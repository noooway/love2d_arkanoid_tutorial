local vector = require "vector"
local lives_display = require "lives_display"
local score_display = require "score_display"

local side_panel = {}
local position_x = 608
local width = 200
local height_top = 160
local height_middle = 288
local height_bottom = 160
local position_top = vector( position_x, 0 )   
local position_middle = vector( position_x, height_top )
local position_bottom = vector( position_x, height_top + height_middle )

side_panel.lives_display = lives_display
side_panel.score_display = score_display

function side_panel.update( dt )
   side_panel.lives_display.update( dt )
   side_panel.score_display.update( dt )
end

function side_panel.draw()
   side_panel.draw_background()
   side_panel.lives_display.draw()
   side_panel.score_display.draw()
end

function side_panel.draw_background()
   local drawtype = 'fill'
   local r, g, b, a = love.graphics.getColor( )
   -- top
   love.graphics.setColor( 255, 102, 0, 255 )
   love.graphics.rectangle("fill",
			   position_top.x,
			   position_top.y,
			   width,
			   height_top )
   love.graphics.setColor( 0, 0, 0, 255 )
   love.graphics.rectangle("line",
			   position_top.x,
			   position_top.y,
			   width,
			   height_top )
   -- middle
   love.graphics.setColor( 255, 127, 42, 255 )
   love.graphics.rectangle("fill",
			   position_middle.x,
			   position_middle.y,
			   width,
			   height_middle )
   love.graphics.setColor( 0, 0, 0, 255 )
   love.graphics.rectangle("line",
			   position_middle.x,
			   position_middle.y,
			   width,
			   height_middle )
   -- bottom
   love.graphics.setColor( 255, 102, 0, 255 )
   love.graphics.rectangle("fill",
			   position_bottom.x,
			   position_bottom.y,
			   width,
			   height_bottom )
   love.graphics.setColor( 0, 0, 0, 255 )
   love.graphics.rectangle("line",
			   position_bottom.x,
			   position_bottom.y,
			   width,
			   height_bottom )   
   love.graphics.setColor( r, g, b, a )      
end

function side_panel.add_life_if_score_reached()
   side_panel.lives_display.add_life_if_score_reached(
      side_panel.score_display.score )
end

function side_panel.reset()
   side_panel.lives_display.reset()
   side_panel.score_display.reset()
end

return side_panel
