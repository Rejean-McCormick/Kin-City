--!strict
-- B05 AGORA KORUM / decorative-only scene; NOT wired to WorldBuilder.
-- Requires SceneData ModuleScript as script.Parent.SceneData.
-- B09 must review the import/export path and staging protection before invocation.
-- Context: {place_key='justice_palace', parent=Instance, origin=Vector3,
--           profile='LITE'|'STANDARD'|'SHOWCASE', replace_decoration=false?}.
local Data = require(script.Parent.SceneData)
local Builder = {}
local GROUP = 'B05_Korum_Decoration'
local REV = 'b05.korum.0.1.0'
local ORDER = {LITE=1, STANDARD=2, SHOWCASE=3}
local COLORS = {
    bronze=Color3.fromRGB(169,124,79),
    brass=Color3.fromRGB(183,140,98),
    teal=Color3.fromRGB(30,104,100),
    opal=Color3.fromRGB(240,233,218),
    shadow=Color3.fromRGB(39,61,63),
}

local function rectangle(folder: Instance, name: string, frame: CFrame, size: Vector3, color: Color3, material: Enum.Material)
    local part=Instance.new('Part')
    part.Name=name
    part.Size=size
    part.CFrame=frame
    part.Anchored=true
    part.CanCollide=false
    part.CanTouch=false
    part.CanQuery=false
    part.CastShadow=false
    part.Material=material
    part.Color=color
    part.TopSurface=Enum.SurfaceType.Smooth
    part.BottomSurface=Enum.SurfaceType.Smooth
    part.Parent=folder
    return part
end

local function createFeature(root: Instance, origin: Vector3, feature: any)
    local p=feature.position_studs
    local frame=CFrame.new(origin+Vector3.new(p[1],p[2],p[3]))*CFrame.Angles(0,math.rad(feature.yaw_degrees),0)
    local m=Instance.new('Model')
    m.Name=feature.id
    m:SetAttribute('KinBranch','B05')
    m:SetAttribute('KinRoomId',feature.room_id)
    m:SetAttribute('KinFeatureKind',feature.kind)
    m:SetAttribute('KinNoGameplayCollision',true)
    m.Parent=root
    local kind=feature.kind
    local width=feature.width_studs
    if kind=='frieze' then
        rectangle(m,'Corniche supérieure',frame*CFrame.new(0,.52,0),Vector3.new(width,.13,.18),COLORS.bronze,Enum.Material.Metal)
        rectangle(m,'Frise de fond',frame,Vector3.new(width-.25,.63,.12),COLORS.shadow,Enum.Material.SmoothPlastic)
        rectangle(m,'Fil sarcelle',frame*CFrame.new(0,-.40,-.12),Vector3.new(width-.6,.12,.10),COLORS.teal,Enum.Material.Metal)
    elseif kind=='rosette' then
        rectangle(m,'Diamant bronze',frame*CFrame.Angles(0,0,math.rad(45)),Vector3.new(width*.67,width*.67,.20),COLORS.bronze,Enum.Material.Metal)
        rectangle(m,'Diamant intérieur',frame*CFrame.new(0,0,-.13)*CFrame.Angles(0,0,math.rad(45)),Vector3.new(width*.45,width*.45,.08),COLORS.opal,Enum.Material.SmoothPlastic)
        rectangle(m,'Centre',frame*CFrame.new(0,0,-.20),Vector3.new(width*.24,width*.24,.08),COLORS.teal,Enum.Material.Metal)
    elseif kind=='pilaster' then
        rectangle(m,'Montant',frame,Vector3.new(.42,width,.24),COLORS.shadow,Enum.Material.Metal)
        rectangle(m,'Couronnement',frame*CFrame.new(0,width/2-.13,0),Vector3.new(1.45,.28,.42),COLORS.bronze,Enum.Material.Metal)
        rectangle(m,'Base',frame*CFrame.new(0,-width/2+.13,0),Vector3.new(1.18,.26,.42),COLORS.brass,Enum.Material.Metal)
    elseif kind=='sconce' then
        rectangle(m,'Dosseret',frame,Vector3.new(width*.65,1.35,.22),COLORS.shadow,Enum.Material.Metal)
        rectangle(m,'Éclat opalin',frame*CFrame.new(0,.22,-.17),Vector3.new(width*.44,.75,.17),COLORS.opal,Enum.Material.SmoothPlastic)
        rectangle(m,'Bord bronze',frame*CFrame.new(0,-.48,-.20),Vector3.new(width*.50,.15,.2),COLORS.bronze,Enum.Material.Metal)
    else
        m:Destroy()
        error('B05 type de feature inconnu: '..tostring(kind))
    end
    return m
end

function Builder.build(ctx: any): any
    assert(type(ctx)=='table','B05 attend un contexte explicite')
    assert(ctx.place_key=='justice_palace','B05 refuse de décorer une autre Place')
    assert(typeof(ctx.parent)=='Instance','B05 parent Instance exigé')
    assert(typeof(ctx.origin)=='Vector3','B05 origine Vector3 exigée')
    assert(type(ctx.profile)=='string' and ORDER[ctx.profile], 'B05 profil invalide')
    -- No real PlaceId or studio publish check here: B09's installer owns that gate.
    local prev=ctx.parent:FindFirstChild(GROUP)
    if prev then
        if prev:GetAttribute('KinB05Revision')==REV and prev:GetAttribute('KinB05Profile')==ctx.profile then
            return {created=0,skipped='already_built',reused=true,parts=0,revision=REV}
        end
        assert(ctx.replace_decoration==true,'B05 variante différente : suppression interdite sans approbation')
        assert(prev:GetAttribute('KinBranch')=='B05','B05 n’efface jamais les objets d’une autre branche')
        prev:Destroy()
    end
    local root=Instance.new('Folder')
    root.Name=GROUP
    root:SetAttribute('KinBranch','B05')
    root:SetAttribute('KinB05Revision',REV)
    root:SetAttribute('KinB05Profile',ctx.profile)
    root:SetAttribute('KinPlaceKey','justice_palace')
    local created=0
    for _,feature in ipairs(Data.features) do
        if ORDER[ctx.profile]>=ORDER[feature.min_profile] then
            createFeature(root,ctx.origin,feature)
            created+=1
        end
    end
    root.Parent=ctx.parent
    -- Three non-collidable native parts per feature; zero imported meshes and lights.
    return {created=created,parts=created*3,imported_meshes=0,lights=0,revision=REV}
end

return Builder
