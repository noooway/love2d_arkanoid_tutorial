local vector = require "vector"
local love = love
local setmetatable = setmetatable

local Platform = {}

if setfenv then
   setfenv(1, Platform) -- for 5.1
else
   _ENV = Platform -- for 5.2
end

image = love.graphics.newImage( "img/800x600/platform.png" )
local platform_small_tile_width = 75
local platform_small_tile_height = 16
local platform_small_tile_x_pos = 0
local platform_small_tile_y_pos = 0
local platform_norm_tile_width = 108
local platform_norm_tile_height = 16
local platform_norm_tile_x_pos = 0
local platform_norm_tile_y_pos = 32
local platform_large_tile_width = 141
local platform_large_tile_height = 16
local platform_large_tile_x_pos = 0
local platform_large_tile_y_pos = 64
local platfrom_sticky_x_pos_shift = 192
local tileset_width = 333
local tileset_height = 80

function Platform:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "platform"
   o.position = o.position or vector( 500, 500 )
   o.speed = o.speed or vector( 1900, 0 )
   o.size = o.size or "norm"
   o.width = o.width or platform_norm_tile_width
   o.height = o.height or platform_norm_tile_height
   o.collider = o.collider or {}
   o.collider_shape = o.collider:rectangle( o.position.x,
					    o.position.y,
					    o.width,
					    o.height )
   o.collider_shape.game_object = o
   o.quad = o.quad or love.graphics.newQuad( platform_norm_tile_x_pos,
					     platform_norm_tile_y_pos,
					     platform_norm_tile_width,
					     platform_norm_tile_height,
					     tileset_width, tileset_height )
   self.sticky = o.sticky or false
   return o
end

function Platform:update( dt )
   self:follow_mouse( dt )
   self.collider_shape:moveTo( self.position.x + self.width / 2,
			       self.position.y + self.height / 2 )   
end

function Platform:draw()
   love.graphics.draw( self.image,
   		       self.quad, 
   		       self.position.x,
   		       self.position.y )
end

function Platform:follow_mouse( dt )
   local x, y = love.mouse.getPosition()
   local left_wall_plus_half_platform = 34 + self.width / 2
   local right_border_minus_half_platform = 576 - self.width / 2
   if ( x > left_wall_plus_half_platform and
	x < right_border_minus_half_platform ) then
      self.position.x = x - self.width / 2
   elseif x < left_wall_plus_half_platform then
      self.position.x = left_wall_plus_half_platform - self.width / 2
   elseif x > right_border_minus_half_platform then
      self.position.x = right_border_minus_half_platform - self.width / 2
   end
end

function Platform:react_on_wall_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position.x + self.width / 2,
			       self.position.y + self.height / 2 )   
end

function Platform:react_on_decrease_bonus()
   if self.size == "norm" then
      self.width = platform_small_tile_width
      self.height = platform_small_tile_height
      self.quad = love.graphics.newQuad( platform_small_tile_x_pos,
					 platform_small_tile_y_pos,
					 platform_small_tile_width,
					 platform_small_tile_height,
					 tileset_width, tileset_height )
      self.size = "small"
   elseif self.size == "large" then
      self.width = platform_norm_tile_width
      self.height = platform_norm_tile_height
      self.quad = love.graphics.newQuad( platform_norm_tile_x_pos,
					 platform_norm_tile_y_pos,
					 platform_norm_tile_width,
					 platform_norm_tile_height,
					 tileset_width, tileset_height )
      self.size = "norm"	 
   end
   self.collider:remove( self.collider_shape )
   self.collider_shape = nil
   self.collider_shape = self.collider:rectangle(
      self.position.x,
      self.position.y,
      self.width,
      self.height )
   self.collider_shape.game_object = self
end

function Platform:react_on_increase_bonus()
   if self.size == "small" then
      self.width = platform_norm_tile_width
      self.height = platform_norm_tile_height
      self.quad = love.graphics.newQuad( platform_norm_tile_x_pos,
					 platform_norm_tile_y_pos,
					 platform_norm_tile_width,
					 platform_norm_tile_height,
					 tileset_width, tileset_height )
      self.size = "norm"
   elseif self.size == "norm" then
      self.width = platform_large_tile_width
      self.height = platform_large_tile_height
      self.quad = love.graphics.newQuad( platform_large_tile_x_pos,
					 platform_large_tile_y_pos,
					 platform_large_tile_width,
					 platform_large_tile_height,
					 tileset_width, tileset_height )
      self.size = "large"
   end
   self.collider:remove( self.collider_shape )
   self.collider_shape = nil
   self.collider_shape = self.collider:rectangle(
      self.position.x,
      self.position.y,
      self.width,
      self.height )
   self.collider_shape.game_object = self
end

function Platform:react_on_glue_bonus()
   self.sticky = true
   if self.size == "small" then
      self.quad = love.graphics.newQuad(
	 platform_small_tile_x_pos + platfrom_sticky_x_pos_shift,
	 platform_small_tile_y_pos,
	 platform_small_tile_width,
	 platform_small_tile_height,
	 tileset_width, tileset_height )
   elseif self.size == "norm" then
      self.quad = love.graphics.newQuad(
	 platform_norm_tile_x_pos + platfrom_sticky_x_pos_shift,
	 platform_norm_tile_y_pos,
	 platform_norm_tile_width,
	 platform_norm_tile_height,
	 tileset_width, tileset_height )
   elseif self.size == "large" then
      self.quad = love.graphics.newQuad(
	 platform_large_tile_x_pos + platfrom_sticky_x_pos_shift,
	 platform_large_tile_y_pos,
	 platform_large_tile_width,
	 platform_large_tile_height,
	 tileset_width, tileset_height )
   end   
end

function Platform:make_nonsticky()
   self.sticky = false
   if self.size == "small" then
      self.quad = love.graphics.newQuad(
	 platform_small_tile_x_pos,
	 platform_small_tile_y_pos,
	 platform_small_tile_width,
	 platform_small_tile_height,
	 tileset_width, tileset_height )
   elseif self.size == "norm" then
      self.quad = love.graphics.newQuad(
	 platform_norm_tile_x_pos,
	 platform_norm_tile_y_pos,
	 platform_norm_tile_width,
	 platform_norm_tile_height,
	 tileset_width, tileset_height )
   elseif self.size == "large" then
      self.quad = love.graphics.newQuad(
	 platform_large_tile_x_pos,
	 platform_large_tile_y_pos,
	 platform_large_tile_width,
	 platform_large_tile_height,
	 tileset_width, tileset_height )
   end      
end

return Platform
