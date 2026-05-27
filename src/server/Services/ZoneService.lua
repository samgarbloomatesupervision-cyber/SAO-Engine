local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local ZoneService = Knit.CreateService {
    Name = "ZoneService",
    Client = {},
}

ZoneService.Zones = {
    ["StartingTown"] = {
        Name = "Starting Town",
        SafeZone = true,
        MobSpawns = {}
    },
    ["Floor1_Forest"] = {
        Name = "First Floor Forest",
        SafeZone = false,
        MobSpawns = {
            {Type = "Wolf", SpawnPoint = Vector3.new(100, 0, 100), Radius = 50, MaxCount = 5}
        }
    }
}

function ZoneService:KnitStart()
    print("ZoneService: Initialized")
    -- Logic for zone-based spawning could go here
end

return ZoneService
