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
                        local circle=F.part(folder,"Repère de parcours",Vector3.new(0.13,2.2,2.2),CFrame.new(pos+Vector3.new(0,0.29,0)),BRASS,Enum.Material.Metal)
                        circle.Shape=Enum.PartType.Cylinder
                        circle.CFrame=circle.CFrame*CFrame.Angles(0,0,math.pi/2)
                        circle.CanCollide=false
                    end
                end
                -- Pas plus de trois poteaux par trajet : lisibilité et budget de parts.
                if idx<=4 then
                    local point=a+direction*math.min(len-2,9)+cross*6.5
                    local post=F.part(folder,"Poteau d'orientation",Vector3.new(0.7,8,0.7),CFrame.new(point+Vector3.new(0,4.0,0)),INK,Enum.Material.Metal)
                    local yaw=math.deg(math.atan2(-direction.X,-direction.Z))
                    local label=F.sign(folder,"Vers "..name,point+Vector3.new(0,8.2,0),yaw,"→ "..name,19,3.1)
                    label.CanCollide=false
                    total+=1
                end
            end
        end
    end
    folder:SetAttribute("KinDirectionSigns",total)
    return folder
end
return Wayfinding
