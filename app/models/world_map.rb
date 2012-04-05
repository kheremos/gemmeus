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

end
