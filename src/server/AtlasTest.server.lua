local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Atlas = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Atlas"))
local WeaponList = require(ReplicatedStorage:WaitForChild("shared"):WaitForChild("Orion"):WaitForChild("WeaponList"))
local HeliosWorldGenerator = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("HeliosWorldGenerator"))

-- 1. Process Weapons
print("--- [1] Processing Weapon Batch ---")
Atlas.ProcessWeaponBatch(WeaponList)

-- 2. Generate World (Town & Forest)
print("\n--- [2] Generating World ---")
HeliosWorldGenerator.GenerateWorld()

print("\n--- ALL ATLAS TASKS COMPLETE ---")
