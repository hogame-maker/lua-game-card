local TurnManager = require "game.turn_manager"
local DeckManager = require "game.deck_manager"
local Player = require "game.player"
local Card = require "game.card"

local GameState = {}

function GameState:init()
    self.deckManager = DeckManager:new()
    
    -- Jogo padrão com 2 jogadores
    self.players = {
        Player:new("Jogador 1"),
        Player:new("Jogador 2") -- Atuará como Oponente inicial nos combates
    }
    
    self.currentPlayerIndex = 1
    self.playTime = 0
    TurnManager:init(self)
end

function GameState:update(dt)
    self.playTime = (self.playTime or 0) + dt
    TurnManager:update(dt)
end

local function serializeCard(card)
    if not card then return nil end
    return {
        id = card.id,
        name = card.name,
        type = card.type,
        cost = card.cost,
        attack = card.attack,
        defense = card.defense,
        imagePath = card.imagePath,
        isDead = card.isDead,
        -- effect_id pode existir para reconectar efeitos no DB
        effect_id = card.effect_id,
    }
end

local function deserializeCard(data)
    if not data then return nil end
    local card = Card:new(data)
    card.isDead = data.isDead
    return card
end

function GameState:toSaveData()
    local data = {
        currentPlayerIndex = self.currentPlayerIndex,
        playTime = self.playTime or 0,
        players = {}
    }

    for i, player in ipairs(self.players) do
        local p = {
            name = player.name,
            maxHandSize = player.maxHandSize,
            playTime = player.playTime or 0,
            actions = player.actions or {},
            heroes = {},
            monsters = {},
            hand = {},
            treasures = {}
        }

        for _, h in ipairs(player.heroes) do
            table.insert(p.heroes, serializeCard(h))
        end
        for _, m in ipairs(player.monsters) do
            table.insert(p.monsters, serializeCard(m))
        end
        for _, c in ipairs(player.hand) do
            table.insert(p.hand, serializeCard(c))
        end
        for _, t in ipairs(player.treasures) do
            table.insert(p.treasures, serializeCard(t))
        end

        table.insert(data.players, p)
    end

    return data
end

function GameState:loadFromSaveData(data)
    if not data or not data.players then return end

    self.currentPlayerIndex = data.currentPlayerIndex or 1
    self.playTime = data.playTime or 0
    self.players = {}

    for _, pData in ipairs(data.players) do
        local p = Player:new(pData.name or "Jogador")
        p.maxHandSize = pData.maxHandSize or 6
        p.playTime = pData.playTime or 0
        p.actions = pData.actions or {}

        p.heroes = {}
        for _, hData in ipairs(pData.heroes or {}) do
            local hero = deserializeCard(hData)
            table.insert(p.heroes, hero)
        end

        p.monsters = {}
        for _, mData in ipairs(pData.monsters or {}) do
            local mon = deserializeCard(mData)
            table.insert(p.monsters, mon)
        end

        p.hand = {}
        for _, cData in ipairs(pData.hand or {}) do
            table.insert(p.hand, deserializeCard(cData))
        end

        p.treasures = {}
        for _, tData in ipairs(pData.treasures or {}) do
            table.insert(p.treasures, deserializeCard(tData))
        end

        table.insert(self.players, p)
    end

    TurnManager:init(self)
end

function GameState:draw()
    TurnManager:draw()
end

function GameState:getCurrentPlayer()
    return self.players[self.currentPlayerIndex]
end

function GameState:getOpponentPlayer()
    local oppIndex = self.currentPlayerIndex + 1
    if oppIndex > #self.players then oppIndex = 1 end
    return self.players[oppIndex]
end

return GameState