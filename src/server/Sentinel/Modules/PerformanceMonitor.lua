local PerformanceMonitor = {}
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Reporter = require(script.Parent:WaitForChild("Reporter"))

local CHECK_INTERVAL = 2 
local lastCheck = tick()

function PerformanceMonitor.Init()
    print("[SENTINEL] PerformanceMonitor: Initialized")
    
    RunService.Heartbeat:Connect(function(dt)
        local now = tick()
        if now - lastCheck >= CHECK_INTERVAL then
            lastCheck = now
            PerformanceMonitor.CheckMetrics()
        end
    end)
end

function PerformanceMonitor.CheckMetrics()
    local memUsage = Stats:GetTotalMemoryUsageMb()
    local fps = workspace:GetRealPhysicsFPS()
    
    if fps < 30 then
        Reporter.Alert("LowFPS", string.format("FPS dropped to %.1f", fps), "CRITICAL")
    elseif fps < 45 then
        Reporter.Alert("LowFPS", string.format("FPS is struggling: %.1f", fps), "WARNING")
    end
    
    if memUsage > 2000 then
        Reporter.Alert("HighMemory", string.format("Memory critical: %.1f MB", memUsage), "CRITICAL")
    elseif memUsage > 1500 then
        Reporter.Alert("HighMemory", string.format("Memory rising: %.1f MB", memUsage), "WARNING")
    end
end

return PerformanceMonitor