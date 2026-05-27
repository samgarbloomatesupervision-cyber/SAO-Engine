local PathfindingService = game:GetService("PathfindingService")

local AIUtils = {}

function AIUtils.FindNearestPlayer(position, maxDistance)
    local nearest = nil
    local minDist = maxDistance
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = char
            end
        end
    end
    
    return nearest
end

function AIUtils.MoveTo(mob, targetPosition)
    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:MoveTo(targetPosition)
    end
end

return AIUtils
