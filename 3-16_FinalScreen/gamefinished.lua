local buttons_with_url = require "buttons_with_url"
local vector = require "vector"

local gamefinished = {}

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30 )
bungee_font_links = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 18 )
bungee_font_soundeffects = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 13 )

function gamefinished.load( prev_state, ... )
   gamecode_button = buttons_with_url.new_button{
      text = "Game code by noway",
      url = "https://github.com/noooway/love2d_arkanoid_tutorial",
      position = vector( 10, 310 ),
      width = 260,
      height = 30      
   }
   love_button = buttons_with_url.new_button{
      text = "Love2d framework by the Love Team",
      url = "http://love2d.org/",
      position = vector( 10, 350 ),
      width = 260,
      height = 50      
   }
   vector_button = buttons_with_url.new_button{
      text = "Vector library from HUMP by vrld",
      url = "https://github.com/vrld/hump",
      position = vector( 10, 410 ),
      width = 260,
      height = 50
   }
   tileset_button = buttons_with_url.new_button{
      text = "Game Tileset by noway",
      url = "http://opengameart.org/content/arcanoid-starter-set",
      position = vector( 280, 310 ),
      width = 260,
      height = 30      
   }
   bungeefont_button = buttons_with_url.new_button{
      text = "Bungee Inline font by David Jonathan Ross",
      url = "https://fonts.google.com/specimen/Bungee",
      position = vector( 280, 350 ),
      width = 260,
      height = 50      
   }
   bart_button = buttons_with_url.new_button{
      text = "bart",
      url = "http://opengameart.org/content/33-metal-clang-sounds-cast-iron-pans",
      position = vector( 570, 360 ),
      width = 59,
      height = 20
   }
   ngruber_button = buttons_with_url.new_button{
      text = "ngruber",
      url = "https://www.freesound.org/people/ngruber/sounds/204777/#",
      position = vector( 570, 380 ),
      width = 89,
      height = 20
   }
   tinyworlds_button = buttons_with_url.new_button{
      text = "TinyWorlds",
      url = "http://opengameart.org/content/break-pumpkin",
      position = vector( 570, 400 ),
      width = 118,
      height = 20
   }
   edgardedition_button = buttons_with_url.new_button{
      text = "EdgardEdition",
      url = "https://www.freesound.org/people/EdgardEdition/sounds/114201/",
      position = vector( 570, 420 ),
      width = 144,
      height = 20
   }
   cmusounddesign_button = buttons_with_url.new_button{
      text = "cmusounddesign",
      url = "https://www.freesound.org/people/cmusounddesign/sounds/84536/",
      position = vector( 570, 440 ),
      width = 154,
      height = 20
   }
   qubodup_button = buttons_with_url.new_button{
      text = "Iwan 'qubodup' Gabovitch",
      url = "http://opengameart.org/users/qubodup",
      position = vector( 570, 460 ),
      width = 228,
      height = 20
   }
   music_button = buttons_with_url.new_button{
      text = "Music by\n Section 31 -Tech",
      url = "http://opengameart.org/content/night-prowler",
      position = vector( 570, 500 ),
      width = 200,
      height = 50
   }
end

function gamefinished.update( dt )
   buttons_with_url.update_button( gamecode_button, dt )
   buttons_with_url.update_button( love_button, dt )
   buttons_with_url.update_button( vector_button, dt )
   buttons_with_url.update_button( tileset_button, dt )
   buttons_with_url.update_button( bungeefont_button, dt )
   buttons_with_url.update_button( cmusounddesign_button, dt )
   buttons_with_url.update_button( ngruber_button, dt )
   buttons_with_url.update_button( bart_button, dt )
   buttons_with_url.update_button( qubodup_button, dt )
   buttons_with_url.update_button( tinyworlds_button, dt )
   buttons_with_url.update_button( edgardedition_button, dt )
   buttons_with_url.update_button( music_button, dt )
end

function gamefinished.draw()
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Congratulations!",
			 235, 70, 350, "center" )
   love.graphics.printf( "You have finished the game!",
			 100, 110, 600, "center" )
   love.graphics.printf( "---Credits---",
			 276, 220, 250, "center" )
   love.graphics.printf( "Code",
			 10, 265, 260, "center" )
   love.graphics.setFont( bungee_font_links )
   buttons_with_url.draw_button( gamecode_button )
   buttons_with_url.draw_button( love_button )
   buttons_with_url.draw_button( vector_button )   

   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Visuals",
			 270, 265, 260, "center" )
   love.graphics.setFont( bungee_font_links )
   buttons_with_url.draw_button( tileset_button )
   buttons_with_url.draw_button( bungeefont_button )

   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Sound",
			 530, 265, 260, "center" )
   love.graphics.setFont( bungee_font_links )
   love.graphics.printf( "Samples derived from works by",
			 570, 315, 200, "center" )

   love.graphics.setFont( bungee_font_soundeffects )
   buttons_with_url.draw_button( cmusounddesign_button )
   buttons_with_url.draw_button( ngruber_button )
   buttons_with_url.draw_button( bart_button )
   buttons_with_url.draw_button( qubodup_button )
   buttons_with_url.draw_button( tinyworlds_button )
   buttons_with_url.draw_button( edgardedition_button )

   love.graphics.setFont( bungee_font_links )
   buttons_with_url.draw_button( music_button )
   
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
   if button == 'r' or button == 2 then
      love.event.quit()
   end
   buttons_with_url.mousereleased( gamecode_button, x, y, button )
   buttons_with_url.mousereleased( love_button, x, y, button )
   buttons_with_url.mousereleased( vector_button, x, y, button )   
   buttons_with_url.mousereleased( tileset_button, x, y, button )
   buttons_with_url.mousereleased( bungeefont_button, x, y, button )
   buttons_with_url.mousereleased( cmusounddesign_button, x, y, button )
   buttons_with_url.mousereleased( ngruber_button, x, y, button )
   buttons_with_url.mousereleased( bart_button, x, y, button )
   buttons_with_url.mousereleased( qubodup_button, x, y, button )
   buttons_with_url.mousereleased( tinyworlds_button, x, y, button )
   buttons_with_url.mousereleased( edgardedition_button, x, y, button )
   buttons_with_url.mousereleased( music_button, x, y, button )
end

return gamefinished
