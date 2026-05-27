local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)
local RaycastHitbox = require(ReplicatedStorage.Shared.RaycastHitbox) 

local SkillEngine = Knit.CreateService {
    Name = "SkillEngine",
    Client = { 
        SkillExecuted = Knit.CreateSignal(), -- For FX on clients
    },
}

local Cooldowns = {}

function SkillEngine:ExecuteSkill(player, skillId)
    local Libra = Knit.GetService("LibraService")
    local skillData = Libra:GetEntry("Titan", "SkillDefinitions", skillId)
    local character = player.Character
    
    if not skillData or not character then return end
    
    -- Cooldown
    local key = player.UserId .. "_" .. skillId
    if Cooldowns[key] and os.clock() < Cooldowns[key] then return end
    Cooldowns[key] = os.clock() + skillData.Cooldown

    -- Data & Weapon
    local data = Knit.GetService("DataService"):GetPlayerData(player)
    local weaponName = data and data.EquippedWeapon
    local weaponConfig = Libra:GetEntry("Orion", "Registry", weaponName)
    local weaponModel = character:FindFirstChild("EquippedWeapon")
    
    if not weaponModel or not weaponConfig then return end

    -- Systemic Damage Calculation
    local baseDamage = (weaponConfig.BaseDamage or 10) * (skillData.DamageMultiplier or 1.0)
    -- Future: Scale with strength/dexterity from data

    -- Raycast Hitbox Configuration
    local hitbox = RaycastHitbox.new(weaponModel)
    
    hitbox.OnHit:Connect(function(hit, humanoid)
        if humanoid.Parent ~= character then
            humanoid:TakeDamage(baseDamage)
            
            -- Telemetry
            local Nexus = Knit.GetService("NexusEngine")
            if Nexus then Nexus:RecordSkillUse(skillId, weaponConfig.Tags) end
            
            -- Tag for XP
            local tag = humanoid:FindFirstChild("creator") or Instance.new("ObjectValue", humanoid)
            tag.Name = "creator"; tag.Value = player
        end
    end)

    -- Execution
    hitbox:HitStart()
    task.wait(0.3) -- Default active time
    hitbox:HitStop()
    hitbox:Destroy()

    -- Visual Feedback
    self.Client.SkillExecuted:FireAll(player, skillId)
    return true
end

-- Function exposed to client for inputs
function SkillEngine.Client:RequestSkill(player, skillId)
    return self.Server:ExecuteSkill(player, skillId)
end

return SkillEngine
