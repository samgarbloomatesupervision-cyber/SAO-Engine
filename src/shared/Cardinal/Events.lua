local Events = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
Remotes.Name = "Remotes"
Remotes.Parent = ReplicatedStorage

function Events.GetRemoteEvent(name)
    local event = Remotes:FindFirstChild(name)
    if not event then
        event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = Remotes
    end
    return event
end

function Events.GetRemoteFunction(name)
    local func = Remotes:FindFirstChild(name)
    if not func then
        func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = Remotes
    end
    return func
end

return Events
