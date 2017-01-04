local vector = require "vector"
local love = love
local setmetatable = setmetatable
local math = math

local Ball = {}

if setfenv then
   setfenv(1, Ball) -- for 5.1
else
   _ENV = Ball -- for 5.2
end

image = love.graphics.newImage( "img/800x600/ball.png" )
local x_tile_pos = 0
local y_tile_pos = 0
local ball_tile_width = 18
local ball_tile_height = 18
local tileset_width = 18
local tileset_height = 18
   
function Ball:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "ball"
   o.radius = o.radius or ball_tile_width / 2
   o.position = o.position or vector( 300, 450 )
   o.speed = o.speed or vector( -250, -250 )
   o.to_destroy = false
   o.collider = o.collider or {}
   o.collider_shape = o.collider:circle( o.position.x,
					 o.position.y,
					 o.radius )
   o.collider_shape.game_object = o
   o.quad = o.quad or love.graphics.newQuad( x_tile_pos, y_tile_pos,
					     ball_tile_width,
					     ball_tile_height,
					     tileset_width,
					     tileset_height )   
   return o
end

function Ball:update( dt )
   self.position = self.position + self.speed * dt
   self.collider_shape:moveTo( self.position:unpack() )
   self:check_escape_from_screen()
end

function Ball:draw()
   love.graphics.draw( self.image,
   		       self.quad, 
   		       self.position.x - self.radius,
   		       self.position.y - self.radius )
end

function Ball:check_escape_from_screen()
   local x, y = self.position:unpack()
   local ball_top = y - self.radius
   if ball_top > love.graphics.getHeight() then
      self.to_destroy = true
   end
end

function Ball:react_on_wall_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position:unpack() )
   self:normal_rebound( separating_vector )
end

function Ball:react_on_brick_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position:unpack() )
   self:normal_rebound( separating_vector )
end

function Ball:react_on_platform_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position:unpack() )
   self:normal_rebound( separating_vector )
end

function Ball:normal_rebound( separating_vector )
   local big_enough_overlap = 0.5
   local vx, vy = self.speed:unpack()
   local dx, dy = separating_vector.x, separating_vector.y
   local new_vx, new_vy
   if math.abs( dx ) > big_enough_overlap then
      new_vx = -vx
   else
      new_vx = vx
   end
   if math.abs( dy ) > big_enough_overlap then
      new_vy = -vy
   else
      new_vy = vy
   end
   self.speed = vector( new_vx, new_vy )
end

function Ball:destroy()
   self.collider_shape.game_object = nil
   self.collider:remove( self.collider_shape )
end

return Ball
