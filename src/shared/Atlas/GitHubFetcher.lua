local GitHubFetcher = {}
local HttpService = game:GetService("HttpService")

local PROXY_URL = "http://localhost:3000/import"

function GitHubFetcher.FetchFile(url, assetName, assetType)
    print("[ATLAS GITHUB] Requesting Proxy to fetch and upload: " .. url)
    
    local payload = {
        url = url,
        name = assetName or url:match("([^/]+)$") or "UnknownAsset",
        assetType = assetType or "Model" -- "Model", "MeshPart", "Decal"
    }
    
    local success, response = pcall(function()
        return HttpService:PostAsync(
            PROXY_URL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success and response then
        local data = HttpService:JSONDecode(response)
        if data.success then
            print("[ATLAS GITHUB] Proxy successfully uploaded asset to Open Cloud!")
            -- data.data contains the Open Cloud Operation ID or Asset ID
            return {
                Url = url,
                FileName = payload.name,
                OperationData = data.data
            }
        else
            warn("[ATLAS GITHUB] Proxy returned an error: " .. tostring(data.error))
            return nil
        end
    else
        warn("[ATLAS GITHUB] Failed to connect to Atlas Proxy at " .. PROXY_URL .. ". Is the Node.js server running?")
        return nil
    end
end

function GitHubFetcher.FetchFolder(url)
    warn("FetchFolder via Proxy not fully implemented yet.")
    return {}
end

function GitHubFetcher.FetchRelease(repo, tag)
    warn("FetchRelease via Proxy not fully implemented yet.")
    return {}
end

return GitHubFetcher