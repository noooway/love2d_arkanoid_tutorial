-- Ball
local ball = {}
ball.position_x = 200
ball.position_y = 500
ball.speed_x = 700
ball.speed_y = 700
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
   local min_shift = math.min( math.abs( shift_ball_x ),
			       math.abs( shift_ball_y ) )
   if math.abs( shift_ball_x ) == min_shift then
      shift_ball_y = 0
   else
      shift_ball_x = 0
   end
   ball.position_x = ball.position_x + shift_ball_x
   ball.position_y = ball.position_y + shift_ball_y
   if shift_ball_x ~= 0 then
      ball.speed_x  = -ball.speed_x
   end
   if shift_ball_y ~= 0 then
      ball.speed_y  = -ball.speed_y
   end
end

function ball.reposition()
   ball.position_x = 200
   ball.position_y = 500   
end


-- Platform
local platform = {}
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 500
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
   platform.position_x = platform.position_x + shift_platform_x
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
bricks.no_more_bricks = false

function bricks.new_brick( position_x, position_y, width, height )
   return( { position_x = position_x,
	     position_y = position_y,
	     width = width or bricks.brick_width,
	     height = height or bricks.brick_height } )
end

function bricks.add_to_current_level_bricks( brick )
   table.insert( bricks.current_level_bricks, brick )
end

function bricks.update_brick( single_brick )   
end

function bricks.draw_brick( single_brick )
   love.graphics.rectangle( 'line',
			    single_brick.position_x,
			    single_brick.position_y,
			    single_brick.width,
			    single_brick.height )   
end

function bricks.construct_level( level_bricks_arrangement )
   bricks.no_more_bricks = false
   local row_index = 0
   for row in level_bricks_arrangement:gmatch( '(.-)\n' ) do
      row_index = row_index + 1
      local col_index = 0
      for bricktype in row:gmatch('.') do
	 col_index = col_index + 1
	 if bricktype == '#' then
	    local new_brick_position_x = bricks.top_left_position_x +
	       ( col_index - 1 ) *
	       ( bricks.brick_width + bricks.horizontal_distance )
	    local new_brick_position_y = bricks.top_left_position_y +
	       ( row_index - 1 ) *
	       ( bricks.brick_height + bricks.vertical_distance )
	    local new_brick = bricks.new_brick( new_brick_position_x,
						new_brick_position_y )
	    bricks.add_to_current_level_bricks( new_brick )
	 end
      end
   end
end

function bricks.update( dt )
   if #bricks.current_level_bricks == 0 then
      bricks.no_more_bricks = true
   else
      for _, brick in pairs( bricks.current_level_bricks ) do
	 bricks.update_brick( brick )
      end      
   end
end

function bricks.draw()
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.draw_brick( brick )
   end
end

function bricks.brick_hit_by_ball( i, brick, shift_ball_x, shift_ball_y )
   table.remove( bricks.current_level_bricks, i )
end

-- Walls 
local walls = {}
walls.wall_thickness = 20
walls.current_level_walls = {}

function walls.new_wall( position_x, position_y, width, height )
   return( { position_x = position_x,
	     position_y = position_y,
	     width = width,
	     height = height } )
end

function walls.update_wall( single_wall )
end

function walls.draw_wall( single_wall )
   love.graphics.rectangle( 'line',
			    single_wall.position_x,
			    single_wall.position_y,
			    single_wall.width,
			    single_wall.height )
end

function walls.construct_walls()
   local left_wall = walls.new_wall(
      0,
      0,
      walls.wall_thickness,
      love.graphics.getHeight()
   )
   local right_wall = walls.new_wall(
      love.graphics.getWidth() - walls.wall_thickness,
      0,
      walls.wall_thickness,
      love.graphics.getHeight()
   )
   local top_wall = walls.new_wall(
      0,
      0,
      love.graphics.getWidth(),
      walls.wall_thickness
   )
   local bottom_wall = walls.new_wall(
      0,
      love.graphics.getHeight() - walls.wall_thickness,
      love.graphics.getWidth(),
      walls.wall_thickness
   ) 
   walls.current_level_walls["left"] = left_wall
   walls.current_level_walls["right"] = right_wall
   walls.current_level_walls["top"] = top_wall
   walls.current_level_walls["bottom"] = bottom_wall
end

function walls.update( dt )
   for _, wall in pairs( walls.current_level_walls ) do
      walls.update_wall( wall )
   end
end

function walls.draw()
   for _, wall in pairs( walls.current_level_walls ) do
      walls.draw_wall( wall )
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
   local shift_b_x, shift_b_y = 0, 0
   if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
	   a.y + a.height < b.y or b.y + b.height < a.y ) then
      overlap = true
      if ( a.x + a.width / 2 ) < ( b.x + b.width / 2 ) then
	 shift_b_x = ( a.x + a.width ) - b.x
      else 
	 shift_b_x = a.x - ( b.x + b.width )
      end
      if ( a.y + a.height / 2 ) < ( b.y + b.height / 2 ) then
	 shift_b_y = ( a.y + a.height ) - b.y
      else
	 shift_b_y = a.y - ( b.y + b.height )      
      end      
   end
   return overlap, shift_b_x, shift_b_y
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
   overlap, shift_ball_x, shift_ball_y =
      collisions.check_rectangles_overlap( a, b )   
   if overlap then
      ball.rebound( shift_ball_x, shift_ball_y )
   end      
end

function collisions.ball_walls_collision( ball, walls )
   local overlap, shift_ball_x, shift_ball_y
   local b = { x = ball.position_x - ball.radius,
	       y = ball.position_y - ball.radius,
	       width = 2 * ball.radius,
	       height = 2 * ball.radius }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { x = wall.position_x,
		  y = wall.position_y,
		  width = wall.width,
		  height = wall.height }      
      overlap, shift_ball_x, shift_ball_y =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then
	 ball.rebound( shift_ball_x, shift_ball_y )
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
      local a = { x = brick.position_x,
		  y = brick.position_y,
		  width = brick.width,
		  height = brick.height }
      overlap, shift_ball_x, shift_ball_y =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then	 
	 ball.rebound( shift_ball_x, shift_ball_y )
	 bricks.brick_hit_by_ball( i, brick,
				   shift_ball_x, shift_ball_y )
      end
   end
end

function collisions.platform_walls_collision()
   local overlap, shift_platform_x, shift_platform_y
   local b = { x = platform.position_x,
	       y = platform.position_y,
	       width = platform.width,
	       height = platform.height }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { x = wall.position_x,
		  y = wall.position_y,
		  width = wall.width,
		  height = wall.height }      
      overlap, shift_platform_x, shift_platform_y =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then	 
	 platform.bounce_from_wall( shift_platform_x,
				    shift_platform_y )
      end
   end
end

-- Levels
local levels = {}
levels.current_level = 1
levels.gamefinished = false
levels.sequence = {}
levels.sequence[1] = [[
___________

# # ### # #
# # #   # #
### ##   # 
# # #    # 
# # ###  # 
___________
]]

levels.sequence[2] = [[
___________

##  # # ###
# # # # #  
###  #  ## 
# #  #  #  
###  #  ###
___________
]]

function levels.switch_to_next_level( bricks )
   if bricks.no_more_bricks then
      if levels.current_level < #levels.sequence then
	 levels.current_level = levels.current_level + 1
	 bricks.construct_level( levels.sequence[levels.current_level] )
	 ball.reposition()
      else
	 levels.gamefinished = true
      end
   end
end



function love.load()
   bricks.construct_level( levels.sequence[levels.current_level] )
   walls.construct_walls()
end
 
function love.update( dt )
   ball.update( dt )
   platform.update( dt )
   bricks.update( dt )
   walls.update( dt )
   collisions.resolve_collisions()
   levels.switch_to_next_level( bricks )
end
 
function love.draw()
   ball.draw()
   platform.draw()
   bricks.draw()
   walls.draw()
   if levels.gamefinished then
      love.graphics.printf( "Congratulations!\n" ..
			       "You have finished the game!",
			    300, 250, 200, "center" )
   end
end

function love.keyreleased( key, code )
   if  key == 'escape' then
      love.event.quit()
   end    
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
