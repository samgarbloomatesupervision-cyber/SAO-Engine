local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local LootService = Knit.CreateService {
    Name = "LootService",
    Client = {},
}

LootService.DropTables = {
    ["Wolf"] = {
        Cols = {Min = 10, Max = 50},
        XP = 20,
        Items = {
            {Name = "Wolf Fur", Chance = 0.5, Amount = 1},
            {Name = "Wolf Tooth", Chance = 0.1, Amount = 1}
        }
    }
}

function LootService:DropLoot(mobName, position)
    local table = self.DropTables[mobName]
    if not table then return end
    
    print("LootService: Dropping loot for " .. mobName)
    
    local lootBag = Instance.new("Part")
    lootBag.Name = "LootBag_" .. mobName
    lootBag.Size = Vector3.new(2, 2, 2)
    lootBag.Position = position
    lootBag.Anchored = true
    lootBag.CanCollide = false
    lootBag.Color = Color3.fromRGB(255, 200, 0)
    
    local lootFolder = workspace:FindFirstChild("Loot") or Instance.new("Folder", workspace)
    lootFolder.Name = "Loot"
    lootBag.Parent = lootFolder
    
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Collect Loot"
    prompt.ObjectText = mobName .. " Drops"
    prompt.Parent = lootBag
    lootBag:SetAttribute("Action", "Loot")
    
    lootBag:SetAttribute("Cols", math.random(table.Cols.Min, table.Cols.Max))
    lootBag:SetAttribute("XP", table.XP)
end

return LootService
