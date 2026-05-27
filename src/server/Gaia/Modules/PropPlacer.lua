local PropPlacer = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlas = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Atlas"))

function PropPlacer.PlaceProps(biome, tilePosition, tileSize)
    local density = biome.PropDensity
    local propCount = math.floor(density * 5) -- Place up to 5 props per tile based on density
    
    for i = 1, propCount do
        if math.random() < density then
            local offsetX = math.random(-tileSize/2, tileSize/2)
            local offsetZ = math.random(-tileSize/2, tileSize/2)
            local pos = tilePosition + Vector3.new(offsetX, 1, offsetZ) -- Slightly above tile
            
            local propQuery = biome.Props[math.random(1, #biome.Props)]
            print("[GAIA] Placing prop: " .. propQuery .. " at " .. tostring(pos))
            
            -- Use Atlas to find and place the prop
            Atlas.ProcessQuery("low poly " .. propQuery, nil, pos)
        end
    end
end

return PropPlacer
