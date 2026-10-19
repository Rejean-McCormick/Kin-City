--!strict
-- Kin City v13 : six rues de promenade secondaires entre les quartiers et les agoras.
-- Dalles pavées, terrasses, enseignes, bancs et luminaires; marche libre.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Neighborhoods=require(Shared:WaitForChild("ResidentialDestinations"))
local Factory=require(script.Parent.Factory)
local Streets={}
local STONE=Color3.fromRGB(214,201,174)
local BRASS=Color3.fromRGB(222,182,107)
local WOOD=Color3.fromRGB(148,106,73)
local NAVY=Color3.fromRGB(43,71,82)
local function put(parent,name,size,cf,color,material,solid)
    local part=Factory.part(parent,name,size,cf,color,material)
    if solid==false then part.CanCollide=false;part.CanQuery=false;part.CanTouch=false end
    return part
end
local function chair(root,cf)
    local s=Instance.new("Seat")
    s.Name="Banc de la promenade secondaire"
    s.Size=Vector3.new(5,0.7,2.1)
    s.CFrame=cf
    s.Color=WOOD;s.Material=Enum.Material.WoodPlanks;s.Anchored=true;s.Parent=root
    put(root,"Dossier de banc",Vector3.new(5,1.8,0.35),cf*CFrame.new(0,1.1,1),NAVY,Enum.Material.Wood)
end
function Streets.isReserved(x,z)
    for _,q in ipairs(Neighborhoods) do
        local angle=q.angle
        local along=x*math.cos(angle)+z*math.sin(angle)
        local across=math.abs(-x*math.sin(angle)+z*math.cos(angle))
        if along>=376 and along<=421 and across<=15 then return true end
    end
    return false
end
function Streets.make(city)
    local root=Factory.folder(city,"Rues secondaires et terrasses")
    for index,q in ipairs(Neighborhoods) do
        local radial=Vector3.new(math.cos(q.angle),0,math.sin(q.angle))
        local tangent=Vector3.new(-radial.Z,0,radial.X)
        local frame=CFrame.lookAt(radial*399,radial*430)
        local district=Factory.folder(root,"Promenade vers "..q.title)
        local c=Color3.fromRGB(q.color[1],q.color[2],q.color[3])
        put(district,"Avenue bordée",Vector3.new(10,0.23,48),frame*CFrame.new(0,0.13,0),STONE,Enum.Material.Cobblestone)
        for side=-1,1,2 do
            local xx=side*7.3
            put(district,"Bande de jardin",Vector3.new(2.8,0.55,48),frame*CFrame.new(xx,0.28,0),c,Enum.Material.Grass,false)
            for n=1,3 do
                local point=radial*(381+n*10)+tangent*xx
                local post=put(district,"Lanterne de ruelle",Vector3.new(0.55,7,0.55),CFrame.new(point+Vector3.new(0,3.6,0)),NAVY,Enum.Material.Metal)
                local bulb=put(district,"Lueur piétonne",Vector3.new(1.3,1.3,1.3),CFrame.new(point+Vector3.new(0,7.6,0)),BRASS,Enum.Material.Neon,false)
                bulb.Shape=Enum.PartType.Ball
                local light=Instance.new("PointLight")
                light.Range=20;light.Brightness=0.65;light.Parent=bulb
            end
            local seatPos=radial*398+tangent*(side*13)
            chair(district,CFrame.lookAt(seatPos+Vector3.new(0,1.4,0),radial*398))
        end
        Factory.sign(district,"Panneau de quartier",radial*407+Vector3.new(0,8.3,0),math.deg(math.pi/2-q.angle),q.title,21,2.7).CanCollide=false
    end
    root:SetAttribute("KinSecondaryPromenades",#Neighborhoods)
    return root
end
return Streets
