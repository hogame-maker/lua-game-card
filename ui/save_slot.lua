local SaveSlot = {}
SaveSlot.__index = SaveSlot

function SaveSlot:new(x, y, w, h, saveData)
    local obj = {
        x = x, y = y,
        w = w, h = h,
        
        -- Dados do save
        saveData = saveData or {
            id = 1,
            characterName = "Sem Save",
            playTime = 0, -- em minutos
            lastPlayed = "Nunca"
        },
        
        -- States
        hovered = false,
        expandedScale = 1,
        targetScale = 1,
        
        -- Cores
        normalColor = {0.3, 0.3, 0.3},
        hoverColor = {0.5, 0.5, 0.5},
        
        -- Fonte
        font = love.graphics.newFont(14),
        smallFont = love.graphics.newFont(12)
    }
    
    setmetatable(obj, SaveSlot)
    return obj
end

function SaveSlot:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.w and
           my >= self.y and my <= self.y + self.h
end

function SaveSlot:update(dt)
    -- Animação suave de expansão
    if self.hovered then
        self.targetScale = 1.15
    else
        self.targetScale = 1
    end
    
    self.expandedScale = self.expandedScale + (self.targetScale - self.expandedScale) * dt * 5
end

function SaveSlot:draw()
    local prevFont = love.graphics.getFont()
    
    local centerX = self.x + self.w / 2
    local centerY = self.y + self.h / 2
    local drawW = self.w * self.expandedScale
    local drawH = self.h * self.expandedScale
    local drawX = centerX - drawW / 2
    local drawY = centerY - drawH / 2
    
    -- Cor baseada no estado
    local r, g, b = unpack(self.normalColor)
    if self.hovered then
        r, g, b = unpack(self.hoverColor)
    end
    
    -- Sombra
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", drawX + 3, drawY + 3, drawW, drawH, 10)
    
    -- Fundo
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", drawX, drawY, drawW, drawH, 10)
    
    -- Borda
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", drawX, drawY, drawW, drawH, 10)
    
    -- Conteúdo
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.font)
    
    -- Nome do personagem ou "Novo Save"
    local displayName = self.saveData.characterName or "Novo Save"
    if self.saveData.isEmpty then
        displayName = "Slot vazio"
    end
    love.graphics.printf(displayName, drawX + 10, drawY + 15, drawW - 20, "center")
    
    -- Se expandido, mostra informações
    if self.expandedScale > 1.05 then
        love.graphics.setFont(self.smallFont)
        love.graphics.setColor(0.9, 0.9, 0.9)

        if self.saveData.isEmpty then
            love.graphics.printf("Clique para criar um novo save", drawX + 10, drawY + 45, drawW - 20, "center")
        else
            local totalMinutes = self.saveData.playTime or 0
            local hours = math.floor(totalMinutes / 60)
            local minutes = totalMinutes % 60
            local playTimeStr = string.format("%dh %dm", hours, minutes)
            love.graphics.printf("Tempo: " .. playTimeStr, drawX + 10, drawY + 45, drawW - 20, "center")
            love.graphics.printf("Último jogo: " .. self.saveData.lastPlayed, drawX + 10, drawY + 70, drawW - 20, "center")
        end
    end
    
    love.graphics.setLineWidth(1)
    love.graphics.setFont(prevFont)
    love.graphics.setColor(1, 1, 1)
end

return SaveSlot
