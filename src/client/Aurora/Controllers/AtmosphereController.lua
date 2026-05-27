local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)

local AtmosphereController = Knit.CreateController { Name = "AtmosphereController" }

function AtmosphereController:ApplyAmbiance(profile)
    if not profile then return end
    print("🌤️ Aurora : Transition d'ambiance en cours...")
    
    -- Atmosphere
    if profile.Atmosphere and Lighting:FindFirstChildWhichIsA("Atmosphere") then
        local atm = Lighting:FindFirstChildWhichIsA("Atmosphere")
        TweenService:Create(atm, TweenInfo.new(3), {
            Density = profile.Atmosphere.Density or 0,
            Color = profile.Atmosphere.Color or Color3.new(1,1,1)
        }):Play()
    end
    
    -- Lighting
    if profile.Lighting then
        TweenService:Create(Lighting, TweenInfo.new(3), {
            ClockTime = profile.Lighting.ClockTime or 14,
            ExposureCompensation = profile.Lighting.Exposure or 0
        }):Play()
    end
end

function AtmosphereController:KnitStart()
    local ZoneService = Knit.GetService("HeliosService")
    
    -- Listen to Helios for detailed profile data
    ZoneService.ZoneChanged:Connect(function(zoneName, profile)
        self:ApplyAmbiance(profile)
    end)
end

return AtmosphereController
