local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local collisions = require "collisions"
local levels = require "levels"

local gamestate = "menu"

function love.load()
   local love_window_width = 800
   local love_window_height = 600
   love.window.setMode( love_window_width,
                        love_window_height,
                        { fullscreen = false } )
   level = levels.require_current_level()
   bricks.construct_level( level )
   walls.construct_walls()
end
 
function love.update( dt )
   if gamestate == "menu" then
   elseif gamestate == "game" then
      ball.update( dt )
      platform.update( dt )
      bricks.update( dt )
      walls.update( dt )
      collisions.resolve_collisions( ball, platform, walls, bricks )
      switch_to_next_level( bricks, ball, levels )
   elseif gamestate == "gamepaused" then
   elseif gamestate == "gamefinished" then
   end
end
 
function love.draw()
   if gamestate == "menu" then
      love.graphics.print("Menu gamestate. Press Enter to continue.",
			  280, 250)
   elseif gamestate == "game" then
      ball.draw()
      platform.draw()
      bricks.draw()
      walls.draw()
   elseif gamestate == "gamepaused" then
      ball.draw()
      platform.draw()
      bricks.draw()
      walls.draw()
      love.graphics.print(
	 "Game is paused. Press Enter to continue or Esc to quit",
	 50, 50)
   elseif gamestate == "gamefinished" then
      love.graphics.print( "Congratulations!\n" ..
			      "You have finished the game!\n" ..
			      "Press Enter to restart or Esc to quit",
			    280, 250 )
   end
end

function love.keyreleased( key, code )
   if gamestate == "menu" then
      if key == "return" then
	 gamestate = "game"
      elseif key == 'escape' then
	 love.event.quit()
      end    
   elseif gamestate == "game" then
      if key == 'c' then
	 bricks.clear_current_level_bricks()
      elseif  key == 'escape' then
	 gamestate = "gamepaused"
      end    
   elseif gamestate == "gamepaused" then
      if key == "return" then
	 gamestate = "game"
      elseif key == 'escape' then
	 love.event.quit()
      end    
   elseif gamestate == "gamefinished" then
      if key == "return" then
	 levels.current_level = 1
	 level = levels.require_current_level()
	 bricks.clear_current_level_bricks()
	 bricks.construct_level( level )
	 ball.reposition()	 	 
	 gamestate = "game"
      elseif key == 'escape' then
	 love.event.quit()
      end    
   end
end

function switch_to_next_level( bricks, ball, levels )
   if bricks.no_more_bricks then
      if levels.current_level < #levels.sequence then
	 levels.current_level = levels.current_level + 1
	 level = levels.require_current_level()
	 bricks.clear_current_level_bricks()
	 bricks.construct_level( level )
	 ball.reposition()	 	 
      else
	 gamestate = "gamefinished"
      end
   end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
