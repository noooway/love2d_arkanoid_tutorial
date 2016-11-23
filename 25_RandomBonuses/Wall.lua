local vector = require "vector"
local love = love
local setmetatable = setmetatable
local math = math

local Wall = {}

if setfenv then
   setfenv(1, Wall) -- for 5.1
else
   _ENV = Wall -- for 5.2
end

image = love.graphics.newImage( "img/800x600/walls.png" )
local wall_vertical_tile_width = 32
local wall_vertical_tile_height = 96
local wall_vertical_tile_x_pos = 0
local wall_vertical_tile_y_pos = 0
local wall_horizontal_tile_width = 96
local wall_horizontal_tile_height = 26
local wall_horizontal_tile_x_pos = 64
local wall_horizontal_tile_y_pos = 0
local topleft_corner_tile_width = 64
local topleft_corner_tile_height = 64
local topleft_corner_tile_x_pos = 64
local topleft_corner_tile_y_pos = 32
local topright_corner_tile_width = 64
local topright_corner_tile_height = 64
local topright_corner_tile_x_pos = 128
local topright_corner_tile_y_pos = 32
local tileset_width = 192
local tileset_height = 96

function Wall:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "wall"
   o.position = o.position or vector( 0, 0 )
   o.width = o.width or 20
   o.height = o.height or love.window.getHeight()
   o.layout = o.layout or nil
   o.next_level_portal = o.next_level_portal or false
   o.vertical_quad = love.graphics.newQuad(
      wall_vertical_tile_x_pos,
      wall_vertical_tile_y_pos,
      wall_vertical_tile_width,
      wall_vertical_tile_height,
      tileset_width, tileset_height )
   o.horizontal_quad = love.graphics.newQuad(
      wall_horizontal_tile_x_pos,
      wall_horizontal_tile_y_pos,
      wall_horizontal_tile_width,
      wall_horizontal_tile_height,
      tileset_width, tileset_height )
   o.topright_corner_quad = love.graphics.newQuad(
      topright_corner_tile_x_pos,
      topright_corner_tile_y_pos,
      topright_corner_tile_width,
      topright_corner_tile_height,
      tileset_width, tileset_height )
   o.topleft_corner_quad = love.graphics.newQuad(
      topleft_corner_tile_x_pos,
      topleft_corner_tile_y_pos,
      topleft_corner_tile_width,
      topleft_corner_tile_height,
      tileset_width, tileset_height )
   o.collider = o.collider or {}
   o.collider_shape = o.collider:rectangle( o.position.x,
					    o.position.y,
					    o.width,
					    o.height )
   o.collider_shape.game_object = o
   return o
end

function Wall:update( dt )
end


function Wall:draw()
   if ( self.layout == 'top' ) then 
      love.graphics.draw(
      	 self.image,
      	 self.topleft_corner_quad,
      	 self.position.x,
      	 self.position.y )
      love.graphics.draw(
	 self.image,
	 self.topright_corner_quad,			  
	 self.position.x + self.width - topleft_corner_tile_width / 2,
	 self.position.y )
      local repeat_n_times = 4
      for i = 0, repeat_n_times do
   	 shift_x = topleft_corner_tile_width +
	    i * wall_horizontal_tile_width
   	 love.graphics.draw(
	    self.image,
	    self.horizontal_quad,
	    self.position.x + shift_x,
	    self.position.y )
      end
   elseif self.layout == 'left' then 
      local repeat_n_times = math.floor(
	 (self.height - topright_corner_tile_height) /
	    wall_vertical_tile_height )
      for i = 0, repeat_n_times do
	 shift_y = topright_corner_tile_height +
	    i * wall_vertical_tile_height
	 love.graphics.draw( self.image,
			     self.vertical_quad,
			     self.position.x,
			     self.position.y + shift_y )
      end
   elseif self.layout == 'right' then
      local repeat_n_times =
	 math.floor( (self.height - topright_corner_tile_height) /
	       wall_vertical_tile_height )
      for i = 0, repeat_n_times do
	 if not (self.next_level_portal and i == repeat_n_times - 1) then
	    shift_y = topright_corner_tile_height +
	       i * wall_vertical_tile_height
	    love.graphics.draw( self.image,
				self.vertical_quad,
				self.position.x,
				self.position.y + shift_y )
	 end
      end
   else
      love.graphics.rectangle( 'line',
			       self.position.x,
			       self.position.y,
			       self.width,
			       self.height )
      local r, g, b, a = love.graphics.getColor( )
      love.graphics.setColor( 0, 255, 0, 100 )
      self.collider_shape:draw( 'fill' )
      love.graphics.setColor( r, g, b, a )
   end
end

function Wall:react_on_next_level_bonus()
   if self.layout == 'right' then
      self.next_level_portal = true
   end
end

function Wall:next_level_portal_active()
   return (self.layout == 'right') and self.next_level_portal
end

return Wall
