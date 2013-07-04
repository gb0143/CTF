require "wx"
include Wx
require "src/tiles"

MAPSIZE = 20

#A Player holds a player's location, moves their avatar, keeps track
#of whether they hold the flag or not, and keeps track of which tiles
#they have been to.
class Player
  # Creates a new Player object
  # param id -- int used as playerID
  # param img -- Image used as player icon
  # param pt -- Point used as current location of player on map
  def initialize(id, pt)
    tiles = Tiles.new
    @playerID = id
    @icon = tiles.getObject("player" + id.to_s())
    @currentLocation = pt
    @hasFlag = false
    @mostRecentLocation = @currentLocation
    @cornersVisited = Array.new(0, nil)
    @update = true #if they need to be redrawn
  end
  
  def getPlayerID
    return @playerID
  end
  
  def setUpdate(boolean)
    @update = boolean
  end
  
  def getUpdate
    return @update
  end
  
  #return bitmap
  def getIcon
    return @icon
  end
  
  # accessor
  def get_current_location()
    return @currentLocation
  end
  
  # accessor
  def get_icon()
    return @icon
  end
  
  # accessor
  def has_flag()
    return @hasFlag
  end
  
  # accessor
  def get_most_recent_location()
    return @mostRecentLocation
  end
  
  # simulates the player picking up the flag
  def pick_up_flag()
    @hasFlag = true
  end
  
  # simulates the player moving to a new location
  # param newPt - the new location
  def move(newPt, flag)
    # check to make sure the parameter does not have
    # negative components
    if (newPt.x >= 0) and (newPt.y >= 0)
	  #@pastRecentLocation = @mostRecentLocation
      @mostRecentLocation = @currentLocation
      @currentLocation = newPt
	  
      # move the flag's position when the player moves
  	  if (has_flag)
  	    flag.move(@mostRecentLocation)
  	    flag.setUpdate(true)
  	  end     
    end
  end

  # simulates the player visiting a specific corner
  # returns true if the cornerNum is added
  # returns false if the cornerNum is already in the array
  def visit_corner(cornerNum)
    # iterate through the array to search for cornerNum
    @cornersVisited.each {
      |c|
      if (c == cornerNum)
        return false
      end
    }
    
    # add the cornerNum to the array and return true
    @cornersVisited = @cornersVisited + [ cornerNum ]
    return true      
  end

  # returns true if the user has visited three corners
  def has_visited_three_corners
    # checks the length of the corners visited array
    if @cornersVisited.length == 3
      return true
	end
	  
	return false
  end
  
  # simulates the player's flag being taken
  def tag()
    @hasFlag = false
    @cornersVisited = []
  end
  
end

#p1 = Player.new(1, Image.new("player1.png"),  Point.new(0,0))
#puts p1.inspect
