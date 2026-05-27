local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)

local WorldController = Knit.CreateController { Name = "WorldController" }

function WorldController:KnitStart()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local hud = playerGui:WaitForChild("HUD")
    local zoneLabel = hud:WaitForChild("ZoneName")

    -- On écoute Helios (ZoneService) via Knit au lieu des API internes de ZonePlus
    local ZoneService = Knit.GetService("HeliosService")
    
    if ZoneService and ZoneService.ZoneChanged then
        ZoneService.ZoneChanged:Connect(function(zoneName, profileData)
            zoneLabel.Text = zoneName
            print("🖥️ Aurora : UI Zone updated -> " .. zoneName)
            
            -- Effet de pop visuel
            local TweenService = game:GetService("TweenService")
            local origSize = UDim2.new(0, 200, 0, 40)
            local targetSize = UDim2.new(0, 240, 0, 48)
            
            TweenService:Create(zoneLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            task.delay(0.2, function()
                TweenService:Create(zoneLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = origSize}):Play()
            end)
        end)
    else
        warn("⚠️ Aurora: Impossible de se connecter à ZoneService.ZoneChanged")
    end
end

return WorldController
