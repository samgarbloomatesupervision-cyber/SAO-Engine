local AssetValidator = {}
local Reporter = require(script.Parent:WaitForChild("Reporter"))
local AutoFixer = require(script.Parent:WaitForChild("AutoFixer"))

function AssetValidator.Init()
    print("[SENTINEL] AssetValidator: Initialized")
end

function AssetValidator.Validate(instance)
    local results = { Valid = true, Issues = {} }
    
    if instance:IsA("MeshPart") and instance.MeshId == "" then
        table.insert(results.Issues, "Missing MeshId")
        results.Valid = false
    elseif instance:IsA("Decal") and instance.Texture == "" then
        table.insert(results.Issues, "Missing Texture")
        results.Valid = false
    end
    
    if not results.Valid then
        local issueStr = table.concat(results.Issues, ", ")
        Reporter.Alert("InvalidAsset", string.format("Asset %s is invalid: %s", instance:GetFullName(), issueStr), "ERROR")
        AutoFixer.Fix(instance, "CorruptedAsset")
    end
    
    return results
end

return AssetValidator