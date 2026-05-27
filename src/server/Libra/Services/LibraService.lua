local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)

local LibraService = Knit.CreateService { Name = "LibraService" }

local CachedData = {}

function LibraService:KnitInit()
    print("🧱 Libra : Initialisation du registre central...")
    local pillars = {"Cardinal", "Helios", "Titan", "Aurora", "Nexus", "Orion"}
    
    for _, pillar in ipairs(pillars) do
        local folder = ReplicatedStorage:FindFirstChild(pillar)
        if folder then
            for _, sub in ipairs(folder:GetChildren()) do
                if sub:IsA("ModuleScript") then
                    self:_RegisterModule(pillar, sub)
                elseif sub:IsA("Folder") then
                    for _, module in ipairs(sub:GetChildren()) do
                        if module:IsA("ModuleScript") then
                            self:_RegisterModule(pillar, module)
                        end
                    end
                end
            end
        end
    end
end

function LibraService:_RegisterModule(pillar, module)
    local key = pillar .. "_" .. module.Name
    local success, data = pcall(function() return require(module) end)
    if success and data then
        CachedData[key] = data
        print("🧱 Libra : Brique enregistrée -> " .. key)
    else
        warn("⚠️ Libra : Échec du chargement de " .. key .. " : " .. tostring(data))
    end
end

function LibraService:Get(pillar, moduleName)
    if not pillar or not moduleName then return nil end
    local key = pillar .. "_" .. moduleName
    return CachedData[key]
end

function LibraService:GetEntry(pillar, moduleName, key)
    local data = self:Get(pillar, moduleName)
    if data and type(data) == "table" then
        return data[key]
    end
    return nil
end

return LibraService
