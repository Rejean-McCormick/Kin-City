--!strict
-- Identité structurelle v17 : formes cristallines asymétriques, fronton et toiture.
local Kit=require(script.Parent.CrystalKit)
local Facades={}
function Facades.make(model,structure,building,_style)
    local place=building.interior_place_key
    local cx,cy,cz=table.unpack(structure.center_studs)
    local width,depth=table.unpack(structure.footprint_studs)
    local height=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local front=-depth/2-3
    local accent=Kit.accent(place)
    local root=Instance.new("Folder")
    root.Name="Architecture sarcelle + cristal v17"
    root.Parent=model
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v17")
    -- Rythme vertical lisible, la porte à x=0 reste dégagée.
    for _,side in ipairs({-1,1}) do
        local x=side*math.min(width*0.35,27)
        local post=Kit.part(root,"Part","Contrefort sarcelle",Vector3.new(1.45,math.max(13,height*0.6),1.35),
            base*CFrame.new(x,math.max(13,height*0.6)/2,front+1.2),Kit.primary,Enum.Material.Slate)
        local jewelBase=base*CFrame.new(x,height*0.66,front-0.45)
        Kit.spire(root,"Cristal d'arcature",jewelBase,1.5,6.5,{accent=accent})
        Kit.spire(root,"Cristal de la corniche",base*CFrame.new(x*0.84,height+0.5,-depth*0.18),1.9,9,{accent=accent})
    end
    Kit.band(root,"Bandeau sarcelle supérieur",base,math.max(12,width-8),height*0.80,front+1.25,Kit.primary)
    Kit.rosette(root,"Rosace minérale",base*CFrame.new(0,math.max(17,height*0.74),front-0.05),4.7,accent,8)
    -- Un cristal majeur par toiture. Basse opacité uniquement sur cette pièce maîtresse.
    Kit.spire(root,"Couronne du bâtiment",base*CFrame.new(0,height+1.0,depth*0.17),3.2,16,
        {accent=accent,metal=Kit.primary,hero=true})
    -- Poutre d'identité : sarcelle sur fond pierre, conserve le lettrage d'origine.
    local sig=Kit.part(root,"Part","Bordure d'identité",Vector3.new(math.min(width-10,35),0.35,0.5),
        base*CFrame.new(0,math.min(height-3,15.8),front+0.65),Kit.gold,Enum.Material.Metal)
    return root
end
return Facades
