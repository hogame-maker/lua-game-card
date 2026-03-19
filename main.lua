-- Importação de módulos
local GameState = require "game.game_state"
local UIManager = require "ui.ui_manager"
local Button = require "ui.button"
local Modal = require "ui.modal"

local currentState = "splash"
local splashTimer = 0
local splashDuration = 3
local splashAlpha = 0
local loginTimer = 0
local background
local bgScaleX, bgScaleY
local selectSaveModal

local function startGame()
    selectSaveModal:show()
end

local function exitGame()
    love.event.quit()
end

local function onSelectSave(saveIndex, saveData)
    currentState = "game"
    UIManager:clear()
    print("Save selecionado:", saveIndex, saveData.characterName)
end

function love.load()
    -- Inicializa fontes e assets principais
    love.graphics.setDefaultFilter("linear", "linear")
    
    -- Carrega background
    background = love.graphics.newImage("imagecard/background.png")
    local bgWidth, bgHeight = background:getDimensions()
    bgScaleX = 1280 / bgWidth
    bgScaleY = 720 / bgHeight
    
    -- Inicializa o estado principal do jogo
    GameState:init()
    UIManager:init()
    
    -- Inicializa modal de seleção de saves
    selectSaveModal = Modal:new("Selecione um Save", onSelectSave)
end

function love.update(dt)
    if currentState == "splash" then
        splashTimer = splashTimer + dt
        splashAlpha = math.min(1, splashAlpha + dt * 2)  -- Fade in
        if splashTimer >= splashDuration then
            currentState = "login"
            -- Init login UI - Botões centralizados, um em cima do outro
            local startButton = Button:new(540, 280, 200, 50, "Iniciar Game", startGame)
            local exitButton = Button:new(540, 350, 200, 50, "Sair do Game", exitGame)
            startButton.alpha = 0
            exitButton.alpha = 0
            UIManager:register(startButton)
            UIManager:register(exitButton)
        end
    elseif currentState == "login" then
        -- Animate buttons fade in
        for _, el in ipairs(UIManager.elements) do
            el.alpha = math.min(1, el.alpha + dt * 2)
        end
    elseif currentState == "game" then
        GameState:update(dt)
        UIManager:update(dt)
    end
    
    -- Atualiza modal
    selectSaveModal:update(dt)
end

function love.draw()
    -- Draw background
    love.graphics.draw(background, 0, 0, 0, bgScaleX, bgScaleY)
    
    if currentState == "splash" then
        love.graphics.setColor(1, 1, 1, splashAlpha)
        love.graphics.setColor(1, 1, 1)
    elseif currentState == "login" then
        UIManager:draw()
    elseif currentState == "game" then
        GameState:draw()
        UIManager:draw()
    end
    
    -- Desenha modal por cima de tudo
    selectSaveModal:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    selectSaveModal:mousepressed(x, y, button)
    UIManager:mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    selectSaveModal:mousemoved(x, y)
    UIManager:mousemoved(x, y)
end