local vector = require "vector"

local collisions = {}

function collisions.resolve_collisions( ball, platform, walls, bricks )
   collisions.ball_platform_collision( ball, platform )
   collisions.ball_walls_collision( ball, walls )
   collisions.ball_bricks_collision( ball, bricks )
   collisions.platform_walls_collision( platform, walls )
end

function collisions.check_rectangles_overlap( a, b )
   local overlap = false
   local shift_b = vector( 0, 0 )
   if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
	   a.y + a.height < b.y or b.y + b.height < a.y ) then
      overlap = true
      if ( a.x + a.width / 2 ) < ( b.x + b.width / 2 ) then
	 shift_b.x = ( a.x + a.width ) - b.x
      else 
	 shift_b.x = a.x - ( b.x + b.width )
      end
      if ( a.y + a.height / 2 ) < ( b.y + b.height / 2 ) then
	 shift_b.y = ( a.y + a.height ) - b.y
      else
	 shift_b.y = a.y - ( b.y + b.height )
      end      
   end
   return overlap, shift_b
end

function collisions.ball_platform_collision( ball, platform )
   local overlap, shift_ball
   local a = { x = platform.position.x,
	       y = platform.position.y,
	       width = platform.width,
	       height = platform.height }
   local b = { x = ball.position.x - ball.radius,
	       y = ball.position.y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   overlap, shift_ball =
      collisions.check_rectangles_overlap( a, b )   
   if overlap then
      ball.rebound( shift_ball )
   end      
end

function collisions.ball_walls_collision( ball, walls )
   local overlap, shift_ball
   local b = { x = ball.position.x - ball.radius,
	       y = ball.position.y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { x = wall.position.x,
		  y = wall.position.y,
		  width = wall.width,
		  height = wall.height }      
      overlap, shift_ball =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then
	 ball.rebound( shift_ball )
      end
   end
end

function collisions.ball_bricks_collision( ball, bricks )
   local overlap, shift_ball
   local b = { x = ball.position.x - ball.radius,
	       y = ball.position.y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   for i, brick in pairs( bricks.current_level_bricks ) do   
      local a = { x = brick.position.x,
		  y = brick.position.y,
		  width = brick.width,
		  height = brick.height }
      overlap, shift_ball =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then	 
	 ball.rebound( shift_ball )
	 bricks.brick_hit_by_ball( i, brick, shift_ball )
      end
   end
end

function collisions.platform_walls_collision( platform, walls )
   local overlap, shift_platform
   local b = { x = platform.position.x,
	       y = platform.position.y,
	       width = platform.width,
	       height = platform.height }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { x = wall.position.x,
		  y = wall.position.y,
		  width = wall.width,
		  height = wall.height }      
      overlap, shift_platform =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then	 
	 platform.bounce_from_wall( shift_platform )
      end
   end
end

return collisions
