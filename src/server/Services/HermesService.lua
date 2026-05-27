local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages:WaitForChild("Knit"))

local HermesService = Knit.CreateService {
    Name = "HermesService",
    Client = {},
}

local Modules = script.Parent:WaitForChild("Modules")
local Scanner = require(Modules:WaitForChild("Scanner"))
local Analyzer = require(Modules:WaitForChild("Analyzer"))
local DocGenerator = require(Modules:WaitForChild("DocGenerator"))
local GraphBuilder = require(Modules:WaitForChild("GraphBuilder"))
local ReportGenerator = require(Modules:WaitForChild("ReportGenerator"))
local ChangeTracker = require(Modules:WaitForChild("ChangeTracker"))

function HermesService:KnitStart()
    print("========================================")
    print("📜 HERMES V10 : ARCHITECT MASTER ONLINE")
    print("========================================")
    
    -- Auto-run first documentation cycle
    task.delay(5, function()
        self:RunDocumentationCycle()
    end)
end

function HermesService:RunDocumentationCycle()
    print("[HERMES] Starting full documentation cycle...")
    
    local manifest = Scanner.ScanProject()
    local deps = Analyzer.AnalyzeDependencies(manifest)
    
    -- 1. Generate Visual Graph (Console)
    local graph = GraphBuilder.BuildDependencyGraph(deps)
    print(graph)
    
    -- 2. Track Changes
    ChangeTracker.TrackSnapshot(manifest)
    
    -- 3. Generate Health Report
    local health = ReportGenerator.GenerateHealthReport(manifest, deps)
    print(ReportGenerator.Format(health))
    
    -- 4. Markdown Generation (Ready for GitHub export)
    local markdown = DocGenerator.GenerateMarkdown(manifest, deps)
    -- In v10, this can be sent to a Custom Admin UI or Webhook
    
    print("[HERMES] Documentation cycle complete.")
    return markdown
end

return HermesService