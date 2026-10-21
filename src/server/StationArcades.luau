--!strict
-- V14 · 8 boutiques-ateliers au flanc de la gare des Connexions.
-- Bâtiments en géométrie native, ouverts physiquement, sans transactions fictives.
local RS=game:GetService("ReplicatedStorage")
local Registry=require(RS:WaitForChild("KinCityShared"):WaitForChild("UrbanV14Destinations"))
local F=require(script.Parent.Factory)
local CrystalEverydayV19=require(script.Parent.CrystalEverydayV19)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local Arcade={}
local P={limestone=Color3.fromRGB(229,216,187),wood=Color3.fromRGB(152,105,70),ink=Color3.fromRGB(30,104,100),glass=Color3.fromRGB(197,244,240),gold=Color3.fromRGB(231,194,124)}
local function part(parent,name,base,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function seat(parent,base,x,z)
    local s=Instance.new("Seat")
    s.Name="Siège de l'atelier";s.Size=Vector3.new(2.2,0.7,2.2)
    s.CFrame=base*CFrame.new(x,1.5,z);s.Anchored=true
    s.Material=Enum.Material.Wood;s.Color=P.wood;s.Parent=parent
    part(parent,"Dossier du siège",base,x,2.6,z+1,2.4,2,0.35,P.ink,Enum.Material.Wood)
end
local function shelf(parent,base,x,z,tint,seed)
    part(parent,"Bibliothèque de présentation",base,x,3.4,z,4.3,5.1,1.4,P.wood,Enum.Material.Wood)
    for row=1,3 do
        part(parent,"Tablette",base,x,1.65+row*1.1,z-0.9,4.5,0.20,2,P.gold,Enum.Material.WoodPlanks,false)
        for n=1,4 do
            local color=if (n+row+seed)%2==0 then tint else P.gold
            local item=part(parent,"Collection d'atelier",base,x-1.6+(n-1)*1.05,2.0+(row-1)*1.15,z-1.08,0.78,0.85,0.65,color,Enum.Material.Fabric,false)
            if (n+row+seed)%3==0 then item.Shape=Enum.PartType.Ball end
        end
    end
end
local function plant(parent,base,x,z)
    part(parent,"Jardinière",base,x,1,z,2.3,1.5,2.3,P.wood,Enum.Material.Wood)
    for i=1,4 do
        local bud=part(parent,"Feuillage",base,x+(i-2.5)*0.48,2.7,z,1,2.1,1.0,Color3.fromRGB(75+i*12,154,97),Enum.Material.Grass,false)
        bud.Shape=Enum.PartType.Ball
    end
end
local function display(parent,base,data,tint)
    local model=Instance.new("Model")
    model.Name="Exposition animable · "..data.kind
    model:SetAttribute("KinArcadeDisplayId",data.id)
    model.Parent=parent
    local pivot=part(model,"Pivot mobile",base,0,4.8,3.1,0.3,0.3,0.3,P.gold,Enum.Material.Metal,false)
    pivot.Transparency=1;model.PrimaryPart=pivot
    local shaft=part(model,"Axe",base,0,4.8,3.1,0.6,5.8,0.6,P.gold,Enum.Material.Metal,false)
    for i=1,5 do
        local theta=i*2*math.pi/5
        local p=part(model,"Objet cinétique",base,math.cos(theta)*2.3,4.8,3.1+math.sin(theta)*2.3,1.3,1.3,1.3,if i%2==0 then tint else P.gold,Enum.Material.Neon,false)
        p.Shape=if data.kind=="clock" then Enum.PartType.Cylinder else Enum.PartType.Ball
    end
    local light=Instance.new("PointLight")
    light.Range=17;light.Brightness=0.6;light.Parent=shaft
    local command=part(parent,"Commande de démonstration",base,-4.5,2,-1.2,2.6,3.3,1.8,P.ink,Enum.Material.Metal)
    command:SetAttribute("KinArcadeAction","animate")
    command:SetAttribute("KinArcadeId",data.id)
    F.prompt(command,"Animer",data.title)
end
local function store(parent,data)
    local m=Instance.new("Model");m.Name=data.title;m.Parent=parent
    m:SetAttribute("KinArcadeId",data.id)
    local cf=CFrame.new(data.center_studs[1],0,data.center_studs[3])*CFrame.Angles(0,data.yaw,0)
    local tint=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
    part(m,"Dallage accessible",cf,0,0.15,0,18,0.5,18,P.limestone,Enum.Material.Marble)
    -- Entrée centrale ouverte de 8 studs côté gare.
    part(m,"Façade gauche",cf,-6.25,5.3,-9,5.5,10.5,0.65,P.ink,Enum.Material.Brick)
    part(m,"Façade droite",cf,6.25,5.3,-9,5.5,10.5,0.65,P.ink,Enum.Material.Brick)
    part(m,"Linteau d'entrée",cf,0,9.4,-9,7.7,2.3,0.7,P.gold,Enum.Material.Metal)
    part(m,"Mur arrière",cf,0,5.3,9,18,10.5,0.75,P.ink,Enum.Material.Brick)
    for _,x in ipairs({-9,9}) do
        part(m,"Mur latéral",cf,x,5.3,0,0.75,10.5,18,P.ink,Enum.Material.Brick)
        local glass=part(m,"Grande vitrine latérale",cf,x+(if x>0 then 0.5 else -0.5),6,0,0.1,5,8,P.glass,Enum.Material.Glass,false)
        OpalGlazingV22.apply(glass,false)
    end
    part(m,"Toit à lanterneaux",cf,0,11.5,0,19.2,0.8,20,tint,Enum.Material.Slate)
    for _,z in ipairs({-3,3}) do
        local g=part(m,"Verrière",cf,0,12,z,7,0.1,3.5,P.glass,Enum.Material.Glass,false)
        OpalGlazingV22.apply(g,true)
    end
    for _,x in ipairs({-6.5,6.5}) do
        shelf(m,cf,x,4,tint,if x<0 then 1 else 2)
        plant(m,cf,x,-5.2)
    end
    part(m,"Table de présentation",cf,0,1.85,2.8,5.8,1.1,4.8,P.wood,Enum.Material.WoodPlanks)
    seat(m,cf,5.4,-2.7)
    display(m,cf,data,tint)
    local terminal=part(m,"Terminal des fonctions futures",cf,4.4,2.4,6.8,2.2,4,1.8,P.ink,Enum.Material.Metal)
    terminal:SetAttribute("KinStubInteractionId",data.id..".terminal")
    terminal:SetAttribute("KinStubCapabilityId","future.station.arcade")
    terminal:SetAttribute("KinStubTitle",data.title)
    F.prompt(terminal,"Consulter","Fonctionnalité à venir")
    local board=F.sign(m,"Enseigne",(cf*CFrame.new(0,14.15,-10.85)).Position,math.deg(data.yaw),data.title,18.8,3.45)
    board.CanCollide=false
    CrystalEverydayV19.frame(m,cf,18,18,11.5,"station-atelier")
    SecondaryArchitectureV25.arcade(m,cf,#data.id,tint)
    return m
end
function Arcade.isReserved(x,z)
    -- Évite les arbres et les kiosques intempestifs autour des façades.
    return math.abs(x)>48 and math.abs(x)<84 and z>=70 and z<=168
end
function Arcade.make(city)
    local root=F.folder(city,"Galeries de la gare - huit ateliers")
    for _,data in ipairs(Registry.arcades) do store(root,data) end
    for _,side in ipairs({-1,1}) do
        local x=side*50.5
        part(root,"Promenade des galeries",CFrame.new(),x,0.15,115.5,5.6,0.4,85,P.limestone,Enum.Material.Cobblestone)
        for n=1,7 do
            local z=75+n*10
            local stem=part(root,"Lampadaire d'arcade",CFrame.new(),side*49,4,z,0.4,8,0.4,P.ink,Enum.Material.Metal)
            stem.CanCollide=false
            local lamp=part(root,"Orbe de galerie",CFrame.new(),side*49,8,z,1.7,1.7,1.7,P.gold,Enum.Material.Neon,false)
            lamp.Shape=Enum.PartType.Ball
            local light=Instance.new("PointLight");light.Range=18;light.Brightness=1;light.Parent=lamp
        end
    end
    root:SetAttribute("KinArcadesBuilt",#Registry.arcades)
    return root
end
return Arcade
