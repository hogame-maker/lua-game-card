local Button = {}
Button.__index = Button

function Button:new(x, y, w, h, text, callback)
    local obj = {
        x = x, y = y, w = w, h = h,
        text = text,
        onClick = callback,
        alpha = 1
    }
    setmetatable(obj, Button)
    return obj
end

function Button:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.w and
           my >= self.y and my <= self.y + self.h
end

function Button:draw()
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.print(self.text, self.x + 10, self.y + 10)
    love.graphics.setColor(1, 1, 1)
end

return Button