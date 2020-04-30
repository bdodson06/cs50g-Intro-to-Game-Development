--virtual resolution handling library
push = require 'push'

--classic OOP class library
Class = require 'class'

--bird class we've written
require 'Bird'

--pipe class we've written
require 'Pipe'

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

--our pipe sprite
local pipes = {}

local spawnTimer = 0

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

        if spawnTimer > 2 then
            table.insert(pipes, Pipe())
            spawnTimer = 0
        end 
        
        bird:update(dt)

        for k, pipe in pairs(pipes) do
            pipe:update(dt)

            if pipe.x < -pipe.width then
                table.remove(pipes, k)
            end
        end 
        

        --reset input table
        love.keyboard.keysPressed = {} 
end 

function love.draw()
    push: start()

    --draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pipe in pairs(pipes) do
        pipe:render()
    end 
    
    --draw the ground on top of the background, toward the bottom of the screen
    --at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --render our bird to the screen using its own render logic
    bird: render()
    
    push: finish()
end


