require "wx"
include Wx
require "src/tiles"
require "src/player"
require "src/game"
require "src/map"

#MAPSIZE = 20

#The GamePanel class holds a Map (which is the background) and draws it
#It also has control of the MediaCtrl for playing the music.
class GamePanel < Panel
  def initialize(parent, game)
    super(parent, :style => Wx::TAB_TRAVERSAL|Wx::CLIP_CHILDREN)
    evt_paint { on_paint }
	
	@mc = Wx::MediaCtrl.new(self)
	evt_media_loaded @mc,:play_song

	#for accessing the game's map
	@game = game
	
	#for redrawing panel on evt_paint
	@p1 = game.getP1
	@p2 = game.getP2
	@flag = game.getFlag
	
	@map = @game.get_map
	puts "end panel constructor"
  end
  
  #when there is a new game we get a new game object which is stock full
  #of variables.
  def new_game(game)
    @game = game
	@p1 = game.getP1
	@p2 = game.getP2
	@flag = game.getFlag
	@map = @game.get_map
	update_background
	draw_all_objects
  end
  
  def on_paint
    puts "on_paint"
    update_background
    #having these threads draw them on is very hacky but it works.
    draw_all_objects
  end
  
  def draw_all_objects
    #sleep(0.005)
    Thread.new {
	  draw_object(@flag, true)
	  draw_object(@p1, true)
	  draw_object(@p2, true)
	  }
  end
  
  def draw_win_message(i)
    tiles = Tiles.new
    if not (i == 1 or i == 2)
	  return
	end
	
	paint do | dc |
	  dc.draw_bitmap(tiles.getMessage(i), 150, 250, true)
	end
  end
  
  def drawToTile(paintObj, img, x, y, transparent)
    paintObj.draw_bitmap(img, x * 32, y * 32, transparent)
  end
  
  def redraw_corners
    mp = MAPSIZE - 1
    
    paint do | dc |
      dc.draw_bitmap(@map.getTile(0, 0), 0 * 32, 0 * 32, false)
      dc.draw_bitmap(@map.getTile(0, mp), 0 * 32, mp * 32, false)
      dc.draw_bitmap(@map.getTile(mp, 0), mp * 32, 0 * 32, false)
      dc.draw_bitmap(@map.getTile(mp, mp), mp * 32, mp * 32, false)
    end
    
    #update_background
    
    #draw objects over background
	draw_all_objects 
  end
  
  def update_background
    paint do | dc |
      dc.clear
      
      #background tiles will have transparency false.
      for i in 0..(MAPSIZE-1)
        for j in 0..(MAPSIZE-1)
          self.drawToTile(dc, @map.getTile(i, j), i, j, false)
        end
      end
    end
  end
  
  #draws either a player or a flag
  def draw_object(object, tail)
    loc = object.get_current_location
    rcnt = object.get_most_recent_location

    paint do | dc |
      if (tail)
        self.drawToTile(dc, @map.getTile(rcnt.x, rcnt.y), rcnt.x, rcnt.y, false)
        self.drawToTile(dc, @map.getTile(loc.x, loc.y), loc.x, loc.y, false)
      end
      self.drawToTile(dc, object.getIcon, loc.x, loc.y, true)
    end
  end
  
  def get_song(name)
    return "./res/music/" + name + ".mid"
  end
  
  def load_song
    location = [get_song("four"), get_song("three")].sample
    @mc.load(location)
  end
  
  def play_song
    if not @mc.play
	  puts "cannot play song"
	end
  end
end

class GameFrame < Frame
  def initialize(game)
    super(nil, :title=>"Capture the Flag", :size=>[656, 676])
    @win = GamePanel.new(self, game)
    @game = game

    self.centre()
    self.show()
    @win.load_song
	
	Thread.new {
	  sleep(1.5)
	  @win.play_song
	}
  end
  
  def draw_win_message(i)
    @win.draw_win_message(i)
  end
  
  def play_song
    @win.play_song
  end
  
  def draw_object(object, tail)
    @win.draw_object(object, tail)
  end
  
  def update_background
    @win.update_background
  end
  
  def redraw_corners
    @win.redraw_corners
  end

  def getKeyPress(event)
    keyCode = event.get_key_code
    @game.input(keyCode)
  end
  
  def set_game_reference(game)
    @game = game
	#@win = GamePanel.new(self, game)
	@win.new_game(game)
  end
end

#class HelpPanel < Panel
#  def initialize(parent)
#    super(parent, :style => Wx::TAB_TRAVERSAL|Wx::CLIP_CHILDREN)
#    evt_paint { on_paint }
#  end
#  
#  def on_paint
#    tiles = Tiles.new
#    paint do | dc |
#	  dc.draw_bitmap(tiles.get_how_to_play, 0, 0, true)
#	end
#  end#
#
#end

#class HelpFrame < Frame
#  def initialize
#    super(nil, -1, "Capture the Flag -- Help", DEFAULT_POSITION,#
#	        Size.new(656, 676), DEFAULT_FRAME_STYLE, "frameName")
#	@win = HelpPanel.new(nil)
#	self.centre()
#	self.show()
#  end
#end

# Defines the main menu frame used for the game
class MainMenuFrame < Frame
  def initialize(appReference)
    super(nil, -1, "Capture the Flag -- Main Menu", DEFAULT_POSITION,
         	Size.new(656, 676), DEFAULT_FRAME_STYLE, "frameName")
    
	#for telling the app to make a new game frame
	@app = appReference
    
    self.centre()
    self.display_main_menu()
                                                    
    self.show()
  end
  
  def display_main_menu
    # change the background color
    self.set_background_colour(BLACK)
    
    # get the initial height of the panel
    initialHeight = self.get_size().get_height() / 2
        
    # create a panel to hold the buttons
    btnPanel = Panel.new(self, -1, Point.new(0, initialHeight), 
      Size.new(self.get_size().get_width(), initialHeight), TAB_TRAVERSAL, "btnPanel")
    btnPanel.set_background_colour(BLACK)
    
    # get the width of the frame to use for the width of the buttons
    frameWidth = self.get_size().get_width() - 15
    
    # create main menu title
    title = StaticText.new(btnPanel, -1, "Capture the Flag", Point.new(205,100), 
      DEFAULT_SIZE, 0, "lblTitle")
    title.set_font(MainMenuFont.new())
    title.set_foreground_colour(WHITE)
    
    # create buttons
    btnNewGame = MainMenuButton.new(btnPanel, ID_ANY, "btnNewGame", Point.new(0, initialHeight), 
      Size.new(frameWidth, 50), 0, DEFAULT_VALIDATOR, "New Game")
                            
    #btnOptions = MainMenuButton.new(btnPanel, ID_ANY, "btnOptions", Point.new(0, (initialHeight + 50)), 
      #Size.new(frameWidth, 50), 0, DEFAULT_VALIDATOR, "Options")
                            
    btnHelp = MainMenuButton.new(btnPanel, ID_ANY, "btnHelp", Point.new(0, (initialHeight + 100)), 
      Size.new(frameWidth, 50), 0, DEFAULT_VALIDATOR, "Help")
      
    # create button listeners
    evt_button(btnNewGame) { 
      @app.make_first_game
      #@game.set_frame_reference(frame)
    }
	
	#evt_button(btnHelp) {
	  #HelpFrame.new.show()  
	#}
  end
end

# Defines the buttons used in the main menu
class MainMenuButton < Button
  def initialize(parent, id, label, pos, size, style, validator, name)
    super(parent, id, name, pos, size, style, validator, name)
    
    # set colors
    self.set_background_colour(BLUE)
    self.set_foreground_colour(WHITE)
    self.set_font(MainMenuFont.new())
  end
end

# Defines the font used on the buttons and label in the main menu
class MainMenuFont < Font
  def initialize()
    super(20, FONTFAMILY_SWISS, FONTSTYLE_NORMAL, FONTWEIGHT_BOLD, false, "", FONTENCODING_DEFAULT)
  end
end

#The 
class MinimalApp < App
  def on_init
    #@game = Game.new
    @menu_frame = MainMenuFrame.new(self)
    #@frame = GameFrame.new(@game)
    #@frame.show()
	
    self.evt_key_up() { 
	  |event| getKeyPress(event) 
	  if (@game.get_game_over)
	    sleep(5)
	    make_new_game
	  end
	}
    #  @frame.play_song	}
    #make_first_game
  end
  
  #when the main menu creates a new game the frame is controlled from
  #here
  def set_game_frame(frame)
    @frame = frame
  end
  
  def make_first_game
    @game = Game.new
    @frame = GameFrame.new(@game)
	@game.set_frame_reference(@frame)
    @frame.show()
  end
  
  def make_new_game
    @game = Game.new
	@frame.set_game_reference(@game)
	@game.set_frame_reference(@frame)
  end
  
  def getKeyPress(event)
    keyCode = event.get_key_code
    @game.input(keyCode)
  end
end

MinimalApp.new.main_loop