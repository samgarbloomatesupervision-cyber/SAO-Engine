return {
    Town = { Origin = Vector3.new(0, 0, 0), Size = Vector2.new(6, 6), Tile = 'GrassTile', Props = { { Asset = 'HouseSmall', Position = Vector3.new(40, 0, 40) }, { Asset = 'TreeCluster', Random = true, Count = 10 } } },
    Field_1 = { Origin = Vector3.new(0, 0, 200), Size = Vector2.new(12, 12), Tile = 'GrassTile', Props = { { Asset = 'TreeCluster', Random = true, Count = 20 }, { Asset = 'RockTile', Random = true, Count = 8 } } },
    Dungeon_Entrance = { Origin = Vector3.new(0, 0, 500), Size = Vector2.new(8, 8), Tile = 'RockTile', Props = { { Asset = 'DungeonGate', Position = Vector3.new(60, 0, 60) }, { Asset = 'TreeCluster', Random = true, Count = 5 } } }
}
