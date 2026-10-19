--!strict
-- V6 : jardins où l'interaction produit un effet PHYSIQUE LOCAL.
-- Les bornes des services métier restent des stubs ailleurs dans Kin City.
local F=require(script.Parent.Factory)
local Gardens={}
local Courts=require(script.Parent.InstitutionForecourts)
local GRASS=Color3.fromRGB(79,139,97)
local STONE=Color3.fromRGB(222,210,188)
local IRON=Color3.fromRGB(41,68,80)
local GOLD=Color3.fromRGB(206,162,93)
local function part(parent,name,base,x,y,z,sx,sy,sz,color,mat,solid)
    local p=F.part(parent,name,Vector3.new(sx,sy,sz),base*CFrame.new(x,y,z),color,mat)
    if solid==false then p.CanCollide=false end
    return p
end
local function clearSpot(x,z,plan)
    if Courts.isReserved(x,z,plan.structures) then return false end
    for _,b in ipairs(plan.structures) do
        local dx=x-b.center_studs[1];local dz=z-b.center_studs[3]
        if math.sqrt(dx*dx+dz*dz)<85 then return false end
    end
    for _,path in ipairs(plan.pedestrian_paths) do
        local pts=path.path_xyz_studs
        for i=2,#pts do
            local a=pts[i-1];local b=pts[i]
            local dx=b[1]-a[1];local dz=b[3]-a[3]
            local l=dx*dx+dz*dz
            if l>0 then
                local t=math.clamp(((x-a[1])*dx+(z-a[3])*dz)/l,0,1)
                local xx=a[1]+dx*t;local zz=a[3]+dz*t
                local dist=math.sqrt((x-xx)^2+(z-zz)^2)
                if dist<path.width_studs/2+13 then return false end
            end
        end
    end
    return true
end
local types={
    {title="Jardin de l'énergie",kind="light",shade=Color3.fromRGB(113,226,212)},
    {title="Laboratoire des rotations",kind="motion",shade=Color3.fromRGB(228,159,96)},
    {title="Atelier de la lumière",kind="light",shade=Color3.fromRGB(207,144,224)},
    {title="Monument cinétique",kind="motion",shade=Color3.fromRGB(117,183,231)},
}
local function assemble(root,index,base,design,yaw)
    local m=Instance.new("Model")
    m.Name=design.title.." "..index
    m:SetAttribute("KinPublicSpaceId",string.format("city.discovery.%02d",index))
    m:SetAttribute("KinLocalMechanismActive",false)
    m.Parent=root
    part(m,"Jardin pavé",base,0,0.05,0,26,0.35,26,STONE,Enum.Material.Cobblestone,false)
    for _,sx in ipairs({-1,1}) do
        for _,sz in ipairs({-1,1}) do
            part(m,"Pilier du jardin",base,sx*11,3.2,sz*11,1.1,6,1.1,IRON,Enum.Material.Metal,true)
            part(m,"Orbe d'énergie",base,sx*11,6.6,sz*11,1.3,1.3,1.3,design.shade,Enum.Material.Neon,false)
            local pot=part(m,"Jardin vertical",base,sx*8,1.1,sz*8,3.2,2.2,3.2,GRASS,Enum.Material.Grass,true)
            pot.Shape=Enum.PartType.Ball
        end
    end
    part(m,"Socle de l'installation",base,0,1,1,9,2,9,IRON,Enum.Material.Metal,true)
    for i=1,8 do
        local a=i*math.pi/4
        local xx=math.cos(a)*5.2;local zz=1+math.sin(a)*5.2
        local orb=part(m,"Cristal interactif",base,xx,5,zz,2,2,2,design.shade,Enum.Material.Glass,false)
        orb.Shape=Enum.PartType.Ball
        orb.Transparency=0.65
        orb:SetAttribute("KinReactiveLight",true)
        local light=Instance.new("PointLight")
        light.Enabled=false;light.Range=16;light.Brightness=0.7;light.Color=design.shade;light.Parent=orb
    end
    if design.kind=="motion" then
        for n=1,4 do
            local piece=part(m,"Aile mobile",base,0,6.6,1,1.1,1.1,13,design.shade,Enum.Material.Metal,false)
            piece.CFrame=base*CFrame.new(0,6.6,1)*CFrame.Angles(0,n*math.pi/4,math.pi/5)
            piece:SetAttribute("KinReactiveRotor",true)
        end
        part(m,"Axe cinétique",base,0,6.5,1,1.2,9,1.2,GOLD,Enum.Material.Metal,false)
    else
        local crown=part(m,"Sphère de réflexion",base,0,8.4,1,5.5,5.5,5.5,design.shade,Enum.Material.Glass,false)
        crown.Shape=Enum.PartType.Ball
        crown.Transparency=0.75
        crown:SetAttribute("KinReactiveLight",true)
        local light=Instance.new("PointLight")
        light.Enabled=false;light.Range=25;light.Brightness=2;light.Color=design.shade;light.Parent=crown
    end
    local console=part(m,"Commande physique",base,8,2.2,-8,3.2,4.4,2.2,IRON,Enum.Material.Metal,true)
    part(m,"Écran de commande",base,8,3,-9.15,2.6,2.2,0.15,design.shade,Enum.Material.Neon,false)
    console:SetAttribute("KinLocalMechanismId",string.format("city.discovery.%02d",index))
    console:SetAttribute("KinLocalMechanismKind",design.kind)
    F.prompt(console,"Activer",design.title)
    F.sign(m,"Panneau",(base*CFrame.new(0,11,-12.2)).Position,math.deg(yaw),design.title,24,2.7).CanCollide=false
end
function Gardens.make(city,plan)
    local root=F.folder(city,"Jardins d'expérimentation interactive")
    local count=0
    for i=1,20 do
        local theta=(i-0.3)*2*math.pi/20
        local radius=195+(i%2)*14
        local x,z=math.cos(theta)*radius,math.sin(theta)*radius
        if clearSpot(x,z,plan) then
            local base=CFrame.new(x,0.2,z)*CFrame.Angles(0,math.pi/2-theta,0)
            assemble(root,i,base,types[(i-1)%#types+1],math.pi/2-theta)
            count+=1
        end
    end
    root:SetAttribute("KinGardensCreated",count)
    return root
end
return Gardens
