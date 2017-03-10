local vector = require "vector"

local buttons = {}

function buttons.new_button( o )
   return( { position = o.position or vector( 300, 300 ),
	     width = o.width or 100,	     
	     height = o.height or 50,
	     text = o.text or "hello",
	     image = o.image or nil,
	     quad = o.quad or nil,
	     quad_when_selected = o.quad_when_selected or nil,
	     selected = false } )
end

function buttons.update_button( single_button, dt )
   local mouse_pos = vector( love.mouse.getPosition() )
   if( buttons.inside( single_button, mouse_pos ) ) then
      single_button.selected = true
   else
      single_button.selected = false
   end
end

function buttons.draw_button( single_button )
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
	 love.graphics.print( single_button.text,
			      single_button.position.x,
			      single_button.position.y )
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
	 love.graphics.print( single_button.text,
			      single_button.position.x,
			      single_button.position.y )	 
      end
   end
end

function buttons.inside( single_button, pos )
   return
      single_button.position.x < pos.x and
      pos.x < ( single_button.position.x + single_button.width ) and
      single_button.position.y < pos.y and
      pos.y < ( single_button.position.y + single_button.height )
end

function buttons.mousereleased( single_button, x, y, button )
   return single_button.selected 
end

return buttons
