local UIOptimizer = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function UIOptimizer.Apply(profileData)
    print("[PROMETHEUS] UIOptimizer: Notifying clients to adjust UI fidelity.")
    -- Send a signal to all Aurora client controllers to disable heavy tweens/blur
    local Events = ReplicatedStorage:FindFirstChild("Events")
    if Events then
        local evt = Events:FindFirstChild("OptimizeUI") or Instance.new("RemoteEvent", Events)
        evt.Name = "OptimizeUI"
        evt:FireAllClients(profileData.LODLevel)
    end
end

return UIOptimizer