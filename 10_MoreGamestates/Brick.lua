local vector = require "vector"
local love = love
local setmetatable = setmetatable
local math = math

local Brick = {}

if setfenv then
   setfenv(1, Brick) -- for 5.1
else
   _ENV = Brick -- for 5.2
end

function Brick:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "brick"
   o.position = o.position or vector( 100, 100 )
   o.width = o.width or 50
   o.height = o.height or 30
   o.bricktype = o.bricktype or 1
   o.collider = o.collider or {}
   o.collider_shape = o.collider:rectangle( o.position.x,
					    o.position.y,
					    o.width,
					    o.height )
   o.collider_shape.game_object = o
   o.to_destroy = o.to_destroy or false
   return o
end

function Brick:update( dt )
end

function Brick:draw()
   love.graphics.rectangle( 'line',
			    self.position.x,
			    self.position.y,
			    self.width,
			    self.height )
   local r, g, b, a = love.graphics.getColor( )
   if self.bricktype == 1 then
      love.graphics.setColor( 255, 0, 0, 100 )
   elseif self.bricktype == 2 then
      love.graphics.setColor( 0, 255, 0, 100 )
   elseif self.bricktype == 3 then
      love.graphics.setColor( 0, 0, 255, 100 )
   end	 
   self.collider_shape:draw( 'fill' )
   love.graphics.setColor( r, g, b, a )
end

function Brick:react_on_ball_collision(	another_shape, separating_vector )
   local big_enough_overlap = 0.5
   local dx, dy = separating_vector.x, separating_vector.y
   if ( math.abs( dx ) > big_enough_overlap ) or
      ( math.abs( dy ) > big_enough_overlap ) then
	 self.to_destroy = true
   end
end

function Brick:destroy()
   self.collider_shape.game_object = nil
   self.collider:remove( self.collider_shape )
end

function Brick:mousepressed( x, y, button, istouch )
   if button == 'l' or button == 1 then
      if self.position.x < x and x < ( self.position.x + self.width ) and
      self.position.y < y and y < ( self.position.y + self.height ) then
	 self.to_destroy = true
      end
   end
end

return Brick
