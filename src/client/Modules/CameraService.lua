local CameraService = {}

local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

function CameraService.Shake(intensity, duration)
    local startTime = tick()
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > duration then
            connection:Disconnect()
            camera.Offset = CFrame.new() -- Reset
            return
        end
        
        local currentIntensity = intensity * (1 - (elapsed / duration))
        local offset = Vector3.new(
            math.random(-100, 100)/100 * currentIntensity,
            math.random(-100, 100)/100 * currentIntensity,
            math.random(-100, 100)/100 * currentIntensity
        )
        
        camera.CFrame = camera.CFrame * CFrame.new(offset)
    end)
end

return CameraService
