local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local HUDController = Knit.CreateController {
    Name = "HUDController",
}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function HUDController:KnitStart()
    local DataService = Knit.GetService("DataService")
    local SentinelService = Knit.GetService("SentinelService")
    
    -- Main HUD Screen - Create immediately to resolve yields from other scripts
    local screen = playerGui:FindFirstChild("MainHUD")
    if not screen then
        screen = Instance.new("ScreenGui")
        screen.Name = "MainHUD"
        screen.ResetOnSpawn = false
        screen.Parent = playerGui
        print("HUDController: Created MainHUD")
    end
    
    -- ... rest of UI setup ...
end

function HUDController:UpdateHP(percent)
    TweenService:Create(self.HPBar, TweenInfo.new(0.3), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
end

function HUDController:Notify(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = self.NotifArea
    
    task.delay(2, function()
        TweenService:Create(label, TweenInfo.new(1), {TextTransparency = 1}):Play()
        task.wait(1)
        label:Destroy()
    end)
end

return HUDController
