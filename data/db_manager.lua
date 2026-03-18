local json = require "json" -- Requer a biblioteca json.lua que você colocou na raiz

local DBManager = {}

-- Aqui nós mapeamos os IDs de efeito do banco de dados para a lógica do jogo
local EffectsMap = {
    ["defende_entrada"] = function(self, target, gameState)
        print("O " .. self.name .. " está defendendo!")
    end,
    ["sopro_fogo"] = function(self, target, gameState)
        target.defense = target.defense - 2
        print("Sopro de fogo! Defesa reduzida.")
    end,
    ["equip_espada"] = function(self, target, gameState)
        target.attack = target.attack + 2
        print("Espada equipada!")
    end
}

function DBManager:loadDatabase()
    -- Lê o arquivo JSON
    local file = love.filesystem.read("data/cards_db.json")
    
    if not file then
        print("ERRO FATAL: Banco de dados (cards_db.json) não encontrado!")
        return nil
    end
    
    -- Converte o texto JSON para tabelas Lua
    local data = json.decode(file)
    
    -- Conecta as funções de efeito às cartas
    self:linkEffects(data.monsters)
    self:linkEffects(data.treasures)
    
    print("Banco de dados JSON carregado com sucesso!")
    return data
end

function DBManager:linkEffects(cardCategory)
    if not cardCategory then return end
    
    for _, cardData in ipairs(cardCategory) do
        if cardData.effect_id and EffectsMap[cardData.effect_id] then
            cardData.effect = EffectsMap[cardData.effect_id]
        end
    end
end

return DBManager