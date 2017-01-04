local Gamestate = require "gamestate"
local game = game or require "game"
local ButtonWithURL = require "ButtonWithURL"
local vector = require "vector"
local love = love


local gamefinished = gamefinished or {}

if setfenv then
   setfenv(1, gamefinished)
else
   _ENV = gamefinished
end

state_name = "gamefinished"

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30 )
bungee_font_links = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 18 )
bungee_font_soundeffects = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 13 )


function gamefinished:enter()
   gamecode_button = ButtonWithURL:new{
      text = "Game code by noway",
      url = "https://github.com/noooway/love2d_arkanoid_tutorial",
      position = vector( 10, 310 ),
      width = 260,
      height = 30      
   }
   love_button = ButtonWithURL:new{
      text = "Love2d framework by the Love Team",
      url = "http://love2d.org/",
      position = vector( 10, 350 ),
      width = 260,
      height = 50      
   }
   hump_button = ButtonWithURL:new{
      text = "Gamestate and Vector libraries from HUMP by vrld",
      url = "https://github.com/vrld/hump",
      position = vector( 10, 410 ),
      width = 260,
      height = 80
   }
   hc_button = ButtonWithURL:new{
      text = "HC collision detection library by vrld",
      url = "https://github.com/vrld/HC",
      position = vector( 10, 500 ),
      width = 260,
      height = 50
   }
   tileset_button = ButtonWithURL:new{
      text = "Game Tileset by noway",
      url = "http://opengameart.org/content/arcanoid-starter-set",
      position = vector( 280, 310 ),
      width = 260,
      height = 30      
   }
   bungeefont_button = ButtonWithURL:new{
      text = "Bungee Inline font by David Jonathan Ross",
      url = "https://fonts.google.com/specimen/Bungee",
      position = vector( 280, 350 ),
      width = 260,
      height = 50      
   }
   bart_button = ButtonWithURL:new{
      text = "bart",
      url = "http://opengameart.org/content/33-metal-clang-sounds-cast-iron-pans",
      position = vector( 570, 360 ),
      width = 59,
      height = 20
   }
   ngruber_button = ButtonWithURL:new{
      text = "ngruber",
      url = "https://www.freesound.org/people/ngruber/sounds/204777/#",
      position = vector( 570, 380 ),
      width = 89,
      height = 20
   }
   tinyworlds_button = ButtonWithURL:new{
      text = "TinyWorlds",
      url = "http://opengameart.org/content/break-pumpkin",
      position = vector( 570, 400 ),
      width = 118,
      height = 20
   }
   edgardedition_button = ButtonWithURL:new{
      text = "EdgardEdition",
      url = "https://www.freesound.org/people/EdgardEdition/sounds/114201/",
      position = vector( 570, 420 ),
      width = 144,
      height = 20
   }
   cmusounddesign_button = ButtonWithURL:new{
      text = "cmusounddesign",
      url = "https://www.freesound.org/people/cmusounddesign/sounds/84536/",
      position = vector( 570, 440 ),
      width = 154,
      height = 20
   }
   qubodup_button = ButtonWithURL:new{
      text = "Iwan 'qubodup' Gabovitch",
      url = "http://opengameart.org/users/qubodup",
      position = vector( 570, 460 ),
      width = 228,
      height = 20
   }

   music_button = ButtonWithURL:new{
      text = "Music by\n Section 31 -Tech",
      url = "http://opengameart.org/content/night-prowler",
      position = vector( 570, 500 ),
      width = 200,
      height = 50
   }
end

function gamefinished:update( dt )
   gamecode_button:update( dt )
   love_button:update( dt )
   hump_button:update( dt )
   hc_button:update( dt )
   tileset_button:update( dt )
   bungeefont_button:update( dt )
   cmusounddesign_button:update( dt )
   ngruber_button:update( dt )
   bart_button:update( dt )
   qubodup_button:update( dt )
   tinyworlds_button:update( dt )
   edgardedition_button:update( dt )
   music_button:update( dt )
end

function gamefinished:draw()
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
   gamecode_button:draw()
   love_button:draw()
   hump_button:draw()
   hc_button:draw()

   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Visuals",
			 270, 265, 260, "center" )
   love.graphics.setFont( bungee_font_links )
   tileset_button:draw()
   bungeefont_button:draw()

   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Sound",
			 530, 265, 260, "center" )
   love.graphics.setFont( bungee_font_links )
   love.graphics.printf( "Samples derived from works by",
			 570, 315, 200, "center" )

   love.graphics.setFont( bungee_font_soundeffects )
   cmusounddesign_button:draw()
   ngruber_button:draw()
   bart_button:draw()
   qubodup_button:draw()
   tinyworlds_button:draw()
   edgardedition_button:draw()

   love.graphics.setFont( bungee_font_links )
   music_button:draw()
   
   love.graphics.setFont( oldfont )
end

function gamefinished:keyreleased( key, code )
   if key == 'return' then      
      Gamestate.switch( game, { level_counter = 1 } )
   elseif  key == 'escape' then
      love.event.quit()
   end    
end

function gamefinished:mousereleased( x, y, button )
   if button == 'r' or button == 2 then
      love.event.quit()
   end   
   gamecode_button:mousereleased( x, y, button )
   love_button:mousereleased( x, y, button )
   hump_button:mousereleased( x, y, button )
   hc_button:mousereleased( x, y, button )
   tileset_button:mousereleased( x, y, button )
   bungeefont_button:mousereleased( x, y, button )
   cmusounddesign_button:mousereleased( x, y, button )
   ngruber_button:mousereleased( x, y, button )
   bart_button:mousereleased( x, y, button )
   qubodup_button:mousereleased( x, y, button )
   tinyworlds_button:mousereleased( x, y, button )
   edgardedition_button:mousereleased( x, y, button )
   music_button:mousereleased( x, y, button )
end

function gamefinished:leave()
end

return gamefinished
