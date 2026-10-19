--!strict
-- Motifs sarcelle/opale pour les maisons et ateliers EXISTANTS.
-- Une grammaire courte : cadre, ligne de toiture, clef cristalline.
-- N'affecte pas les ouvertures et n'ajoute pas de physique.
local Kit=require(script.Parent.CrystalKit)
local Everyday={}
local function item(parent,name,cf,size,color,optional)
    local p=Kit.part(parent,"Part",name,size,cf,color,Enum.Material.Metal)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
function Everyday.frame(model,base,width,depth,roofHeight,variant)
    local folder=Instance.new("Folder")
    folder.Name="Habillage opalin — v19"
    folder.Parent=model
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    local entrance=-depth/2-0.95
    local pillars=math.min(width*0.34,7)
    local doorHeight=math.min(roofHeight-2,9)
    -- Bordure disjointe de la porte, laisse le passage central libre.
    for _,side in ipairs({-1,1}) do
        item(folder,"Jambage minéral",base*CFrame.new(side*pillars,doorHeight/2,entrance),
            Vector3.new(0.4,doorHeight,0.32),Kit.primary,false)
        item(folder,"Chemin de lumière",base*CFrame.new(side*pillars,doorHeight*0.6,entrance-0.21),
            Vector3.new(0.12,doorHeight*0.6,0.1),Kit.opal,true)
    end
    item(folder,"Traverse supérieure",base*CFrame.new(0,doorHeight,entrance),
        Vector3.new(pillars*2+0.4,0.4,0.45),Kit.gold,false)
    item(folder,"Liseré de toiture",base*CFrame.new(0,roofHeight-0.45,entrance+0.7),
        Vector3.new(math.max(9,width-1.5),0.36,0.46),Kit.primary,true)
    -- Clef de voûte dans le bandeau, non sur le passage.
    local key=item(folder,"Clef opaline",base*CFrame.new(0,doorHeight+0.35,entrance-0.25),
        Vector3.new(0.95,0.95,0.3),Kit.opal,false)
    key.CFrame=key.CFrame*CFrame.Angles(0,0,math.pi/4)
    if Kit.profile~="LITE" then
        for _,side in ipairs({-1,1}) do
            item(folder,"Trame horizontale",base*CFrame.new(side*(width*0.34),roofHeight*0.77,entrance+0.45),
                Vector3.new(math.max(1.2,width*0.16),0.24,0.3),Kit.gold,true)
        end
    end
    folder:SetAttribute("KinDecorationRole",variant or "everyday")
    return folder
end
return Everyday
