require "wx"
include Wx
require "src/tiles"

#The flag is the main game token which is taken by a player around the
#map.  If they player takes the flag to three of the four corners,
#they win the game
class Flag
  def initialize
    tiles = Tiles.new
    @icon = tiles.getObject("flag")
    @currentLocation = Point.new(10, 10)
    @mostRecentLocation = @currentLocation
    @update = true
    @which_player = nil
  end
  
  #update which player has the flag
  def set_player(player)
    @which_player = player
  end
  
  def setUpdate(boolean)
    @update = boolean
  end
  
  def getUpdate
    return @update
  end
  
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
  
  def set_most_recent_location(playersRecent)
    @mostRecentLocation = playersRecent
  end
  
  # simulates the player picking up the flag
  def pick_up_flag()
    @hasFlag = true
  end
  
  # simulates the player moving to a new location
  # param newPt - the new location
  def move(newPt)
    
    # check to make sure the parameter does not have
    # negative components
    if (newPt.x >= 0) and (newPt.y >= 0)
      
      # update the recent location from the current
      @mostRecentLocation = @currentLocation
      
      # change the current
      @currentLocation = newPt
    end
  end
end