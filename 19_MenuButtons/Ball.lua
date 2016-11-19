local vector = require "vector"
local love = love
local setmetatable = setmetatable
local math = math
local print = print
local sign = math.sign or function(x) return x < 0 and -1 or x > 0 and 1 or 0 end

local Ball = {}

if setfenv then
   setfenv(1, Ball) -- for 5.1
else
   _ENV = Ball -- for 5.2
end

image = love.graphics.newImage( "img/800x600/ball.png" )
local x_tile_pos = 0
local y_tile_pos = 0
local ball_tile_width = 18
local ball_tile_height = 18
local tileset_width = 18
local tileset_height = 18

local platform_starting_x_pos = 150
local platform_starting_y_pos = 500
local platform_height = 16
local ball_x_shift = 28
local first_launch_magnitude = 350

function Ball:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "ball"
   o.radius = o.radius or ball_tile_width / 2
   if o.stuck_to_platform == nil then
      o.stuck_to_platform = true
   end
   o.separation_from_platform_center = o.separation_from_platform_center or
      vector( -ball_x_shift,
	      (-1) * platform_height / 2 - o.radius - 1 )
   o.position = o.position or
      vector( platform_starting_x_pos + o.separation_from_platform_center.x,
	      platform_starting_y_pos + o.separation_from_platform_center.y )
   o.platform_launch_speed_magnitude =
      o.platform_launch_speed_magnitude or first_launch_magnitude
   o.speed = o.speed or vector( 0, 0 )
   o.collider = o.collider or {}
   o.collider_shape = o.collider:circle( o.position.x,
					 o.position.y,
					 o.radius )
   o.collider_shape.game_object = o
   o.quad = o.quad or love.graphics.newQuad( x_tile_pos, y_tile_pos,
					     ball_tile_width, ball_tile_height,
					     tileset_width, tileset_height )
   o.collision_counter = 0
   o.collision_speed_multiplier = 1.03
   return o
end

function Ball:update( dt, platform )
   self.position = self.position + self.speed * dt
   if self.stuck_to_platform then
      self:follow_platform( platform )
   end
   self.collider_shape:moveTo( self.position:unpack() )
end

function Ball:draw()
   love.graphics.draw( self.image,
   		       self.quad, 
   		       self.position.x - self.radius,
   		       self.position.y - self.radius )
end

function Ball:follow_platform( platform )   
   local platform_center = vector( platform.position.x + platform.width / 2,
				   platform.position.y + platform.height / 2 )
   self.position = platform_center + self.separation_from_platform_center
end

function Ball:launch_from_platform( platform )
   self.stuck_to_platform = false
   local max_angle_from_normal = 30
   local ball_center = vector( self.collider_shape:center() ) 
   local platform_center = vector( platform.collider_shape:center() )
   local separation = ( ball_center - platform_center )
   local launch_angle = separation.x / ( platform.width / 2 ) * max_angle_from_normal
   local launch_angle_rad = launch_angle / 180 * math.pi      
   local direction = vector( math.sin( launch_angle_rad ),
			     -math.cos( launch_angle_rad ) )
   self.speed = self.platform_launch_speed_magnitude * direction
end

function Ball:react_on_wall_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position:unpack() )
   self:normal_rebound( separating_vector )
   self:min_angle_rebound()
   self:increase_collision_counter()
   self:increase_speed_after_collision()
end

function Ball:react_on_brick_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position:unpack() )
   self:normal_rebound( separating_vector )
   self:increase_collision_counter()
   self:increase_speed_after_collision()
end

function Ball:react_on_platform_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position:unpack() )
   if not another_shape.game_object.sticky then
      self:platform_rebound( another_shape, separating_vector )
   else
      self.stuck_to_platform = true
      self.platform_launch_speed_magnitude = self.speed:len()
      self.speed = vector( 0, 0 )
      local platform_center = vector( another_shape:center() )
      local ball_center = vector( self.collider_shape:center() )
      self.separation_from_platform_center = ball_center - platform_center
   end
   self:increase_collision_counter()
   self:increase_speed_after_collision()
end

function Ball:normal_rebound( separating_vector )
   local big_enough_overlap = 0.5
   local vx, vy = self.speed:unpack()
   local dx, dy = separating_vector.x, separating_vector.y
   local new_vx, new_vy
   if math.abs( dx ) > big_enough_overlap then
      new_vx = -vx
   else
      new_vx = vx
   end
   if math.abs( dy ) > big_enough_overlap then
      new_vy = -vy
   else
      new_vy = vy
   end
   self.speed = vector( new_vx, new_vy )
end

function Ball:platform_rebound( another_shape, separating_vector )
   local big_enough_overlap = 0.5
   local platform_width = another_shape.game_object.width
   local dx, dy = separating_vector.x, separating_vector.y
   if ( math.abs( dx ) > big_enough_overlap ) then
      -- todo: when platform moves and hits ball with side
      self:inverse_speed_horizontal()
   end
   if ( math.abs( dy ) > big_enough_overlap ) then
      self:inverse_speed_vertical()
      local max_rotation_degrees = 30
      local ball_center = vector( self.collider_shape:center() ) 
      local platform_center = vector( another_shape:center() )
      local separation = ( ball_center - platform_center )
      local rotation_deg = separation.x / ( platform_width / 2 ) * max_rotation_degrees
      local rotation_rad = rotation_deg / 180 * math.pi      
      self.speed:rotate_inplace( rotation_rad )
   end
end

function Ball:min_angle_rebound()
   local min_horizontal_rebound_angle = math.rad( 20 )
   local vx, vy = self.speed:unpack()
   local new_vx, new_vy = vx, vy
   rebound_angle = math.abs( math.atan( vy / vx ) )
   if rebound_angle < min_horizontal_rebound_angle then
      new_vx = sign( vx ) * 
	 math.sqrt( vx * vx + vy * vy ) *
	 math.cos( min_horizontal_rebound_angle )
      new_vy = sign( vy ) * 
	 math.sqrt( vx * vx + vy * vy ) *
	 math.sin( min_horizontal_rebound_angle )
   end
   self.speed = vector( new_vx, new_vy )
end

function Ball:inverse_speed_horizontal()
   self.speed = vector( -1 * self.speed.x, self.speed.y )
end

function Ball:inverse_speed_vertical()
   self.speed = vector( self.speed.x, -1 * self.speed.y )
end

function Ball:increase_collision_counter()
   self.collision_counter = self.collision_counter + 1 
end

function Ball:increase_speed_after_collision()
   if self.collision_counter % 5 == 0 then
      self.speed = self.speed * self.collision_speed_multiplier
   end
end

function Ball:react_on_slow_down_bonus()
   local slowdown = 0.7
   self.speed = self.speed * slowdown
end

function Ball:react_on_accelerate_bonus()
   local accelerate = 1.3
   self.speed = self.speed * accelerate
end

return Ball
