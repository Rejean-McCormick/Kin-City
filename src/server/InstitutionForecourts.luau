--!strict
-- V5 — Cours publiques accessibles et différenciées pour les huit institutions.
-- Géométrie totalement locale. Les bornes métier restent des stubs.
local F = require(script.Parent.Factory)
local Districts=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("HexagonalDistricts"))
local Courts = {}
local STONE = Color3.fromRGB(213,201,173)
local DARK = Color3.fromRGB(30,104,100)
local WOOD = Color3.fromRGB(147,104,70)
local BRASS = Color3.fromRGB(188,149,91)

local function block(parent,name,base,x,y,z,sx,sy,sz,color,material,collision)
    local part = F.part(parent,name,Vector3.new(sx,sy,sz),base*CFrame.new(x,y,z),color,material)
    if collision==false then part.CanCollide=false;part.CastShadow=false end
    return part
end
local function sphere(parent,name,base,x,y,z,size,color)
    local p=block(parent,name,base,x,y,z,size,size,size,color,Enum.Material.Glass,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function torusApprox(parent,base,radius,height,color)
    for i=1,16 do
        local a=i*math.pi*2/16
        local b=(i+1)*math.pi*2/16
        local mid=(a+b)/2
        local chord=2*radius*math.sin(math.pi/16)+0.18
        local p=block(parent,"Anneau du savoir",base,math.cos(mid)*radius,height,math.sin(mid)*radius,chord,0.75,0.75,color,Enum.Material.Metal,false)
        p.CFrame=base*CFrame.new(math.cos(mid)*radius,height,math.sin(mid)*radius)*CFrame.Angles(0,-mid-math.pi/2,0)
    end
end
local themes={
    ["central.city_hall"]={label="Parvis des citoyens",kind="assembly",color=Color3.fromRGB(197,168,106)},
    ["central.ekoh_tower"]={label="Jardin des connaissances",kind="spiral",color=Color3.fromRGB(97,196,185)},
    ["ethikos.justice_palace"]={label="Cour de la délibération",kind="balance",color=Color3.fromRGB(182,150,115)},
    ["keenkonnect.innovation_lab"]={label="Cour des inventions",kind="lab",color=Color3.fromRGB(96,180,190)},
    ["konnected.library"]={label="Parvis des lecteurs",kind="books",color=Color3.fromRGB(140,175,206)},
    ["konnected.university"]={label="Jardin astronomique",kind="astronomy",color=Color3.fromRGB(184,163,212)},
    ["kreative.museum"]={label="Cour des arts",kind="arts",color=Color3.fromRGB(214,146,134)},
    ["orgo.admin_center"]={label="Place des échanges",kind="nodes",color=Color3.fromRGB(128,173,199)},
}

local function candidate(structure,side)
    local x,_,z=table.unpack(structure.center_studs)
    local w=structure.footprint_studs[1]
    local angle=math.rad(structure.yaw_degrees)
    local orientation=CFrame.new(x,0,z)*CFrame.Angles(0,angle,0)
    return orientation*CFrame.new(side*(w/2+36),0,0)
end

local function overlaps(position,structures,owner)
    local x,z=position.X,position.Z
    if math.sqrt(x*x+z*z)>452 then return true end
    for _,b in ipairs(structures) do
        if b.building_id~=owner then
            local cx,_,cz=table.unpack(b.center_studs)
            local a=math.rad(b.yaw_degrees)
            local dx,dz=x-cx,z-cz
            local lx=math.cos(a)*dx-math.sin(a)*dz
            local lz=math.sin(a)*dx+math.cos(a)*dz
            if math.abs(lx)<b.footprint_studs[1]/2+32 and math.abs(lz)<b.footprint_studs[2]/2+29 then return true end
        end
    end
    return false
end

local function choose(structure,structures)
    -- Recherche déterministe d'un côté dont le parvis ne heurte pas les autres institutions.
    for _,side in ipairs({1,-1}) do
        local cf=candidate(structure,side)
        if not overlaps(cf.Position,structures,structure.building_id) then return cf,side end
    end
    return nil,nil
end
function Courts.isReserved(x,z,structures)
    for _,structure in ipairs(structures) do
        local cf=choose(structure,structures)
        if cf then
            local p=cf:PointToObjectSpace(Vector3.new(x,0,z))
            if math.abs(p.X)<27 and math.abs(p.Z)<23 then return true end
        end
    end
    return false
end

local function seat(parent,base,x,z,accent)
    block(parent,"Banc du parvis",base,x,1.5,z,7,0.55,2.6,WOOD,Enum.Material.WoodPlanks,true)
    block(parent,"Dossier de banc",base,x,2.8,z+1,7,2.1,0.45,accent,Enum.Material.Metal,true)
    for _,s in ipairs({-1,1}) do
        block(parent,"Pied de banc",base,x+s*2.6,0.7,z,0.6,1.4,2.1,DARK,Enum.Material.Metal,true)
    end
end
local function planter(parent,base,x,z,index)
    block(parent,"Bac fleuri",base,x,0.8,z,4.5,1.6,4.5,STONE,Enum.Material.Marble,true)
    for i=1,5 do
        local a=i*math.pi*2/5
        local px,pz=x+math.cos(a)*1.35,z+math.sin(a)*1.35
        block(parent,"Tige du jardin",base,px,2.25,pz,0.24,2.3,0.24,Color3.fromRGB(51,132,79),Enum.Material.Grass,false)
        sphere(parent,"Fleur",base,px,3.45,pz,1.2,Color3.fromHSV((index+i*0.14)%1,0.55,0.9))
    end
end
local function centerpiece(parent,base,theme)
    local accent=theme.color
    block(parent,"Socle patrimonial",base,0,1,2,16,2,14,STONE,Enum.Material.Marble,true)
    local kind=theme.kind
    if kind=="assembly" then
        for i=-3,3 do
            block(parent,"Siège de l'assemblée",base,i*2.2,3.2,2,1.9,2.2,2.5,DARK,Enum.Material.WoodPlanks,true)
            block(parent,"Dossier civique",base,i*2.2,4.3,3.1,1.9,2.2,0.5,accent,Enum.Material.Metal,false)
        end
        block(parent,"Tribune",base,0,4.3,-3.5,6,4,2,accent,Enum.Material.Marble,true)
    elseif kind=="spiral" then
        for i=1,14 do
            local a=i*0.55
            sphere(parent,"Connaissance",base,math.cos(a)*4,2.8+i*0.65,2+math.sin(a)*3.5,1.9,Color3.fromHSV(i/16,0.42,0.9))
        end
        torusApprox(parent,base,6,8,accent)
    elseif kind=="balance" then
        block(parent,"Colonne de justice",base,0,5.5,2,1.4,9,1.4,accent,Enum.Material.Marble,true)
        block(parent,"Fléau",base,0,10,2,13,0.65,0.65,BRASS,Enum.Material.Metal,false)
        for _,x in ipairs({-5,5}) do
            block(parent,"Chaîne",base,x,7.8,2,0.26,4,0.26,BRASS,Enum.Material.Metal,false)
            block(parent,"Plateau",base,x,5.8,2,4.3,0.5,3.7,STONE,Enum.Material.Marble,false)
        end
    elseif kind=="lab" then
        block(parent,"Colonne d'énergie",base,0,7,2,3.2,12,3.2,DARK,Enum.Material.Metal,true)
        for i=1,6 do
            local a=i*math.pi/3
            local p=sphere(parent,"Atome lumineux",base,math.cos(a)*5,7+math.sin(a)*2.6,2+math.sin(a)*5,2.2,accent)
            p.Material=Enum.Material.Neon
        end
        torusApprox(parent,base,6,8,BRASS)
    elseif kind=="books" then
        for i=-3,3 do
            local height=5+(i+7)%4*1.4
            block(parent,"Livre monumental",base,i*1.8,2+height/2,2,1.5,height,6,Color3.fromHSV((i+5)*0.11,0.34,0.82),Enum.Material.Marble,true)
            block(parent,"Dos doré",base,i*1.8,2+height/2,-1.1,0.35,height-0.5,0.22,BRASS,Enum.Material.Metal,false)
        end
    elseif kind=="astronomy" then
        sphere(parent,"Soleil",base,0,10,2,5,Color3.fromRGB(255,205,104)).Material=Enum.Material.Neon
        for i=1,6 do
            local a=i*1.07
            sphere(parent,"Planète",base,math.cos(a)*5,6+(i%3)*2,2+math.sin(a)*4,1.6+(i%3)*0.5,Color3.fromHSV(i/7,0.52,0.86))
        end
        torusApprox(parent,base,6,5,accent)
    elseif kind=="arts" then
        for i=-2,2 do
            block(parent,"Colonne d'art",base,i*2.5,4,2,1.3,5,1.3,STONE,Enum.Material.Marble,true)
            local p=block(parent,"Sculpture",base,i*2.5,7,2,2.8,3,2.8,Color3.fromHSV((i+3)/6,0.5,0.9),Enum.Material.Metal,false)
            p.CFrame=p.CFrame*CFrame.Angles(0,math.rad(20*i),math.rad(35+i*12))
        end
    else
        for i=1,8 do
            local a=i*math.pi/4
            sphere(parent,"Noeud du réseau",base,math.cos(a)*5,6,2+math.sin(a)*4,2.2,accent)
            block(parent,"Connecteur vertical",base,math.cos(a)*5,3,2+math.sin(a)*4,0.5,5,0.5,DARK,Enum.Material.Metal,false)
        end
    end
end

function Courts.make(city,plan)
    local root=F.folder(city,"Parvis des institutions")
    local count=0
    for _,structure in ipairs(plan.structures) do
        local original=themes[structure.building_id]
        local district=Districts.byKey(structure.district_id)
        local theme=if original then {
            label=original.label,kind=original.kind,
            color=if district then district.lightColor else original.color,
        } else nil
        local cf,side=choose(structure,plan.structures)
        if theme and cf and side then
            local m=Instance.new("Model")
            m.Name=theme.label
            m:SetAttribute("KinPublicSpaceId","court."..structure.building_id)
            m.Parent=root
            local accent=theme.color
            block(m,"Pavement de cour",cf,0,0.18,0,46,0.35,33,STONE,Enum.Material.Cobblestone,false)
            for _,s in ipairs({-1,1}) do
                block(m,"Bordure du parvis",cf,0,0.45,s*16.5,46,0.8,0.65,BRASS,Enum.Material.Marble,true)
                seat(m,cf,s*16,-9,accent)
                planter(m,cf,s*16,9,s+4)
                block(m,"Colonnade du parvis",cf,s*21,5,-6,1,10,1,accent,Enum.Material.Marble,true)
                block(m,"Arche latérale",cf,s*21,10,0,1.8,1,15,accent,Enum.Material.Marble,false)
            end
            centerpiece(m,cf,theme)
            local console=block(m,"Console d'accueil",cf,11,2.4,-12,4.2,4.8,2.3,DARK,Enum.Material.Metal,true)
            block(m,"Écran informatif",cf,11,3.1,-13.25,3.3,2.2,0.18,accent,Enum.Material.Neon,false)
            local id="court."..structure.building_id..".terminal"
            console:SetAttribute("KinStubInteractionId",id)
            console:SetAttribute("KinStubCapabilityId","future."..structure.building_id..".outdoor")
            console:SetAttribute("KinStubTitle",theme.label)
            F.prompt(console,"Consulter",theme.label)
            -- La cour conserve ses ornements et sa borne; pas de seconde enseigne géante.
            -- Belvédère fonctionnel : la caméra observe la façade depuis le parvis.
            local marker=block(m,"Longue-vue",cf,-15,2.4,-10,2.6,4.7,2.6,DARK,Enum.Material.Metal,true)
            block(m,"Lentille",cf,-15,4.3,-11.6,2.1,1.1,1.1,accent,Enum.Material.Glass,false)
            marker:SetAttribute("KinVistaId","vista.court."..structure.building_id)
            marker:SetAttribute("KinVistaTitle",theme.label)
            marker:SetAttribute("KinVistaCameraPosition",(cf*CFrame.new(-8,15,-25)).Position)
            marker:SetAttribute("KinVistaLookAt",Vector3.new(structure.center_studs[1],13,structure.center_studs[3]))
            F.prompt(marker,"Observer",theme.label)
            -- Connexion piétonne vers le côté du bâtiment sans téléportation.
            local b= CFrame.new(structure.center_studs[1],0,structure.center_studs[3]) * CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
            block(m,"Allée de liaison",b,side*(structure.footprint_studs[1]/2+15),0.2,0,31,0.35,7,STONE,Enum.Material.Cobblestone,false)
            count+=1
        end
    end
    root:SetAttribute("KinForecourtsCreated",count)
    return root
end
return Courts
