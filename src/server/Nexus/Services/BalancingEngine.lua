local Knit = require(game:GetService("ReplicatedStorage").Shared.Knit)

local BalancingEngine = Knit.CreateService { Name = "BalancingEngine", Client = {} }

function BalancingEngine:AdaptWorld()
    local Libra = Knit.GetService("LibraService")
    local Telemetry = Knit.GetService("TelemetryService")
    local stats = Telemetry:GetServerStats()
    local skills = Libra:Get("SkillDefinitions")
    
    local total = 0
    for _, c in pairs(stats.SkillUsage) do total += c end
    if total < 10 then return end

    Knit.GetService("TelemetryService").Client.ResonanceChanged:FireAll(total > 100 and "High" or "Low")

    for name, count in pairs(stats.SkillUsage) do
        local ratio = count / total
        local cfg = skills[name]
        if cfg then
            cfg.OriginalMultiplier = cfg.OriginalMultiplier or cfg.DamageMultiplier
            if ratio > 0.6 then
                cfg.DamageMultiplier = math.max(cfg.DamageMultiplier - 0.05, cfg.OriginalMultiplier * 0.5)
            elseif ratio < 0.15 then
                cfg.DamageMultiplier = math.min(cfg.DamageMultiplier + 0.05, cfg.OriginalMultiplier * 2.0)
            end
        end
    end
end

function BalancingEngine:KnitStart()
    task.spawn(function() while true do task.wait(60); self:AdaptWorld() end end)
end

return BalancingEngine
