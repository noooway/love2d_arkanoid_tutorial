local vector = require "vector"
local love = love
local setmetatable = setmetatable
local tostring = tostring
local print = print

local LivesDisplay = {}

if setfenv then
   setfenv(1, LivesDisplay) -- for 5.1
else
   _ENV = LivesDisplay -- for 5.2
end

function LivesDisplay:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "lives_display"
   o.position = o.position or vector( 680, 500 )
   o.lives = o.lives or 5
   return o
end

function LivesDisplay:update( dt )
end

function LivesDisplay:draw()
   love.graphics.print( "Lives: " .. tostring( self.lives ),
			self.position.x,
			self.position.y )
end

function LivesDisplay:lose_life()
   self.lives = self.lives - 1
end

return LivesDisplay
