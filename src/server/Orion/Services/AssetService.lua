local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)

local AssetService = Knit.CreateService { Name = "AssetService", Client = {} }

function AssetService:EquipWeapon(player, weaponName)
    local Libra = Knit.GetService("LibraService")
    local config = Libra:Get("WeaponRegistry", weaponName)
    local character = player.Character
    if not character or not config then return end

    local weaponTemplate = ServerStorage:FindFirstChild("Assets", true):FindFirstChild("Weapons"):FindFirstChild(weaponName)
    if not weaponTemplate then return end

    if character:FindFirstChild("EquippedWeapon") then character.EquippedWeapon:Destroy() end

    local clone = weaponTemplate:Clone()
    clone.Name = "EquippedWeapon"
    clone.Parent = character
    
    local handle = clone:FindFirstChild("Handle") or clone
    local weld = Instance.new("Motor6D")
    weld.Part0 = character.RightHand
    weld.Part1 = handle
    weld.Parent = handle
    return true
end

function AssetService:KnitStart()
    game.Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(1)
            local data = Knit.GetService("DataService"):GetPlayerData(p)
            if data then self:EquipWeapon(p, data.EquippedWeapon) end
        end)
    end)
end

return AssetService
