local gamefinished = {}

function gamefinished.update( dt )
end

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30 )

function gamefinished.draw()
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Congratulations!",
			 235, 200, 350, "center" )
   love.graphics.printf( "You have finished the game!",
			 100, 240, 600, "center" )
   love.graphics.setFont( oldfont )
end

function gamefinished.keyreleased( key, code )
   if key == "return" then
      gamestates.set_state( "game", { current_level = 1 } )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

function gamefinished.mousereleased( x, y, button, istouch )
   if button == 'l' or button == 1 then
      gamestates.set_state( "game", { current_level = 1 } )
   elseif button == 'r' or button == 2 then
      love.event.quit()
   end    
end

return gamefinished
