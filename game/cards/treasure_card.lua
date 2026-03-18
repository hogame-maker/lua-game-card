local Card = require "game.card"

local TreasureCard = setmetatable({}, {__index = Card})
TreasureCard.__index = TreasureCard

function TreasureCard:new(data)
    data.type = "TESOURO"
    
    local obj = Card.new(self, data)
    
    -- Dados mecânicos exclusivos de Tesouros
    obj.isEquipped = false
    obj.equippedHero = nil
    
    return obj
end

function TreasureCard:equip(hero)
    self.isEquipped = true
    self.equippedHero = hero
    print(self.name .. " equipado em " .. hero.name)
end

return TreasureCard