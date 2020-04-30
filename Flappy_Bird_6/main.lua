--virtual resolution handling library
push = require 'push'

--classic OOP class library
Class = require 'class'

--bird class we've written
require 'Bird'

--pipe class we've written
require 'Pipe'

--class representing pair of pipes together
require 'PipePair'

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

--our bird sprite
local bird = Bird()

--our table of spawning PipePairs
local pipePairs = {}

local spawnTimer = 0

--initialize our last recorded Y value for a gap placement
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    --inintalize our nearest neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('50 Bird')

    math.randomseed(os.time())

    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end 

function love.update(dt)
    --scroll background by preset speed * dt, looping back to 0 after the loop ends?
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    --scroll ground by preset speed * dt, looping back to 0 after the screen 
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH

        spawnTimer = spawnTimer + dt

        --spawn a new PipePair if the timer is past 2 seconds
        if spawnTimer > 2 then
            --modify the last Y coordinate we placed so pipes aren't too far
            --no higher than 10 pixels below the top edge of the screen
            --and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10,
                math.min (lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
                lastY = y

            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
        end 
        
        bird:update(dt)

        for k, pair in pairs(pipePairs) do
            pair:update(dt)
        end 

        --remove any flagged pipes
        --we need a second loop, rather than deleting in the previous loop,
        --modifying the table in-place without explicit keys will resilt in skipped
        --next pipe, since all implicit keys (numerical indices) are automatically
        --down after a table removal
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end 
        

        --reset input table
        love.keyboard.keysPressed = {} 
end 

function love.draw()
    push: start()

    --draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    --render all the pipe pairs
    for k, pair in pairs(pipePairs) do
        pair:render()
    end 
    
    --draw the ground on top of the background, toward the bottom of the screen
    --at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --render our bird to the screen using its own render logic
    bird: render()
    
    push: finish()
end


