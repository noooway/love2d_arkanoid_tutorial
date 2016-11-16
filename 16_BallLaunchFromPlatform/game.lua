local Gamestate = require "gamestate"
local gamepaused = gamepaused or require "gamepaused"
local gamefinished = gamefinished or require "gamefinished"
local Platform = require "Platform"
local BallsContainer = require "BallsContainer"
local BricksContainer = require "BricksContainer"
local WallsContainer = require "WallsContainer"
local BonusesContainer = require "BonusesContainer"
local HC = require "HC"
local vector = require "vector"
local love = love
local require = require
local pairs = pairs

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
end

function game:update( dt )
   platform:update( dt )
   balls_container:update( dt, platform )
   bricks_container:update( dt )
   bonuses_container:update( dt )
   walls_container:update( dt )
   resolve_collisions( dt )
   switch_to_next_level()
end

function game:draw()
   platform:draw()
   balls_container:draw()
   bricks_container:draw()
   bonuses_container:draw()
   walls_container:draw()
end

function resolve_collisions( dt )
   -- Platform
   local collisions = collider:collisions( platform.collider_shape )
   for another_shape, separating_vector in pairs( collisions ) do
      if another_shape.game_object.name == "wall" then
	 platform:react_on_wall_collision( another_shape, separating_vector )
      elseif another_shape.game_object.name == "bonus" then
	 local picked_bonus = another_shape.game_object
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
				   walls_container = walls_container } )
      end
   end
end

function game:keyreleased( key, code )
   balls_container:keyreleased( key, code )
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
			  bonuses_container = bonuses_container } )
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
end

return game
