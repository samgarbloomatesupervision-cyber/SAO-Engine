local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Shared.Knit)

local TelemetryService = Knit.CreateService {
    Name = "TelemetryService",
    Client = {
        ResonanceChanged = Knit.CreateSignal(), -- Signal pour informer les clients
    },
}

-- Les mémoires de Nexus
local ServerStats = {
    SkillUsage = {},
    WeaponUsage = {},
    ZoneVisits = {}
}

function TelemetryService:RecordAttack(weaponName, skillName)
    ServerStats.WeaponUsage[weaponName] = (ServerStats.WeaponUsage[weaponName] or 0) + 1
    ServerStats.SkillUsage[skillName] = (ServerStats.SkillUsage[skillName] or 0) + 1
end

function TelemetryService:RecordZoneVisit(zoneName)
    ServerStats.ZoneVisits[zoneName] = (ServerStats.ZoneVisits[zoneName] or 0) + 1
end

function TelemetryService:GetServerStats()
    return ServerStats
end

function TelemetryService:KnitStart()
    print("👁️ Nexus : TelemetryService en ligne. Observation du monde en cours...")
    
    task.spawn(function()
        while true do
            task.wait(30)
            print("--- 📊 RAPPORT NEXUS (30s) ---")
            for weapon, count in pairs(ServerStats.WeaponUsage) do
                print("Arme: " .. weapon .. " | Utilisations: " .. count)
            end
            for zone, count in pairs(ServerStats.ZoneVisits) do
                print("Zone: " .. zone .. " | Visites: " .. count)
            end
            print("------------------------------")
        end
    end)
end

return TelemetryService
