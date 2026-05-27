local ReplicaController = {}
local Listeners = {}
function ReplicaController.ReplicaOfClassCreated(name, cb)
    Listeners[name] = Listeners[name] or {}
    table.insert(Listeners[name], cb)
end
function ReplicaController.RequestData() print('Handshake...') end
function ReplicaController._NewReplicaCreated(r)
    if Listeners[r.Class] then for _, cb in ipairs(Listeners[r.Class]) do task.spawn(cb, r) end end
end
return ReplicaController
