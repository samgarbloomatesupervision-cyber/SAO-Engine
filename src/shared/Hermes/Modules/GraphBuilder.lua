local GraphBuilder = {}

function GraphBuilder.BuildDependencyGraph(dependencyMap)
    print("[HERMES] GraphBuilder: Generating visual representation...")
    local lines = {"--- PROJECT DEPENDENCY GRAPH ---"}
    
    for name, info in pairs(dependencyMap) do
        if #info.DependsOn > 0 then
            table.insert(lines, string.format("[%s] relies on: %s", name, table.concat(info.DependsOn, ", ")))
        else
            table.insert(lines, string.format("[%s] is an independent Root module.", name))
        end
    end
    
    table.insert(lines, "--------------------------------")
    return table.concat(lines, "\n")
end

return GraphBuilder