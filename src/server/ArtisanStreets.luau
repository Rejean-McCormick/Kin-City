--!strict
-- V6: petites rues d'artisans physiquement visitables, avec tables, vitrines et bornes.
local F=require(script.Parent.Factory)
local Courts=require(script.Parent.InstitutionForecourts)
local Artisan={}
local styles={
    {name="Librairie de quartier",tag="Livres",wall=Color3.fromRGB(184,163,133),roof=Color3.fromRGB(75,96,114)},
    {name="Atelier de céramique",tag="Art",wall=Color3.fromRGB(206,166,148),roof=Color3.fromRGB(137,86,85)},
    {name="Serre communautaire",tag="Nature",wall=Color3.fromRGB(142,178,151),roof=Color3.fromRGB(81,115,91)},
    {name="Café du savoir",tag="Rencontres",wall=Color3.fromRGB(208,185,141),roof=Color3.fromRGB(124,82,61)},
    {name="Atelier de réparation",tag="Savoir-faire",wall=Color3.fromRGB(163,180,197),roof=Color3.fromRGB(76,100,119)},
    {name="Galerie des voisins",tag="Patrimoine",wall=Color3.fromRGB(187,163,192),roof=Color3.fromRGB(93,82,120)},
}
local function part(root,label,cf,size,color,mat,solid)
    local p=F.part(root,label,size,cf,color,mat)
    if solid==false then p.CanCollide=false end
    return p
end
local function offset(root,name,base,x,y,z,size,color,mat,solid)
    return part(root,name,base*CFrame.new(x,y,z),size,color,mat,solid)
end
local function pathDistance(x,z,path)
    local nearest=math.huge
    for j=2,#path.path_xyz_studs do
        local a=path.path_xyz_studs[j-1]
        local b=path.path_xyz_studs[j]
        local x1,z1,x2,z2=a[1],a[3],b[1],b[3]
        local dx,dz=x2-x1,z2-z1
        local len=dx*dx+dz*dz
        if len>0 then
            local t=math.clamp(((x-x1)*dx+(z-z1)*dz)/len,0,1)
            local ddx,ddz=x-(x1+dx*t),z-(z1+dz*t)
            nearest=math.min(nearest,math.sqrt(ddx*ddx+ddz*ddz))
        end
    end
    return nearest
end
local function reservedPromenade(x,z)
    for i=1,36 do
        local a=2*math.pi*(i-1)/36+0.11
        local r=344+(i%3)*9
        local dx=x-math.cos(a)*r
        local dz=z-math.sin(a)*r
        if dx*dx+dz*dz<37*37 then return true end
    end
    return false
end
local function canBuild(x,z,plan)
    if Courts.isReserved(x,z,plan.structures) or reservedPromenade(x,z) then return false end
    for _,s in ipairs(plan.structures) do
        local dx=x-s.center_studs[1]
        local dz=z-s.center_studs[3]
        if math.sqrt(dx*dx+dz*dz)<90 then return false end
    end
    for _,path in ipairs(plan.pedestrian_paths) do
        if pathDistance(x,z,path)<(path.width_studs/2+17) then return false end
    end
    return true
end
local function booth(root,index,base,style,yaw)
    local mdl=Instance.new("Model")
    mdl.Name=style.name.." "..tostring(index)
    mdl:SetAttribute("KinArtisanId",string.format("artisan.%02d",index))
    mdl.Parent=root
    local trim=Color3.fromRGB(236,220,189)
    local timber=Color3.fromRGB(130,92,62)
    local metal=Color3.fromRGB(42,66,75)
    local w,h,d=24,13,24
    offset(mdl,"Plancher accessible",base,0,-0.35,0,Vector3.new(w,0.7,d),trim,Enum.Material.WoodPlanks,true)
    offset(mdl,"Mur du fond",base,0,h/2,d/2,Vector3.new(w,h,0.85),style.wall,Enum.Material.Brick,true)
    for _,s in ipairs({-1,1}) do
        offset(mdl,"Mur latéral",base,s*w/2,h/2,0,Vector3.new(0.85,h,d),style.wall,Enum.Material.Brick,true)
        offset(mdl,"Pilier entrée",base,s*5.1,h/2,-d/2,Vector3.new(1.0,h,1.0),trim,Enum.Material.Marble,true)
        offset(mdl,"Façade",base,s*8.7,h/2,-d/2,Vector3.new(6.5,h,0.85),style.wall,Enum.Material.Brick,true)
        offset(mdl,"Vitrine",base,s*8.7,7,-d/2-0.47,Vector3.new(4.6,5.2,0.18),Color3.fromRGB(127,198,207),Enum.Material.Glass,false).Transparency=0.35
        offset(mdl,"Châssis doré",base,s*8.7,10.3,-d/2-0.6,Vector3.new(5.2,0.25,0.28),trim,Enum.Material.Metal,false)
    end
    offset(mdl,"Poutre d'entrée",base,0,11,-d/2,Vector3.new(10,3.8,1.1),trim,Enum.Material.Marble,true)
    offset(mdl,"Toiture inclinée",base,0,h+0.8,0,Vector3.new(w+3,1.4,d+3),style.roof,Enum.Material.Slate,true)
    offset(mdl,"Marquise",base,0,9.9,-14.7,Vector3.new(13.5,0.6,6.4),style.roof,Enum.Material.Metal,false)
    offset(mdl,"Paillasson",base,0,0.18,-13,Vector3.new(7,0.15,3.6),Color3.fromRGB(162,132,102),Enum.Material.Fabric,false)
    -- Les tabourets sont de vrais Seats Roblox : le joueur peut s'y asseoir.
    for j=1,3 do
        local x=(j-2)*6
        offset(mdl,"Comptoir artisan",base,x,2.9,3,Vector3.new(4.7,0.6,4),timber,Enum.Material.WoodPlanks,true)
        local chair=Instance.new("Seat")
        chair.Name="Siège de consultation"
        chair.Size=Vector3.new(2.8,0.9,2.8)
        chair.CFrame=base*CFrame.new(x,1.2,-3.8)
        chair.Color=metal
        chair.Material=Enum.Material.WoodPlanks
        chair.Anchored=true
        chair.Parent=mdl
    end
    for level=1,3 do
        offset(mdl,"Rayon mural",base,-8.3,1.5+level*2.5,9,Vector3.new(4.6,0.35,2.5),timber,Enum.Material.WoodPlanks,true)
        for j=1,4 do
            local clr=Color3.fromHSV((index*0.12+j*0.11+level*0.21)%1,0.4,0.8)
            offset(mdl,"Collection exposée",base,-10.2+(j-1)*1.15,2.4+level*2.5,8.6,Vector3.new(0.8,1.5,1.0),clr,Enum.Material.Fabric,false)
        end
    end
    local counter=offset(mdl,"Terminal de l'atelier",base,7.5,2.2,8,Vector3.new(3.5,4.4,2.2),metal,Enum.Material.Metal,true)
    offset(mdl,"Écran de l'atelier",base,7.5,2.9,6.8,Vector3.new(2.9,2.4,0.14),Color3.fromRGB(112,208,198),Enum.Material.Neon,false)
    counter:SetAttribute("KinStubInteractionId",string.format("artisan.%02d.counter",index))
    counter:SetAttribute("KinStubCapabilityId","future.artisan."..style.tag)
    counter:SetAttribute("KinStubTitle",style.name)
    F.prompt(counter,"Consulter",style.name)
    F.sign(mdl,"Enseigne",(base*CFrame.new(0,12.3,-15)).Position,math.deg(yaw),style.name,20,2.7).CanCollide=false
    return mdl
end
function Artisan.make(city,plan)
    local root=F.folder(city,"Ruelles artisanales et boutiques")
    local count=0
    for i=1,48 do
        local theta=(i-0.6)*math.pi*2/48
        local radius=302+(i%3)*13
        local x,z=math.cos(theta)*radius,math.sin(theta)*radius
        if canBuild(x,z,plan) then
            local base=CFrame.new(x,0.1,z)*CFrame.Angles(0,math.pi/2-theta,0)
            booth(root,i,base,styles[(i-1)%#styles+1],math.pi/2-theta)
            count+=1
        end
    end
    root:SetAttribute("KinArtisanShopsCreated",count)
    return root
end
return Artisan
