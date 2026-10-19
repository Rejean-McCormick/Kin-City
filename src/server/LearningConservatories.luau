--!strict
-- Huit pavillons d'expérimentation, construits en matériaux Roblox natifs.
-- Activités pédagogiques locales, indépendantes des cours et API kOA.
local F=require(script.Parent.Factory)
local Pavilions={}
local TEAL=Color3.fromRGB(42,77,82)
local BRASS=Color3.fromRGB(201,170,110)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local themes=require(Shared:WaitForChild("PublicDestinations"))
local function part(m,name,base,x,y,z,w,h,d,c,material,solid)
    local p=F.part(m,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),c,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false end
    return p
end
local function model(root,id,name)
    local m=Instance.new("Model");m.Name=name;m:SetAttribute("KinScienceExhibitId",id);m.Parent=root
    return m
end
local function sphere(m,name,base,x,y,z,size,c)
    local p=part(m,name,base,x,y,z,size,size,size,c,Enum.Material.Neon,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function exhibit(parent,base,theme,index)
    local modelRoot=model(parent,"kin.science."..theme.kind,theme.title)
    part(modelRoot,"Socle de manipulation",base,0,1.6,-1,8.6,3.2,7.2,TEAL,Enum.Material.Marble,true)
    local front=part(modelRoot,"Console d'expérience",base,0,3.4,-4.6,5,3,1.2,BRASS,Enum.Material.Metal,true)
    front:SetAttribute("KinScienceExhibitId","kin.science."..theme.kind)
    front:SetAttribute("KinScienceKind",theme.kind)
    F.prompt(front,"Expérimenter",theme.title)
    local orb=sphere(modelRoot,"Noyau lumineux",base,0,5,-1,3,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]))
    orb:SetAttribute("KinScienceLight",true)
    orb.Transparency=0.6
    local light=Instance.new("PointLight")
    light.Color=Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]);light.Range=15;light.Brightness=0.2;light.Parent=orb
    if theme.kind=="astronomy" then
        for i=1,5 do
            local a=2*math.pi*i/5
            local p=sphere(modelRoot,"Planète orbitale",base,math.cos(a)*(3.5+i*0.35),4.5+math.sin(a)*1.1,math.sin(a)*(3.5+i*0.35),1.0+(i%2)*0.5,Color3.fromHSV(i/6,0.6,0.9))
            p:SetAttribute("KinScienceRotor",true)
        end
    elseif theme.kind=="optics" then
        for i=1,7 do
            local beam=part(modelRoot,"Spectre",base,(i-4)*0.7,5.1,2,0.45,0.5,7,Color3.fromHSV(i/7,0.9,1),Enum.Material.Neon,false)
            beam:SetAttribute("KinScienceLight",true);beam.Transparency=0.83
        end
    elseif theme.kind=="water" then
        for i=1,6 do
            local blade=part(modelRoot,"Roue hydraulique",base,math.cos(i*math.pi/3)*3,4.9,math.sin(i*math.pi/3)*3-1,3.3,0.45,0.65,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Metal,false)
            blade:SetAttribute("KinScienceRotor",true)
        end
    elseif theme.kind=="energy" then
        for i=1,5 do
            local circuit=part(modelRoot,"Circuit électroluminescent",base,-4+i*1.8,4.2,1.8,1.0,0.15,5,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Neon,false)
            circuit:SetAttribute("KinScienceLight",true);circuit.Transparency=0.82
        end
    elseif theme.kind=="engineering" then
        local lever=part(modelRoot,"Levier mécanique",base,0,5.3,1.5,10,0.55,0.75,BRASS,Enum.Material.Metal,false)
        lever:SetAttribute("KinScienceRotor",true)
        for _,side in ipairs({-1,1}) do
            sphere(modelRoot,"Contrepoids",base,side*4.7,4.25,1.5,1.8,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]))
        end
    elseif theme.kind=="sound" then
        for i=1,7 do
            local chime=part(modelRoot,"Tube vibrant",base,(i-4)*1.2,6.2-(i%3)*0.6,2.6,0.42,5.3+(i%3),0.45,BRASS,Enum.Material.Metal,false)
            chime:SetAttribute("KinScienceRotor",true)
        end
    else
        for i=1,7 do
            local a=i*2.399963
            local bud=sphere(modelRoot,"Organisme",base,math.cos(a)*3.5,4.5+(i%3),math.sin(a)*2.8+0.5,1.1+(i%2)*0.8,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]))
            bud:SetAttribute("KinScienceLight",true);bud.Transparency=0.35
        end
    end
end
local function pavilion(root,theme,index)
    local angle=theme.angle
    local center=Vector3.new(theme.center_studs[1],0.15,theme.center_studs[3])
    local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-angle,0)
    local m=model(root,theme.id,theme.title)
    part(m,"Plancher de la serre",base,0,-0.33,0,29,0.7,32,Color3.fromRGB(221,208,174),Enum.Material.Marble,true)
    -- Trois murs vitrés; la façade sud demeure largement ouverte.
    for _,x in ipairs({-14,14}) do
        for _,z in ipairs({-13,0,13}) do
            part(m,"Poteau de serre",base,x,8,z,0.8,16,0.8,TEAL,Enum.Material.Metal,true)
        end
        local glass=part(m,"Verrière latérale",base,x,9,0,0.2,14,26,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Glass,false)
        glass.Transparency=0.69
    end
    for _,x in ipairs({-12,0,12}) do
        part(m,"Poutre du fond",base,x,8,15,0.8,16,0.8,TEAL,Enum.Material.Metal,true)
    end
    local rear=part(m,"Verrière du fond",base,0,8,15,25,14,0.2,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Glass,false)
    rear.Transparency=0.72
    -- Toit en couronne : lumière et ciel visibles du centre.
    for _,x in ipairs({-10,10}) do part(m,"Bande vitrée supérieure",base,x,16,0,8.5,0.65,32,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Glass,false).Transparency=0.35 end
    for _,z in ipairs({-13,13}) do part(m,"Linteau supérieur",base,0,16,z,29,0.7,2.4,TEAL,Enum.Material.Metal,true) end
    for _,x in ipairs({-11,11}) do
        local s=Instance.new("Seat")
        s.Name="Siège d'observation";s.Size=Vector3.new(3.6,0.8,3.0)
        s.CFrame=base*CFrame.new(x,1.1,-9);s.Anchored=true;s.Material=Enum.Material.WoodPlanks;s.Color=Color3.fromRGB(162,122,82);s.Parent=m
    end
    for _,x in ipairs({-10,10}) do for _,z in ipairs({-3,7}) do
        part(m,"Jardinière",base,x,1.2,z,3.3,2.2,4.0,Color3.fromRGB(117,95,76),Enum.Material.Slate,true)
        local leaf=part(m,"Plante pédagogique",base,x,3.15,z,3.9,3.5,3.9,Color3.fromRGB(67+index*8,157,111),Enum.Material.Grass,false)
        leaf.Shape=Enum.PartType.Ball
    end end
    exhibit(m,base,theme,index)
    local label=F.sign(m,"Enseigne du pavillon",(base*CFrame.new(0,14,-16.7)).Position,math.deg(math.pi/2-angle),theme.title,23,3)
    label.CanCollide=false
    -- Alignement de pierres entre les promenades et l'entrée.
    for j=1,5 do
        part(m,"Pas japonais",base,0,-0.08,-17-j*2,4.4,0.2,1.6,Color3.fromRGB(227,215,185),Enum.Material.Cobblestone,false)
    end
end
function Pavilions.make(city)
    local root=F.folder(city,"Pavillons scientifiques publics")
    for i,theme in ipairs(themes) do pavilion(root,theme,i) end
    root:SetAttribute("KinSciencePavilions",#themes)
    return root
end
function Pavilions.isReserved(x,z)
    for index=1,#themes do
        local dx=x-themes[index].center_studs[1]
        local dz=z-themes[index].center_studs[3]
        if dx*dx+dz*dz<35*35 then return true end
    end
    return false
end
return Pavilions
