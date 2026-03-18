local Card = {}
Card.__index = Card

function Card:new(data)
    local obj = {
        id = data.id or 0,
        name = data.name or "Sem Nome",
        type = data.type or "BASE",
        cost = data.cost or 0,
        attack = data.attack or 0,
        defense = data.defense or 0,
        effect = data.effect or nil, -- Função a ser executada
        imagePath = data.imagePath or nil,
        image = nil -- Será carregado visualmente depois
    }
    
    setmetatable(obj, self)
    return obj
end

-- Carrega os dados visuais apenas quando necessário
function Card:loadVisuals()
    if self.imagePath and not self.image then
        -- No LÖVE, é ideal garantir que o arquivo exista antes de carregar
        local info = love.filesystem.getInfo(self.imagePath)
        if info then
            self.image = love.graphics.newImage(self.imagePath)
        else
            print("Erro: Imagem não encontrada - " .. tostring(self.imagePath))
        end
    end
end

-- Função genérica de ativação de efeito
function Card:activateEffect(target, gameState)
    if self.effect and type(self.effect) == "function" then
        self.effect(self, target, gameState)
        print("Efeito da carta " .. self.name .. " ativado.")
    else
        print("A carta " .. self.name .. " não possui um efeito ativável.")
    end
end

-- Desenho básico para debug visual
function Card:draw(x, y, w, h)
    if self.image then
        -- Desenha a imagem redimensionada para caber no espaço
        local sx = w / self.image:getWidth()
        local sy = h / self.image:getHeight()
        love.graphics.draw(self.image, x, y, 0, sx, sy)
    else
        -- Fallback caso não tenha imagem
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(self.name, x, y + (h/2) - 10, w, "center")
        love.graphics.setColor(1, 1, 1)
    end
end

return Card