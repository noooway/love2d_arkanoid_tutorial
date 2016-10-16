local love = love

local platform = {}

if setfenv then
   setfenv(1, platform) -- for 5.1
else
   _ENV = platform -- for 5.2
end

position_x = 500
position_y = 500
speed_x = 300 
width = 70
height = 20

function update( dt )
   if love.keyboard.isDown("right") then
      position_x = position_x + speed_x * dt
   end
   if love.keyboard.isDown("left") then
      position_x = position_x - speed_x * dt
   end
end

function draw()
   love.graphics.rectangle( 'line',
			    position_x,
			    position_y,
			    width,
			    height )
end


return platform
