--!strict
-- Incrustations opalines intégrées dans le pavage (sans collision ni éclairages coûteux).
-- Parcours dérivés des mêmes points que les véritables sentiers piétons.
local Kit=require(script.Parent.CrystalKit)
local Wayfinding={}
local function stripe(folder,p,q,offset,color)
    local direction=q-p
    local horizontal=Vector3.new(direction.X,0,direction.Z)
    local distance=horizontal.Magnitude
    if distance<3 then return end
    local forward=horizontal.Unit
    local sideways=Vector3.new(forward.Z,0,-forward.X)
    local center=(p+q)*0.5+sideways*offset
    center=Vector3.new(center.X,0.27,center.Z)
    local frame=CFrame.lookAt(center,center+forward)
    local part=Kit.part(folder,"Part","Veine de guidage",Vector3.new(0.24,0.08,distance),frame,color,Enum.Material.Metal)
    part:SetAttribute("KinOptionalDetail",true)
end
function Wayfinding.make(city,plan)
    local folder=Instance.new("Folder")
    folder.Name="Filigranes de promenade — v19"
    folder.Parent=city
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    local density=Kit.profile=="LITE" and 1 or 2
    for routeIndex,path in ipairs(plan.pedestrian_paths) do
        for i=2,#path.path_xyz_studs do
            local a,b=path.path_xyz_studs[i-1],path.path_xyz_studs[i]
            local p=Vector3.new(a[1],0,a[3])
            local q=Vector3.new(b[1],0,b[3])
            local halfWidth=math.max(1.25,math.min(path.width_studs*0.31,3.5))
            stripe(folder,p,q,-halfWidth,Kit.primary)
            if density==2 then stripe(folder,p,q,halfWidth,Kit.gold) end
        end
    end
    return folder
end
return Wayfinding
