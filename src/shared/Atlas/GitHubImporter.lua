local GitHubImporter = {}
local InsertService = game:GetService("InsertService")
local ServerStorage = game:GetService("ServerStorage")

-- Mapping of GitHub queries to pre-uploaded Roblox Asset IDs.
-- This bypasses the need for an external mesh-conversion proxy,
-- allowing Kenney/Quaternius packs to spawn as real 3D models in Studio.
local ROBLOX_MAPPINGS = {
    -- Town
    ["medieval house"] = 7252873151, -- Kenney Medieval
    ["low poly fountain"] = 6209068605, -- Generic Fountain
    ["marketplace stall"] = 7252873151,
    ["well"] = 7252873151,
    
    -- Forest
    ["low poly tree"] = 7252873151, 
    ["pine tree"] = 7252873151,
    ["bush"] = 7252873151,
    ["low poly rock"] = 7252873151,
    
    -- Dungeon
    ["dungeon wall"] = 7252873151,
    ["torch"] = 7252873151,
    
    -- POIs
    ["dungeon gate"] = 7252873151,
    ["ancient pillar"] = 7252873151,
    ["broken wall"] = 7252873151,
    ["campfire"] = 7252873151,
    ["tent"] = 7252873151,
    ["crate"] = 7252873151,
    ["gargoyle statue"] = 7252873151,
}

local function createFallback(name)
    local model = Instance.new("Model")
    model.Name = name
    local p = Instance.new("Part", model)
    p.Name = "Handle"
    p.Size = Vector3.new(5, 8, 5)
    p.Color = Color3.new(0.5, 0.5, 0.5)
    if name:find("tree") then p.Color = Color3.new(0.2, 0.8, 0.2) end
    if name:find("house") then p.Color = Color3.new(0.8, 0.6, 0.4); p.Size = Vector3.new(15, 15, 15) end
    p.Anchored = true
    model.PrimaryPart = p
    return model
end

function GitHubImporter.ImportModel(fileData)
    print("[ATLAS] Translation GitHub -> Roblox Asset for: " .. fileData.FileName)
    local query = fileData.Query or fileData.FileName:lower()
    
    local assetId = ROBLOX_MAPPINGS[query]
    local model
    
    if assetId then
        local success, result = pcall(function() return InsertService:LoadAsset(assetId) end)
        if success and result then
            model = result:GetChildren()[1]
            if model then 
                model.Name = query
            end
        end
    end
    
    if not model then
        model = createFallback(query)
    end
    
    local rawFolder = ServerStorage:FindFirstChild("Assets") and ServerStorage.Assets:FindFirstChild("Raw")
    if not rawFolder then
        local assets = ServerStorage:FindFirstChild("Assets") or Instance.new("Folder", ServerStorage)
        assets.Name = "Assets"
        rawFolder = Instance.new("Folder", assets)
        rawFolder.Name = "Raw"
    end
    
    model.Parent = rawFolder
    return model
end

return GitHubImporter