local vector = require "vector"

local collisions = {}

function collisions.resolve_collisions( ball, platform,
					walls, bricks, bonuses )
   collisions.ball_platform_collision( ball, platform )
   collisions.ball_walls_collision( ball, walls )
   collisions.ball_bricks_collision( ball, bricks, bonuses )
   collisions.platform_walls_collision( platform, walls )
   collisions.platform_bonuses_collision( platform, bonuses, ball )
end

function collisions.check_rectangles_overlap( a, b )
   local overlap = false
   local small_shift_to_prevent_overlap = 0.1
   local shift_b = vector( 0, 0 )
   if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
	   a.y + a.height < b.y or b.y + b.height < a.y ) then
      overlap = true
      if ( a.x + a.width / 2 ) < ( b.x + b.width / 2 ) then
	 shift_b.x = ( a.x + a.width ) - b.x + small_shift_to_prevent_overlap
      else 
	 shift_b.x = a.x - ( b.x + b.width ) - small_shift_to_prevent_overlap
      end
      if ( a.y + a.height / 2 ) < ( b.y + b.height / 2 ) then
	 shift_b.y = ( a.y + a.height ) - b.y + small_shift_to_prevent_overlap
      else
	 shift_b.y = a.y - ( b.y + b.height ) - small_shift_to_prevent_overlap
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
      ball.platform_rebound( shift_ball, platform )
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
	 ball.wall_rebound( shift_ball )
      end
   end
end

function collisions.ball_bricks_collision( ball, bricks, bonuses )
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
	 ball.brick_rebound( shift_ball )
	 bricks.brick_hit_by_ball( i, brick, shift_ball, bonuses )
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

function collisions.platform_bonuses_collision( platform, bonuses, ball )
   local overlap
   local b = { x = platform.position.x,
	       y = platform.position.y,
	       width = platform.width,
	       height = platform.height }
   for i, bonus in pairs( bonuses.current_level_bonuses ) do
      local a = { x = bonus.position.x - bonuses.radius,
		  y = bonus.position.y - bonuses.radius,
		  width = 2 * bonuses.radius,
		  height = 2 * bonuses.radius }      
      overlap = collisions.check_rectangles_overlap( a, b )
      if overlap then
	 bonuses.bonus_collected( i, bonus, ball, platform )
      end
   end
end

return collisions
