--!strict
-- Espaces publics, bancs, fontaines, belvédères, lampadaires, arbres floraux.
local F=require(script.Parent.Factory)
local Urban={}
local function pos(x,y,z) return Vector3.new(x,y,z) end
local function part(parent,name,xyz,size,color,material)
    return F.part(parent,name,size,CFrame.new(xyz),color,material)
end
local function sphere(parent,name,xyz,size,color,material)
    local p=part(parent,name,xyz,size,color,material)
    p.Shape=Enum.PartType.Ball
    return p
end
local function cylinder(parent,name,xyz,diameter,height,color,material)
    local p=F.part(parent,name,Vector3.new(height,diameter,diameter),CFrame.new(xyz)*CFrame.Angles(0,0,math.pi/2),color,material)
    p.Shape=Enum.PartType.Cylinder
    return p
end
local stone=Color3.fromRGB(201,193,169)
local iron=Color3.fromRGB(30,104,100)
local copper=Color3.fromRGB(181,139,86)
local foliage=Color3.fromRGB(51,132,91)
local function lamp(parent,x,z)
    local model=F.folder(parent,"Réverbère")
    part(model,"Socle",pos(x,0.35,z),Vector3.new(2,0.7,2),stone,Enum.Material.Marble)
    part(model,"Fût",pos(x,5.1,z),Vector3.new(0.7,9.3,0.7),iron,Enum.Material.Metal)
    part(model,"Chapiteau",pos(x,10.2,z),Vector3.new(2.4,1.3,2.4),copper,Enum.Material.Metal)
    local bulb=part(model,"Luminaire",pos(x,10.7,z),Vector3.new(1.2,0.8,1.2),Color3.fromRGB(255,234,172),Enum.Material.Neon)
    bulb.CanCollide=false
    local light=Instance.new("PointLight");light.Brightness=1.1;light.Range=19;light.Shadows=false;light.Parent=bulb
end
local function bench(parent,x,z,yaw)
    local m=F.folder(parent,"Banc public")
    local base=CFrame.new(x,0,z)*CFrame.Angles(0,math.rad(yaw),0)
    F.part(m,"Assise",Vector3.new(8,0.5,2),base*CFrame.new(0,1.8,0),copper,Enum.Material.WoodPlanks)
    F.part(m,"Dossier",Vector3.new(8,2,0.45),base*CFrame.new(0,2.7,1),copper,Enum.Material.Wood)
    for _,s in ipairs({-1,1}) do
        F.part(m,"Pied",Vector3.new(0.55,1.7,1.8),base*CFrame.new(s*3,0.85,0),iron,Enum.Material.Metal)
    end
end
local function planter(parent,x,z,seed)
    local m=F.folder(parent,"Jardinière")
    cylinder(m,"Bordure",pos(x,0.85,z),5.8,1.7,stone,Enum.Material.Cobblestone)
    for n=1,6 do
        local a=n*math.pi/3
        local r=1.8
        local px,pz=x+math.cos(a)*r,z+math.sin(a)*r
        sphere(m,"Fleur",pos(px,2.9,pz),Vector3.new(1.2,1.2,1.2),Color3.fromHSV(((seed+n)*0.17)%1,0.64,0.94),Enum.Material.Grass).CanCollide=false
        part(m,"Tige",pos(px,2,pz),Vector3.new(0.22,1.9,0.22),foliage,Enum.Material.Grass).CanCollide=false
    end
end
local function sculpture(parent,x,z,seed)
    local m=F.folder(parent,"Sculpture publique")
    cylinder(m,"Piédestal",pos(x,1.3,z),7,2.6,stone,Enum.Material.Marble)
    local ring=F.part(m,"Anneau",Vector3.new(9,0.7,9),CFrame.new(x,7,z)*CFrame.Angles(0,0,math.rad(25+seed*7)),copper,Enum.Material.Metal)
    ring.Shape=Enum.PartType.Cylinder;ring.CanCollide=false
    sphere(m,"Noyau",pos(x,7,z),Vector3.new(4.5,4.5,4.5),Color3.fromRGB(84,156,169),Enum.Material.Glass).CanCollide=false
end
local function fountain(parent,x,z)
    local m=F.folder(parent,"Fontaine")
    cylinder(m,"Margelle",pos(x,0.55,z),25,1.1,stone,Enum.Material.Marble)
    cylinder(m,"Bassin",pos(x,1.2,z),21,0.25,Color3.fromRGB(58,153,187),Enum.Material.Glass).CanCollide=false
    cylinder(m,"Pilier",pos(x,3,z),3,5,copper,Enum.Material.Marble)
    sphere(m,"Couronne d'eau",pos(x,6,z),Vector3.new(5,2.3,5),Color3.fromRGB(103,207,229),Enum.Material.Glass).CanCollide=false
    for n=1,6 do
        local a=n*math.pi/3
        local xx,zz=x+math.cos(a)*6,z+math.sin(a)*6
        sphere(m,"Jet",pos(xx,3,zz),Vector3.new(0.5,4,0.5),Color3.fromRGB(149,214,237),Enum.Material.Glass).CanCollide=false
    end
end
local function nearBuilding(x,z,structures,padding)
    for _,b in ipairs(structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        local angle=math.rad(b.yaw_degrees)
        local lx=math.cos(angle)*dx-math.sin(angle)*dz
        local lz=math.sin(angle)*dx+math.cos(angle)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+padding and math.abs(lz)<b.footprint_studs[2]/2+padding then return true end
    end
    return false
end
local function ring(parent,radius,width,structures)
    local segments=96
    for k=1,segments do
        local theta=(k-0.5)*math.pi*2/segments
        local x,z=math.cos(theta)*radius,math.sin(theta)*radius
        if not nearBuilding(x,z,structures,9) then
            local a=(k-1)*math.pi*2/segments
            local b=k*math.pi*2/segments
            local p=Vector3.new(math.cos(a)*radius,0.17,math.sin(a)*radius)
            local q=Vector3.new(math.cos(b)*radius,0.17,math.sin(b)*radius)
            local v=q-p
            local section=F.part(parent,"Promenade annulaire",Vector3.new(width,0.23,v.Magnitude+1.3),CFrame.lookAt((p+q)/2,q),Color3.fromRGB(204,187,159),Enum.Material.Cobblestone)
            section.CanCollide=false
        end
    end
end
local districtNames={
    central="Place de la Gouvernance",konnected="Quartier du Savoir",
    ethikos="Place de l'Éthique",keenkonnect="Parc de l'Innovation",
    kreative="Quartier Créatif",orgo="Infrastructure Orgo"
}
function Urban.make(parent,plan)
    local folder=F.folder(parent,"Vie urbaine et jardins")
    local promenades=F.folder(folder,"Promenades concentriques")
    ring(promenades,71,5.5,plan.structures)
    ring(promenades,327,7,plan.structures)
    local details=F.folder(folder,"Places et monuments")
    fountain(details,-30,-29)
    for n=1,7 do
        local a=math.pi*2*n/7
        local radius=42
        local x,z=math.cos(a)*radius,math.sin(a)*radius
        bench(details,x,z,(a*180/math.pi)+90)
        planter(details,math.cos(a)*52,math.sin(a)*52,n)
    end
    for n=1,4 do
        local a=n*math.pi/2+math.pi/4
        lamp(details,math.cos(a)*59,math.sin(a)*59)
    end
    for _,anchor in ipairs(plan.places) do
        if anchor.place_key=="city" then
            for _,hub in ipairs(anchor.anchors) do
                local district=string.match(hub.anchor_id,"^city%.district%.([%a]+)%.hub$")
                if district and district~="central" then
                    local x,z=hub.position_studs[1],hub.position_studs[3]
                    local dir=Vector3.new(x,0,z).Unit
                    local right=Vector3.new(-dir.Z,0,dir.X)
                    local spot=Vector3.new(x,0,z)
                    local sign=F.sign(details,"Orientation "..district,spot+Vector3.new(0,6,0),-math.deg(math.atan2(dir.X,dir.Z)),districtNames[district] or district,23,3.8)
                    sign.CanCollide=false
                    for s=-1,1,2 do
                        local point=spot+right*s*16
                        bench(details,point.X,point.Z,math.deg(math.atan2(dir.X,dir.Z)))
                        planter(details,point.X+dir.X*8,point.Z+dir.Z*8,math.floor(math.abs(x)+math.abs(z)+s))
                        lamp(details,point.X-dir.X*8,point.Z-dir.Z*8)
                    end
                end
            end
        end
    end
    -- Axes radiaux vers les quartiers périphériques, sans traverser les bâtiments.
    for spoke=1,16 do
        local angle=(spoke-1)*math.pi/8
        for radius=335,425,15 do
            local mid=radius+7.5
            local x,z=math.cos(angle)*mid,math.sin(angle)*mid
            if not nearBuilding(x,z,plan.structures,8) then
                local base=CFrame.new(x,0.19,z)*CFrame.Angles(0,-angle+math.pi/2,0)
                local sidewalk=F.part(promenades,"Allée radiale",Vector3.new(6,0.23,16.5),base,stone,Enum.Material.Cobblestone)
                sidewalk.CanCollide=false
            end
        end
    end
    -- Belvédères sur la rive de l'île, pour explorer la couronne naturelle.
    for n=1,8 do
        local angle=n*math.pi/4
        local cx,cz=math.cos(angle)*476,math.sin(angle)*476
        local base=CFrame.new(cx,0,cz)*CFrame.Angles(0,-angle+math.pi/2,0)
        local terrace=F.folder(details,"Belvédère littoral")
        F.part(terrace,"Terrasse",Vector3.new(22,0.7,18),base*CFrame.new(0,0.2,0),Color3.fromRGB(142,111,75),Enum.Material.WoodPlanks)
        for _,side in ipairs({-1,1}) do
            F.part(terrace,"Garde-corps",Vector3.new(0.5,3.3,16),base*CFrame.new(side*10.5,2,0),iron,Enum.Material.Metal)
        end
        F.part(terrace,"Balustrade",Vector3.new(21,3.3,0.5),base*CFrame.new(0,2,8.8),iron,Enum.Material.Metal)
        local a=base*CFrame.new(0,0,-2)
        bench(terrace,a.Position.X,a.Position.Z,math.deg(-angle+math.pi/2))
    end
    sculpture(details,58,48,2)
    sculpture(details,-65,56,5)
    -- Lumières piétonnes espacées : détail visuel, mais coût maîtrisé.
    for _,path in ipairs(plan.pedestrian_paths) do
        local nodes=path.path_xyz_studs
        if #nodes>=2 then
            local a=Vector3.new(nodes[1][1],0,nodes[1][3])
            local b=Vector3.new(nodes[#nodes][1],0,nodes[#nodes][3])
            local dir=b-a
            if dir.Magnitude>20 then
                local perpendicular=Vector3.new(-dir.Unit.Z,0,dir.Unit.X)
                for _,t in ipairs({0.28,0.69}) do
                    local point=a+dir*t+perpendicular*10
                    if not nearBuilding(point.X,point.Z,plan.structures,3) then
                        lamp(details,point.X,point.Z)
                    end
                end
            end
        end
    end
    return folder
end
return Urban
