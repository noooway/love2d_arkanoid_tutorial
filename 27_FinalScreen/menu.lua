local Gamestate = require "gamestate"
local game = game or require "game"
local love = love
local Button = require "Button"
local vector = require "vector"

local menu = menu or {}

if setfenv then
   setfenv(1, menu)
else
   _ENV = menu
end

state_name = "menu"

music = love.audio.newSource( "sounds/music/S31-Night Prowler.ogg" )
music:setLooping( true )

function menu:enter()
   start_button = Button:new{
      text = "New game",
      position = vector( (800 - Button.button_tile_width) / 2, 200),
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
      position = vector( (800 - Button.button_tile_width) / 2, 310),
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
   music:play()
end

function menu:update(dt)
   start_button:update()
   quit_button:update()
end

function menu:draw()
   start_button:draw()
   quit_button:draw()
end

function menu:keyreleased( key, code )
   if key == 'return' then      
      Gamestate.switch( game, { level_counter = 1 } )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function menu:mousereleased( x, y, button )
   if start_button:mousereleased( x, y, button ) then
      Gamestate.switch( game, { level_counter = 1 } )
   elseif quit_button:mousereleased( x, y, button ) then
      love.event.quit()
   end   
end

function menu:leave()
   start_button = nil
   quit_button = nil
end

return menu
