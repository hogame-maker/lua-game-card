local Button = require "ui.button"
local PlayerInfoPanel = require "ui.player_info_panel"

local GameMenu = {}
GameMenu.__index = GameMenu

function GameMenu:new(gameState, onTemple, onTavern, onBattle, onReturn)
    local obj = {
        gameState = gameState,
        player = gameState.players[1],  -- Jogador atual
        
        -- Callbacks
        onTemple = onTemple,
        onTavern = onTavern,
        onBattle = onBattle,
        onReturn = onReturn,
        
        -- Background
        background = nil,
        bgScaleX = 1,
        bgScaleY = 1,
        
        -- Components
        playerPanel = nil,
        templeButton = nil,
        tavernButton = nil,
        battleButton = nil,
        
        -- Layout
        visible = false,
        alpha = 0,
        targetAlpha = 1
    }
    setmetatable(obj, GameMenu)
    
    -- Carrega background
    pcall(function()
        obj.background = love.graphics.newImage("imagecard/Menu_principal.png")
        local bgWidth, bgHeight = obj.background:getDimensions()
        obj.bgScaleX = 1280 / bgWidth
        obj.bgScaleY = 720 / bgHeight
    end)
    
    -- Player info panel no canto superior esquerdo
    obj.playerPanel = PlayerInfoPanel:new(10, 10, 350, 70, obj.player)
    
    -- Botões do menu centralizados e bem espaçados
    local buttonWidth = 380
    local buttonHeight = 90
    local centerX = (1280 - buttonWidth) / 2
    local startY = 150
    local spacing = 140  -- Espaço entre botões
    
    -- Templo
    obj.templeButton = Button:new(centerX, startY, buttonWidth, buttonHeight, "TEMPLO", onTemple)
    
    -- Taverna
    obj.tavernButton = Button:new(centerX, startY + spacing, buttonWidth, buttonHeight, "TAVERNA", onTavern)
    
    -- Batalha em Terrenos
    obj.battleButton = Button:new(centerX, startY + spacing * 2, buttonWidth, buttonHeight, "BATALHA EM\nTERREÑOS", onBattle)
    
    return obj
end

function GameMenu:show()
    self.visible = true
    self.targetAlpha = 1
end

function GameMenu:hide()
    self.visible = false
    self.targetAlpha = 0
end

function GameMenu:update(dt)
    if not self.visible then return end
    
    self.alpha = self.alpha + (self.targetAlpha - self.alpha) * dt * 8
    
    -- Atualiza componentes
    self.playerPanel:update(dt)
    self.templeButton:update(dt)
    self.tavernButton:update(dt)
    self.battleButton:update(dt)
end

function GameMenu:mousemoved(x, y)
    if not self.visible then return end
    
    self.templeButton.hovered = self.templeButton:isHovered(x, y)
    self.tavernButton.hovered = self.tavernButton:isHovered(x, y)
    self.battleButton.hovered = self.battleButton:isHovered(x, y)
    
    self.playerPanel:isHovered(x, y)
end

function GameMenu:mousepressed(x, y, button)
    if not self.visible or button ~= 1 then return end
    
    if self.templeButton:isHovered(x, y) then
        self.templeButton:onClick()
    elseif self.tavernButton:isHovered(x, y) then
        self.tavernButton:onClick()
    elseif self.battleButton:isHovered(x, y) then
        self.battleButton:onClick()
    end
end

function GameMenu:draw()
    if not self.visible then return end
    
    love.graphics.setColor(1, 1, 1, self.alpha)
    
    -- Background
    if self.background then
        love.graphics.draw(self.background, 0, 0, 0, self.bgScaleX, self.bgScaleY)
    else
        -- Fallback color
        love.graphics.setColor(0.1, 0.1, 0.12, self.alpha)
        love.graphics.rectangle("fill", 0, 0, 1280, 720)
    end
    
    -- Overlay semi-transparente para melhor legibilidade
    love.graphics.setColor(0, 0, 0, 0.3 * self.alpha)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
    love.graphics.setColor(1, 1, 1, self.alpha)
    
    -- Player panel
    self.playerPanel:draw()
    
    -- Título do menu
    local titleFont = love.graphics.newFont(32)
    local prevFont = love.graphics.getFont()
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1, self.alpha)
    local titleText = "Modos de Jogo"
    local titleWidth = titleFont:getWidth(titleText)
    love.graphics.print(titleText, (1280 - titleWidth) / 2, 90)
    love.graphics.setFont(prevFont)
    
    -- Botões do menu
    self.templeButton:draw()
    self.tavernButton:draw()
    self.battleButton:draw()
    
    love.graphics.setColor(1, 1, 1)
end

return GameMenu
