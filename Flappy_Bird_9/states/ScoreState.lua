ScoreState = Class {__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState: update(dt)
    --go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end 
end

function ScoreState:render()
    --render the score tot he middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oh No! You Lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: '..tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end 
