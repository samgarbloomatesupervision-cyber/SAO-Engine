local Knit = require(game.ReplicatedStorage.Shared.Knit)
local ReplicaController = require(game.ReplicatedStorage.Shared.ReplicaController)
local HUDController = Knit.CreateController { Name = 'HUDController' }
function HUDController:KnitStart()
    local lp = game.Players.LocalPlayer
    local gui = lp:WaitForChild('PlayerGui'):WaitForChild('MainHUD')
    local fill = gui.HealthFrame.Fill
    local zone = gui.ZoneLabel
    local function setup(char)
        local hum = char:WaitForChild('Humanoid')
        hum.HealthChanged:Connect(function(h) fill:TweenSize(UDim2.new(h/hum.MaxHealth,0,1,0),'Out','Quad',0.2,true) end)
    end
    if lp.Character then setup(lp.Character) end
    lp.CharacterAdded:Connect(setup)
    ReplicaController.ReplicaOfClassCreated('PlayerData_' .. game.PlaceId, function(r)
        if r.Tags.Player == lp then
            zone.Text = r.Data.CurrentZone
            r:ListenToChange({'CurrentZone'}, function(nz) 
                zone.Text = nz
                local orig = UDim2.new(0,300,0,50)
                zone:TweenSize(UDim2.new(0,360,0,60),'Out','Back',0.2,true,function() zone:TweenSize(orig,'In','Quad',0.2) end)
            end)
        end
    end)
end
function HUDController:KnitInit() ReplicaController.RequestData() end
return HUDController
