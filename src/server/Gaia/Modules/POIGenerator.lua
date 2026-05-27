local POIGenerator = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function POIGenerator.Generate(poiType, centerPosition)
    print("[GAIA] Generating POI: " .. poiType .. " at " .. tostring(centerPosition))
    
    local success, Cardinal = pcall(function() return require(ReplicatedStorage:WaitForChild("Cardinal")) end)
    if not success or not Cardinal.Atlas then return end
    
    if poiType == "Ruins" then
        Cardinal.Atlas.ProcessQuery("ancient pillar", nil, centerPosition + Vector3.new(10, 0, 10))
        Cardinal.Atlas.ProcessQuery("ancient pillar", nil, centerPosition + Vector3.new(-10, 0, 10))
        Cardinal.Atlas.ProcessQuery("broken wall", nil, centerPosition + Vector3.new(0, 0, -10))
    elseif poiType == "Camp" then
        Cardinal.Atlas.ProcessQuery("campfire", nil, centerPosition)
        Cardinal.Atlas.ProcessQuery("tent", nil, centerPosition + Vector3.new(15, 0, 0))
        Cardinal.Atlas.ProcessQuery("crate", nil, centerPosition + Vector3.new(-10, 0, 5))
    elseif poiType == "DungeonEntrance" then
        Cardinal.Atlas.ProcessQuery("dungeon gate", nil, centerPosition)
        Cardinal.Atlas.ProcessQuery("gargoyle statue", nil, centerPosition + Vector3.new(20, 0, 10))
        Cardinal.Atlas.ProcessQuery("gargoyle statue", nil, centerPosition + Vector3.new(-20, 0, 10))
    end
end

return POIGenerator