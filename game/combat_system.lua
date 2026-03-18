local CombatSystem = {}

CombatSystem.ROUND_PHASES = {
    INICIATIVA = 1,
    ACOES = 2,
    PODER_GRUPO = 3,
    FERIMENTO = 4
}

function CombatSystem:startCombat(activePlayer, opponentPlayer)
    self.activePlayer = activePlayer
    self.opponentPlayer = opponentPlayer
    self.currentRoundPhase = self.ROUND_PHASES.INICIATIVA
    self.isCombatActive = true
end

function CombatSystem:update(dt)
    if not self.isCombatActive then return end
    -- Lógica de transição de rounds de combate
end

function CombatSystem:draw()
    if not self.isCombatActive then return end
    love.graphics.print("COMBATE EM ANDAMENTO - Fase: " .. tostring(self.currentRoundPhase), 10, 40)
end

function CombatSystem:resolveGroupPower()
    -- Rola o D6 e soma ao poder de grupo
    local activePower = self.activePlayer:getGroupPower() + love.math.random(1, 6)
    local opponentPower = self.opponentPlayer:getGroupPower() + love.math.random(1, 6)
    
    if activePower > opponentPower then
        return self.activePlayer
    elseif opponentPower > activePower then
        return self.opponentPlayer
    else
        return nil -- Empate
    end
end

return CombatSystem