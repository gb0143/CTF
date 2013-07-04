require "wx"
include Wx
require "src/player"
require "src/flag"
require "src/map"

#MAPSIZE = 20

#The game class holds all of the game logic.  It deals with the input
#from the player, determines valid player movements, determines 
#collisions, ends the game if a player has been to all four corners,
#and it draws the players and flags when they have moved.
class Game
	def initialize
		@p1 = Player.new(1, Point.new(0,0))
		@p2 = Player.new(2, Point.new(19,19))
		@flag = Flag.new
		@who_has_flag = nil
		
		@map = MapOne.new
		
		@game_over = false
	end
	
	def get_game_over
	  return @game_over
	end
	
	def set_game_over(boolean)
	  @game_over = boolean
	end
	
	def get_map
	  return @map
	end
	
	#The frame reference is for calling drawing functions
	def set_frame_reference(frame_ref)
	  @frame_reference = frame_ref
	  #draw_all
	end
	
	def draw_all
	  draw_object(@p1)
	  draw_object(@p2)
	  draw_object(@flag)
	end
	
	def redraw_corners
	  @frame_reference.redraw_corners
	end
	
	#draw the object.  If tail is true, it colors over their previous
	# location.  If false, it does not (false if they have the flag)
	def draw_object(obj, tail)
	  @frame_reference.draw_object(obj, tail)
	end
	
	def getP1
	  return @p1
	end
  
	def getP2
	  return @p2
	end
	
	def getFlag
	  return @flag
	end
	
	#first see if the player is on a corner, then change game state
	def corner_handler
	  point = @who_has_flag.get_current_location
      pointArr = [point.x, point.y]
	
	  #see if player is standing on corner
	  corner_num = corner_number(pointArr)
	  #puts corner_num
	
	  if corner_num != -1
	  #if they are on a corner, update it if they haven't been there.
	    @who_has_flag.visit_corner(corner_num)
      end
	  
	  if corner_num == 0
	    @map.top_left_pressed
	  elsif corner_num == 1
	    @map.top_right_pressed
	  elsif corner_num == 2
	    @map.bottom_left_pressed
	  elsif corner_num == 3
	    @map.bottom_right_pressed
	  end
	  
	  if @who_has_flag.has_visited_three_corners == true
	    @game_over = true
		@frame_reference.draw_win_message(@who_has_flag.getPlayerID)
      end
    end
	
	#calculate the number of the corner
	def corner_number(pointArr)
      if pointArr == [0, 0]
	    return 0
	  elsif pointArr == [MAPSIZE - 1, 0]
	    return 1
	  elsif pointArr == [0, MAPSIZE - 1]
	    return 2
	  elsif pointArr == [MAPSIZE - 1, MAPSIZE - 1]
	    return 3
	  else
	    return -1
	  end
    end
	
	#When a player stands on the flag they grab it.
	def change_flag_ownership
	  if (@who_has_flag == @p1)
	    @p2.tag
		@flag.set_most_recent_location(@p1.get_most_recent_location)
      else
	    @p1.tag
		@flag.set_most_recent_location(@p2.get_most_recent_location)
	  end
	  @map.reset_corners
	  redraw_corners
	end
	
	#Is the player standing on the flag?
	def flagOverlap(player)
	  if (player.get_current_location == @flag.get_current_location)
	    player.pick_up_flag
		@who_has_flag = player
		change_flag_ownership
	  end
	end
	#return true if the map needs to be updated, else false
	#def getUpdate
	#  return @update
	#end
	
	#def setUpdate(boolean)
	#  @update = boolean
	#end
	
	#see if the players are on the same spot.
	def overlap(p1Point, p2Point)
	  if p1Point == p2Point
	    return true
	  end
	  return false
	end
	
	#move player and see if they are standing on flag
	# also check to see if they are at one of the corners
	def playerUpdate(player, newLoc)
	  player.move(Point.new(newLoc[0], newLoc[1]), getFlag)
	  #player.setUpdate(true)
	  
	  #If the player is standing on the flag, take it.
	  flagOverlap(player)
	  
	  #If the player has the flag then first the flag needs to be drawn
	  #then the player will be drawn without their tail since that is
	  # where their flag is.  If the tail was drawn the flag would be
	  # covered.
	  if (player.has_flag)
	    draw_object(@flag, true)
	    draw_object(player, false)
	  else
        draw_object(player, true)
	  end
	  
	  if (player == @who_has_flag)
	    corner_handler
	  end
	end
	
	#Take in a key value from the key event in the App and process it.
	def input(value)
		p1Location = @p1.get_current_location()
		p2Location = @p2.get_current_location()
		#for checking overlap
		p1Array = [p1Location.x, p1Location.y]
		p2Array = [p2Location.x, p2Location.y]
		
		if(value == ?W.ord and p1Location.y > 0)
			newLoc = [p1Location.x, p1Location.y - 1]
			if not overlap(newLoc, p2Array)
				playerUpdate(@p1, newLoc)
			end
		elsif(value == ?S.ord and p1Location.y < MAPSIZE - 1)
			newLoc = [p1Location.x, p1Location.y + 1]
			if not overlap(newLoc, p2Array)
				playerUpdate(@p1, newLoc)
			end
		elsif(value == ?A.ord and p1Location.x > 0)
			newLoc = [p1Location.x - 1, p1Location.y]
			if not overlap(newLoc, p2Array)
				playerUpdate(@p1, newLoc)
			end
		elsif(value == ?D.ord and p1Location.x < MAPSIZE - 1)
			newLoc = [p1Location.x + 1, p1Location.y]
			if not overlap(newLoc, p2Array)
				playerUpdate(@p1, newLoc)
			end
		elsif(value == K_UP and p2Location.y > 0)
			newLoc = [p2Location.x, p2Location.y - 1]
			if not overlap(newLoc, p1Array)        			  
				playerUpdate(@p2, newLoc)
			end
		elsif(value == K_DOWN and p2Location.y < MAPSIZE - 1)
			newLoc = [p2Location.x, p2Location.y + 1]
			if not overlap(newLoc, p1Array)
				playerUpdate(@p2, newLoc)
			end
		elsif(value == K_LEFT and p2Location.x > 0)
			newLoc = [p2Location.x - 1, p2Location.y]
			if not overlap(newLoc, p1Array)
				playerUpdate(@p2, newLoc)
			end
		elsif(value == K_RIGHT and p2Location.x < MAPSIZE - 1)
			newLoc = [p2Location.x + 1, p2Location.y]
			if not overlap(newLoc, p1Array)
				playerUpdate(@p2, newLoc)
			end
		end
	end
	
	#Checks to see if the flag should be transferred.
	def checkGame(p)
		if(@p1.hasFlag() and @p2.get_current_location() == @p1.getFlagLocation())
			@p1.tag()
			@p2.pick_up_flag()
		elsif(p2.hasFlag() and p1.get_current_location() == p2.get_most_recent_location())
			@p2.tag()
			@p1.pick_up_flag()
		end
		
		# !!! get_num_corneres_visited() returns the number of corneres visited
		# if 3 corners were visited
		if(P.get_num_Corners_Visited() == 3)
			#!!! code to make game over with @P winning...what should I do for this?
		end
	end
	
end

#if __FILE__ == $0
#  game = Game.new
#end