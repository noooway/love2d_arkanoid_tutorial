local gameover = {}

local game_objects = {}

function gameover.enter( prev_state, ... )
   game_objects = ...
end

function gameover.update( dt )
end

function gameover.draw()
   for _, obj in pairs( game_objects ) do
      if type(obj) == "table" and obj.draw then
	 obj.draw()
      end
   end
   love.graphics.print(
      "Game Over. Press Enter to continue or Esc to quit",
      50, 50)
end

function gameover.keyreleased( key, code )
   if key == "return" then      
      gamestates.set_state( "game", { current_level = 1 } )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

function gameover.exit()
   game_objects = nil 
end

return gameover
