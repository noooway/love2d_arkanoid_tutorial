local love = love

local ball = {}

if setfenv then
   setfenv(1, ball) -- for 5.1
else
   _ENV = ball -- for 5.2
end

position_x = 300
position_y = 300
speed_x = 300
speed_y = 300
radius = 10

function update( dt )
   position_x = position_x + speed_x * dt
   position_y = position_y + speed_y * dt
end

function draw()
   local segments_in_circle = 16
   love.graphics.circle( 'line',
			 position_x,
			 position_y,
			 radius,
			 segments_in_circle )
end

return ball
