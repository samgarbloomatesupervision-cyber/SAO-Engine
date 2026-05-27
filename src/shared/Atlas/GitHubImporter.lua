local GitHubImporter = {}
local ServerStorage = game:GetService("ServerStorage")

function GitHubImporter.ImportModel(fileData)
    print("[ATLAS GITHUB] Converting and importing model: " .. fileData.FileName)
    
    -- In a production Roblox environment, converting .obj/.fbx to instances at runtime
    -- requires a backend service (e.g., Node.js + OpenCloud API) to upload the mesh to Roblox 
    -- and return the new AssetId. We simulate the final instantiated model here.
    
    local model = Instance.new("Model")
    local name = fileData.FileName:gsub("%.%w+$", "") -- Remove extension
    model.Name = name
    
    local primaryPart = Instance.new("Part")
    primaryPart.Name = "Handle"
    primaryPart.Size = Vector3.new(4, 4, 4)
    primaryPart.Anchored = true
    primaryPart.Color = Color3.fromRGB(math.random(50,200), math.random(50,200), math.random(50,200))
    primaryPart.Parent = model
    model.PrimaryPart = primaryPart
    
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