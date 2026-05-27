local ChangeTracker = {}

local history = {}

function ChangeTracker.TrackSnapshot(manifest)
    print("[HERMES] ChangeTracker: Archiving project snapshot...")
    
    local current = {
        Timestamp = os.date("%X"),
        ServiceCount = #manifest.Services,
        ControllerCount = #manifest.Controllers,
        PillarCount = #manifest.SharedModules,
        Names = {}
    }
    
    for _, s in ipairs(manifest.Services) do table.insert(current.Names, s.Name) end
    
    if #history > 0 then
        local prev = history[#history]
        local added = {}
        for _, name in ipairs(current.Names) do
            if not table.find(prev.Names, name) then table.insert(added, name) end
        end
        
        if #added > 0 then
            print("[HERMES] 📢 CHANGELOG: Added " .. table.concat(added, ", "))
        end
    end
    
    table.insert(history, current)
end

function ChangeTracker.GetHistory() return history end

return ChangeTracker