local level_sequence = {}

if setfenv then
   setfenv(1, level_sequence) -- for 5.1
else
   _ENV = level_sequence -- for 5.2
end

name = "level_sequence" 

sequence = {
   "intro",
   "pcmn",
   "digger",
   "spaceship",   
   "pipeflower",
   "spaceinv",
   "test_all"
}

return level_sequence

