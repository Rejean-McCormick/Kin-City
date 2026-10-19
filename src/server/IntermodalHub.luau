--!strict
-- Gare centrale visitable : grande halle traversante, deux niveaux,
-- escaliers physiques, kiosques, galeries, bornes de correspondance
-- et douze panneaux de retour aux stations des navettes v11.
local RS=game:GetService("ReplicatedStorage")
local Network=require(RS:WaitForChild("KinCityShared"):WaitForChild("IntermodalNetwork"))
local F=require(script.Parent.Factory)
local Hub={}
local C={stone=Color3.fromRGB(222,213,189),steel=Color3.fromRGB(30,104,100),gold=Color3.fromRGB(215,175,107),glass=Color3.fromRGB(197,244,240),wood=Color3.fromRGB(148,107,79),green=Color3.fromRGB(95,147,116)}
local function part(parent,name,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),CFrame.new(x,y,z),color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function seat(parent,x,y,z)
    local s=Instance.new("Seat")
    s.Name="Banquette de la gare";s.Anchored=true
    s.Size=Vector3.new(3.8,0.8,2.7);s.CFrame=CFrame.new(x,y,z)
    s.Material=Enum.Material.WoodPlanks;s.Color=C.wood;s.Parent=parent
    part(parent,"Dossier",x,y+1,z+1.2,3.8,2,0.4,C.steel,Enum.Material.Wood)
end
local function glass(parent,x,y,z,w,h,d)
    local p=part(parent,"Vitrail de la gare",x,y,z,w,h,d,C.glass,Enum.Material.Glass,false)
    p.Transparency=0.36
end
local function orb(parent,name,x,y,z,r,color)
    local p=part(parent,name,x,y,z,r,r,r,color,Enum.Material.Neon,false)
    p.Shape=Enum.PartType.Ball
    local light=Instance.new("PointLight")
    light.Range=18;light.Brightness=0.9;light.Parent=p
    return p
end
local function sign(parent,name,x,y,z,text,w)
    local s=F.sign(parent,name,Vector3.new(x,y,z),0,text,w or 24,3.4)
    s.CanCollide=false
    return s
end
local function stairs(parent,side)
    -- 14 marches pour une galerie à Y=12; 2 stud de profondeur chacune.
    local x=side*30
    for step=1,14 do
        local height=step*0.85
        local z=90+(step-1)*1.85
        part(parent,"Marche de la galerie",x,height/2,z,7,height,1.95,C.stone,Enum.Material.Cobblestone)
        for _,railSide in ipairs({-1,1}) do
            part(parent,"Montant d'escalier",x+railSide*3.7,height+1.4,z,0.3,2.8,0.3,C.steel,Enum.Material.Metal,false)
        end
    end
    -- Palier de liaison : marche 14 arrive à Y=11.9, galerie à Y=12.
    part(parent,"Palier galerie",x,11.85,118,9,0.45,7,C.stone,Enum.Material.Cobblestone)
end
local function shell(root)
    local m=Instance.new("Model");m.Name="Gare centrale des Connexions";m.Parent=root
    m:SetAttribute("KinIntermodalHubId",Network.hub.id)
    local z=114
    part(m,"Parvis gare",0,0.02,79,94,0.3,21,C.stone,Enum.Material.Cobblestone)
    part(m,"Halle - dallage",0,0.14,z,84,0.55,70,C.stone,Enum.Material.Marble)
    part(m,"Promenade traversante nord",0,0.16,156,16,0.34,22,C.stone,Enum.Material.Cobblestone)
    part(m,"Axe piéton depuis la place",0,0.14,65,13,0.3,27,C.stone,Enum.Material.Cobblestone)
    for _,x in ipairs({-42,42}) do
        part(m,"Mur latéral",x,10.1,z,1.2,20,68,C.steel,Enum.Material.Brick)
        for j=1,6 do
            glass(m,x+((x>0) and 0.7 or -0.7),11,84+j*9,0.13,7.5,5.7)
        end
    end
    -- Deux passages ouverts de 15 studs, au sud et au nord, sans porte factice.
    for _,endZ in ipairs({79,149}) do
        for _,side in ipairs({-1,1}) do
            part(m,"Façade de gare",side*24.75,10.3,endZ,34.5,20.2,1,C.steel,Enum.Material.Brick)
            glass(m,side*26,11,endZ+((endZ==79) and -0.6 or 0.6),13,8,0.12)
        end
        part(m,"Linteau central",0,18.0,endZ,16,4.1,1.3,C.gold,Enum.Material.Metal)
    end
    for _,x in ipairs({-39,39}) do
        for _,zz in ipairs({88,107,126,142}) do
            part(m,"Colonne de la nef",x,12,zz,1.5,23,1.5,C.gold,Enum.Material.Marble)
        end
    end
    -- Verrière haute translucide, non bloquante pour le cadrage caméra.
    for i=1,8 do
        local zz=79+i*8.0
        local pane=part(m,"Verrière de la nef",0,25.5,zz,83,0.45,8.5,C.glass,Enum.Material.Glass,false)
        pane.Transparency=0.43
        part(m,"Arceau de verrière",0,25.8,zz-4.3,83,0.6,0.4,C.steel,Enum.Material.Metal,false)
    end
    for _,side in ipairs({-1,1}) do
        part(m,"Galerie haute accessible",side*26,12.0,z,28,0.85,63,C.wood,Enum.Material.WoodPlanks)
        -- Rampe qui empêche la chute sur la nef centrale.
        part(m,"Garde-corps intérieur",side*12.4,15,z,0.5,5,63,C.steel,Enum.Material.Metal)
        for _,zz in ipairs({90,112,135}) do
            glass(m,side*12.1,15.2,zz,0.1,3,13)
        end
        stairs(m,side)
        for _,zz in ipairs({103,130}) do seat(m,side*23,13,zz) end
    end
    -- Pont galerie au nord (la traversée au sol demeure libre).
    part(m,"Passerelle haute",0,12,141,25,0.85,7,C.wood,Enum.Material.WoodPlanks)
    for _,x in ipairs({-12.5,12.5}) do
        part(m,"Console de passerelle",x,14.8,141,0.5,5.2,7,C.gold,Enum.Material.Metal)
    end
    sign(m,"Fronton monumental",0,22,78,"GARE DES CONNEXIONS",42)
    sign(m,"Direction jardin de justice",0,18.3,149,"ETHIKOS  ↑",24)
    sign(m,"Orientation depuis la place",0,5.2,75,"6 LIGNES DE CORRESPONDANCE",36)
    for _,x in ipairs({-9,9}) do
        for _,zz in ipairs({95,118,135}) do
            orb(m,"Luminaire de la nef",x,20,zz,1.6,C.gold)
        end
    end
    -- Café et bibliothèque d'attente : pas de commerce fictif ni économie.
    for _,side in ipairs({-1,1}) do
        local x=side*33
        part(m,"Comptoir d'accueil",x,2.4,142,11,2.8,3.5,C.wood,Enum.Material.WoodPlanks)
        part(m,"Table haute",x,2.2,136,7,1.0,4,C.wood,Enum.Material.WoodPlanks)
        for _,sx in ipairs({-3,3}) do seat(m,x+sx,1.65,131) end
        part(m,"Présentoir de lecture",x,4,145,8,6,1.5,C.steel,Enum.Material.Wood)
        for k=1,7 do
            part(m,"Livres de voyage",x-3.5+k,5,144.1,0.7,2.6,0.7,if k%2==0 then C.gold else C.green,Enum.Material.Fabric,false)
        end
    end
    -- Écrans avec futurs services toujours en stub.
    local terminal=part(m,"Borne information à venir",0,2.6,133,3,4.3,1.7,C.steel,Enum.Material.Metal)
    terminal:SetAttribute("KinStubInteractionId","kin.intermodal.info.future")
    terminal:SetAttribute("KinStubCapabilityId","future.intermodal.information")
    terminal:SetAttribute("KinStubTitle","Informations de la gare")
    F.prompt(terminal,"Consulter","Informations futures")
    return m
end
function Hub.isReserved(x,z)
    -- Empêcher les arbres générés en amont de traverser la nef et ses parvis.
    return math.abs(x)<52 and z>52 and z<164
end
function Hub.make(city)
    local root=F.folder(city,"Gare centrale et correspondances")
    shell(root)
    for i,gate in ipairs(Network.gates) do
        local pos=gate.position_studs
        local x,z=pos[1],pos[3]
        local color=Color3.fromRGB(gate.color[1],gate.color[2],gate.color[3])
        local desk=part(root,"Comptoir de correspondance "..i,x,2.3,z,8.5,3.2,3.2,C.steel,Enum.Material.Metal)
        local band=part(root,"Bande lumineuse de ligne",x,4.2,z-1.5,8.5,0.45,0.2,color,Enum.Material.Neon,false)
        desk:SetAttribute("KinIntermodalTransfer",gate.id)
        desk:SetAttribute("KinIntermodalFrom","hub")
        desk:SetAttribute("KinIntermodalLine",gate.line_id)
        F.prompt(desk,"Rejoindre la station",gate.title)
        sign(root,"Panneau de correspondance "..i,x,7,z-1.9,"LIGNE "..i,8)
        local light=Instance.new("PointLight")
        light.Range=13;light.Brightness=0.7;light.Parent=band
    end
    -- Correspondance retour depuis les 12 stations déjà présentes dans les boulevards.
    for _,ret in ipairs(Network.returns) do
        local x,z=ret.position_studs[1],ret.position_studs[3]
        local color=Color3.fromRGB(ret.color[1],ret.color[2],ret.color[3])
        part(root,"Socle retour",x,0.3,z,5.3,0.4,5.3,C.stone,Enum.Material.Cobblestone)
        local pole=part(root,"Correspondance retour à la gare",x,2.3,z,2.7,3.9,2.7,color,Enum.Material.Metal)
        pole:SetAttribute("KinIntermodalTransfer",ret.id)
        pole:SetAttribute("KinIntermodalFrom","station")
        pole:SetAttribute("KinIntermodalLine",ret.line_id)
        F.prompt(pole,"Retour gare centrale","Correspondance rapide")
        local beam=part(root,"Lumière de station",x,5.4,z,1.3,1.3,1.3,C.gold,Enum.Material.Neon,false)
        beam.Shape=Enum.PartType.Ball
        local p=Instance.new("PointLight");p.Range=15;p.Parent=beam
    end
    root:SetAttribute("KinIntermodalGates",#Network.gates)
    root:SetAttribute("KinIntermodalReturns",#Network.returns)
    return root
end
return Hub
