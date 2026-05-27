local AdaptiveQuality = {}
local Rules = require(script.Parent:WaitForChild("Rules"))

function AdaptiveQuality.Evaluate(metrics)
    if metrics.FPS < Rules.Thresholds.FPS_Critical or metrics.Memory > Rules.Thresholds.Memory_Critical then
        return "Critical"
    elseif metrics.FPS < Rules.Thresholds.FPS_Warning or metrics.Memory > Rules.Thresholds.Memory_Warning then
        return "Low"
    elseif metrics.FPS >= 55 and metrics.Memory < 1000 then
        return "High"
    end
    return "Medium"
end

return AdaptiveQuality