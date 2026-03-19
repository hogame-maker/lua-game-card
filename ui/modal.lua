local SaveSlot = require "ui.save_slot"

local Modal = {}
Modal.__index = Modal

function Modal:new(title, onSelectCallback, onCancelCallback)
    local obj = {
        title = title,
        onSelectCallback = onSelectCallback,
        onCancelCallback = onCancelCallback,
        
        -- Tamanho e posição
        width = 1200,
        height = 650,
        
        -- Botão voltar
        backButton = {w = 120, h = 35, offsetX = 30, offsetY = 25},
        
        -- Estados
        visible = false,
        alpha = 0,
        targetAlpha = 0,
        
        -- Dados de saves
        saveSlots = {},
        
        -- Fontes
        titleFont = love.graphics.newFont(24),
        font = love.graphics.newFont(16)
    }
    
    setmetatable(obj, Modal)
    
    -- Cria 3 save slots com dados zerados (tempo = 0)
    local saves = {
        {
            id = 1,
            characterName = "Save 1",
            playTime = 0,
            lastPlayed = "Nunca"
        },
        {
            id = 2,
            characterName = "Save 2",
            playTime = 0,
            lastPlayed = "Nunca"
        },
        {
            id = 3,
            characterName = "Novo Save",
            playTime = 0,
            lastPlayed = "Nunca"
        }
    }
    
    for i, saveData in ipairs(saves) do
        local slot = SaveSlot:new(
            200 + (i - 1) * 320,
            150,
            280,
            450,
            saveData
        )
        table.insert(obj.saveSlots, slot)
    end
    
    return obj
end

function Modal:show()
    self.visible = true
    self.targetAlpha = 0.95
    self.alpha = 0.95 -- mostra imediatamente
end

function Modal:hide()
    self.targetAlpha = 0
    self.alpha = 0 -- fecha imediatamente
    self.visible = false
end

function Modal:update(dt)
    if self.visible then
        -- Animação de fade in/out mais rápida
        self.alpha = self.alpha + (self.targetAlpha - self.alpha) * dt * 12
        
        if self.targetAlpha == 0 and self.alpha < 0.02 then
            self.visible = false
            self.alpha = 0
        end
        
        -- Atualiza os save slots
        for _, slot in ipairs(self.saveSlots) do
            slot:update(dt)
        end
    end
end

function Modal:mousemoved(x, y)
    if not self.visible then return end
    
    for _, slot in ipairs(self.saveSlots) do
        slot.hovered = slot:isHovered(x, y)
    end
end

function Modal:mousepressed(x, y, button)
    if not self.visible or button ~= 1 then return end

    local modalX = (1280 - self.width) / 2
    local modalY = (720 - self.height) / 2
    local b = self.backButton
    local backX = modalX + b.offsetX
    local backY = modalY + b.offsetY

    if x >= backX and x <= backX + b.w and y >= backY and y <= backY + b.h then
        self:hide()
        if self.onCancelCallback then
            self.onCancelCallback()
        end
        return
    end

    for i, slot in ipairs(self.saveSlots) do
        if slot:isHovered(x, y) then
            if self.onSelectCallback then
                self.onSelectCallback(i, slot.saveData)
            end
            self:hide()
            break
        end
    end
end

function Modal:draw()
    if not self.visible then return end
    
    -- Fundo escuro (overlay)
    love.graphics.setColor(0, 0, 0, 0.7 * self.alpha)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
    -- Fundo modal preto
    local modalX = (1280 - self.width) / 2
    local modalY = (720 - self.height) / 2
    
    love.graphics.setColor(0.1, 0.1, 0.1, self.alpha)
    love.graphics.rectangle("fill", modalX, modalY, self.width, self.height, 15)
    
    -- Borda
    love.graphics.setColor(0.5, 0.5, 0.5, self.alpha)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", modalX, modalY, self.width, self.height, 15)
    
    -- Título
    local prevFont = love.graphics.getFont()
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.printf(self.title, modalX, modalY + 20, self.width, "center")

    -- Botão voltar
    local b = self.backButton
    local backX = modalX + b.offsetX
    local backY = modalY + b.offsetY
    love.graphics.setColor(0.2, 0.2, 0.2, self.alpha)
    love.graphics.rectangle("fill", backX, backY, b.w, b.h, 8)
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.rectangle("line", backX, backY, b.w, b.h, 8)
    love.graphics.setFont(self.font)
    love.graphics.printf("Voltar", backX, backY + 8, b.w, "center")
    
    -- Draw save slots
    love.graphics.setFont(prevFont)
    for _, slot in ipairs(self.saveSlots) do
        slot:draw()
    end
    
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
end

return Modal
