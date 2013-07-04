require "wx"
include Wx

class TestFrame < Frame
  
  def initialize
    super(nil, -1, "Press Arrow Keys")
    self.show()
  end
 
end

class GameApp < App
  
  def on_init
    
    TestFrame.new
    
    self.evt_key_down() { |event| displayButtonName(event) }
    
  end
    
  def displayButtonName(event)
    
    keyCode = event.get_key_code 
    
    if keyCode == 314
      puts "Left"
    elsif keyCode == 315
      puts "Up"
    elsif keyCode == 316
        puts "Right"
    elsif keyCode == 317
        puts "Down"
    end
    
  end
  
end

GameApp.new.main_loop