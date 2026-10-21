--!strict
-- Filigranes v29 : unions collinéaires des itinéraires du plan, non solidaires du sol.
-- Aucun trait doublé lorsque deux destinations empruntent le même segment.
local Kit=require(script.Parent.CrystalKit)
local Wayfinding={}
local function addSegment(groups,a,b)
    local horizontal=a[3]==b[3]
    local fixed=if horizontal then a[3] else a[1]
    local first=math.min(if horizontal then a[1] else a[3],if horizontal then b[1] else b[3])
    local last=math.max(if horizontal then a[1] else a[3],if horizontal then b[1] else b[3])
    if last-first<0.1 then return end
    local key=(if horizontal then "H" else "V")..":"..tostring(fixed)
    if not groups[key] then groups[key]={horizontal=horizontal,fixed=fixed,intervals={}} end
    table.insert(groups[key].intervals,{first,last})
end
local function stripe(folder,a,b,side,color,isVertical)
    local direction=b-a
    local distance=direction.Magnitude
    if distance<3 then return end
    local forward=direction.Unit
    local perpendicular=Vector3.new(forward.Z,0,-forward.X)
    local center=(a+b)/2+perpendicular*side
    -- Croisements transversaux sur un plan visuel distinct pour éviter les faces coplanaires.
    local y=if isVertical then 0.292 else 0.27
    center=Vector3.new(center.X,y,center.Z)
    local part=Kit.part(folder,"Part","Veine de guidage unifiée",Vector3.new(0.24,0.08,distance),CFrame.lookAt(center,center+forward),color,Enum.Material.Metal)
    part.CanCollide=false;part.CanTouch=false;part.CanQuery=false;part.CastShadow=false
    part:SetAttribute("KinOptionalDetail",true)
end
function Wayfinding.make(city,plan)
    local folder=Instance.new("Folder")
    folder.Name="Filigranes de promenade — v29"
    folder.Parent=city
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v29")
    local density=Kit.profile=="LITE" and 1 or 2
    local groups={}
    for _,route in ipairs(plan.pedestrian_paths) do
        for i=2,#route.path_xyz_studs do
            addSegment(groups,route.path_xyz_studs[i-1],route.path_xyz_studs[i])
        end
    end
    local count=0
    local keys={}
    for key in pairs(groups) do table.insert(keys,key) end
    table.sort(keys)
    for _,key in ipairs(keys) do
        local group=groups[key]
        table.sort(group.intervals,function(a,b)return a[1]<b[1] end)
        local merged={}
        for _,interval in ipairs(group.intervals) do
            local last=merged[#merged]
            if last and interval[1]<=last[2]+0.001 then
                last[2]=math.max(last[2],interval[2])
            else
                table.insert(merged,{interval[1],interval[2]})
            end
        end
        for _,interval in ipairs(merged) do
            local a,b
            if group.horizontal then
                a=Vector3.new(interval[1],0,group.fixed)
                b=Vector3.new(interval[2],0,group.fixed)
            else
                a=Vector3.new(group.fixed,0,interval[1])
                b=Vector3.new(group.fixed,0,interval[2])
            end
            local side=math.max(1.25,math.min(6*0.31,3.5))
            stripe(folder,a,b,-side,Kit.primary,not group.horizontal)
            count+=1
            if density==2 then
                stripe(folder,a,b,side,Kit.gold,not group.horizontal)
                count+=1
            end
        end
    end
    folder:SetAttribute("KinMergedOpalVeins",count)
    return folder
end
return Wayfinding
