local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local CraftingService = Knit.CreateService {
    Name = "CraftingService",
    Client = {},
}

function CraftingService:KnitStart()
    print("CraftingService: Initialized")
end

function CraftingService.Client:CraftItem(player, recipeId)
    -- Logic for checking materials and adding item to inventory
    print(player.Name .. " is crafting " .. recipeId)
end

return CraftingService
