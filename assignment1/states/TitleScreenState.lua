--[[
    TitleScreenState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end

    --transition to Instruction state when "i" is wasPressed
    if love.keyboard.wasPressed('i') then 
        gStateMachine:change('instruction')
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('To Start Press Enter', 0, 125, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('For Instructions Press The "I" Key', 0, 175, VIRTUAL_WIDTH, 'center')
end