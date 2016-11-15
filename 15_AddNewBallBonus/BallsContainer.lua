local Ball = require "Ball"
local vector = require "vector"
local love = love
local setmetatable = setmetatable
local table = table
local pairs = pairs
local math = math

local BallsContainer = {}

if setfenv then
   setfenv(1, BallsContainer) -- for 5.1
else
   _ENV = BallsContainer -- for 5.2
end

function BallsContainer:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "balls_container"   
   o.balls = o.balls or {}
   o.collider = o.collider or {}
   table.insert( o.balls, Ball:new( { collider = o.collider } ) )
   return o
end

function BallsContainer:update( dt )
   for _, ball in pairs( self.balls ) do
      ball:update( dt )
   end   
end

function BallsContainer:draw()
   for _, ball in pairs( self.balls ) do
      ball:draw()
   end   
end

function BallsContainer:add_ball( new_ball_properties )
   local new_ball = Ball:new( new_ball_properties )
   table.insert( self.balls, new_ball )
end

function BallsContainer:react_on_slow_down_bonus()
   for _, ball in pairs( self.balls ) do
      ball:react_on_slow_down_bonus()
   end
end

function BallsContainer:react_on_accelerate_bonus()
   for _, ball in pairs( self.balls ) do
      ball:react_on_accelerate_bonus()
   end
end

function BallsContainer:react_on_add_new_ball_bonus()
   local first_ball = self.balls[1]
   local new_ball_properties = { position = first_ball.position,
				 speed = first_ball.speed:rotated( math.pi / 4 ),
				 collider = first_ball.collider }
   self:add_ball( new_ball_properties )
end

return BallsContainer
