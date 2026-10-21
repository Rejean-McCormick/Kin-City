--!strict
-- Intensité des éclairages artificiels des huit institutions à 65 %.
-- Aucun changement au soleil / à Lighting global / aux lampadaires extérieurs.
local InteriorLighting={}
local FACTOR=0.65
function InteriorLighting.apply(model:Instance):number
    local count=0
    for _,item in ipairs(model:GetDescendants()) do
        if item:IsA("PointLight") or item:IsA("SpotLight") or item:IsA("SurfaceLight") then
            local original=item:GetAttribute("KinInteriorOriginalBrightness")
            if typeof(original)~="number" then
                original=item.Brightness
                item:SetAttribute("KinInteriorOriginalBrightness",original)
            end
            item.Brightness=original*FACTOR
            count+=1
        end
    end
    model:SetAttribute("KinInteriorLightingFactor",FACTOR)
    model:SetAttribute("KinInteriorLightsAdjusted",count)
    return count
end
return InteriorLighting
