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

local simple_break_sound = love.audio.newSource(
   "sounds/recordered_glass_norm.ogg",
   "static")   
local armored_hit_sound = love.audio.newSource(
   "sounds/qubodupImpactMetal_short_norm.ogg",
   "static")
local armored_break_sound = love.audio.newSource(
   "sounds/armored_glass_break_short_norm.ogg",
   "static")
local ball_heavyarmored_sound = love.audio.newSource(
   "sounds/cast_iron_clangs_11_short_norm.ogg",
   "static")

function bricks.new_brick( position, width, height, bricktype )
   return( { position = position,
	     width = width or bricks.brick_width,
	     height = height or bricks.brick_height,
	     bricktype = bricktype,
	     quad = bricks.bricktype_to_quad( bricktype ) } )
end

function bricks.add_to_current_level_bricks( brick )
   table.insert( bricks.current_level_bricks, brick )
end

function bricks.update_brick( single_brick )   
end

function bricks.draw_brick( single_brick )
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
   for row_index, row in ipairs( level_bricks_arrangement ) do
      for col_index, bricktype in ipairs( row ) do
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
	    bricks.add_to_current_level_bricks( new_brick )
	 end
      end
   end
end

function bricks.clear_current_level_bricks()
   for i in pairs( bricks.current_level_bricks ) do
      bricks.current_level_bricks[i] = nil
   end
end

function bricks.update( dt )
   local no_more_bricks = true
   for _, brick in pairs( bricks.current_level_bricks ) do
      if bricks.is_heavyarmored( brick ) then
	 no_more_bricks = no_more_bricks and true
      else
	 no_more_bricks = no_more_bricks and false
      end
   end
   bricks.no_more_bricks = no_more_bricks
end

function bricks.draw()
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.draw_brick( brick )
   end
end

function bricks.brick_hit_by_ball( i, brick, shift_ball )
   if bricks.is_simple( brick ) then
      table.remove( bricks.current_level_bricks, i )
      simple_break_sound:play()
   elseif bricks.is_armored( brick ) then
      bricks.armored_to_scrathed( brick )
      armored_hit_sound:play()
   elseif bricks.is_scratched( brick ) then
      bricks.scrathed_to_cracked( brick )
      armored_hit_sound:play()
   elseif bricks.is_cracked( brick ) then
      table.remove( bricks.current_level_bricks, i )
      armored_break_sound:play()
   elseif bricks.is_heavyarmored( brick ) then
      ball_heavyarmored_sound:play()
   end
end

function bricks.is_simple( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 1 )
end

function bricks.is_armored( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 2 )
end

function bricks.is_scratched( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 3 )
end

function bricks.is_cracked( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 4 )
end

function bricks.is_heavyarmored( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 5 )
end

function bricks.armored_to_scrathed( single_brick )
   single_brick.bricktype = single_brick.bricktype + 10
   single_brick.quad = bricks.bricktype_to_quad( single_brick.bricktype )
end

function bricks.scrathed_to_cracked( single_brick )
   single_brick.bricktype = single_brick.bricktype + 10
   single_brick.quad = bricks.bricktype_to_quad( single_brick.bricktype )
end

return bricks
