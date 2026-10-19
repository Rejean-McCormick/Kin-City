--!strict
-- Un luminaire sculptural par pièce, au lieu de trois sphères de verre identiques.
-- Réutilise l'éclairage existant : aucune PointLight/SpotLight supplémentaire.
local Kit=require(script.Parent.CrystalKit)
local Studio=require(script.Parent.ArtisanGeometryV22)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Luminaires={}
local roles={city_hall="civic",ekoh_tower="knowledge",library="archive",campus="orbit",
    justice_palace="balance",innovation_lab="mechanism",museum="art",orgo_center="network"}
function Luminaires.decorate(parent,room,origin,placeKey,index)
    local cx,_,cz=table.unpack(room.center_studs)
    local role=roles[placeKey] or "civic"
    local root=Instance.new("Folder")
    root.Name="Luminaire minéral v23"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v23")
    root.Parent=parent
    local base=CFrame.new(origin+Vector3.new(cx,12.9,cz))
    Studio.part(root,"Tige de suspension",Vector3.new(0.24,3.1,0.24),base*CFrame.new(0,2.1,0),"gold",Enum.Material.Metal,false)
    Studio.part(root,"Couronne suspendue",Vector3.new(5.8,0.44,5.8),base,"deep",Enum.Material.Slate,false)
    Studio.part(root,"Plafonnier opalin",Vector3.new(4.8,0.3,4.8),base*CFrame.new(0,-0.4,0),"opal",Enum.Material.Slate,false)
    Meshes.decorate(root,"Prisme de lustre", "opal_chandelier",Vector3.new(3.2,2.7,3.2),base*CFrame.new(0,-1.0,0),Kit.opal)
    if Kit.profile~="LITE" then
        local count=if Kit.profile=="SHOWCASE" then 8 else 5
        for i=1,count do
            local a=i*2*math.pi/count
            local r=2.45
            local p=Studio.part(root,"Pendeloque cristalline",Vector3.new(0.52,1.55+(i%2)*0.35,0.52),
                base*CFrame.new(math.cos(a)*r,-1.4,math.sin(a)*r)*CFrame.Angles(0,a,math.rad((i%2)*13)),
                if i%3==0 then "gold" else "opal",Enum.Material.Slate,true)
            p:SetAttribute("KinDecorRole",role)
        end
    end
    if role=="orbit" or role=="knowledge" then
        local dot=Studio.orb(root,"Astrolabe central",1.35,base*CFrame.new(0,-1.4,0),"gold",true)
    elseif role=="archive" or role=="balance" then
        Studio.part(root,"Carreau axial",Vector3.new(1.0,2.0,1.0),base*CFrame.new(0,-1.4,0),"medium",Enum.Material.Slate,true)
    elseif role=="art" or role=="mechanism" then
        Studio.wedge(root,"Fragment central",Vector3.new(1.8,1.5,0.8),base*CFrame.new(0,-1.1,0)*CFrame.Angles(0,0.6,0),"gold",true)
    end
    return root
end
return Luminaires
