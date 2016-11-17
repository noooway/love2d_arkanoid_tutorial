local Gamestate = require "gamestate"
local game = game or require "game"
local love = love

local gamefinished = gamefinished or {}

if setfenv then
   setfenv(1, gamefinished)
else
   _ENV = gamefinished
end

state_name = "gamefinished"

function gamefinished:enter()
end

function gamefinished:update( dt )
end

function gamefinished:draw()
   love.graphics.print(
      "Congratulations, you have finished the game.\n" ..
	 "Press Enter to restart or Esc to quit",
      10, 10)
end

function gamefinished:keyreleased( key, code )
   if key == 'return' then      
      Gamestate.switch( game, { level_counter = 1 } )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function gamefinished:leave()
end

return gamefinished
