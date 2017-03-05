local vector = require "vector"

local platform = {}
platform.position = vector( 300, 500 )
platform.speed = vector( 800, 0 )
platform.image = love.graphics.newImage( "img/800x600/platform.png" )
platform.small_tile_width = 75
platform.small_tile_height = 16
platform.small_tile_x_pos = 0
platform.small_tile_y_pos = 0
platform.norm_tile_width = 108
platform.norm_tile_height = 16
platform.norm_tile_x_pos = 0
platform.norm_tile_y_pos = 32
platform.large_tile_width = 141
platform.large_tile_height = 16
platform.large_tile_x_pos = 0
platform.large_tile_y_pos = 64
platform.glued_x_pos_shift = 192
platform.tileset_width = 333
platform.tileset_height = 80
platform.quad = love.graphics.newQuad( platform.norm_tile_x_pos,
				       platform.norm_tile_y_pos,
				       platform.norm_tile_width,
				       platform.norm_tile_height,
				       platform.tileset_width,
				       platform.tileset_height )
platform.width = platform.norm_tile_width
platform.height = platform.norm_tile_height


function platform.update( dt )
   platform.follow_mouse( dt )
end

function platform.draw()
   love.graphics.draw( platform.image,
   		       platform.quad, 
   		       platform.position.x,
   		       platform.position.y )
end

function platform.follow_mouse( dt )
   local x, y = love.mouse.getPosition()
   local left_wall_plus_half_platform = 34 + platform.width / 2
   local right_wall_minus_half_platform = 576 - platform.width / 2
   if ( x > left_wall_plus_half_platform and
	x < right_wall_minus_half_platform ) then
      platform.position.x = x - platform.width / 2
   elseif x < left_wall_plus_half_platform then
      platform.position.x =
	 left_wall_plus_half_platform - platform.width / 2
   elseif x > right_wall_minus_half_platform then
      platform.position.x =
	 right_wall_minus_half_platform - platform.width / 2
   end
end

function platform.bounce_from_wall( shift_platform )
   platform.position.x = platform.position.x + shift_platform.x
end

return platform
