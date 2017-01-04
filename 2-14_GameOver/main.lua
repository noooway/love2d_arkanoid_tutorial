local Gamestate = require "gamestate"
menu = {}
game = {}
gamepaused = {}
gamefinished = {}
gameover = {}
local menu = require "menu"
local game = require "game"
local gamepaused = require "gamepaused"
local gamefinished = require "gamefinished"
local gameover = require "gameover"

function love.load()
   local love_window_width = 800
   local love_window_height = 600
   love.window.setMode( love_window_width,
                        love_window_height,
                        { fullscreen = false } )
   Gamestate.registerEvents()
   Gamestate.switch( menu )
end
				  
function love.quit()
  print("Thanks for playing! Come back soon!")
end
