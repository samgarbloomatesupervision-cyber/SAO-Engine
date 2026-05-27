local HeliosWorldGenerator = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlas = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Atlas"))
local ZoneService = require(game:GetService("ServerScriptService"):WaitForChild("Services"):WaitForChild("ZoneService"))

HeliosWorldGenerator.Biomes = {
    ["StartingTown"] = {
        Assets = {
            {Query = "low poly medieval house", Count = 10, Type = "Building"},
            {Query = "low poly fountain", Count = 1, Type = "Prop"},
            {Query = "low poly merchant stall", Count = 5, Type = "Prop"},
            {Query = "low poly stone path", Count = 20, Type = "Prop"}
        },
        Center = Vector3.new(0, 0, 0),
        Radius = 150
    },
    ["Floor1_Forest"] = {
        Assets = {
            {Query = "low poly pine tree", Count = 50, Type = "Nature"},
            {Query = "low poly oak tree", Count = 30, Type = "Nature"},
            {Query = "low poly rock boulder", Count = 40, Type = "Nature"},
            {Query = "low poly ruin pillar", Count = 10, Type = "Building"}
        },
        Center = Vector3.new(300, 0, 300),
        Radius = 250
    }
}

function HeliosWorldGenerator.GenerateWorld()
    print("Helios: Starting massive world generation...")
    
    for biomeName, config in pairs(HeliosWorldGenerator.Biomes) do
        print("Helios: Generating biome " .. biomeName)
        
        for _, assetReq in ipairs(config.Assets) do
            for i = 1, assetReq.Count do
                -- Use Atlas to find and process the asset
                -- Note: In a real run, this would import from Marketplace.
                -- For now, it leverages the Atlas pipeline we built.
                local angle = math.rad(math.random(0, 360))
                local dist = math.random(0, config.Radius)
                local pos = config.Center + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
                
                -- Use Atlas to find and place the asset
                Atlas.ProcessQuery(assetReq.Query, nil, pos)
                
                -- The Bridges (HeliosBridge) will handle the actual placement 
                -- and categorization in the workspace.
            end
        end
    end
    
    print("Helios: World generation complete.")
end

return HeliosWorldGenerator
