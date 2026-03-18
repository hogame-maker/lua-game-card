local Card = require "game.card"

local MonsterCard = setmetatable({}, {__index = Card})
MonsterCard.__index = MonsterCard

function MonsterCard:new(data)
    data.type = "MONSTRO"
    
    -- Chama o construtor da classe base
    local obj = Card.new(self, data)
    
    -- Dados mecânicos exclusivos de Monstros (Ex: recompensa de evolução do PDF)
    obj.evolutionBonus = data.evolutionBonus or {attribute = nil, value = 0}
    obj.treasureReward = data.treasureReward or 1
    
    return obj
end

-- Sobrescreve ou expande comportamentos se necessário
function MonsterCard:die(player)
    print("O monstro " .. self.name .. " foi derrotado!")
    -- Lógica de entregar tesouro e evolução
end

return MonsterCard