local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local InsertService = game:GetService('InsertService')
local Knit = require(ReplicatedStorage.Packages.Knit)
local AtlasEngine = Knit.CreateService { Name = 'AtlasEngine', Client = {} }
function AtlasEngine:ImportAsset(assetId, assetName)
    print('🤖 Atlas : Importation de l\'asset [' .. assetId .. ']...')
    local success, model = pcall(function() return InsertService:LoadAsset(assetId) end)
    if success and model then
        model.Name = assetName or 'RawAsset_' .. assetId
        for _, child in ipairs(model:GetDescendants()) do if child:IsA('Script') or child:IsA('LocalScript') then child:Destroy() end end
        model.Parent = ServerStorage.Assets.Raw
        print('✅ Atlas : Asset nettoyé -> ' .. model.Name)
        self:AnalyzeAndClassify(model)
        return true
    else warn('❌ Atlas : Échec de l\'importation ' .. assetId) return false end
end
function AtlasEngine:AnalyzeAndClassify(model)
    local actualModel = model:GetChildren()[1] or model
    local metadata = { Name = actualModel.Name, Category = 'Unknown', Tags = {}, HitboxPoints = {} }
    if actualModel:FindFirstChildWhichIsA('Humanoid', true) then
        metadata.Category = 'Mob'; table.insert(metadata.Tags, 'Organic')
    elseif actualModel:FindFirstChildWhichIsA('MeshPart', true) and actualModel.Name:lower():find('sword') then
        metadata.Category = 'Weapon'; metadata.SubType = 'Sword'
        local handle = actualModel:FindFirstChild('Handle') or actualModel.PrimaryPart
        if handle then for i=1, 3 do local att = Instance.new('Attachment', handle) att.Name = 'DmgPoint' table.insert(metadata.HitboxPoints, att.Name) end end
    else metadata.Category = 'Prop' end
    print('🔍 Atlas classification : ' .. metadata.Category)
    self:IntegrateAsset(actualModel, metadata)
end
function AtlasEngine:IntegrateAsset(model, metadata)
    if metadata.Category == 'Weapon' then model.Parent = ServerStorage.Assets.Weapons print('🔗 AtlasBridge [Orion]')
    elseif metadata.Category == 'Mob' then model.Parent = ServerStorage.Assets.Mobs print('🔗 AtlasBridge [Titan]')
    elseif metadata.Category == 'Prop' then model.Parent = ServerStorage.Assets.Props print('🔗 AtlasBridge [Helios]') end
end
function AtlasEngine:KnitStart()
    print("🌐 ATLAS v1 : Moteur d'Exploration en ligne.")
    
    local Players = game:GetService("Players")
    local ADMIN_NAME = "PapiSimsimy" -- Ton pseudo mis à jour
    
    Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(message)
            if player.Name == ADMIN_NAME then
                if message:sub(1, 7) == "/atlas " then
                    local idStr = message:sub(8)
                    local assetId = tonumber(idStr)
                    
                    if assetId then
                        print("🤖 Atlas : Commande manuelle reçue pour l'ID " .. assetId)
                        -- Lancement de la tâche d'importation en asynchrone
                        task.spawn(function()
                            local success = self:ImportAsset(assetId, "AtlasImport_" .. assetId)
                            if success then
                                print("✅ Atlas : Traitement manuel de " .. assetId .. " terminé.")
                            end
                        end)
                    else
                        warn("❌ Atlas : ID invalide (" .. tostring(idStr) .. ")")
                    end
                end
            end
        end)
    end)
end

return AtlasEngine
