local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Knit = require(game:GetService("ReplicatedStorage").Shared.Knit)

local AIService = Knit.CreateService { Name = "AIService", Client = {} }
local MobCooldowns = {}

local function getClosestPlayer(position, maxRadius)
    local closestPlayer = nil
    local shortestDistance = maxRadius

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local distance = (character.HumanoidRootPart.Position - position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = character
            end
        end
    end

    return closestPlayer, shortestDistance
end

function AIService:KnitStart()
    print("🧠 Titan : AI Service Online (Behavior-Driven).")
    local Libra = Knit.GetService("LibraService")
    local mobsFolder = Workspace:WaitForChild("Mobs_Workspace")

    task.spawn(function()
        while true do
            task.wait(0.5)

            for _, mob in ipairs(mobsFolder:GetChildren()) do
                local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
                local rootPart = mob:FindFirstChild("HumanoidRootPart")
                
                if not humanoid or humanoid.Health <= 0 then continue end

                -- Get Configs via Libra
                local mobRegistry = Libra:Get("Orion", "MobRegistry")
                local mobConfig = mobRegistry and mobRegistry[mob.Name]
                local behavior = Libra:GetEntry("Titan", "Behaviors", mobConfig and mobConfig.Behavior or "Passive")

                if rootPart and behavior and behavior.DetectionRadius > 0 then
                    local targetChar, distance = getClosestPlayer(rootPart.Position, behavior.DetectionRadius)

                    if targetChar then
                        if distance <= behavior.AttackRange then
                            local lastAttack = MobCooldowns[mob] or 0
                            if os.clock() - lastAttack >= behavior.AttackCooldown then
                                -- Mob Attack (Systemic)
                                targetChar.Humanoid:TakeDamage(mobConfig.BaseDamage or 10)
                                MobCooldowns[mob] = os.clock()
                                print("🩸 AI : " .. mob.Name .. " hit " .. targetChar.Name)
                            end
                        else
                            humanoid:MoveTo(targetChar.HumanoidRootPart.Position)
                        end
                    end
                end
            end
        end
    end)
end

return AIService
