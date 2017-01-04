local Gamestate = require "gamestate"
local game = require "game"
local love = love

local menu = menu or {}

if setfenv then
   setfenv(1, menu)
else
   _ENV = menu
end

state_name = "menu"

function menu:enter()
end

function menu:update( dt )
end

function menu:draw()
   love.graphics.print("Menu gamestate. Press Enter to continue.", 280, 250)
end

function menu:keyreleased( key, code )
   if key == 'return' then      
      Gamestate.switch( game )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function menu:leave()
end

return menu