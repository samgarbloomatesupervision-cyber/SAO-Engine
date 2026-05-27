local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local DamagePopupService = {}

function DamagePopupService.spawnPopup(target, amount, isCrit)
  if not target or not target:FindFirstChild("Head") then return end
  
  local billboard = Instance.new("BillboardGui")
  billboard.Size = UDim2.new(0, 80, 0, 40)
  billboard.StudsOffset = Vector3.new(0, 3, 0)
  billboard.AlwaysOnTop = true
  billboard.Adornee = target.Head
  
  local label = Instance.new("TextLabel", billboard)
  label.Size = UDim2.fromScale(1, 1)
  label.BackgroundTransparency = 1
  label.Text = isCrit and "💥 " .. amount or tostring(amount)
  label.TextColor3 = isCrit and Color3.fromRGB(255,50,50) or Color3.fromRGB(255,220,80)
  label.Font = Enum.Font.GothamBold
  label.TextScaled = true
  
  billboard.Parent = target.Head
  
  -- Animation
  local startOffset = billboard.StudsOffset
  TweenService:Create(billboard, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    StudsOffset = startOffset + Vector3.new(0, 3, 0),
  }):Play()
  TweenService:Create(label, TweenInfo.new(0.8), {
    TextTransparency = 1
  }):Play()
  
  Debris:AddItem(billboard, 1)
end

return DamagePopupService
