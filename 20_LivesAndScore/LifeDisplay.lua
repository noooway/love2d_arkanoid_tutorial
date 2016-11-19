local vector = require "vector"
local love = love
local setmetatable = setmetatable
local tostring = tostring
local print = print

local LifeDisplay = {}

if setfenv then
   setfenv(1, LifeDisplay) -- for 5.1
else
   _ENV = LifeDisplay -- for 5.2
end

function LifeDisplay:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "life_display"
   o.position = o.position or vector( 670, 500 )
   o.width = o.width or 100
   o.height = o.height or 65
   o.life = o.life or 3
   o.lives_added_from_score = o.lives_added_from_score or 0
   o.separation = o.separation or 25
   return o
end

function LifeDisplay:update( dt )
end

function LifeDisplay:draw()
   love.graphics.rectangle( 'line',
			    self.position.x,
			    self.position.y,
			    self.width,
			    self.height )
   love.graphics.printf( "Lives: " .. tostring( self.life ),
			 self.position.x,
			 self.position.y,
			 self.width,
			 "center" )
end

function LifeDisplay:add_life_if_score_reached( score )
   print( score )
   local score_milestone = (self.lives_added_from_score + 1) * 3000
   if score >= score_milestone then
      self:add_new_life()
      self.lives_added_from_score = self.lives_added_from_score + 1
   end
end

function LifeDisplay:add_new_life()
   self.life = self.life + 1
end

function LifeDisplay:lose_life()
   self.life = self.life - 1
end

return LifeDisplay


