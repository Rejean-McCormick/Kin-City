--!strict
-- Outils de génération incrémentale à utiliser depuis la Command Bar de Studio.
-- Le serveur actif reconstruit le monde au démarrage d'une session Play.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local Spatial=require(script.Parent.Spatial)
local Facade=require(script.Parent.FacadeGenerator)
local Interiors=require(script.Parent.InteriorGenerator)
local InteriorLighting=require(script.Parent.InteriorLightingV30)
local FullBuilder=require(script.Parent.WorldBuilder)
local CanonicalInteractions=require(script.Parent.CanonicalInteractions)
local ArtDecoAssets=require(script.Parent.ArtDecoAssets)
local Editor={}
local structures={}
local labels={}
local places={}
for _,b in ipairs(Plan.structures) do structures[b.building_id]=b end
for _,b in ipairs(Buildings) do labels[b.building_id]=b end
for _,p in ipairs(Plan.places) do places[p.place_key]=p end
local function refreshBudgetStats(world)
    local stats=ArtDecoAssets.stats()
    world:SetAttribute("KinArtDecoTrianglesEstimate",stats.triangles)
    world:SetAttribute("KinArtDecoParts",stats.parts)
    world:SetAttribute("KinArtDecoClones",stats.clones)
end
local function generated()
    return workspace:FindFirstChild("KinCityGenerated")
end
function Editor.regenerateAll()
    return FullBuilder.build()
end
function Editor.regenerateFacade(buildingId)
    ArtDecoAssets.checkTarget()
    local structure=structures[buildingId]
    local b=labels[buildingId]
    assert(structure and b,"ID de bâtiment inconnu: "..tostring(buildingId))
    local world=generated()
    assert(world,"Installer Kin City avant une régénération sélective")
    local city=world:FindFirstChild("Ville")
    assert(city,"Ville absente (Place non central)")
    local folder=city:FindFirstChild("Bâtiments")
    assert(folder,"Dossier des façades absent")
    assert(ArtDecoAssets.restore(world),"Rebuild the world before incremental editing")
    world:SetAttribute("KinBuildState","Editing")
    for _,m in ipairs(folder:GetChildren()) do
        if m:GetAttribute("KinBuildingId")==buildingId then ArtDecoAssets.release(m) end
    end
    local result=Facade.make(folder,structure,b,Plan.styles[structure.style_id])
    refreshBudgetStats(world)
    world:SetAttribute("KinBuildState","Ready")
    return result
end
function Editor.regenerateInterior(placeKey)
    ArtDecoAssets.checkTarget()
    assert(placeKey~="city","La ville n'est pas un intérieur")
    local place=places[placeKey]
    assert(place,"Place inconnu: "..tostring(placeKey))
    assert(Spatial.mode()=="LOCAL_UNIVERSE" or Spatial.currentPlace()==placeKey,
        "Cet intérieur appartient à une autre Place; ouvrir son installateur dédié")
    local world=generated()
    assert(world,"Installer Kin City avant une régénération sélective")
    local interiors=world:FindFirstChild("Bâtiments visitables")
    assert(interiors,"Dossier intérieur absent")
    local old=interiors:FindFirstChild("Intérieur — "..placeKey)
    assert(ArtDecoAssets.restore(world),"Rebuild the world before incremental editing")
    world:SetAttribute("KinBuildState","Editing")
    if old then ArtDecoAssets.release(old) end
    local style=Spatial.styleForPlace(placeKey)
    local model=Interiors.make(interiors,place,style)
    InteriorLighting.apply(model)
    CanonicalInteractions.bindPlace(model,placeKey,Plan.interactions,nil)
    refreshBudgetStats(world)
    world:SetAttribute("KinBuildState","Ready")
    return model
end
return Editor
