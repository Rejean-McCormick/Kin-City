--!strict
-- Kin City v16 : huit ailes d'exposition visitables, rattachées physiquement
-- à l'atrium arrière de chaque institution. Constructions natives, sans asset distant.
-- Repère local de chaque intérieur : aile z=110..192, mezzanines à y=18.
-- Identifiants persistants : <place_key>.discovery.<01|02>.
local F=require(script.Parent.Factory)
local Wings={}

local INK=Color3.fromRGB(36,57,70)
local STONE=Color3.fromRGB(220,211,191)
local GOLD=Color3.fromRGB(204,166,103)
local GLASS=Color3.fromRGB(126,190,204)
local WOOD=Color3.fromRGB(127,87,63)
local THEMES={
    city_hall={"GALERIE DE LA CITÉ","Territoire en mouvement","Liens entre quartiers","urban",Color3.fromRGB(235,177,108)},
    ekoh_tower={"ATELIER DES SAVOIRS","Constellation de concepts","Arbre des découvertes","network",Color3.fromRGB(98,220,189)},
    library={"GRANDE AILE DES ARCHIVES","Bibliothèque cinétique","Mémoires en mouvement","books",Color3.fromRGB(141,188,230)},
    campus={"GALERIE DES SCIENCES","Orbites pédagogiques","Cycle des planètes","orbits",Color3.fromRGB(181,161,230)},
    justice_palace={"ESPACE DES ÉQUILIBRES","Mécanique des équilibres","Symétries du monde","balance",Color3.fromRGB(234,192,131)},
    innovation_lab={"FABRIQUE DES IDÉES","Assemblage inventif","Moteur des possibles","turbine",Color3.fromRGB(100,208,228)},
    museum={"GALERIE DES FORMES","Sculpture chromatique","Mouvement du patrimoine","art",Color3.fromRGB(234,145,174)},
    orgo_center={"ATELIER DES RÉSEAUX","Topologie des services","Circulation des flux","network",Color3.fromRGB(139,192,239)},
}

local function part(parent,name,origin,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),CFrame.new(origin+Vector3.new(x,y,z)),color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function orb(parent,name,origin,x,y,z,diameter,color,material)
    local p=part(parent,name,origin,x,y,z,diameter,diameter,diameter,color,material,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function beam(parent,name,origin,a,b,thickness,color)
    local delta=b-a
    local center=(a+b)*0.5
    local p=F.part(parent,name,Vector3.new(thickness,thickness,delta.Magnitude),
        CFrame.lookAt(origin+center,origin+b),color,Enum.Material.Metal)
    p.CanCollide=false
    return p
end
local function rampStairs(parent,origin,x,accent,stone)
    -- 26 marches contiguës : la dernière rejoint la mezzanine y=18.
    local steps=26
    for i=1,steps do
        local rise=18*i/steps
        local z=119+(i-0.5)*1.5
        part(parent,"Escalier galerie · marche "..i,origin,x,rise/2,z,7,rise,1.56,stone,Enum.Material.Marble,true)
        if i%4==0 then
            for _,s in ipairs({-1,1}) do
                part(parent,"Montant de rampe",origin,x+s*3.95,rise+1.55,z,0.24,3.1,0.24,accent,Enum.Material.Metal,false)
            end
        end
    end
    for _,s in ipairs({-1,1}) do
        -- La rampe est un élément de décor haut, pour ne pas obstruer les marches.
        local start=Vector3.new(x+s*4,3.0,119)
        local finish=Vector3.new(x+s*4,21.0,157.5)
        beam(parent,"Rampe inclinée",origin,start,finish,0.32,accent)
    end
end
local function sculpture(parent,origin,x,z,kind,accent,variant,id)
    local platform=part(parent,"Socle de collection",origin,x,1.45,z,15,2.9,15,STONE,Enum.Material.Marble,true)
    part(parent,"Filet du socle",origin,x,2.9,z,15.4,0.22,15.4,GOLD,Enum.Material.Metal,false)
    local mobile=Instance.new("Model")
    mobile.Name="Oeuvre interactive · "..kind
    mobile:SetAttribute("KinV16MechanismId",id)
    mobile.Parent=parent
    local axis=part(mobile,"Pivot de l'oeuvre",origin,x,8,z,0.2,0.2,0.2,INK,Enum.Material.Metal,false)
    axis.Transparency=1
    mobile.PrimaryPart=axis
    if kind=="urban" then
        for i=1,8 do
            local a=2*math.pi*i/8
            local height=2.3+(i%4)*1.5
            part(mobile,"Miniature d'un quartier",origin,x+math.cos(a)*4.5,4+height/2,z+math.sin(a)*4.5,
                1.9,height,1.9,if i%2==0 then accent else GOLD,Enum.Material.Marble,false)
        end
        orb(mobile,"Coeur de cité",origin,x,8,z,3.5,accent,Enum.Material.Glass)
    elseif kind=="network" then
        local nodes={}
        for i=1,9 do
            local a=i*math.pi*2/9
            local point=Vector3.new(x+math.cos(a)*4.5,7+(i%3)*1.5,z+math.sin(a)*4.5)
            nodes[i]=point
            orb(mobile,"Noeud du savoir",origin,point.X,point.Y,point.Z,1.8,accent,Enum.Material.Neon)
        end
        for i=1,#nodes do
            local j=i%#nodes+1
            beam(mobile,"Lien des savoirs",origin,nodes[i],nodes[j],0.25,GOLD)
        end
    elseif kind=="books" then
        for i=1,7 do
            local angle=i*2*math.pi/7
            local q=part(mobile,"Livre sculptural",origin,x+math.cos(angle)*4,7+(i%3),z+math.sin(angle)*4,
                1.4,4,3,if i%2==0 then accent else GOLD,Enum.Material.WoodPlanks,false)
            q.CFrame=q.CFrame*CFrame.Angles(0,angle,0)
        end
    elseif kind=="orbits" then
        orb(mobile,"Soleil central",origin,x,8,z,4.2,GOLD,Enum.Material.Neon)
        for i=1,6 do
            local a=i*math.pi/3
            orb(mobile,"Planète pédagogique",origin,x+math.cos(a)*5,8+(i%3)*1.1,z+math.sin(a)*5,
                0.9+(i%3)*0.55,accent,Enum.Material.Glass)
        end
    elseif kind=="balance" then
        part(mobile,"Axe des équilibres",origin,x,8,z,0.8,9,0.8,GOLD,Enum.Material.Metal,false)
        part(mobile,"Traverse des équilibres",origin,x,12,z,11,0.65,0.65,accent,Enum.Material.Metal,false)
        for _,side in ipairs({-1,1}) do
            part(mobile,"Câble de plateau",origin,x+side*4.7,9.4,z,0.22,4.4,0.22,GOLD,Enum.Material.Metal,false)
            part(mobile,"Plateau des équilibres",origin,x+side*4.7,7.1,z,4.3,0.45,4.3,accent,Enum.Material.Metal,false)
        end
    elseif kind=="turbine" then
        part(mobile,"Mât de turbine",origin,x,8,z,1.1,9,1.1,INK,Enum.Material.Metal,false)
        for i=1,8 do
            local a=i*math.pi/4
            local blade=part(mobile,"Pale de turbine",origin,x+math.cos(a)*3,9,z+math.sin(a)*3,
                1.5,0.4,5.0,accent,Enum.Material.Metal,false)
            blade.CFrame=blade.CFrame*CFrame.Angles(0,a,math.rad(17))
        end
    else
        for i=1,8 do
            local a=2*math.pi*i/8
            local ball=orb(mobile,"Forme de couleur",origin,x+math.cos(a)*4.3,6+(i%4),z+math.sin(a)*4.3,
                1.7+(i%2)*0.6,Color3.fromHSV((i/8+variant*0.17)%1,0.5,0.92),Enum.Material.Glass)
            ball.Transparency=0.17
        end
    end
    local control=part(parent,"Commande de l'oeuvre",origin,x+9.1,2.3,z+8.8,3.7,4.6,2.4,INK,Enum.Material.Metal,true)
    part(parent,"Interface de l'oeuvre",origin,x+9.1,2.9,z+7.5,2.9,2.4,0.16,accent,Enum.Material.Neon,false)
    control:SetAttribute("KinV16Action","mechanism")
    control:SetAttribute("KinV16MechanismId",id)
    control:SetAttribute("KinV16PlaceKey",string.match(id,"^[^.]+") or "")
    control:SetAttribute("KinV16Title",if variant==1 then "Oeuvre A" else "Oeuvre B")
    F.prompt(control,"Animer","Galerie des découvertes")
    return platform
end
local function bench(parent,origin,x,z)
    local seat=Instance.new("Seat")
    seat.Name="Banc de galerie"
    seat.Anchored=true
    seat.Size=Vector3.new(5,0.7,2.6)
    seat.CFrame=CFrame.new(origin+Vector3.new(x,1.7,z))
    seat.Material=Enum.Material.WoodPlanks
    seat.Color=WOOD
    seat.Parent=parent
    part(parent,"Dossier du banc",origin,x,2.65,z+1.1,5,2.2,0.5,INK,Enum.Material.Metal,true)
end
local function cutOriginalWall(model,origin,trim)
    -- Ouvre réellement le mur arrière de l'atrium; une ouverture seulement
    -- visuelle empêcherait le visiteur de rejoindre cette nouvelle aile.
    local atrium=model:FindFirstChild("city_hall.rear_atrium")
    if not atrium then
        for _,child in ipairs(model:GetChildren()) do
            if child.Name:find("%.rear_atrium$",1,false) then atrium=child;break end
        end
    end
    if not atrium then error("Kin City : atrium arrière absent pour la nouvelle aile") end
    local removed=0
    for _,obj in ipairs(atrium:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name=="Wall_back" then
            obj:Destroy()
            removed+=1
        end
    end
    if removed==0 then error("Kin City : mur arrière introuvable") end
    part(atrium,"Mur arrière · ouest",origin,-29,8,104,42,16,0.85,trim,Enum.Material.Concrete,true)
    part(atrium,"Mur arrière · est",origin,29,8,104,42,16,0.85,trim,Enum.Material.Concrete,true)
    part(atrium,"Linteau de galerie",origin,0,14.5,104,16,3,1,trim,Enum.Material.Marble,true)
end
function Wings.make(model,key,origin,style)
    local theme=THEMES[key]
    if not theme then return nil end
    local trim=F.hex(style.palette.trim)
    local accent=F.hex(style.palette.accent)
    local wall=F.hex(style.palette.wall)
    local section=F.folder(model,"Aile des découvertes v16")
    section:SetAttribute("KinV16PlaceKey",key)
    cutOriginalWall(model,origin,wall)
    -- Le seuil relie sans trou l'atrium historique (jusqu'à z=104) au nouveau volume.
    part(section,"Seuil de l'aile",origin,0,-0.5,106.5,18,1,7,trim,Enum.Material.Marble,true)
    part(section,"Sol de la grande galerie",origin,0,-0.5,150.5,92,1,83,trim,Enum.Material.Marble,true)
    for _,s in ipairs({-1,1}) do
        part(section,"Mur latéral de galerie",origin,s*46,9,150.5,1.1,18,83,wall,Enum.Material.Concrete,true)
        part(section,"Portique de la nouvelle aile",origin,s*27,9,109,38,18,1,wall,Enum.Material.Concrete,true)
        for z=119,179,12 do
            local window=part(section,"Fenêtre haute",origin,s*46.8,10.4,z,0.24,6.6,6.2,GLASS,Enum.Material.Glass,false)
            window.Transparency=0.19
            part(section,"Cadre de fenêtre",origin,s*47,14.0,z,0.35,0.65,7.0,accent,Enum.Material.Metal,false)
        end
    end
    part(section,"Mur du fond",origin,0,9,192,93,18,1,wall,Enum.Material.Concrete,true)
    part(section,"Linteau d'entrée",origin,0,14.5,109,17,3.0,1,accent,Enum.Material.Metal,true)
    -- Deux mezzanines reliées à l'arrière, accès par escaliers physiques.
    for _,s in ipairs({-1,1}) do
        part(section,"Mezzanine",origin,s*36.5,17.5,174,17,1,32,trim,Enum.Material.Marble,true)
        -- Garde-corps interrompu au raccord de la passerelle (z=173..185) :
        -- sans cette ouverture, la mezzanine serait visuellement connectée mais impraticable.
        part(section,"Garde-corps avant",origin,s*27.7,20.0,165,0.65,3.8,12,accent,Enum.Material.Metal,true)
        part(section,"Garde-corps arrière",origin,s*27.7,20.0,188,0.65,3.8,4,accent,Enum.Material.Metal,true)
        for z=164,184,10 do
            part(section,"Potelet de mezzanine",origin,s*27.7,19.6,z,0.6,4,0.6,GOLD,Enum.Material.Metal,false)
        end
        rampStairs(section,origin,s*36.5,accent,trim)
        bench(section,origin,s*36,176)
    end
    part(section,"Passerelle transversale",origin,0,17.5,179,55,1,12,trim,Enum.Material.Marble,true)
    part(section,"Garde-corps de passerelle",origin,0,20,173.2,52,3.8,0.65,accent,Enum.Material.Metal,true)
    -- Verrière translucide : les matériaux et reliefs sont visibles de loin.
    local pane=part(section,"Verrière monumentale",origin,0,34.1,150,91,0.65,80,GLASS,Enum.Material.Glass,false)
    pane.Transparency=0.48
    for x=-42,42,14 do
        part(section,"Nervure de verrière",origin,x,34.6,150,0.45,1,82,accent,Enum.Material.Metal,false)
    end
    for z=117,187,14 do
        part(section,"Traverse de verrière",origin,0,34.6,z,92,1,0.5,accent,Enum.Material.Metal,false)
    end
    for _,s in ipairs({-1,1}) do
        for z=123,183,20 do
            local lum=part(section,"Lustre de galerie",origin,s*19,26,z,2.3,1.3,2.3,theme[5],Enum.Material.Neon,false)
            lum.Shape=Enum.PartType.Ball
            local light=Instance.new("PointLight")
            light.Brightness=1.2;light.Range=22;light.Shadows=false;light.Parent=lum
            lum:SetAttribute("KinV16LampPlace",key)
        end
    end
    F.sign(section,"Enseigne de la grande galerie",origin+Vector3.new(0,12,110.0),0,theme[1],38,3.1).CanCollide=false
    for i,s in ipairs({-1,1}) do
        local id=key..".discovery."..string.format("%02d",i)
        sculpture(section,origin,s*23,153,theme[4],theme[5],i,id)
        F.sign(section,"Titre de collection",origin+Vector3.new(s*22,8,164),0,theme[i+1],23,2.9).CanCollide=false
    end
    for _,x in ipairs({-15,0,15}) do bench(section,origin,x,182) end
    local console=part(section,"Console d'ambiance",origin,0,2.25,187,3.5,4.5,2.5,INK,Enum.Material.Metal,true)
    part(section,"Ecran de console",origin,0,2.8,185.65,2.6,2.5,0.2,theme[5],Enum.Material.Neon,false)
    console:SetAttribute("KinV16Action","lighting")
    console:SetAttribute("KinV16PlaceKey",key)
    F.prompt(console,"Changer l'ambiance","Grande galerie")
    -- Fonctionnalité métier explicitement conservée à l'état futur.
    local terminal=part(section,"Terminal du futur",origin,13,2.4,188,3.5,4.8,2.5,INK,Enum.Material.Metal,true)
    part(section,"Ecran du terminal",origin,13,3,186.65,2.6,2.5,0.2,GLASS,Enum.Material.Neon,false)
    terminal:SetAttribute("KinStubInteractionId",key..".discovery.future.01")
    terminal:SetAttribute("KinStubCapabilityId","future."..key..".discovery")
    terminal:SetAttribute("KinStubTitle",theme[1])
    F.prompt(terminal,"Consulter","Futures activités")
    return section
end
return Wings
