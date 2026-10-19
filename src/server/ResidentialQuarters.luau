--!strict
-- Kin City v10 : six îlots résidentiels, quatre maisons à DEUX NIVEAUX chacun.
-- Intérieurs physiquement accessibles, escalier praticable, mobilier, cours,
-- plantations, toitures végétalisées et éclairage commandable localement.
-- Fabriqué uniquement avec des primitives Roblox. Aucun mesh payant ni HTTP.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local CrystalEverydayV19=require(script.Parent.CrystalEverydayV19)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local NeighborhoodRooflinesV22=require(script.Parent.NeighborhoodRooflinesV22)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local Groups=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local Residential={}
local WOOD=Color3.fromRGB(153,112,83)
local CREAM=Color3.fromRGB(234,223,200)
local INK=Color3.fromRGB(30,104,100)
local GOLD=Color3.fromRGB(226,184,109)
local GREEN=Color3.fromRGB(85,145,99)
local GLASS=Color3.fromRGB(197,244,240)

local function block(parent,label,base,x,y,z,w,h,d,color,material,solid)
    local r=F.part(parent,label,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then r.CanCollide=false;r.CanTouch=false;r.CanQuery=false end
    return r
end
local function globe(parent,base,name,x,y,z,diameter,color,material)
    local r=block(parent,name,base,x,y,z,diameter,diameter,diameter,color,material,false)
    r.Shape=Enum.PartType.Ball
    return r
end
local function chair(parent,base,x,y,z,color)
    local seat=Instance.new("Seat")
    seat.Name="Assise utilisable"
    seat.Size=Vector3.new(2.5,0.7,2.2)
    seat.CFrame=base*CFrame.new(x,y,z)
    seat.Anchored=true;seat.Color=color;seat.Material=Enum.Material.WoodPlanks;seat.Parent=parent
    block(parent,"Dossier de chaise",base,x,y+1.0,z+1.0,2.6,1.9,0.35,INK,Enum.Material.Wood)
end
local function plant(parent,base,x,y,z,color,large)
    local height=if large then 2.2 else 1.3
    block(parent,"Bac de verdure",base,x,y,z,if large then 4 else 2.3,1.1,if large then 3.2 else 2.3,WOOD,Enum.Material.Wood)
    for n=1,3 do
        local dx=(n-2)*(if large then 1.0 else 0.52)
        block(parent,"Tige",base,x+dx,y+1.1+height/2,z,0.23,height,0.23,GREEN,Enum.Material.Grass,false)
        globe(parent,base,"Feuillage",x+dx,y+height+1.3,z,if large then 1.8 else 1.25,color,Enum.Material.Grass)
    end
end
local function lamp(parent,base,x,y,z,color,tag)
    local a=globe(parent,base,"Lanternon habité",x,y,z,1.8,color,Enum.Material.Neon)
    local light=Instance.new("PointLight")
    light.Brightness=0.9;light.Range=18;light.Shadows=false;light.Parent=a
    if tag then
        a:SetAttribute("KinResidentialLampGroup",tag)
        a:SetAttribute("KinResidentialDefaultColor",color)
    end
    return a
end
local function home(root,group,groupIndex,index,base,theme)
    local m=Instance.new("Model")
    m.Name=string.format("Maison %02d — %s",index,group.title)
    m.Parent=root
    local stableId=string.format("%s.home.%02d",group.id,index)
    m:SetAttribute("KinResidenceId",stableId)
    m:SetAttribute("KinResidenceQuarter",group.id)
    m:SetAttribute("KinResidenceLevels",2)
    local tint=Color3.fromRGB(theme[1],theme[2],theme[3])
    local wall=if group.style=="culture" then Color3.fromRGB(202,170,157) elseif group.style=="atelier" then Color3.fromRGB(178,200,201) elseif group.style=="collectif" then Color3.fromRGB(216,195,156) else Color3.fromRGB(191,204,176)
    local roof=if index%2==0 then Color3.fromRGB(18,62,60) else Color3.fromRGB(43,114,108)
    local w,d=23,25
    -- Deux niveaux construits à hauteur réelle et sans volume de collision fictif.
    block(m,"Fondation",base,0,-0.3,0,w+1,1.1,d+1,CREAM,Enum.Material.Cobblestone)
    block(m,"Plancher du rez-de-chaussée",base,0,0.38,0,w,0.52,d,WOOD,Enum.Material.WoodPlanks)
    -- Sol étage : passage de 5.5 studs à droite pour la volée d'escalier.
    block(m,"Étage — aile ouest",base,-4.9,10.7,0,13.2,0.52,24,CREAM,Enum.Material.WoodPlanks)
    block(m,"Étage — galerie est",base,9.9,10.7,0,3.1,0.52,24,CREAM,Enum.Material.WoodPlanks)
    block(m,"Étage — palier de jonction",base,2.9,10.7,10.3,11,0.52,4.2,CREAM,Enum.Material.WoodPlanks)
    for _,side in ipairs({-1,1}) do
        local xx=side*(w/2)
        block(m,"Mur porteur latéral",base,xx,5.2,0,0.68,9.5,d,wall,Enum.Material.Brick)
        block(m,"Mur de l'étage",base,xx,15.7,0,0.68,9.7,d,wall,Enum.Material.Brick)
        for _,z in ipairs({-6,5}) do
            local glass=block(m,"Baie vitrée latérale",base,xx+side*0.39,15.8,z,0.19,3.7,4.8,GLASS,Enum.Material.Glass,false)
            OpalGlazingV22.apply(glass,false)
            block(m,"Traverse de baie",base,xx+side*0.54,15.8,z,0.21,0.21,4.9,CREAM,Enum.Material.Metal,false)
        end
    end
    block(m,"Mur arrière",base,0,5.2,d/2,w,9.5,0.68,wall,Enum.Material.Brick)
    block(m,"Mur arrière étage",base,0,15.7,d/2,w,9.7,0.68,wall,Enum.Material.Brick)
    -- Entrée au rez-de-chaussée : ouverture de 8 studs de large, non bloquée.
    for _,side in ipairs({-1,1}) do
        block(m,"Façade ouverte",base,side*7.7,5.2,-d/2,7.5,9.5,0.68,wall,Enum.Material.Brick)
        local pane=block(m,"Vitrine d'entrée",base,side*8,5.9,-d/2-0.42,4.0,3.3,0.18,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(pane,false)
        block(m,"Poutre de porte",base,side*4.1,6,-d/2,0.55,7.5,0.9,CREAM,Enum.Material.Marble)
    end
    block(m,"Linteau de l'entrée",base,0,9.25,-d/2,8.8,1.3,1.0,CREAM,Enum.Material.Marble)
    -- Étage vitré donnant sur le jardin commun.
    for _,xx in ipairs({-8,-2.7,2.7,8}) do
        local pane=block(m,"Fenêtre de l'étage",base,xx,15.3,-d/2,4.1,5.6,0.25,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(pane,false)
    end
    block(m,"Sol de toiture",base,0,21.2,0,w+2,0.75,d+2,roof,Enum.Material.Slate)
    for _,xx in ipairs({-12,12}) do
        block(m,"Parapet vertical",base,xx,22.5,0,0.36,2.1,d+2,GOLD,Enum.Material.Metal,false)
    end
    for _,zz in ipairs({-13.5,13.5}) do
        block(m,"Parapet de terrasse",base,0,22.5,zz,w+2,2.1,0.36,GOLD,Enum.Material.Metal,false)
    end
    -- Escalier intérieur réel de 14 marches, montant au palier du 2e niveau.
    -- Il longe la façade EST; chaque marche présente une surface porteuse.
    for step=1,14 do
        local z=-9.8+(step-1)*1.46
        local y=0.65+step*0.7
        block(m,"Escalier intérieur — marche "..step,base,5.05,y,z,4.8,0.48,1.55,CREAM,Enum.Material.Cobblestone)
    end
    for _,x in ipairs({2.45,7.55}) do
        block(m,"Main courante de l'escalier",base,x,7.4,0.1,0.26,0.32,20,GOLD,Enum.Material.Metal,false)
    end
    -- Séjour, bibliothèque et petite cuisine au rez-de-chaussée.
    block(m,"Table de séjour",base,-4.5,2.6,-1.5,6,1.0,3.8,WOOD,Enum.Material.WoodPlanks)
    chair(m,base,-8,1.5,-1.5,tint)
    chair(m,base,-1,1.5,-1.5,tint)
    block(m,"Comptoir collectif",base,-6.8,1.9,7.4,7,2.3,2.2,INK,Enum.Material.Wood)
    for n=1,4 do
        block(m,"Collection domestique "..n,base,-9.5+n*1.25,3.2,7.4,0.9,1.4,0.8,if n%2==0 then tint else GOLD,Enum.Material.Fabric,false)
    end
    -- Étude et repos en galerie au deuxième étage.
    block(m,"Bureau panoramique",base,-6.6,12.1,-4.2,6.9,1,3.2,WOOD,Enum.Material.WoodPlanks)
    chair(m,base,-6.5,11.7,-0.9,tint)
    block(m,"Bibliothèque de l'étage",base,-9.5,13.3,6.8,2.2,4,5.5,INK,Enum.Material.Wood)
    for shelf=1,2 do
        block(m,"Livres et archives",base,-9.5,12.8+shelf*1.3,6.8,1.2,0.7,4.0,tint,Enum.Material.Fabric,false)
    end
    block(m,"Couchage d'appoint",base,-1.1,11.4,-6.1,4,1,5.6,Color3.fromRGB(226,216,196),Enum.Material.Fabric)
    -- Toiture végétalisée : décor uniquement, sans accès promis au public.
    for n=1,4 do
        local x=-8+(n-1)*5
        block(m,"Bac vert de toiture",base,x,21.85,6.4,3.8,0.7,4.2,WOOD,Enum.Material.Wood)
        for stem=1,2 do
            globe(m,base,"Plante de toit",x+(stem-1)*1.1,23.0,6.4,1.4,GREEN,Enum.Material.Grass)
        end
    end
    block(m,"Auvent de bienvenue",base,0,9.5,-15.4,11,0.55,5.8,roof,Enum.Material.Slate,false)
    block(m,"Chemin vers la cour",base,0,0.08,-16.3,7,0.2,10,CREAM,Enum.Material.Cobblestone)
    local mailbox=block(m,"Boîte d'information à venir",base,-9.5,2,-16,2.2,3.5,1.0,INK,Enum.Material.Metal)
    mailbox:SetAttribute("KinStubInteractionId",stableId..".mail.future")
    mailbox:SetAttribute("KinStubCapabilityId","future.residential.services")
    mailbox:SetAttribute("KinStubTitle","Services de la maison")
    F.prompt(mailbox,"Consulter","Fonctionnalité à venir")
    F.sign(m,"Numéro de la maison",(base*CFrame.new(0,8.5,-13.2)).Position,math.deg(group.angle),string.format("MAISON %02d",index),10,2.0).CanCollide=false
    lamp(m,base,9,7.8,-14.6,tint,group.id)
    CrystalEverydayV19.frame(m,base,w,d,21.2,"residence")
    NeighborhoodRooflinesV22.make(m,base,w,d,21.2,group.style,groupIndex*4+index)
    SecondaryArchitectureV25.home(m,base,group.style,groupIndex*4+index)
    return m
end

local function plot(m,base,x,z,color)
    block(m,"Jardin partagé",base,x,0.5,z,8,1,5,WOOD,Enum.Material.Wood)
    for n=1,4 do
        local plantColor=if n%2==0 then GREEN else color
        globe(m,base,"Cultures du jardin",x+(n-2.5)*1.65,1.6,z,2.0,plantColor,Enum.Material.Grass)
    end
end
local function plaza(m,base,group,color)
    block(m,"Place collective pavée",base,0,0.03,0,38,0.24,38,CREAM,Enum.Material.Cobblestone)
    for _,offset in ipairs({-19.7,19.7}) do
        block(m,"Liseré de la place",base,offset,0.17,0,0.5,0.3,39,GOLD,Enum.Material.Metal,false)
        block(m,"Liseré de la place",base,0,0.17,offset,39,0.3,0.5,GOLD,Enum.Material.Metal,false)
    end
    block(m,"Kiosque de rencontres",base,0,0.9,0,14,0.6,14,WOOD,Enum.Material.WoodPlanks)
    block(m,"Toit du kiosque",base,0,10.1,0,17,0.7,17,color,Enum.Material.Slate,false)
    for _,x in ipairs({-7,7}) do for _,z in ipairs({-7,7}) do
        block(m,"Pilier du kiosque",base,x,5.3,z,0.8,9.5,0.8,INK,Enum.Material.Wood)
    end end
    block(m,"Table des voisins",base,0,3.2,0,5.8,0.8,4.4,WOOD,Enum.Material.WoodPlanks)
    for _,z in ipairs({-4,4}) do chair(m,base,0,1.5,z,color) end
    for _,x in ipairs({-14,14}) do for _,z in ipairs({-14,14}) do
        lamp(m,base,x,4.5,z,color,group.id)
    end end
    for _,x in ipairs({-15,15}) do
        plot(m,base,x,0,color)
        plant(m,base,x,1.1,10,color,false)
    end
    -- Installation mécanique locale : lumières de la cour ON/OFF.
    local switch=block(m,"Commande des lanternes communes",base,0,2.2,11.8,2.2,3.5,1.8,INK,Enum.Material.Metal)
    switch:SetAttribute("KinResidentialAction","lights")
    switch:SetAttribute("KinResidentialQuarterId",group.id)
    F.prompt(switch,"Allumer / éteindre","Lanternes de quartier")
    -- Tableau de services futurs clairement délimité du mécanisme physique.
    local future=block(m,"Tableau de services de quartier",base,0,3.0,-12.7,2.6,4.8,0.9,INK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",group.id..".services.future")
    future:SetAttribute("KinStubCapabilityId","future.residential.neighborhood")
    future:SetAttribute("KinStubTitle",group.title)
    F.prompt(future,"Consulter","Fonctionnalité à venir")
end
-- Empêche les arbres procéduraux de pousser dans les maisons et leur accès.
function Residential.isReserved(x,z)
    for _,group in ipairs(Groups) do
        local center=Vector3.new(group.center_studs[1],0,group.center_studs[3])
        local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-group.angle,0)
        local localPosition=base:PointToObjectSpace(Vector3.new(x,0,z))
        if math.abs(localPosition.X)<45 and math.abs(localPosition.Z)<45 then return true end
        if math.abs(localPosition.X)<11 and localPosition.Z>=-90 and localPosition.Z<=-35 then return true end
        -- Boulevard piéton depuis la place centrale jusqu'au quartier.
        local radial=Vector3.new(math.cos(group.angle),0,math.sin(group.angle))
        local along=x*radial.X+z*radial.Z
        local across=math.abs(x*radial.Z-z*radial.X)
        if along>=65 and along<=335 and across<22 then return true end
    end
    return false
end

function Residential.make(city)
    local root=F.folder(city,"Quartiers habités — 24 maisons")
    local houses=0
    for k,group in ipairs(Groups) do
        local clr=Color3.fromRGB(group.color[1],group.color[2],group.color[3])
        local center=Vector3.new(group.center_studs[1],0,group.center_studs[3])
        local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-group.angle,0)
        local neighborhood=Instance.new("Model")
        neighborhood.Name=group.title
        neighborhood.Parent=root
        neighborhood:SetAttribute("KinResidentialQuarterId",group.id)
        -- Quatre maisons le long des angles de la cour, façades vers le centre.
        for i,position in ipairs({Vector3.new(-29,0,-29),Vector3.new(29,0,-29),Vector3.new(-29,0,29),Vector3.new(29,0,29)}) do
            local facing=if i<=2 then math.pi else 0
            local orient=base*CFrame.new(position)*CFrame.Angles(0,facing,0)
            home(neighborhood,group,k,i,orient,group.color)
            houses+=1
        end
        plaza(neighborhood,base,group,clr)
        -- Boulevard radiaire CONSTRUIT : connecte le centre de Kin City à la cour.
        local radial=Vector3.new(math.cos(group.angle),0,math.sin(group.angle))
        local boulevardStart=radial*64+Vector3.new(0,0.12,0)
        local boulevardEnd=radial*305+Vector3.new(0,0.12,0)
        local roadCFrame=CFrame.lookAt((boulevardStart+boulevardEnd)/2,boulevardEnd)
        local road=F.part(neighborhood,"Boulevard piéton radial",Vector3.new(10,0.25,(boulevardEnd-boulevardStart).Magnitude),roadCFrame,CREAM,Enum.Material.Cobblestone)
        road:SetAttribute("KinPedestrianBoulevard",group.id)
        for _,distance in ipairs({103,160,217,274}) do
            local point=radial*distance
            local side=Vector3.new(-radial.Z,0,radial.X)
            for _,dir in ipairs({-1,1}) do
                local where=point+side*(dir*11)
                local basis=CFrame.new(where)
                block(neighborhood,"Lanterne de promenade",basis,0,3.3,0,0.6,6.5,0.6,INK,Enum.Material.Metal)
                lamp(neighborhood,basis,0,7.0,0,clr,group.id)
            end
        end
        -- Chemin radiaire de la promenade vers le cœur de l'îlot.
        block(neighborhood,"Accès piéton de quartier",base,0,-0.03,-60,10,0.25,55,CREAM,Enum.Material.Cobblestone)
        for _,xx in ipairs({-6,6}) do
            block(neighborhood,"Bordure végétale",base,xx,0.05,-56,0.7,0.35,40,GREEN,Enum.Material.Grass,false)
        end
        F.sign(neighborhood,"Nom du quartier",(base*CFrame.new(0,6.6,-77)).Position,math.deg(math.pi/2-group.angle),group.title,24,3.2).CanCollide=false
    end
    root:SetAttribute("KinResidentialQuarters",#Groups)
    root:SetAttribute("KinResidentialHomes",houses)
    root:SetAttribute("KinResidentialFloors",houses*2)
    return root
end
return Residential
