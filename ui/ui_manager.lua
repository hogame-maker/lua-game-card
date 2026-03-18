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

function UIManager:mousepressed(x, y, button)
    if button == 1 then
        for _, el in ipairs(self.elements) do
            if el:isHovered(x, y) and el.onClick then
                el:onClick()
            end
        end
    end
end

function UIManager:register(element)
    table.insert(self.elements, element)
end

return UIManager