gamestates = require "gamestates"

music = love.audio.newSource( "sounds/S31-Night Prowler.ogg" )
music:setLooping( true )

function love.load()
   local love_window_width = 800
   local love_window_height = 600
   love.window.setMode( love_window_width,
                        love_window_height,
                        { fullscreen = false } )
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
