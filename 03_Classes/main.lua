local Platform = require "Platform"
local Ball = require "Ball"
local Brick = require "Brick"

function love.load()
   ball = Ball:new{}
   platform = Platform:new{}
   brick = Brick:new{}
end
 
function love.update( dt )
   ball:update( dt )
   platform:update( dt )
   brick:update( dt )
end
 
function love.draw()
   ball:draw()
   platform:draw()
   brick:draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
