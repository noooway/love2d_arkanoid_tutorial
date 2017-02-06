local vector = require "vector"

local bricks = {}
bricks.image = love.graphics.newImage( "img/800x600/bricks.png" )
bricks.tile_width = 64
bricks.tile_height = 32
bricks.tileset_width = 384
bricks.tileset_height = 160
bricks.rows = 11
bricks.columns = 8
bricks.top_left_position = vector( 47, 34 )
bricks.brick_width = bricks.tile_width
bricks.brick_height = bricks.tile_height
bricks.horizontal_distance = 0
bricks.vertical_distance = 0
bricks.current_level_bricks = {}
bricks.no_more_bricks = false

function bricks.new_brick( position, width, height, bricktype )
   return( { position = position,
	     width = width or bricks.brick_width,
	     height = height or bricks.brick_height,
	     bricktype = bricktype,
	     quad = bricks.bricktype_to_quad( bricktype ) } )
end

function bricks.update_brick( single_brick )   
end

function bricks.draw_brick( single_brick )
   love.graphics.rectangle( 'line',
			    single_brick.position.x,
			    single_brick.position.y,
			    single_brick.width,
			    single_brick.height )
   if single_brick.quad then
      love.graphics.draw( bricks.image,
			  single_brick.quad, 
			  single_brick.position.x,
			  single_brick.position.y )
   end
end

function bricks.bricktype_to_quad( bricktype )
   if bricktype == nil or bricktype <= 10 then
      return nil
   end
   local row = math.floor( bricktype / 10 )
   local col = bricktype % 10
   local x_pos = bricks.tile_width * ( col - 1 )
   local y_pos = bricks.tile_height * ( row - 1 )
   return love.graphics.newQuad( x_pos, y_pos,
                                 bricks.tile_width, bricks.tile_height,
                                 bricks.tileset_width, bricks.tileset_height )

end

function bricks.construct_level( level_bricks_arrangement )
   bricks.no_more_bricks = false
   for row_index, row in pairs( level_bricks_arrangement ) do
      for col_index, bricktype in pairs( row ) do
	 if bricktype ~= 0 then
	    local new_brick_position_x = bricks.top_left_position.x +
	       ( col_index - 1 ) *
	       ( bricks.brick_width + bricks.horizontal_distance )
	    local new_brick_position_y = bricks.top_left_position.y +
	       ( row_index - 1 ) *
	       ( bricks.brick_height + bricks.vertical_distance )
	    local new_brick_position = vector( new_brick_position_x,
					       new_brick_position_y )
	    local new_brick = bricks.new_brick( new_brick_position,
						bricks.brick_width,
						bricks.brick_height,
						bricktype )
	    table.insert( bricks.current_level_bricks, new_brick )
	 end
      end
   end
end

function bricks.update( dt )
   if #bricks.current_level_bricks == 0 then
      bricks.no_more_bricks = true
   end
end

function bricks.draw()
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.draw_brick( brick )
   end
end

function bricks.brick_hit_by_ball( i, brick, shift_ball )
   table.remove( bricks.current_level_bricks, i )
end

function bricks.clear_current_level_bricks()
   for i in pairs( bricks.current_level_bricks ) do
      bricks.current_level_bricks[i] = nil
   end
end

return bricks
