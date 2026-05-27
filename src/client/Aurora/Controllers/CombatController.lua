local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Shared.Knit)

local StateMachine = require(ReplicatedStorage.Titan:WaitForChild("StateMachine"))
local ComboSystem = require(ReplicatedStorage.Orion:WaitForChild("ComboSystem"))

local CombatController = Knit.CreateController { Name = "CombatController" }

function CombatController:KnitStart()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    self.SM = StateMachine.new()
    self.Combo = ComboSystem.new()
    
    local SkillEngine = Knit.GetService("SkillEngine")
    
    -- 🖱️ COMBAT INPUT
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        
        local state = self.SM:Get()
        
        -- 1. ATTACK
        if input.UserInputType == Enum.UserInputType.MouseButton1 and state.CanAttack then
            self:ExecuteAttack(SkillEngine, humanoid)
        end
        
        -- 2. DASH (Q or double tap direction)
        if input.KeyCode == Enum.KeyCode.Q and state.CanDash then
            self:ExecuteDash(humanoid)
        end
    end)
end

function CombatController:ExecuteAttack(SkillEngine, humanoid)
    local comboIndex = self.Combo:Next()
    local animId = self.Combo:GetAnimation("Sword")
    
    self.SM:SetState("Attacking", 0.5) -- Locked for 0.5s
    
    -- Visual / Animation
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = humanoid:LoadAnimation(anim)
    track:Play()
    
    -- Request Server for Damage / Hitbox
    SkillEngine:RequestSkill("BasicAttack_" .. comboIndex)
    
    -- Screen FX (Prometheus compliant)
    task.spawn(function()
        humanoid.AutoRotate = false
        task.wait(0.4)
        humanoid.AutoRotate = true
    end)
end

function CombatController:ExecuteDash(humanoid)
    local root = humanoid.RootPart
    if not root then return end
    
    self.SM:SetState("Dodging", 0.4) -- 0.4s of I-Frames
    
    local dashVelocity = Instance.new("LinearVelocity")
    local attachment = Instance.new("Attachment", root)
    dashVelocity.MaxForce = 100000
    dashVelocity.VectorVelocity = root.CFrame.LookVector * 60
    dashVelocity.Attachment0 = attachment
    dashVelocity.Parent = root
    
    game:GetService("Debris"):AddItem(dashVelocity, 0.2)
    game:GetService("Debris"):AddItem(attachment, 0.2)
    
    -- Visual Dash FX
    print("[TITAN] Dash I-Frames Active!")
end

return CombatController