local Platform = require "Platform"
local Ball = require "Ball"
local BricksContainer = require "BricksContainer"
local WallsContainer = require "WallsContainer"

function love.load()
   ball = Ball:new()
   platform = Platform:new()
   bricks_container = BricksContainer:new()
   walls_container = WallsContainer:new()
end
 
function love.update( dt )
   ball:update( dt )
   platform:update( dt )
   bricks_container:update( dt )
   walls_container:update( dt )
end
 
function love.draw()
   ball:draw()
   platform:draw()
   bricks_container:draw()
   walls_container:draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
