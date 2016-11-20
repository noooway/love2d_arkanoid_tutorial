local Gamestate = require "gamestate"
local gamepaused = gamepaused or require "gamepaused"
local gamefinished = gamefinished or require "gamefinished"
local Platform = require "Platform"
local BallsContainer = require "BallsContainer"
local BricksContainer = require "BricksContainer"
local WallsContainer = require "WallsContainer"
local BonusesContainer = require "BonusesContainer"
local ScoreDisplay = require "ScoreDisplay"
local LifeDisplay = require "LifeDisplay"
local HC = require "HC"
local vector = require "vector"
local love = love
local require = require
local pairs = pairs
local print = print

local game = game or {}

if setfenv then
   setfenv(1, game)
else
   _ENV = game
end

state_name = "game"

function game:enter( previous_state, ... )
   args = ...

   level_sequence = args.level_sequence or require "levels/sequence"
   level_counter = args.level_counter or 1
   if level_counter > #level_sequence.sequence then
      Gamestate.switch( gamefinished )
   end
   level_filename = "levels/" .. level_sequence.sequence[ level_counter ]
   level = args.level or require( level_filename )
   collider = args.collider or HC.new()
   platform = args.platform or Platform:new( { collider = collider } )
   balls_container = args.balls_container or
      BallsContainer:new( { collider = collider } )
   bonuses_container = args.bonuses_container or
      BonusesContainer:new( { collider = collider } )
   bricks_container = args.bricks_container or
      BricksContainer:new( { level = level,
			     collider = collider,
			     bonuses_container = bonuses_container } )
   walls_container = args.walls_container or
      WallsContainer:new( { collider = collider } )
   score_display = args.score_display or
      ScoreDisplay:new( {} )
   life_display = args.life_display or
      LifeDisplay:new( {} )
end

function game:update( dt )
   platform:update( dt )
   balls_container:update( dt, platform )
   bricks_container:update( dt )
   bonuses_container:update( dt )
   walls_container:update( dt )
   score_display:update( dt )
   life_display:update( dt )
   resolve_collisions( dt )
   switch_to_next_level()
end

function game:draw()
   platform:draw()
   balls_container:draw()
   bricks_container:draw()
   bonuses_container:draw()
   walls_container:draw()
   score_display:draw()
   life_display:draw()
end

function resolve_collisions( dt )
   -- Platform
   local collisions = collider:collisions( platform.collider_shape )
   for another_shape, separating_vector in pairs( collisions ) do
      if another_shape.game_object.name == "wall" then
	 platform:react_on_wall_collision( another_shape, separating_vector )
	 if another_shape.game_object:next_level_portal_active() then
	    game:react_on_next_level_bonus()
	 end
      elseif another_shape.game_object.name == "bonus" then
	 local picked_bonus = another_shape.game_object
	 if platform.sticky and ( not picked_bonus:is_glue() ) then
	    platform:make_nonsticky()
	    balls_container:launch_all_stuck_balls( platform )
	 end
	 if picked_bonus:is_slowdown() then
	    balls_container:react_on_slow_down_bonus()
	 elseif picked_bonus:is_accelerate() then
	    balls_container:react_on_accelerate_bonus()
	 elseif picked_bonus:is_increase() then
	    platform:react_on_increase_bonus()
	 elseif picked_bonus:is_decrease() then
	    platform:react_on_decrease_bonus()
	 elseif picked_bonus:is_add_new_ball() then
	    balls_container:react_on_add_new_ball_bonus()
	 elseif picked_bonus:is_glue() then
	    platform:react_on_glue_bonus()
	 elseif picked_bonus:is_life() then
	    life_display:add_new_life()
	 elseif picked_bonus:is_next_level() then
	    walls_container:react_on_next_level_bonus()
	 end
	 another_shape.game_object:react_on_platform_collision(
	    platform.collider_shape,
	    (-1) * vector( separating_vector.x, separating_vector.y ) )
      end
   end
   -- Balls
   for _, ball in pairs( balls_container.balls ) do
      local collisions = collider:collisions( ball.collider_shape )
      for another_shape, separating_vector in pairs( collisions ) do
	 if another_shape.game_object.name == "wall" then
	    ball:react_on_wall_collision( another_shape, separating_vector )
	 elseif another_shape.game_object.name == "platform" then
	    ball:react_on_platform_collision( another_shape, separating_vector )
	 elseif another_shape.game_object.name == "brick" then
	    ball:react_on_brick_collision( another_shape, separating_vector )
	    another_shape.game_object:react_on_ball_collision(
	       ball.collider_shape,
	       (-1) * vector( separating_vector.x, separating_vector.y )  )
	    score_display:react_on_ball_brick_collision( another_shape )
	    life_display:add_life_if_score_reached( score_display.score )
	 end
      end
   end
end

function switch_to_next_level()
   if bricks_container.no_more_bricks then
      level_counter = level_counter + 1
      if level_counter > #level_sequence.sequence then
	 Gamestate.switch( gamefinished )
      else
	 Gamestate.switch( game, { level_sequence = level_sequence,
				   level_counter = level_counter,
				   collider = collider,
				   walls_container = walls_container,
				   score_display = score_display,
				   life_display = life_display } )
      end
   end
end

function game:react_on_next_level_bonus()
   level_counter = level_counter + 1 
   if level_counter <= #level_sequence.sequence then
      Gamestate.switch( game, { level_sequence = level_sequence,
				level_counter = level_counter,
				life_display = life_display,
				score_display = score_display } )
   else
      Gamestate.switch( gamefinished )
   end	
end

function game:keyreleased( key, code )
   balls_container:keyreleased( key, code, platform )
   if key == 'escape' then      
      Gamestate.switch( gamepaused,
			{ level_sequence = level_sequence,
			  level_counter = level_counter,
			  level = level,
			  collider = collider,
			  balls_container = balls_container,
			  platform = platform,
			  walls_container = walls_container,
			  bricks_container = bricks_container,			  
			  bonuses_container = bonuses_container,
			  score_display = score_display,
			  life_display = life_display } )
   end
end

function game:leave()
   level_sequence = nil
   level_counter = nil
   level_filename = nil
   level = nil
   collider = nil
   balls_container = nil
   platform = nil
   bricks_container = nil
   walls_container = nil
   bonuses_container = nil
   score_display = nil
   life_display = nil
end

return game
