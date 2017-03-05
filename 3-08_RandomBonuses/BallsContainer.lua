local Ball = require "Ball"
local vector = require "vector"
local love = love
local setmetatable = setmetatable
local table = table
local pairs = pairs
local math = math
local print = print

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

function BallsContainer:update( dt, platform )
   for _, ball in pairs( self.balls ) do
      ball:update( dt, platform )
   end   
end

function BallsContainer:draw()
   for _, ball in pairs( self.balls ) do
      ball:draw()
   end   
end

function BallsContainer:keyreleased( key, scancode, platform )
   if key == ' ' then
      local stuck = {}
      for _, ball in pairs( self.balls ) do
	 if ball.stuck_to_platform then
	    table.insert( stuck, ball )
	 end
	 if #stuck > 0 then
	    stuck[1]:launch_from_platform( platform )
	 end
      end
   end
end

function BallsContainer:mousereleased( x, y, button, istouch, platform )
   if button == 'l' then
      local stuck = {}
      for key, ball in pairs( self.balls ) do
	 if ball.stuck_to_platform then
	    table.insert( stuck, ball )
	 end
	 if #stuck > 0 then
	    stuck[1]:launch_from_platform( platform )
	 end
      end
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
				 collider = first_ball.collider,
				 stuck_to_platform = false }
   self:add_ball( new_ball_properties )
end

function BallsContainer:launch_all_stuck_balls( platform )
   for i, ball in pairs( self.balls ) do
      if ball.stuck_to_platform then
	 ball:launch_from_platform( platform )
      end
   end
end

return BallsContainer
