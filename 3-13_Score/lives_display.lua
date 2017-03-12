local vector = require "vector"

local lives_display = {}
lives_display.position = vector( 680, 500 )
lives_display.lives = 5
lives_display.lives_added_from_score = 0

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

function lives_display.add_life()
   lives_display.lives = lives_display.lives + 1
end

function lives_display.add_life_if_score_reached( score )
   local score_milestone = (lives_display.lives_added_from_score + 1) * 3000
   if score >= score_milestone then
      lives_display.add_life()
      lives_display.lives_added_from_score = lives_display.lives_added_from_score + 1
   end
end
   
function lives_display.reset()
   lives_display.lives = 5
   lives_display.lives_added_from_score = 0
end

return lives_display
