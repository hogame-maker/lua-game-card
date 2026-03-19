local Player = {}
Player.__index = Player

function Player:new(name)
    local obj = {
        name = name,
        heroes = {},       -- Grupo de Heróis na mesa (Max 3)
        monsters = {},     -- Monstros controlados caso atue como Oponente
        hand = {},         -- Cartas de ação
        maxHandSize = 6,
        treasures = {},
        actions = {},      -- Ações disponíveis no turno
        playTime = 0       -- Tempo total do jogador (minutos)
    }
    setmetatable(obj, Player)
    return obj
end

function Player:addHero(heroCard)
    if #self.heroes < 3 then
        table.insert(self.heroes, heroCard)
        return true
    end
    return false
end

function Player:addAction(action)
    table.insert(self.actions, action)
end

function Player:clearActions()
    self.actions = {}
end

function Player:getGroupPower()
    local totalPower = 0
    -- Soma o poder do grupo ativo, considerando penalidades (heróis feridos)
    for _, hero in ipairs(self.heroes) do
        if not hero.isDead then
            totalPower = totalPower + hero:getCurrentPower()
        end
    end
    -- Se estiver controlando monstros (como Oponente)
    for _, monster in ipairs(self.monsters) do
        if not monster.isDead then
            totalPower = totalPower + monster:getCurrentPower()
        end
    end
    return totalPower
end

return Player