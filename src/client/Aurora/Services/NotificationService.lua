local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local NotificationService = {}
local queue = {}
local isPlaying = false

-- On s'attend à ce qu'un NotifGui existe dans PlayerGui
local function getNotifGui()
    local lp = Players.LocalPlayer
    local gui = lp.PlayerGui:FindFirstChild("NotifGui")
    if not gui then
        gui = Instance.new("ScreenGui", lp.PlayerGui)
        gui.Name = "NotifGui"
        
        local template = Instance.new("Frame", gui)
        template.Name = "Template"
        template.Size = UDim2.new(0, 250, 0, 60)
        template.Position = UDim2.new(-0.5, 0, 0.85, 0)
        template.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
        template.BackgroundTransparency = 0.3
        Instance.new("UICorner", template)
        local stroke = Instance.new("UIStroke", template)
        stroke.Color = Color3.fromRGB(0, 170, 255)
        stroke.Thickness = 2
        
        local icon = Instance.new("TextLabel", template)
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 50, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "ℹ️"
        icon.TextSize = 30
        icon.TextColor3 = Color3.new(1,1,1)
        
        local msg = Instance.new("TextLabel", template)
        msg.Name = "Message"
        msg.Size = UDim2.new(1, -60, 1, 0)
        msg.Position = UDim2.new(0, 60, 0, 0)
        msg.BackgroundTransparency = 1
        msg.Text = "Notification message"
        msg.TextColor3 = Color3.new(1,1,1)
        msg.TextXAlignment = Enum.TextXAlignment.Left
        msg.Font = Enum.Font.GothamMedium
        msg.TextSize = 14
        msg.TextWrapped = true
    end
    return gui
end

local function showNext()
  if #queue == 0 then isPlaying = false return end
  isPlaying = true
  local notif = table.remove(queue, 1)
  local gui = getNotifGui()
  local frame = gui.Template:Clone()
  frame.Icon.Text = notif.icon
  frame.Message.Text = notif.text
  frame.Parent = gui
  frame.Visible = true

  -- Slide in
  frame.Position = UDim2.new(-0.4, 0, 0.85, 0)
  TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    Position = UDim2.new(0.02, 0, 0.85, 0)
  }):Play()

  task.wait(3)

  TweenService:Create(frame, TweenInfo.new(0.3), {
    Position = UDim2.new(-0.4, 0, 0.85, 0)
  }):Play()
  task.wait(0.3)
  frame:Destroy()
  showNext()
end

function NotificationService.notify(icon, text)
  table.insert(queue, { icon=icon, text=text })
  if not isPlaying then
    task.spawn(showNext)
  end
end

return NotificationService
