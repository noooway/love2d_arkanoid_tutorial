local vector = require "vector"
local sign = math.sign or function(x) return x < 0 and -1 or x > 0 and 1 or 0 end

local balls = {}
balls.image = love.graphics.newImage( "img/800x600/ball.png" )
local x_tile_pos = 0
local y_tile_pos = 0
local tile_width = 18
local tile_height = 18
local tileset_width = 18
local tileset_height = 18
balls.quad = love.graphics.newQuad( x_tile_pos, y_tile_pos,
				    tile_width, tile_height,
				    tileset_width, tileset_height )
balls.radius = tile_width / 2
local ball_x_shift = -28
local platform_height = 16
local platform_starting_pos = vector( 300, 500 )
local ball_platform_initial_separation = vector(
   ball_x_shift, -1 * platform_height / 2 - balls.radius - 1 )
local initial_launch_speed_magnitude = 300

balls.current_balls = {}
balls.no_more_balls = false

function balls.new_ball( position, speed,
			 platform_launch_speed_magnitude,
			 stuck_to_platform )
   return( { position = position,
	     speed = speed,
	     platform_launch_speed_magnitude =
		platform_launch_speed_magnitude,
	     stuck_to_platform = stuck_to_platform,
	     radius = balls.radius,
	     collision_counter = 0,
	     separation_from_platform_center =
		ball_platform_initial_separation,
	     quad = balls.quad } )
end

function balls.add_ball( single_ball )
   table.insert( balls.current_balls, single_ball )
end

function balls.update_ball( single_ball, dt, platform )
   if single_ball.stuck_to_platform then
      balls.follow_platform( single_ball, platform )
   else
      single_ball.position = single_ball.position + single_ball.speed * dt
   end      
end

function balls.update( dt, platform )
   for _, ball in ipairs( balls.current_balls ) do
      balls.update_ball( ball, dt, platform )
   end
   balls.check_balls_escaped_from_screen()
end

function balls.draw_ball( single_ball )
   love.graphics.draw( balls.image,
   		       single_ball.quad, 
   		       single_ball.position.x - single_ball.radius,
   		       single_ball.position.y - single_ball.radius )
end

function balls.draw()
   for _, ball in ipairs( balls.current_balls ) do
      balls.draw_ball( ball )
   end
end

function balls.follow_platform( single_ball, platform )   
   local platform_center = vector(
      platform.position.x + platform.width / 2,
      platform.position.y + platform.height / 2 )
   single_ball.position = platform_center +
      single_ball.separation_from_platform_center
end

function balls.launch_single_ball_from_platform()
   for _, single_ball in pairs( balls.current_balls ) do
      if single_ball.stuck_to_platform then
	 single_ball.stuck_to_platform = false
	 local platform_halfwidth = 70
	 local launch_direction = vector(
	    single_ball.separation_from_platform_center.x /
	       platform_halfwidth, -1 )
	 single_ball.speed = launch_direction / launch_direction:len() *
	    single_ball.platform_launch_speed_magnitude
	 break
      end      
   end
end

function balls.launch_all_balls_from_platform()
   for _, single_ball in pairs( balls.current_balls ) do
      if single_ball.stuck_to_platform then
	 single_ball.stuck_to_platform = false
	 local platform_halfwidth = 70
	 local launch_direction = vector(
	    single_ball.separation_from_platform_center.x /
	       platform_halfwidth, -1 )
	 single_ball.speed = launch_direction / launch_direction:len() *
	    single_ball.platform_launch_speed_magnitude
      end
   end
end

function balls.wall_rebound( single_ball, shift_ball )
   balls.normal_rebound( single_ball, shift_ball )
   balls.min_angle_rebound( single_ball )
   balls.increase_collision_counter( single_ball )
   balls.increase_speed_after_collision( single_ball )
end

function balls.platform_rebound( single_ball, shift_ball, platform )
   balls.increase_collision_counter( single_ball )
   balls.increase_speed_after_collision( single_ball )
   if not platform.glued then
      balls.bounce_from_sphere( single_ball, shift_ball, platform )
   else
      single_ball.stuck_to_platform = true
      local actual_shift = balls.determine_actual_shift( shift_ball )
      single_ball.position = single_ball.position + actual_shift
      single_ball.platform_launch_speed_magnitude =
	 single_ball.speed:len()
      balls.compute_ball_platform_separation( single_ball, platform )
   end
end

function balls.compute_ball_platform_separation( single_ball, platform )
   local platform_center = vector(
      platform.position.x + platform.width / 2,
      platform.position.y + platform.height / 2 )
   local ball_center = single_ball.position:clone()
   single_ball.separation_from_platform_center =
      ball_center - platform_center
   print( single_ball.separation_from_platform_center )
end


function balls.brick_rebound( single_ball, shift_ball )
   balls.normal_rebound( single_ball, shift_ball )
   balls.increase_collision_counter( single_ball )
   balls.increase_speed_after_collision( single_ball )
end

function balls.normal_rebound( single_ball, shift_ball )
   local actual_shift = balls.determine_actual_shift( shift_ball )
   single_ball.position = single_ball.position + actual_shift
   if actual_shift.x ~= 0 then
      single_ball.speed.x = -single_ball.speed.x
   end
   if actual_shift.y ~= 0 then
      single_ball.speed.y = -single_ball.speed.y
   end
end

function balls.determine_actual_shift( shift_ball )
   local actual_shift = vector( 0, 0 )
   local min_shift = math.min( math.abs( shift_ball.x ),
			       math.abs( shift_ball.y ) )  
   if math.abs( shift_ball.x ) == min_shift then
      actual_shift.x = shift_ball.x
   else
      actual_shift.y = shift_ball.y
   end
   return actual_shift
end

function balls.bounce_from_sphere( single_ball, shift_ball, platform )
   local actual_shift = balls.determine_actual_shift( shift_ball )
   single_ball.position = single_ball.position + actual_shift
   if actual_shift.x ~= 0 then
      single_ball.speed.x = -single_ball.speed.x
   end
   if actual_shift.y ~= 0 then
      local sphere_radius = 200
      local ball_center = single_ball.position
      local platform_center = platform.position +
	 vector( platform.width / 2, platform.height / 2  )
      local separation = ( ball_center - platform_center )
      local normal_direction = vector( separation.x / sphere_radius, -1 )
      local v_norm = single_ball.speed:projectOn( normal_direction )
      local v_tan = single_ball.speed - v_norm
      local reverse_v_norm = v_norm * (-1)
      single_ball.speed = reverse_v_norm + v_tan
   end
end

function balls.min_angle_rebound( single_ball )
   local min_horizontal_rebound_angle = math.rad( 20 )
   local vx, vy = single_ball.speed:unpack()
   local new_vx, new_vy = vx, vy
   rebound_angle = math.abs( math.atan( vy / vx ) )
   if rebound_angle < min_horizontal_rebound_angle then
      new_vx = sign( vx ) * single_ball.speed:len() *
	 math.cos( min_horizontal_rebound_angle )
      new_vy = sign( vy ) * single_ball.speed:len() *
	 math.sin( min_horizontal_rebound_angle )
   end
   single_ball.speed = vector( new_vx, new_vy )
end

function balls.increase_collision_counter( single_ball )
   single_ball.collision_counter = single_ball.collision_counter + 1
end

function balls.increase_speed_after_collision( single_ball )
   local speed_increase = 20
   local each_n_collisions = 10
   if single_ball.collision_counter ~= 0 and
      single_ball.collision_counter % each_n_collisions == 0 then
	 single_ball.speed = single_ball.speed +
	    single_ball.speed:normalized() * speed_increase
   end
end

function balls.reset()
   balls.no_more_balls = false
   for i in pairs( balls.current_balls ) do
      balls.current_balls[i] = nil
   end
   local position = platform_starting_pos +
      ball_platform_initial_separation
   local speed = vector( 0, 0 )
   local platform_launch_speed_magnitude = initial_launch_speed_magnitude
   local stuck_to_platform = true
   balls.add_ball( balls.new_ball(
		      position, speed,
		      platform_launch_speed_magnitude,
		      stuck_to_platform ) )
end

function balls.check_balls_escaped_from_screen()
   for i, single_ball in pairs( balls.current_balls ) do
      local x, y = single_ball.position:unpack()
      local ball_top = y - single_ball.radius
      if ball_top > love.graphics.getHeight() then
	 table.remove( balls.current_balls, i )
      end
   end
   if next( balls.current_balls ) == nil then
      balls.no_more_balls = true
   end
end

function balls.react_on_slow_down_bonus()
   local slowdown = 0.7
   for _, single_ball in pairs( balls.current_balls ) do
      single_ball.speed = single_ball.speed * slowdown
   end
end

function balls.react_on_accelerate_bonus()
   local accelerate = 1.3
   for _, single_ball in pairs( balls.current_balls ) do
      single_ball.speed = single_ball.speed * accelerate
   end
end

function balls.react_on_add_new_ball_bonus()
   local first_ball = balls.current_balls[1]
   local new_ball_position = first_ball.position:clone()
   local new_ball_speed = first_ball.speed:rotated( math.pi / 4 )
   local new_ball_launch_speed_magnitude =
      first_ball.platform_launch_speed_magnitude
   local new_ball_stuck = first_ball.stuck_to_platform
   balls.add_ball(
      balls.new_ball( new_ball_position, new_ball_speed,
		      new_ball_launch_speed_magnitude,
		      new_ball_stuck ) )
end

return balls
