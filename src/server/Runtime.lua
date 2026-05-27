local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Shared.Knit)

print("⏳ Initialisation des moteurs...")

local piliers = {
    ServerScriptService:WaitForChild("Libra"):WaitForChild("Services"), -- EN PREMIER !
    ServerScriptService:WaitForChild("Cardinal"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Helios"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Orion"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Titan"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Nexus"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Gaia"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Oracle"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Prometheus"):WaitForChild("Services"),
    ServerScriptService:WaitForChild("Sentinel"):WaitForChild("Services"),
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Hermes"):WaitForChild("Services"),
}

for _, folder in ipairs(piliers) do
    for _, module in ipairs(folder:GetChildren()) do
        if module:IsA("ModuleScript") then
            require(module)
            print("📦 Moteur chargé : " .. module.Name)
        end
    end
end

Knit.Start():andThen(function()
    print("🔥 [SERVEUR SYSTEM] : Tous les systèmes sont interconnectés et prêts !")
end):catch(warn)
