local Gamestate = require "gamestate"
menu = {}
game = {}
gamepaused = {}
gamefinished = {}
local menu = require "menu"
local game = require "game"
local gamepaused = require "gamepaused"
local gamefinished = require "gamefinished"

function love.load()	
   Gamestate.registerEvents()
   Gamestate.switch( menu )
end
				  
function love.quit()
  print("Thanks for playing! Come back soon!")
end
