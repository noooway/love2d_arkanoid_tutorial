local gamefinished = {}

function gamefinished.update( dt )
end

function gamefinished.draw()
   love.graphics.print( "Congratulations!\n" ..
			   "You have finished the game!\n" ..
			   "Press Enter to restart or Esc to quit",
			280, 250 )
end

function gamefinished.keyreleased( key, code )
   if key == "return" then
      gamestates.set_state( "game", { current_level = 1 } )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

return gamefinished
