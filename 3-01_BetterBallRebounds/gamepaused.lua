local gamepaused = {}

local game_objects = {}

function gamepaused.enter( prev_state, ... )
   game_objects = ...
end

function gamepaused.update( dt )
end

function gamepaused.draw()
   for _, obj in pairs( game_objects ) do
      if type(obj) == "table" and obj.draw then
	 obj.draw()
      end
   end
   love.graphics.print(
      "Game is paused. Press Enter to continue or Esc to quit",
      50, 50)
end

function gamepaused.keyreleased( key, code )
   if key == "return" then
      gamestates.set_state( "game" )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

function gamepaused.exit()
   game_objects = nil 
end

return gamepaused
