local vector = require "vector"

local platform = {}
platform.position = vector( 500, 500 )
platform.speed = vector( 500, 0 )
platform.width = 70
platform.height = 20

function platform.update( dt )
   if love.keyboard.isDown("right") then
      platform.position = platform.position + platform.speed * dt
   end
   if love.keyboard.isDown("left") then
      platform.position = platform.position - platform.speed * dt
   end   
end

function platform.draw()
   love.graphics.rectangle( 'line',
			    platform.position.x,
			    platform.position.y,
			    platform.width,
			    platform.height )   
end

function platform.bounce_from_wall( shift_platform )
   platform.position = platform.position + shift_platform
end

return platform
