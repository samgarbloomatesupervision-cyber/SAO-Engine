local Biomes = {}

Biomes.Definitions = {
    ["Forest"] = {
        TileSize = 60,
        PropDensity = 0.8,
        AtlasQueries = {"low poly tree", "pine tree", "bush", "low poly rock"},
        Color = Color3.fromRGB(34, 139, 34),
        Ambiance = "BGM_FIELD_1",
        HasFog = true,
        FogColor = Color3.fromRGB(150, 180, 150)
    },
    ["Plains"] = {
        TileSize = 60,
        PropDensity = 0.2,
        AtlasQueries = {"low poly grass", "small rock", "flower"},
        Color = Color3.fromRGB(124, 252, 0),
        Ambiance = "BGM_FIELD_1",
        HasFog = false
    },
    ["Mountain"] = {
        TileSize = 60,
        PropDensity = 0.5,
        AtlasQueries = {"boulder", "low poly rock", "dead tree"},
        Color = Color3.fromRGB(139, 137, 137),
        Ambiance = "BGM_FIELD_1",
        HasFog = true,
        FogColor = Color3.fromRGB(200, 200, 200)
    },
    ["Swamp"] = {
        TileSize = 60,
        PropDensity = 0.7,
        AtlasQueries = {"dead tree", "mushroom", "mud rock"},
        Color = Color3.fromRGB(47, 79, 79),
        Ambiance = "BGM_FIELD_1",
        HasFog = true,
        FogColor = Color3.fromRGB(30, 50, 30)
    },
    ["Dungeon"] = {
        TileSize = 40,
        PropDensity = 0.4,
        AtlasQueries = {"dungeon pillar", "torch", "crate", "skeleton"},
        Color = Color3.fromRGB(50, 50, 50),
        Ambiance = "BGM_DUNGEON",
        HasFog = true,
        FogColor = Color3.fromRGB(10, 10, 10)
    },
    ["Town"] = {
        TileSize = 80,
        PropDensity = 0.9,
        AtlasQueries = {"medieval house", "well", "cart", "fountain"},
        Color = Color3.fromRGB(200, 180, 140),
        Ambiance = "BGM_TOWN",
        HasFog = false
    }
}

return Biomes