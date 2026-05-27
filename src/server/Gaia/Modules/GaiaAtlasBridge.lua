local GaiaAtlasBridge = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- A dedicated bridge for Gaia to safely wrap Atlas calls
function GaiaAtlasBridge.PlaceAsset(query, position)
    local success, Cardinal = pcall(function() return require(ReplicatedStorage:WaitForChild("Cardinal")) end)
    if success and Cardinal.Atlas and Cardinal.Atlas.ProcessQuery then
        -- Execute synchronously to ensure the asset is registered before moving on
        local meta = Cardinal.Atlas.ProcessQuery(query, nil, position)
        if meta then
            -- Enforce parentage to Workspace.World
            local Workspace = game:GetService("Workspace")
            local worldFolder = Workspace:FindFirstChild("World")
            local model = Workspace:FindFirstChild(meta.Name, true)
            if model and worldFolder then
                model.Parent = worldFolder
            end
            return true
        end
    end
    return false
end

return GaiaAtlasBridge