local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local SentinelService = Knit.CreateService {
    Name = "SentinelService",
    Client = {
        OnSystemAlert = Knit.CreateSignal(),
    },
}

function SentinelService:NotifyPlayers(message, level)
    self.Client.OnSystemAlert:FireAll(message, level or "Warning")
end

function SentinelService:KnitStart()
    print("========================================")
    print("🛡️ SENTINEL V10: ULTIMATE GUARDIAN ONLINE 🛡️")
    print("========================================")
    
    local Modules = ServerScriptService:WaitForChild("Sentinel"):WaitForChild("Modules")
    
    -- Initialize all sub-systems
    require(Modules:WaitForChild("Reporter")).Init()
    require(Modules:WaitForChild("ErrorWatcher")).Init()
    require(Modules:WaitForChild("PerformanceMonitor")).Init()
    require(Modules:WaitForChild("APIInspector")).Init()
    require(Modules:WaitForChild("AssetValidator")).Init()
    require(Modules:WaitForChild("EventTracker")).Init()
    require(Modules:WaitForChild("CrashGuard")).Init()
    require(Modules:WaitForChild("AutoFixer")).Init()
    
    require(Modules:WaitForChild("Reporter")).Alert("System", "Sentinel V10 fully armed and operational.", "SUCCESS")
end

return SentinelService