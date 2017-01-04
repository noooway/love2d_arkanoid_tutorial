local Gamestate = require "gamestate"
local game = game or require "game"
local love = love
local pairs = pairs
local type = type

local gameover = gameover or {}

if setfenv then
   setfenv(1, gameover)
else
   _ENV = gameover
end

state_name = "gameover"

function gameover:enter( previous_state, ... )
   game_objects = ...
end

function gameover:update( dt )
end

function gameover:draw()
   for _,obj in pairs( game_objects ) do
      if type(obj) == "table" and obj.draw then
	 obj:draw()
      end
   end
   self:cast_shadow()
   love.graphics.print(
      "Game over. Press Enter to continue or Esc to quit",
      50, 50)
end

function gameover:keyreleased( key, code )
   if key == 'return' then      
      Gamestate.switch( game, { level_counter = 1 } )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function gameover:leave()
   game_objects = nil
end

function gameover:cast_shadow()
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 10, 10, 10, 100 )
   love.graphics.rectangle("fill",
			   0,
			   0,
			   love.graphics.getWidth(),
			   love.graphics.getHeight() )
   love.graphics.setColor( r, g, b, a )
end


return gameover
