local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new()
    local self = setmetatable({
        CurrentState = "Idle",
        States = {
            ["Idle"] = { CanAttack = true, CanMove = true, CanDash = true },
            ["Attacking"] = { CanAttack = false, CanMove = false, CanDash = false },
            ["Dodging"] = { CanAttack = false, CanMove = false, CanDash = false, IsInvulnerable = true },
            ["Stunned"] = { CanAttack = false, CanMove = false, CanDash = false },
            ["Blocking"] = { CanAttack = false, CanMove = true, CanDash = false },
        }
    }, StateMachine)
    return self
end

function StateMachine:SetState(stateName, duration)
    if not self.States[stateName] then warn("Invalid state: " .. stateName) return end
    
    self.CurrentState = stateName
    -- print("[STATE] Player shifted to: " .. stateName)
    
    if duration then
        task.delay(duration, function()
            if self.CurrentState == stateName then
                self:SetState("Idle")
            end
        end)
    end
end

function StateMachine:Get()
    return self.States[self.CurrentState]
end

return StateMachine