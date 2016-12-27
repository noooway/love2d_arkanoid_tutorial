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

function ball.rebound( shift_ball_x, shift_ball_y )
   local big_enough_overlap = 0.5
   ball.position_x = ball.position_x + shift_ball_x
   ball.position_y = ball.position_y + shift_ball_y
   if math.abs( shift_ball_x ) > big_enough_overlap then
      ball.speed_x  = -ball.speed_x
   end
   if math.abs( shift_ball_y ) > big_enough_overlap then
      ball.speed_y  = -ball.speed_y
   end
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

function platform.bounce_from_wall( shift_platform_x, shift_platform_y )
   -- platform.position_x = platform.position_x + shift_platform_x
   -- platform.position_y = platform.position_y + shift_platform_y   
end

-- Bricks
local bricks = {}
bricks.rows = 8
bricks.columns = 11
bricks.top_left_position_x = 70
bricks.top_left_position_y = 50
bricks.brick_width = 50
bricks.brick_height = 30
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.current_level_bricks = {}

function bricks.construct_level()
   for row = 1, bricks.rows do
      for col = 1, bricks.columns do
	 local new_brick_position_x = bricks.top_left_position_x +
	    ( col - 1 ) *
	    ( bricks.brick_width + bricks.horizontal_distance )
	 local new_brick_position_y = bricks.top_left_position_y +
	    ( row - 1 ) *
	    ( bricks.brick_height + bricks.vertical_distance )
	 local new_brick = { x = new_brick_position_x,
			     y = new_brick_position_y }
	 table.insert( bricks.current_level_bricks, new_brick )
      end      
   end   
end

function bricks.update( dt )
end

function bricks.draw()
   for _, brick in pairs( bricks.current_level_bricks ) do
      love.graphics.rectangle( 'line',
			       brick.x,
			       brick.y,
			       bricks.brick_width,
			       bricks.brick_height )
   end
end

function bricks.brick_hit_by_ball( i, brick )
   bricks.current_level_bricks[i] = nil
end

-- Walls 
local walls = {}
walls.wall_thickness = 20
walls.walls = {}

function walls.construct_walls()
   local left_wall = {
      x = 0,
      y = 0,
      width = walls.wall_thickness,
      height = love.graphics.getHeight()
   }
   local right_wall = {
      x = love.graphics.getWidth() - walls.wall_thickness,
      y = 0,
      width = walls.wall_thickness,
      height = love.graphics.getHeight()
   }
   local top_wall = {
      x = 0,
      y = 0,
      width = love.graphics.getWidth(),
      height = walls.wall_thickness,
   }
   local bottom_wall = {
      x = 0,
      y = love.graphics.getHeight() - walls.wall_thickness,
      width = love.graphics.getWidth(),
      height = walls.wall_thickness,
   }   
   walls.walls.left = left_wall
   walls.walls.right = right_wall
   walls.walls.top = top_wall
   walls.walls.bottom = bottom_wall
end

function walls.update( dt )
end

function walls.draw()
   for _, wall in pairs( walls.walls ) do
      love.graphics.rectangle( 'line',
			       wall.x,
			       wall.y,
			       wall.width,
			       wall.height )
   end
end


-- Collisions
local collisions = {}

function collisions.resolve_collisions()
   collisions.ball_platform_collision( ball, platform )
   collisions.ball_walls_collision( ball, walls )
   collisions.ball_bricks_collision( ball, bricks )
   collisions.platform_walls_collision( platform, walls )
end

function collisions.check_rectangles_overlap( a, b )
   local overlap = false
   if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
	   a.y + a.height < b.y or b.y + b.height < a.y ) then
      overlap = true
   end
   return overlap
end

function collisions.ball_platform_collision( ball, platform )
   local overlap, shift_ball_x, shift_ball_y
   local a = { x = platform.position_x,
	       y = platform.position_y,
	       width = platform.width,
	       height = platform.height }
   local b = { x = ball.position_x - ball.radius,
	       y = ball.position_y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   if collisions.check_rectangles_overlap( a, b ) then
      print( "ball-platform collision" )
   end      
end

function collisions.ball_walls_collision( ball, walls )
   local overlap, shift_ball_x, shift_ball_y
   local b = { x = ball.position_x - ball.radius,
	       y = ball.position_y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   for _, wall in pairs( walls.walls ) do
      local a = { x = wall.x,
		  y = wall.y,
		  width = wall.width,
		  height = wall.height }      
      	 
      if collisions.check_rectangles_overlap( a, b ) then
	 print( "ball-wall collision" )
      end
   end
end

function collisions.ball_bricks_collision( ball, bricks )
   local overlap, shift_ball_x, shift_ball_y
   local b = { x = ball.position_x - ball.radius,
	       y = ball.position_y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   for i, brick in pairs( bricks.current_level_bricks ) do   
      local a = { x = brick.x,
		  y = brick.y,
		  width = bricks.brick_width,
		  height = bricks.brick_height }
      if collisions.check_rectangles_overlap( a, b ) then
	 print( "ball-bricks collision" )
      end
   end
end

function collisions.platform_walls_collision()
   local overlap, shift_platform_x, shift_platform_y
   local b = { x = platform.position_x,
	       y = platform.position_y,
	       width = platform.width,
	       height = platform.height }
   for _, wall in pairs( walls.walls ) do
      local a = { x = wall.x,
		  y = wall.y,
		  width = wall.width,
		  height = wall.height }      
      if collisions.check_rectangles_overlap( a, b ) then
	 print( "platform-walls collision" )
      end
   end
end


function love.load()
   bricks.construct_level()
   walls.construct_walls()
end
 
function love.update( dt )
   ball.update( dt )
   platform.update( dt )
   bricks.update( dt )
   walls.update( dt )
   collisions.resolve_collisions()
end
 
function love.draw()
   ball.draw()
   platform.draw()
   bricks.draw()
   walls.draw()
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
