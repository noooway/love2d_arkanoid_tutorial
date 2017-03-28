local vector = require "vector"
local sign = math.sign or function(x) return x < 0 and -1 or x > 0 and 1 or 0 end

local ball = {}
ball.position = vector( 200, 450 )
ball.speed = vector( -250, -250 )
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


function ball.update( dt )
   ball.position = ball.position + ball.speed * dt
   ball.check_escape_from_screen()
end

function ball.draw()
   love.graphics.draw( ball.image,
   		       ball.quad, 
   		       ball.position.x - ball.radius,
   		       ball.position.y - ball.radius )
end

function ball.wall_rebound( shift_ball )
   ball.normal_rebound( shift_ball )
   ball.min_angle_rebound()
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
end

function ball.platform_rebound( shift_ball, platform )
   ball.bounce_from_sphere( shift_ball, platform )
   ball.increase_collision_counter()
   ball.increase_speed_after_collision()
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

function ball.bounce_from_sphere( shift_ball, platform )
   local actual_shift = ball.determine_actual_shift( shift_ball )
   ball.position = ball.position + actual_shift
   if actual_shift.x ~= 0 then
      ball.speed.x = -ball.speed.x
   end
   if actual_shift.y ~= 0 then
      local sphere_radius = 200
      local ball_center = ball.position
      local platform_center = platform.position +
	 vector( platform.width / 2, platform.height / 2  )
      local separation = ( ball_center - platform_center )
      local normal_direction = vector( separation.x / sphere_radius, -1 )
      local v_norm = ball.speed:projectOn( normal_direction )
      local v_tan = ball.speed - v_norm
      local reverse_v_norm = v_norm * (-1)
      ball.speed = reverse_v_norm + v_tan
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
   ball.position = vector( 200, 500 )
   ball.speed = vector( -250, -250 )
end

function ball.check_escape_from_screen()
   local x, y = ball.position:unpack()
   local ball_top = y - ball.radius
   if ball_top > love.graphics.getHeight() then
      ball.escaped_screen = true
   end
end

return ball
