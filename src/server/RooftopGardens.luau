--!strict
-- Troisième espace : terrasse sur le toit de l'atrium. Ascenseur étage <-> toit.
-- Aucun nouveau PlaceId; toutes les structures sont des parts natives.
local F=require(script.Parent.Factory)
local Roof={}
local function block(parent,name,origin,size,x,y,z,color,material)
    return F.part(parent,name,size,CFrame.new(origin+Vector3.new(x,y,z)),color,material)
end
local function planters(parent,origin,x,z,seed)
    block(parent,"Bac paysager",origin,Vector3.new(7,2,4),x,39,z,Color3.fromRGB(184,157,117),Enum.Material.Marble)
    for i=1,3 do
        local stem=block(parent,"Tige",origin,Vector3.new(0.45,3.2,0.45),x-2.1+i*1.1,41,z,Color3.fromRGB(75,112,76),Enum.Material.Wood)
        stem.CanCollide=false
        local plant=block(parent,"Feuillage",origin,Vector3.new(2.1,2.8,2.3),x-2.1+i*1.1,43,z,Color3.fromHSV((seed+i)*0.091%1,0.38,0.62),Enum.Material.Grass)
        plant.Shape=Enum.PartType.Ball
        plant.CanCollide=false
    end
end
local function observatory(parent,origin,key,x,z,title,index,color)
    local base=block(parent,"Borne terrasse",origin,Vector3.new(3.4,3.9,2.1),x,40.0,z,Color3.fromRGB(42,59,66),Enum.Material.Metal)
    block(parent,"Écran extérieur",origin,Vector3.new(2.8,2.0,0.2),x,41.1,z-1.2,color,Enum.Material.Neon).CanCollide=false
    base:SetAttribute("KinStubInteractionId",key..".roof.exhibit."..index)
    base:SetAttribute("KinStubCapabilityId","future."..key..".roof")
    base:SetAttribute("KinStubTitle",title)
    F.prompt(base,"Découvrir",title)
end
local function roofLift(parent,origin,key,x,sourceY,destY,label)
    block(parent,"Plateforme terrasse",origin,Vector3.new(7,0.4,6),x,sourceY+0.2,82,Color3.fromRGB(65,108,119),Enum.Material.Metal)
    local cab=block(parent,"Cabine accès toit",origin,Vector3.new(2.6,3.9,1.5),x+5,sourceY+2.3,82,Color3.fromRGB(48,70,85),Enum.Material.Metal)
    local screen=block(parent,"Voyant cabine",origin,Vector3.new(1.9,1.6,0.15),x+5,sourceY+2.6,81.15,Color3.fromRGB(130,222,208),Enum.Material.Neon)
    screen.CanCollide=false
    cab:SetAttribute("KinLiftId",key..".roof."..label)
    cab:SetAttribute("KinLiftPlaceKey",key)
    cab:SetAttribute("KinLiftPosition",origin+Vector3.new(x,destY+3.5,80))
    F.prompt(cab,sourceY>destY and "Redescendre" or "Accéder au toit","Belvédère")
end
function Roof.make(model,key,origin,style)
    local group=F.folder(model,"Toit jardin et belvédère")
    local light=F.hex(style.palette.trim)
    local accent=F.hex(style.palette.accent)
    local stone=F.hex(style.palette.floor)
    local floor=block(group,"Plancher belvédère",origin,Vector3.new(96,1.1,52),0,37.5,76,stone,Enum.Material.Marble)
    -- Bordures sur les quatre faces, à hauteur d'avatar.
    for _,s in ipairs({-1,1}) do
        block(group,"Garde-corps latéral",origin,Vector3.new(0.75,5,52),s*47.8,40.4,76,accent,Enum.Material.Metal)
        block(group,"Garde-corps transversal",origin,Vector3.new(96,5,0.75),0,40.4,76+s*25.6,accent,Enum.Material.Metal)
    end
    block(group,"Promenade végétale",origin,Vector3.new(83,0.13,11),0,38.15,61,Color3.fromRGB(120,154,102),Enum.Material.Grass).CanCollide=false
    for i=1,8 do
        local x=-41+(i-1)*11.6
        planters(group,origin,x,58,i)
        local color= i%2==0 and accent or light
        local spot=block(group,"Borne lumineuse",origin,Vector3.new(1,3.2,1),x,39.6,98,color,Enum.Material.Neon)
        spot.CanCollide=false
    end
    for _,spec in ipairs({{-28,82},{28,82}}) do
        local x,z=spec[1],spec[2]
        block(group,"Banc toit",origin,Vector3.new(9,0.65,2.6),x,39.3,z,Color3.fromRGB(135,97,68),Enum.Material.WoodPlanks)
        for _,side in ipairs({-1,1}) do
            block(group,"Pied banc",origin,Vector3.new(0.55,1,1.9),x+side*3.5,38.7,z,accent,Enum.Material.Metal)
        end
    end
    observatory(group,origin,key,-33,72,"Panorama historique",1,accent)
    observatory(group,origin,key,33,72,"Observatoire de Kin City",2,accent)
    F.sign(group,"Titre du toit",origin+Vector3.new(0,45,98),180,"BELVÉDÈRE · "..string.upper(key),42,3).CanCollide=false
    roofLift(group,origin,key,-6,18,38,"up")
    roofLift(group,origin,key,-6,38,18,"down")
    return group
end
return Roof
