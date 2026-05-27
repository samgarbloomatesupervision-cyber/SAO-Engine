local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Shared.Knit)
local ReplicaController = require(ReplicatedStorage.Shared.ReplicaController)

local MenuController = Knit.CreateController { Name = "MenuController" }

local isOpen = false

function MenuController:KnitStart()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local menuGui = playerGui:WaitForChild("MenuGui")
    local panel = menuGui:WaitForChild("Panel")
    local tabBar = panel:WaitForChild("TabBar")
    local contentArea = panel:WaitForChild("ContentArea")

    -- Navigation des onglets
    local function switchTab(tabName)
        for _, page in ipairs(contentArea:GetChildren()) do
            if page:IsA("Frame") then
                page.Visible = (page.Name == "Page" .. tabName)
            end
        end
        for _, btn in ipairs(tabBar:GetChildren()) do
            if btn:IsA("TextButton") then
                if btn.Name == tabName then
                    btn.BackgroundColor3 = Color3.fromRGB(30, 100, 180)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
                end
            end
        end
    end

    for _, btn in ipairs(tabBar:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.MouseButton1Click:Connect(function()
                switchTab(btn.Name)
            end)
        end
    end

    -- Toggle M
        UserInputService.InputBegan:Connect(function(input, gpe)
        print("Input: " .. tostring(input.KeyCode) .. " GPE: " .. tostring(gpe))
        if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.Escape then
            if gpe then print("Menu blocked by GameProcessedEvent") return end
            if input.KeyCode == Enum.KeyCode.Escape and not isOpen then return end
            
            isOpen = not isOpen
            menuGui.Enabled = isOpen

            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")

            if isOpen then
                panel.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, 650, 0, 500)
                }):Play()
                if humanoid then humanoid.WalkSpeed = 0 end
            else
                TweenService:Create(panel, TweenInfo.new(0.15), {
                    Size = UDim2.new(0, 0, 0, 0)
                }):Play()
                if humanoid then humanoid.WalkSpeed = 16 end
            end
        end
    end)
    

    -- Rafraîchir les données (Cardinal via ReplicaService)
    ReplicaController.ReplicaOfClassCreated("PlayerData_" .. game.PlaceId, function(replica)
        if replica.Tags.Player == player then
            local function refreshProfil()
                local data = replica.Data
                local page = contentArea.PageProfil
                
                page.NomJoueur.Text = player.Name
                page.Niveau.Text = "Niveau " .. data.Level
                panel.Col.Text = "💰 " .. data.Col .. " Col"
                
                local xpMax = data.Level * 100
                page.XPBar.Bar:TweenSize(UDim2.new(data.XP / xpMax, 0, 1, 0), "Out", "Quad", 0.3, true)

                -- Inventaire
                local invFrame = page.Inventaire
                for _, child in ipairs(invFrame:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end

                for _, itemName in ipairs(data.Inventory) do
                    local slot = Instance.new("Frame", invFrame)
                    slot.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                    Instance.new("UICorner", slot)
                    
                    local label = Instance.new("TextLabel", slot)
                    label.Size = UDim2.fromScale(1, 1)
                    label.BackgroundTransparency = 1
                    label.Text = itemName == "Elucidator" and "⚔️" or "🗡️"
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.TextScaled = true
                end
                
                -- Ajustement de la taille du scroll
                local layout = invFrame:FindFirstChildWhichIsA("UIGridLayout")
                if layout then
                    invFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
                end
            end

            replica:ListenToRaw(refreshProfil)
            refreshProfil()
        end
    end)

    switchTab("Profil")
end

return MenuController
