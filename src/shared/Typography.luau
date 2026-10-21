--!strict
-- Charte typographique Kin City : Garamond partout, Bodoni en repli.
-- Les deux polices sont des polices natives Roblox; aucun AssetId requis.
local Typography={}

local function resolve(name:string): Enum.Font?
    local ok, value = pcall(function()
        return Enum.Font[name]
    end)
    if ok and value then return value end
    return nil
end

local GARAMOND=resolve("Garamond")
local BODONI=resolve("Bodoni")
local SELECTED=GARAMOND or BODONI or Enum.Font.SourceSans

function Typography.body(): Enum.Font
    return SELECTED
end
function Typography.bold(): Enum.Font
    return SELECTED
end
function Typography.display(): Enum.Font
    return SELECTED
end
function Typography.fallback(): Enum.Font
    return BODONI or SELECTED
end
return Typography
