-- GAIA v10 Master Orchestrator
local ServerScriptService = game:GetService("ServerScriptService")
local Gaia = require(ServerScriptService.Gaia.Services.GaiaService)

print("🚀 [GAIA] Starting High-Fidelity Construction of Floor 1...")

task.spawn(function()
    -- The new simplified master function that handles town, forest, and paths
    Gaia:GenerateAincradFloor()
    print("✨ [GAIA] Floor 1 Construction Complete. Welcome to Aincrad.")
end)
