#!/usr/bin/python

import boto3
""" Import botocore for Error handling """
import botocore
import json

sqs = boto3.resource('sqs')
s3 = boto3.resource('s3')
ec2 = boto3.resource('ec2')

DEBUG = True
VERBOSE = not False
fileName = None
jenkinsBucket = "gts-jenkins"
infrastructureQueue = "Infrastructure-Maestro-Queue"

""" Helper method for conditional logging (ex: DEBUG and VERBOSE) """
def logger(condition, string):
    if condition:
       print(string)

""" JSON Pretty Printing """
def prettyPrint(condition, labelString, stringToPretty):
    if not condition:
        return
    parsed = json.loads(stringToPretty)
    print(labelString.format(json.dumps(parsed,indent=3)))

def make_tag_dict(ec2_object):
    """Given an tagable ec2_object, return dictionary of existing tags."""
    tag_dict = {}
    if ec2_object.tags is None: return tag_dict
    for tag in ec2_object.tags:
        tag_dict[tag['Key']] = tag['Value']
    return tag_dict

def main():
    fileName = getFileNameFromQueue(infrastructureQueue)
    if not fileName:
        print("!!!\tfileName not assigned.")
        return
    metaTags=getMetaTags(fileName)
    if not metaTags:
        print("!!!\tMetaData tags not found.")
        return
    print("Found metaData: %s"%metaTags)
    instance=getInstances(metaTags['buildinfo'])

def getFileNameFromQueue(queueName):
    queue = sqs.get_queue_by_name(QueueName=queueName)
    prettyPrint(VERBOSE,"INFO: Queue Attributes\n{0}\n",str(queue.attributes).replace("\"","?@?").replace("\'","\"").replace("?@?","\'"))
    logger(VERBOSE,"INFO: Queue Url:\n%s\n"%(queue.url))
    for message in queue.receive_messages(MessageAttributeNames=['Author']):
        """ Get the custom author message attribute if it was set """
        if message.message_attributes is not None:
            author_name = message.message_attributes.get('Author').get('StringValue')
            if author_name:
                author_text = ' ({0})'.format(author_name)
                print(author_text)
            prettyPrint("Message: {0}",str(message.body))
        try:
            fileName = json.loads(message.body)['Records'][0]['s3']['object']['key']
            logger(VERBOSE,"INFO: Found message regarding %s"%fileName)
            return fileName
        except KeyError as e:
            print("***\tError when retrieving object key: %s"%e)
            return None


def getMetaTags(fileToFind):
    print("Retrieving MetaTags for %s"%fileToFind)
    foundObject = s3.Object(jenkinsBucket,fileToFind)
    try:
        objectTwo = foundObject.get()
        print("***\tFound: %s "%foundObject)
        return foundObject.metadata
    except botocore.exceptions.ClientError as e:
        print("!!!\tError when retrieving %s\n!!!\t%s"%(fileToFind,e))
        return None

def getInstances(buildInfo):
    logger(VERBOSE,"INFO: Searching instances for %s"%buildInfo)
    instances = ec2.instances.filter(
        Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    noBuildInfo = []
    retInstances = []
    for instance in instances:
        tags = make_tag_dict(instance)
        if tags.get('BuildInfo'):
            logger(VERBOSE,"\tINFO:Checking %s..." % tags.get('Name'))
#            print "ID:\t%s\tType:\t%s" % (instance.id, instance.instance_type )
            if tags.get('BuildInfo') == buildInfo:
                logger(VERBOSE,"\tINFO:\tMatched buildInfo for %s (%s)"%(tags.get('Name' ),instance.id))
                retInstances.append(instance)
        else:
            noBuildInfo.append(tags.get('Name'))
    if (len(noBuildInfo) > 0):
        logger(VERBOSE,"INFO: The following instances have no buildinfo:\n\t%s"%noBuildInfo)
    logger(VERBOSE,"INFO: Returning instance(s) %s"%retInstances)
    return retInstances


main()
