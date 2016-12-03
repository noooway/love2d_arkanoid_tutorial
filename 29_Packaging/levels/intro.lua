local level = {}

local print = print

if setfenv then
   setfenv(1, level) -- for 5.1
else
   _ENV = level -- for 5.2
end

name = "intro" 

bricks = {
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 11, 12, 13, 13, 12, 11, 00},
   {00, 11, 12, 13, 13, 12, 11, 00},
   {00, 11, 12, 13, 13, 12, 11, 00},
   {00, 11, 12, 13, 13, 12, 11, 00},
   {00, 11, 12, 13, 13, 12, 11, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
}

bonuses = {
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
   {00, 00, 00, 00, 00, 00, 00, 00},
}

return level
