local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Shared.Knit)

print("⏳ Initialisation des systèmes clients...")

-- Auto-chargement de tous les contrôleurs dans Aurora
local controllersFolder = StarterPlayer:WaitForChild("StarterPlayerScripts")
    :WaitForChild("Aurora")
    :WaitForChild("Controllers")

for _, module in ipairs(controllersFolder:GetChildren()) do
    if module:IsA("ModuleScript") then
        require(module)
        print("🎮 Contrôleur chargé : " .. module.Name)
    end
end

-- Allumage de Knit côté Client
Knit.Start():andThen(function()
    print("⚡ [CLIENT SYSTEM] : Connexion établie et contrôleurs activés.")
end):catch(warn)
