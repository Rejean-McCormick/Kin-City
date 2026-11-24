--!strict
-- Signalétique par couleur, sur le réseau piéton ET les six avenues.
-- Tous les repères conservent un noyau sarcelle; ni les routes ni les portes ne bougent.
local F=require(script.Parent.Factory)
local Palette=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("HexagonalDistricts"))
local Chromatics={}
local function decal(parent,name,size,cf,color,material)
    local p=F.part(parent,name,size,cf,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    return p
end
local function segment(parent,a,b,section)
    local d=b-a
    local frame=CFrame.new((a+b)*0.5)*CFrame.Angles(0,-math.atan2(d.Z,d.X),0)
    decal(parent,"Tracé "..section.name,Vector3.new(d.Magnitude,0.18,2.0),frame,
        section.color,Enum.Material.SmoothPlastic).Transparency=0.16
    decal(parent,"Fil sarcelle",Vector3.new(d.Magnitude,0.22,0.31),
        frame*CFrame.new(0,0.12,0),Palette.base,Enum.Material.Neon)
end
function Chromatics.make(city,plan)
    local root=F.folder(city,"Repères chromatiques • 6 secteurs")
    root:SetAttribute("KinReferenceTeal","#1E6864")
    for _,s in ipairs(Palette.sections) do
        local axis=Vector3.new(s.x,0,s.z)
        for j=1,13 do
            local r=70+(j-1)*24
            local a=axis*r+Vector3.new(0,0.38,0)
            local b=axis*(r+17)+Vector3.new(0,0.38,0)
            segment(root,a,b,s)
        end
        for _,r in ipairs({102,290,391}) do
            local p=axis*r
            decal(root,"Balise "..s.name,Vector3.new(2.1,1.4,2.1),
                CFrame.new(p+Vector3.new(0,1.2,0)),s.color,Enum.Material.Neon).Transparency=0.1
            decal(root,"Socle sarcelle",Vector3.new(3.1,0.5,3.1),
                CFrame.new(p+Vector3.new(0,0.38,0)),Palette.base,Enum.Material.Metal)
        end
    end
    -- Fil de couleur près des sentiers canoniques : secteur calculé de la position.
    local seen={}
    for _,route in ipairs(plan.pedestrian_paths) do
        local pts=route.path_xyz_studs
        for i=2,#pts do
            local first=Vector3.new(pts[i-1][1],0,pts[i-1][3])
            local last=Vector3.new(pts[i][1],0,pts[i][3])
            local travel=last-first
            if travel.Magnitude>0 then
                for n=1,math.floor(travel.Magnitude/27) do
                    local p=first+travel.Unit*n*27
                    local key=math.floor(p.X/9)..":"..math.floor(p.Z/9)
                    if p.Magnitude>73 and not seen[key] then
                        local s=Palette.nearestAxis(p.X,p.Z)
                        if s then
                            seen[key]=true
                            local marker=decal(root,"Point de repère "..s.name,
                                Vector3.new(2.1,0.16,2.1),CFrame.new(p+Vector3.new(0,0.43,0)),
                                s.color,Enum.Material.Neon)
                            marker:SetAttribute("KinSector",s.key)
                        end
                    end
                end
            end
        end
    end
    return root
end
return Chromatics
