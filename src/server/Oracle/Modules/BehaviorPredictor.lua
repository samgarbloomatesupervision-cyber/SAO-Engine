local BehaviorPredictor = {}

function BehaviorPredictor.PredictNextAction(playerData)
    -- Analysis of player history to predict next move (Looting, Combat, Traveling)
    -- Basic simulation for now
    local rand = math.random()
    if rand < 0.5 then
        return "Combat"
    elseif rand < 0.8 then
        return "Looting"
    else
        return "Social"
    end
end

return BehaviorPredictor
