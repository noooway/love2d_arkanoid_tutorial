local level = {}

local print = print

if setfenv then
   setfenv(1, level) -- for 5.1
else
   _ENV = level -- for 5.2
end

name = "waka-waka-waka" 

bricks = {
   {12, 12, 12, 16, 16, 13, 13, 13},
   {12, 12, 16, 16, 16, 16, 13, 13},
   {12, 16, 16, 16, 16, 16, 16, 13},
   {12, 16, 12, 12, 16, 12, 12, 13},
   {12, 16, 12, 12, 16, 12, 12, 13},
   {16, 16, 16, 16, 16, 16, 16, 16},
   {16, 16, 16, 16, 16, 16, 16, 16},
   {16, 16, 16, 16, 16, 16, 16, 16},
   {16, 16, 16, 11, 11, 16, 16, 16},
   {16, 11, 16, 11, 11, 16, 11, 16},
   {11, 11, 11, 11, 11, 11, 11, 11},
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
