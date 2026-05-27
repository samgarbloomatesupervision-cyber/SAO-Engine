local WeaponBase = {}
WeaponBase.__index = WeaponBase

function WeaponBase.new(meta)
    local self = setmetatable({}, WeaponBase)
    self.Name = meta.Name
    self.Category = meta.SubType
    self.Rarity = meta.Rarity
    self.Skills = meta.DefaultSkills
    self.HitboxPoints = meta.HitboxPoints
    return self
end

return WeaponBase
