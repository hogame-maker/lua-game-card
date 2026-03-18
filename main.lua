-- Importação de módulos
local GameState = require "game.game_state"
local UIManager = require "ui.ui_manager"

function love.load()
    -- Inicializa fontes e assets principais
    love.graphics.setDefaultFilter("linear", "linear")
    
    -- Inicializa o estado principal do jogo
    GameState:init()
    UIManager:init()
end

function love.update(dt)
    GameState:update(dt)
    UIManager:update(dt)
end

function love.draw()
    GameState:draw()
    UIManager:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    UIManager:mousepressed(x, y, button)
end