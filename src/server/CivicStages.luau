--!strict
-- Six places de quartier : amphithéâtres, scènes, jeux de jardin, éclairage
-- et mobiles activables. Géométrie native, durable en mode édition.
local RS=game:GetService("ReplicatedStorage")
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("CivicDestinations"))
local F=require(script.Parent.Factory)
local Stages={}
local STONE=Color3.fromRGB(217,211,182)
local DARK=Color3.fromRGB(30,104,100)
local WOOD=Color3.fromRGB(142,108,79)
local GOLD=Color3.fromRGB(223,186,112)
local GREEN=Color3.fromRGB(89,139,99)
local function p(root,label,cf,x,y,z,w,h,d,color,mat,solid)
    local o=F.part(root,label,Vector3.new(w,h,d),cf*CFrame.new(x,y,z),color,mat)
    if solid==false then o.CanCollide=false;o.CanTouch=false;o.CanQuery=false end
    return o
end
local function lighting(root,cf,x,y,z,id,color)
    local bulb=p(root,"Orbe d'ambiance",cf,x,y,z,1.3,1.3,1.3,color,Enum.Material.Neon,false)
    bulb.Shape=Enum.PartType.Ball
    bulb:SetAttribute("KinCivicLamp",id)
    local light=Instance.new("PointLight")
    light.Brightness=1.1;light.Range=20;light.Parent=bulb
end
local function planting(root,cf,x,z,seed)
    p(root,"Bac de plantation",cf,x,1.1,z,5,1.4,3.3,WOOD,Enum.Material.WoodPlanks)
    for n=1,3 do
        local stalk=p(root,"Feuilles publiques",cf,x+(n-2)*1.2,3.4,z,2.5+(seed%2),2.9,2.5,GREEN,Enum.Material.Grass,false)
        stalk.Shape=Enum.PartType.Ball
    end
end
local function bench(root,cf,x,z)
    local s=Instance.new("Seat")
    s.Name="Banc de l'agora";s.Size=Vector3.new(4.5,0.8,2.2)
    s.CFrame=cf*CFrame.new(x,1.8,z);s.Anchored=true;s.Material=Enum.Material.WoodPlanks;s.Color=WOOD;s.Parent=root
    p(root,"Dossier",cf,x,2.7,z+1,4.6,1.7,0.4,DARK,Enum.Material.Wood)
end
local function buildOne(parent,item)
    local m=Instance.new("Model");m.Name=item.title;m.Parent=parent
    m:SetAttribute("KinCivicStageId",item.id)
    local center=Vector3.new(item.center_studs[1],0,item.center_studs[3])
    local cf=CFrame.new(center)*CFrame.Angles(0,item.yaw,0)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    p(m,"Dallage place publique",cf,0,0.05,0,44,0.55,48,STONE,Enum.Material.Cobblestone)
    p(m,"Scène culturelle",cf,0,1.35,13,23,2.4,13,WOOD,Enum.Material.WoodPlanks)
    p(m,"Fond de scène",cf,0,5.7,19,24,8.3,0.7,DARK,Enum.Material.Slate)
    p(m,"Auvent scène",cf,0,11.2,13,26,0.7,16,tint,Enum.Material.Fabric,false)
    for _,side in ipairs({-1,1}) do
        for _,zz in ipairs({7,18}) do
            p(m,"Structure scène",cf,side*12.4,5.7,zz,0.7,10.7,0.7,GOLD,Enum.Material.Metal)
        end
        for n=1,3 do
            bench(m,cf,side*8,-16+(n-1)*5.6)
        end
        planting(m,cf,side*18,if side==1 then 10 else -9,side)
    end
    -- Amphithéâtre bas avec entrée centrale libre et éclairage public.
    for row=1,3 do
        for _,side in ipairs({-1,1}) do
            local zz=2-(row-1)*6
            p(m,"Gradin communautaire",cf,side*11,0.65,zz,15,0.7,3.8,STONE,Enum.Material.Cobblestone)
        end
    end
    for i=1,8 do
        local a=i*math.pi/4
        local x=math.cos(a)*19
        local z=math.sin(a)*20
        lighting(m,cf,x,7.2,z,item.id,tint)
        p(m,"Mât de lumière",cf,x,3.5,z,0.6,6.5,0.6,DARK,Enum.Material.Metal)
    end
    -- Grand mobile identitaire et projection lumineuse visible depuis la promenade.
    local art=Instance.new("Model")
    art.Name="Mobile cinétique — "..item.theme
    art.Parent=m
    art:SetAttribute("KinCivicArt",item.id)
    local pivot=p(art,"Pivot",cf,0,4.3,12,0.3,0.3,0.3,GOLD,Enum.Material.Metal,false)
    pivot.Transparency=1;art.PrimaryPart=pivot
    local rail=p(art,"Anneau lumineux",cf,0,6.3,12,7,0.7,7,tint,Enum.Material.Neon,false)
    rail.Shape=Enum.PartType.Cylinder
    for k=1,5 do
        local a=k*math.pi*2/5
        local x=math.cos(a)*3.0
        local z=12+math.sin(a)*3.0
        local bead=p(art,"Éclat en orbite",cf,x,6.3,z,1.5,1.5,1.5,if k%2==0 then GOLD else tint,Enum.Material.Neon,false)
        bead.Shape=Enum.PartType.Ball
    end
    -- Commandes physiques distinctes pour les deux actions réelles.
    local lampSwitch=p(m,"Console lumières",cf,-14,2.1,-18,2.7,3.8,2.0,DARK,Enum.Material.Metal)
    lampSwitch:SetAttribute("KinCivicAction","lights")
    lampSwitch:SetAttribute("KinCivicStageId",item.id)
    F.prompt(lampSwitch,"Allumer / éteindre",item.activity)
    local mobileSwitch=p(m,"Console sculpture",cf,14,2.1,-18,2.7,3.8,2.0,DARK,Enum.Material.Metal)
    mobileSwitch:SetAttribute("KinCivicAction","mobile")
    mobileSwitch:SetAttribute("KinCivicStageId",item.id)
    F.prompt(mobileSwitch,"Faire tourner",item.activity)
    -- Toute fonction métier future reste explicite et inchangée.
    local future=p(m,"Borne de la communauté",cf,16,2.1,16,2.8,4,2.0,DARK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",item.id..".future")
    future:SetAttribute("KinStubCapabilityId","future.public.engagement")
    future:SetAttribute("KinStubTitle",item.title)
    F.prompt(future,"Consulter","Fonction à venir")
    -- Pancarte orientée dans le repère de l'îlot.
    local sign=F.sign(m,"Nom de l'agora",(cf*CFrame.new(0,6,-24)).Position,math.deg(item.yaw),item.title,29,3.5)
    sign.CanCollide=false
    return m
end
function Stages.isReserved(x,z)
    for _,item in ipairs(Destinations) do
        local dx=x-item.center_studs[1]
        local dz=z-item.center_studs[3]
        if dx*dx+dz*dz<37*37 then return true end
    end
    return false
end
function Stages.make(city)
    local root=F.folder(city,"Agoras et scènes des quartiers")
    for _,item in ipairs(Destinations) do buildOne(root,item) end
    root:SetAttribute("KinCivicStages",#Destinations)
    return root
end
return Stages
