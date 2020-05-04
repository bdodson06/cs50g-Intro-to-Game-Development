InstructionState = Class{__includes = BaseState}

function InstructionState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') 
    or love.keyboard.wasPressed('kpenter') then
        gStateMachine:change('countdown')
    end
end

function InstructionState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('How to Play:', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('To Make Fifty Bird Jump Press the Spacebar!', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Try to Stay Away From the Ground, and be Sure to Watch out for the Pipes!', 0, 130, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('If You Need to Pause the Game Just Press the "P" key!', 0, 175, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to Continue', 0, 250, VIRTUAL_WIDTH, 'center')
end