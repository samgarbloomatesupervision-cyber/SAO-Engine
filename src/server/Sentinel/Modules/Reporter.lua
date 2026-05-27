local Reporter = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local logs = {}

function Reporter.Init()
    print("[SENTINEL] Reporter: Initialized")
end

function Reporter.Alert(category, message, level)
    local formatted = string.format("[SENTINEL] [%s] [%s] %s", level, category, message)
    
    if level == "CRITICAL" or level == "ERROR" then
        warn(formatted)
    else
        print(formatted)
    end
    
    table.insert(logs, {
        Time = os.date("%X"),
        Level = level,
        Category = category,
        Message = message
    })
    
    -- Send to Nexus for global telemetry if available
    local success, Knit = pcall(function() return require(ReplicatedStorage.Shared.Knit) end)
    if success then
        -- We wrap in pcall because Nexus might not be fully ready
        pcall(function()
            local Nexus = Knit.GetService("TelemetryService")
            if Nexus and Nexus.RecordSentinelAlert then
                Nexus:RecordSentinelAlert(category, level)
            end
        end)
    end
end

function Reporter.GetLogs()
    return logs
end

return Reporter