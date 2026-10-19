--!strict
-- Petites stations de repos près des trajets EXISTANTS : bancs, pergolas, jardin minéral.
-- Chaque station est lue du chemin canonique; aucun nouveau quartier.
local Kit=require(script.Parent.CrystalKit)
local Studio=require(script.Parent.ArtisanGeometryV22)
local Stops={}
local function pointAt(path,fraction)
    local coords=path.path_xyz_studs
    if not coords or #coords<2 then return nil,nil end
    local lengths={}
    local total=0
    for i=2,#coords do
        local a,b=coords[i-1],coords[i]
        local dist=Vector3.new(b[1]-a[1],0,b[3]-a[3]).Magnitude
        lengths[i]=dist
        total+=dist
    end
    local remaining=total*fraction
    for i=2,#coords do
        if remaining<=lengths[i] or i==#coords then
            local a,b=coords[i-1],coords[i]
            local dir=Vector3.new(b[1]-a[1],0,b[3]-a[3])
            if dir.Magnitude<0.1 then return nil,nil end
            local t=math.clamp(remaining/math.max(lengths[i],0.01),0,1)
            local pos=Vector3.new(a[1],0,a[3])+dir*t
            return pos,dir.Unit
        end
        remaining-=lengths[i]
    end
    return nil,nil
end
local function restStop(folder,position,tangent,index,side)
    local root=Instance.new("Model")
    root.Name="Halte opaline "..index
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    root.Parent=folder
    local normal=Vector3.new(-tangent.Z,0,tangent.X)*side
    local center=position+normal*12
    local base=CFrame.lookAt(center,center+normal)
    local deck=Studio.part(root,"Esplanade minérale",Vector3.new(13,0.4,8.5),
        base*CFrame.new(0,0.06,0),"medium",Enum.Material.Slate,false)
    -- Banc physique, utilisable en s'asseyant. À 12 studs du tracé et hors de son axe.
    local seat=Instance.new("Seat")
    seat.Name="Banc de promenade"
    seat.Size=Vector3.new(5.5,0.65,2.2)
    seat.CFrame=base*CFrame.new(0,1.6,-1.5)
    seat.Anchored=true
    seat.CanCollide=true
    seat.Material=Enum.Material.Wood
    seat.Color=Kit.deep
    seat.Parent=root
    Studio.part(root,"Dossier sarcelle",Vector3.new(5.6,2.3,0.43),
        base*CFrame.new(0,2.8,-2.5),"deep",Enum.Material.Wood,false)
    for _,x in ipairs({-5.7,5.7}) do
        Studio.part(root,"Pilier en pierre",Vector3.new(0.6,6.8,0.6),
            base*CFrame.new(x,3.6,0),"deep",Enum.Material.Slate,false)
        Studio.facet(root,"Gemme de pergola",base*CFrame.new(x,6.85,0),0.55,2.2,"opal",true)
    end
    Studio.part(root,"Traverse de pergola",Vector3.new(12,0.55,0.7),
        base*CFrame.new(0,6.9,0),"gold",Enum.Material.Metal,false)
    for _,x in ipairs({-4.9,4.9}) do
        Studio.part(root,"Jardinière",Vector3.new(2.8,0.9,2.8),
            base*CFrame.new(x,0.65,2.3),"deep",Enum.Material.Slate,false)
        if Kit.profile~="LITE" then
            Studio.facet(root,"Flore minérale",base*CFrame.new(x,1.1,2.3),0.48,2.4,"opal",true)
        end
    end
    return root
end
function Stops.make(city,plan)
    local folder=Instance.new("Folder")
    folder.Name="Haltes de promenade cristallines v22"
    folder.Parent=city
    local index=0
    for routeIndex,path in ipairs(plan.pedestrian_paths) do
        local count=if Kit.profile=="LITE" then 1 else 2
        for n=1,count do
            local p,dir=pointAt(path,if n==1 then 0.37 else 0.64)
            if p and dir then
                index+=1
                restStop(folder,p,dir,index,if (routeIndex+n)%2==0 then 1 else -1)
            end
        end
    end
    return folder
end
return Stops
