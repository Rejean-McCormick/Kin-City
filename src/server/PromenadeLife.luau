--!strict
-- Animations et activités publiques de Kin City : marchés, pergolas, exposition en plein air.
-- Installations permanentes. Toutes les interactions métier sont des stubs identifiés.
local F=require(script.Parent.Factory)
local Promenade={}
local STONE=Color3.fromRGB(211,196,168)
local WOOD=Color3.fromRGB(140,106,74)
local IRON=Color3.fromRGB(42,73,84)
local CYAN=Color3.fromRGB(85,188,180)
local function part(parent,name,base,size,offset,color,material,solid)
    local p=F.part(parent,name,size,base*CFrame.new(offset),color,material)
    if solid==false then p.CanCollide=false;p.CastShadow=false end
    return p
end
local function ball(parent,name,base,size,offset,color)
    local p=part(parent,name,base,size,offset,color,Enum.Material.Glass,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function blocked(x,z,structures)
    for _,b in ipairs(structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        if math.sqrt(dx*dx+dz*dz)<math.max(64,math.max(b.footprint_studs[1],b.footprint_studs[2])*0.68+20) then return true end
    end
    return false
end
local themes={
    {"Atelier des idées","Rencontre et création",Color3.fromRGB(130,188,164)},
    {"Jardin de lecture","Littérature et savoir",Color3.fromRGB(211,165,113)},
    {"Forum du dialogue","Écoute et médiation",Color3.fromRGB(144,173,210)},
    {"Passage des inventions","Science collaborative",Color3.fromRGB(203,148,177)},
    {"Scène des cultures","Créativité partagée",Color3.fromRGB(208,186,106)},
    {"Pavillon du vivant","Écologie et découverte",Color3.fromRGB(120,184,126)},
}
local function pavilion(root,base,index,spec)
    local m=Instance.new("Model")
    m.Name=spec[1].." "..index
    m:SetAttribute("KinPublicSpaceId",string.format("city.promenade.%02d",index))
    m.Parent=root
    local accent=spec[3]
    part(m,"Estrade",base,Vector3.new(26,0.85,22),Vector3.new(0,0.38,0),STONE,Enum.Material.Marble,true)
    for _,sx in ipairs({-1,1}) do
        for _,sz in ipairs({-1,1}) do
            part(m,"Colonne de pergola",base,Vector3.new(0.9,13,0.9),Vector3.new(sx*11,7,sz*9),WOOD,Enum.Material.Wood,true)
            part(m,"Socle de colonne",base,Vector3.new(2.4,1.2,2.4),Vector3.new(sx*11,0.8,sz*9),STONE,Enum.Material.Marble,true)
        end
    end
    for _,zz in ipairs({-8.5,8.5}) do
        part(m,"Poutre de pergola",base,Vector3.new(25,0.7,1.3),Vector3.new(0,13.6,zz),WOOD,Enum.Material.WoodPlanks,false)
    end
    for n=-3,3 do
        part(m,"Treillage ouvert",base,Vector3.new(0.8,0.55,20),Vector3.new(n*3.1,14.2,0),WOOD,Enum.Material.WoodPlanks,false)
    end
    local kiosk=part(m,"Borne de quartier",base,Vector3.new(4.5,4.7,3),Vector3.new(0,2.6,7.2),IRON,Enum.Material.Metal,true)
    part(m,"Écran public",base,Vector3.new(3.8,2.7,0.12),Vector3.new(0,3.3,5.62),accent,Enum.Material.Neon,false)
    kiosk:SetAttribute("KinStubInteractionId","city.public.pavilion."..index)
    kiosk:SetAttribute("KinStubCapabilityId","future.public.activities")
    kiosk:SetAttribute("KinStubTitle",spec[2])
    F.prompt(kiosk,"Découvrir",spec[1])
    for _,x in ipairs({-7.5,7.5}) do
        part(m,"Banc d'atelier",base,Vector3.new(7.1,0.6,2.3),Vector3.new(x,1.55,-2.7),WOOD,Enum.Material.WoodPlanks,true)
        part(m,"Dossier",base,Vector3.new(7.1,2,0.45),Vector3.new(x,2.5,-1.7),IRON,Enum.Material.Metal,false)
        ball(m,"Lampe d'ambiance",base,Vector3.new(1.3,1.3,1.3),Vector3.new(x,12.8,-3),accent)
    end
    F.sign(m,"Enseigne",(base*CFrame.new(0,12.5,-11.25)).Position,math.deg(math.atan2(-base.LookVector.X,-base.LookVector.Z)),spec[1],20.5,3.2).CanCollide=false
end
function Promenade.make(parent,plan)
    local folder=F.folder(parent,"Promenades citoyennes")
    local total=0
    for i=1,36 do
        local angle=2*math.pi*(i-1)/36 + 0.11
        local radius=344+(i%3)*9
        local x,z=math.cos(angle)*radius,math.sin(angle)*radius
        if not blocked(x,z,plan.structures) then
            local base=CFrame.new(x,0.13,z)*CFrame.Angles(0,-angle,0)
            local theme=themes[(i-1)%#themes+1]
            pavilion(folder,base,i,theme)
            total+=1
        end
    end
    folder:SetAttribute("KinPavilionsCreated",total)
    return folder
end
return Promenade
