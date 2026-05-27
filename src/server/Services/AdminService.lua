local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local AdminService = Knit.CreateService {
    Name = "AdminService",
    Client = {},
}

function AdminService:KnitStart()
    print("[ADMIN] AdminService online.")
end

function AdminService.Client:ExecuteCommand(player, command, args)
    -- Security check: Verify if player is admin
    print(string.format("[ADMIN] %s executing: %s", player.Name, command))
    
    if command == "GenerateZone" then
        local Gaia = Knit.GetService("GaiaService")
        Gaia:GenerateZone(args.Biome, player.Character.PrimaryPart.Position, args.Size or 5)
    elseif command == "GenerateVillage" then
        local Gaia = Knit.GetService("GaiaService")
        Gaia:GenerateVillage(player.Character.PrimaryPart.Position, args.Houses or 10)
    elseif command == "RepairSystem" then
        local Sentinel = Knit.GetService("SentinelService")
        Sentinel:NotifyPlayers("Lancement d'une réparation système forcée...", "Warning")
        -- Trigger logic
    end
end

return AdminService
