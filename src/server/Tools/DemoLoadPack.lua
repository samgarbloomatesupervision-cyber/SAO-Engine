-- ATLAS v10 Pack Import Demo
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlas = require(ReplicatedStorage:WaitForChild("Atlas"))

task.wait(5) -- Wait for engine to settle
print("🚀 [DEMO] Atlas is about to pull a full pack from GitHub...")

-- Process the 'Monsters' pack from GitHubRegistry
Atlas.ProcessPack("Monsters")

print("✨ [DEMO] Pack processing request sent. Check ServerStorage.Assets.Mobs for results.")
