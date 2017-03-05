local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local lives_display = require "lives_display"
local collisions = require "collisions"
local levels = require "levels"

local game = {}

function game.load( prev_state, ... )
   walls.construct_walls()
end

function game.enter( prev_state, ... )
   local args = ...
   if prev_state == "gamepaused" then
      music:resume()
   end
   if prev_state == "gameover" or prev_state == "gamefinished" then
      lives_display.reset()
      music:rewind()
   end
   if args and args.current_level then
      bricks.clear_current_level_bricks()
      levels.current_level = args.current_level
      local level = levels.require_current_level()
      bricks.construct_level( level )      
      ball.reposition()      
   end      
end

function game.update( dt )
   ball.update( dt )
   platform.update( dt )
   bricks.update( dt )
   walls.update( dt )
   lives_display.update( dt )
   collisions.resolve_collisions( ball, platform, walls, bricks )
   game.check_no_more_balls( ball, lives_display )
   game.switch_to_next_level( bricks, ball, levels )
end

function game.draw()
   ball.draw()
   platform.draw()
   bricks.draw()
   walls.draw()
   lives_display.draw()
end

function game.keyreleased( key, code )
   if key == 'c' then
      bricks.clear_current_level_bricks()
   elseif  key == 'escape' then
      music:pause()
      gamestates.set_state( "gamepaused",
			    { ball, platform, bricks, walls, lives_display } )
   end
end

function game.check_no_more_balls( ball, lives_display )
   if ball.escaped_screen then
      lives_display.lose_life()      
      if lives_display.lives < 0 then
	 gamestates.set_state( "gameover",
			       { ball, platform, bricks,
				 walls, lives_display } )
      else
	 ball.reposition()	 
      end
   end
end

function game.switch_to_next_level( bricks, ball, levels )
   if bricks.no_more_bricks then
      bricks.clear_current_level_bricks()
      if levels.current_level < #levels.sequence then
	 gamestates.set_state(
	    "game", { current_level = levels.current_level + 1 } )
      else
	 gamestates.set_state( "gamefinished" )
      end
   end
end

return game
