local vector = require "vector"
local love = love
local setmetatable = setmetatable

local Platform = {}

if setfenv then
   setfenv(1, Platform) -- for 5.1
else
   _ENV = Platform -- for 5.2
end

function Platform:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "platform"
   o.position = o.position or vector( 500, 500 )
   o.speed = o.speed or vector( 300, 0 )
   o.width = o.width or 70
   o.height = o.height or 20
   o.collider = o.collider or {}
   o.collider_shape = o.collider:rectangle( o.position.x,
					    o.position.y,
					    o.width,
					    o.height )
   o.collider_shape.game_object = o
   return o
end

function Platform:update( dt )
   if love.keyboard.isDown("right") then
      self.position.x = self.position.x + self.speed.x * dt
   end
   if love.keyboard.isDown("left") then
      self.position.x = self.position.x - self.speed.x * dt
   end
   self.collider_shape:moveTo( self.position.x + self.width / 2,
			       self.position.y + self.height / 2 )
end

function Platform:draw()
   love.graphics.rectangle( 'line',
			    self.position.x,
			    self.position.y,
			    self.width,
			    self.height )
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 0, 255, 0, 100 )
   self.collider_shape:draw( 'fill' )
   love.graphics.setColor( r, g, b, a )
end

function Platform:react_on_wall_collision( another_shape, separating_vector )
   self.position = self.position + separating_vector
   self.collider_shape:moveTo( self.position.x + self.width / 2,
			       self.position.y + self.height / 2 )   
end

function Platform:destroy()
   self.collider_shape.game_object = nil
   self.collider:remove( self.collider_shape )
end

return Platform
