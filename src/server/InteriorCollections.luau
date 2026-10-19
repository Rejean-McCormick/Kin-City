--!strict
-- Kin City v4 : collections architecturales thématiques natives, sans assets distants.
-- Les objets se trouvent près des murs latéraux afin de préserver la circulation.
local F = require(script.Parent.Factory)
local Collection = {}

local INK=Color3.fromRGB(32,54,63)
local GOLD=Color3.fromRGB(194,151,86)
local IVORY=Color3.fromRGB(229,217,189)
local WOOD=Color3.fromRGB(116,78,56)
local GLASS=Color3.fromRGB(110,193,208)

local function p(parent,name,cf,size,color,mat,solid)
    local q=F.part(parent,name,size,cf,color,mat or Enum.Material.SmoothPlastic)
    if solid==false then q.CanCollide=false; q.CastShadow=false end
    return q
end
local function box(parent,name,base,x,y,z,sx,sy,sz,color,mat,solid)
    return p(parent,name,base*CFrame.new(x,y,z),Vector3.new(sx,sy,sz),color,mat,solid)
end
local function orb(parent,name,base,x,y,z,s,clr)
    local q=box(parent,name,base,x,y,z,s,s,s,clr,Enum.Material.Glass,false)
    q.Shape=Enum.PartType.Ball
    return q
end
local function exhibitPrompt(part,key,title,index)
    part:SetAttribute("KinStubInteractionId",key..".collection."..index)
    part:SetAttribute("KinStubCapabilityId","future."..key..".collection")
    part:SetAttribute("KinStubTitle",title)
    F.prompt(part,"Explorer",title)
end
local function tablet(parent,base,x,z,title,key,index,accent)
    local pod=box(parent,"Borne de consultation",base,x,2.35,z,5.2,4.7,2.8,INK,Enum.Material.Metal,true)
    box(parent,"Écran de consultation",base,x,3.3,z-1.48,4.2,2.25,0.2,accent,Enum.Material.Neon,false)
    box(parent,"Tablette de contrôle",base,x,1.15,z-1.7,4.4,0.28,0.8,GOLD,Enum.Material.Metal,false)
    exhibitPrompt(pod,key,title,index)
end
local function bookcase(parent,base,x,z,accent,seed)
    box(parent,"Bibliothèque en chêne",base,x,5.1,z,10.3,10.2,2.25,WOOD,Enum.Material.WoodPlanks,true)
    for level=1,4 do
        box(parent,"Rayon renforcé",base,x,1.9+level*1.8,z-0.8,10,0.25,2.1,accent,Enum.Material.Metal,false)
        for j=1,10 do
            local shade=Color3.fromHSV(((seed+j*11+level*17)%101)/101,0.25+0.08*(j%3),0.68)
            box(parent,"Ouvrage relié",base,x-4.6+j*0.85,1.05+level*1.8,z-1.14,0.55,1.3+(j%3)*0.12,0.8,shade,Enum.Material.Fabric,false)
        end
    end
end
local function hallScreen(parent,base,x,z,accent,title)
    box(parent,"Panneau numérique",base,x,7.4,z,14,8,0.7,INK,Enum.Material.Metal,false)
    box(parent,"Affichage lumineux",base,x,7.4,z-0.43,12.4,6.5,0.16,accent,Enum.Material.Neon,false)
    F.sign(parent,"Titre écran",(base*CFrame.new(x,7.4,z-0.6)).Position,0,title,11.3,3.2).CanCollide=false
end
local function workstation(parent,base,x,z,accent)
    box(parent,"Bureau",base,x,2.5,z,11,0.6,4.6,WOOD,Enum.Material.WoodPlanks,true)
    for _,side in ipairs({-1,1}) do
        box(parent,"Piètement",base,x+side*4,1.25,z,0.55,2.5,3.7,INK,Enum.Material.Metal,true)
    end
    box(parent,"Écran informatique",base,x,4.2,z+0.75,5.6,3,0.4,INK,Enum.Material.Metal,true)
    box(parent,"Interface",base,x,4.2,z+0.47,4.9,2.4,0.08,accent,Enum.Material.Neon,false)
    box(parent,"Clavier",base,x,2.86,z-1.25,4.4,0.12,1.1,IVORY,Enum.Material.SmoothPlastic,false)
    box(parent,"Siège",base,x,1,z-5.2,3.2,2,2.8,INK,Enum.Material.Fabric,true)
end
local function artWall(parent,base,x,z,accent,variant)
    box(parent,"Cadre du patrimoine",base,x,8.2,z,9,7,0.65,GOLD,Enum.Material.Metal,false)
    box(parent,"Œuvre encadrée",base,x,8.2,z-0.43,7.9,5.8,0.15,Color3.fromHSV(variant*0.16%1,0.42,0.68),Enum.Material.SmoothPlastic,false)
    orb(parent,"Relief artistique",base,x,8.2,z-0.78,3,accent)
end
local function laboratory(parent,base,x,z,accent)
    box(parent,"Paillasse scientifique",base,x,2.45,z,12,0.65,4.2,IVORY,Enum.Material.Marble,true)
    for n=1,4 do
        local xx=x-4.5+n*2
        local stand=box(parent,"Éprouvette",base,xx,4,z,0.9,2.6,0.9,GLASS,Enum.Material.Glass,false)
        stand.Transparency=0.35
        local light=orb(parent,"Échantillon",base,xx,5.4,z,1.1,accent)
        light.Material=Enum.Material.Neon
    end
    box(parent,"Microscope",base,x+4.5,4.1,z-0.4,1.4,3,1.6,INK,Enum.Material.Metal,false)
end
local function justice(parent,base,x,z,accent)
    box(parent,"Banc du conseil",base,x,2.1,z,13,4.2,2.7,WOOD,Enum.Material.WoodPlanks,true)
    for n=1,3 do
        box(parent,"Dossier du tribunal",base,x+(n-2)*4,4.9,z+0.6,3.3,2.8,0.5,accent,Enum.Material.Fabric,false)
    end
    box(parent,"Registre",base,x,4.45,z-0.8,4.2,0.3,3,IVORY,Enum.Material.Fabric,false)
end
local function cityHall(parent,base,x,z,accent)
    box(parent,"Table citoyenne",base,x,2.2,z,12,0.5,6,GOLD,Enum.Material.WoodPlanks,true)
    for j=-2,2 do
        box(parent,"Dossier de projet",base,x+j*2.1,2.55,z,1.5,0.15,2.1,IVORY,Enum.Material.Fabric,false)
    end
    orb(parent,"Modèle symbolique du conseil",base,x,5.2,z,3.2,accent)
end
local function ekoh(parent,base,x,z,accent)
    for i=1,5 do
        box(parent,"Panneau de savoir",base,x-5+i*1.8,1.8+i*0.5,z,1.1,3.5+i*0.5,2.4,accent,Enum.Material.Neon,false)
    end
    box(parent,"Socle du mérite",base,x,1,z-4,9,2,1.8,INK,Enum.Material.Metal,true)
end
local function archive(parent,base,x,z,accent)
    for j=1,3 do
        box(parent,"Casier du réseau",base,x+(j-2)*3,4.4,z,2.6,6.8,2.8,INK,Enum.Material.Metal,true)
        box(parent,"Indicateur",base,x+(j-2)*3,5.5,z-1.5,1.8,1.2,0.14,accent,Enum.Material.Neon,false)
    end
end
local renderers={
    library=function(parent,base,x,z,accent,index) bookcase(parent,base,x,z,accent,index) end,
    campus=function(parent,base,x,z,accent,index) laboratory(parent,base,x,z,accent) end,
    justice_palace=function(parent,base,x,z,accent,index) justice(parent,base,x,z,accent) end,
    city_hall=function(parent,base,x,z,accent,index) cityHall(parent,base,x,z,accent) end,
    ekoh_tower=function(parent,base,x,z,accent,index) ekoh(parent,base,x,z,accent) end,
    innovation_lab=function(parent,base,x,z,accent,index) laboratory(parent,base,x,z,accent) end,
    museum=function(parent,base,x,z,accent,index) artWall(parent,base,x,z,accent,index) end,
    orgo_center=function(parent,base,x,z,accent,index) archive(parent,base,x,z,accent) end,
}
local titles={
    library="Catalogue des savoirs",campus="Parcours d'apprentissage",justice_palace="Registre de médiation",
    city_hall="Projets citoyens",ekoh_tower="Cartographie de l'expertise",innovation_lab="Projets et inventions",
    museum="Collection culturelle",orgo_center="Tableau des services",
}
function Collection.make(parent,key,room,origin,style,index)
    local x,_,z=table.unpack(room.center_studs)
    local width,_,depth=table.unpack(room.size_studs)
    local base=CFrame.new(origin+Vector3.new(x,0,z))
    local accent=F.hex(style.palette.accent)
    local folder=F.folder(parent,"Collections thématiques")
    -- Deux dispositifs placés à proximité du mur arrière, hors axe principal.
    local stationX=math.max(12,math.min(width*0.24,19))
    local backZ=math.min(depth/2-7,depth*0.24)
    local build=renderers[key]
    if build then
        build(folder,base,-stationX,backZ,accent,index)
        if width>=48 then build(folder,base,stationX,backZ,accent,index+3) end
    end
    -- Une borne explicite reste attachée à un objet physique. Le prompt est routé au serveur.
    local frontZ=-math.min(depth*0.18,7)
    tablet(folder,base,stationX,frontZ,titles[key] or "Centre de découverte",key.."."..room.room_id,index,accent)
    if index==1 and width>38 then
        hallScreen(folder,base,0,depth/2-1.7,accent,string.upper(titles[key] or "KIN CITY"))
    end
    return folder
end
return Collection
