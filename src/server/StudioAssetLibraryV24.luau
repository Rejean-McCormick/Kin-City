--!strict
-- Bibliothèque locale de MeshPart importés dans Roblox Studio.
-- Les modèles ne sont jamais téléchargés, ni obtenus depuis une IA/API.
-- ServerStorage.KinCityAssetLibrary est préservé par l'installateur de la ville.
local ServerStorage = game:GetService("ServerStorage")
local MaterialLibraryV25=require(script.Parent.MaterialLibraryV25)
local Kit=require(script.Parent.CrystalKit)
local Library = {}

local VALID = {
    mineral_column=true, opal_spire=true, crystal_rosette=true,
    opal_arch=true, opal_chandelier=true,
    crystal_canopy=true, mineral_planter=true, opal_console=true,
    opal_lattice=true, mineral_pediment=true, harbor_crest=true,
}
function Library.has(assetKey)
    if not VALID[assetKey] then return false end
    local root=ServerStorage:FindFirstChild("KinCityAssetLibrary")
    local template=root and root:FindFirstChild(assetKey)
    return template~=nil and template:IsA("MeshPart")
end
function Library.instantiate(parent,name,assetKey,size,cf,color)
    if not VALID[assetKey] then return nil end
    local root=ServerStorage:FindFirstChild("KinCityAssetLibrary")
    local template=root and root:FindFirstChild(assetKey)
    if not template or not template:IsA("MeshPart") then return nil end
    local copy=template:Clone()
    copy.Name=name
    copy.Size=size
    copy.CFrame=cf
    copy.Color=color
    copy.Material=Enum.Material.Slate
    copy.Anchored=true
    copy.CanCollide=false
    copy.CanTouch=false
    copy.CanQuery=false
    copy.CastShadow=false
    copy:SetAttribute("KinArtTheme","sarcelle-cristal-v24")
    copy:SetAttribute("KinOptionalDetail",true)
    copy:SetAttribute("KinImportedMeshKey",assetKey)
    MaterialLibraryV25.apply(copy,assetKey,Kit.profile)
    copy.Parent=parent
    return copy
end
return Library
