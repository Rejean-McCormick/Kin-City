--!strict
-- Soundscape est optionnel : les WAV sont livrés et doivent être importés
-- par l'auteur dans Roblox. Les sons vides n'entravent jamais le chargement.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Config=require(Shared:WaitForChild("AudioManifest"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Residential=require(Shared:WaitForChild("ResidentialDestinations"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local F=require(script.Parent.Factory)
local Audio={}
local function attach(parent,name,id,volume,radius,looped)
    if type(id)~="number" or id<=0 then return end
    local s=Instance.new("Sound")
    s.Name=name
    s.SoundId="rbxassetid://"..tostring(id)
    s.Volume=volume
    s.RollOffMode=Enum.RollOffMode.Inverse
    s.RollOffMaxDistance=radius
    s.RollOffMinDistance=8
    s.Looped=looped
    s.Parent=parent
    s:Play()
    return s
end
function Audio.start(world)
    if not Config.enabled then return end
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local stations=F.folder(city,"Stations sonores")
    local function emitter(title,xyz,soundId,volume,maxDist)
        local p=F.part(stations,title,Vector3.new(0.6,0.6,0.6),CFrame.new(xyz),Color3.new(1,1,1),Enum.Material.SmoothPlastic)
        p.Transparency=1;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
        attach(p,title,soundId,volume,maxDist,true)
    end
    emitter("Vent dans les jardins",Vector3.new(0,8,175),Config.botanical_sound_id or Config.wind_sound_id,0.24,220)
    emitter("Fontaines de la place",Vector3.new(0,4,0),Config.water_sound_id,0.25,95)
    emitter("Promenade du musée",Vector3.new(-202,6,-180),Config.chimes_sound_id,0.12,75)
    emitter("Ambiance des quais",Vector3.new(35,5,420),Config.harbor_sound_id,0.12,90)
    -- Ambiance localisée : cinq pistes originales en plus du trio historique.
    -- Aucune piste n'est obligatoire; les IDs restent nuls jusqu'à l'import Roblox.
    local tones={
        city_hall=Config.civic_sound_id,
        ekoh_tower=Config.chimes_sound_id,
        library=Config.archives_sound_id,
        campus=Config.botanical_sound_id,
        justice_palace=Config.civic_sound_id,
        innovation_lab=Config.laboratory_sound_id,
        museum=Config.chimes_sound_id,
        orgo_center=Config.laboratory_sound_id,
    }
    local placesByBuilding={}
    for _,b in ipairs(Buildings) do placesByBuilding[b.building_id]=b.interior_place_key end
    for i,building in ipairs(Plan.structures) do
        local xyz=building.center_studs
        if xyz then
            emitter("Ambiance · "..building.building_id,
                Vector3.new(xyz[1],6,xyz[3]),tones[placesByBuilding[building.building_id]] or Config.chimes_sound_id,0.08,62)
        end
    end
    for i,quarter in ipairs(Residential) do
        local xyz=quarter.center_studs
        if xyz then
            emitter("Jardin habité "..i,Vector3.new(xyz[1],5,xyz[3]),Config.wind_sound_id,0.09,65)
        end
    end
end
return Audio
