local Gamestate = require "gamestate"
local Button = require "Button"
local vector = require "vector"
local game = game or require "game"
local love = love
local pairs = pairs
local type = type

local gamepaused = gamepaused or {}

if setfenv then
   setfenv(1, gamepaused)
else
   _ENV = gamepaused
end

state_name = "gamepaused"

local right_border_x_pos = 576
local wall_thickness = 34

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 40 )

function gamepaused:enter( previous_state, ... )
   game_objects = ...
end

function gamepaused:update( dt )
end

function gamepaused:draw()
   for _,obj in pairs( game_objects ) do
      if type(obj) == "table" and obj.draw then
	 obj:draw()
      end
   end
   self:cast_shadow()
   
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Game Paused...",
			 108, 110, 400, "center" )
   love.graphics.setFont( oldfont )
end

function gamepaused:keyreleased( key, code )
   if key == 'return' then
      Gamestate.switch( game, game_objects )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function gamepaused:mousereleased( x, y, button )
   if button == 'l' then
      Gamestate.switch( game, game_objects )
   elseif button == 'r' then
      love.event.quit()
   end   
end

function gamepaused:leave()
   game_objects = nil
   play_button = nil
   quit_button = nil
end

function gamepaused:cast_shadow()
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 10, 10, 10, 100 )
   love.graphics.rectangle("fill",
			   0,
			   0,
			   love.window.getWidth(),
			   love.window.getHeight() )
   love.graphics.setColor( r, g, b, a )
end


return gamepaused
