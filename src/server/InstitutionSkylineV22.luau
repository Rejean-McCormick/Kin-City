--!strict
-- Silhouettes fonctionnelles sur les TOITS existants : pas de second bâtiment ni de fermeture de porte.
local Studio=require(script.Parent.ArtisanGeometryV22)
local Kit=require(script.Parent.CrystalKit)
local Skyline={}
local variants={city_hall="civic",ekoh_tower="knowledge",library="archive",campus="orbit",
    justice_palace="balance",innovation_lab="mechanism",museum="art",orgo_center="network"}
function Skyline.make(model,structure,building)
    local place=building.interior_place_key
    local role=variants[place] or "civic"
    local w,d=table.unpack(structure.footprint_studs)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local h=structure.height_studs
    local frame=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local roof=frame*CFrame.new(0,h+0.8,0)
    local gallery=Instance.new("Folder")
    gallery.Name="Silhouette cristalline v22 — "..role
    gallery:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    gallery.Parent=model
    local width=math.min(w-12,34)
    local depth=math.min(d-12,25)
    -- Gabarit de toiture reculé : jamais devant la porte d'entrée.
    for _,side in ipairs({-1,1}) do
        Studio.part(gallery,"Couronnement sarcelle",Vector3.new(width*0.38,0.65,2),
            roof*CFrame.new(side*width*0.3,0,depth*0.2),"deep",Enum.Material.Slate,false)
        Studio.facet(gallery,"Pointe de couronne",roof*CFrame.new(side*width*0.37,0.3,depth*0.2),
            1.25,if Kit.profile=="LITE" then 4.6 else 6.5,"opal",true)
    end
    Studio.part(gallery,"Bandeau de faîtage",Vector3.new(width*0.8,0.42,1),
        roof*CFrame.new(0,1,-depth*0.24),"gold",Enum.Material.Metal,false)
    if role=="civic" then
        Studio.facet(gallery,"Flèche du conseil",roof*CFrame.new(0,0,0),3,16,"opal",false)
        for _,side in ipairs({-1,1}) do
            Studio.part(gallery,"Voûte civique",Vector3.new(3.2,8,2.5),roof*CFrame.new(side*9,4,0),"medium",Enum.Material.Slate,true)
        end
    elseif role=="knowledge" then
        for i=1,5 do
            local a=i*math.pi*2/5
            Studio.facet(gallery,"Constellation du savoir",roof*CFrame.new(math.sin(a)*9,0,math.cos(a)*7),1.5,5.5+i*1.2,
                if i%2==0 then "gold" else "opal",true)
        end
    elseif role=="archive" then
        for i=-2,2 do
            Studio.wedge(gallery,"Livre de pierre",Vector3.new(3,7+math.abs(i)*1.4,3),
                roof*CFrame.new(i*4,4,0)*CFrame.Angles(0,0,0.11*i),
                if i%2==0 then "medium" else "opal",true)
        end
    elseif role=="orbit" then
        for i=1,12 do
            local a=2*math.pi*i/12
            Studio.orb(gallery,"Étoile d'observatoire",if i%3==0 then 1.45 else 0.8,
                roof*CFrame.new(math.sin(a)*10,8+math.cos(a)*4,math.cos(a)*7),
                if i%2==0 then "gold" else "opal",true)
        end
        Studio.facet(gallery,"Observatoire",roof*CFrame.new(0,0,0),2.4,12,"medium",false)
    elseif role=="balance" then
        Studio.facet(gallery,"Axe d'équilibre",roof*CFrame.new(0,0,0),1.6,12,"opal",false)
        Studio.beam(gallery,"Traverse du droit",(roof*CFrame.new(-11,11,0)).Position,
            (roof*CFrame.new(11,11,0)).Position,0.85,"gold",false)
        for _,side in ipairs({-1,1}) do
            Studio.facet(gallery,"Plateau de pierre",roof*CFrame.new(side*11,0,0),2.3,6,"medium",true)
        end
    elseif role=="mechanism" then
        Studio.facet(gallery,"Noyau d'invention",roof*CFrame.new(0,0,0),3.1,10,"opal",false)
        for i=1,6 do
            local a=i*math.pi/3
            Studio.wedge(gallery,"Aube géométrique",Vector3.new(2.5,8,1.1),
                roof*CFrame.new(math.sin(a)*7.3,6,math.cos(a)*5.7)*CFrame.Angles(0,a,0),"gold",true)
        end
    elseif role=="art" then
        for i=-1,1 do
            Studio.facet(gallery,"Prisme des arts",roof*CFrame.new(i*7,0,(i%2)*3),2.8,10+i*3,
                if i==0 then "opal" else "gold",false)
        end
    elseif role=="network" then
        for _,x in ipairs({-9,9}) do
            for _,z in ipairs({-5,5}) do
                Studio.facet(gallery,"Nœud de réseau",roof*CFrame.new(x,0,z),1.6,8,"opal",true)
            end
        end
        for _,z in ipairs({-5,5}) do
            Studio.beam(gallery,"Réseau aérien",(roof*CFrame.new(-9,8,z)).Position,
                (roof*CFrame.new(9,8,z)).Position,0.46,"gold",true)
        end
    end
    return gallery
end
return Skyline
