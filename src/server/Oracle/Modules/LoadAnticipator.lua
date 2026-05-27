local LoadAnticipator = {}

function LoadAnticipator.AnticipateSpike(playerCount, activeMobs)
    -- Predict if a server lag spike is coming based on current entities
    local complexity = playerCount * 10 + activeMobs * 2
    if complexity > 200 then
        return true, "High Load Predicted"
    end
    return false, "Stable"
end

return LoadAnticipator
