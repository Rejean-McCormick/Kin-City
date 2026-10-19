--!strict
-- Traitement cohérent et économique des vitrages répétés.
-- Les verres partiellement transparents se superposent : ici l'opale est d'abord opaque.
local Kit=require(script.Parent.CrystalKit)
local Glass={}
function Glass.apply(part:BasePart,hero:boolean)
    part.Color=Kit.opal
    if Kit.profile=="SHOWCASE" and hero then
        part.Material=Enum.Material.Glass
        part.Transparency=0.28
        part.Reflectance=0.025
    else
        part.Material=Enum.Material.SmoothPlastic
        part.Transparency=0
        part.Reflectance=0.07
    end
    part.CanCollide=false
    part.CanTouch=false
    part.CanQuery=false
    part.CastShadow=false
    part:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    return part
end
return Glass
