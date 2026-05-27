local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local CombatService = Knit.CreateService {
    Name = "CombatService",
    Client = {
        OnCombatAction = Knit.CreateSignal(),
    },
}

local ComboSystem = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Orion"):WaitForChild("ComboSystem"))
local HitboxSystem = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Orion"):WaitForChild("HitboxSystem"))

function CombatService:KnitStart()
    print("CombatService: Initialized")
end

function CombatService.Client:Attack(player, data)
    self.Server:ProcessAttack(player, data)
end

function CombatService.Client:Dash(player, data)
    self.Server:ProcessDash(player, data)
end

function CombatService.Client:RequestSkillExecution(player, skillName, data)
    self.Server:ProcessSkill(player, skillName, data)
end

function CombatService:ProcessSkill(player, skillName, data)
    print(player.Name .. " requested skill: " .. skillName)
    -- Logic for skill validation, cooldowns, and execution
end

function CombatService:ProcessAttack(player, data)
    local character = player.Character
    if not character then return end
    
    -- Mock metadata for now
    local weaponMeta = {
        Name = "Elucidator",
        HitboxPoints = {"BladePoint1", "BladePoint2"},
        DefaultSkills = {"VerticalSlash"}
    }
    
    local comboStep, animId = ComboSystem.ExecuteAttack(player, weaponMeta)
    if not comboStep then return end
    
    -- Sync animation to all clients
    self.Client.OnCombatAction:FireAll("PlayAnimation", {
        Player = player,
        AnimationId = animId,
        ComboStep = comboStep
    })
    
    local weaponModel = character:FindFirstChild("Weapon")
    HitboxSystem.CastHitbox(character, weaponMeta, weaponModel)
end

function CombatService:ProcessDash(player, data)
    print(player.Name .. " performed a dash!")
end

return CombatService
