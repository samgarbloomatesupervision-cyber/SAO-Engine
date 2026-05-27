local VillageGenerator = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TileGenerator = require(script.Parent:WaitForChild("TileGenerator"))
local Biomes = require(script.Parent:WaitForChild("Biomes"))

function VillageGenerator.Generate(center, houseCount)
    print("[GAIA] Generating Procedural Village with " .. houseCount .. " houses at " .. tostring(center))
    
    local biome = Biomes.Definitions["Town"]
    local success, Cardinal = pcall(function() return require(ReplicatedStorage:WaitForChild("Cardinal")) end)
    local Atlas = success and Cardinal.Atlas
    
    -- Town Square
    TileGenerator.CreateTile(center, biome.TileSize * 1.5, biome.Color)
    if Atlas then
        Atlas.ProcessQuery("low poly fountain", nil, center)
        Atlas.ProcessQuery("marketplace stall", nil, center + Vector3.new(30, 0, 20))
        Atlas.ProcessQuery("marketplace stall", nil, center + Vector3.new(-30, 0, -20))
    end
    
    -- Houses around the square
    local radius = 80
    for i = 1, houseCount do
        local angle = math.rad((360 / houseCount) * i)
        local pos = center + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        
        TileGenerator.CreateTile(pos, biome.TileSize/2, biome.Color)
        
        if Atlas then
            Atlas.ProcessQuery("medieval house", nil, pos)
        end
    end
end

return VillageGenerator