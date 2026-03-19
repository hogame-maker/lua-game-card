local Button = {}
Button.__index = Button

function Button:new(x, y, w, h, text, callback)
    local obj = {
        x = x, y = y, w = w, h = h,
        text = text,
        onClick = callback,
        alpha = 1,
        hovered = false,
        hoverScale = 1,
        isPressed = false,
        pressAlpha = 0,
        
        -- Cores preto
        normalColor = {0.2, 0.2, 0.2},      -- Preto
        hoverColor = {0.4, 0.4, 0.4},      -- Preto claro
        pressColor = {0.1, 0.1, 0.1},      -- Preto escuro
        
        -- Fonte
        font = love.graphics.newFont(16)
    }
    setmetatable(obj, Button)
    return obj
end

function Button:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.w and
           my >= self.y and my <= self.y + self.h
end

function Button:update(dt)
    -- Animação smooth hover
    if self.hovered then
        self.hoverScale = math.min(1.05, self.hoverScale + dt * 3)
    else
        self.hoverScale = math.max(1, self.hoverScale - dt * 3)
    end
end

function Button:draw()
    local prevFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    
    -- Calcular escala e posição para efeito de zoom
    local centerX = self.x + self.w / 2
    local centerY = self.y + self.h / 2
    local scale = self.hoverScale
    local drawX = centerX - (self.w * scale) / 2
    local drawY = centerY - (self.h * scale) / 2
    
    -- Cores baseadas no estado
    local r, g, b = unpack(self.normalColor)
    if self.hovered then
        r, g, b = unpack(self.hoverColor)
    end
    if self.isPressed then
        r, g, b = unpack(self.pressColor)
    end
    
    -- Desenha sombra
    love.graphics.setColor(0, 0, 0, 0.3 * self.alpha)
    love.graphics.rectangle("fill", drawX + 4, drawY + 4, self.w * scale, self.h * scale, 8)
    
    -- Desenha fundo do botão
    love.graphics.setColor(r, g, b, self.alpha)
    love.graphics.rectangle("fill", drawX, drawY, self.w * scale, self.h * scale, 8)
    
    -- Desenha borda
    love.graphics.setColor(1, 1, 1, self.alpha * 0.6)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", drawX, drawY, self.w * scale, self.h * scale, 8)
    
    -- Desenha texto centralizado
    love.graphics.setColor(1, 1, 1, self.alpha)
    local textWidth = self.font:getWidth(self.text)
    local textHeight = self.font:getHeight()
    love.graphics.print(
        self.text,
        drawX + (self.w * scale - textWidth) / 2,
        drawY + (self.h * scale - textHeight) / 2
    )
    
    love.graphics.setLineWidth(1)
    love.graphics.setFont(prevFont)
    love.graphics.setColor(1, 1, 1)
end

return Button