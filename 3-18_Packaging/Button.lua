local vector = require "vector"
local love = love
local setmetatable = setmetatable

local Button = {}

if setfenv then
   setfenv(1, Button) -- for 5.1
else
   _ENV = Button -- for 5.2
end

image = love.graphics.newImage( "img/800x600/buttons.png" )
button_tile_width = 128
button_tile_height = 64
play_button_tile_x_pos = 0
play_button_tile_y_pos = 0
quit_button_tile_x_pos = 0
quit_button_tile_y_pos = 64
selected_x_shift = 128
tileset_width = 256
tileset_height = 128

function Button:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "button"
   o.position = o.position or vector( 300, 300 )
   o.width = o.width or 100
   o.height = o.height or 50
   o.text = o.text or "hello"
   o.selected = o.selected or false
   o.quad = o.quad or nil
   o.quad_selected = o.quad_selected or nil
   return o
end

function Button:update( dt )
   local mousePos = vector( love.mouse.getPosition() )
   if( self:inside( mousePos ) ) then
      self.selected = true
   else
      self.selected = false
   end
end

function Button:draw()
   if self.selected then
      if self.quad_selected then
	 love.graphics.draw( self.image,
			     self.quad_selected, 
			     self.position.x, self.position.y )
      else
	 love.graphics.rectangle( 'line',
				  self.position.x,
				  self.position.y,
				  self.width,
				  self.height )
	 local r, g, b, a = love.graphics.getColor()
	 love.graphics.setColor( 255, 0, 0, 100 )
	 love.graphics.print( self.text,
			      self.position.x,
			      self.position.y )
	 love.graphics.setColor( r, g, b, a )
      end
   else
      if self.quad then
	 love.graphics.draw( self.image,
			     self.quad, 
			     self.position.x, self.position.y )
      else
	 love.graphics.rectangle( 'line',
				  self.position.x,
				  self.position.y,
				  self.width,
				  self.height )
	 love.graphics.print( self.text,
			      self.position.x,
			      self.position.y )	 
      end
   end
end

function Button:inside( pos )
   return
      self.position.x < pos.x and
      pos.x < ( self.position.x + self.width ) and
      self.position.y < pos.y and
      pos.y < ( self.position.y + self.height )
end

function Button:mousereleased( x, y, button )
   return self.selected 
end

return Button
