local Gamestate = require "gamestate"
local menu = require "menu"

function love.load()	
   Gamestate.registerEvents()
   Gamestate.switch( menu )
end
				  
function love.quit()
  print("Thanks for playing! Come back soon!")
end
