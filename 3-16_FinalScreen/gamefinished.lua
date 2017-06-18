local buttons_with_url = require "buttons_with_url"
local vector = require "vector"

local gamefinished = {}

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30 )
bungee_font_links = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 18 )
bungee_font_soundeffects = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 13 )
bungee_font_thanks = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 12 )

local section_start_y = 280
local section_width = 250
local section_line_height = 25

function gamefinished.load( prev_state, ... )
   code_section = buttons_with_url.new_layout{
      position = vector( 5, section_start_y ),
      default_width = section_width,
      default_height = section_line_height,
      default_offset = vector( 0, 8 )	 
   }
   buttons_with_url.add_to_layout(
      code_section,
      buttons_with_url.new_button{
	 text = "Game code by noway",
	 url = "https://github.com/noooway/love2d_arkanoid_tutorial",
	 font = bungee_font_links,
	 positioning = "auto",
	 sizing = "auto"
   })
   buttons_with_url.add_to_layout(
      code_section,
      buttons_with_url.new_button{
	 text = "Love2d framework by Love Team",
	 url = "http://love2d.org/",
	 positioning = "auto",
	 width = code_section.default_width,
	 height = 2 * code_section.default_height,
	 font = bungee_font_links
   })
   buttons_with_url.add_to_layout(
      code_section,   
      buttons_with_url.new_button{
	 text = "Vector library from HUMP by vrld",
	 url = "https://github.com/vrld/hump",
	 positioning = "auto",
	 width = code_section.default_width,
	 height = 2 * code_section.default_height,
	 font = bungee_font_links
   })

   graphics_section = buttons_with_url.new_layout{
      position = vector( 278, section_start_y ),
      default_width = section_width,
      default_height = section_line_height,
      default_offset = vector( 0, 8 )
   }
   buttons_with_url.add_to_layout(
      graphics_section,   
      buttons_with_url.new_button{
	 text = "Game Tileset by noway",
	 url = "http://opengameart.org/content/arcanoid-starter-set",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_links
   })
   buttons_with_url.add_to_layout(
      graphics_section,   
      buttons_with_url.new_button{
	 text = "Bungee Inline font by David Jonathan Ross",
	 url = "https://fonts.google.com/specimen/Bungee",
	 positioning = "auto",
	 width = graphics_section.default_width,
	 height = 2 * graphics_section.default_height,
	 font = bungee_font_links
   })


   sound_effects_section = buttons_with_url.new_layout{
      position = vector( 580, 335 ),
      default_width = 260,
      default_height = 20,
      default_offset = vector( 0, 0 )
   }   
   buttons_with_url.add_to_layout(      
      sound_effects_section,
      buttons_with_url.new_button{
	 text = "bart",
	 url = "http://opengameart.org/content/33-metal-clang-sounds-cast-iron-pans",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_soundeffects,
	 text_align = "left"
   })
   buttons_with_url.add_to_layout(
      sound_effects_section,
      buttons_with_url.new_button{
	 text = "ngruber",
	 url = "https://www.freesound.org/people/ngruber/sounds/204777/#",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_soundeffects,
	 text_align = "left"
   })
   buttons_with_url.add_to_layout(
      sound_effects_section,
      buttons_with_url.new_button{
	 text = "TinyWorlds",
	 url = "http://opengameart.org/content/break-pumpkin",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_soundeffects,
	 text_align = "left"
   })
   buttons_with_url.add_to_layout(
      sound_effects_section,
      buttons_with_url.new_button{
	 text = "EdgardEdition",
	 url = "https://www.freesound.org/people/EdgardEdition/sounds/114201/",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_soundeffects,
	 text_align = "left"
   })
   buttons_with_url.add_to_layout(
      sound_effects_section,
      buttons_with_url.new_button{
	 text = "cmusounddesign",
	 url = "https://www.freesound.org/people/cmusounddesign/sounds/84536/",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_soundeffects,
	 text_align = "left"
   })
   buttons_with_url.add_to_layout(
      sound_effects_section,
      buttons_with_url.new_button{
	 text = "Iwan 'qubodup' Gabovitch",
	 url = "http://opengameart.org/users/qubodup",
	 positioning = "auto",
	 sizing = "auto",
	 font = bungee_font_soundeffects,
	 text_align = "left"
   })
   
   music_button = buttons_with_url.new_button{
	 text = "Music by\n Section 31 -Tech",
	 url = "http://opengameart.org/content/night-prowler",
	 position = vector( 570, 465 ),
	 width = 200,
	 height = 50,
	 font = bungee_font_links
   }
   thanks_button = buttons_with_url.new_button{           
      text = "Thanks to Ivan, Zorg, Pgimeno, Airstruck, Positive07, Germanunkol from LOVE forums for early critique and discussion. Special thanks to Ivan, whose advice and suggestions have significantly influenced the structure of the game code.",
      url = "https://love2d.org/forums/viewtopic.php?f=14&t=83240",
      position = vector( 100, 530 ),
      width = 600,
      height = 50,
      font = bungee_font_thanks
   }
end

function gamefinished.update( dt )
   buttons_with_url.update_layout( code_section, dt )
   buttons_with_url.update_layout( graphics_section, dt )
   buttons_with_url.update_layout( sound_effects_section, dt )
   buttons_with_url.update_button( music_button, dt )
   buttons_with_url.update_button( thanks_button, dt )
end

function gamefinished.draw()
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Congratulations!",
			 0, 55, love.graphics.getWidth(), "center" )
   love.graphics.printf( "You have finished the game!",
			 0, 95, love.graphics.getWidth(), "center" )
   love.graphics.printf( "---Credits---",
			 5, 188, love.graphics.getWidth(), "center" )

   local section_names_y = 235
   local section_width = 260
   love.graphics.printf( "Code",
			 5, section_names_y, section_width, "center" )
   love.graphics.printf( "Graphics",
			 275, section_names_y, section_width, "center" )
   love.graphics.printf( "Sound",
			 530, section_names_y, section_width, "center" )

   love.graphics.setFont( bungee_font_links )
   love.graphics.printf( "Samples derived from works by",
			 570, section_start_y, 200, "center" )
   love.graphics.setFont( oldfont )
   
   buttons_with_url.draw_layout( code_section )
   buttons_with_url.draw_layout( graphics_section )
   buttons_with_url.draw_layout( sound_effects_section )
   buttons_with_url.draw_button( music_button )
   buttons_with_url.draw_button( thanks_button )
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
   buttons_with_url.mousereleased_layout( code_section )
   buttons_with_url.mousereleased_layout( graphics_section )
   buttons_with_url.mousereleased_layout( sound_effects_section )
   buttons_with_url.mousereleased_button( music_button )
   buttons_with_url.mousereleased_button( thanks_button )
end

return gamefinished
