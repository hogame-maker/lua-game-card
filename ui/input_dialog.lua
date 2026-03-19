local Button = require "ui.button"

local InputDialog = {}
InputDialog.__index = InputDialog

function InputDialog:new(title, placeholder, onConfirm, onCancel)
    local obj = {
        title = title,
        placeholder = placeholder,
        onConfirm = onConfirm,
        onCancel = onCancel,
        
        -- Tamanho e posição
        width = 600,
        height = 300,
        
        -- Input
        inputText = "",
        maxLength = 30,
        inputActive = false,
        cursorAlpha = 1,
        cursorTimer = 0,
        
        -- Estados
        visible = false,
        alpha = 0,
        targetAlpha = 0,
        
        -- Cores
        inputBgColor = {0.15, 0.15, 0.15},
        inputBorderColor = {0.5, 0.5, 0.5},
        focusedBorderColor = {0.8, 0.4, 0.2},
        
        -- Fonte
        titleFont = love.graphics.newFont(20),
        inputFont = love.graphics.newFont(16)
    }
    setmetatable(obj, InputDialog)
    
    -- Precisa ser calculado dinamicamente
    obj.confirmButton = nil
    obj.cancelButton = nil
    
    return obj
end

function InputDialog:show()
    self.visible = true
    self.targetAlpha = 1
    self.inputText = ""
    self.inputActive = true
    self.cursorAlpha = 1
    self.cursorTimer = 0
    
    -- Cria botões na primeira vez que mostra
    if not self.confirmButton then
        local modalX = (1280 - self.width) / 2
        local modalY = (720 - self.height) / 2
        local buttonY = modalY + 200
        local btnW = 120
        local btnH = 40
        
        local confirmX = modalX + (self.width / 2) - btnW - 10
        local cancelX = modalX + (self.width / 2) + 10
        
        self.confirmButton = Button:new(confirmX, buttonY, btnW, btnH, "Confirmar", function()
            if self.onConfirm then
                self.onConfirm(self.inputText)
            end
            self:hide()
        end)
        
        self.cancelButton = Button:new(cancelX, buttonY, btnW, btnH, "Cancelar", function()
            if self.onCancel then
                self.onCancel()
            end
            self:hide()
        end)
    end
end

function InputDialog:hide()
    self.visible = false
    self.inputActive = false
    self.targetAlpha = 0
end

function InputDialog:update(dt)
    if not self.visible then return end
    
    self.alpha = self.alpha + (self.targetAlpha - self.alpha) * dt * 8
    
    -- Animação do cursor
    if self.inputActive then
        self.cursorTimer = self.cursorTimer + dt
        self.cursorAlpha = 0.5 + 0.5 * math.sin(self.cursorTimer * 5)
    end
    
    -- Atualiza botões
    self.confirmButton:update(dt)
    self.cancelButton:update(dt)
end

function InputDialog:mousemoved(x, y)
    if not self.visible then return end
    
    if self.confirmButton then
        self.confirmButton.hovered = self.confirmButton:isHovered(x, y)
    end
    if self.cancelButton then
        self.cancelButton.hovered = self.cancelButton:isHovered(x, y)
    end
end

function InputDialog:mousepressed(x, y, button)
    if not self.visible or button ~= 1 then return end
    
    local modalX = (1280 - self.width) / 2
    local modalY = (720 - self.height) / 2
    
    -- Check input field click
    local inputX = modalX + 50
    local inputY = modalY + 120
    local inputWidth = self.width - 100
    local inputHeight = 40
    
    if x >= inputX and x <= inputX + inputWidth and
       y >= inputY and y <= inputY + inputHeight then
        self.inputActive = true
        return
    end
    
    -- Check buttons
    if self.confirmButton and self.confirmButton:isHovered(x, y) then
        self.confirmButton:onClick()
    elseif self.cancelButton and self.cancelButton:isHovered(x, y) then
        self.cancelButton:onClick()
    else
        self.inputActive = false
    end
end

function InputDialog:textinput(text)
    if not self.inputActive or not self.visible then return end
    
    if #self.inputText < self.maxLength then
        self.inputText = self.inputText .. text
    end
end

function InputDialog:keypressed(key)
    if not self.inputActive or not self.visible then return end
    
    if key == "backspace" then
        self.inputText = self.inputText:sub(1, -2)
    elseif key == "return" then
        if self.onConfirm and #self.inputText > 0 then
            self.onConfirm(self.inputText)
        end
        self:hide()
    elseif key == "escape" then
        self:hide()
        if self.onCancel then
            self.onCancel()
        end
    end
end

function InputDialog:draw()
    if not self.visible then return end
    
    -- Fundo escuro (overlay)
    love.graphics.setColor(0, 0, 0, 0.6 * self.alpha)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
    local modalX = (1280 - self.width) / 2
    local modalY = (720 - self.height) / 2
    
    -- Fundo modal
    love.graphics.setColor(0.1, 0.1, 0.1, self.alpha)
    love.graphics.rectangle("fill", modalX, modalY, self.width, self.height, 10)
    
    -- Borda
    love.graphics.setColor(0.6, 0.6, 0.6, self.alpha)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", modalX, modalY, self.width, self.height, 10)
    
    -- Título
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 1, 1, self.alpha)
    local titleWidth = self.titleFont:getWidth(self.title)
    love.graphics.print(self.title, modalX + (self.width - titleWidth) / 2, modalY + 20)
    
    -- Input field background
    local inputX = modalX + 50
    local inputY = modalY + 120
    local inputWidth = self.width - 100
    local inputHeight = 40
    
    love.graphics.setColor(unpack(self.inputBgColor))
    love.graphics.rectangle("fill", inputX, inputY, inputWidth, inputHeight, 5)
    
    -- Input field border
    local borderColor = self.inputActive and self.focusedBorderColor or self.inputBorderColor
    love.graphics.setColor(unpack(borderColor))
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", inputX, inputY, inputWidth, inputHeight, 5)
    
    -- Input text
    love.graphics.setFont(self.inputFont)
    love.graphics.setColor(1, 1, 1, self.alpha)
    local displayText = #self.inputText > 0 and self.inputText or self.placeholder
    local textColor = #self.inputText > 0 and 1 or 0.5
    love.graphics.setColor(textColor, textColor, textColor, self.alpha)
    love.graphics.print(displayText, inputX + 10, inputY + 8)
    
    -- Cursor
    if self.inputActive and #self.inputText > 0 then
        love.graphics.setColor(1, 1, 1, self.cursorAlpha)
        local cursorX = inputX + 10 + self.inputFont:getWidth(self.inputText)
        love.graphics.line(cursorX, inputY + 8, cursorX, inputY + inputHeight - 8)
    end
    
    -- Desenha botões
    if self.confirmButton then
        self.confirmButton:draw()
    end
    if self.cancelButton then
        self.cancelButton:draw()
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end
