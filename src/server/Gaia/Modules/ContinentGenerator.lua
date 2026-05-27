local ContinentGenerator = {}
local Biomes = require(script.Parent:WaitForChild("Biomes"))
local POIGenerator = require(script.Parent:WaitForChild("POIGenerator"))

function ContinentGenerator.Generate(center, size)
    print(string.format("[GAIA] Generating Continent at %s (Size: %s)", tostring(center), size))
    -- A continent orchestrates multiple biomes, POIs, dungeons, and villages.
    -- This relies heavily on GaiaService invoking GenerateWorld for patches.
    -- (This acts as the macro-level planner)
    
    local poiTypes = {"Ruins", "Camp", "DungeonEntrance"}
    
    for i = 1, math.floor(size / 3) do
        local offsetX = math.random(-size*100, size*100)
        local offsetZ = math.random(-size*100, size*100)
        local pos = center + Vector3.new(offsetX, 0, offsetZ)
        
        local poiType = poiTypes[math.random(1, #poiTypes)]
        POIGenerator.Generate(poiType, pos)
    end
end

return ContinentGenerator