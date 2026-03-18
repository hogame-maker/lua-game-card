local TurnManager = require "game.turn_manager"
local DeckManager = require "game.deck_manager"
local Player = require "game.player"

local GameState = {}

function GameState:init()
    self.deckManager = DeckManager:new()
    
    -- Jogo padrão com 2 jogadores
    self.players = {
        Player:new("Jogador 1"),
        Player:new("Jogador 2") -- Atuará como Oponente inicial nos combates
    }
    
    self.currentPlayerIndex = 1
    TurnManager:init(self)
end

function GameState:update(dt)
    TurnManager:update(dt)
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