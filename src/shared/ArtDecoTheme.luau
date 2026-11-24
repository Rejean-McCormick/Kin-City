--!strict
-- Neutral architecture shared across every sector. Accents come from HexagonalDistricts.
local Districts=require(script.Parent.HexagonalDistricts)
return {
    stone=Color3.fromRGB(232,226,213),
    dark=Color3.fromRGB(32,60,64),
    teal=Districts.base,
    bronze=Color3.fromRGB(179,148,96),
    glazing=Color3.fromRGB(143,197,197),
    light=Color3.fromRGB(229,215,175),
}
