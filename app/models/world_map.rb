class WorldMap < ActiveRecord::Base

  require 'oily_png'

  MAP_DIRECTORY = "app/assets/images/"
  #MAPLOCATION = "world_map.png"
  #<%= image_tag('viewed.png', :title => 'You have watched this episode ('+season.season_number.to_s+'-'+episode.number.to_s+')') if @episode_union.index(episode.id) %>

  IMAGE_MAP = {
      395452671 => "forest.png",
      653211135 => "grass.png",
      1972306175 => "hill.png",
      3533648383 => "hill.png",
      2341436415 => "mountain.png",
      3623107071 => "path.png",
      8895999 => "sea.png",
      11779583 => "shallow.png",
      532753407 => "shrub.png",
      3126618367 => "swamp.png",
      10337791 => "water.png",
      0 => "void.png"
  }

  # So, my impending implementation is NOT threadsafe.  Fix it using this:
  # http://m.onkey.org/thread-safety-for-your-rails
  # I didn't want to be bothered at the moment, and wanted to be able to
  # wander my wonderland.
  # Stores # -> "image.png"
  @@TILE_TO_IMAGE = {}
  # Stores "image.png" -> #
  @@IMAGE_TO_TILE = {}
  # Stores low-tile-values in large x##y## hash
  @@REVEALED_MAP = {}

  # The following is a class variable, it should only be read from, as it is NOT thread safe
  # but will prevent the need of reloading it or loading multiple instances of it.
  # Caleb, sign here if you agree with the above statement: _________________ (Seriously, do it)
  @@greg_world_map = ChunkyPNG::Image.from_file("#{MAP_DIRECTORY}world_map.png")

  def image_array(radius, xcoord, ycoord)
    # Sets default to zero, which should result in a "Void" space (ex: Edge regions and unknown)
    result= Hash.new(0)
    for x in xcoord-radius..xcoord+radius
      for y in ycoord-radius..ycoord+radius
        if y.between?(-1, @@greg_world_map.height) && x.between?(-1, @@greg_world_map.width)
          #puts "y: #{y} vs. #{@@greg_world_map.height} and x: #{x} vs #{@@greg_world_map.width}"
          pixel = @@greg_world_map.get_pixel(x,y)

          result["#{x},#{y}"] = pixel if IMAGE_MAP[pixel]
          puts "Pixel value: #{pixel} not found!" if !IMAGE_MAP[pixel]
        #else #no need, default is 0
        else
          puts "!!! NOT FOUND !!! -> y: #{y} vs. #{@@greg_world_map.height} and x: #{x} vs #{@@greg_world_map.width}"
        end
      end
    end
    #puts result
    result
  end

  def get_image(xcoord, ycoord)
    initialize_simple_reference if @@TILE_TO_IMAGE.empty?
    coord_string = "x#{xcoord}y#{ycoord}"
    return @@TILE_TO_IMAGE[@@REVEALED_MAP[coord_string]] if @@REVEALED_MAP[coord_string]
    if ycoord.between?(-1, @@greg_world_map.height) && xcoord.between?(-1, @@greg_world_map.width)
      this_image = IMAGE_MAP[@@greg_world_map.get_pixel(xcoord,ycoord)]
      @@REVEALED_MAP[coord_string] = @@IMAGE_TO_TILE[this_image]
    else # IMAGE_MAP[@@greg_world_map.get_pixel(x,y)]
      @@REVEALED_MAP["x#{xcoord}y#{ycoord}"] = @@IMAGE_TO_TILE["void.png"]
    end
    puts @@TILE_TO_IMAGE.inspect
    puts @@REVEALED_MAP.inspect
    puts @@TILE_TO_IMAGE[@@REVEALED_MAP[coord_string]]
    return @@TILE_TO_IMAGE[@@REVEALED_MAP[coord_string]]
  end

  # This should be done as part of the initialization of the server
  def initialize_simple_reference
    starting_point = 0
    IMAGE_MAP.each_pair do |k,v|
      # Assign small digits to the various tiles
      @@TILE_TO_IMAGE[starting_point+=1] = v
      # Reverse lookup to store references as map is revealed
      @@IMAGE_TO_TILE[v] = starting_point unless @@IMAGE_TO_TILE[v]
    end
  end

end
