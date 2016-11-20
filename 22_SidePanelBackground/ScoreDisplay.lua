local vector = require "vector"
local love = love
local setmetatable = setmetatable

local ScoreDisplay = {}

if setfenv then
   setfenv(1, ScoreDisplay) -- for 5.1
else
   _ENV = ScoreDisplay -- for 5.2
end

function ScoreDisplay:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "score_display"
   o.position = o.position or vector( 670, 32 )
   o.width = o.width or 100
   o.height = o.height or 65
   o.score = o.score or 0
   o.separation = o.separation or 25
   return o
end

function ScoreDisplay:update( dt )
end

function ScoreDisplay:draw()
   love.graphics.rectangle( 'line',
			    self.position.x,
			    self.position.y,
			    self.width,
			    self.height )
   love.graphics.printf( "Score:",
			 self.position.x,
			 self.position.y,
			 self.width,
			 "center" )
   love.graphics.printf( self.score,
			 self.position.x,
			 self.position.y + self.separation,
			 self.width,
			 "center" )
end

function ScoreDisplay:react_on_ball_brick_collision( brick_shape )
   local brick = brick_shape.game_object
   if brick.to_destroy then
      if brick:is_simple() then
	 self.score = self.score + 10
      elseif brick:is_cracked() then
	 self.score = self.score + 30
      end
   end
end

return ScoreDisplay


