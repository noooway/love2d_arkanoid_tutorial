local level = {}

if setfenv then
   setfenv(1, level) -- for 5.1
else
   _ENV = level -- for 5.2
end

name = "first" 

bricks = {
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {3, 3, 3, 3, 3, 3, 3, 3, 3, 3},
   {2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
}

return level