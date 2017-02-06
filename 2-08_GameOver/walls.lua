local vector = require "vector"

local walls = {}
walls.side_walls_thickness = 34
walls.top_wall_thickness = 26
walls.right_border_x_pos = 576
walls.current_level_walls = {}

function walls.new_wall( position, width, height )
   return( { position = position,
	     width = width,
	     height = height } )
end

function walls.update_wall( single_wall )
end

function walls.draw_wall( single_wall )
   love.graphics.rectangle( 'line',
			    single_wall.position.x,
			    single_wall.position.y,
			    single_wall.width,
			    single_wall.height )
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 255, 0, 0, 100 )
   love.graphics.rectangle( 'fill',
			    single_wall.position.x,
			    single_wall.position.y,
			    single_wall.width,
			    single_wall.height )
   love.graphics.setColor( r, g, b, a )
end

function walls.construct_walls()
   local left_wall = walls.new_wall(
      vector( 0, 0 ),
      walls.side_walls_thickness,
      love.graphics.getHeight()
   )
   local right_wall = walls.new_wall(
      vector( walls.right_border_x_pos, 0 ),
      walls.side_walls_thickness,
      love.graphics.getHeight()
   )
   local top_wall = walls.new_wall(
      vector( 0, 0 ),
      walls.right_border_x_pos,
      walls.top_wall_thickness
   )
   walls.current_level_walls["left"] = left_wall
   walls.current_level_walls["right"] = right_wall
   walls.current_level_walls["top"] = top_wall
end

function walls.update( dt )
end

function walls.draw()
   for _, wall in pairs( walls.current_level_walls ) do
      walls.draw_wall( wall )
   end
end

return walls
