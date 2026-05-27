local Knit = require(game.ReplicatedStorage.Shared.Knit)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local AdminController = Knit.CreateController { Name = "AdminController" }

function AdminController:KnitStart()
    local player = Players.LocalPlayer
    if player.Name ~= "PapiSimsim" then return end

    local gui = player:WaitForChild("PlayerGui"):WaitForChild("AdminPanel")
    local frame = gui.Main
    
    -- Touche "P" pour ouvrir le panneau divin
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.P then
            gui.Enabled = not gui.Enabled
        end
    end)

    frame.Apply.MouseButton1Click:Connect(function()
        local category = frame.Category.Text
        local key = frame.Key.Text
        local field = frame.Field.Text
        local val = frame.Value.Text
        
        local Libra = Knit.GetService("LibraService")
        local success = Libra:RequestUpdate(category, key, field, val)
        
        if success then
            frame.Apply.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(0.5)
            frame.Apply.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            frame.Apply.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(0.5)
            frame.Apply.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        end
    end)
end

return AdminController
