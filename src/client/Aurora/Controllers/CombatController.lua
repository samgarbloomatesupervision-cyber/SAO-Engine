local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Shared.Knit)

local CombatController = Knit.CreateController { Name = "CombatController" }

local function shakeCamera(intensity, duration)
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    task.spawn(function()
        local endTime = os.clock() + duration
        while os.clock() < endTime do
            humanoid.CameraOffset = Vector3.new(math.random(-intensity, intensity)/100, math.random(-intensity, intensity)/100, 0)
            task.wait()
        end
        humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end)
end

local function hitstop(duration)
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local animator = humanoid and humanoid:FindFirstChild("Animator")
    if not animator then return end
    
    local tracks = animator:GetPlayingAnimationTracks()
    for _, track in ipairs(tracks) do track:AdjustSpeed(0) end
    task.wait(duration)
    for _, track in ipairs(tracks) do track:AdjustSpeed(1) end
end

local function screenFlash()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local flash = Instance.new("Frame", playerGui:WaitForChild("MainHUD"))
    flash.Size = UDim2.fromScale(1,1)
    flash.BackgroundColor3 = Color3.new(1,1,1)
    flash.BackgroundTransparency = 0.7
    flash.ZIndex = 100
    TweenService:Create(flash, TweenInfo.new(0.08), {BackgroundTransparency = 1}):Play()
    game:GetService("Debris"):AddItem(flash, 0.1)
end

function CombatController:KnitStart()
    local SkillEngine = Knit.GetService("SkillEngine")
    local SoundController = Knit.GetController("SoundController")
    local Events = ReplicatedStorage:WaitForChild("Events")

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local success = SkillEngine:RequestSkillExecution("VerticalSlash")
            if success then
                SoundController:Play("SWORD_SWING")
                local char = Players.LocalPlayer.Character
                local animator = char and char.Humanoid:FindFirstChild("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://18408103328"
                    animator:LoadAnimation(anim):Play()
                end
                shakeCamera(15, 0.2)
            end
        end
    end)

    -- Listen to hits for hitstop and flash
    Events.DamageDealt.OnClientEvent:Connect(function(target, amount, isCrit)
        -- We only apply hitstop if the local player is the attacker (mocked check)
        hitstop(isCrit and 0.1 or 0.05)
        if isCrit then screenFlash() end
    end)
end

return CombatController
