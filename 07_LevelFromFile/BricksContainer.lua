local Brick = require "Brick"
local vector = require "vector"
local love = love
local setmetatable = setmetatable
local table = table
local pairs = pairs

local BricksContainer = {}

if setfenv then
   setfenv(1, BricksContainer) -- for 5.1
else
   _ENV = BricksContainer -- for 5.2
end

function BricksContainer:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "bricks_container"
   o.bricks = o.bricks or {}
   o.level = o.level or nil
   o.collider = o.collider or {}
   o.rows = 10
   o.columns = 10   
   o.top_left_position = vector( 100, 50 )
   o.horizontal_distance = o.horizontal_distance or 10
   o.vertical_distance = o.vertical_distance or 10
   o.brick_width = o.brick_width or 50
   o.brick_height = o.brick_height or 30
   if not o.level then
      o:default_level_construction_procedure()
   else
      o:construct_from_level()
   end
   return o
end

function BricksContainer:default_level_construction_procedure()
   for row = 1, self.rows do
      local new_row = {}
      for col = 1, self.columns do	 
	 local new_brick_position = self.top_left_position +
	    vector(
	       ( col - 1 ) * ( self.brick_width + self.horizontal_distance ),
	       ( row - 1 ) * ( self.brick_height + self.vertical_distance ) )
	 local new_brick = Brick:new{
	    width = self.brick_width,
	    height = self.brick_height,
	    position = new_brick_position,
	    collider = self.collider
	 }
	 new_row[ col ] = new_brick
      end
      self.bricks[ row ] = new_row
   end   
end


function BricksContainer:construct_from_level()
   for row = 1, self.rows do
      local new_row = {}
      for col = 1, self.columns do
	 local bricktype = self.level.bricks[row][col]
	 if bricktype ~= 0 then
	    local new_brick_position = self.top_left_position +
	       vector(
		  ( col - 1 ) *
		     ( self.brick_width + self.horizontal_distance ),
		  ( row - 1 ) *
		     ( self.brick_height + self.vertical_distance ) )
	    local new_brick = Brick:new{
	       width = self.brick_width,
	       height = self.brick_height,
	       position = new_brick_position,
	       bricktype = bricktype,
	       collider = self.collider
	    }
	    new_row[ col ] = new_brick
	 end
      end
      self.bricks[ row ] = new_row
   end   
end


function BricksContainer:update( dt )
   for i, brick_row in pairs( self.bricks ) do
      for j, brick in pairs( brick_row ) do
	 brick:update( dt )
	 if brick.to_destroy then
	    brick.collider:remove( brick.collider_shape )
	    self.bricks[i][j] = nil
	 end
      end
   end   
end

function BricksContainer:draw()
   for _, brick_row in pairs( self.bricks ) do
      for _, brick in pairs( brick_row ) do
	 brick:draw()
      end
   end   
end

return BricksContainer
