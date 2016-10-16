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
   o.height = o.height or love.window.getHeight()
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
end

return Wall
