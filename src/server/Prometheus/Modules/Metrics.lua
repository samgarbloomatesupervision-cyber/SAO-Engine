local Metrics = {}
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

function Metrics.GetReport()
    local report = {
        FPS = Workspace:GetRealPhysicsFPS(),
        CPU = Stats.InstanceCount, -- Heuristic
        Memory = Stats:GetTotalMemoryUsageMb(),
        Ping = 0, -- Set by client reporting
        ActiveMobs = 0,
        ActiveFX = 0,
        WorkspaceInstances = 0,
        ReplicaSize = 0 -- Conceptual
    }
    
    local mobs = Workspace:FindFirstChild("Mobs_Workspace")
    if mobs then report.ActiveMobs = #mobs:GetChildren() end
    
    -- Very rough heuristic for active FX/Instances to avoid deep scanning every 0.5s
    report.WorkspaceInstances = #Workspace:GetChildren() 
    
    return report
end

return Metrics