local ReportGenerator = {}

function ReportGenerator.GenerateHealthReport(manifest, dependencyMap)
    print("[HERMES] ReportGenerator: Evaluating system health...")
    
    local report = {
        Score = 100,
        Warnings = {},
        Metrics = {
            Services = #manifest.Services,
            Controllers = #manifest.Controllers,
            TotalComplexity = 0
        }
    }
    
    for name, info in pairs(dependencyMap) do
        report.Metrics.TotalComplexity += #info.DependsOn
        if #info.DependsOn > 8 then
            table.insert(report.Warnings, "High Coupling: " .. name .. " has too many dependencies.")
            report.Score -= 5
        end
    end
    
    return report
end

function ReportGenerator.Format(report)
    local lines = {
        "--- 📊 SAO ENGINE HEALTH REPORT ---",
        "Architecture Score: " .. report.Score .. "/100",
        "Total Complexity Index: " .. report.Metrics.TotalComplexity,
        "Services: " .. report.Metrics.Services .. " | Controllers: " .. report.Metrics.Controllers
    }
    
    if #report.Warnings > 0 then
        table.insert(lines, "\n⚠️ WARNINGS:")
        for _, w in ipairs(report.Warnings) do table.insert(lines, "- " .. w) end
    else
        table.insert(lines, "Status: STABLE")
    end
    
    table.insert(lines, "-----------------------------------")
    return table.concat(lines, "\n")
end

return ReportGenerator