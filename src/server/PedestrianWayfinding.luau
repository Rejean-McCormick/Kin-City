--!strict
-- Réseau de jalonnement de la ville. Suit les itinéraires calculés par le compilateur.
local F=require(script.Parent.Factory)
local Wayfinding={}
local STONE=Color3.fromRGB(220,204,171)
local BRASS=Color3.fromRGB(194,155,95)
local INK=Color3.fromRGB(38,69,78)
function Wayfinding.make(city,plan,buildingsById)
    local folder=F.folder(city,"Jalonnement piéton")
    local total=0
    local marked={}
    local signs={}
    for _,path in ipairs(plan.pedestrian_paths) do
        local points=path.path_xyz_studs
        local building=buildingsById[path.building_id]
        local name=building and building.name or path.building_id
        for idx=2,#points do
            local prev=points[idx-1]
            local next=points[idx]
            local a=Vector3.new(prev[1],0,prev[3])
            local b=Vector3.new(next[1],0,next[3])
            local vec=b-a
            local len=vec.Magnitude
            if len>6 then
                local direction=vec.Unit
                local cross=Vector3.new(-direction.Z,0,direction.X)
                -- Pastilles au sol, espacées; n'interfèrent pas avec les déplacements.
                for step=1,math.floor(len/20) do
                    local t=step*20
                    if t<len-4 then
                        local pos=a+direction*t
                        local key=string.format("%d:%d",math.floor(pos.X/4+0.5),math.floor(pos.Z/4+0.5))
                        if not marked[key] and pos.Magnitude>56 then
                            marked[key]=true
                            local circle=F.part(folder,"Repère de parcours",Vector3.new(0.13,2.2,2.2),CFrame.new(pos+Vector3.new(0,0.29,0)),BRASS,Enum.Material.Metal)
                            circle.Shape=Enum.PartType.Cylinder
                            circle.CFrame=circle.CFrame*CFrame.Angles(0,0,math.pi/2)
                            circle.CanCollide=false
                        end
                    end
                end
                -- Pas plus de trois poteaux par trajet : lisibilité et budget de parts.
                local point=a+direction*math.min(len-2,9)+cross*6.5
                -- Réserver le centre aux joueurs et à leur caméra.
                -- La demi-largeur des panneaux (9.5) reste hors du disque de 28 studs.
                local far=point.Magnitude>=72
                local clear=true
                for _,b in ipairs(plan.structures) do
                    local center=Vector3.new(b.center_studs[1],0,b.center_studs[3])
                    local relative=point-center
                    local yaw=math.rad(b.yaw_degrees)
                    local xx=math.cos(yaw)*relative.X-math.sin(yaw)*relative.Z
                    local zz=math.sin(yaw)*relative.X+math.cos(yaw)*relative.Z
                    if math.abs(xx)<b.footprint_studs[1]/2+13 and math.abs(zz)<b.footprint_studs[2]/2+13 then clear=false;break end
                end
                for _,existing in ipairs(signs) do
                    if (existing-point).Magnitude<25 then clear=false;break end
                end
                if not signs[path.building_id] and far and clear then
                    local post=F.part(folder,"Poteau d'orientation",Vector3.new(0.7,8,0.7),CFrame.new(point+Vector3.new(0,4.0,0)),INK,Enum.Material.Metal)
                    local yaw=math.deg(math.atan2(-direction.X,-direction.Z))
                    local label=F.sign(folder,"Vers "..name,point+Vector3.new(0,8.2,0),yaw,"→ "..name,19,3.1)
                    label.CanCollide=false
                    table.insert(signs,point)
                    signs[path.building_id]=true
                    total+=1
                end
            end
        end
    end
    -- Garantit une indication unique pour chaque institution, même proche de la place.
    -- Déplacement automatique hors des empreintes réelles et des panneaux voisins.
    for n,path in ipairs(plan.pedestrian_paths) do
        if not signs[path.building_id] then
            local building=buildingsById[path.building_id]
            local goal=path.path_xyz_studs[#path.path_xyz_studs]
            local bearing=math.atan2(goal[3],goal[1])
            local found=nil
            for _,radius in ipairs({115,145,175}) do
                if found then break end
                for offset=-12,12 do
                    local angle=bearing+offset*math.pi/24
                    local pos=Vector3.new(math.cos(angle)*radius,0,math.sin(angle)*radius)
                    local clear=true
                    for _,b in ipairs(plan.structures) do
                        local center=Vector3.new(b.center_studs[1],0,b.center_studs[3])
                        local delta=pos-center
                        local rot=math.rad(b.yaw_degrees)
                        local xx=math.cos(rot)*delta.X-math.sin(rot)*delta.Z
                        local zz=math.sin(rot)*delta.X+math.cos(rot)*delta.Z
                        if math.abs(xx)<b.footprint_studs[1]/2+13 and math.abs(zz)<b.footprint_studs[2]/2+13 then clear=false;break end
                    end
                    for _,existing in ipairs(signs) do
                        if (existing-pos).Magnitude<26 then clear=false;break end
                    end
                    if clear then found=pos;break end
                end
            end
            if found then
                local dir=(Vector3.new(goal[1],0,goal[3])-found).Unit
                F.part(folder,"Poteau d'orientation",Vector3.new(0.7,8,0.7),CFrame.new(found+Vector3.new(0,4,0)),INK,Enum.Material.Metal)
                local sign=F.sign(folder,"Vers "..(building and building.name or path.building_id),found+Vector3.new(0,8.2,0),math.deg(math.atan2(-dir.X,-dir.Z)),"→ "..(building and building.name or path.building_id),19,3.1)
                sign.CanCollide=false
                table.insert(signs,found);signs[path.building_id]=true;total+=1
            else
                warn("Kin City : aucune implantation sans obstacle pour le panneau de "..path.building_id)
            end
        end
    end
    folder:SetAttribute("KinDirectionSigns",total)
    return folder
end
return Wayfinding
