-- Importação de módulos
local GameState = require "game.game_state"
local UIManager = require "ui.ui_manager"
local Button = require "ui.button"
local Modal = require "ui.modal"
local SaveManager = require "data.save_manager"
local InputDialog = require "ui.input_dialog"
local GameMenu = require "ui.game_menu"

local currentState = "splash"
local saveManager = nil
local splashTimer = 0
local splashDuration = 3
local splashAlpha = 0
local loginTimer = 0
local background
local bgScaleX, bgScaleY
local selectSaveModal
local inputDialog
local gameMenu
local currentSaveIndex = nil

local function startGame()
    selectSaveModal:refreshSaveSlots()
    selectSaveModal:show()
end

local function exitGame()
    love.event.quit()
end

local function setupLoginButtons()
    UIManager:clear()
    local startButton = Button:new(540, 280, 200, 50, "Iniciar Game", startGame)
    local exitButton = Button:new(540, 350, 200, 50, "Sair do Game", exitGame)
    startButton.alpha = 1
    exitButton.alpha = 1
    UIManager:register(startButton)
    UIManager:register(exitButton)
end

local function onSelectSave(saveIndex, saveData, slotUI)
    currentSaveIndex = saveIndex
    
    if saveData then
        GameState:loadFromSaveData(saveData)
    else
        GameState:init()
    end
    
    -- Cria/atualiza o GameMenu com o estado atual (para ambos os casos)
    gameMenu = GameMenu:new(
        GameState,
        function() print("Templo") end,
        function() print("Taverna") end,
        function() print("Batalha em Terrenos") end,
        function() 
            currentState = "login"
            gameMenu:hide()
            setupLoginButtons()
        end
    )
    
    if saveData then
        -- Se já tem dados salvos, vai direto para o menu principal
        currentState = "main_menu"
        selectSaveModal:hide()
        gameMenu:show()
    else
        -- Se é um novo save, pede o nome do jogador
        currentState = "name_input"
        selectSaveModal:hide()
        inputDialog:show()
    end
end

local function onPlayerNameConfirmed(playerName)
    -- Define o nome do jogador
    GameState.players[1].name = playerName
    GameState.players[1].level = 1
    GameState.players[1].gold = 0
    GameState.players[1].experience = 0
    
    -- Salva o estado do jogo ao iniciar
    local newSave = GameState:toSaveData()
    saveManager:setSlot(currentSaveIndex, newSave)
    
    -- Atualiza o modal e vai para o menu principal
    selectSaveModal:refreshSaveSlots()
    
    -- Cria/atualiza o GameMenu com o estado atual
    gameMenu = GameMenu:new(
        GameState,
        function() print("Templo") end,
        function() print("Taverna") end,
        function() print("Batalha em Terrenos") end,
        function() 
            currentState = "login"
            gameMenu:hide()
            setupLoginButtons()
        end
    )
    
    currentState = "main_menu"
    gameMenu:show()
end

local function onPlayerNameCancelled()
    currentState = "login"
    setupLoginButtons()
end

local function onCancelSaveSelection()
    currentState = "login"
    setupLoginButtons()
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

    saveManager = SaveManager:new()
    
    -- Inicializa componentes de UI
    selectSaveModal = Modal:new("Selecione um Save", onSelectSave, onCancelSaveSelection, saveManager)
    inputDialog = InputDialog:new("Nome do Jogador", "Digite seu nome...", onPlayerNameConfirmed, onPlayerNameCancelled)
    gameMenu = GameMenu:new(GameState, 
        function() print("Templo") end,
        function() print("Taverna") end,
        function() print("Batalha em Terrenos") end,
        function() 
            currentState = "login"
            gameMenu:hide()
            setupLoginButtons()
        end
    )

    setupLoginButtons()
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
    elseif currentState == "name_input" then
        inputDialog:update(dt)
    elseif currentState == "main_menu" then
        gameMenu:update(dt)
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
    elseif currentState == "name_input" then
        inputDialog:draw()
    elseif currentState == "main_menu" then
        gameMenu:draw()
    elseif currentState == "game" then
        GameState:draw()
        UIManager:draw()
    end
    
    -- Desenha modal por cima de tudo
    selectSaveModal:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    -- A modal de saves tem prioridade quando está visível
    if selectSaveModal.visible then
        selectSaveModal:mousepressed(x, y, button)
        return
    end
    
    if currentState == "name_input" then
        inputDialog:mousepressed(x, y, button)
    elseif currentState == "main_menu" then
        gameMenu:mousepressed(x, y, button)
    elseif currentState == "login" then
        UIManager:mousepressed(x, y, button)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    -- A modal de saves tem prioridade quando está visível
    if selectSaveModal.visible then
        selectSaveModal:mousemoved(x, y)
        return
    end
    
    if currentState == "name_input" then
        inputDialog:mousemoved(x, y)
    elseif currentState == "main_menu" then
        gameMenu:mousemoved(x, y)
    elseif currentState == "login" then
        UIManager:mousemoved(x, y)
    end
end

function love.textinput(text)
    if currentState == "name_input" then
        inputDialog:textinput(text)
    end
end

function love.keypressed(key)
    if currentState == "name_input" then
        inputDialog:keypressed(key)
    end
end