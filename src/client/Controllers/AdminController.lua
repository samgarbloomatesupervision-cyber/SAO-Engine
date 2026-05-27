local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local AdminController = Knit.CreateController {
    Name = "AdminController",
}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function AdminController:KnitStart()
    local AdminService = Knit.GetService("AdminService")
    
    -- Creation of the Panel UI
    local screen = Instance.new("ScreenGui")
    screen.Name = "SystemPanel"
    screen.Enabled = false
    screen.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
    mainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
    mainFrame.Parent = screen
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Text = "SYSTEM COMMAND PANEL - v1.0"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(0.9, 0, 0.85, 0)
    list.Position = UDim2.new(0.05, 0, 0.12, 0)
    list.BackgroundTransparency = 1
    list.CanvasSize = UDim2.new(0, 0, 2, 0)
    list.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = list
    
    local function CreateButton(text, cmd, args)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0.08, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.Parent = list
        
        btn.MouseButton1Click:Connect(function()
            AdminService:ExecuteCommand(cmd, args)
        end)
    end
    
    -- Commands
    CreateButton("GENERATE FOREST BIOME", "GenerateZone", {Biome = "Forest", Size = 5})
    CreateButton("GENERATE PLAINS BIOME", "GenerateZone", {Biome = "Plains", Size = 5})
    CreateButton("SPAWN PROCEDURAL VILLAGE", "GenerateVillage", {Houses = 12})
    CreateButton("FORCE SYSTEM REPAIR (SENTINEL)", "RepairSystem", {})
    
    -- Toggle Key (F10)
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.F10 then
            screen.Enabled = not screen.Enabled
        end
    end)
    
    print("AdminController: System Panel ready (F10 to toggle)")
end

return AdminController
