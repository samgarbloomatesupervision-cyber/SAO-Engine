local Analyzer = {}

function Analyzer.AnalyzeDependencies(manifest)
    print("[HERMES] Analyzer: Mapping dependency graph...")
    local dependencyMap = {}
    
    local allItems = {}
    for _, s in ipairs(manifest.Services) do table.insert(allItems, s) end
    for _, c in ipairs(manifest.Controllers) do table.insert(allItems, c) end
    for _, m in ipairs(manifest.SharedModules) do table.insert(allItems, m) end

    for _, item in ipairs(allItems) do
        local deps = { DependsOn = {}, UsedBy = {} }
        local source = ""
        pcall(function() source = item.Instance.Source end)

        -- Basic heuristic: look for require() or GetService() calls in source
        local patterns = {
            "require%(.*%.(%w+)%)",
            "GetService%(\"(%w+)\"%)"
        }

        for _, pattern in ipairs(patterns) do
            for match in source:gmatch(pattern) do
                if match ~= item.Name and not table.find(deps.DependsOn, match) then
                    table.insert(deps.DependsOn, match)
                end
            end
        end
        
        dependencyMap[item.Name] = deps
    end

    return dependencyMap
end

return Analyzer