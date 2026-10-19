--!strict
-- Hiérarchie v24: MeshPart déjà importé dans ServerStorage > FileMesh par ID > formes natives.
-- Aucune dépendance à un AssetId fictif. Importer un asset n'exige plus de modifier Luau.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Manifest=require(Shared:WaitForChild("MeshManifest"))
local Kit=require(script.Parent.CrystalKit)
local StudioLibrary=require(script.Parent.StudioAssetLibraryV24)
local Reusable={}
local function segment(parent,name,size,cf,color)
    local part=Kit.part(parent,"Part",name,size,cf,color,Enum.Material.Slate)
    part:SetAttribute("KinOptionalDetail",true)
    return part
end
local function nativeArch(parent,name,size,cf,color)
    local model=Instance.new("Model")
    model.Name=name
    model:SetAttribute("KinArtTheme","sarcelle-cristal-v24")
    model.Parent=parent
    local w,h,d=size.X,size.Y,size.Z
    local pillar=math.max(0.32,math.min(w*0.13,d))
    for _,side in ipairs({-1,1}) do
        segment(model,"Pied de l'arche",Vector3.new(pillar,h*0.69,d),cf*CFrame.new(side*(w-pillar)*0.5,-h*0.155,0),color)
        local diagonal=Kit.part(model,"WedgePart","Épaulement de l'arche",Vector3.new(w*0.23,h*0.23,d),
            cf*CFrame.new(side*w*0.26,h*0.245,0)*CFrame.Angles(0,if side==-1 then math.pi else 0,0),color,Enum.Material.Slate)
        diagonal:SetAttribute("KinOptionalDetail",true)
    end
    segment(model,"Claveau",Vector3.new(w*0.45,h*0.14,d),cf*CFrame.new(0,h*0.44,0),Kit.gold)
    return model
end
function Reusable.decorate(parent,name,assetKey,size,cf,color)
    local imported=StudioLibrary.instantiate(parent,name,assetKey,size,cf,color)
    if imported then return imported end
    local id=Manifest[assetKey]
    if type(id)=="number" and id>0 then
        -- SpecialMesh.FileMesh se redimensionne par Scale en unités de mesh natif,
        -- pas en fonction de la taille du Part. Nos OBJ sont centrés et normalisés.
        local p=segment(parent,name,size,cf,color)
        local mesh=Instance.new("SpecialMesh")
        mesh.Name="FileMesh "..assetKey
        mesh.MeshType=Enum.MeshType.FileMesh
        mesh.MeshId="rbxassetid://"..tostring(id)
        mesh.Scale=size
        mesh.Parent=p
        p:SetAttribute("KinImportedMeshKey",assetKey)
        return p
    end
    if assetKey=="opal_chandelier" or assetKey=="opal_spire" or assetKey=="crystal_canopy" then
        return Kit.spire(parent,name,cf*CFrame.new(0,-size.Y*0.5,0),math.min(size.X,size.Z)*0.27,size.Y,
            {accent=color,metal=Kit.deep})
    elseif assetKey=="crystal_rosette" then
        return Kit.rosette(parent,name,cf,math.min(size.X,size.Y)*0.5,color,6)
    elseif assetKey=="opal_arch" then
        return nativeArch(parent,name,size,cf,color)
    elseif assetKey=="opal_lattice" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        for _,side in ipairs({-1,1}) do
            segment(root,"Traverse verticale",Vector3.new(0.15,size.Y,0.12),cf*CFrame.new(side*size.X*0.42,0,0),color)
            segment(root,"Traverse horizontale",Vector3.new(size.X,0.15,0.12),cf*CFrame.new(0,side*size.Y*0.42,0),Kit.gold)
        end
        if Kit.profile~="LITE" then
            for i=-1,1 do
                segment(root,"Maille opaline",Vector3.new(0.1,size.Y*0.8,0.1),cf*CFrame.new(i*size.X*0.22,0,0),Kit.opal)
            end
        end
        return root
    elseif assetKey=="mineral_pediment" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        for _,side in ipairs({-1,1}) do
            local wedge=Kit.part(root,"WedgePart","Versant de fronton",Vector3.new(size.X*0.5,size.Y,size.Z),
                cf*CFrame.new(side*size.X*0.25,0,0)*CFrame.Angles(0,if side==1 then math.pi else 0,0),color,Enum.Material.Slate)
            wedge:SetAttribute("KinOptionalDetail",true)
        end
        segment(root,"Filet de faîtage",Vector3.new(size.X*0.9,0.18,size.Z*1.1),cf*CFrame.new(0,-size.Y*0.44,0),Kit.gold)
        return root
    elseif assetKey=="harbor_crest" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        segment(root,"Pointe d'amarrage",Vector3.new(size.X*0.10,size.Y*0.8,size.Z),cf,color)
        segment(root,"Traverse maritime",Vector3.new(size.X*0.8,size.Y*0.10,size.Z),cf*CFrame.new(0,size.Y*0.25,0),Kit.gold)
        segment(root,"Moule du port",Vector3.new(size.X*0.62,size.Y*0.12,size.Z),cf*CFrame.new(0,-size.Y*0.37,0),color)
        return root
    elseif assetKey=="mineral_planter" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        segment(root,"Corbeille minérale",size*Vector3.new(1,0.55,1),cf*CFrame.new(0,-size.Y*0.19,0),Kit.deep)
        segment(root,"Bordure champagne",Vector3.new(size.X,0.23,size.Z),cf*CFrame.new(0,size.Y*0.18,0),Kit.gold)
        return root
    elseif assetKey=="opal_console" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        segment(root,"Fût console",size*Vector3.new(0.7,0.8,0.65),cf*CFrame.new(0,-size.Y*0.1,0),Kit.deep)
        segment(root,"Tablette opaline",Vector3.new(size.X,0.28,size.Z),cf*CFrame.new(0,size.Y*0.39,0),color)
        return root
    end
    return segment(parent,name,size,cf,color)
end
return Reusable
