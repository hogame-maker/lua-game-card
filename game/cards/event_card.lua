local Card = require "game.card"

local EventCard = setmetatable({}, {__index = Card})
EventCard.__index = EventCard

function EventCard:new(data)
    data.type = "EVENTO"
    
    local obj = Card.new(self, data)
    
    -- Eventos geralmente resolvem na hora e vão para o descarte
    obj.isResolved = false
    
    return obj
end

-- Sobrescreve o activateEffect para marcar como resolvido
function EventCard:activateEffect(target, gameState)
    Card.activateEffect(self, target, gameState)
    self.isResolved = true
end

return EventCard