local vector = require "vector"

local score_display = {}
score_display.position = vector( 680, 32 )
score_display.score = 0

function score_display.update( dt )
end

function score_display.draw()
   love.graphics.print( "Score: " .. tostring( score_display.score ),
			score_display.position.x,
			score_display.position.y )
end

function score_display.add_score_for_simple_brick()
   score_display.score = score_display.score + 10
end

function score_display.add_score_for_cracked_brick()
   score_display.score = score_display.score + 30
end

function score_display.reset()
   score_display.score = 0
end

return score_display
