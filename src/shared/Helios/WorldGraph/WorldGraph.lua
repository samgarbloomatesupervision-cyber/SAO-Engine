return {
    Zones = {
        ["Town"] = {
            Type = "Safe",
            Connections = { "Field_1" },
            Profile = "Town_Ambiance",
        },
        ["Field_1"] = {
            Type = "Combat",
            Connections = { "Town", "Dungeon_1" },
            Profile = "Field_1_Ecosystem",
            Difficulty = 1,
        },
        ["Dungeon_1"] = {
            Type = "Dungeon",
            Connections = { "Field_1" },
            Profile = "Dungeon_1_Ecosystem",
            Difficulty = 3,
        },
    }
}
