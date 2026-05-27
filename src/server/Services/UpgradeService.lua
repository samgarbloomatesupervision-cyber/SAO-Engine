local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local UpgradeService = Knit.CreateService {
    Name = "UpgradeService",
    Client = {},
}

function UpgradeService:KnitStart()
    print("UpgradeService: Initialized")
end

function UpgradeService.Client:UpgradeWeapon(player, weaponId)
    -- Logic for consuming Cols/Materials to increase weapon stats
    print(player.Name .. " is upgrading " .. weaponId)
end

return UpgradeService
