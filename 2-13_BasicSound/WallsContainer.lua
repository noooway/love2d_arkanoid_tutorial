local Wall = require "Wall"
local vector = require "vector"
local love = love
local setmetatable = setmetatable
local table = table
local pairs = pairs

local WallsContainer = {}

if setfenv then
   setfenv(1, WallsContainer) -- for 5.1
else
   _ENV = WallsContainer -- for 5.2
end

local defaultThickness = 34
local top_wall_thickness = 26
local right_border_x_pos = 576

function WallsContainer:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "walls_container"   
   o.walls = o.walls or {}
   o.collider = o.collider or {}
   o.wall_thickness = o.wall_thickness or defaultThickness
   local left_wall = Wall:new{
      position = vector( 0, 0 ),
      width = o.wall_thickness,
      height = love.graphics.getHeight(),
      collider = o.collider
   }
   local right_wall = Wall:new{
      position = vector( right_border_x_pos, 0 ),
      width = o.wall_thickness,
      height = love.graphics.getHeight(),
      collider = o.collider
   }
   local top_wall = Wall:new{
      position = vector( 0, 0 ),
      width = right_border_x_pos,
      height = top_wall_thickness,
      collider = o.collider
   }
   local bottom_wall = Wall:new{
      position = vector( 0, love.graphics.getHeight() ),
      width = love.graphics.getWidth(),
      height = o.wall_thickness,
      collider = o.collider
   }   
   o.walls.left = left_wall
   o.walls.right = right_wall
   o.walls.top = top_wall
   o.walls.bottom = bottom_wall
   return o
end

function WallsContainer:update( dt )
   for _, wall in pairs( self.walls ) do
      wall:update( dt ) 
   end   
end

function WallsContainer:draw()
   for _, wall in pairs( self.walls ) do
      wall:draw()
   end   
end

function WallsContainer:destroy()
   for _, wall in pairs( self.walls ) do
      wall:destroy()
   end   
end

return WallsContainer
