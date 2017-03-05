local love = love
local ScoreDisplay = require "ScoreDisplay"
local LifeDisplay = require "LifeDisplay"
local vector = require "vector"
local setmetatable = setmetatable

local SidePanel = {}

if setfenv then
   setfenv(1, SidePanel) -- for 5.1
else
   _ENV = SidePanel -- for 5.2
end


function SidePanel:new( o )   
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   local position_x = 608
   o.width = o.width or 200
   o.height_top = 160
   o.height_middle = 288
   o.height_bottom = 160
   o.position_top = vector( position_x, 0 )   
   o.position_middle = vector( position_x, o.height_top )
   o.position_bottom = vector( position_x, o.height_top + o.height_middle )
   o.score_display = o.score_display or ScoreDisplay:new( {} )
   o.life_display = o.life_display or LifeDisplay:new( {} )
   return o
end

function SidePanel:update( dt )
   self.score_display:update( dt )
   self.life_display:update( dt )
end

function SidePanel:draw()
   self:draw_background()
   self.score_display:draw()
   self.life_display:draw()
end

function SidePanel:draw_background()
   local drawtype = 'fill'
   local r, g, b, a = love.graphics.getColor( )
   -- top
   love.graphics.setColor( 255, 102, 0, 255 )
   love.graphics.rectangle("fill",
			   self.position_top.x,
			   self.position_top.y,
			   self.width,
			   self.height_top )
   love.graphics.setColor( 0, 0, 0, 255 )
   love.graphics.rectangle("line",
			   self.position_top.x,
			   self.position_top.y,
			   self.width,
			   self.height_top )
   -- middle
   love.graphics.setColor( 255, 127, 42, 255 )
   love.graphics.rectangle("fill",
			   self.position_middle.x,
			   self.position_middle.y,
			   self.width,
			   self.height_middle )
   love.graphics.setColor( 0, 0, 0, 255 )
   love.graphics.rectangle("line",
			   self.position_middle.x,
			   self.position_middle.y,
			   self.width,
			   self.height_middle )
   -- bottom
   love.graphics.setColor( 255, 102, 0, 255 )
   love.graphics.rectangle("fill",
			   self.position_bottom.x,
			   self.position_bottom.y,
			   self.width,
			   self.height_bottom )
   love.graphics.setColor( 0, 0, 0, 255 )
   love.graphics.rectangle("line",
			   self.position_bottom.x,
			   self.position_bottom.y,
			   self.width,
			   self.height_bottom )   
   love.graphics.setColor( r, g, b, a )      
end


return SidePanel
