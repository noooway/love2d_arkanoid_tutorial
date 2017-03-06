local vector = require "vector"

local bonuses = {}
bonuses.image = love.graphics.newImage( "img/800x600/bonuses.png" )
bonuses.tile_width = 64
bonuses.tile_height = 32
bonuses.tileset_width = 512
bonuses.tileset_height = 32
bonuses.radius = 14
bonuses.speed = vector( 0, 100 )
bonuses.current_level_bonuses = {}

function bonuses.new_bonus( position, bonustype )
   return( { position = position,
	     bonustype = bonustype,
	     quad = bonuses.bonustype_to_quad( bonustype ) } )
end

function bonuses.update_bonus( single_bonus, dt )
   single_bonus.position = single_bonus.position + bonuses.speed * dt
end

function bonuses.draw_bonus( single_bonus )
   if single_bonus.quad then
      love.graphics.draw(
	 bonuses.image,
	 single_bonus.quad, 
	 single_bonus.position.x - bonuses.tile_width / 2,
	 single_bonus.position.y - bonuses.tile_height / 2 )
   end
   local segments_in_circle = 16
   love.graphics.circle( 'line',
			 single_bonus.position.x,
			 single_bonus.position.y,
			 bonuses.radius,
			 segments_in_circle )
end

function bonuses.bonustype_to_quad( bonustype )
   if bonustype == nil or bonustype <= 10 or bonustype >= 20 then
      return nil
   end
   local row = math.floor( bonustype / 10 )
   local col = bonustype % 10
   local x_pos = bonuses.tile_width * ( col - 1 )
   local y_pos = bonuses.tile_height * ( row - 1 )
   return love.graphics.newQuad(
      x_pos, y_pos,
      bonuses.tile_width, bonuses.tile_height,
      bonuses.tileset_width, bonuses.tileset_height )
end

function bonuses.update( dt )
   for _, bonus in pairs( bonuses.current_level_bonuses ) do
      bonuses.update_bonus( bonus, dt )
   end
end

function bonuses.draw()
   for _, bonus in pairs( bonuses.current_level_bonuses ) do
      bonuses.draw_bonus( bonus )
   end
end

function bonuses.add_bonus( bonus )
   table.insert( bonuses.current_level_bonuses, bonus )
end

function bonuses.clear_current_level_bonuses()
   for i in pairs( bonuses.current_level_bonuses ) do
      bonuses.current_level_bonuses[i] = nil
   end
end

function bonuses.bonus_collected( i, bonus, ball, platform )
   if bonuses.is_slowdown( bonus ) then
      ball.react_on_slow_down_bonus()
   elseif bonuses.is_accelerate( bonus ) then
      ball.react_on_accelerate_bonus()
   elseif bonuses.is_increase( bonus ) then
      platform.react_on_increase_bonus()
   elseif bonuses.is_decrease( bonus ) then
      platform.react_on_decrease_bonus()      
   end
   table.remove( bonuses.current_level_bonuses, i )
end

function bonuses.is_slowdown( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 1 )
end

function bonuses.is_accelerate( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 5 )
end

function bonuses.is_increase( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 3 )
end

function bonuses.is_decrease( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 6 )
end

return bonuses
