local vector = require "vector"

local lives_display = {}
lives_display.position = vector( 680, 500 )
lives_display.lives = 5

function lives_display.update( dt )
end

function lives_display.draw()
   love.graphics.print( "Lives: " .. tostring( lives_display.lives ),
			lives_display.position.x,
			lives_display.position.y )
end

function lives_display.lose_life()
   lives_display.lives = lives_display.lives - 1
end

function lives_display.reset()
   lives_display.lives = 5
end

return lives_display
