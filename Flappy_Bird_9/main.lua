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

--all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

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

--point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

--point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT =514

--our bird sprite
local bird = Bird()

--our table of spawning PipePairs
local pipePairs = {}

local spawnTimer = 0

--initialize our last recorded Y value for a gap placement
local lastY = -PIPE_HEIGHT + math.random(80) + 20

--scrolling variable to pause the game when we collide with a pipe
local scrolling = true

function love.load()
    --inintalize our nearest neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('50 Bird')

    math.randomseed(os.time())

    --initialze retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont) 

    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --intialize state machine with all state running functions
    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end,
        ['play'] = function () return PlayState() end,
        ['score'] = function() return ScoreState() end 
    }
    gStateMachine:change('title') 

    --initialize input table
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
        % GROUND_LOOPING_POINT

        --now we just update the state machine, which defers to the right StateMachine
        gStateMachine:update(dt)
        
        --reset input table
        love.keyboard.keysPressed = {} 
end 

function love.draw()
    push: start()

    --draw state machine between the background and ground, which defers
    --render logioc to the currently active state
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render() 
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push: finish()
end


