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

function Ball:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "ball"
   o.radius = o.radius or 10
   o.position = o.position or vector( 500, 500 )
   o.speed = o.speed or vector( 300, 300 )
   o.collider = o.collider or {}
   o.collider_shape = o.collider:circle( o.position.x,
					 o.position.y,
					 o.radius )
   o.collider_shape.game_object = o
   return o
end

function Ball:update( dt )
   self.position = self.position + self.speed * dt
   self.collider_shape:moveTo( self.position:unpack() )
end

function Ball:draw()
   local segments_in_circle = 16
   love.graphics.circle( 'line',
			 self.position.x,
			 self.position.y,
			 self.radius,
			 segments_in_circle )
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 0, 255, 0, 100 )
   self.collider_shape:draw( 'fill' )
   love.graphics.setColor( r, g, b, a )
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
