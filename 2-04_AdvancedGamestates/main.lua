gamestates = require "gamestates"

function love.load()
   gamestates.set_state( "menu" )
end

function love.update( dt )
   gamestates.state_event( "update", dt )
end

function love.draw()
   gamestates.state_event( "draw" )
end

function love.keyreleased( key, code )
   gamestates.state_event( "keyreleased", key, code )
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
