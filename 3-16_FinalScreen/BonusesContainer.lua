local Bonus = require "Bonus"
local vector = require "vector"
local love = love
local setmetatable = setmetatable
local table = table
local pairs = pairs

local BonusesContainer = {}

if setfenv then
   setfenv(1, BonusesContainer) -- for 5.1
else
   _ENV = BonusesContainer -- for 5.2
end

function BonusesContainer:new( o )
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.name = o.name or "bonuses_container"   
   o.bonuses = o.bonuses or {}
   o.collider = o.collider or {}
   return o
end

function BonusesContainer:update( dt )
   for i, bonus in pairs( self.bonuses ) do
      bonus:update( dt )
      if bonus.to_destroy then
	 bonus.collider:remove( bonus.collider_shape )
	 self.bonuses[i] = nil
      end
   end   
end

function BonusesContainer:draw()
   for _, bonus in pairs( self.bonuses ) do
      bonus:draw()
   end   
end

function BonusesContainer:add_bonus( new_bonus_properties )
   local bonustype = new_bonus_properties.bonustype
   if bonustype == 0 then
      bonustype = Bonus:random_bonustype()
   end
   if bonustype then
      new_bonus_properties.bonustype = bonustype
      local new_bonus = Bonus:new( new_bonus_properties )
      table.insert( self.bonuses, new_bonus )
   end
end

return BonusesContainer
