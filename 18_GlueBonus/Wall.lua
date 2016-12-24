local vector = require "vector"
local love = love
local setmetatable = setmetatable

local Wall = {}

if setfenv then
   setfenv(1, Wall) -- for 5.1
else
   _ENV = Wall -- for 5.2
end

function Wall:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "wall"
   o.position = o.position or vector( 0, 0 )
   o.width = o.width or 20
   o.height = o.height or love.graphics.getHeight()
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

return Wall
