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

local bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30 )

function LifeDisplay:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "life_display"
   o.position = o.position or vector( 620, 500 )
   o.width = o.width or 170
   o.height = o.height or 65
   o.separation = o.separation or 35
   o.life = o.life or 3
   o.lives_added_from_score = o.lives_added_from_score or 0
   return o
end

function LifeDisplay:update( dt )
end

function LifeDisplay:draw()
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 255, 255, 255, 230 )
   love.graphics.printf( "Lives: " .. tostring( self.life ),
			 self.position.x,
			 self.position.y,
			 self.width,
			 "center" )
   love.graphics.setFont( oldfont )
   love.graphics.setColor( r, g, b, a )
end

function LifeDisplay:add_life_if_score_reached( score )
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
