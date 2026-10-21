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
local GroundCompatibility=require(script.Parent.GroundCompatibility)
local Spatial=require(script.Parent.Spatial)
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

-- v29 : union discrète des routes alignées sur la grille canonique de 10 studs.
-- Un seul carreau par noeud et un seul tronçon par arête, sans surfaces coplanaires.
-- Au centre, la Place centrale couvre le sol : ne pas générer de pavés cachés.
local function streetTiles(folder,paths)
    local nodes,edges={},{}
    local function nodeKey(x,z) return string.format("%d:%d",x,z) end
    local function addNode(x,z)
        local key=nodeKey(x,z)
        if Vector2.new(x,z).Magnitude>56 then nodes[key]={x,z} end
    end
    for _,path in ipairs(paths) do
        local pts=path.path_xyz_studs
        for i=2,#pts do
            local a,b=pts[i-1],pts[i]
            local dx=if a[1]~=b[1] then (b[1]>a[1] and 10 or -10) else 0
            local dz=if a[3]~=b[3] then (b[3]>a[3] and 10 or -10) else 0
            if dx~=0 or dz~=0 then
                local steps=math.floor((math.abs(b[1]-a[1])+math.abs(b[3]-a[3]))/10+0.5)
                for j=0,steps do
                    local x,z=a[1]+j*dx,a[3]+j*dz
                    addNode(x,z)
                    if j>0 then
                        local px,pz=x-dx,z-dz
                        local midx,midz=(px+x)/2,(pz+z)/2
                        if Vector2.new(px,pz).Magnitude>56 and Vector2.new(x,z).Magnitude>56 then
                            local key=if dx~=0 then "H:"..nodeKey(midx,midz) else "V:"..nodeKey(midx,midz)
                            edges[key]={midx,midz,dx~=0}
                        end
                    end
                end
            end
        end
    end
    -- Raster de 2 studs : cellules disjointes, puis fusion par rangées contiguës.
    -- La forme visible et la forme de collision utilisent les mêmes rectangles.
    local rows={}
    local function cell(x,z)
        local ix,iz=math.floor(x/2+0.5),math.floor(z/2+0.5)
        rows[iz]=rows[iz] or {}
        rows[iz][ix]=true
    end
    for _,v in pairs(nodes) do
        for dx=-2,2,2 do
            for dz=-2,2,2 do cell(v[1]+dx,v[2]+dz) end
        end
    end
    for _,v in pairs(edges) do
        if v[3] then
            for dx=-1,1,2 do
                for dz=-2,2,2 do cell(v[1]+dx,v[2]+dz) end
            end
        else
            for dx=-2,2,2 do
                for dz=-1,1,2 do cell(v[1]+dx,v[2]+dz) end
            end
        end
    end
    local color=Color3.fromRGB(211,200,175)
    local count=0
    local function emit(r)
        local x1,x2,z1,z2=r[1],r[2],r[3],r[4]
        local width=(x2-x1+1)*2
        local depth=(z2-z1+1)*2
        local tile=Factory.part(folder,"Chemin unifié",Vector3.new(width,0.24,depth),CFrame.new(x1+x2,0.09,z1+z2),color,Enum.Material.Cobblestone)
        tile.CanCollide=true;count+=1
    end
    local zs={}
    for z in pairs(rows) do table.insert(zs,z) end
    table.sort(zs)
    local active={}
    for _,z in ipairs(zs) do
        local xs={}
        for x in pairs(rows[z]) do table.insert(xs,x) end
        table.sort(xs)
        local runs={}
        for _,x in ipairs(xs) do
            local last=runs[#runs]
            if last and x==last[2]+1 then last[2]=x
            else table.insert(runs,{x,x}) end
        end
        local nextActive={}
        for _,run in ipairs(runs) do
            local key=tostring(run[1])..":"..tostring(run[2])
            local old=active[key]
            if old and old[4]==z-1 then
                old[4]=z;nextActive[key]=old
            else
                nextActive[key]={run[1],run[2],z,z}
            end
        end
        for key,r in pairs(active) do
            if not nextActive[key] then emit(r) end
        end
        active=nextActive
    end
    for _,r in pairs(active) do emit(r) end
    folder:SetAttribute("KinUniquePavementPieces",count)
    folder:SetAttribute("KinPavementUnionV29",true)
end

function CityGenerator.make(parent,plan,buildingsById)
    GroundCompatibility.prepare()
    local city=Factory.folder(parent,"Ville")
    local disk=Factory.part(city,"Île circulaire",Vector3.new(2,990,990),CFrame.new(0,-1,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(84,141,107),Enum.Material.Grass)
    disk.Shape=Enum.PartType.Cylinder
    local water=Factory.part(city,"Lac périphérique",Vector3.new(1,1800,1800),CFrame.new(0,-3.8,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(47,125,163),Enum.Material.SmoothPlastic)
    water.Shape=Enum.PartType.Cylinder
    local plaza=Factory.part(city,"Place centrale",Vector3.new(2,110,110),CFrame.new(0,0,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(198,220,211),Enum.Material.Cobblestone)
    plaza.Shape=Enum.PartType.Cylinder
    plaza.CanCollide=true
    local roads=Factory.folder(city,"Sentiers piétons")
    streetTiles(roads,plan.pedestrian_paths)
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
    for _,item in ipairs(plan.navigation_obstacles) do
        if item.kind=="monument" then
            Factory.part(city,"Monument du savoir",Vector3.new(5,19,5),CFrame.new(item.center_studs[1],9.5,item.center_studs[2]),Color3.fromRGB(30,104,100),Enum.Material.Marble)
        elseif item.kind=="welcome" then
            Factory.sign(city,"Bienvenue",Vector3.new(item.center_studs[1],7,item.center_studs[2]),0,"KIN CITY",28,5).CanCollide=false
        end
    end
    local spawn=Instance.new("SpawnLocation")
    spawn.Name="Arrivée Kin City"
    spawn.Size=Vector3.new(12,1,12)
    local arrival=assert(Spatial.anchorCFrame("city","city.central.spawn"))
    spawn.CFrame=arrival*CFrame.new(0,-2.2,0)
    spawn.Anchored=true
    spawn.Neutral=true
    spawn.CanCollide=true
    spawn.Transparency=1
    spawn.Duration=0
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
