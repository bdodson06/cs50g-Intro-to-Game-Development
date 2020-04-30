--virtual resolution handling library
push = require 'push'

--classic OOP class library
Class = require 'class'

--bird class we've written
require 'Bird'

--physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--in game "Virtual" screen dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

--ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

--speed at which we should scroll our images scaled by 
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

function love.load()
    --inintalize our nearest neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('50 Bird')

    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    --scroll background by preset speed * dt, looping back to 0 after the loop ends?
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    --scroll ground by preset speed * dt, looping back to 0 after the screen 
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

        bird:update(dt)
end 

function love.draw()
    push: start()

    --draw the background starting at top left (0,0)
    love.graphics.draw(background, -backgroundScroll, 0)
    
    --draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird: render()
    
    push: finish()
end


