local ball = require "ball"
local platform = require "platform"
local bricks = require "bricks"
local walls = require "walls"
local lives_display = require "lives_display"
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
      lives_display.update( dt )
      collisions.resolve_collisions( ball, platform, walls, bricks )
      check_no_more_balls( ball, lives_display )
      switch_to_next_level( bricks, ball, levels )
   elseif gamestate == "gamepaused" then
   elseif gamestate == "gameover" then
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
      lives_display.draw()
   elseif gamestate == "gamepaused" then
      ball.draw()
      platform.draw()
      bricks.draw()
      walls.draw()
      lives_display.draw()
      love.graphics.print(
	 "Game is paused. Press Enter to continue or Esc to quit",
	 50, 50)
   elseif gamestate == "gameover" then
      ball.draw()
      platform.draw()
      bricks.draw()
      walls.draw()
      lives_display.draw()
      love.graphics.print(
	 "Game Over. Press Enter to restart or Esc to quit",
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
   elseif gamestate == "gameover" then
      if key == "return" then
	 restart_from_first_level()
      elseif key == 'escape' then
	 love.event.quit()
      end    
   elseif gamestate == "gamefinished" then
      if key == "return" then
	 restart_from_first_level()
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
      elseif levels.current_level >= #levels.sequence then
	 gamestate = "gamefinished"
      end
   end
end

function check_no_more_balls( ball )
   if ball.escaped_screen then
      lives_display.lose_life()      
      if lives_display.lives < 0 then
	 gamestate = "gameover"
      else
	 ball.reposition()	 
      end
   end
end

function restart_from_first_level()
   levels.current_level = 1
   level = levels.require_current_level()
   bricks.clear_current_level_bricks()
   bricks.construct_level( level )
   ball.reposition()
   lives_display.reset()
   gamestate = "game"   
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
