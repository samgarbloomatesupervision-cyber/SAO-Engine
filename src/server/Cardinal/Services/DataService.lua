local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Shared.Knit)
local ProfileService = require(ReplicatedStorage.Shared.ProfileService)
local ReplicaService = require(ReplicatedStorage.Shared.ReplicaService)

local DataService = Knit.CreateService {
    Name = "DataService",
    Client = {},
}

-- 1. Configuration du DataStore avec ProfileService
local ProfileStore = ProfileService.GetProfileStore("PlayerData_V3", {
    Level = 1,
    XP = 0,
    EquippedWeapon = "TraineeSword",
    Inventory = { "TraineeSword" },
    CurrentZone = "Town",
})

local Profiles = {} -- Cache des profils
local PlayerReplicas = {} -- Cache des replicas
local PlayerDataToken = ReplicaService.NewClassToken("PlayerData_" .. game.PlaceId)

--- Gestion de l'arrivée d'un joueur
local function OnPlayerAdded(player)
    local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
    
    if profile then
        profile:AddUserId(player.UserId) -- Sécurité pour le RGPD
        profile:Reconcile() -- Remplit les données manquantes si le template a changé
        
        profile:ListenToRelease(function()
            if PlayerReplicas[player] then
                PlayerReplicas[player]:Destroy()
                PlayerReplicas[player] = nil
            end
            Profiles[player] = nil
            player:Kick("Vos données ont été chargées sur un autre serveur.")
        end)
        
        if player:IsDescendantOf(Players) then
            Profiles[player] = profile
            
            -- 2. Initialisation du Replica pour la synchronisation Aurora (HUD)
            local replica = ReplicaService.NewReplica({
                ClassToken = PlayerDataToken,
                Tags = { Player = player },
                Data = profile.Data,
                Replication = player
            })
            PlayerReplicas[player] = replica
            
            print("💾 Cardinal : Données persistantes chargées et répliquées pour " .. player.Name)
        else
            profile:Release()
        end
    else
        player:Kick("Impossible de charger vos données. Veuillez réessayer.")
    end
end

-- API : Ajouter de l'XP avec calcul de Level Up et sauvegarde automatique
function DataService:AddXP(player, amount)
    local profile = Profiles[player]
    local replica = PlayerReplicas[player]
    if not profile or not replica then return end

    local data = profile.Data
    data.XP = data.XP + amount
    local requiredXP = data.Level * 100

    while data.XP >= requiredXP do
        data.XP = data.XP - requiredXP
        data.Level = data.Level + 1
        requiredXP = data.Level * 100
        
        -- On met à jour le Replica pour prévenir le Client (Aurora)
        replica:SetValue({"Level"}, data.Level)
        print("🌟 Cardinal : " .. player.Name .. " a atteint le NIVEAU " .. data.Level .. " !")
        
        local character = player.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.Health = humanoid.MaxHealth end
    end

    replica:SetValue({"XP"}, data.XP)
end

-- API : Récupérer les données
function DataService:GetPlayerData(player)
    local profile = Profiles[player]
    return profile and profile.Data or nil
end

-- API : Mettre à jour une valeur spécifique (avec sync Replica)
function DataService:UpdateDataValue(player, key, value)
    local profile = Profiles[player]
    local replica = PlayerReplicas[player]
    if profile and replica and profile.Data[key] ~= nil then
        profile.Data[key] = value
        replica:SetValue({key}, value)
    end
end

function DataService:AddItemToInventory(player, itemName)
    local profile = Profiles[player]
    local replica = PlayerReplicas[player]
    if profile and replica then
        table.insert(profile.Data.Inventory, itemName)
        -- On utilise SetValue pour déclencher la réplication de la table entière (simplifié pour le mock)
        replica:SetValue({"Inventory"}, profile.Data.Inventory)
        print("🎁 Cardinal : " .. itemName .. " ajouté à l'inventaire de " .. player.Name)
    end
end

function DataService:KnitStart()
    print("🚀 Cardinal DataService (Persistent) démarré !")
    
    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(function(player)
        local profile = Profiles[player]
        if profile then profile:Release() end
    end)
    
    -- Sécurité pour les serveurs de test
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(OnPlayerAdded, player)
    end
end

return DataService
