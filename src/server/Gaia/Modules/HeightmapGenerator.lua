local HeightmapGenerator = {}

local SEED = math.random(1, 1000000)

function HeightmapGenerator.GetHeight(x, z, scale, amplitude)
    scale = scale or 50
    amplitude = amplitude or 20
    
    local noise = math.noise(x / scale, z / scale, SEED)
    return noise * amplitude
end

return HeightmapGenerator
