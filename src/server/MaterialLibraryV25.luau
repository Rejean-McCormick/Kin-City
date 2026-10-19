--!strict
-- Application sélective de matériaux PBR déjà importés dans Studio.
-- Jamais d'AssetId inventé; la géométrie native fonctionne sans bibliothèque.
-- La SurfaceAppearance est copiée uniquement sur des MeshParts facultatifs.
local ServerStorage=game:GetService("ServerStorage")
local Library={}
local MATERIAL_FOR_MESH={
    mineral_column="sarcelle_pierre",
    opal_spire="opale_massive",
    crystal_rosette="opale_massive",
    opal_arch="sarcelle_pierre",
    opal_chandelier="champagne_mineral",
    crystal_canopy="opale_massive",
    mineral_planter="pierre_promenoir",
    opal_console="champagne_mineral",
    opal_lattice="opale_massive",
    mineral_pediment="sarcelle_pierre",
    harbor_crest="champagne_mineral",
}
local VALID={sarcelle_pierre=true,opale_massive=true,champagne_mineral=true,pierre_promenoir=true}
function Library.materialFor(assetKey)
    return MATERIAL_FOR_MESH[assetKey]
end
function Library.apply(mesh,assetKey,profile)
    if not mesh or not mesh:IsA("MeshPart") or profile=="LITE" then return false end
    local key=MATERIAL_FOR_MESH[assetKey]
    if not key or not VALID[key] then return false end
    -- Respecter un SurfaceAppearance déjà présent sur l'asset importé.
    if mesh:FindFirstChildOfClass("SurfaceAppearance") then return false end
    local root=ServerStorage:FindFirstChild("KinCityMaterialLibrary")
    local template=root and root:FindFirstChild(key)
    if not template or not template:IsA("SurfaceAppearance") then return false end
    local finish=template:Clone()
    finish.Name="Finition Kin City — "..key
    finish.Parent=mesh
    mesh:SetAttribute("KinMaterialKey",key)
    return true
end
return Library
