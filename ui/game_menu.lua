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
    
    -- Botões do menu no lado esquerdo
    -- Templo - topo esquerdo
    obj.templeButton = Button:new(50, 150, 300, 80, "TEMPLO", onTemple)
    
    -- Taverna - meio esquerdo
    obj.tavernButton = Button:new(50, 250, 300, 80, "TAVERNA", onTavern)
    
    -- Batalha em Terrenos - baixo esquerdo
    obj.battleButton = Button:new(50, 350, 300, 80, "BATALHA EM\nTERREÑOS", onBattle)
    
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
    
    -- Divisões e botões
    -- Templo
    self:_drawMenuSection(100, 300, 250, 200, "TEMPLO", self.templeButton)
    
    -- Taverna
    self:_drawMenuSection(515, 300, 250, 200, "TAVERNA", self.tavernButton)
    
    -- Batalha em Terrenos
    self:_drawMenuSection(930, 300, 250, 200, "BATALHA EM\nTERREÑOS", self.battleButton)
    
    -- Botões
    self.templeButton:draw()
    self.tavernButton:draw()
    self.battleButton:draw()
    self.returnButton:draw()
    
    love.graphics.setColor(1, 1, 1)
end

function GameMenu:_drawMenuSection(x, y, w, h, label, button)
    -- Sombra
    love.graphics.setColor(0, 0, 0, 0.5 * self.alpha)
    love.graphics.rectangle("fill", x + 3, y + 3, w, h, 10)
    
    -- Fundo
    love.graphics.setColor(0.15, 0.15, 0.15, 0.9 * self.alpha)
    love.graphics.rectangle("fill", x, y, w, h, 10)
    
    -- Borda com cor especial se hovering
    if button.hovered then
        love.graphics.setColor(0.8, 0.4, 0.2, self.alpha)
    else
        love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
    end
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 10)
end

return GameMenu
