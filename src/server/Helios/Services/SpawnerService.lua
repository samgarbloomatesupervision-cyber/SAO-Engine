local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Shared.Knit)

local SpawnerService = Knit.CreateService { 
    Name = "SpawnerService",
    Client = {}
}

local ActiveSpawns = {} -- [zoneName] = count

function SpawnerService:SpawnInZone(zoneName, profileData)
    local Libra = Knit.GetService("LibraService")
    local mobRegistry = Libra:Get("Orion", "MobRegistry")
    
    if not profileData.Population or not profileData.Mobs then return end
    
    local mobChoice = profileData.Mobs[math.random(1, #profileData.Mobs)]
    local mobConfig = mobRegistry[mobChoice]
    local mobTemplate = ServerStorage:FindFirstChild("Assets", true):FindFirstChild("Mobs"):FindFirstChild(mobChoice)

    if not mobTemplate or not mobConfig then return end

    local newMob = mobTemplate:Clone()
    local humanoid = newMob:FindFirstChildWhichIsA("Humanoid")
    
    if humanoid then
        humanoid.MaxHealth = mobConfig.MaxHealth
        humanoid.Health = mobConfig.MaxHealth
        humanoid.WalkSpeed = mobConfig.WalkSpeed
        
        humanoid.Died:Connect(function()
            ActiveSpawns[zoneName] -= 1
            task.wait(2)
            newMob:Destroy()
        end)
    end

    -- Positioning
    local zonesFolder = Workspace:FindFirstChild("Zones")
    local zonePart = zonesFolder and zonesFolder:FindFirstChild(zoneName)
    if zonePart then
        local pos, size = zonePart.Position, zonePart.Size
        newMob:PivotTo(CFrame.new(
            pos.X + math.random(-size.X/2, size.X/2),
            pos.Y + 3,
            pos.Z + math.random(-size.Z/2, size.Z/2)
        ))
    end

    newMob.Parent = Workspace:FindFirstChild("Mobs_Workspace")
    ActiveSpawns[zoneName] += 1
end

function SpawnerService:KnitStart()
    print("🧬 Helios : Spawner Engine Online (Profile-Driven).")
    local Libra = Knit.GetService("LibraService")
    local worldGraph = Libra:Get("Helios", "WorldGraph")
    local profiles = Libra:Get("Helios", "Profiles")

    if not worldGraph or not profiles then return end

    for zoneName, config in pairs(worldGraph.Zones) do
        local profileData = profiles[config.Profile]
        if profileData and profileData.Population then
            ActiveSpawns[zoneName] = 0
            task.spawn(function()
                while true do
                    if ActiveSpawns[zoneName] < profileData.Population.Max then
                        self:SpawnInZone(zoneName, profileData)
                    end
                    task.wait(profileData.Population.RespawnRate)
                end
            end)
        end
    end
end

return SpawnerService
