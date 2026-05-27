local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local CombatController = Knit.CreateController {
    Name = "CombatController",
}

function CombatController:KnitStart()
    local CombatService = Knit.GetService("CombatService")
    local VFXManager = require(ReplicatedStorage:WaitForChild("client"):WaitForChild("Modules"):WaitForChild("VFXManager"))
    local CameraService = require(ReplicatedStorage:WaitForChild("client"):WaitForChild("Modules"):WaitForChild("CameraService"))

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            CombatService:Attack({Timestamp = tick()})
        elseif input.KeyCode == Enum.KeyCode.Q then
            CombatService:Dash({Direction = "Forward"})
        end
    end)
    
    CombatService.OnCombatAction:Connect(function(action, data)
        if action == "PlayAnimation" then
            self:PlayAttackAnimation(data.Player, data.AnimationId, data.ComboStep)
            
            VFXManager.PlaySlashEffect(data.Player.Character, data.ComboStep)
            
            if data.Player == game.Players.LocalPlayer then
                CameraService.Shake(0.5, 0.2)
            end
        end
    end)
    
    print("CombatController: Initialized")
end

function CombatController:PlayAttackAnimation(player, animId, step)
    -- Logic to load and play the animation on the character
end

return CombatController
