--!strict
-- Éclairage natif sans texture distante ni bande-son externe.
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local SkyDirector={}
local function singleton(parent,name,class)
    local old=parent:FindFirstChild(name)
    if old and old.ClassName==class then return old end
    if old then old:Destroy() end
    local new=Instance.new(class)
    new.Name=name
    new.Parent=parent
    return new
end
function SkyDirector.configure()
    Lighting.Brightness=2.3
    Lighting.ClockTime=13.8
    Lighting.GlobalShadows=true
    Lighting.EnvironmentDiffuseScale=0.72
    Lighting.EnvironmentSpecularScale=0.75
    Lighting.Ambient=Color3.fromRGB(104,116,121)
    Lighting.OutdoorAmbient=Color3.fromRGB(147,160,158)
    local atmosphere=singleton(Lighting,"KinCityAtmosphere","Atmosphere")
    atmosphere.Density=0.26
    atmosphere.Offset=0.18
    atmosphere.Color=Color3.fromRGB(207,233,229)
    atmosphere.Decay=Color3.fromRGB(116,168,164)
    atmosphere.Glare=0.09
    atmosphere.Haze=1.3
    local correction=singleton(Lighting,"KinCityColor","ColorCorrectionEffect")
    correction.Brightness=0.03
    correction.Contrast=0.08
    correction.Saturation=0.06
    correction.TintColor=Color3.fromRGB(242,252,248)
    local bloom=singleton(Lighting,"KinCityBloom","BloomEffect")
    bloom.Intensity=0.12
    bloom.Size=18
    bloom.Threshold=1.7
    local rays=singleton(Lighting,"KinCitySunRays","SunRaysEffect")
    rays.Intensity=0.035
    rays.Spread=0.75
    local terrain=Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        local clouds=singleton(terrain,"KinCityClouds","Clouds")
        clouds.Cover=0.22
        clouds.Density=0.34
        clouds.Color=Color3.fromRGB(243,247,247)
    end
end
return SkyDirector
