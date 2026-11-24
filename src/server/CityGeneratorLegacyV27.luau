--!strict
local Factory=require(script.Parent.Factory)
local FacadeGenerator=require(script.Parent.FacadeGenerator)
local UrbanDetails=require(script.Parent.UrbanDetails)
local Citizens=require(script.Parent.Citizens)
local DistrictLandmarks=require(script.Parent.DistrictLandmarks)
local Wildlife=require(script.Parent.Wildlife)
local PromenadeLife=require(script.Parent.PromenadeLife)
local OutdoorAtmosphere=require(script.Parent.OutdoorAtmosphere)
local InstitutionForecourts=require(script.Parent.InstitutionForecourts)
local ScenicCoast=require(script.Parent.ScenicCoast)
local PedestrianWayfinding=require(script.Parent.PedestrianWayfinding)
local WaterfrontDistrict=require(script.Parent.WaterfrontDistrict)
local ArtisanStreets=require(script.Parent.ArtisanStreets)
local InteractiveGardens=require(script.Parent.InteractiveGardens)
local LearningConservatories=require(script.Parent.LearningConservatories)
local DiscoveryPromenade=require(script.Parent.DiscoveryPromenade)
local OuterIslands=require(script.Parent.OuterIslands)
local MarinaDistrict=require(script.Parent.MarinaDistrict)
local IslandAnnexes=require(script.Parent.IslandAnnexes)
local IslandFootpaths=require(script.Parent.IslandFootpaths)
local ResidentialQuarters=require(script.Parent.ResidentialQuarters)
local CommunityBuildings=require(script.Parent.CommunityBuildings)
local IntermodalHub=require(script.Parent.IntermodalHub)
local CivicStages=require(script.Parent.CivicStages)
local PromenadeCommerce=require(script.Parent.PromenadeCommerce)
local SecondaryStreets=require(script.Parent.SecondaryStreets)
local CooperativeInstallations=require(script.Parent.CooperativeInstallations)
local StationArcades=require(script.Parent.StationArcades)
local PublicWorkshops=require(script.Parent.PublicWorkshops)
local CrystalPublic=require(script.Parent.CrystalPublic)
local OpalWayfindingV19=require(script.Parent.OpalWayfindingV19)
local BotanicalKitV20=require(script.Parent.BotanicalKitV20)
local CrystalRestStopsV22=require(script.Parent.CrystalRestStopsV22)
local CrystalLandingsV24=require(script.Parent.CrystalLandingsV24)
local CityGenerator={}

local function nearestBuildings(x,z,structures)
    for _,b in ipairs(structures) do
        local cx,_,cz=table.unpack(b.center_studs)
        local yaw=math.rad(b.yaw_degrees)
        local dx=x-cx
        local dz=z-cz
        local localX=math.cos(yaw)*dx-math.sin(yaw)*dz
        local localZ=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(localX)<b.footprint_studs[1]/2+14 and math.abs(localZ)<b.footprint_studs[2]/2+14 then return true end
    end
    return false
end

local function distanceToPath(x,z,path)
    local p=Vector3.new(x,0,z)
    local nearest=math.huge
    for i=2,#path.path_xyz_studs do
        local a=path.path_xyz_studs[i-1]
        local b=path.path_xyz_studs[i]
        local av=Vector3.new(a[1],0,a[3])
        local bv=Vector3.new(b[1],0,b[3])
        local segment=bv-av
        if segment.Magnitude>0.1 then
            local t=math.clamp((p-av):Dot(segment)/segment:Dot(segment),0,1)
            nearest=math.min(nearest,(p-(av+segment*t)).Magnitude)
        end
    end
    return nearest
end
local function tree(parent,x,z,seed)
    return BotanicalKitV20.tree(parent,x,z,seed)
end

local function pavement(parent,name,a,b,width,color)
    local vector=b-a
    local length=Vector3.new(vector.X,0,vector.Z).Magnitude
    if length<0.5 then return end
    local midpoint=(a+b)/2
    Factory.part(parent,name,Vector3.new(width,0.24,length),CFrame.lookAt(Vector3.new(midpoint.X,0.09,midpoint.Z),Vector3.new(b.X,0.09,b.Z)),color,Enum.Material.Cobblestone)
end

function CityGenerator.make(parent,plan,buildingsById)
    local city=Factory.folder(parent,"Ville")
    local disk=Factory.part(city,"Île circulaire",Vector3.new(2,990,990),CFrame.new(0,-1,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(84,141,107),Enum.Material.Grass)
    disk.Shape=Enum.PartType.Cylinder
    local water=Factory.part(city,"Lac périphérique",Vector3.new(1,1800,1800),CFrame.new(0,-3.8,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(47,125,163),Enum.Material.SmoothPlastic)
    water.Shape=Enum.PartType.Cylinder
    local plaza=Factory.part(city,"Place centrale",Vector3.new(2,110,110),CFrame.new(0,0,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(198,220,211),Enum.Material.Cobblestone)
    plaza.Shape=Enum.PartType.Cylinder
    plaza.CanCollide=false
    local roads=Factory.folder(city,"Sentiers piétons")
    for _,path in ipairs(plan.pedestrian_paths) do
        for i=2,#path.path_xyz_studs do
            local p=path.path_xyz_studs[i-1]
            local q=path.path_xyz_studs[i]
            pavement(roads,path.building_id,Vector3.new(p[1],0,p[3]),Vector3.new(q[1],0,q[3]),path.width_studs,Color3.fromRGB(211,200,175))
        end
    end
    local facades=Factory.folder(city,"Bâtiments")
    for _,b in ipairs(plan.structures) do
        local building=buildingsById[b.building_id]
        assert(building,"Missing building: "..b.building_id)
        FacadeGenerator.make(facades,b,building,plan.styles[b.style_id])
    end
    local gardens=Factory.folder(city,"Nature")
    local rng=Random.new(plan.seed)
    local planted=0
    for i=1,185 do
        local angle=rng:NextNumber(0,2*math.pi)
        local radius=rng:NextNumber(90,465)
        local x,z=math.cos(angle)*radius,math.sin(angle)*radius
        if not nearestBuildings(x,z,plan.structures) and not InstitutionForecourts.isReserved(x,z,plan.structures) and not LearningConservatories.isReserved(x,z) and not DiscoveryPromenade.isReserved(x,z) and not ResidentialQuarters.isReserved(x,z) and not CommunityBuildings.isReserved(x,z) and not IntermodalHub.isReserved(x,z) and not CivicStages.isReserved(x,z) and not PromenadeCommerce.isReserved(x,z) and not CooperativeInstallations.isReserved(x,z) and not SecondaryStreets.isReserved(x,z) and not StationArcades.isReserved(x,z) and not PublicWorkshops.isReserved(x,z) then
            local blockedPath=false
            for _,path in ipairs(plan.pedestrian_paths) do
                if distanceToPath(x,z,path)<path.width_studs/2+7 then
                    blockedPath=true
                    break
                end
            end
            if not blockedPath then
                tree(gardens,x,z,i);planted+=1
            end
        end
    end
    local monument=Factory.part(city,"Monument du savoir",Vector3.new(5,19,5),CFrame.new(0,9.5,39),Color3.fromRGB(30,104,100),Enum.Material.Marble)
    -- Grand panneau redondant supprimé.
    local spawn=Instance.new("SpawnLocation")
    spawn.Name="Arrivée Kin City"
    spawn.Size=Vector3.new(12,1,12)
    spawn.CFrame=CFrame.new(0,0.8,0)
    spawn.Anchored=true
    spawn.Neutral=true
    spawn.CanCollide=true
    spawn.Transparency=0.25
    spawn.Parent=city
    UrbanDetails.make(city,plan)
    InstitutionForecourts.make(city,plan)
    CrystalLandingsV24.make(city,plan)
    ScenicCoast.make(city)
    WaterfrontDistrict.make(city)
    OuterIslands.make(city)
    MarinaDistrict.make(city)
    IslandAnnexes.make(city)
    IslandFootpaths.make(city)
    ResidentialQuarters.make(city)
    CommunityBuildings.make(city)
    IntermodalHub.make(city)
    StationArcades.make(city)
    PublicWorkshops.make(city)
    CivicStages.make(city)
    CooperativeInstallations.make(city)
    PromenadeCommerce.make(city)
    SecondaryStreets.make(city)
    ArtisanStreets.make(city,plan)
    InteractiveGardens.make(city,plan)
    LearningConservatories.make(city)
    DiscoveryPromenade.make(city)
    PedestrianWayfinding.make(city,plan,buildingsById)
    DistrictLandmarks.make(city,plan)
    PromenadeLife.make(city,plan)
    OutdoorAtmosphere.make(city)
    Citizens.make(city)
    Wildlife.make(city)
    CrystalPublic.make(city)
    OpalWayfindingV19.make(city,plan)
    CrystalRestStopsV22.make(city,plan)
    return city
end
return CityGenerator

