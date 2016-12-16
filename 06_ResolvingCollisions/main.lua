local Platform = require "Platform"
local Ball = require "Ball"
local BricksContainer = require "BricksContainer"
local WallsContainer = require "WallsContainer"
local HC = require "HC"
local vector = require "vector"

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
   -- Platform
   local collisions = collider:collisions( platform.collider_shape )
   for another_shape, separating_vector in pairs( collisions ) do
      if another_shape.game_object.name == "wall" then
         platform:react_on_wall_collision( another_shape, separating_vector )
      end
   end
   -- Ball
   local collisions = collider:collisions( ball.collider_shape )
   for another_shape, separating_vector in pairs( collisions ) do
      if another_shape.game_object.name == "wall" then
         ball:react_on_wall_collision( another_shape, separating_vector )
      elseif another_shape.game_object.name == "platform" then
         ball:react_on_platform_collision( another_shape, separating_vector )
      elseif another_shape.game_object.name == "brick" then
         ball:react_on_brick_collision( another_shape, separating_vector )
         another_shape.game_object:react_on_ball_collision(
            ball.collider_shape,
            (-1) * vector( separating_vector.x, separating_vector.y )  )
      end
   end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
