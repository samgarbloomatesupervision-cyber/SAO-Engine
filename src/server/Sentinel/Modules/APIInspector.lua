local APIInspector = {}
local Reporter = require(script.Parent:WaitForChild("Reporter"))

function APIInspector.Init()
    print("[SENTINEL] APIInspector: Initialized")
end

function APIInspector.Inspect(instance)
    if instance:IsA("MeshPart") then
        if instance.CollisionFidelity == Enum.CollisionFidelity.Default then
            Reporter.Alert("API", "MeshPart " .. instance.Name .. " uses Default CollisionFidelity. Consider Box or Precise.", "INFO")
        end
    elseif instance:IsA("Script") then
        if instance.RunContext == Enum.RunContext.Legacy then
             -- Example check
             Reporter.Alert("API", "Legacy script detected: " .. instance.Name, "INFO")
        end
    end
end

return APIInspector