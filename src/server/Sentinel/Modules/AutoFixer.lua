local AutoFixer = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reporter = require(script.Parent:WaitForChild("Reporter"))

function AutoFixer.Init()
    print("[SENTINEL] AutoFixer: Initialized")
end

function AutoFixer.HandleError(scriptName, message)
    -- V10 intelligent fixing based on known patterns
    if message:find("Mobs_Workspace") then
        local mobsFolder = workspace:FindFirstChild("Mobs_Workspace")
        if not mobsFolder then
            mobsFolder = Instance.new("Folder", workspace)
            mobsFolder.Name = "Mobs_Workspace"
            Reporter.Alert("AutoFix", "Created missing Mobs_Workspace folder.", "SUCCESS")
        end
    end
end

function AutoFixer.Fix(instance, issueType)
    if issueType == "CorruptedAsset" then
        Reporter.Alert("AutoFix", "Attempting to purge and re-import corrupted asset: " .. instance.Name, "INFO")
        -- Integration with Atlas
        local success, Cardinal = pcall(function() return require(ReplicatedStorage:WaitForChild("Cardinal")) end)
        if success and Cardinal.Atlas then
            Cardinal.Atlas.RepairAsset(instance, issueType)
        else
            instance:Destroy() -- Safe fallback
        end
    elseif issueType == "InvalidCollision" and instance:IsA("MeshPart") then
        instance.CollisionFidelity = Enum.CollisionFidelity.Box
        Reporter.Alert("AutoFix", "Fixed collision fidelity for " .. instance.Name, "SUCCESS")
    end
end

return AutoFixer