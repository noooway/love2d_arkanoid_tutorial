local vector = require "vector"

local collisions = {}

function collisions.resolve_collisions( ball, platform, walls, bricks )
   collisions.ball_platform_collision( ball, platform )
   collisions.ball_walls_collision( ball, walls )
   collisions.ball_bricks_collision( ball, bricks )
   collisions.platform_walls_collision( platform, walls )
end

function collisions.check_rectangles_overlap( a, b )
   local x_overlap, x_b_shift = collisions.overlap_along_axis(
      a.center_x, a.halfwidth, b.center_x, b.halfwidth )
   local y_overlap, y_b_shift = collisions.overlap_along_axis(
      a.center_y, a.halfheight, b.center_y, b.halfheight )
   local overlap = ( x_overlap > 0 ) and ( y_overlap > 0 )
   return overlap, vector( x_b_shift, y_b_shift )
end

function collisions.overlap_along_axis( a_pos, a_size, b_pos, b_size )
   local diff = b_pos - a_pos
   local dist = math.abs( diff )
   local overlap_value = a_size + b_size - dist
   local b_shift = diff / dist * overlap_value
   return overlap_value, b_shift
end

function collisions.ball_platform_collision( ball, platform )
   local overlap, shift_ball
   local a = { center_x = platform.position.x + platform.width / 2,
	       center_y = platform.position.y + platform.height / 2,
	       halfwidth = platform.width / 2,
	       halfheight = platform.height / 2 }
   local b = { center_x = ball.position.x,
	       center_y = ball.position.y,
	       halfwidth = ball.radius,
	       halfheight = ball.radius }
   overlap, shift_ball =
      collisions.check_rectangles_overlap( a, b )   
   if overlap then
      ball.rebound( shift_ball )
   end      
end

function collisions.ball_walls_collision( ball, walls )
   local overlap, shift_ball
   local b = { center_x = ball.position.x,
	       center_y = ball.position.y,
	       halfwidth = ball.radius,
	       halfheight = ball.radius }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { center_x = wall.position.x + wall.width / 2,
		  center_y = wall.position.y + wall.height / 2,
		  halfwidth = wall.width / 2,
		  halfheight = wall.height / 2 }
      overlap, shift_ball =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then
	 ball.rebound( shift_ball )
      end
   end
end

function collisions.ball_bricks_collision( ball, bricks )
   local overlap, shift_ball
   local b = { center_x = ball.position.x,
	       center_y = ball.position.y,
	       halfwidth = ball.radius,
	       halfheight = ball.radius }
   for i, brick in pairs( bricks.current_level_bricks ) do   
      local a = { center_x = brick.position.x + brick.width / 2,
		  center_y = brick.position.y + brick.height / 2,
		  halfwidth = brick.width / 2,
		  halfheight = brick.height / 2 }
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
   local b = { center_x = platform.position.x + platform.width / 2,
	       center_y = platform.position.y + platform.height / 2,
	       halfwidth = platform.width / 2,
	       halfheight = platform.height / 2 }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { center_x = wall.position.x + wall.width / 2,
		  center_y = wall.position.y + wall.height / 2,
		  halfwidth = wall.width / 2,
		  halfheight = wall.height / 2 }      
      overlap, shift_platform =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then	 
	 platform.bounce_from_wall( shift_platform )
      end
   end
end

return collisions
