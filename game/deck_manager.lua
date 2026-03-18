local MonsterCard = require "game.cards.monster_card"
local TreasureCard = require "game.cards.treasure_card"
local DBManager = require "data.db_manager"

local DeckManager = {}
DeckManager.__index = DeckManager

function DeckManager:new()
    local obj = {
        monstersDeck = {},
        treasuresDeck = {},
        eventsDeck = {}
    }
    setmetatable(obj, DeckManager)
    
    obj:buildDecks()
    return obj
end

function DeckManager:buildDecks()
    -- Conecta ao nosso banco de dados JSON
    local db = DBManager:loadDatabase()
    
    if not db then return end

    -- Fabrica os Monstros
    if db.monsters then
        for _, data in ipairs(db.monsters) do
            table.insert(self.monstersDeck, MonsterCard:new(data))
        end
    end
    
    -- Fabrica os Tesouros
    if db.treasures then
        for _, data in ipairs(db.treasures) do
            table.insert(self.treasuresDeck, TreasureCard:new(data))
        end
    end
    
    print("Total de Monstros gerados: " .. #self.monstersDeck)
    print("Total de Tesouros gerados: " .. #self.treasuresDeck)
end

function DeckManager:drawCard(deckName)
    local deck = self[deckName]
    if deck and #deck > 0 then
        return table.remove(deck, 1)
    end
    return nil
end

return DeckManager