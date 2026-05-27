local AssetOptimizer = {}

function AssetOptimizer.Apply(profileData)
    print("[PROMETHEUS] AssetOptimizer: Applying LOD Level -> " .. profileData.LODLevel)
    -- In extreme cases, removes distant props or changes materials to SmoothPlastic
    local Workspace = game:GetService("Workspace")
    local world = Workspace:FindFirstChild("World")
    
    if world and profileData.LODLevel == "Minimum" then
        for _, part in ipairs(world:GetDescendants()) do
            if part:IsA("BasePart") and not part:GetAttribute("OriginalMaterial") then
                part:SetAttribute("OriginalMaterial", part.Material.Name)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    elseif world and profileData.LODLevel == "High" then
        for _, part in ipairs(world:GetDescendants()) do
            if part:IsA("BasePart") and part:GetAttribute("OriginalMaterial") then
                pcall(function() part.Material = Enum.Material[part:GetAttribute("OriginalMaterial")] end)
            end
        end
    end
end

return AssetOptimizer