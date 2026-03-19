local PlayerInfoPanel = {}
PlayerInfoPanel.__index = PlayerInfoPanel

function PlayerInfoPanel:new(x, y, w, h, player)
    local obj = {
        x = x, y = y,
        w = w, h = h,
        player = player,
        
        -- Dados do jogador
        level = player.level or 1,
        gold = player.gold or 0,
        experience = player.experience or 0,
        playerPhoto = nil,  -- será carregada de um asset
        
        -- Animação
        hoverScale = 1,
        targetScale = 1,
        
        -- Cores
        bgColor = {0.15, 0.15, 0.15},
        borderColor = {0.6, 0.6, 0.6},
        accentColor = {0.8, 0.4, 0.2},
        
        -- Fonte
        nameFont = love.graphics.newFont(18),
        statFont = love.graphics.newFont(14),
        labelFont = love.graphics.newFont(12)
    }
    setmetatable(obj, PlayerInfoPanel)
    
    -- Tenta carregar foto do jogador (placeholder)
    if obj.player.photoPath then
        pcall(function()
            obj.playerPhoto = love.graphics.newImage(obj.player.photoPath)
        end)
    end
    
    return obj
end

function PlayerInfoPanel:update(dt)
    self.hoverScale = self.hoverScale + (self.targetScale - self.hoverScale) * dt * 5
end

function PlayerInfoPanel:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.w and
           my >= self.y and my <= self.y + self.h
end

function PlayerInfoPanel:draw()
    -- Fundo
    love.graphics.setColor(unpack(self.bgColor))
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 8)
    
    -- Borda
    love.graphics.setColor(unpack(self.borderColor))
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h, 8)
    
    -- Foto do jogador (lado esquerdo)
    local photoSize = self.h - 10
    local photoX = self.x + 5
    local photoY = self.y + 5
    
    if self.playerPhoto then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.playerPhoto, photoX, photoY, 0, photoSize / self.playerPhoto:getHeight(), photoSize / self.playerPhoto:getHeight())
    else
        -- Placeholder circle
        love.graphics.setColor(unpack(self.accentColor))
        love.graphics.circle("fill", photoX + photoSize / 2, photoY + photoSize / 2, photoSize / 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("line", photoX + photoSize / 2, photoY + photoSize / 2, photoSize / 2)
    end
    
    -- Informações do jogador (lado direito)
    local infoX = photoX + photoSize + 15
    local infoY = self.y + 8
    
    -- Nome
    love.graphics.setFont(self.nameFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.player.name or "Jogador", infoX, infoY)
    
    -- Level
    love.graphics.setFont(self.statFont)
    love.graphics.setColor(unpack(self.accentColor))
    love.graphics.print("Level: " .. (self.player.level or 1), infoX, infoY + 25)
    
    -- Gold
    love.graphics.setColor(1, 0.84, 0)  -- Cor de ouro
    love.graphics.print("Gold: " .. (self.player.gold or 0), infoX, infoY + 45)
    
    -- Experience bar
    local expBarX = infoX
    local expBarY = infoY + 65
    local expBarWidth = self.w - (infoX - self.x) - 10
    local expBarHeight = 8
    
    -- Label EXP
    love.graphics.setFont(self.labelFont)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("EXP", expBarX, expBarY - 15)
    
    -- Background da barra
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", expBarX, expBarY, expBarWidth, expBarHeight, 3)
    
    -- Barra de experiência
    local expPercentage = (self.player.experience or 0) % 100 / 100
    love.graphics.setColor(unpack(self.accentColor))
    love.graphics.rectangle("fill", expBarX, expBarY, expBarWidth * expPercentage, expBarHeight, 3)
    
    -- Borda da barra
    love.graphics.setColor(unpack(self.borderColor))
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", expBarX, expBarY, expBarWidth, expBarHeight, 3)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return PlayerInfoPanel
