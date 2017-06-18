local vector = require "vector"
local buttons = require "buttons"

local buttons_with_url = {}

function buttons_with_url.new_button( o )
   btn = buttons.new_button( o )
   btn.url = o.url or nil
   btn.font = o.font or love.graphics.getFont()
   btn.text_align = o.text_align or "center"
   btn.sizing = o.sizing or nil
   btn.positioning = o.positioning or nil
   btn.displacement_from_auto = o.displacement_from_auto or vector(0, 0)
   return( btn )
end

function buttons_with_url.update_button( single_button, dt )
   buttons.update_button( single_button, dt )
end

function buttons_with_url.draw_button( single_button )
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( single_button.font )
   if single_button.selected then
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor( 255, 0, 0, 100 )
      love.graphics.printf( single_button.text,
			    single_button.position.x,
			    single_button.position.y,
			    single_button.width,
			    single_button.text_align )
      love.graphics.setColor( r, g, b, a )
   else
      love.graphics.printf( single_button.text,
			    single_button.position.x,
			    single_button.position.y,
			    single_button.width,
			    single_button.text_align )	 
   end
   love.graphics.setFont( oldfont )
end

function buttons_with_url.inside( single_button, pos )
   buttons.inside( single_button, pos )
end

function buttons_with_url.mousereleased_button( single_button, x, y, button )
   if single_button.selected then
      local status = love.system.openURL( single_button.url )
   end      
   return single_button.selected
end


function buttons_with_url.new_layout( o )
   return( { position = o.position or vector( 300, 300 ),
	     default_width = o.default_width or 100,
	     default_height = o.default_height or 50,
	     default_offset = o.default_offset or vector( 10, 10 ),
	     orientation = o.orientation or "vertical",
	     children = o.children or {} } )
end

function buttons_with_url.add_to_layout( layout, element )
   if element.positioning and element.positioning == 'auto' then
      local position = layout.position
      for i, el in ipairs( layout.children ) do
	 if layout.orientation == "vertical" then
	    position = position + vector( 0, el.height ) + layout.default_offset
	 else
	    print( "unknown layout orientation" )
	 end
      end
      element.position = position + element.displacement_from_auto
   end
   if element.sizing and element.sizing == 'auto' then
      element.width = layout.default_width
      element.height = layout.default_height
   end
   table.insert( layout.children, element )
end

function buttons_with_url.update_layout( layout, dt )
   for _, btn in pairs( layout.children ) do
      buttons_with_url.update_button( btn, dt )
   end
end

function buttons_with_url.draw_layout( layout )
   for _, btn in pairs( layout.children ) do
      buttons_with_url.draw_button( btn )
   end
end

function buttons_with_url.mousereleased_layout( layout, x, y, button )
   for _, btn in pairs( layout.children ) do
      buttons_with_url.mousereleased_button( btn, x, y, button )
   end
end

return buttons_with_url
