local vector = require "vector"
local love = love
local setmetatable = setmetatable

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
   o.position = o.position or vector( 300, 300 )
   o.speed = o.speed or vector( 300, 300 )
   o.collider = o.collider or {}
   o.collider_shape = o.collider:circle( o.position.x,
					 o.position.y,
					 o.radius )
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

return Ball
