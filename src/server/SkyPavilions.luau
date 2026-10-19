--!strict
-- V15 · Quatrième niveau visitable pour chacune des huit institutions.
-- Observatoires scénographiques et expériences physiques locales; aucun asset externe.
-- Coordonnées relatives à l'origine de chaque Place : le toit existant est à y=38.
local F=require(script.Parent.Factory)
local Sky={}

local INK=Color3.fromRGB(32,55,72)
local GOLD=Color3.fromRGB(225,190,120)
local PALE=Color3.fromRGB(238,232,210)
local GLASS=Color3.fromRGB(138,215,228)
local GREEN=Color3.fromRGB(87,160,129)

local TOPICS={
    city_hall={"LE FORUM DES CITÉS","Maquette des quartiers","Architecture des places",Color3.fromRGB(238,179,109),"city"},
    ekoh_tower={"LA CONSTELLATION DES SAVOIRS","Réseaux de connaissances","Cartographie des expertises",Color3.fromRGB(92,223,197),"network"},
    library={"LE JARDIN DES LIVRES","Livres en mouvement","Archives du futur",Color3.fromRGB(150,194,233),"books"},
    campus={"LE LABORATOIRE DU CIEL","Orbits et gravitation","Système des découvertes",Color3.fromRGB(187,162,237),"orbits"},
    justice_palace={"L'ATELIER DES ÉQUILIBRES","Mécanique des balances","Symétrie et harmonie",Color3.fromRGB(229,196,138),"balance"},
    innovation_lab={"LA HALLE DES INVENTIONS","Turbine expérimentale","Engrenages créatifs",Color3.fromRGB(124,222,225),"turbine"},
    museum={"LE MUSÉE AÉRIEN","Mouvement des formes","Sculpture chromatique",Color3.fromRGB(239,156,159),"art"},
    orgo_center={"L'OBSERVATOIRE DES RÉSEAUX","Topologie des services","Circuit des connexions",Color3.fromRGB(139,191,237),"network"},
}

local function block(parent,name,base,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then
        p.CanCollide=false
        p.CanTouch=false
        p.CanQuery=false
    end
    return p
end

local function sphere(parent,name,base,x,y,z,r,color,material)
    local p=block(parent,name,base,x,y,z,r,r,r,color,material,false)
    p.Shape=Enum.PartType.Ball
    return p
end

local function seat(parent,base,x,z)
    local s=Instance.new("Seat")
    s.Name="Assise de l'observatoire"
    s.Size=Vector3.new(3,0.65,2.6)
    s.CFrame=base*CFrame.new(x,57.2,z)
    s.Anchored=true
    s.Color=INK
    s.Material=Enum.Material.Fabric
    s.Parent=parent
    block(parent,"Dossier",base,x,58.2,z+1.0,3,2,0.45,GOLD,Enum.Material.Metal)
end

local function apparatus(parent,base,x,z,kind,color,variant,id)
    -- Seules les pièces de ce Model pivotent; le socle et l'utilisateur ne bougent pas.
    block(parent,"Socle de démonstration",base,x,57.2,z,11,2.0,11,PALE,Enum.Material.Marble)
    local model=Instance.new("Model")
    model.Name="Mécanisme · "..kind.." · "..variant
    model:SetAttribute("KinSkyMechanismId",id)
    model.Parent=parent
    local pivot=block(model,"Pivot invisible",base,x,63.0,z,0.2,0.2,0.2,INK,Enum.Material.Metal,false)
    pivot.Transparency=1
    model.PrimaryPart=pivot
    if kind=="city" then
        for i=1,7 do
            local a=i*math.pi*2/7
            local h=3+(i%4)*1.6
            block(model,"Miniature urbaine",base,x+math.cos(a)*3.4,61+h/2,z+math.sin(a)*3.4,1.65,h,1.65,if i%2==0 then color else GOLD,Enum.Material.Marble,false)
        end
        block(model,"Place centrale miniature",base,x,61,z,3.5,0.3,3.5,INK,Enum.Material.Metal,false)
    elseif kind=="books" then
        for i=1,9 do
            local a=i*math.pi*2/9
            local sy=2.1+(i%3)*0.55
            local p=block(model,"Volume suspendu",base,x+math.cos(a)*3.5,63+(i%3)*1.6,z+math.sin(a)*3.5,1.9,sy,0.6,if i%2==0 then color else GOLD,Enum.Material.Fabric,false)
            p.CFrame=p.CFrame*CFrame.Angles(0,a,math.rad(18))
        end
        sphere(model,"Sphère des archives",base,x,64,z,2.5,PALE,Enum.Material.Glass)
    elseif kind=="balance" then
        block(model,"Axe d'équilibre",base,x,63.4,z,0.9,6.8,0.9,GOLD,Enum.Material.Metal,false)
        block(model,"Traverse suspendue",base,x,66.2,z,9.3,0.45,0.5,GOLD,Enum.Material.Metal,false)
        for _,dir in ipairs({-1,1}) do
            block(model,"Chaîne",base,x+dir*3.6,64.4,z,0.18,3.2,0.18,GOLD,Enum.Material.Metal,false)
            local tray=block(model,"Plateau de balance",base,x+dir*3.6,62.6,z,3.1,0.5,3.1,color,Enum.Material.Marble,false)
            tray.Shape=Enum.PartType.Cylinder
            tray.CFrame=tray.CFrame*CFrame.Angles(0,0,math.pi/2)
        end
    elseif kind=="turbine" then
        block(model,"Axe turbine",base,x,62.4,z,0.8,6.2,0.8,GOLD,Enum.Material.Metal,false)
        for i=1,8 do
            local a=i*math.pi/4
            local vane=block(model,"Pale motrice",base,x+math.cos(a)*2.5,63,z+math.sin(a)*2.5,4.5,0.32,1.2,color,Enum.Material.Metal,false)
            vane.CFrame=vane.CFrame*CFrame.Angles(0,-a,math.rad(23))
        end
    elseif kind=="art" then
        for i=1,11 do
            local a=i*math.pi*2/11
            local p=sphere(model,"Œuvre colorée",base,x+math.cos(a)*3.5,62+(i%5)*0.95,z+math.sin(a)*3.5,1.5,Color3.fromHSV(((i*0.091)+(variant*0.15))%1,0.55,0.94),Enum.Material.Glass)
            p.Transparency=0.15
        end
    else -- orbits / network
        sphere(model,"Noyau lumineux",base,x,64,z,3,if kind=="network" then color else GOLD,Enum.Material.Neon)
        for i=1,8 do
            local a=i*math.pi/4
            local r=if kind=="orbits" then 4 else 3.5
            local yy=63+(i%3-1)*1.35
            sphere(model,"Satellite",base,x+math.cos(a)*r,yy,z+math.sin(a)*r,1.1,if i%2==0 then color else PALE,Enum.Material.Glass)
            if kind=="network" then
                local ray=block(model,"Liaison",base,x+math.cos(a)*1.9,(yy+64)/2,z+math.sin(a)*1.9,0.16,0.16,3.8,GOLD,Enum.Material.Neon,false)
                ray.CFrame=CFrame.lookAt(ray.Position,base.Position+Vector3.new(x+math.cos(a)*r,yy,z+math.sin(a)*r))*CFrame.Angles(math.pi/2,0,0)
            end
        end
    end
    return model
end

local function lamp(parent,base,x,z,key,index,color)
    local housing=block(parent,"Balise lumière",base,x,58.3,z,1.2,4.2,1.2,INK,Enum.Material.Metal)
    local bulb=sphere(parent,"Projecteur",base,x,60.6,z,1.7,color,Enum.Material.Neon)
    bulb:SetAttribute("KinSkyLampPlace",key)
    bulb:SetAttribute("KinSkyLampIndex",index)
    local light=Instance.new("PointLight")
    light.Brightness=1.1
    light.Range=22
    light.Shadows=false
    light.Parent=bulb
    return housing
end

local function lift(parent,base,key,sourceY,destY,name)
    block(parent,"Plateforme élévateur "..name,base,12,sourceY+0.25,82,6,0.5,6,GOLD,Enum.Material.Metal)
    local control=block(parent,"Console élévateur "..name,base,16.7,sourceY+2,82,2.6,4,1.5,INK,Enum.Material.Metal)
    block(parent,"Voyant ascenseur",base,16.7,sourceY+2.5,81.15,1.8,1.6,0.15,GLASS,Enum.Material.Neon,false)
    control:SetAttribute("KinLiftId",key..".sky."..name)
    control:SetAttribute("KinLiftPlaceKey",key)
    control:SetAttribute("KinLiftPosition",base.Position+Vector3.new(12,destY+3.4,79.5))
    F.prompt(control,if destY>sourceY then "Monter au pavillon" else "Revenir au toit","Ascenseur du ciel")
end

function Sky.make(interior,key,origin,style)
    local topic=TOPICS[key]
    if not topic then return nil end
    local section=F.folder(interior,"Quatrième niveau · "..topic[1])
    section:SetAttribute("KinSkyPlaceKey",key)
    section:SetAttribute("KinSkyLevel",4)
    local base=CFrame.new(origin)
    local color=topic[4]
    local trim=F.hex(style.palette.trim)
    -- Quatrième niveau construit au-dessus du toit-jardin existant, sans remplacer ses installations.
    block(section,"Plateforme aérienne",base,0,55.55,76,74,1.1,44,PALE,Enum.Material.Marble)
    block(section,"Promenade centrale",base,0,56.17,82,15,0.10,30,color,Enum.Material.SmoothPlastic,false).Transparency=0.48
    for _,x in ipairs({-34,34}) do
        for _,z in ipairs({57,95}) do
            block(section,"Colonne porteuse",base,x,46.5,z,1.6,18.5,1.6,trim,Enum.Material.Metal)
        end
        block(section,"Garde-corps aérien",base,x+(if x<0 then -3 else 3),58.8,76,0.6,5,44,INK,Enum.Material.Metal)
    end
    for _,z in ipairs({54,98}) do
        block(section,"Garde-corps transversal",base,0,58.8,z,75,5,0.6,INK,Enum.Material.Metal)
    end
    -- Structure de verrière semi-ouverte : panneaux translucides sans collision.
    for _,x in ipairs({-33,-16,0,16,33}) do
        block(section,"Arceau de serre",base,x,68.5,76,0.65,3,45,GOLD,Enum.Material.Metal,false)
    end
    for _,z in ipairs({58,70,82,94}) do
        local glass=block(section,"Panneau solaire translucide",base,0,70.25,z,72,0.35,8.8,GLASS,Enum.Material.Glass,false)
        glass.Transparency=0.64
    end
    F.sign(section,"Titre de la serre haute",origin+Vector3.new(0,64,96.7),180,topic[1],47,3.5).CanCollide=false
    for i,side in ipairs({-1,1}) do
        local x=side*23
        local id=key..".sky.station."..string.format("%02d",i)
        apparatus(section,base,x,67,topic[5],color,i,id)
        F.sign(section,"Station "..i,origin+Vector3.new(x,59.6,73.2),180,topic[1+i],17,2.5).CanCollide=false
        local console=block(section,"Console de démonstration",base,x,58.15,78,2.5,4.1,2,INK,Enum.Material.Metal)
        block(section,"Écran console",base,x,58.8,76.85,2,2.5,0.2,color,Enum.Material.Neon,false)
        console:SetAttribute("KinSkyAction","animate")
        console:SetAttribute("KinSkyMachineId",id)
        console:SetAttribute("KinSkyPlaceKey",key)
        console:SetAttribute("KinSkyStationTitle",topic[1+i])
        F.prompt(console,"Démontrer",topic[1+i])
        seat(section,base,x,91)
        lamp(section,base,x+side*10,92,key,i,color)
    end
    lift(section,base,key,38,56,"roof_to_sky")
    lift(section,base,key,56,38,"sky_to_roof")
    local lighting=block(section,"Console d'ambiance",base,-1,58.1,91,3.3,4,2.4,INK,Enum.Material.Metal)
    block(section,"Voyant d'ambiance",base,-1,59,89.7,2.3,2,0.2,color,Enum.Material.Neon,false)
    lighting:SetAttribute("KinSkyAction","lighting")
    lighting:SetAttribute("KinSkyPlaceKey",key)
    F.prompt(lighting,"Changer la lumière","Ambiance du pavillon")
    -- Borne réservée à une future capacité, distincte des vraies expériences locales.
    local future=block(section,"Terminal de la future exposition",base,5,58.2,91,3.3,4.2,2.2,INK,Enum.Material.Metal)
    block(section,"Écran du futur",base,5,58.8,89.8,2.4,2.4,0.2,GLASS,Enum.Material.Neon,false)
    future:SetAttribute("KinStubInteractionId",key..".sky.future.01")
    future:SetAttribute("KinStubCapabilityId","future."..key..".sky")
    future:SetAttribute("KinStubTitle",topic[1])
    F.prompt(future,"Consulter","Futures expositions")
    section:SetAttribute("KinSkyStations",2)
    return section
end
return Sky
