local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local InteractionService = Knit.CreateService {
    Name = "InteractionService",
    Client = {},
}

function InteractionService:KnitStart()
    print("InteractionService: Initialized")
    
    -- Global handler for ProximityPrompts
    game:GetService("ProximityPromptService").PromptTriggered:Connect(function(prompt, player)
        self:ProcessInteraction(prompt, player)
    end)
end

function InteractionService:ProcessInteraction(prompt, player)
    local action = prompt:GetAttribute("Action")
    local target = prompt.Parent
    
    if action == "Loot" then
        self:HandleLoot(player, target)
    elseif action == "Talk" then
        self:HandleDialogue(player, target)
    end
end

function InteractionService:HandleLoot(player, item)
    local DataService = Knit.GetService("DataService")
    local profile = DataService:GetProfile(player)
    
    if profile then
        local cols = item:GetAttribute("Cols") or 0
        local xp = item:GetAttribute("XP") or 0
        
        profile.Data.Cols = (profile.Data.Cols or 0) + cols
        profile.Data.XP = (profile.Data.XP or 0) + xp
        
        -- Update replica to sync with client
        local replica = DataService:GetReplica(player)
        if replica then
            replica:Set({"Cols"}, profile.Data.Cols)
            replica:Set({"XP"}, profile.Data.XP)
        end
        
        print(player.Name .. " collected " .. cols .. " Cols and " .. xp .. " XP")
    end
    
    item:Destroy()
end

function InteractionService:HandleDialogue(player, npc)
    print(player.Name .. " is talking to " .. npc.Name)
    -- Trigger client-side dialogue UI
    self.Client.OnDialogueTriggered:Fire(player, npc)
end

function InteractionService:KnitInit()
    self.Client.OnDialogueTriggered = Knit.CreateSignal()
end

return InteractionService
