--!strict
-- Ailes supérieures, promenades panoramiques et escaliers réellement franchissables.
-- Les étages sont intégrés au même modèle et ne requièrent aucun asset / service externe.
local F=require(script.Parent.Factory)
local Vertical={}
local Roof=require(script.Parent.RooftopGardens)
local ArtAssets=require(script.Parent.ArtDecoAssets)
local ArtData=require(script.Parent.ArtDecoData)
local Buildings=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared").Buildings)
local function block(parent,name,origin,size,x,y,z,color,material)
    return F.part(parent,name,size,CFrame.new(origin+Vector3.new(x,y,z)),color,material)
end
local function panel(parent,origin,key,x,z,accent,title,index)
    local booth=block(parent,"Borne étage "..index,origin,Vector3.new(3.3,4.5,2.2),x,20.6,z,Color3.fromRGB(39,61,73),Enum.Material.Metal)
    local face=block(parent,"Écran interactif",origin,Vector3.new(2.7,2.8,0.2),x,21.2,z-1.2,accent,Enum.Material.Neon)
    face.CanCollide=false
    booth:SetAttribute("KinStubInteractionId",key..".level2.terminal."..index)
    booth:SetAttribute("KinStubCapabilityId","future."..key..".level2")
    booth:SetAttribute("KinStubTitle",title)
    F.prompt(booth,"Consulter",title)
end
local function bookGallery(parent,origin,key,accent,trim)
    -- Galeries de deuxième niveau, bordées d'une balustrade côté atrium.
    for _,s in ipairs({-1,1}) do
        local x=s*34
        block(parent,"Mezzanine latérale",origin,Vector3.new(30,1,49),x,17.5,75,trim,Enum.Material.Marble)
        for z=55,94,8 do
            block(parent,"Poteau de galerie",origin,Vector3.new(0.45,4,0.45),s*18.3,20.1,z,accent,Enum.Material.Metal)
        end
        block(parent,"Main courante",origin,Vector3.new(0.7,0.65,45),s*18.3,22.3,75,accent,Enum.Material.Metal)
        -- On garde le bord intérieur ouvert et une vue sur le rez-de-chaussée.
        for n=1,3 do
            local zz=56+(n-1)*18
            local lamp=block(parent,"Luminaire galerie",origin,Vector3.new(0.45,0.6,0.45),s*34,31,zz,Color3.fromRGB(253,218,145),Enum.Material.Neon)
            lamp.CanCollide=false
        end
    end
    block(parent,"Passerelle arrière",origin,Vector3.new(37,1,10),0,17.5,95,trim,Enum.Material.Marble)
    block(parent,"Balustrade passerelle",origin,Vector3.new(34,4,0.65),0,20.2,90.5,accent,Enum.Material.Metal)
    panel(parent,origin,key,-35,68,accent,"Collections supérieures",1)
    panel(parent,origin,key,35,68,accent,"Salle de recherche",2)
    panel(parent,origin,key,0,96,accent,"Observatoire des connaissances",3)
end
local function stairs(parent,origin,key,x,accent,stone)
    -- 26 marches : hauteur 0,69, giron 1,4. Les volumes sont jointifs.
    -- Chaque marche est un socle plein : pas de plancher invisible entre deux marches.
    local steps=26
    local rise=18/steps
    local depth=1.45
    local startZ=49
    for i=1,steps do
        local height=rise*i
        local z=startZ+(i-0.5)*depth
        block(parent,"Marche "..i,origin,Vector3.new(7.4,height,depth+0.08),x,height/2,z,stone,Enum.Material.Marble)
        if i%3==0 then
            for _,side in ipairs({-1,1}) do
                block(parent,"Montant d'escalier",origin,Vector3.new(0.25,3,0.25),x+side*4.1,height+1.5,z,accent,Enum.Material.Metal).CanCollide=false
            end
        end
    end
    for _,side in ipairs({-1,1}) do
        -- Barrières non bloquantes en hauteur, sans gêner la montée.
        block(parent,"Main courante escalier",origin,Vector3.new(0.3,0.4,37),x+side*4.25,12,68,accent,Enum.Material.Metal).CanCollide=false
    end
end
local function upperFurniture(parent,origin,key,accent)
    local colors={Color3.fromRGB(106,75,51),Color3.fromRGB(47,74,82)}
    for _,s in ipairs({-1,1}) do
        for n=1,3 do
            local x=s*(26+(n%2)*8)
            local z=56+(n-1)*13
            block(parent,"Table étude étage",origin,Vector3.new(7,0.55,4),x,20.4,z,colors[1],Enum.Material.WoodPlanks)
            for _,side in ipairs({-1,1}) do
                block(parent,"Pied table étage",origin,Vector3.new(0.45,2.2,0.45),x+side*2.7,19.1,z,colors[2],Enum.Material.Metal)
            end
            block(parent,"Lampe bureau",origin,Vector3.new(1.2,1.1,1.2),x,21.4,z,accent,Enum.Material.Neon).CanCollide=false
        end
    end
end
local function elevator(parent,origin,key,accent)
    -- Deux stations indépendantes avec une destination côté serveur.
    -- Elles sont placées dans l'atrium, à l'écart des ouvertures centrales.
    for _,spec in ipairs({{name="Rez-de-chaussée",baseY=0,destY=18},{name="Étage panoramique",baseY=18,destY=0}}) do
        local y=spec.baseY
        block(parent,"Palier ascenseur "..spec.name,origin,Vector3.new(7,0.35,6),0,y+0.08,82,accent,Enum.Material.Metal)
        local console=block(parent,"Ascenseur "..spec.name,origin,Vector3.new(2,4,1.3),5,y+2.1,83,Color3.fromRGB(40,64,75),Enum.Material.Metal)
        local display=block(parent,"Afficheur ascenseur",origin,Vector3.new(1.6,1.8,0.15),5,y+2.6,82.3,Color3.fromRGB(115,226,218),Enum.Material.Neon)
        display.CanCollide=false
        console:SetAttribute("KinLiftId",key..(y==0 and ".lift.up" or ".lift.down"))
        console:SetAttribute("KinLiftPlaceKey",key)
        console:SetAttribute("KinLiftPosition",origin+Vector3.new(0,spec.destY+3.5,79))
        local verb=y==0 and "Monter à l'étage" or "Descendre"
        F.prompt(console,verb,"Ascenseur panoramique")
    end
end
function Vertical.make(model,placeKey,origin,style)
    local section=F.folder(model,"Galeries et étage panoramique")
    local trim=F.hex(style.palette.trim)
    local accent=F.hex(style.palette.accent)
    local walls=F.hex(style.palette.wall)
    -- Couronne extérieure au-dessus des murs de l'atrium d'origine (z:48..104, x:-50..50).
    for _,s in ipairs({-1,1}) do
        block(section,"Mur haut latéral",origin,Vector3.new(1,19,56),s*49.7,25.5,76,walls,Enum.Material.Concrete)
    end
    block(section,"Mur arrière haut",origin,Vector3.new(99,19,1),0,25.5,103.8,walls,Enum.Material.Concrete)
    block(section,"Frise haute",origin,Vector3.new(101,1,57),0,34.8,76,trim,Enum.Material.Metal).CanCollide=false
    block(section,"Toit verrière",origin,Vector3.new(97,0.8,53),0,35.3,76,Color3.fromRGB(119,178,185),Enum.Material.Glass).CanCollide=false
    for x=-40,40,16 do
        block(section,"Traverse de verrière",origin,Vector3.new(0.65,1.2,55),x,35.8,76,accent,Enum.Material.Metal).CanCollide=false
    end
    for z=56,96,10 do
        block(section,"Traverse transversale",origin,Vector3.new(99,1.1,0.5),0,35.8,z,accent,Enum.Material.Metal).CanCollide=false
    end
    bookGallery(section,origin,placeKey,accent,trim)
    -- La passerelle médiane connecte les deux mezzanines et porte l'ascenseur.
    block(section,"Passerelle médiane",origin,Vector3.new(98,1,10),0,17.5,82,trim,Enum.Material.Marble)
    for _,z in ipairs({77.3,87.0}) do
        for _,s in ipairs({-1,1}) do
            block(section,"Garde-corps passerelle",origin,Vector3.new(25,3.4,0.55),s*10,19.9,z,accent,Enum.Material.Metal)
        end
    end
    local sector="central"
    for _,building in ipairs(Buildings) do
        if building.interior_place_key==placeKey then sector=building.district_id;break end
    end
    for _,side in ipairs({-1,1}) do
        stairs(section,origin,placeKey,side*37,accent,trim)
        -- Imported stair skins dress the first native steps; they are NOT
        -- colliders. The full climb and railings remain genuine Roblox parts.
        local skin=if sector=="kreative" then ArtData.placements.stair_skins.kreative
            else ArtData.placements.stair_skins.default
        local imported=ArtAssets.place(section,skin,sector,Vector3.new(7.2,5.7,11.4),
            CFrame.new(origin+Vector3.new(side*37,0,49)),"architecture/"..placeKey)
        if imported then
            imported.Name="Habillage Art Deco des premières marches "..side
            for _,part in ipairs(imported:GetDescendants()) do
                if part:IsA("BasePart") then part:SetAttribute("KinOptionalDetail",true) end
            end
        end
    end
    upperFurniture(section,origin,placeKey,accent)
    elevator(section,origin,placeKey,accent)
    Roof.make(model,placeKey,origin,style)
    F.sign(section,"Galerie haute",origin+Vector3.new(0,29.5,100),180,"GALERIE PANORAMIQUE",38,3).CanCollide=false
    return section
end
return Vertical
