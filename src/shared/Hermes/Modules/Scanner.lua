local Scanner = {}
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

function Scanner.ScanProject()
    print("[HERMES] Scanner: Starting deep project scan...")
    local manifest = {
        Services = {},
        Controllers = {},
        SharedModules = {},
        Assets = {}
    }
    
    -- 1. Scan Services
    for _, descendant in ipairs(ServerScriptService:GetDescendants()) do
        if descendant:IsA("ModuleScript") and (descendant.Name:find("Service") or descendant.Name:find("Engine")) then
            table.insert(manifest.Services, {
                Name = descendant.Name,
                Path = descendant:GetFullName(),
                Instance = descendant
            })
        end
    end
    
    -- 2. Scan Controllers
    for _, descendant in ipairs(StarterPlayer.StarterPlayerScripts:GetDescendants()) do
        if descendant:IsA("ModuleScript") and descendant.Name:find("Controller") then
            table.insert(manifest.Controllers, {
                Name = descendant.Name,
                Path = descendant:GetFullName(),
                Instance = descendant
            })
        end
    end
    
    -- 3. Scan Shared / Pillars
    local pillars = {"Cardinal", "Atlas", "Helios", "Titan", "Aurora", "Nexus", "Orion", "Gaia", "Sentinel", "Oracle", "Hermes"}
    for _, pillarName in ipairs(pillars) do
        local pillar = ReplicatedStorage:FindFirstChild(pillarName)
        if pillar then
            table.insert(manifest.SharedModules, {
                Name = pillarName,
                Path = pillar:GetFullName(),
                Instance = pillar
            })
        end
    end

    print(string.format("[HERMES] Scanner complete: Found %d Services, %d Controllers, %d Pillars.", #manifest.Services, #manifest.Controllers, #manifest.SharedModules))
    return manifest
end

return Scanner