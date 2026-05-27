local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local MobService = Knit.CreateService {
    Name = "MobService",
    Client = {},
}

local AIUtils = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Titan"):WaitForChild("AIUtils"))

MobService.ActiveMobs = {}
MobService.AIDensity = 1.0 -- 1.0 = 100%, 0.5 = 50% performance/count

function MobService:UpdateAIDensity(density)
    self.AIDensity = math.clamp(density, 0.1, 1.0)
    print("[TITAN] AI Density adjusted to: " .. (self.AIDensity * 100) .. "%")
end

function MobService:KnitStart()
    print("MobService: Initialized")
    
    RunService.Heartbeat:Connect(function(dt)
        for mob, data in pairs(self.ActiveMobs) do
            self:UpdateAI(mob, data, dt)
        end
    end)
end

function MobService:SpawnMob(mobTemplate, position)
    local mob = mobTemplate:Clone()
    mob:SetPrimaryPartCFrame(CFrame.new(position))
    
    local mobsFolder = workspace:FindFirstChild("Mobs_Workspace") or Instance.new("Folder", workspace)
    mobsFolder.Name = "Mobs_Workspace"
    mob.Parent = mobsFolder
    
    self.ActiveMobs[mob] = {
        Target = nil,
        State = "Wander",
        WanderPoint = position,
        LastActionTime = 0
    }
    
    return mob
end

function MobService:UpdateAI(mob, data, dt)
    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        -- Trigger loot before cleanup
        local LootService = Knit.GetService("LootService")
        LootService:DropLoot(mob.Name, mob.PrimaryPart.Position)
        
        self.ActiveMobs[mob] = nil
        mob:Destroy()
        return
    end
    
    local root = mob.PrimaryPart
    if not root then return end
    
    local nearestPlayer = AIUtils.FindNearestPlayer(root.Position, 50)
    
    if nearestPlayer then
        data.Target = nearestPlayer
        data.State = "Aggro"
    else
        data.Target = nil
        data.State = "Wander"
    end
    
    if data.State == "Aggro" and data.Target then
        AIUtils.MoveTo(mob, data.Target.HumanoidRootPart.Position)
        
        local dist = (data.Target.HumanoidRootPart.Position - root.Position).Magnitude
        if dist < 5 and tick() - data.LastActionTime > 2 then
            data.Target.Humanoid:TakeDamage(10)
            data.LastActionTime = tick()
        end
    elseif data.State == "Wander" then
        if (root.Position - data.WanderPoint).Magnitude > 10 then
            AIUtils.MoveTo(mob, data.WanderPoint)
        end
    end
end

return MobService
