local vector = require "vector"

local ball = {}
ball.position = vector( 200, 500 )
ball.speed = vector( 700, 700 )
ball.radius = 10

function ball.update( dt )
   ball.position = ball.position + ball.speed * dt
end

function ball.draw()
   local segments_in_circle = 16
   love.graphics.circle( 'line',
			 ball.position.x,
			 ball.position.y,
			 ball.radius,
			 segments_in_circle )   
end

function ball.rebound( shift_ball )
   local min_shift = math.min( math.abs( shift_ball.x ),
			       math.abs( shift_ball.y ) )
   if math.abs( shift_ball.x ) == min_shift then
      shift_ball.y = 0
   else
      shift_ball.x = 0
   end
   ball.position = ball.position + shift_ball
   if shift_ball.x ~= 0 then
      ball.speed.x = -ball.speed.x
   end
   if shift_ball.y ~= 0 then
      ball.speed.y = -ball.speed.y
   end
end

function ball.reposition()
   ball.position = vector( 200, 500 )
end

return ball
