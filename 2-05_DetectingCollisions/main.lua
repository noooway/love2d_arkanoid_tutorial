local Platform = require "Platform"
local Ball = require "Ball"
local BricksContainer = require "BricksContainer"
local WallsContainer = require "WallsContainer"
local HC = require "HC"

function love.load()
   collider = HC.new()
   ball = Ball:new( { collider = collider } )
   platform = Platform:new( { collider = collider } )
   bricks_container = BricksContainer:new( { collider = collider } )
   walls_container = WallsContainer:new( { collider = collider } )
end
 
function love.update( dt )
   ball:update( dt )
   platform:update( dt )
   bricks_container:update( dt )
   walls_container:update( dt )
   resolve_collisions( dt )
end
 
function love.draw()
   ball:draw()
   platform:draw()
   bricks_container:draw()
   walls_container:draw()
end

function resolve_collisions( dt )
   for another_shape, delta in pairs( collider:collisions( ball.collider_shape ) ) do
      local toprint = string.format("Ball is colliding. Separating vector = (%s,%s)",
				    delta.x, delta.y)
      print( toprint )     
   end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
