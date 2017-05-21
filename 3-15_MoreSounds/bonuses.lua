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

local bonus_collected_sound = {
   love.audio.newSource("sounds/bonus/bonus1.wav", "static"),
   love.audio.newSource("sounds/bonus/bonus2.wav", "static"),
   love.audio.newSource("sounds/bonus/bonus3.wav", "static")
}

local snd_rng = love.math.newRandomGenerator( os.time() )

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
   else
      local segments_in_circle = 16
      love.graphics.circle( 'line',
			    single_bonus.position.x,
			    single_bonus.position.y,
			    bonuses.radius,
			    segments_in_circle )
   end
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

function bonuses.bonus_collected( i, bonus,
				  balls, platform,
				  walls, lives_display )
   if not bonuses.is_glue( bonus ) then
      platform.remove_glued_effect()
      balls.launch_all_balls_from_platform()
   end
   if bonuses.is_slowdown( bonus ) then
      balls.react_on_slow_down_bonus()
   elseif bonuses.is_accelerate( bonus ) then
      balls.react_on_accelerate_bonus()
   elseif bonuses.is_increase( bonus ) then
      platform.react_on_increase_bonus()
   elseif bonuses.is_decrease( bonus ) then
      platform.react_on_decrease_bonus()
   elseif bonuses.is_glue( bonus ) then
      platform.react_on_glue_bonus()
   elseif bonuses.is_add_new_ball( bonus ) then
      balls.react_on_add_new_ball_bonus()
   elseif bonuses.is_life( bonus ) then
      lives_display.add_life()
   elseif bonuses.is_next_level( bonus ) then
      walls.current_level_walls["right"].next_level_bonus = true
   end
   table.remove( bonuses.current_level_bonuses, i )
   local snd = bonus_collected_sound[ snd_rng:random( #bonus_collected_sound ) ]
   snd:play()
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

function bonuses.is_glue( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 2 )
end

function bonuses.is_add_new_ball( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 4 )
end

function bonuses.is_life( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 8 )
end

function bonuses.is_next_level( single_bonus )
   local col = single_bonus.bonustype % 10
   return ( col == 7 )
end

function bonuses.bonustype_denotes_random( bonustype )
   return bonustype == 0
end

function bonuses.generate_bonus( position, bonustype )
   if bonuses.bonustype_denotes_random( bonustype ) then
      bonustype = bonuses.random_bonustype()
   end
   if bonuses.valid_bonustype( bonustype ) then
      bonuses.add_bonus( bonuses.new_bonus( position, bonustype ) )
   end
end

function bonuses.valid_bonustype( bonustype )
   if bonustype and bonustype > 10 and bonustype < 19 then
      return true
   else
      return false
   end
end

local bonustype_rng = love.math.newRandomGenerator( os.time() )

function bonuses.random_bonustype()
   local bonustype
   local prob = bonustype_rng:random( 400 )
   if prob == 400 then
      bonustype = bonuses.choose_random_valuable_bonus()
   elseif prob >= 360 then
      bonustype = bonuses.choose_random_common_bonus()
   else
      bonustype = nil
   end
   return bonustype
end

function bonuses.choose_random_valuable_bonus()
   local valuable_bonustypes = { 17, 18 }
   return valuable_bonustypes[
      bonustype_rng:random( #valuable_bonustypes )]
end

function bonuses.choose_random_common_bonus()
   local common_bonustypes = { 11, 12, 13, 14, 15, 16 }
   return common_bonustypes[ bonustype_rng:random( #common_bonustypes )]
end

return bonuses
