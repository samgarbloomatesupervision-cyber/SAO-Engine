local RS = game:GetService('ReplicatedStorage')
local W = game:GetService('Workspace')
local Knit = require(RS.Shared.Knit)
local ZP = require(RS.Helios.ZoneProfiles)
local WB = require(RS.Helios.WorldBuilder)
local ZoneService = Knit.CreateService { Name = 'ZoneService', Client = { ZoneChanged = Knit.CreateSignal() } }
local function buildZone(zi, pr)
  local o = pr.Origin
  for x = 1, pr.Size.X do for z = 1, pr.Size.Y do
    WB.BuildTile(pr.Tile, o + Vector3.new((x-1)*20, 0, (z-1)*20))
  end end
  for _, p in ipairs(pr.Props or {}) do
    if p.Random then for i = 1, p.Count do
      WB.PlaceProp({Asset = p.Asset, Position = Vector3.new(math.random(0, pr.Size.X-1)*20, 0, math.random(0, pr.Size.Y-1)*20)}, o)
    end else WB.PlaceProp(p, o) end
  end
end
function ZoneService:KnitStart()
  if not W:FindFirstChild('World') then Instance.new('Folder', W).Name = 'World' end
  W.World:ClearAllChildren()
  for zi, pr in pairs(ZP) do buildZone(zi, pr) end
  print('[Helios] World built.')
end
return ZoneService
