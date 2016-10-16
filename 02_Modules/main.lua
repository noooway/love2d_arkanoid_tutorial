local platform = require "platform"
local ball = require "ball"
local brick = require "brick"

function love.load()
end
 
function love.update( dt )
   ball.update( dt )
   platform.update( dt )
   brick.update( dt )
end
 
function love.draw()
   ball.draw()
   platform.draw()
   brick.draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
