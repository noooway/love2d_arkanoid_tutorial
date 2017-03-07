local levels = {}

levels.current_level = 1
levels.gamefinished = false
levels.sequence = require "levels/sequence" 

function levels.require_current_level()
   local level_filename = "levels/" ..
      levels.sequence[ levels.current_level ]
   local level = require( level_filename )
   return level
end

return levels
