# the purpose of this class is to hold which background tiles go to 
# specific coordinates so that we can modularize different maps

#The MapOne class holds a map which will be drawn by the game panel.
#It holds tiles and their relative coordinates.  It also provides 
#functionality for altering the corner tiles when they are stepped on
#and it also allows for those tiles to be reverted to grass when the 
#flag is picked up again.
class MapOne
  
  def initialize
    
    #each row is a row of tiles
    tiles = Tiles.new
	
    @top_left = tiles.getTile("topLeft")
    @top_right = tiles.getTile("topRight")
    @bottom_left = tiles.getTile("bottomLeft")
    @bottom_right = tiles.getTile("bottomRight")
    @grass = tiles.getTile("grass")
	
    #MAPSIZE = 19 #20 tiles from 0 to 19
    @backgroundTiles = []
      
    for i in 1..MAPSIZE
      @backgroundTiles.push([])
	  
      for j in 1..MAPSIZE
        @backgroundTiles[i-1].push(@grass)
      end
    end
  end
  
  def set_tile(x, y, img)
    @backgroundTiles[x][y] = img
  end
  
  def top_left_pressed
    set_tile(0, 0, @top_left)
  end
  
  def top_right_pressed
	set_tile(MAPSIZE - 1, 0, @top_right)
  end
  
  def bottom_left_pressed
	set_tile(0, MAPSIZE - 1, @bottom_left)
  end
  
  def bottom_right_pressed
    set_tile(MAPSIZE - 1, MAPSIZE - 1, @bottom_right)
  end
  
  #Resets the corners to grass.
  def reset_corners
    set_tile(0, 0, @grass)
    set_tile(MAPSIZE - 1, 0, @grass)
    set_tile(0, MAPSIZE - 1, @grass)
    set_tile(MAPSIZE - 1, MAPSIZE - 1, @grass)
  end
  
  #Returns the tile at i, j
  def getTile(i, j)
    return @backgroundTiles[i][j]
  end
  
end