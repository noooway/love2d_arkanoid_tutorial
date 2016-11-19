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

function gamepaused:enter( previous_state, ... )
   game_objects = ...
   play_button = Button:new{
      text = "Play",
      position = vector(
	 ( right_border_x_pos + wall_thickness - Button.button_tile_width ) / 2,
	 230 ),
      selected = true,
      width = Button.button_tile_width,
      height = Button.button_tile_height,
      quad = love.graphics.newQuad(
	 Button.play_button_tile_x_pos,
	 Button.play_button_tile_y_pos,
	 Button.button_tile_width,
	 Button.button_tile_height,
	 Button.tileset_width,
	 Button.tileset_height ),
      quad_selected = love.graphics.newQuad(
	 Button.play_button_tile_x_pos + Button.selected_x_shift,
	 Button.play_button_tile_y_pos,
	 Button.button_tile_width,
	 Button.button_tile_height,
	 Button.tileset_width,
	 Button.tileset_height )
   }
   quit_button = Button:new {
      text = "Quit",
      position = vector(
	 ( right_border_x_pos + wall_thickness - Button.button_tile_width ) / 2,
	 340),
      width = Button.button_tile_width,
      height = Button.button_tile_height,
      quad = love.graphics.newQuad(
	 Button.quit_button_tile_x_pos,
	 Button.quit_button_tile_y_pos,
	 Button.button_tile_width,
	 Button.button_tile_height,
	 Button.tileset_width,
	 Button.tileset_height ),
      quad_selected = love.graphics.newQuad(
	 Button.quit_button_tile_x_pos + Button.selected_x_shift,
	 Button.quit_button_tile_y_pos,
	 Button.button_tile_width,
	 Button.button_tile_height,
	 Button.tileset_width,
	 Button.tileset_height )
   }
end

function gamepaused:update( dt )
   play_button:update()
   quit_button:update()
end

function gamepaused:draw()
   for _,obj in pairs( game_objects ) do
      if type(obj) == "table" and obj.draw then
	 obj:draw()
      end
   end
   self:cast_shadow()
   play_button:draw()
   quit_button:draw()
end

function gamepaused:keyreleased( key, code )
   if key == 'return' then      
      Gamestate.switch( game, game_objects )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function gamepaused:mousereleased( x, y, button )
   if play_button:mousereleased( x, y, button ) then
      Gamestate.switch( game, game_objects )
   elseif quit_button:mousereleased( x, y, button ) then
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
