--!strict
-- V25 : grammaire architecturale des quartiers existants.
-- Chaque détail est statique, sans collision, sans lumière dynamique ni script par pièce.
-- Aucun passage, escalier, terminal ou porte n'est déplacé.
local Kit=require(script.Parent.CrystalKit)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Architecture={}

local function decor(parent,name,size,cf,color,material,optional)
    local item=Kit.part(parent,"Part",name,size,cf,color,material or Enum.Material.Slate)
    if optional then item:SetAttribute("KinOptionalDetail",true) end
    item:SetAttribute("KinV25Architecture",true)
    return item
end
local function folder(model,role)
    local previous=model:FindFirstChild("Architecture de quartier v25")
    if previous then previous:Destroy() end
    local root=Instance.new("Folder")
    root.Name="Architecture de quartier v25"
    root:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    root:SetAttribute("KinArchitectureRole",role)
    root.Parent=model
    return root
end
local function mesh(parent,name,key,size,cf,color)
    local result=Meshes.decorate(parent,name,key,size,cf,color)
    if result then result:SetAttribute("KinV25Architecture",true) end
    return result
end
local function upperFrame(root,base,w,d,height)
    -- Périmètre de toiture; les rails sont à l'extérieur du mur et au-dessus du toit.
    for _,side in ipairs({-1,1}) do
        decor(root,"Bande de corniche avant/arrière",Vector3.new(w+0.9,0.3,0.35),
            base*CFrame.new(0,height,side*(d*0.5+0.31)),Kit.gold,Enum.Material.Metal,true)
        decor(root,"Corniche latérale",Vector3.new(0.35,0.3,d),
            base*CFrame.new(side*(w*0.5+0.31),height,0),Kit.primary,Enum.Material.Metal,true)
    end
end
local function facadePanels(root,base,w,front,top,count,accent)
    for index=1,count do
        local x=(index-(count+1)*0.5)*(w*0.27)
        local p=decor(root,"Pilastre et prisme opalin",Vector3.new(0.38,4.2,0.25),
            base*CFrame.new(x,top-2.2,front-0.22),Kit.primary,Enum.Material.Metal,true)
        decor(root,"Incrustation de pilastre",Vector3.new(0.14,2.4,0.1),
            p.CFrame*CFrame.new(0,0,-0.2),accent,Enum.Material.Neon,true)
    end
end
local function crest(root,base,front,top,width,accent,asset)
    -- Toujours au-dessus du linteau d'entrée : aucune obstruction de passage.
    mesh(root,"Emblème du lieu",asset or "crystal_rosette",Vector3.new(width,width,0.65),
        base*CFrame.new(0,top,front),accent)
end

-- Six halles et six maisons communautaires : nef, couronnement, rosace.
function Architecture.hall(model,base,kind,color)
    local market=kind=="market"
    local w=if market then 46 else 38
    local d=if market then 58 else 43
    local root=folder(model,if market then "marché" else "maison communautaire")
    local front=-d*0.5-0.7
    upperFrame(root,base,w,d,17.25)
    facadePanels(root,base,w,front,11.8,if Kit.profile=="LITE" then 2 else 4,color)
    crest(root,base,front-0.40,14.8,if market then 4.5 else 4.1,color,"crystal_rosette")
    if Kit.profile~="LITE" then
        mesh(root,"Fronton de nef","mineral_pediment",Vector3.new(w*0.30,4.4,0.48),
            base*CFrame.new(0,19.5,front+0.4),Kit.primary)
    end
    -- Deux axes opalins sur le toit ; pas de nouvelles PointLight.
    for _,side in ipairs({-1,1}) do
        local x=side*w*0.34
        decor(root,"Contrefort haut",Vector3.new(1.0,1.4,d*0.72),
            base*CFrame.new(x,17.8,0),Kit.deep,Enum.Material.Slate,true)
        if Kit.profile~="LITE" then
            mesh(root,"Épi de toiture", "opal_spire", Vector3.new(2.8,5.1,2.8),
                base*CFrame.new(x,20.5,-d*0.27),if market then Kit.opal else color)
        end
    end
    if Kit.profile=="SHOWCASE" then
        for _,z in ipairs({-d*0.25,0,d*0.25}) do
            decor(root,"Rainure de nef",Vector3.new(w*0.65,0.16,0.32),
                base*CFrame.new(0,17.65,z),Kit.gold,Enum.Material.Metal,true)
        end
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Neuf boutiques de promenade : silhouette d'atelier et enseigne minérale.
function Architecture.boutique(model,base,style,accent)
    local root=folder(model,"boutique-"..tostring(style))
    upperFrame(root,base,17,21,14.0)
    for _,side in ipairs({-1,1}) do
        decor(root,"Fronton oblique",Vector3.new(6.0,0.42,0.55),
            base*CFrame.new(side*4.3,14.9,-10.95)*CFrame.Angles(0,0,side*math.rad(21)),
            Kit.primary,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            mesh(root,"Résille de métier","opal_lattice",Vector3.new(3.7,3.7,0.3),
                base*CFrame.new(side*5.8,8.4,-10.98),accent)
        end
    end
    local peak=if style=="ceramics" then "opal_spire" else "mineral_column"
    mesh(root,"Clé du faîtage",peak,Vector3.new(2.15,3.1,2.15),
        base*CFrame.new(0,15.25,3),accent)
    if Kit.profile=="SHOWCASE" then
        for n=1,3 do
            decor(root,"Lumière du métier",Vector3.new(0.2,0.2,2.3),
                base*CFrame.new(-5+n*2.5,14.52,-9.1),Kit.opal,Enum.Material.Neon,true)
        end
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Huit ateliers de gare : rythme de marquise sans ajouter une deuxième façade.
function Architecture.arcade(model,base,seed,accent)
    local root=folder(model,"atelier de gare")
    upperFrame(root,base,18,18,12.2)
    for _,side in ipairs({-1,1}) do
        decor(root,"Nervure de marquise",Vector3.new(0.46,0.44,6.0),
            base*CFrame.new(side*7.4,12.4,-10.4),Kit.gold,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            mesh(root,"Jeton d'atelier","opal_lattice",Vector3.new(2.2,2.2,0.4),
                base*CFrame.new(side*6.2,8.1,-9.55),accent)
        end
    end
    local count=if Kit.profile=="SHOWCASE" then 5 else 3
    for n=1,count do
        decor(root,"Trame opaline de lanterneau",Vector3.new(0.26,0.14,3.9),
            base*CFrame.new((n-(count+1)/2)*2.2,12.22,-3.0),
            if (n+seed)%2==0 then Kit.opal else Kit.gold,Enum.Material.Metal,true)
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Vingt-quatre maisons : gardent leur accès sur deux niveaux et leurs jardins de toit.
function Architecture.home(model,base,variant,seed)
    local root=folder(model,"maison-"..tostring(variant))
    local accent=if variant=="culture" then Kit.gold elseif variant=="atelier" then Kit.opal else Kit.medium
    -- Bordure de terrasse avant; éviter la végétation sur le toit à l'arrière (Z positif).
    for _,side in ipairs({-1,1}) do
        decor(root,"Fronton résidentiel",Vector3.new(6.0,0.36,0.48),
            base*CFrame.new(side*5.4,23.8,-10.65)*CFrame.Angles(0,0,side*math.rad(18)),
            accent,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            decor(root,"Gemme de lucarne",Vector3.new(1.15,1.15,0.25),
                base*CFrame.new(side*7.7,21.2,-12.2)*CFrame.Angles(0,0,math.rad(45)),
                Kit.opal,Enum.Material.Slate,true)
        end
    end
    if Kit.profile=="SHOWCASE" and seed%2==0 then
        mesh(root,"Petite clef de toit","opal_spire",Vector3.new(1.5,2.4,1.5),
            base*CFrame.new(0,25.4,-10),accent)
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Quatre ateliers maritimes : couronnement de façade et petit mât non fonctionnel.
function Architecture.marina(model,base,index)
    local root=folder(model,"atelier maritime")
    -- Façade ouverte à Z=+12 : les décorations restent au-dessus de son ouverture.
    for _,side in ipairs({-1,1}) do
        decor(root,"Traverse du port",Vector3.new(7.3,0.45,0.32),
            base*CFrame.new(side*7.0,11.7,12.45),Kit.gold,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            mesh(root,"Ancre minérale abstraite","mineral_column",Vector3.new(1.5,3.4,1.5),
                base*CFrame.new(side*9.2,13.8,-8.0),Kit.primary)
        end
    end
    mesh(root,"Emblème de marin","harbor_crest",Vector3.new(4.1,3.8,0.48),
        base*CFrame.new(0,14.2,12.52),Kit.gold)
    mesh(root,"Éclat de vigie","opal_spire",Vector3.new(2.4,3.8,2.4),
        base*CFrame.new(0,14.6,0),if index==1 then Kit.opal else Kit.gold)
    model:SetAttribute("KinV25Facade",true)
    return root
end
return Architecture
