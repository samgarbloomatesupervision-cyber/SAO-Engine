require("dotenv").config();
const express = require("express");
const axios = require("axios");
const cors = require("cors");
const fs = require("fs");
const path = require("path");
const FormData = require("form-data");

const app = express();
app.use(cors());
app.use(express.json());

const PORT = 3000;
const ROBLOX_API_KEY = process.env.ROBLOX_API_KEY;
const ROBLOX_CREATOR_ID = process.env.ROBLOX_CREATOR_ID; // Can be UserID or GroupID

// Helper: Download file from GitHub
async function downloadFromGitHub(url, destPath) {
    console.log(`[Proxy] Downloading from GitHub: ${url}`);
    const writer = fs.createWriteStream(destPath);
    const response = await axios({
        url,
        method: "GET",
        responseType: "stream"
    });
    
    response.data.pipe(writer);
    return new Promise((resolve, reject) => {
        writer.on("finish", resolve);
        writer.on("error", reject);
    });
}

// Endpoint called by Roblox Studio (Atlas)
app.post("/import", async (req, res) => {
    const { url, name, assetType } = req.body; // assetType: "Model", "Decal", "MeshPart"
    
    if (!url || !ROBLOX_API_KEY) {
        return res.status(400).json({ error: "Missing URL or API Key." });
    }

    try {
        const tempFileName = `temp_${Date.now()}_${path.basename(url)}`;
        const tempFilePath = path.join(__dirname, tempFileName);
        
        // 1. Fetch from GitHub
        await downloadFromGitHub(url, tempFilePath);
        console.log(`[Proxy] File saved to ${tempFilePath}`);
        
        // 2. Prepare Roblox Open Cloud Payload
        // Official Endpoint: https://apis.roblox.com/assets/v1/assets
        const formData = new FormData();
        
        // The payload config required by Open Cloud
        const config = {
            assetType: assetType || "Model",
            displayName: name || "AtlasImportedAsset",
            description: "Automatically imported by SAO-Engine Atlas",
            creationContext: {
                creator: {
                    userId: ROBLOX_CREATOR_ID
                }
            }
        };

        formData.append("request", JSON.stringify(config), { contentType: "application/json" });
        formData.append("fileContent", fs.createReadStream(tempFilePath), { filename: tempFileName });

        console.log(`[Proxy] Uploading to Roblox Open Cloud...`);
        
        // 3. Upload to Roblox
        const robloxRes = await axios.post("https://apis.roblox.com/assets/v1/assets", formData, {
            headers: {
                "x-api-key": ROBLOX_API_KEY,
                ...formData.getHeaders()
            }
        });

        // 4. Cleanup temp file
        fs.unlinkSync(tempFilePath);
        
        // Return Operation ID or Asset ID to Roblox
        // Open Cloud returns an Operation ID that must be polled, but for this proxy,
        // we return the data so Atlas can track it.
        console.log(`[Proxy] Upload successful! Response:`, robloxRes.data);
        res.json({ success: true, data: robloxRes.data });

    } catch (error) {
        console.error("[Proxy] Error during import:", error.response ? error.response.data : error.message);
        res.status(500).json({ error: "Upload failed." });
    }
});

app.listen(PORT, () => {
    console.log(`
======================================================
🤖 ATLAS PROXY SERVER ONLINE 🤖
Listening on http://localhost:${PORT}
Waiting for requests from SAO-Engine...
======================================================
    `);
    if (!ROBLOX_API_KEY) {
        console.warn("⚠️ WARNING: ROBLOX_API_KEY is missing in .env file.");
    }
});
