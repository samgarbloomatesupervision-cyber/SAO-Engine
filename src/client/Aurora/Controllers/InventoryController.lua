local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Shared.Knit)
local ReplicaController = require(ReplicatedStorage.Shared.ReplicaController)

local InventoryController = Knit.CreateController { Name = "InventoryController" }

function InventoryController:KnitStart()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local menuGui = playerGui:WaitForChild("MenuGui")
    local invFrame = menuGui.Panel.ContentArea.PageProfil.Inventaire

    ReplicaController.ReplicaOfClassCreated("PlayerData_" .. game.PlaceId, function(replica)
        if replica.Tags.Player == player then
            local function refreshInventory()
                for _, child in ipairs(invFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
                for _, itemName in ipairs(replica.Data.Inventory) do
                    local slot = Instance.new("Frame", invFrame)
                    slot.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                    Instance.new("UICorner", slot)
                    local icon = Instance.new("TextLabel", slot)
                    icon.Size = UDim2.fromScale(1,1)
                    icon.BackgroundTransparency = 1
                    icon.Text = "🗡️" -- generic
                    icon.TextScaled = true
                end
                invFrame.CanvasSize = UDim2.new(0, 0, 0, layout and layout.AbsoluteContentSize.Y or 0)
            end
            replica:ListenToChange({"Inventory"}, refreshInventory)
            refreshInventory()
        end
    end)
end

return InventoryController
