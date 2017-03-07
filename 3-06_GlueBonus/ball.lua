local vector = require "vector"
local sign = math.sign or function(x) return x < 0 and -1 or x > 0 and 1 or 0 end

local ball = {}
local first_launch_speed = vector( -150, -300 )
ball.platform_launch_speed = first_launch_speed:clone()
ball.speed = vector( 0, 0 )
ball.image = love.graphics.newImage( "img/800x600/ball.png" )
ball.x_tile_pos = 0
ball.y_tile_pos = 0
ball.tile_width = 18
ball.tile_height = 18
ball.tileset_width = 18
ball.tileset_height = 18
ball.quad = love.graphics.newQuad( ball.x_tile_pos, ball.y_tile_pos,
				   ball.tile_width, ball.tile_height,
				   ball.tileset_width, ball.tileset_height )
ball.radius = ball.tile_width / 2
ball.collision_counter = 0
local ball_x_shift = -28
local platform_height = 16
local platform_starting_pos = vector( 300, 500 )
ball.stuck_to_platform = true
ball.separation_from_platform_center = vector(
   ball_x_shift, -1 * platform_height / 2 - ball.radius - 1 )
ball.position = platform_starting_pos +
   ball.separation_from_platform_center


function ball.update( dt, platform )
   ball.position = ball.position + ball.speed * dt
   if ball.stuck_to_platform then
      ball.follow_platform( platform )
   end
   ball.check_escape_from_screen()   
end

function ball.draw()
   love.graphics.draw( ball.image,
   		       ball.quad, 
   		       ball.position.x - ball.radius,
   		       ball.position.y - ball.radius )
end

function ball.follow_platform( platform )   
   local platform_center = vector(
      platform.position.x + platform.width / 2,
      platform.position.y + platform.height / 2 )
   ball.position = platform_center + ball.separation_from_platform_center
end

function ball.launch_from_platform()
   if ball.stuck_to_platform then
      ball.stuck_to_platform = false
      ball.speed = ball.platform_launch_speed:clone()
   end
end

function ball.wall_rebound( shift_ball )
   ball.normal_rebound( shift_ball )
   ball.min_angle_rebound()
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
end

function ball.platform_rebound( shift_ball, platform )
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
   if not platform.glued then
      ball.normal_rebound( shift_ball )
      ball.rotate_speed( shift_ball, platform )
   else
      ball.normal_rebound( shift_ball )
      ball.rotate_speed( shift_ball, platform )
      ball.platform_launch_speed = ball.speed:clone()
      ball.stuck_to_platform = true      
      ball.speed = vector( 0, 0 )
      local platform_center = vector(
      	 platform.position.x + platform.width / 2,
      	 platform.position.y + platform.height / 2 )
      local ball_center = ball.position:clone()
      ball.separation_from_platform_center =
      	 ball_center - platform_center
      print( ball.separation_from_platform_center )
   end
end

function ball.brick_rebound( shift_ball )
   ball.normal_rebound( shift_ball )
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
end

function ball.normal_rebound( shift_ball )
   local actual_shift = ball.determine_actual_shift( shift_ball )
   ball.position = ball.position + actual_shift
   if actual_shift.x ~= 0 then
      ball.speed.x = -ball.speed.x
   end
   if actual_shift.y ~= 0 then
      ball.speed.y = -ball.speed.y
   end
end

function ball.determine_actual_shift( shift_ball )
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

function ball.rotate_speed( shift_ball, platform )
   local actual_shift = ball.determine_actual_shift( shift_ball )
   if actual_shift.y ~= 0 then
      local max_rotation_degrees = 30
      local ball_center = ball.position
      local platform_center = platform.position +
	 vector( platform.width / 2, platform.height / 2  )
      local separation = ( ball_center - platform_center )
      local rotation_deg = separation.x / ( platform.width / 2 ) *
	 max_rotation_degrees
      local rotation_rad = rotation_deg / 180 * math.pi      
      ball.speed:rotate_inplace( rotation_rad )
   end
end

function ball.min_angle_rebound()
   local min_horizontal_rebound_angle = math.rad( 20 )
   local vx, vy = ball.speed:unpack()
   local new_vx, new_vy = vx, vy
   rebound_angle = math.abs( math.atan( vy / vx ) )
   if rebound_angle < min_horizontal_rebound_angle then
      new_vx = sign( vx ) * ball.speed:len() *
	 math.cos( min_horizontal_rebound_angle )
      new_vy = sign( vy ) * ball.speed:len() *
	 math.sin( min_horizontal_rebound_angle )
   end
   ball.speed = vector( new_vx, new_vy )
end

function ball.increase_collision_counter()
   ball.collision_counter = ball.collision_counter + 1
end

function ball.increase_speed_after_collision()
   local speed_increase = 20
   local each_n_collisions = 10
   if ball.collision_counter ~= 0 and
      ball.collision_counter % each_n_collisions == 0 then
      ball.speed = ball.speed + ball.speed:normalized() * speed_increase
   end
end

function ball.reposition()
   ball.escaped_screen = false
   ball.collision_counter = 0
   ball.stuck_to_platform = true
   ball.speed = vector( 0, 0 )
end

function ball.check_escape_from_screen()
   local x, y = ball.position:unpack()
   local ball_top = y - ball.radius
   if ball_top > love.graphics.getHeight() then
      ball.escaped_screen = true
   end
end

function ball.react_on_slow_down_bonus()
   local slowdown = 0.7
   ball.speed = ball.speed * slowdown
end

function ball.react_on_accelerate_bonus()
   local accelerate = 1.3
   ball.speed = ball.speed * accelerate
end

return ball
