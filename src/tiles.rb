#The tiles class holds three Hashes of string to WxRuby bitmap objects
#so the map can easily deal with drawing and storing these tiles.
#This class provides a method for loading a tile from the res folder.
class Tiles
  #create hash with all of the tiles in it for easy access
  
  def initialize
    @tileset = {"grass" => createBitmap("grass.png"),
                "topLeft" => createBitmap("topLeft.png"),
                 "topRight" => createBitmap("topRight.png"),
                 "bottomLeft" => createBitmap("bottomLeft.png"),
                 "bottomRight" => createBitmap("bottomRight.png")}
                 
    #players and the flag
    @objects = {"player1" => createBitmap("player1.png"),
                "player2" => createBitmap("player3.png"),
                "flag" => createBitmap("flag.png")}
				      
    @message = {"playerOneWin" => createBitmap("playerOneWin.png"),
                "playerTwoWin" => createBitmap("playerTwoWin.png")}
	
	#@howToPlay = createBitmap("howToPlay.png")
  end
  
  #def getHowToPlay
  #  return @howToPlay
  #end
  
  #Return a tile from the hash based on its key
  def getTile(name)
    return @tileset[name]
  end
  
  def getObject(name)
    return @objects[name]
  end
  
  def getMessage(m)
    if m == 1
	  return @message["playerOneWin"]
	elsif m == 2
	  return @message["playerTwoWin"]
	end
  end
  
  #Create a bitmap of the file based upon its name, if it exists in res/
  # note: no error checking
  def createBitmap(name)
    return Wx::Bitmap.new(Wx::Image.new(File.expand_path("res/img/" + name)))
  end
end