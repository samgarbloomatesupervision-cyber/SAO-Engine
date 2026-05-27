local ErrorWatcher = {}
local ScriptContext = game:GetService("ScriptContext")
local LogService = game:GetService("LogService")
local Reporter = require(script.Parent:WaitForChild("Reporter"))

function ErrorWatcher.Init()
    print("[SENTINEL] ErrorWatcher: Initialized")
    
    ScriptContext.Error:Connect(function(message, trace, script)
        local scriptName = script and script:GetFullName() or "Unknown Script"
        local alertMsg = string.format("ERROR in %s: %s\nTrace: %s", scriptName, message, trace)
        Reporter.Alert("ScriptError", alertMsg, "CRITICAL")
        
        -- Trigger AutoFixer if possible
        require(script.Parent:WaitForChild("AutoFixer")).HandleError(scriptName, message)
    end)
    
    LogService.MessageOut:Connect(function(message, messageType)
        if messageType == Enum.MessageType.MessageWarning then
            if message:find("Infinite yield") then
                Reporter.Alert("Yield", message, "WARNING")
            else
                Reporter.Alert("LogWarning", message, "INFO")
            end
        end
    end)
end

return ErrorWatcher