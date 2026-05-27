local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local OracleService = Knit.CreateService {
    Name = "OracleService",
    Client = {},
}

local Modules = ServerScriptService:WaitForChild("Oracle"):WaitForChild("Modules")
local BehaviorPredictor = require(Modules:WaitForChild("BehaviorPredictor"))
local LoadAnticipator = require(Modules:WaitForChild("LoadAnticipator"))

function OracleService:KnitStart()
    print("========================================")
    print("🔮 ORACLE V1: THE PREDICTIVE SEER ACTIVE 🔮")
    print("========================================")
    
    task.spawn(function()
        while true do
            self:PerformPredictions()
            task.wait(10)
        end
    end)
end

function OracleService:PerformPredictions()
    -- Integration with Prometheus and Prometheus' metrics
    local Prometheus = Knit.GetService("PrometheusService")
    if Prometheus then
        -- Use load anticipator to warn Prometheus BEFORE lag happens
        local willSpike, msg = LoadAnticipator.AnticipateSpike(#game.Players:GetPlayers(), 50) -- Mock mob count
        if willSpike then
            print("[ORACLE] PREDICTION: " .. msg)
            -- Future: Notify Prometheus to start pre-emptive throttling
        end
    end
end

return OracleService
