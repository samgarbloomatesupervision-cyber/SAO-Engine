local CrashGuard = {}
local Reporter = require(script.Parent:WaitForChild("Reporter"))
local RunService = game:GetService("RunService")
local lastHeartbeat = tick()

function CrashGuard.Init()
    print("[SENTINEL] CrashGuard: Initialized")
    
    RunService.Heartbeat:Connect(function()
        lastHeartbeat = tick()
    end)
    
    task.spawn(function()
        while true do
            task.wait(2)
            local diff = tick() - lastHeartbeat
            if diff > 3 then
                Reporter.Alert("ServerHang", string.format("Server froze for %.2f seconds!", diff), "CRITICAL")
                -- In v10, could attempt to isolate the hanging thread if possible
            end
        end
    end)
end

return CrashGuard