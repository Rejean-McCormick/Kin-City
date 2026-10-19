--!strict
-- Kin City v6: promenades et quais accessibles au bord du lac annulaire.
-- Tout est génere avec les primitives natives. Aucun asset distant.
local F=require(script.Parent.Factory)
local Waterfront={}
local WOOD=Color3.fromRGB(153,110,74)
local COPPER=Color3.fromRGB(190,151,94)
local PIER=Color3.fromRGB(220,207,181)
local NAVY=Color3.fromRGB(30,104,100)
local WATER=Color3.fromRGB(83,187,205)

local function block(parent,name,base,offset,size,color,material,collide)
    local p=F.part(parent,name,size,base*CFrame.new(offset),color,material)
    if collide==false then p.CanCollide=false end
    return p
end
local function seat(parent,base,x,z)
    local model=Instance.new("Seat")
    model.Name="Banc accessible"
    model.Size=Vector3.new(5,0.9,2.5)
    model.CFrame=base*CFrame.new(x,1.25,z)
    model.Anchored=true
    model.Color=WOOD
    model.Material=Enum.Material.WoodPlanks
    model.Parent=parent
    block(parent,"Dossier de banc",base,Vector3.new(x,2.25,z+1.3),Vector3.new(5,2.2,0.5),NAVY,Enum.Material.Metal,true)
end
local function pier(root,index,theta)
    -- La berge est à r=495. Les quais prolongent la ville au-dessus du lac.
    local radial=Vector3.new(math.cos(theta),0,math.sin(theta))
    local center=radial*502
    local base=CFrame.lookAt(center,center+radial)
    local m=Instance.new("Model")
    m.Name=string.format("Quai public %02d",index)
    m:SetAttribute("KinWaterfrontId",string.format("city.waterfront.%02d",index))
    m.Parent=root
    block(m,"Passerelle jusqu'au quai",base,Vector3.new(0,0.5,0),Vector3.new(11,1.2,76),WOOD,Enum.Material.WoodPlanks,true)
    block(m,"Plateforme sur le lac",base,Vector3.new(0,0.55,-39),Vector3.new(34,1.25,24),PIER,Enum.Material.WoodPlanks,true)
    -- Piliers dans l'eau : le quai ne flotte pas visuellement dans le vide.
    for _,zz in ipairs({-48,-38,-27,7,28}) do
        for _,xx in ipairs({-5,5}) do
            block(m,"Pieu de fondation",base,Vector3.new(xx,-2,zz),Vector3.new(1.4,6.3,1.4),NAVY,Enum.Material.Metal,true)
        end
    end
    for _,x in ipairs({-15.4,15.4}) do
        for _,z in ipairs({-48,-37,-29}) do
            block(m,"Borne d'amarrage",base,Vector3.new(x,2.1,z),Vector3.new(1.2,3.5,1.2),NAVY,Enum.Material.Metal,true)
        end
        for _,z in ipairs({-44,-34}) do
            block(m,"Garde-corps lac",base,Vector3.new(x,3,z),Vector3.new(0.45,0.6,9),COPPER,Enum.Material.Metal,false)
        end
        seat(m,base,x*0.55,-38)
    end
    for _,z in ipairs({-21,-6,8,23}) do
        for _,x in ipairs({-5,5}) do
            block(m,"Poteau guide",base,Vector3.new(x,1.5,z),Vector3.new(0.45,3.2,0.45),NAVY,Enum.Material.Metal,true)
            local lamp=block(m,"Balise lumineuse",base,Vector3.new(x,3.1,z),Vector3.new(1.0,0.75,1.0),COPPER,Enum.Material.Neon,false)
            if z==-21 then
                local light=Instance.new("PointLight")
                light.Brightness=0.35;light.Range=12;light.Parent=lamp
            end
        end
    end
    -- Pavillon d'observation couvert, accessible en toute saison.
    for _,x in ipairs({-12,12}) do
        for _,z in ipairs({-46,-31}) do
            block(m,"Poteau pavillon",base,Vector3.new(x,5,z),Vector3.new(0.9,9.3,0.9),NAVY,Enum.Material.Metal,true)
        end
    end
    block(m,"Toiture du pavillon",base,Vector3.new(0,9.8,-38.5),Vector3.new(28,0.75,19),COPPER,Enum.Material.Metal,false)
    for _,x in ipairs({-10,10}) do
        block(m,"Plante du quai",base,Vector3.new(x,1.9,-27),Vector3.new(3,2.4,3),Color3.fromRGB(82,144,113),Enum.Material.Grass,false)
    end
    local monument=block(m,"Orbe maritime",base,Vector3.new(0,5.3,-41),Vector3.new(4,4,4),WATER,Enum.Material.Glass,false)
    monument.Shape=Enum.PartType.Ball
    local tablet=block(m,"Borne maritime",base,Vector3.new(0,2.5,-28),Vector3.new(3.3,4.4,2.2),NAVY,Enum.Material.Metal,true)
    tablet:SetAttribute("KinStubInteractionId",string.format("city.waterfront.%02d.guide",index))
    tablet:SetAttribute("KinStubCapabilityId","future.waterfront.discovery")
    tablet:SetAttribute("KinStubTitle","Découvertes maritimes")
    F.prompt(tablet,"Découvrir","Quai de Kin City")
    -- Accès au quai depuis le rebord, sans téléportation.
    return m
end

function Waterfront.make(city)
    local root=F.folder(city,"Promenade lacustre et quais")
    for i=1,12 do
        local theta=(i-1)*2*math.pi/12+math.pi/24
        pier(root,i,theta)
    end
    root:SetAttribute("KinPiersCreated",12)
    return root
end
return Waterfront
