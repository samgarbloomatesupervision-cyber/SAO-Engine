local Cardinal = {}

Cardinal.Atlas = require(game:GetService("ReplicatedStorage"):WaitForChild("Atlas"))
Cardinal.Orion = require(game:GetService("ReplicatedStorage"):WaitForChild("Orion"):WaitForChild("WeaponBase"))
Cardinal.Helios = require(game:GetService("ReplicatedStorage"):WaitForChild("Helios"))
Cardinal.Titan = require(game:GetService("ReplicatedStorage"):WaitForChild("Titan"))

print("Cardinal Core: All systems initialized.")

return Cardinal
