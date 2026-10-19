--!strict
-- Espaces thématiques dans les grands atriums : réserves, ateliers, documentation.
-- Les activités en stub possèdent leurs futurs IDs ; les sièges sont utilisables.
local F=require(script.Parent.Factory)
local Specialized={}
local INK=Color3.fromRGB(37,63,76)
local GOLD=Color3.fromRGB(189,148,90)
local WOOD=Color3.fromRGB(130,91,64)
local STONE=Color3.fromRGB(220,208,186)
local topics={
    library={"Atelier de reliure","Bibliothèque des archives",Color3.fromRGB(131,175,200)},
    campus={"Station des sciences","Atelier des mathématiques",Color3.fromRGB(192,163,219)},
    justice_palace={"Salle de médiation","Archives juridiques",Color3.fromRGB(206,172,122)},
    city_hall={"Forum des citoyens","Maquette des quartiers",Color3.fromRGB(222,181,111)},
    ekoh_tower={"Cartographie des connaissances","Galerie des méthodes",Color3.fromRGB(124,217,205)},
    innovation_lab={"Atelier de prototypes","Station d'énergie",Color3.fromRGB(110,206,212)},
    museum={"Conservation des œuvres","Atelier des artistes",Color3.fromRGB(231,162,153)},
    orgo_center={"Atelier de coordination","Réseau des opérations",Color3.fromRGB(140,186,220)},
}
local function block(parent,name,base,x,y,z,size,color,material,solid)
    local p=F.part(parent,name,size,base*CFrame.new(x,y,z),color,material)
    if solid==false then p.CanCollide=false end
    return p
end
local function seat(parent,base,x,z)
    local v=Instance.new("Seat")
    v.Name="Siège d'apprentissage"
    v.Anchored=true
    v.Size=Vector3.new(3,0.7,3)
    v.CFrame=base*CFrame.new(x,1.5,z)
    v.Color=INK
    v.Material=Enum.Material.Fabric
    v.Parent=parent
    block(parent,"Dossier",base,x,2.7,z+1.2,Vector3.new(3,2.2,0.5),GOLD,Enum.Material.Metal,true)
end
local function furnish(parent,origin,x,z,section,key,index,accent)
    local base=CFrame.new(origin+Vector3.new(x,0,z))
    local m=Instance.new("Model")
    m.Name=section
    m.Parent=parent
    block(m,"Tapis d'étude",base,0,0.1,0,Vector3.new(16,0.18,15),STONE,Enum.Material.Fabric,false)
    for i=1,3 do
        local bx=(i-2)*4.5
        block(m,"Table d'atelier",base,bx,2.65,1.4,Vector3.new(3.9,0.55,4.2),WOOD,Enum.Material.WoodPlanks,true)
        block(m,"Socle d'atelier",base,bx,1.2,1.4,Vector3.new(0.6,2.4,2.8),INK,Enum.Material.Metal,true)
        block(m,"Échantillon à explorer",base,bx,3.35,1.4,Vector3.new(1.5,1.3,1.5),accent,Enum.Material.Glass,false)
        seat(m,base,bx,-3.3)
    end
    for _,cx in ipairs({-7,7}) do
        block(m,"Rayonnage latéral",base,cx,5.5,5.0,Vector3.new(1.4,10,3.2),WOOD,Enum.Material.WoodPlanks,true)
        for yy=2,8,2 do
            block(m,"Plaque de collection",base,cx,yy,2.9,Vector3.new(1.1,1.2,0.16),accent,Enum.Material.Metal,false)
        end
    end
    local kiosk=block(m,"Terminal documentaire",base,0,2.5,6.8,Vector3.new(3.4,4.6,1.7),INK,Enum.Material.Metal,true)
    block(m,"Écran documentaire",base,0,3.2,5.8,Vector3.new(2.8,2.4,0.16),accent,Enum.Material.Neon,false)
    kiosk:SetAttribute("KinStubInteractionId",string.format("atrium.%s.%02d",key,index))
    kiosk:SetAttribute("KinStubCapabilityId","future."..key..".specialization")
    kiosk:SetAttribute("KinStubTitle",section)
    F.prompt(kiosk,"Découvrir",section)
    return m
end
function Specialized.make(model,key,origin)
    local topic=topics[key]
    if not topic then return nil end
    local section=F.folder(model,"Espaces spécialisés de l'atrium")
    -- Les collections existantes occupent le fond à z=68 ; ces niches sont latérales.
    furnish(section,origin,-23,86,topic[1],key,1,topic[3])
    furnish(section,origin,23,86,topic[2],key,2,topic[3])
    return section
end
return Specialized
