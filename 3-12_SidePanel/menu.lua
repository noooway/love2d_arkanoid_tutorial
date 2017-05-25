local vector = require "vector"
local buttons = require "buttons"

local menu = {}

local menu_buttons_image = love.graphics.newImage( "img/800x600/buttons.png" )
local button_tile_width = 128
local button_tile_height = 64
local play_button_tile_x_pos = 0
local play_button_tile_y_pos = 0
local quit_button_tile_x_pos = 0
local quit_button_tile_y_pos = 64
local selected_x_shift = 128
local tileset_width = 256
local tileset_height = 128
local play_button_quad = love.graphics.newQuad(
   play_button_tile_x_pos,
   play_button_tile_y_pos,
   button_tile_width,
   button_tile_height,
   tileset_width,
   tileset_height )
local play_button_selected_quad = love.graphics.newQuad(
   play_button_tile_x_pos + selected_x_shift,
   play_button_tile_y_pos,
   button_tile_width,
   button_tile_height,
   tileset_width,
   tileset_height )
local quit_button_quad = love.graphics.newQuad(
   quit_button_tile_x_pos,
   quit_button_tile_y_pos,
   button_tile_width,
   button_tile_height,
   tileset_width,
   tileset_height )
local quit_button_selected_quad = love.graphics.newQuad(
   quit_button_tile_x_pos + selected_x_shift,
   quit_button_tile_y_pos,
   button_tile_width,
   button_tile_height,
   tileset_width,
   tileset_height )

local start_button = {}
local quit_button = {}

function menu.load( prev_state, ... )
   start_button = buttons.new_button{
      text = "New game",
      position = vector( (800 - button_tile_width) / 2, 200),
      width = button_tile_width,
      height = button_tile_height,
      image = menu_buttons_image,
      quad = play_button_quad,
      quad_when_selected = play_button_selected_quad
   }
   quit_button = buttons.new_button{
      text = "Quit",
      position = vector( (800 - button_tile_width) / 2, 310),
      width = button_tile_width,
      height = button_tile_height,
      image = menu_buttons_image,
      quad = quit_button_quad,
      quad_when_selected = quit_button_selected_quad
   }
   music:play()
end

function menu.update( dt )
   buttons.update_button( start_button, dt )
   buttons.update_button( quit_button, dt )
end

function menu.draw()
   buttons.draw_button( start_button )
   buttons.draw_button( quit_button )
end

function menu.keyreleased( key, code )
   if key == "return" then
      gamestates.set_state( "game", { current_level = 1 } )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

function menu.mousereleased( x, y, button, istouch )
   if button == 'l' or button == 1 then
      if buttons.mousereleased( start_button, x, y, button ) then
	 gamestates.set_state( "game", { current_level = 1 } )
      elseif buttons.mousereleased( quit_button, x, y, button ) then
	 love.event.quit()
      end
   elseif button == 'r' or button == 2 then
      love.event.quit()
   end    
end

return menu
