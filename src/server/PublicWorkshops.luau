--!strict
-- V14 · Six ateliers en plein air à 3 étapes, visibles depuis les agoras.
-- La manipulation d'objets est réelle; aucune note, récompense ou requête kOA.
local RS=game:GetService("ReplicatedStorage")
local Registry=require(RS:WaitForChild("KinCityShared"):WaitForChild("UrbanV14Destinations"))
local F=require(script.Parent.Factory)
local Workshop={}
local STONE=Color3.fromRGB(219,211,184)
local INK=Color3.fromRGB(30,104,100)
local GOLD=Color3.fromRGB(233,195,117)
local WOOD=Color3.fromRGB(148,106,73)
local function part(parent,name,base,x,y,z,w,h,d,color,material,solid)
    local obj=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false end
    return obj
end
local function one(parent,data)
    local root=Instance.new("Model")
    root.Name=data.title;root.Parent=parent
    root:SetAttribute("KinWorkshopId",data.id)
    local base=CFrame.new(data.center_studs[1],0,data.center_studs[3])*CFrame.Angles(0,data.yaw,0)
    local accent=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
    part(root,"Parvis accessible",base,0,0.1,0,24,0.4,28,STONE,Enum.Material.Cobblestone)
    -- Raccord au parvis civique (centre de l'agora 43 studs vers +X).
    part(root,"Raccord piétonnier",base,18,0.1,-3,18,0.3,5,STONE,Enum.Material.Cobblestone)
    for _,x in ipairs({-10,10}) do
        for _,z in ipairs({-11,11}) do
            part(root,"Pilier de l'atelier",base,x,5.5,z,0.85,11,0.85,INK,Enum.Material.Metal)
        end
    end
    for _,z in ipairs({-11,11}) do
        part(root,"Poutre ouverte",base,0,11,z,21,0.5,0.5,GOLD,Enum.Material.Metal,false)
    end
    for n=-2,2 do
        part(root,"Lattis de pergola",base,n*4.1,11.8,0,0.55,0.35,23,WOOD,Enum.Material.WoodPlanks,false)
    end
    local machine=Instance.new("Model")
    machine.Name="Machine pédagogique activable";machine.Parent=root
    machine:SetAttribute("KinWorkshopMachine",data.id)
    local pivot=part(machine,"Pivot central",base,0,4.7,5,0.25,0.25,0.25,GOLD,Enum.Material.Metal,false)
    machine.PrimaryPart=pivot;pivot.Transparency=1
    local core=part(machine,"Cœur expérimental",base,0,4.7,5,4,4,4,accent,Enum.Material.Neon,false)
    core:SetAttribute("KinWorkshopCore",data.id)
    core.Shape=Enum.PartType.Ball
    local light=Instance.new("PointLight")
    light.Brightness=0.35;light.Range=14;light.Parent=core
    for i=1,6 do
        local angle=(i/6)*2*math.pi
        local bead=part(machine,"Orbiteur mécanique",base,math.cos(angle)*3.1,4.7,5+math.sin(angle)*3.1,1.2,1.2,1.2,GOLD,Enum.Material.Neon,false)
        bead.Shape=Enum.PartType.Ball
    end
    local stages={"1 · ASSEMBLER","2 · CALIBRER","3 · ANIMER"}
    for step=1,3 do
        local x=-7+(step-1)*7
        local console=part(root,"Console d'expérience "..step,base,x,1.95,-6,3.4,3.4,2.5,INK,Enum.Material.Metal)
        console:SetAttribute("KinWorkshopId",data.id)
        console:SetAttribute("KinWorkshopStep",step)
        F.prompt(console,stages[step],data.title)
        local screen=part(root,"Voyant étape "..step,base,x,4.15,-6.3,1.4,1.4,1.4,Color3.fromRGB(94,124,136),Enum.Material.Neon,false)
        screen.Shape=Enum.PartType.Ball
        screen:SetAttribute("KinWorkshopIndicator",data.id)
        screen:SetAttribute("KinWorkshopIndicatorStep",step)
    end
    for _,x in ipairs({-8,8}) do
        local seat=Instance.new("Seat")
        seat.Name="Banc de l'atelier";seat.Size=Vector3.new(3.2,0.8,2.4)
        seat.Anchored=true;seat.Color=WOOD;seat.Material=Enum.Material.WoodPlanks
        seat.CFrame=base*CFrame.new(x,1.6,9.6);seat.Parent=root
    end
    local s=F.sign(root,"Instructions",(base*CFrame.new(0,10,-13)).Position,math.deg(data.yaw),data.title.." · 3 ÉTAPES",22,2.5)
    s.CanCollide=false
    -- Le terminal métier est distinct des 3 mécanismes locaux qui fonctionnent.
    local future=part(root,"Terminal futur",base,9,2.3,2.3,2.7,4,1.9,INK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",data.id..".future")
    future:SetAttribute("KinStubCapabilityId","future.public.workshops")
    future:SetAttribute("KinStubTitle",data.title)
    F.prompt(future,"Consulter","Fonctionnalité à venir")
    return root
end
function Workshop.isReserved(x,z)
    for _,data in ipairs(Registry.workshops) do
        local base=CFrame.new(data.center_studs[1],0,data.center_studs[3])*CFrame.Angles(0,data.yaw,0)
        local p=base:PointToObjectSpace(Vector3.new(x,0,z))
        if math.abs(p.X)<17 and math.abs(p.Z)<19 then return true end
    end
    return false
end
function Workshop.make(city)
    local folder=F.folder(city,"Ateliers pedagogiques en trois etapes")
    for _,data in ipairs(Registry.workshops) do one(folder,data) end
    folder:SetAttribute("KinWorkshopCount",#Registry.workshops)
    return folder
end
return Workshop
