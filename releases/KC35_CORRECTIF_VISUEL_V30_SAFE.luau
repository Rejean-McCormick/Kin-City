-- KIN CITY / KC35 : HOTFIX VISUEL REVERSIBLE, SANS REINSTALLER LA VILLE
-- Studio > KinCity_35.rbxl > Command Bar; Play arrete; Place locale ID=0.
-- 1) Retire B10 floating BillboardGui / "SECTEUR 10 H".
-- 2) Cache temporairement le pavage ArtDeco GLB importé (garde les sols natifs).
-- 3) Bloque sa regeneration lors d'une construction ulterieure.
-- 4) Garde une copie des sources pour retour arriere.
-- 5) Ne touche jamais KinCityArtDecoLibrary, ses 121 modèles et son PackageLink.

local RunService = game:GetService("RunService")
local SS = game:GetService("ServerStorage")
local SSS = game:GetService("ServerScriptService")
assert(RunService:IsStudio() and not RunService:IsRunning(), "KC35: executer en EDIT, Play arrete")
assert(game.PlaceId == 0, "KC35: seulement dans la Place locale non publiee")

local library = SS:FindFirstChild("KinCityArtDecoLibrary")
assert(library and library:FindFirstChildOfClass("PackageLink"),
    "Bibliotheque centrale liee introuvable, patch arrete")
assert(library:GetAttribute("KinSourceCount") == 121,
    "Bibliotheque centrale non validee, patch arrete")

local runtime = SSS:FindFirstChild("KinCityRuntime")
assert(runtime and runtime:IsA("Script"), "KinCityRuntime introuvable")
local branch = runtime:FindFirstChild("BranchRuntime")
local urban = runtime:FindFirstChild("KoaliUrbanism")
assert(branch and branch:IsA("ModuleScript"), "BranchRuntime absent")
assert(urban and urban:IsA("ModuleScript"), "KoaliUrbanism absent")

local world = workspace:FindFirstChild("KinCityGenerated")
assert(world, "KinCityGenerated introuvable")
local city = world:FindFirstChild("Ville")
assert(city, "Ville introuvable")

local backup = SS:FindFirstChild("KinCityVisualFixBackup_v1")
if not backup then
    backup = Instance.new("Folder")
    backup.Name = "KinCityVisualFixBackup_v1"
    backup.Parent = SS
end

local function remember(name, original)
    local holder = backup:FindFirstChild(name)
    if not holder then
        holder = Instance.new("StringValue")
        holder.Name = name
        holder.Value = original
        holder.Parent = backup
    end
end

local function escapePattern(text)
    return (text:gsub("([^%w])", "%%%1"))
end

local branchOriginal = branch.Source
local urbanOriginal = urban.Source
local branchNeedle = 'return require(script.Parent.B10Wayfinding).build(model,Plan,Districts,profile)'
local branchReplacement = [[
        -- KC35 visual hotfix: B10 flotteurs desactives. Les panneaux physiques restent.
        local previous = model:FindFirstChild("KinB10Orientation")
        if previous then previous:Destroy() end
        local empty = Instance.new("Folder")
        empty.Name = "KinB10Orientation"
        empty:SetAttribute("KinB10Revision", "KC35-V30-SOBRE-1")
        empty:SetAttribute("KinB10AvenueMarkers", 0)
        empty:SetAttribute("KinB10EntranceMarkers", 0)
        empty:SetAttribute("KinB10Skipped", 0)
        empty.Parent = model
        return empty,{avenue=0,entrances=0,skipped=0}
]]
local urbanNeedle = "ArtDecoProps.street(road,kind,frame,s.key)"
local urbanReplacement = "-- KC35 visuel: pavage GLB desactive ; conserver les dalles natives"

if not branchOriginal:find("KC35-V30-SOBRE-1",1,true) then
    assert(branchOriginal:find(branchNeedle,1,true), "Signature B10 inconnue : rien modifie")
end
if not urbanOriginal:find(urbanReplacement,1,true) then
    assert(urbanOriginal:find(urbanNeedle,1,true), "Signature du pavage inconnue : rien modifie")
end

-- Les deux prevalidations ont reussi : sauvegarder les sources avant modification.
if not branchOriginal:find("KC35-V30-SOBRE-1",1,true) then
    remember("Original_BranchRuntime", branchOriginal)
    local updated,n = branchOriginal:gsub(escapePattern(branchNeedle),branchReplacement,1)
    assert(n==1,"Reecriture B10 impossible")
    branch.Source = updated
end
if not urbanOriginal:find(urbanReplacement,1,true) then
    remember("Original_KoaliUrbanism", urbanOriginal)
    local updated,n = urbanOriginal:gsub(escapePattern(urbanNeedle),urbanReplacement,1)
    assert(n==1,"Reecriture du pavage impossible")
    urban.Source = updated
end

-- Retirer uniquement la couche B10, jamais les panneaux de facades.
local removed = 0
local previous = city:FindFirstChild("KinB10Orientation")
if previous then
    local parked = backup:FindFirstChild("Original_KinB10Orientation")
    if not parked then
        previous.Name = "Original_KinB10Orientation"
        previous.Parent = backup
    else
        previous:Destroy()
    end
    removed += 1
end

-- Les deux meshes de pavage importes sont ornementaux et sans collision.
-- On conserve les instances et leur transparence initiale pour un vrai rollback.
local pavingKeys = {
    AD_Ext_Street_Straight = true,
    AD_Ext_Street_Cross = true,
}
local hiddenModels = 0
local hiddenParts = 0
for _,obj in ipairs(city:GetDescendants()) do
    if obj:IsA("Model") and pavingKeys[obj:GetAttribute("KinArtDecoAsset")] then
        if not obj:GetAttribute("KinKC35PavingHidden") then
            obj:SetAttribute("KinKC35PavingHidden", true)
            hiddenModels += 1
        end
        for _,part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") and part:GetAttribute("KinKC35OriginalTransparency") == nil then
                part:SetAttribute("KinKC35OriginalTransparency", part.Transparency)
                part.Transparency = 1
                hiddenParts += 1
            end
        end
    end
end
backup:SetAttribute("KinVisualHotfixApplied", true)
print("KC35 VISUEL : B10 flottant neutralise; groupes retires="..removed)
print("KC35 VISUEL : pavage GLB masque temporairement; modeles="..hiddenModels..", parts="..hiddenParts)
print("KC35 VISUEL : modules sauvegardes dans ServerStorage.KinCityVisualFixBackup_v1")
print("KC35 VISUEL : KinCityArtDecoLibrary PRESERVEE; portes et interieur inchanges")
print("KC35 VISUEL : Ctrl+S, puis Play. Si triangle persiste, utiliser DIAGNOSTIC_SOL_KC35.luau")
