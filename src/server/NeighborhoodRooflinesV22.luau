--!strict
-- 24 maisons habitées : géométrie de toit sarcelle, lucarnes opalines, faîtages par quartier.
-- Ne touche pas aux volumes porteurs, escaliers ni aux ouvertures des bâtiments visitables.
local Studio=require(script.Parent.ArtisanGeometryV22)
local Kit=require(script.Parent.CrystalKit)
local Roof={}
local function palette(style)
    if style=="culture" then return "gold" end
    if style=="atelier" then return "medium" end
    if style=="collectif" then return "opal" end
    return "deep"
end
function Roof.make(parent,base,width,depth,height,style,seed)
    local folder=Instance.new("Folder")
    folder.Name="Toiture minérale v22"
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    folder.Parent=parent
    local tint=palette(style)
    local peak=if seed%3==0 then 4.2 elseif seed%3==1 then 3.2 else 5.0
    -- Bande sculptée uniquement au BORD AVANT. Les plantations situées derrière restent visibles.
    for _,s in ipairs({-1,1}) do
        Studio.wedge(folder,"Aile de toiture",Vector3.new(width*0.46,peak,depth*0.18),
            base*CFrame.new(s*width*0.245,height+peak*0.5,-depth*0.4)*CFrame.Angles(0,if s>0 then math.pi else 0,0),
            if s==1 then tint else "deep",true)
    end
    Studio.part(folder,"Ligne de faîtage",Vector3.new(width*0.9,0.55,0.6),
        base*CFrame.new(0,height+peak,-depth*0.4),"gold",Enum.Material.Metal,false)
    local count=if Kit.profile=="LITE" then 1 else 3
    for k=1,count do
        local x=(k-(count+1)/2)*6.0
        Studio.part(folder,"Panneau de lucarne",Vector3.new(3.6,1.9,0.23),
            base*CFrame.new(x,height+peak*0.65,-depth*0.33),"opal",Enum.Material.Slate,true)
        Studio.part(folder,"Traverse de lucarne",Vector3.new(3.8,0.21,0.36),
            base*CFrame.new(x,height+peak*0.68,-depth*0.35),"gold",Enum.Material.Metal,true)
    end
    -- Les petites gemmes indiquent le district, mais elles ne sont ni un téléporteur ni un terminal.
    for _,x in ipairs({-width*0.40,width*0.40}) do
        Studio.facet(folder,"Clef de quartier",base*CFrame.new(x,height+0.1,-depth*0.38),0.7,
            if Kit.profile=="LITE" then 2 else 3.6,"opal",true)
    end
    return folder
end
return Roof
