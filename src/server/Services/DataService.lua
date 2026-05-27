local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))
local ProfileService = require(Packages:WaitForChild("ProfileService"))
local ReplicaService = require(Packages:WaitForChild("ReplicaService"))

local DataService = Knit.CreateService {
	Name = "DataService",
	Client = {},
}

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData_v1",
	{
		XP = 0,
		Level = 1,
		Cols = 0,
		Inventory = {},
		Quests = {},
		Skills = {},
		Stats = {
			HP = 100,
			MaxHP = 100,
			Stamina = 100,
			MaxStamina = 100,
		},
	}
)

local Profiles = {} -- [player] = profile
local Replicas = {} -- [player] = replica

function DataService:GetProfile(player)
	return Profiles[player]
end

function DataService:GetReplica(player)
	return Replicas[player]
end

local function PlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		
		profile:ListenToRelease(function()
			Profiles[player] = nil
			if Replicas[player] then
				Replicas[player]:Destroy()
				Replicas[player] = nil
			end
			player:Kick("Data session released.")
		end)

		if player:IsDescendantOf(game.Players) then
			Profiles[player] = profile
			
			-- Create Replica
			local replica = ReplicaService.NewReplica({
				Token = ReplicaService.NewToken("PlayerReplica_" .. player.UserId),
				Data = profile.Data,
				Replication = player,
			})
			Replicas[player] = replica
			
			print("Data loaded for " .. player.Name)
		else
			profile:Release()
		end
	else
		player:Kick("Failed to load data.")
	end
end

function DataService:KnitStart()
	for _, player in ipairs(game.Players:GetPlayers()) do
		task.spawn(PlayerAdded, player)
	end
	game.Players.PlayerAdded:Connect(PlayerAdded)
	
	game.Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]
		if profile then
			print("[DATA] Releasing profile for " .. player.Name)
			profile:Release()
		end
	end)

	game:BindToClose(function()
		print("[DATA] Server closing. Releasing all profiles...")
		for _, profile in pairs(Profiles) do
			profile:Release()
		end
		-- Wait a bit for ProfileService to finish saving
		task.wait(2)
	end)
end

return DataService
