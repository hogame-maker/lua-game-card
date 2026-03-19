local UIManager = {}

function UIManager:init()
    self.elements = {}
end

function UIManager:update(dt)
    for _, el in ipairs(self.elements) do
        if el.update then el:update(dt) end
    end
end

function UIManager:draw()
    for _, el in ipairs(self.elements) do
        if el.draw then el:draw() end
    end
end

function UIManager:mousemoved(x, y)
    for _, el in ipairs(self.elements) do
        if el.isHovered then
            el.hovered = el:isHovered(x, y)
        end
    end
end

function UIManager:mousepressed(x, y, button)
    if button == 1 then
        for _, el in ipairs(self.elements) do
            if el:isHovered(x, y) and el.onClick then
                if el.isPressed ~= nil then
                    el.isPressed = true
                end
                el:onClick()
            end
        end
    end
end

function UIManager:register(element)
    table.insert(self.elements, element)
end

function UIManager:clear()
    self.elements = {}
end

return UIManager