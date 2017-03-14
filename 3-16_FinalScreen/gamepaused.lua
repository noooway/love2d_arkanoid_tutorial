local gamepaused = {}

local game_objects = {}

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 40 )

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
   gamepaused.cast_shadow()

   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Game Paused...",
			 108, 110, 400, "center" )
   love.graphics.setFont( oldfont )
end

function gamepaused.cast_shadow()
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 10, 10, 10, 100 )
   love.graphics.rectangle("fill",
			   0,
			   0,
			   love.graphics.getWidth(),
			   love.graphics.getHeight() )
   love.graphics.setColor( r, g, b, a )
end

function gamepaused.keyreleased( key, code )
   if key == "return" then
      gamestates.set_state( "game" )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

function gamepaused.mousereleased( x, y, button, istouch )
   if button == 'l' or button == 1 then
      gamestates.set_state( "game" )
   elseif button == 'r' or button == 2 then
      love.event.quit()
   end   
end

function gamepaused.exit()
   game_objects = nil 
end

return gamepaused
