local gamestates = {}

local current_state = nil

function gamestates.set_state( new_state, ... )
  gamestates.state_event( 'exit' )
  current_state = new_state
  if current_state.load then
     gamestates.state_event( 'load', ... )
     current_state.load = nil
  end
  gamestates.state_event( 'enter', ... )
end

function gamestates.state_event( function_name, ... )
   if current_state and type( current_state[function_name] ) == 'function' then
      current_state[function_name](...)
   end
end

return gamestates
