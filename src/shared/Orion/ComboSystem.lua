local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeaponBase = require(ReplicatedStorage:WaitForChild("Orion"):WaitForChild("WeaponBase"))

local ComboSystem = {}
ComboSystem.PlayerData = {}

local COMBO_TIMEOUT = 1.5 -- Seconds to reset combo

function ComboSystem.GetPlayerData(player)
    if not ComboSystem.PlayerData[player] then
        ComboSystem.PlayerData[player] = {
            CurrentCombo = 0,
            LastAttackTime = 0,
            IsAttacking = false
        }
    end
    return ComboSystem.PlayerData[player]
end

function ComboSystem.ExecuteAttack(player, weaponMeta)
    local data = ComboSystem.GetPlayerData(player)
    local now = tick()
    
    if now - data.LastAttackTime > COMBO_TIMEOUT then
        data.CurrentCombo = 0
    end
    
    if data.IsAttacking then return nil end
    
    data.IsAttacking = true
    data.CurrentCombo = (data.CurrentCombo % 3) + 1
    data.LastAttackTime = now
    
    print(string.format("ComboSystem: %s performing Hit %d with %s", player.Name, data.CurrentCombo, weaponMeta.Name))
    
    -- In a real implementation, we would return animation ID based on weapon type and combo step
    local animationId = "rbxassetid://0" -- Placeholder
    
    task.delay(0.5, function() -- Attack duration placeholder
        data.IsAttacking = false
    end)
    
    return data.CurrentCombo, animationId
end

return ComboSystem
