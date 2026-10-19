--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("KinCityShared")
local WorldPlan = require(Shared:WaitForChild("WorldPlan"))
local PlaceRouting = require(Shared:WaitForChild("PlaceRouting"))
local RuntimeConfig = require(Shared:WaitForChild("RuntimeConfig"))
local RunService = game:GetService("RunService")
local InteriorOrigins = require(Shared:WaitForChild("InteriorOrigins"))

local Spatial = {}
local byPlace = {}
for index, p in ipairs(WorldPlan.places) do
    byPlace[p.place_key] = p
end

function Spatial.mode()
    return RuntimeConfig.mode
end

function Spatial.currentPlace()
    if RuntimeConfig.mode == "LOCAL_UNIVERSE" then return "city" end
    -- Les aperçus sont des Places indépendantes, pas des poches à 3 km dans la ville.
    if RuntimeConfig.mode == "SPLIT_PREVIEW" then
        local key = RuntimeConfig.target_place_key
        assert(type(key)=="string" and byPlace[key],"Cible d'aperçu inconnue")
        return key
    end
    -- En publication, le PlaceId Roblox fait autorité : un script installé dans
    -- la mauvaise Place ne doit JAMAIS instancier silencieusement un autre lieu.
    for key, id in pairs(PlaceRouting) do
        if id == game.PlaceId and id ~= nil then
            assert(RuntimeConfig.target_place_key==nil or RuntimeConfig.target_place_key==key,
                "Installateur appliqué à la mauvaise Place: "..tostring(key))
            return key
        end
    end
    -- Une Place neuve non publiée peut être prévisualisée depuis Studio uniquement.
    if RunService:IsStudio() and game.PlaceId==0 then
        local key=RuntimeConfig.target_place_key
        assert(type(key)=="string" and byPlace[key],"Cible MULTI_PLACE absente de Studio")
        return key
    end
    error("PlaceId courant absent du registre Kin City: " .. tostring(game.PlaceId))
end

function Spatial.place(key)
    return byPlace[key]
end

function Spatial.origin(key)
    if RuntimeConfig.mode ~= "LOCAL_UNIVERSE" or key == "city" then return Vector3.zero end
    -- Origines stables par identifiant : insensibles à l'ordre du catalogue.
    local coordinate=InteriorOrigins[key]
    assert(coordinate,"Origine intérieure absente: "..tostring(key))
    return Vector3.new(coordinate[1],coordinate[2],coordinate[3])
end

function Spatial.position(key, xyz)
    return Spatial.origin(key) + Vector3.new(xyz[1], xyz[2], xyz[3])
end

function Spatial.anchor(key, id)
    local p = byPlace[key]
    if not p then return nil end
    for _, a in ipairs(p.anchors) do
        if a.anchor_id == id then return a end
    end
    return nil
end

function Spatial.anchorCFrame(key, id)
    local anchor = Spatial.anchor(key, id)
    if not anchor then return nil end
    return CFrame.new(Spatial.position(key, anchor.position_studs)) * CFrame.Angles(0, math.rad(anchor.yaw_degrees or 0), 0)
end

function Spatial.placeId(key)
    return PlaceRouting[key]
end

function Spatial.styleForPlace(key)
    for _, door in ipairs(WorldPlan.doors) do
        if door.destination_place_key == key and door.source_place_key == "city" then
            for _, structure in ipairs(WorldPlan.structures) do
                if structure.building_id == door.building_id then
                    return WorldPlan.styles[structure.style_id]
                end
            end
        end
    end
    return WorldPlan.styles.civic_stone
end

return Spatial
