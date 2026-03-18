local CombatSystem = require "game.combat_system"

local TurnManager = {}

-- Fases oficias de um turno
TurnManager.PHASES = {
    DESCARTE_COMPRA = 1,
    TERRENOS = 2, -- Templo, Taverna ou Explorar
    REVELAR_MONSTROS = 3,
    COMBATE = 4,
    CONQUISTA_TESOUROS = 5
}

function TurnManager:init(gameState)
    self.gameState = gameState
    self.currentPhase = self.PHASES.DESCARTE_COMPRA
end

function TurnManager:nextPhase()
    self.currentPhase = self.currentPhase + 1
    if self.currentPhase > self.PHASES.CONQUISTA_TESOUROS then
        self:nextTurn()
    end
    
    if self.currentPhase == self.PHASES.COMBATE then
        CombatSystem:startCombat(self.gameState:getCurrentPlayer(), self.gameState:getOpponentPlayer())
    end
end

function TurnManager:nextTurn()
    self.currentPhase = self.PHASES.DESCARTE_COMPRA
    self.gameState.currentPlayerIndex = self.gameState.currentPlayerIndex + 1
    if self.gameState.currentPlayerIndex > #self.gameState.players then
        self.gameState.currentPlayerIndex = 1
    end
end

function TurnManager:update(dt)
    if self.currentPhase == self.PHASES.COMBATE then
        CombatSystem:update(dt)
    end
end

function TurnManager:draw()
    love.graphics.print("Fase Atual: " .. tostring(self.currentPhase), 10, 10)
    if self.currentPhase == self.PHASES.COMBATE then
        CombatSystem:draw()
    end
end

return TurnManager