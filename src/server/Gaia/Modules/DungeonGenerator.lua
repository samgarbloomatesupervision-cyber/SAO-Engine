local DungeonGenerator = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TileGenerator = require(script.Parent:WaitForChild("TileGenerator"))
local Biomes = require(script.Parent:WaitForChild("Biomes"))

function DungeonGenerator.Generate(center, depth)
    print("[GAIA] Generating Procedural Dungeon (Depth " .. depth .. ") at " .. tostring(center))
    
    local biome = Biomes.Definitions["Dungeon"]
    local tileSize = biome.TileSize
    local rooms = depth * 3
    
    local success, Cardinal = pcall(function() return require(ReplicatedStorage:WaitForChild("Cardinal")) end)
    local Atlas = success and Cardinal.Atlas
    
    for i = 1, rooms do
        -- Procedural layout: mostly straight with some branches
        local offsetX = math.random(-2, 2) * tileSize
        local offsetZ = i * tileSize
        local pos = center + Vector3.new(offsetX, 0, offsetZ)
        
        -- Create floor
        TileGenerator.CreateTile(pos, tileSize, biome.Color)
        
        if Atlas then
            -- Walls (Conceptual)
            Atlas.ProcessQuery("dungeon wall", nil, pos + Vector3.new(tileSize/2, 10, 0))
            Atlas.ProcessQuery("dungeon wall", nil, pos + Vector3.new(-tileSize/2, 10, 0))
            
            -- Props
            if math.random() > 0.5 then
                Atlas.ProcessQuery("torch", nil, pos + Vector3.new(tileSize/2 - 2, 5, 0))
            end
        end
        
        -- Boss Room at the end
        if i == rooms then
            print("[GAIA] Generating Boss Room at " .. tostring(pos))
            TileGenerator.CreateTile(pos + Vector3.new(0,0,tileSize), tileSize * 2, Color3.fromRGB(30,0,0))
            if Atlas then
                Atlas.ProcessQuery("throne", nil, pos + Vector3.new(0, 0, tileSize * 1.5))
            end
        end
    end
end

return DungeonGenerator