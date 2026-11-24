--!strict
-- v31.6 : uniquement des pastilles au sol sur les chemins piétons.
-- Les noms des destinations sont déjà inscrits sur chaque façade, et les six
-- portiques de l'hexagone assurent la direction. Aucun poteau doublon.
local F=require(script.Parent.Factory)
local Wayfinding={}
local BRASS=Color3.fromRGB(194,155,95)
function Wayfinding.make(city,plan,buildingsById)
    local folder=F.folder(city,"Jalonnement piéton")
    local marked={}
    local total=0
    for _,path in ipairs(plan.pedestrian_paths) do
        local points=path.path_xyz_studs
        for index=2,#points do
            local previous=points[index-1]
            local following=points[index]
            local a=Vector3.new(previous[1],0,previous[3])
            local b=Vector3.new(following[1],0,following[3])
            local vector=b-a
            local distance=vector.Magnitude
            if distance>6 then
                local direction=vector.Unit
                for step=1,math.floor(distance/20) do
                    local t=step*20
                    if t<distance-4 then
                        local position=a+direction*t
                        local key=string.format("%d:%d",math.floor(position.X/4+0.5),math.floor(position.Z/4+0.5))
                        if not marked[key] and position.Magnitude>56 then
                            marked[key]=true
                            local marker=F.part(folder,"Repère de parcours",Vector3.new(0.13,2.2,2.2),
                                CFrame.new(position+Vector3.new(0,0.29,0)),BRASS,Enum.Material.Metal)
                            marker.Shape=Enum.PartType.Cylinder
                            marker.CFrame=marker.CFrame*CFrame.Angles(0,0,math.pi/2)
                            marker.CanCollide=false
                            total+=1
                        end
                    end
                end
            end
        end
    end
    folder:SetAttribute("KinDirectionSigns",0)
    folder:SetAttribute("KinGroundMarkers",total)
    return folder
end
return Wayfinding
