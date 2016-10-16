local vector = require "vector"
local love = love
local setmetatable = setmetatable

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
   o.collider = o.collider or {}
   o.collider_shape = o.collider:rectangle( o.position.x,
					    o.position.y,
					    o.width,
					    o.height )
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
   love.graphics.setColor( 0, 255, 0, 100 )
   self.collider_shape:draw( 'fill' )
   love.graphics.setColor( r, g, b, a )
end

return Brick
