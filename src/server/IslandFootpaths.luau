--!strict
-- Six boucles paysagères, 24 bornes de randonnée, 6 petits belvédères.
-- Les promenades sont physiques et accessibles sans téléportation.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("IslandDestinations"))
local Paths={}
local STONE=Color3.fromRGB(216,199,168)
local COPPER=Color3.fromRGB(207,165,102)
local NAVY=Color3.fromRGB(45,86,90)
local function simple(m,name,cf,size,color,material,collides)
    local part=F.part(m,name,size,cf,color,material)
    if collides==false then part.CanCollide=false;part.CanTouch=false end
    return part
end
function Paths.make(city)
    local root=F.folder(city,"Sentiers de l'archipel")
    for index,item in ipairs(Destinations) do
        local trail=F.folder(root,"Circuit de randonnée — "..item.title)
        local origin=Vector3.new(item.center_studs[1],0,item.center_studs[3])
        local base=CFrame.new(origin)*CFrame.Angles(0,math.pi/2-item.angle,0)
        local n=32
        local r=37
        for step=1,n do
            local a=(step-1)*math.pi*2/n
            local b=step*math.pi*2/n
            local av=(base*CFrame.new(math.cos(a)*r,0.95,math.sin(a)*r)).Position
            local bv=(base*CFrame.new(math.cos(b)*r,0.95,math.sin(b)*r)).Position
            local delta=bv-av
            simple(trail,"Chemin de ronde",CFrame.lookAt((av+bv)/2,bv),Vector3.new(4.5,0.28,delta.Magnitude+0.3),STONE,Enum.Material.Cobblestone,true)
            if step%4==0 then
                local lamp=simple(trail,"Balise du sentier",CFrame.new((av+bv)/2+Vector3.new(0,2.9,0)),Vector3.new(0.9,0.9,0.9),COPPER,Enum.Material.Neon,false)
                lamp.Shape=Enum.PartType.Ball
            end
        end
        for station=1,4 do
            local a=(station-1)*math.pi/2+0.32
            local pos=(base*CFrame.new(math.cos(a)*34,0,math.sin(a)*34)).Position
            local marker=simple(trail,"Halte insulaire "..station,CFrame.new(pos+Vector3.new(0,2.2,0)),Vector3.new(2.2,3.8,1.8),NAVY,Enum.Material.Metal,true)
            marker:SetAttribute("KinIslandTrailId",item.id..".stop."..station)
            marker:SetAttribute("KinTrailIslandId",item.id)
            marker:SetAttribute("KinTrailStopNumber",station)
            F.prompt(marker,"Découvrir","Halte du sentier")
            local rim=simple(trail,"Socle de la halte",CFrame.new(pos+Vector3.new(0,0.7,0)),Vector3.new(5,0.3,5),COPPER,Enum.Material.Cobblestone)
            rim.CanCollide=false
        end
        local spot=(base*CFrame.new(19,0.8,-31)).Position
        simple(trail,"Belvédère du sentier",CFrame.new(spot),Vector3.new(12,0.7,9),STONE,Enum.Material.WoodPlanks)
        for _,dx in ipairs({-5,5}) do
            local bar=simple(trail,"Garde-corps de belvédère",CFrame.new(spot+Vector3.new(dx,2.0,0)),Vector3.new(0.35,2.0,9),COPPER,Enum.Material.Metal,false)
            bar.CanCollide=false
        end
        trail:SetAttribute("KinTrailStops",4)
    end
    root:SetAttribute("KinTrailTotalStops",#Destinations*4)
    return root
end
return Paths
