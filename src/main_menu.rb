require "wx"
include Wx

# Defines the main menu frame used for the game
class MainMenuFrame < Frame
  
  def initialize()
    
    super(nil, -1, "Capture the Flag -- Main Menu")
    
    # center the window horizontally & vertically
    self.centre(BOTH)
    
    # change the background color
    self.set_background_colour(BLACK)
    
    # get the initial height of the panel
    @initialHeight = self.get_size().get_height() / 2
        
    # create a panel to hold the buttons
    @btnPanel = Panel.new(self, -1, Point.new(0, @initialHeight), 
      Size.new(self.get_size().get_width(), @initialHeight), TAB_TRAVERSAL, "btnPanel")
    @btnPanel.set_background_colour(BLACK)
    
    # get the width of the frame to use for the width of the buttons
    @frameWidth = self.get_size().get_width() - 15
    
    # create main menu title
    @title = StaticText.new(@btnPanel, -1, "Capture the Flag", Point.new(80, 100), 
      DEFAULT_SIZE, ALIGN_CENTRE, "lblTitle")
    @title.set_font(MainMenuFont.new())
    @title.set_foreground_colour(WHITE)
    
    # create buttons
    @btnNewGame = MainMenuButton.new(@btnPanel, ID_ANY, "btnNewGame", Point.new(0, @initialHeight), 
      Size.new(@frameWidth, 50), 0, DEFAULT_VALIDATOR, "New Game")
                            
    @btnOptions = MainMenuButton.new(@btnPanel, ID_ANY, "btnOptions", Point.new(0, (@initialHeight + 50)), 
      Size.new(@frameWidth, 50), 0, DEFAULT_VALIDATOR, "Options")
                            
    @btnHelp = MainMenuButton.new(@btnPanel, ID_ANY, "btnHelp", Point.new(0, (@initialHeight + 100)), 
      Size.new(@frameWidth, 50), 0, DEFAULT_VALIDATOR, "Help")
                                                    
    self.show()
    
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
      
    evt_button(self) { puts self.get_label }
    
  end
  
end

# Defines the font used on the buttons and label in the main menu
class MainMenuFont < Font
  
  def initialize()
    
    super(20, FONTFAMILY_SWISS, FONTSTYLE_NORMAL, FONTWEIGHT_BOLD, false, "", FONTENCODING_DEFAULT)
    
  end
  
end

class GameApp < App
  
  def on_init
    
    # create main menu frame
    MainMenuFrame.new
    
  end
  
end

GameApp.new.main_loop