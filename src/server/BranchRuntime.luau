--!strict
-- KC35 B09: reviewed branch overlays, deterministic and idempotent.
-- Applied after WorldBuilder.build, in Studio Edition and at server Play start.
-- Never modifies portals, PlaceIds, canonical plan, transport or remote bindings.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local Visual=require(Shared:WaitForChild("VisualConfig"))
local Runtime={}
local REVISION="KC35-BRANCH-RUNTIME-1"
local ORDER={"city_hall","ekoh_tower","library","campus","justice_palace","innovation_lab","museum","orgo_center","city"}
local EXPECTED={
    city_hall="B01",ekoh_tower="B02",library="B03",campus="B04",justice_palace="B05",
    innovation_lab="B06",museum="B07",orgo_center="B08",city="B10",
}

local function invoke(key:string,model:Instance?,origin:Vector3,profile:string,world:Instance):any
    assert(model,"KC35: modèle absent : "..key)
    local context={place_key=key,placeKey=key,contracts_version="KC34-DOC-1.0",
        place_model=model,placeModel=model,interiorModel=model,model=model,
        parent=model,origin=origin,profile=profile,authorized=true,replace_decoration=false}
    if key=="city_hall" then
        return require(script.Parent.B01CityHallScene).build(context)
    elseif key=="ekoh_tower" then
        return require(script.Parent.B02EkohInterior).Build(context)
    elseif key=="library" then
        return require(script.Parent.B03LibraryScene).build(context)
    elseif key=="campus" then
        return require(script.Parent.B04CampusDecor).build(model,origin,profile)
    elseif key=="justice_palace" then
        return require(script.Parent.B05KorumPreview).build(context)
    elseif key=="innovation_lab" then
        return require(script.Parent.B06KonstructScene).build(context)
    elseif key=="museum" then
        return require(script.Parent.B07MuseumScene).build(context)
    elseif key=="orgo_center" then
        return require(script.Parent.B08OrgoScene).build(context)
    elseif key=="city" then
        return require(script.Parent.B10WayfindingKC36).build(model,Plan,Districts,profile)
    end
    error("KC35: clé inconnue "..key)
end

function Runtime.apply(state:any):any
    assert(state and state.world,"KC35: world attendu")
    local world=state.world
    assert(world:GetAttribute("KinBuildState")=="Ready","KC35: monde non prêt")
    local mode=state.mode or world:GetAttribute("KinRoutingMode")
    local active=state.currentPlace or world:GetAttribute("KinActivePlace")
    local profile=Visual.profile
    assert(profile=="LITE" or profile=="STANDARD" or profile=="SHOWCASE","KC35: profil inconnu")
    local candidates={}
    for _,key in ipairs(ORDER) do
        if mode=="LOCAL_UNIVERSE" or key==active then table.insert(candidates,key) end
    end
    -- Validate all destinations BEFORE decorating anything; no silent omission.
    local interiorRoot=world:FindFirstChild("Bâtiments visitables")
    local interiors={}
    for _,key in ipairs(candidates) do
        if key=="city" then
            assert(world:FindFirstChild("Ville"),"KC35: Ville absente")
        else
            local m=interiorRoot and interiorRoot:FindFirstChild("Intérieur — "..key)
            assert(m and m:IsA("Model"),"KC35: intérieur manquant : "..key)
            assert(m:GetAttribute("KinPlaceKey")==key,"KC35: attribut Place invalide : "..key)
            assert(typeof(m:GetAttribute("KinInteriorOrigin"))=="Vector3","KC35: origine manquante : "..key)
            interiors[key]=m
        end
    end
    local completed=0
    local failed={}
    for _,key in ipairs(candidates) do
        local model=if key=="city" then world:FindFirstChild("Ville") else interiors[key]
        local origin=if key=="city" then Vector3.zero else (model::Instance):GetAttribute("KinInteriorOrigin")
        local ok,res=pcall(function() return invoke(key,model,origin,profile,world) end)
        if ok then
            completed+=1
            world:SetAttribute("KinBranch"..EXPECTED[key].."Status","Ready")
        else
            table.insert(failed,key..": "..tostring(res))
            world:SetAttribute("KinBranch"..EXPECTED[key].."Status","Error")
            warn("KC35 BRANCH ERROR "..key..": "..tostring(res))
        end
    end
    world:SetAttribute("KinBranchRuntimeRevision",REVISION)
    world:SetAttribute("KinBranchExpected",#candidates)
    world:SetAttribute("KinBranchReadyCount",completed)
    world:SetAttribute("KinBranchRuntimeState",if #failed==0 then "Ready" else "Partial")
    world:SetAttribute("KinBranchRuntimeErrors",table.concat(failed," | "))
    if #failed==0 then
        print("KC35 B09 : "..completed.." sur "..#candidates.." branches installées, profil "..profile)
    end
    return {expected=#candidates,created=completed,failed=failed,profile=profile,ready=#failed==0}
end

return Runtime
