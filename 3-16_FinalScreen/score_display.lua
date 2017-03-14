local vector = require "vector"

local score_display = {}
score_display.score = 0

local position = vector( 650, 32 )
local width = 120
local height = 65
local separation = 35
local bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30 )

function score_display.update( dt )
end

function score_display.draw()
   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 255, 255, 255, 230 )
   love.graphics.printf( "Score:",
			 position.x,
			 position.y,
			 width,
			 "center" )
   love.graphics.printf( score_display.score,
			 position.x,
			 position.y + separation,
			 width,
			 "center" )
   love.graphics.setFont( oldfont )
   love.graphics.setColor( r, g, b, a )
end

function score_display.add_score_for_simple_brick()
   score_display.score = score_display.score + 10
end

function score_display.add_score_for_cracked_brick()
   score_display.score = score_display.score + 30
end

function score_display.reset()
   score_display.score = 0
end

return score_display
