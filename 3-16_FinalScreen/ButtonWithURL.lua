local setmetatable = setmetatable
local string = string
local love = love
local vector = require "vector"
local print = print

local ButtonWithURL = {}

if setfenv then
   setfenv(1, ButtonWithURL)
else
   _ENV = ButtonWithURL
end

function ButtonWithURL:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = "button"
   o.text = o.text or "hello"
   o.url = o.url or nil
   o.selected = o.selected or false
   o.position = o.position or vector(300, 300)
   o.tileset_image = o.tileset_image or nil
   o.quad = o.quad or nil
   o.quad_selected = o.quad_selected or nil
   o.width = o.width or 100
   o.height = o.height or 50
   return o
end

function ButtonWithURL:update(dt)
   local mousePos = vector( love.mouse.getPosition() )
   if( self:inside( mousePos ) ) then
      self.selected = true
   else
      self.selected = false
   end
end

function ButtonWithURL:draw()
   local text_offset_from_top_border = 5
   if self.selected then
      -- love.graphics.rectangle( 'line',
      -- 			       self.position.x,
      -- 			       self.position.y,
      -- 			       self.width,
      -- 			       self.height )
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor( 255, 0, 0, 100 )
      love.graphics.printf( self.text,
			    self.position.x,
			    self.position.y + text_offset_from_top_border,
			    self.width,
			    "center" )
      love.graphics.setColor( r, g, b, a )
   else
      -- love.graphics.rectangle( 'line',
      -- 			       self.position.x,
      -- 			       self.position.y,
      -- 			       self.width,
      -- 			       self.height )
      love.graphics.printf( self.text,
			    self.position.x,
			    self.position.y + text_offset_from_top_border,
			    self.width,
			    "center" )	 
   end
end

function ButtonWithURL:mousereleased( x, y, button )
   if self.selected then
      local sccs = love.system.openURL( self.url )
   end
   return self.selected 
end

function ButtonWithURL:inside( pos )
   return
      self.position.x < pos.x and
      pos.x < ( self.position.x + self.width ) and
      self.position.y < pos.y and
      pos.y < ( self.position.y + self.height )
end

return ButtonWithURL
