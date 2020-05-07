require 'src/Dependencies'

function love.load()
    --recall the nearest neighbor filter eliminates pixel filtering (no blurriness)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --recall we seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    --set the application title bar
    love.window.setTitle('Breakout')

    --initialize out retro fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    --initialize our graphics
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['heart'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    --initialize our virtual resolution, which wil be rendered within our
    --actual window no matter the dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --initialize our sounds/music
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')

    --we'll use this table to keep track of which keys have bene pressed this frame, to get around
    --the act that LOVE's default callback won't let us test for input within other functions
    love.keyboard.keysPressed = {}
end

--this function is called whenever the dimendions of our window is changed, as if by
--dragging out it's bottom corner
function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    gStateMachine:update(dt)

    --reset keys pressed
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

--[[
    A custom function that will let us test for individual keystrokes outside of the default 'love.keypressed'
    call back, since we can't call that logic elsewhere by default
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:apply('start')

    --background should be drawn regardless of state, scaled to fit our virtual resolution
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        --draw at coordinates 0,0
        0,0,
        --no rotation
         0,
        --scale factors on X and Y axis so it fils the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    --use the state machine to defer rendering to the current state we're in
    gStateMachine:render()

    --display FPS for debugging; simply comment out to remove
    displayFPS()

    push:apply('end')
end

function displayFPS()
    --simple FPS display across all States 
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS:'..tostring(love.timer.getFPS()), 5, 5)
    
end