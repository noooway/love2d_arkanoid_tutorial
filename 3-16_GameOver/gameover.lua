local Gamestate = require "gamestate"
local Button = require "Button"
local vector = require "vector"
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

local right_border_x_pos = 576
local wall_thickness = 34

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 40 )

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
   
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Game Over!",
			 158, 110, 300, "center" )
   love.graphics.setFont( oldfont )
end

function gameover:keyreleased( key, code )
   if key == 'return' then
      Gamestate.switch( game, { level_counter = 1 } )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function gameover:mousereleased( x, y, button )
   if button == 'l' then
      Gamestate.switch( game, { level_counter = 1 } )
   elseif button == 'r' then
      love.event.quit()
   end   
end

function gameover:leave()
   game_objects = nil
   play_button = nil
   quit_button = nil
end

function gameover:cast_shadow()
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 10, 10, 10, 180 )
   love.graphics.rectangle("fill",
			   0,
			   0,
			   love.graphics.getWidth(),
			   love.graphics.getHeight() )
   love.graphics.setColor( r, g, b, a )
end


return gameover
