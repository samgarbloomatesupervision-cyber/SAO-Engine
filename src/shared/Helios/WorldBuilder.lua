local SS = game:GetService('ServerStorage')
local W = game:GetService('Workspace')
local WB = {}
function WB.BuildTile(n, p)
  local a = SS.Assets.Tiles:FindFirstChild(n)
  if a then local c = a:Clone(); if c:IsA('BasePart') then c.CFrame = CFrame.new(p) else c:SetPrimaryPartCFrame(CFrame.new(p)) end; c.Parent = W.World end
end
function WB.PlaceProp(pr, o)
  local a = SS.Assets.Props:FindFirstChild(pr.Asset)
  if a then local c = a:Clone(); local p = o + (pr.Position or Vector3.new()); c:SetPrimaryPartCFrame(CFrame.new(p)); c.Parent = W.World end
end
return WB
