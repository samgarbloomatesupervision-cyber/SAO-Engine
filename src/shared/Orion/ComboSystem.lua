local ComboSystem = {}
ComboSystem.__index = ComboSystem

function ComboSystem.new()
    local self = setmetatable({
        CurrentIndex = 0,
        LastInputTime = 0,
        MaxCombo = 3,
        ResetWindow = 0.8, -- Time before combo resets
        BufferWindow = 0.3, -- Time to buffer next input
        IsActive = false
    }, ComboSystem)
    return self
end

function ComboSystem:Next()
    local now = tick()
    
    if now - self.LastInputTime > self.ResetWindow then
        self.CurrentIndex = 1
    else
        self.CurrentIndex = (self.CurrentIndex % self.MaxCombo) + 1
    end
    
    self.LastInputTime = now
    return self.CurrentIndex
end

function ComboSystem:GetAnimation(weaponType)
    -- Map index to specific animation IDs or names
    local anims = {
        [1] = "rbxassetid://18408103328", -- Slash 1
        [2] = "rbxassetid://18408103328", -- Slash 2 (Placeholder)
        [3] = "rbxassetid://18408103328", -- Heavy Finish
    }
    return anims[self.CurrentIndex]
end

return ComboSystem