-- Ball
local ball = {}
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300
ball.radius = 10

function ball.update( dt )
   ball.position_x = ball.position_x + ball.speed_x * dt
   ball.position_y = ball.position_y + ball.speed_y * dt   
end

function ball.draw()
   local segments_in_circle = 16
   love.graphics.circle( 'line',
			 ball.position_x,
			 ball.position_y,
			 ball.radius,
			 segments_in_circle )   
end


-- Platform
local platform = {}
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20

function platform.update( dt )
   if love.keyboard.isDown("right") then
      platform.position_x = platform.position_x + (platform.speed_x * dt)
   end
   if love.keyboard.isDown("left") then
      platform.position_x = platform.position_x - (platform.speed_x * dt)
   end   
end

function platform.draw()
   love.graphics.rectangle( 'line',
			    platform.position_x,
			    platform.position_y,
			    platform.width,
			    platform.height )   
end

-- Bricks
local bricks = {}
bricks.brick_width = 50
bricks.brick_height = 30
bricks.current_level_bricks = {}

function bricks.new_brick( position_x, position_y, width, height )
   return( { position_x = position_x,
	     position_y = position_y,
	     width = width or bricks.brick_width,
	     height = height or bricks.brick_height } )
end

function bricks.add_to_current_level_bricks( brick )
   table.insert( bricks.current_level_bricks, brick )
end

function bricks.update_brick( single_brick )   
end

function bricks.draw_brick( single_brick )
   love.graphics.rectangle( 'line',
			    single_brick.position_x,
			    single_brick.position_y,
			    single_brick.width,
			    single_brick.height )   
end

function bricks.update( dt )
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.update_brick( brick )
   end
end

function bricks.draw()
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.draw_brick( brick )
   end
end


function love.load()   
   bricks.add_to_current_level_bricks(
      bricks.new_brick( 100, 100, bricks.brick_width, bricks.brick_height )  )
   bricks.add_to_current_level_bricks(
      bricks.new_brick( 160, 100, bricks.brick_width, bricks.brick_height )  )
   bricks.add_to_current_level_bricks(
      bricks.new_brick( 220, 100, bricks.brick_width, bricks.brick_height )  )   
   bricks.add_to_current_level_bricks(
      bricks.new_brick( 280, 145, bricks.brick_width, bricks.brick_height )  )   
   bricks.add_to_current_level_bricks(
      bricks.new_brick( 340, 145, bricks.brick_width, bricks.brick_height )  )   
end
 
function love.update( dt )
   ball.update( dt )
   platform.update( dt )
   bricks.update( dt )
end
 
function love.draw()
   ball.draw()
   platform.draw()
   bricks.draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
