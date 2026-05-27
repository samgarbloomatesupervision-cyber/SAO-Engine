local GitHubFetcher = require(script:WaitForChild("GitHubFetcher"))
local GitHubImporter = require(script:WaitForChild("GitHubImporter"))
local GitHubRegistry = require(script:WaitForChild("GitHubRegistry"))
local Analyzer = require(script:WaitForChild("Analyzer"))
local Classifier = require(script:WaitForChild("Classifier"))
local MetaGenerator = require(script:WaitForChild("MetaGenerator"))
local AssetRegistry = require(script:WaitForChild("AssetRegistry"))

local Integrations = script:WaitForChild("Integrations")
local OrionBridge = require(Integrations:WaitForChild("OrionBridge"))
local HeliosBridge = require(Integrations:WaitForChild("HeliosBridge"))
local TitanBridge = require(Integrations:WaitForChild("TitanBridge"))
local AuroraBridge = require(Integrations:WaitForChild("AuroraBridge"))
local CardinalBridge = require(Integrations:WaitForChild("CardinalBridge"))

local Atlas = {}

function Atlas.ProcessGitHubAsset(url, targetPosition, query)
    print("----------------------------------------")
    print("🤖 ATLAS GITHUB : Downloading -> " .. url)
    
    local fileData = GitHubFetcher.FetchFile(url)
    if not fileData then return nil end
    fileData.Query = query
    
    local model = GitHubImporter.ImportModel(fileData)
    if not model then return nil end
    
    local analysis = Analyzer.Analyze(model)
    local category, subType = Classifier.Classify(analysis)
    local meta = MetaGenerator.Generate(analysis, category, subType)
    
    AssetRegistry.Register(meta)
    
    OrionBridge.Integrate(meta, model)
    HeliosBridge.Integrate(meta, model)
    TitanBridge.Integrate(meta, model)
    AuroraBridge.Integrate(meta, model)
    CardinalBridge.Integrate(meta, model)
    
    if targetPosition then
        local worldFolder = game:GetService("Workspace"):FindFirstChild("World")
        if model:IsA("Model") then
            model:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        elseif model:IsA("BasePart") then
            model.CFrame = CFrame.new(targetPosition)
        end
        if worldFolder then model.Parent = worldFolder end
    end
    
    print("✅ ATLAS GITHUB : Asset successfully integrated!")
    print("----------------------------------------")
    return meta
end

function Atlas.ProcessPack(query)
    local packs = GitHubRegistry.FindPack(query)
    if not packs then
        warn("⚠️ ATLAS : No packs found for " .. query)
        return
    end

    print("📦 ATLAS : Processing Pack collection for " .. query)
    for _, pack in ipairs(packs) do
        Atlas.ProcessGitHubAsset(pack.Url .. "/main/Model.obj", nil, query)
    end
end

function Atlas.ProcessQuery(query, nameOverride, targetPosition)
    local dummyUrl = "https://raw.githubusercontent.com/SAO-Engine/Assets/main/" .. query:gsub(" ", "_") .. ".obj"
    return Atlas.ProcessGitHubAsset(dummyUrl, targetPosition, query)
end

return Atlas