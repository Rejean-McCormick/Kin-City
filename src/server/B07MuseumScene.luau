--!strict
-- KC35 B09 GENERATED from contrib/places/museum/MuseumScene.luau sha256=a07d68b988761bf85f7d4cdf8ebe2f4b726556ac03bf6adba5dc72c93cd7ac9f
local Data=require(script.Parent:WaitForChild("B07MuseumData"))
local MuseumScene={}

local function makePart(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material, collide: boolean): BasePart
    local part=Instance.new("Part")
    part.Name=name
    part.Size=size
    part.CFrame=cf
    part.Color=color
    part.Material=material
    part.Anchored=true
    part.CanCollide=collide
    part.CanTouch=collide
    part.CanQuery=collide
    part.Parent=parent
    return part
end

local function buildPedestal(parent: Instance, origin: Vector3, item: any, accent: Color3)
    local folder=Instance.new("Folder")
    folder.Name=item.room_id
    folder.Parent=parent
    local pos=origin+Vector3.new(item.center[1],0,item.center[3])
    makePart(folder,"Socle",Vector3.new(4,1,4),CFrame.new(pos+Vector3.new(0,0.5,0)),accent,Enum.Material.SmoothPlastic,false)
    makePart(folder,"Cadre",Vector3.new(3,6,0.35),CFrame.new(pos+Vector3.new(0,3.5,-2.2)),Color3.fromRGB(43,27,36),Enum.Material.Metal,false)
    return folder
end

function MuseumScene.plan(profile: string?): any
    local name=(profile or "STANDARD"):upper()
    local budget=Data.profiles[name] or Data.profiles.STANDARD
    return {metadata=Data.metadata, rooms=Data.rooms, exterior=Data.exterior, decorative_budget=budget}
end

function MuseumScene.build(context: any): any
    local parent=(context and (context.parent or context.placeModel or context.interiorModel)) or workspace
    local origin=(context and context.origin) or Vector3.zero
    local profile=(context and context.profile) or "STANDARD"
    local accent=Color3.fromRGB(table.unpack(Data.metadata.accent_rgb))
    local existing=parent:FindFirstChild("KinB07MuseumScene")
    if existing then
        assert(existing:GetAttribute("KinB07Revision")==Data.metadata.revision,
            "B07: décoration existante d'une version différente")
        assert(existing:GetAttribute("KinB07Profile")==profile,"B07: profil modifié, reconstruction explicite requise")
        return {created=0,reused=true,model=existing}
    end
    local root=Instance.new("Folder")
    root.Name="KinB07MuseumScene"
    root:SetAttribute("KinB07Revision",Data.metadata.revision)
    root:SetAttribute("KinB07Profile",profile)
    root:SetAttribute("KinBranch","B07")
    root.Parent=parent
    local created=0
    for _,room in ipairs(Data.rooms) do
        buildPedestal(root,origin,room,accent)
        created+=2
    end
    return {
        created=created,
        skipped=0,
        failed=0,
        estimated_parts=created,
        estimated_triangles=created*12,
        warnings={"B07 garde la porte extérieure barrée ; écran de broadcast YouTube placé par intégration B09."},
        plan=MuseumScene.plan(profile),
        model=root,
    }
end

return MuseumScene
