local Rules = {}

Rules.Profiles = {
    ["High"] = {
        FXDensity = 1.0,
        AIDensity = 1.0,
        NetworkFrequency = 1.0, -- 100% update rate
        LODLevel = "High"
    },
    ["Medium"] = {
        FXDensity = 0.6,
        AIDensity = 0.6,
        NetworkFrequency = 0.5, -- 50% update rate
        LODLevel = "Medium"
    },
    ["Low"] = {
        FXDensity = 0.2,
        AIDensity = 0.3,
        NetworkFrequency = 0.2, -- 20% update rate
        LODLevel = "Low"
    },
    ["Critical"] = {
        FXDensity = 0.0,
        AIDensity = 0.1,
        NetworkFrequency = 0.1,
        LODLevel = "Minimum"
    }
}

Rules.Thresholds = {
    FPS_Critical = 25,
    FPS_Warning = 40,
    Memory_Critical = 2500,
    Memory_Warning = 1800,
    CPU_Spike = 50000 -- Instance count heuristic
}

return Rules