local FXOptimizer = {}

function FXOptimizer.Apply(profileData)
    print("[PROMETHEUS] FXOptimizer: Applying FX Density -> " .. tostring(profileData.FXDensity))
    -- In a real scenario, this fires a signal to clients to reduce ParticleEmitter.Rate
    -- or disable certain visual features.
    
    local Workspace = game:GetService("Workspace")
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc:IsA("ParticleEmitter") then
            if not desc:GetAttribute("OriginalRate") then
                desc:SetAttribute("OriginalRate", desc.Rate)
            end
            desc.Rate = desc:GetAttribute("OriginalRate") * profileData.FXDensity
            desc.Enabled = profileData.FXDensity > 0
        elseif desc:IsA("Trail") or desc:IsA("Beam") then
            desc.Enabled = profileData.FXDensity > 0.2
        end
    end
end

return FXOptimizer