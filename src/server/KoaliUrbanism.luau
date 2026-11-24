--!strict
-- Koali v31 : ville-interface avec axes piétons, allées alignées et lots repérables.
-- Les pavillons sont des aperçus, pas des façades qui prétendent ouvrir des APIs.
-- Les huit vrais intérieurs et leurs portes restent gérés par WorldPlan.
local Factory=require(script.Parent.Factory)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local Urbanism={}
local TEAL=Districts.base
local STONE=Color3.fromRGB(207,218,209)
local INK=Color3.fromRGB(30,45,48)
local GOLD=Color3.fromRGB(181,149,94)
local preview={
    keenkonnect={
        {title="Konstruct",subtitle="Atelier des projets",owner="Konnaxion / keenKonnect"},
        {title="Stockage",subtitle="Plans et ressources versionnés",owner="Konnaxion / keenKonnect"},
        {title="Co-création",subtitle="Atelier des équipes",owner="Konnaxion / keenKonnect"},
    },
    ethikos={
        {title="Korum",subtitle="Arguments et délibération",owner="Konnaxion / ethiKos"},
        {title="Konsultations",subtitle="Consultation et propositions",owner="Konnaxion / ethiKos"},
        {title="Smart Vote",subtitle="Lectures distinctes des votes",owner="Konnaxion / Smart Vote"},
    },
    kreative={
        {title="Konservation",subtitle="Mémoire et patrimoine",owner="Konnaxion / Kreative"},
        {title="Kontact",subtitle="Réseaux et occasions",owner="Konnaxion / Kreative"},
        {title="Scène Kreative",subtitle="Créations collectives",owner="Konnaxion / Kreative"},
    },
    uckk={
        {title="Médiathèque",subtitle="Ressources et lectures",owner="Université King Klown"},
        {title="Activités",subtitle="Cours et ateliers",owner="Université King Klown"},
        {title="Agora du campus",subtitle="Rencontres et échanges",owner="Université King Klown"},
    },
    ekole={
        {title="Ekole",subtitle="Notions et activités",owner="Ekole"},
        {title="Kristal",subtitle="Artéfacts de savoir portables",owner="Kristal"},
        {title="Konstellation",subtitle="Lecteurs et perspectives",owner="Konstellation / lecture"},
    },
    konnected={
        {title="Knowledge",subtitle="Bibliothèque d'apprentissage",owner="Konnaxion / KonnectED"},
        {title="CertifiKation",subtitle="Évaluation et portfolios",owner="Konnaxion / KonnectED"},
        {title="KonnectED",subtitle="Parcours et mentorat",owner="Konnaxion / KonnectED"},
    },
}
local function piece(parent,name,size,cf,color,material,solid)
    local p=Factory.part(parent,name,size,cf,color,material)
    p.CanCollide=(solid==true)
    p.CanTouch=false
    p.CastShadow=solid==true
    return p
end
local function beam(parent,name,a,b,width,height,color,material)
    local d=b-a
    return piece(parent,name,Vector3.new(d.Magnitude,height,width),
        CFrame.new((a+b)*0.5)*CFrame.Angles(0,-math.atan2(d.Z,d.X),0),color,material,false)
end
local function occupied(x,z,structures,margin)
    for _,b in ipairs(structures) do
        local dx,dz=x-b.center_studs[1],z-b.center_studs[3]
        local theta=math.rad(b.yaw_degrees)
        local bx=math.cos(theta)*dx-math.sin(theta)*dz
        local bz=math.sin(theta)*dx+math.cos(theta)*dz
        if math.abs(bx)<b.footprint_studs[1]/2+margin and math.abs(bz)<b.footprint_studs[2]/2+margin then
            return true
        end
    end
    return false
end
local function directions(s)
    local axis=Vector3.new(s.x,0,s.z)
    local side=Vector3.new(-s.z,0,s.x)
    return axis,side
end
local function site(s,i,structures,chosen)
    local axis,side=directions(s)
    local radii={164,278,365}
    local r=radii[i]
    local polarity=if i==2 then -1 else 1
    -- Emplacements en façade d'allée : les fonctions occupent des parcelles
    -- régulières de 30×23 et ne bloquent jamais le boulevard de 20 studs.
    for _,rr in ipairs({r,r+24,r-24,r+42,r-42}) do
        for _,shift in ipairs({78,91,64,103,-78,-91,-64,-103}) do
            local v=axis*rr+side*shift*polarity
            if v.Magnitude<445 and math.abs(shift)>=64 and not occupied(v.X,v.Z,structures,27) then
                local safe=true
                for _,old in ipairs(chosen) do
                    if (old-v).Magnitude<49 then safe=false;break end
                end
                if safe then return v end
            end
        end
    end
    return nil
end
local function makeSites(structures)
    local chosen={}
    local result={}
    for _,s in ipairs(Districts.sections) do
        for i,info in ipairs(preview[s.key]) do
            local p=site(s,i,structures,chosen)
            if p then
                table.insert(chosen,p)
                table.insert(result,{section=s,info=info,index=i,position=p})
            else
                warn("Koali: parcelle ignorée, pas de dégagement pour "..s.key.." / "..info.title)
            end
        end
    end
    return result
end
local reserved={}
function Urbanism.isReserved(x,z)
    for _,v in ipairs(reserved) do
        if math.abs(x-v.X)<24 and math.abs(z-v.Z)<24 then return true end
    end
    local r=math.sqrt(x*x+z*z)
    if r>=58 and r<432 then
        local s=Districts.nearestAxis(x,z)
        if s then
            local side=Vector3.new(-s.z,0,s.x)
            local lateral=x*side.X+z*side.Z
            if math.abs(lateral)<32 then return true end
        end
    end
    return false
end
local function decorativeBench(parent,base,side,accent)
    piece(parent,"Banc – assise",Vector3.new(6,0.75,2.5),base*CFrame.new(side*30,1.6,0),STONE,Enum.Material.WoodPlanks,true)
    piece(parent,"Banc – dossier",Vector3.new(6,2,0.5),base*CFrame.new(side*30,2.45,1),accent,Enum.Material.Metal,true)
end
local function avenue(parent,s)
    local road=Factory.folder(parent,"Avenue "..s.name)
    road:SetAttribute("KinSection",s.key)
    road:SetAttribute("KinAvenueName","Avenue "..s.name)
    road:SetAttribute("KinInterfaceOf","Koali")
    local axis,side=directions(s)
    for i=1,19 do
        local r=62+(i-0.5)*20
        local location=axis*r
        local cf=CFrame.new(location+Vector3.new(0,0.36,0))*CFrame.Angles(0,math.atan2(s.x,s.z),0)
        piece(road,"Dalle piétonne",Vector3.new(19,0.35,20.03),cf,STONE,Enum.Material.Slate,true)
        for _,polarity in ipairs({-1,1}) do
            piece(road,"Bordure",Vector3.new(1,0.50,20.01),cf*CFrame.new(polarity*10.2,-0.01,0),TEAL,Enum.Material.Metal,false)
            local line=piece(road,"Filet identitaire",Vector3.new(0.30,0.22,19.9),cf*CFrame.new(polarity*8.65,0.27,0),s.lightColor,Enum.Material.Neon,false)
            if s.key=="kreative" then line:SetAttribute("KinKreativeCanvas",true) end
        end
    end
    -- Deux alignements lisibles de mobilier à intervalles réguliers.
    for n=1,8 do
        local r=99+n*37
        local centre=axis*r
        local base=CFrame.new(centre)*CFrame.Angles(0,math.atan2(s.x,s.z),0)
        for _,direction in ipairs({-1,1}) do
            local c=base*CFrame.new(direction*24,0,0)
            piece(road,"Mât de quartier",Vector3.new(0.75,8.4,0.75),c*CFrame.new(0,4.4,0),TEAL,Enum.Material.Metal,true)
            local collar=piece(road,"Bague du lampadaire",Vector3.new(1.1,0.34,1.1),c*CFrame.new(0,8.5,0),s.lightColor,Enum.Material.Neon,false)
            local lamp=piece(road,"Lanterne de quartier",Vector3.new(1.75,1.75,1.75),c*CFrame.new(0,9.05,0),s.lightColor,Enum.Material.Neon,false)
            lamp:SetAttribute("KinLightingSector",s.key)
            lamp:SetAttribute("KinLightingColor",s.lightColor:ToHex())
            if s.key=="kreative" then
                collar:SetAttribute("KinKreativeCanvas",true)
                lamp:SetAttribute("KinKreativeCanvas",true)
            end
            if n%2==0 then
                local light=Instance.new("PointLight")
                light.Name="Lueur du quartier"
                light.Brightness=0.42;light.Range=18;light.Color=s.lightColor;light.Shadows=false;light.Parent=lamp
                if s.key=="kreative" then light:SetAttribute("KinKreativeLight",true) end
            end
        end
        if n==2 or n==5 then
            decorativeBench(road,base,-1,s.color)
            decorativeBench(road,base,1,s.color)
        end
    end
    -- Grandes pancartes d’avenue retirées : l’architecture et les pavillons orientent les visiteurs.
    return road
end
local function pavilion(parent,siteRecord)
    local s=siteRecord.section
    local info=siteRecord.info
    local at=siteRecord.position
    local base=CFrame.new(at)*CFrame.Angles(0,math.atan2(s.x,s.z),0)
    local lot=Factory.folder(parent,"Allée "..info.title)
    lot:SetAttribute("KinKoaliPlace",info.title)
    lot:SetAttribute("KinSection",s.key)
    lot:SetAttribute("KinOwner",info.owner)
    lot:SetAttribute("KinBackendConnected",false)
    lot:SetAttribute("KinFunctionality","apercu_public_world_stub")
    local material=Enum.Material.Slate
    if s.material=="metal" then material=Enum.Material.Metal
    elseif s.material=="wood" then material=Enum.Material.WoodPlanks
    elseif s.material=="black_marble" then material=Enum.Material.Marble
    end
    piece(lot,"Esplanade de l'allée",Vector3.new(43,0.50,34),base*CFrame.new(0,0.30,0),STONE,Enum.Material.Slate,true)
    local axis=Vector3.new(s.x,0,s.z)
    local longitudinal=siteRecord.position:Dot(axis)
    local path=beam(lot,"Allée piétonne — "..info.title,
        axis*(longitudinal-18)+Vector3.new(0,0.54,0),
        at-axis*18+Vector3.new(0,0.54,0),7.5,0.25,STONE,Enum.Material.Slate)
    path.CanCollide=true
    piece(lot,"Façade réemployée",Vector3.new(30,12,15),base*CFrame.new(0,6.5,7),s.dark,material,true)
    local roof=piece(lot,"Toiture de quartier",Vector3.new(34,1.25,18),base*CFrame.new(0,12.8,7),s.color,Enum.Material.Metal,true)
    if s.key=="kreative" then roof:SetAttribute("KinKreativeCanvas",true) end
    local frieze=piece(lot,"Frise lumineuse de quartier",Vector3.new(31,0.6,1),base*CFrame.new(0,10.7,-1),s.lightColor,Enum.Material.Neon,false)
    if s.key=="kreative" then frieze:SetAttribute("KinKreativeCanvas",true) end
    for n=-2,2 do
        piece(lot,"Colonnade alignée",Vector3.new(1.25,8.5,1.25),base*CFrame.new(n*5.2,5,-1),
            if s.material=="monochrome" and n%2==0 then s.pale else s.secondary,material,true)
    end
    if s.material=="black_marble" then
        for n=-2,2 do
            piece(lot,"Veines dorées",Vector3.new(0.14,9,0.22),base*CFrame.new(n*5.2+1.1,6.3,-1.56)*CFrame.Angles(0,0,0.3),GOLD,Enum.Material.Metal,false)
        end
    end
    local entrance=piece(lot,"Totem de découverte",Vector3.new(5.5,4,2),base*CFrame.new(0,2.3,-13),TEAL,Enum.Material.Metal,true)
    entrance:SetAttribute("KinStubInteractionId","koali.preview."..s.key.."."..siteRecord.index)
    entrance:SetAttribute("KinStubCapabilityId","koali.preview.information")
    entrance:SetAttribute("KinStubTitle",info.title)
    Factory.prompt(entrance,"Découvrir",info.title)
    local panel=Factory.sign(lot,"Enseigne de l'allée",(base*CFrame.new(0,16.3,-1.5)).Position,
        math.deg(math.atan2(s.x,s.z)),info.title,24,3.2)
    panel.CanCollide=false
    -- Un marqueur ne simule pas le branchement à Orgo, Moodle, Konstellation ou Konnaxion.
    return lot
end
function Urbanism.make(city,plan)
    local root=Factory.folder(city,"KOALI • urbanisme d'allées brandées")
    root:SetAttribute("KinCityPurpose","interface spatiale pour Koali")
    root:SetAttribute("KinWorldStub",true)
    root:SetAttribute("KinLayoutVersion","koali-hex-urban-v31")
    root:SetAttribute("KinColor","#1E6864")
    for _,s in ipairs(Districts.sections) do avenue(root,s) end
    reserved={}
    local sites=makeSites(plan.structures)
    local gallery=Factory.folder(root,"18 lieux thématiques • vues d'ensemble")
    for _,lot in ipairs(sites) do
        table.insert(reserved,lot.position)
        pavilion(gallery,lot)
    end
    root:SetAttribute("KinPreviewPavilions",#sites)
    local guide=Factory.folder(root,"Orientation de Koali")
    local stand=piece(guide,"Borne Ariane — accueil",Vector3.new(4.5,5.7,3.6),
        CFrame.new(12,3,14),TEAL,Enum.Material.Metal,true)
    stand:SetAttribute("KinStubInteractionId","koali.ariane.introduction")
    stand:SetAttribute("KinStubCapabilityId","koali.preview.navigation")
    stand:SetAttribute("KinStubTitle","Ariane — navigation sémantique")
    Factory.prompt(stand,"Explorer","Ariane")
    -- Place centrale volontairement libre des panneaux KIN CITY géants.
    return root
end
return Urbanism
