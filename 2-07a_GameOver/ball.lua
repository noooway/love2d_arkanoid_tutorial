local vector = require "vector"

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

function ball.rebound( shift_ball )
   local min_shift = math.min( math.abs( shift_ball.x ),
			       math.abs( shift_ball.y ) )
   if math.abs( shift_ball.x ) == min_shift then
      shift_ball.y = 0
   else
      shift_ball.x = 0
   end
   ball.position = ball.position + shift_ball
   if shift_ball.x ~= 0 then
      ball.speed.x = -ball.speed.x
   end
   if shift_ball.y ~= 0 then
      ball.speed.y = -ball.speed.y
   end
end

function ball.reposition()
   ball.escaped_screen = false
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
