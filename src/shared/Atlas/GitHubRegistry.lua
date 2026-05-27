local GitHubRegistry = {}

-- 📂 The Master Database of SAO-Compatible Open-Source Assets
GitHubRegistry.Packs = {
    ["Weapons"] = {
        { Name = "Quaternius Weapons", Url = "https://github.com/quaternius/Weapons", Author = "Quaternius" },
        { Name = "Ultimate Low Poly", Url = "https://github.com/quaternius/UltimateLowPolyPack", Author = "Quaternius" }
    },
    ["Nature"] = {
        { Name = "Nature Kit", Url = "https://github.com/KenneyNL/nature-kit", Author = "Kenney" },
        { Name = "Low Poly Nature", Url = "https://github.com/KenneyNL/kenney_lowpoly", Author = "Kenney" },
        { Name = "Rocks Pack", Url = "https://github.com/KenneyNL/rocks-pack", Author = "Kenney" }
    },
    ["Town"] = {
        { Name = "Village Kit", Url = "https://github.com/KenneyNL/village-kit", Author = "Kenney" },
        { Name = "Medieval Buildings", Url = "https://github.com/KenneyNL/medieval-buildings", Author = "Kenney" },
        { Name = "Street Kit", Url = "https://github.com/KenneyNL/street-kit", Author = "Kenney" },
        { Name = "Buildings Pack", Url = "https://github.com/quaternius/Buildings", Author = "Quaternius" }
    },
    ["Dungeon"] = {
        { Name = "Dungeon Pack", Url = "https://github.com/KenneyNL/dungeon-pack", Author = "Kenney" },
        { Name = "Fantasy Pack", Url = "https://github.com/KenneyNL/fantasy-pack", Author = "Kenney" }
    },
    ["Monsters"] = {
        { Name = "Monsters Pack", Url = "https://github.com/quaternius/Monsters", Author = "Quaternius" }
    }
}

function GitHubRegistry.FindPack(query)
    query = query:lower()
    for category, packs in pairs(GitHubRegistry.Packs) do
        if category:lower():find(query) then
            return packs
        end
        for _, pack in ipairs(packs) do
            if pack.Name:lower():find(query) then
                return {pack}
            end
        end
    end
    return nil
end

return GitHubRegistry