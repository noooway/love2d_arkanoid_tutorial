local vector = require "vector"

local buttons_with_url = {}

function buttons_with_url.new_button( o )
   return( { position = o.position or vector( 300, 300 ),
	     width = o.width or 100,	     
	     height = o.height or 50,
	     text = o.text or "hello",
	     url = o.url or nil,
	     image = o.image or nil,
	     quad = o.quad or nil,
	     quad_when_selected = o.quad_when_selected or nil,
	     selected = false } )
end

function buttons_with_url.update_button( single_button, dt )
   local mouse_pos = vector( love.mouse.getPosition() )
   if( buttons_with_url.inside( single_button, mouse_pos ) ) then
      single_button.selected = true
   else
      single_button.selected = false
   end
end


function buttons_with_url.draw_button( single_button )
   local text_offset_from_top_border = 5
   if single_button.selected then
      if single_button.image and single_button.quad_when_selected then
	 love.graphics.draw( single_button.image,
			     single_button.quad_when_selected, 
			     single_button.position.x,
			     single_button.position.y )
      else
	 love.graphics.rectangle( 'line',
	 			  single_button.position.x,
	 			  single_button.position.y,
	 			  single_button.width,
	 			  single_button.height )
	 local r, g, b, a = love.graphics.getColor()
	 love.graphics.setColor( 255, 0, 0, 100 )
	 love.graphics.printf(
	    single_button.text,
	    single_button.position.x,
	    single_button.position.y + text_offset_from_top_border,
	    single_button.width,
	    "center" )
	 love.graphics.setColor( r, g, b, a )
      end
   else
      if single_button.image and single_button.quad then
	 love.graphics.draw( single_button.image,
			     single_button.quad, 
			     single_button.position.x,
			     single_button.position.y )
      else
	 love.graphics.rectangle( 'line',
	 			  single_button.position.x,
	 			  single_button.position.y,
	 			  single_button.width,
	 			  single_button.height )
	 love.graphics.printf(
	    single_button.text,
	    single_button.position.x,
	    single_button.position.y + text_offset_from_top_border,
	    single_button.width,
	    "center" )
      end
   end
end

function buttons_with_url.inside( single_button, pos )
   return
      single_button.position.x < pos.x and
      pos.x < ( single_button.position.x + single_button.width ) and
      single_button.position.y < pos.y and
      pos.y < ( single_button.position.y + single_button.height )
end

function buttons_with_url.mousereleased( single_button, x, y, button )
   if single_button.selected then
      local status = love.system.openURL( single_button.url )
   end
   return single_button.selected 
end

return buttons_with_url
