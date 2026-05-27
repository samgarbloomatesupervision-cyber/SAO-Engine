local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local PrometheusService = Knit.CreateService {
    Name = "PrometheusService",
    Client = {
        OnQualityChanged = Knit.CreateSignal(),
    },
}

local Modules = script.Parent:WaitForChild("Modules")
local Metrics = require(Modules:WaitForChild("Metrics"))
local Rules = require(Modules:WaitForChild("Rules"))
local AdaptiveQuality = require(Modules:WaitForChild("AdaptiveQuality"))
local FXOptimizer = require(Modules:WaitForChild("FXOptimizer"))
local AIOptimizer = require(Modules:WaitForChild("AIOptimizer"))
local NetworkOptimizer = require(Modules:WaitForChild("NetworkOptimizer"))
local UIOptimizer = require(Modules:WaitForChild("UIOptimizer"))
local AssetOptimizer = require(Modules:WaitForChild("AssetOptimizer"))
local PrometheusBridge = require(Modules:WaitForChild("PrometheusBridge"))

PrometheusService.CurrentProfile = "High"

function PrometheusService:KnitStart()
    print("========================================")
    print("💎 PROMETHEUS V10: ULTIMATE EVOLUTION 💎")
    print("========================================")
    
    -- Bridge connections
    task.spawn(function()
        task.wait(2) -- Wait for other services
        local Sentinel = Knit.GetService("SentinelService")
        local Telemetry = Knit.GetService("TelemetryService")
        PrometheusBridge.ConnectToSentinel(Sentinel)
        PrometheusBridge.ConnectToNexus(Telemetry)
    end)
    
    -- Core Loop
    task.spawn(function()
        while true do
            self:Optimize()
            task.wait(2) -- Run optimization check every 2 seconds
        end
    end)
end

function PrometheusService:Optimize()
    local currentMetrics = Metrics.GetReport()
    local targetProfile = AdaptiveQuality.Evaluate(currentMetrics)
    
    if targetProfile ~= self.CurrentProfile then
        self:ApplyProfile(targetProfile)
        self.CurrentProfile = targetProfile
    end
end

function PrometheusService:ApplyProfile(profileName)
    local profileData = Rules.Profiles[profileName]
    if not profileData then return end
    
    print("[PROMETHEUS] ⚠️ SHIFTING ENGINE PROFILE TO: " .. profileName:upper())
    
    -- Apply optimizations across the board
    FXOptimizer.Apply(profileData)
    AIOptimizer.Apply(profileData)
    NetworkOptimizer.Apply(profileData)
    UIOptimizer.Apply(profileData)
    AssetOptimizer.Apply(profileData)
    
    -- Notify Clients
    self.Client.OnQualityChanged:FireAll(profileName, profileData)
    
    -- Notify Sentinel
    local success, Sentinel = pcall(function() return Knit.GetService("SentinelService") end)
    if success and Sentinel then
        Sentinel:NotifyPlayers("Prometheus Auto-Tuning: Quality set to " .. profileName, "Info")
    end
end

return PrometheusService