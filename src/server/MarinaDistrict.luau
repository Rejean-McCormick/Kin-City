--!strict
-- V9 : deux vraies marinas, quatre ateliers couverts visitables sans téléportation,
-- phares, petits jardins de sel, kiosques et quais d'observation. 100% natif.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("MarinaDestinations"))
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local Marina={}
local HULL=Color3.fromRGB(30,104,100)
local WOOD=Color3.fromRGB(163,116,77)
local SAND=Color3.fromRGB(224,211,179)
local BRASS=Color3.fromRGB(230,184,111)
local GLASS=Color3.fromRGB(197,244,240)
local function part(parent,name,base,x,y,z,w,h,d,color,material,collide)
    local p=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if collide==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function ball(parent,name,base,x,y,z,diam,color,material)
    local p=part(parent,name,base,x,y,z,diam,diam,diam,color,material,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function seat(parent,base,x,z)
    local p=Instance.new("Seat")
    p.Name="Siège de marina";p.Size=Vector3.new(4.5,0.9,2.2)
    p.Anchored=true;p.Material=Enum.Material.WoodPlanks;p.Color=WOOD
    p.CFrame=base*CFrame.new(x,1.45,z);p.Parent=parent
    part(parent,"Dossier de siège",base,x,2.5,z+1.1,4.5,2.0,0.4,HULL,Enum.Material.Wood)
end
local function workshop(parent,base,x,theme,index)
    local localBase=base*CFrame.new(x,0,-30)
    local m=Instance.new("Model");m.Name=theme.." — atelier visitable";m.Parent=parent
    m:SetAttribute("KinMarinaWorkshop",theme)
    part(m,"Sol de l'atelier",localBase,0,1.15,0,22,0.45,25,SAND,Enum.Material.WoodPlanks)
    part(m,"Mur arrière",localBase,0,6.0,-12,22,9.8,0.7,HULL,Enum.Material.Wood)
    -- Façade ouverte en deux pans : entrée de 8 studs réellement franchissable.
    for _,xx in ipairs({-8,8}) do
        part(m,"Façade ouverte",localBase,xx,6,12,6,9.8,0.7,HULL,Enum.Material.Wood)
        local glass=part(m,"Fenêtre d'atelier",localBase,xx,7.7,12.4,3,2.9,0.18,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(glass,false)
    end
    for _,xx in ipairs({-10.7,10.7}) do
        part(m,"Mur latéral",localBase,xx,6,0,0.7,9.8,24,HULL,Enum.Material.Wood)
    end
    part(m,"Poutre d'auvent",localBase,0,11.4,0,24,0.8,27,BRASS,Enum.Material.Wood)
    part(m,"Toiture inclinée ouest",localBase,-5.7,12.5,0,12.4,0.7,28,Color3.fromRGB(103,132,130),Enum.Material.Slate,false)
    part(m,"Toiture inclinée est",localBase,5.7,12.5,0,12.4,0.7,28,Color3.fromRGB(103,132,130),Enum.Material.Slate,false)
    part(m,"Table de fabrication",localBase,0,2.9,-4,9,1.2,4,WOOD,Enum.Material.WoodPlanks)
    for col=1,4 do
        local xx=(col-2.5)*3.8
        local item=part(m,"Objet d'atelier "..col,localBase,xx,4.1,-4,1.9,1.5,1.9,
            if index==1 then GLASS else BRASS,if index==1 then Enum.Material.Glass else Enum.Material.Metal,false)
        if index==1 then item.Shape=Enum.PartType.Ball end
    end
    for level=1,3 do
        part(m,"Étagère de rangement",localBase,-8.7,2.1+level*2.2,-6,2,0.4,10,WOOD,Enum.Material.Wood)
    end
    part(m,"Comptoir d'accueil",localBase,7,2.1,6,5,2.2,2.5,BRASS,Enum.Material.Wood)
    seat(m,localBase,4,1)
    local screen=part(m,"Borne de service futur",localBase,7.0,4.1,5.5,1.7,2.2,0.45,GLASS,Enum.Material.Glass,false)
    screen:SetAttribute("KinStubInteractionId",string.format("%s.workshop.%d.future",parent:GetAttribute("KinMarinaId"),index))
    screen:SetAttribute("KinStubCapabilityId","future.marina.workshop")
    screen:SetAttribute("KinStubTitle",theme)
    F.prompt(screen,"Consulter","Fonctionnalité à venir")
    SecondaryArchitectureV25.marina(m,localBase,index)
    return m
end
local function makeMarina(root,item,index)
    local radial=Vector3.new(math.cos(item.angle),0,math.sin(item.angle))
    local base=CFrame.lookAt(radial*item.radius,radial*(item.radius+1))
    local m=Instance.new("Model");m.Name=item.title;m.Parent=root
    m:SetAttribute("KinMarinaId",item.id)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    -- Débarcadère qui commence à l'intérieur de la côte r=480 et atteint le lac.
    part(m,"Promenade d'accès",base,0,0.88,-30,12,0.85,99,WOOD,Enum.Material.WoodPlanks)
    part(m,"Esplanade sur pilotis",base,0,0.88,-29,89,0.85,58,SAND,Enum.Material.WoodPlanks)
    part(m,"Brise-lames principal",base,0,0.88,-84,13,0.85,53,WOOD,Enum.Material.WoodPlanks)
    for _,xx in ipairs({-41,41}) do
        for _,zz in ipairs({-50,-35,-18,-6}) do
            part(m,"Pilotis portuaire",base,xx,-2.2,zz,1.8,7.6,1.8,HULL,Enum.Material.Metal)
        end
        part(m,"Garde-corps",base,xx,2.4,-29,0.55,1.8,54,BRASS,Enum.Material.Metal,false)
    end
    for _,xx in ipairs({-25,25}) do
        part(m,"Liaison aux ateliers",base,xx,0.88,0,11,0.85,19,WOOD,Enum.Material.WoodPlanks)
    end
    workshop(m,base,-26,if index==1 then "Atelier des courants" else "Atelier du bois flotté",1)
    workshop(m,base,26,if index==1 then "Cabinet du lac" else "Atelier des voiles",2)
    for _,xx in ipairs({-34,34}) do
        seat(m,base,xx,-47)
        for _,zz in ipairs({-3,-51}) do
            local lamp=ball(m,"Boule d'amarrage",base,xx,4.6,zz,1.4,tint,Enum.Material.Neon)
            local light=Instance.new("PointLight");light.Brightness=0.4;light.Range=16;light.Parent=lamp
            part(m,"Mât d'amarrage",base,xx,2.7,zz,0.8,4,0.8,HULL,Enum.Material.Metal)
        end
    end
    -- Phare sur un plateau distinct du passage central.
    part(m,"Plateau du phare",base,19,0.95,-93,25,0.7,25,SAND,Enum.Material.Cobblestone)
    for level=1,3 do
        part(m,"Tour du phare niveau "..level,base,19,4.4+(level-1)*7,-93,7-level*0.5,7,7-level*0.5,HULL,Enum.Material.Metal)
        part(m,"Corniche phare",base,19,8.1+(level-1)*7,-93,8,0.5,8,BRASS,Enum.Material.Metal,false)
    end
    local beacon=ball(m,"Lentille du phare",base,19,26.5,-93,5,GLASS,Enum.Material.Neon)
    beacon:SetAttribute("KinMarinaLightLens",item.id)
    local rotating=part(m,"Faisceau maritime",base,19,26.5,-102,1.8,1.8,16,tint,Enum.Material.Neon,false)
    rotating.Transparency=0.25;rotating:SetAttribute("KinMarinaBeam",item.id)
    local switch=part(m,"Commande du phare",base,9,2.7,-87,2.5,4.1,2.5,HULL,Enum.Material.Metal)
    switch:SetAttribute("KinMarinaAction","beacon")
    switch:SetAttribute("KinMarinaId",item.id)
    F.prompt(switch,"Allumer / éteindre","Phare de la marina")
    -- Grue de port dynamique (rotation locale de la poutre, pas de simulation physique).
    part(m,"Socle de grue",base,-20,2.5,-79,8,3,8,HULL,Enum.Material.Metal)
    part(m,"Pylône de grue",base,-20,11,-79,1.8,16,1.8,HULL,Enum.Material.Metal)
    local arm=part(m,"Bras mobile de grue",base,-20,20,-88,1.6,1.2,21,BRASS,Enum.Material.Metal,false)
    arm:SetAttribute("KinMarinaCraneArm",item.id)
    local craneSwitch=part(m,"Commande de grue",base,-9,2.6,-74,2.3,3.7,2.3,HULL,Enum.Material.Metal)
    craneSwitch:SetAttribute("KinMarinaAction","crane")
    craneSwitch:SetAttribute("KinMarinaId",item.id)
    F.prompt(craneSwitch,"Déplacer la grue","Atelier maritime")
    local collectible=part(m,"Borne carnet maritime",base,0,2.6,-54,2.8,4.0,2.1,tint,Enum.Material.Metal)
    collectible:SetAttribute("KinMarinaAction","collect")
    collectible:SetAttribute("KinMarinaId",item.id)
    F.prompt(collectible,"Observer le port","Carnet de navigation")
    F.sign(m,"Enseigne maritime",(base*CFrame.new(0,8.1,8)).Position,math.deg(math.pi/2-item.angle),item.title,29,3.8).CanCollide=false
    return m
end
function Marina.make(city)
    local root=F.folder(city,"Marinas et ateliers maritimes")
    for i,item in ipairs(Destinations) do makeMarina(root,item,i) end
    root:SetAttribute("KinMarinas",#Destinations)
    root:SetAttribute("KinWorkshops",#Destinations*2)
    return root
end
return Marina
