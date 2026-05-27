local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)
local DamagePopupService = require(script.Parent.Parent:WaitForChild("Services"):WaitForChild("DamagePopupService"))
local NotificationService = require(script.Parent.Parent:WaitForChild("Services"):WaitForChild("NotificationService"))

local VisualFeedbackController = Knit.CreateController { Name = "VisualFeedbackController" }

function VisualFeedbackController:KnitStart()
    local Events = ReplicatedStorage:WaitForChild("Events")
    
    Events.DamageDealt.OnClientEvent:Connect(function(target, amount, isCrit)
        DamagePopupService.spawnPopup(target, amount, isCrit)
    end)
    
    Events.LevelUp.OnClientEvent:Connect(function(newLevel)
        NotificationService.notify("⬆️", "LEVEL UP — Niveau " .. newLevel .. " !")
    end)
    
    Events.ItemObtained.OnClientEvent:Connect(function(icon, name)
        NotificationService.notify(icon, "Obtenu : " .. name)
    end)
    
    Events.ColEarned.OnClientEvent:Connect(function(icon, amount)
        NotificationService.notify(icon, "+" .. amount .. " Col")
    end)
end

return VisualFeedbackController
