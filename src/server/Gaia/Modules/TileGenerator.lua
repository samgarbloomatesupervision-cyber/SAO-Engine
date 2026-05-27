local TileGenerator = {}

function TileGenerator.CreateTile(position, size, color)
    local tile = Instance.new("Part")
    tile.Name = "GaiaTile"
    tile.Size = Vector3.new(size, 1, size)
    tile.Position = position
    tile.Anchored = true
    tile.Color = color
    tile.Parent = workspace:FindFirstChild("World") or Instance.new("Folder", workspace)
    workspace.World.Name = "World"
    return tile
end

return TileGenerator
