local Gamestate = require "gamestate"
menu = {}
game = {}
local menu = require "menu"
local game = require "game"

function love.load()	
   Gamestate.registerEvents()
   Gamestate.switch( menu )
end
				  
function love.quit()
  print("Thanks for playing! Come back soon!")
end
