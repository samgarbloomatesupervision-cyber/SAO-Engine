local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)
local SoundRegistry = require(ReplicatedStorage:WaitForChild("SoundRegistry"))

local SoundController = Knit.CreateController { Name = "SoundController" }
local sounds = {}

function SoundController:Play(name)
    if sounds[name] then
        local function SafePlay(sound)
            if not sound or sound.SoundId == "" or sound.SoundId == "rbxassetid://0" or sound.SoundId == "0" then return end
            sound:Play()
        end
        SafePlay(sounds[name])
    end
end

function SoundController:KnitStart()
    local Events = ReplicatedStorage:WaitForChild("Events")
    
    -- Pre-charge sounds
    for name, data in pairs(SoundRegistry) do
        local s = Instance.new("Sound")
        s.Name = name
        s.SoundId = data.id
        s.Volume = data.vol
        s.PlaybackSpeed = data.pitch or 1
        s.Looped = data.loop or false
        s.Parent = game:GetService("SoundService")
        sounds[name] = s
    end
    
    Events.DamageDealt.OnClientEvent:Connect(function(target, amount, isCrit)
        self:Play(isCrit and "SWORD_HIT_CRIT" or "SWORD_HIT")
    end)
    
    Events.LevelUp.OnClientEvent:Connect(function()
        self:Play("LEVEL_UP")
    end)
    
    Events.ItemObtained.OnClientEvent:Connect(function()
        self:Play("ITEM_OBTAINED")
    end)

    -- Music sync with ZoneChanged (from Helios)
    local HeliosEngine = Knit.GetService("HeliosService")
    HeliosEngine.ZoneChanged:Connect(function(zoneName)
        for name, sound in pairs(sounds) do
            if name:sub(1, 4) == "BGM_" then sound:Stop() end
        end
        local key = "BGM_" .. zoneName:upper():gsub(" ", "_")
        if sounds[key] then sounds[key]:Play() end
    end)
end

return SoundController
