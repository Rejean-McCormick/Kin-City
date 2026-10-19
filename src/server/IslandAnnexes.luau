--!strict
-- V9 : six maisons insulaires autonomes, deux salles intérieures chacune,
-- terrasses de toit accessibles par seize marches. Aucune téléportation.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Islands=require(RS:WaitForChild("KinCityShared"):WaitForChild("IslandDestinations"))
local Annex={}
local STONE=Color3.fromRGB(231,222,197)
local DECK=Color3.fromRGB(159,121,86)
local DARK=Color3.fromRGB(42,75,84)
local GOLD=Color3.fromRGB(230,189,115)
local function p(m,name,base,x,y,z,w,h,d,color,material,solid)
    local r=F.part(m,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then r.CanCollide=false;r.CanTouch=false end
    return r
end
local function bulb(m,base,x,y,z,color)
    local lamp=p(m,"Luminaire suspendu",base,x,y,z,1.5,1.5,1.5,color,Enum.Material.Neon,false)
    lamp.Shape=Enum.PartType.Ball
    local light=Instance.new("PointLight");light.Brightness=0.8;light.Range=14;light.Parent=lamp
    lamp:SetAttribute("KinAnnexLamp",true)
    return lamp
end
-- Collections sculptées à partir de primitives et adaptées aux six vocations.
-- Chaque variante occupe le fond de la pièce, hors du passage central.
local function thematicInstallation(m,base,theme,z,clr)
    local focusX=-68
    local focusZ=z-5
    if theme=="gardens" then
        for n=1,6 do
            local xx=focusX+(n%3)*2.1
            local zz=focusZ+math.floor((n-1)/3)*2.6
            p(m,"Bac de jardin botanique",base,xx,2,zz,2.1,1.2,1.7,DECK,Enum.Material.Wood)
            p(m,"Tige de recherche",base,xx,3.7,zz,0.35,2.3,0.35,Color3.fromRGB(90,170,117),Enum.Material.Grass,false)
            local bulb=p(m,"Feuille de serre",base,xx,5,zz,2.1,1.1,1.5,clr,Enum.Material.Grass,false)
            bulb.Shape=Enum.PartType.Ball
        end
    elseif theme=="arts" then
        for n=1,7 do
            local theta=n*2*math.pi/7
            local x=focusX+math.cos(theta)*3.2
            local zz=focusZ+math.sin(theta)*3.2
            local height=2+(n%3)*1.3
            p(m,"Volume d'art abstrait",base,x,2.9+height/2,zz,1.3,height,1.3,
                if n%2==0 then GOLD else clr,Enum.Material.Marble,false)
        end
    elseif theme=="energy" then
        for n=1,5 do
            local theta=n*math.pi*2/5
            local x=focusX+math.cos(theta)*2.8
            local zz=focusZ+math.sin(theta)*2.8
            local blade=p(m,"Aube de dynamo",base,x,5.5,zz,4.8,0.35,0.65,GOLD,Enum.Material.Metal,false)
            blade:SetAttribute("KinAnnexReactive",true)
        end
        p(m,"Socle de turbine",base,focusX,3.2,focusZ,6,1.5,6,DARK,Enum.Material.Metal)
    elseif theme=="stars" then
        local sun=p(m,"Étoile de l'observatoire",base,focusX,6.5,focusZ,3.3,3.3,3.3,GOLD,Enum.Material.Neon,false)
        sun.Shape=Enum.PartType.Ball
        for n=1,5 do
            local theta=n*math.pi*2/5
            local orb=p(m,"Planète de la maquette",base,focusX+math.cos(theta)*3.7,5.8+(n%2),focusZ+math.sin(theta)*3.1,1.0+n%2,1.0+n%2,1.0+n%2,clr,Enum.Material.Glass,false)
            orb.Shape=Enum.PartType.Ball
        end
    elseif theme=="archives" then
        for level=1,3 do
            p(m,"Rayon d'archives",base,focusX,2.0+level*2,focusZ,8,0.35,2,DECK,Enum.Material.WoodPlanks)
            for n=1,8 do
                p(m,"Livre de la mémoire",base,focusX-3.6+n*0.82,2.8+level*2,focusZ,0.55,1.5+(n%3)*0.2,1.2,
                    if n%3==0 then GOLD else clr,Enum.Material.Fabric,false)
            end
        end
    else
        for n=1,6 do
            local theta=n*math.pi/3
            p(m,"Assise de cercle civique",base,focusX+math.cos(theta)*3.2,1.9,focusZ+math.sin(theta)*3.2,2.6,0.8,1.9,DECK,Enum.Material.WoodPlanks)
        end
        p(m,"Table des rencontres",base,focusX,3.0,focusZ,3.8,0.9,3.8,clr,Enum.Material.Marble)
    end
end
local function room(m,base,item,roomId,z,clr)
    local theme=item.kind
    p(m,"Table de médiation",base,-60,2.8,z,11,1.2,4,DECK,Enum.Material.WoodPlanks)
    p(m,"Socle du thème",base,-64,2.4,z-5,4,2.9,4,DARK,Enum.Material.Marble)
    local core=p(m,"Pièce centrale de la salle",base,-64,5.2,z-5,3.2,3.2,3.2,clr,Enum.Material.Neon,false)
    core.Shape=if theme=="stars" or theme=="gardens" then Enum.PartType.Ball else Enum.PartType.Block
    core:SetAttribute("KinAnnexReactive",true)
    for j=1,5 do
        local x=-71+j*3
        local piece=p(m,"Collection "..roomId.."-"..j,base,x,4.5,z+4,1.5,2.4,2,
            if j%2==0 then GOLD else clr,
            if theme=="archives" then Enum.Material.Fabric else Enum.Material.Glass,false)
        if theme=="gardens" or theme=="stars" then piece.Shape=Enum.PartType.Ball end
        piece:SetAttribute("KinAnnexReactive",true)
        p(m,"Étagère du thème",base,x,3,z+4,2.4,0.35,2.5,DECK,Enum.Material.WoodPlanks)
    end
    for _,xx in ipairs({-70,-51}) do
        p(m,"Colonne décorative",base,xx,6.2,z,0.7,9.5,0.7,DARK,Enum.Material.Metal)
    end
    bulb(m,base,-59,9.2,z,clr)
    thematicInstallation(m,base,theme,z,clr)
    -- Chaque salle possède son propre ensemble de sculptures actives.
    for _,element in ipairs(m:GetDescendants()) do
        if element:IsA("BasePart") and element:GetAttribute("KinAnnexReactive")==true and element:GetAttribute("KinAnnexRoomZ")==nil then
            element:SetAttribute("KinAnnexRoomZ",z)
        end
    end
    local console=p(m,"Console de découverte locale",base,-50.8,3,z+5,2.0,3.8,1.9,DARK,Enum.Material.Metal)
    console:SetAttribute("KinAnnexExperienceId",item.id..".room."..roomId)
    console:SetAttribute("KinAnnexIslandId",item.id)
    F.prompt(console,"Activer la salle","Expérience locale")
    local future=p(m,"Bibliothèque numérique future",base,-50,4,z-5,1.8,4.4,1.4,STONE,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",item.id..".room."..roomId..".future")
    future:SetAttribute("KinStubCapabilityId","future.island."..theme..".room")
    future:SetAttribute("KinStubTitle",item.title.." — salle "..roomId)
    F.prompt(future,"Consulter","Fonctionnalité à venir")
end
local function buildHouse(root,item,index)
    local worldPosition=Vector3.new(item.center_studs[1],0,item.center_studs[3])
    local base=CFrame.new(worldPosition)*CFrame.Angles(0,math.pi/2-item.angle,0)
    local clr=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local m=Instance.new("Model")
    m.Name="Maison des découvertes — "..item.title
    m:SetAttribute("KinAnnexIslandId",item.id)
    m.Parent=root
    -- Terrasse annexe sur pilotis au-delà de l'ancien bord de l'île.
    p(m,"Plateforme insulaire",base,-59,0.55,17,34,1.3,46,DECK,Enum.Material.WoodPlanks)
    for _,xx in ipairs({-74,-44}) do for _,zz in ipairs({-4,38}) do
        p(m,"Pieu de fondation",base,xx,-2.2,zz,1.7,7.5,1.7,DARK,Enum.Material.Metal)
    end end
    -- Accès de plain-pied par une passerelle latérale vers l'entrée EST.
    p(m,"Passerelle d'accès",base,-32,0.85,17,31,0.55,7,STONE,Enum.Material.WoodPlanks)
    for _,zz in ipairs({13,21}) do
        p(m,"Garde-corps d'accès",base,-32,2.2,zz,30,0.35,0.35,GOLD,Enum.Material.Metal,false)
    end
    p(m,"Revêtement intérieur",base,-59,1.3,17,29,0.3,42,STONE,Enum.Material.Marble)
    p(m,"Mur ouest",base,-74.3,6,17,0.8,9.9,42,DARK,Enum.Material.Slate)
    p(m,"Mur nord",base,-59,6,-3.5,31,9.9,0.8,DARK,Enum.Material.Slate)
    p(m,"Mur sud",base,-59,6,37.5,31,9.9,0.8,DARK,Enum.Material.Slate)
    -- Le mur côté île comporte un passage central de 8 studs de large.
    for _,zz in ipairs({3,31}) do
        p(m,"Façade est à ouverture",base,-44.5,6,zz,0.8,9.9,13,DARK,Enum.Material.Slate)
        local window=p(m,"Grande fenêtre d'atelier",base,-44.0,7.0,zz,0.3,3.4,8,Color3.fromRGB(157,205,221),Enum.Material.Glass,false)
        window.Transparency=0.4
    end
    -- Partition intérieure : porte réelle au centre, pas de mur invisible.
    for _,xx in ipairs({-68.0,-50.0}) do
        p(m,"Cloison percée",base,xx,5.9,17,12,9.5,0.7,DARK,Enum.Material.Wood)
    end
    p(m,"Linteau du passage intérieur",base,-59,10,17,6,1.5,0.8,GOLD,Enum.Material.Wood)
    p(m,"Toiture terrasse",base,-59,11.8,17,32,0.8,44,clr,Enum.Material.Slate)
    for _,xx in ipairs({-75,-43}) do
        p(m,"Balustrade de toiture",base,xx,13.2,17,0.4,2.2,43,GOLD,Enum.Material.Metal,false)
    end
    for _,zz in ipairs({-4,38}) do
        p(m,"Parapet de toiture",base,-59,13.2,zz,31,2.2,0.4,GOLD,Enum.Material.Metal,false)
    end
    -- Escalier indépendant au sud : 16 marches montant du terrain jusqu'au toit.
    for i=1,16 do
        local xx=-17-(i*1.8)
        local yy=0.9+i*0.69
        local step=p(m,"Marche panoramique "..i,base,xx,yy,38.5,1.9,0.4,5.0,STONE,Enum.Material.Cobblestone)
        step:SetAttribute("KinAnnexStair",i)
    end
    p(m,"Palier de terrasse",base,-46.5,11.9,38.5,8,0.6,6.5,STONE,Enum.Material.Cobblestone)
    for _,zz in ipairs({35.5,41.4}) do
        p(m,"Rampe d'escalier",base,-33.0,7.6,zz,32,0.4,0.5,GOLD,Enum.Material.Metal,false)
    end
    room(m,base,item,"A",6,clr)
    room(m,base,item,"B",28,clr)
    local seat=Instance.new("Seat");seat.Name="Siège panoramique"
    seat.Size=Vector3.new(5,0.7,2.4);seat.CFrame=base*CFrame.new(-59,12.6,3)
    seat.Color=DECK;seat.Material=Enum.Material.WoodPlanks;seat.Anchored=true;seat.Parent=m
    local beacon=p(m,"Signal de terrasse",base,-60,15.3,34,2,2,2,clr,Enum.Material.Neon,false)
    beacon.Shape=Enum.PartType.Ball
    F.sign(m,"Maison de l'île",(base*CFrame.new(-44,8.3,17)).Position,math.deg(-item.angle),"MAISON DES DÉCOUVERTES",23,3).CanCollide=false
    return m
end
function Annex.make(city)
    local root=F.folder(city,"Maisons insulaires et terrasses")
    for i,item in ipairs(Islands) do buildHouse(root,item,i) end
    root:SetAttribute("KinVisitables",#Islands)
    root:SetAttribute("KinSpecialRooms",2*#Islands)
    return root
end
return Annex
