local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local GaiaService = Knit.CreateService {
    Name = "GaiaService",
    Client = {},
}

local Modules = script.Parent:WaitForChild("Modules")
local Biomes = require(Modules:WaitForChild("Biomes"))
local TileGenerator = require(Modules:WaitForChild("TileGenerator"))
local PropPlacer = require(Modules:WaitForChild("PropPlacer"))
local HeightmapGenerator = require(Modules:WaitForChild("HeightmapGenerator"))
local VillageGenerator = require(Modules:WaitForChild("VillageGenerator"))
local DungeonGenerator = require(Modules:WaitForChild("DungeonGenerator"))
local ContinentGenerator = require(Modules:WaitForChild("ContinentGenerator"))

function GaiaService:KnitStart()
    print("========================================")
    print("🌍 GAIA v10 : THE WORLD CREATOR ONLINE")
    print("========================================")
end

function GaiaService:GenerateWorld(center, radiusInTiles, biomeName)
    local biome = Biomes.Definitions[biomeName or "Forest"]
    if not biome then return end
    
    print("[GAIA] Constructing biome: " .. (biomeName or "Forest"))
    
    for x = -radiusInTiles, radiusInTiles do
        for z = -radiusInTiles, radiusInTiles do
            local worldX = center.X + (x * biome.TileSize)
            local worldZ = center.Z + (z * biome.TileSize)
            
            -- Apply Heightmap (Mountain biomes have higher amplitude)
            local scale = biomeName == "Mountain" and 150 or 250
            local amplitude = biomeName == "Mountain" and 80 or 20
            local height = HeightmapGenerator.GetHeight(worldX, worldZ, scale, amplitude)
            
            local pos = Vector3.new(worldX, height, worldZ)
            
            -- 1. Create Terrain Tile
            TileGenerator.CreateTile(pos, biome.TileSize, biome.Color)
            
            -- 2. Place Props via Atlas
            task.spawn(function()
                PropPlacer.PlaceProps(biome, pos, biome.TileSize)
            end)
            
            if (x * z) % 5 == 0 then task.wait() end
        end
    end
    print("[GAIA] Biome " .. (biomeName or "Forest") .. " generation complete!")
end

function GaiaService:GenerateVillage(center, houses)
    VillageGenerator.Generate(center, houses)
end

function GaiaService:GenerateDungeon(center, depth)
    DungeonGenerator.Generate(center, depth)
end

function GaiaService:GenerateContinent(center, size)
    ContinentGenerator.Generate(center, size)
end

return GaiaService