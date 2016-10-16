local love = love

local brick = {}

if setfenv then
   setfenv(1, brick) -- for 5.1
else
   _ENV = brick -- for 5.2
end

position_x = 100
position_y = 100
width = 50
height = 30

function update( dt )
end

function draw()
   love.graphics.rectangle( 'line',
			    position_x,
			    position_y,
			    width,
			    height )
end

return brick
