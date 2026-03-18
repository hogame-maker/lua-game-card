local RuleEngine = {}

function RuleEngine:canPlayActionCard(characterCard, actionCard)
    -- Verifica se a carta de ação possui requisito mínimo de atributo
    if actionCard.requirement then
        local reqAttr = actionCard.requirement.attribute -- ex: "arcana"
        local reqValue = actionCard.requirement.value    -- ex: 3
        
        if characterCard.attributes[reqAttr] < reqValue then
            return false
        end
    end
    return true
end

function RuleEngine:canHeal(characterCard)
    return characterCard.isWounded and not characterCard.isDead
end

return RuleEngine