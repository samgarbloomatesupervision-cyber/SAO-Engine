local EventTracker = {}
local Reporter = require(script.Parent:WaitForChild("Reporter"))
local tracking = {}

function EventTracker.Init()
    print("[SENTINEL] EventTracker: Initialized")
    task.spawn(function()
        while true do
            task.wait(60)
            table.clear(tracking) -- Reset per minute
        end
    end)
end

function EventTracker.Track(eventName, source)
    tracking[eventName] = (tracking[eventName] or 0) + 1
    if tracking[eventName] > 100 then
        Reporter.Alert("EventSpam", string.format("Event %s spammed %d times by %s", eventName, tracking[eventName], tostring(source)), "CRITICAL")
    end
end

return EventTracker