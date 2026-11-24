--!strict
-- No InsertService, HTTP or asset upload. The private Studio library survives installs.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Data=require(script.Parent.ArtDecoData)
local Visual=require(Shared.VisualConfig)
local Districts=require(Shared.HexagonalDistricts)
local Theme=require(Shared.ArtDecoTheme)
local Policy=require(script.Parent.ArtDecoPolicy)
local Budget=require(script.Parent.ArtDecoBudget)
local Assets={}
local records={}
for _,record in ipairs(Data.manifest.assets) do records[record.asset_key]=record end
local rejected={}
local accountLimits={}
local budget
local generation=0
local function addAccount(key,pool)
    accountLimits[key]=Data.config.profiles[Visual.profile].pools[pool]
end
local function resetAccounts()
    accountLimits={}
    for id,recipe in pairs(Data.placements.buildings) do
        addAccount("building/"..id,"building")
        addAccount("interior/"..recipe.place_key,"interior")
        addAccount("architecture/"..recipe.place_key,"architecture")
    end
    for _,section in ipairs(Districts.sections) do
        addAccount("street/"..section.key,"street")
        addAccount("paving/"..section.key,"paving")
        addAccount("pavilion/"..section.key,"pavilion")
        addAccount("environment/"..section.key,"environment")
    end
    budget=Budget.new(accountLimits)
    generation+=1
end
resetAccounts()
local function reject(key,reason)
    if not rejected[key..reason] then
        rejected[key..reason]=true
        warn("Art Deco fallback: "..key.." / "..reason)
    end
    return nil
end
function Assets.allowed()
    return Data.config.enabled and Policy.isRuntimeTarget(game.PlaceId,
        workspace:GetAttribute("KinArtDecoTestPlace"),Data.config)
end
function Assets.beginBuild()
    rejected={}
    resetAccounts()
end
function Assets.revision()
    local library=game:GetService("ServerStorage"):FindFirstChild(Data.config.library_name)
    return Data.config.revision.."/"..tostring(if library then library:GetAttribute("KinLibraryRevision") else "missing")
end
function Assets.beginQualification()
    local service=game:GetService("RunService")
    assert(service:IsStudio() and not service:IsRunning(),"Qualification is editor-only")
    Assets.checkTarget()
    Assets.beginBuild()
    budget:addOwner("qualification",{triangles=10000000,parts=10000,clones=1})
end
function Assets.profile()
    return Data.config.profiles[Visual.profile]
end
function Assets.accountStats(key)
    return budget:stats(key)
end
function Assets.stats()
    return budget:stats()
end
function Assets.checkTarget()
    assert(Policy.isRuntimeTarget(game.PlaceId,workspace:GetAttribute("KinArtDecoTestPlace"),Data.config),
        "Art Deco : Place non autorisee (production canonique ou test marque requis)")
    if game.PlaceId==Data.config.production_place_id then
        local library=game:GetService("ServerStorage"):FindFirstChild(Data.config.library_name)
        assert(library and library:FindFirstChildOfClass("PackageLink")
            and library:GetAttribute("KinSourceCount")==121,
            "Art Deco production : Package central lie 121/121 requis")
    end
end
local allowedClasses={Model=true,Folder=true,Part=true,MeshPart=true,SpecialMesh=true,
    SurfaceAppearance=true,Decal=true,Texture=true}
function Assets.materialRole(part,root)
    local node=part
    while node and node~=root do
        for _,role in ipairs({"KC32_ACCENT","KC32_BRONZE","KC32_VITRAGE","KC32_LUMIERE","KC32_CORPS"}) do
            if string.find(node.Name,role,1,true) then return role end
        end
        node=node.Parent
    end
    return nil
end
function Assets.isAccent(part,root)
    local node=part
    while node and node~=root do
        if string.find(node.Name,"KC32_ACCENT",1,true) then return true end
        node=node.Parent
    end
    return false
end
function Assets.clone(key,sector,account)
    if not Assets.allowed() then return nil end
    if not accountLimits[account] then return reject(key,"unknown budget owner") end
    local record=records[key]
    if not record then return reject(key,"unknown manifest key") end
    local library=game:GetService("ServerStorage"):FindFirstChild(Data.config.library_name)
    local source=if library then library:FindFirstChild(record.source_name) else nil
    if not source or not source:IsA("Model") then return reject(key,"private source missing") end
    if not source.Archivable then return reject(key,"source not Archivable") end
    local clone=source:Clone()
    local parts=0
    for _,node in ipairs(clone:GetDescendants()) do
        if not allowedClasses[node.ClassName] then
            clone:Destroy()
            return reject(key,"unsupported import class "..node.ClassName)
        end
        if node:IsA("BasePart") then parts+=1 end
    end
    local cost={triangles=record.triangles_mesh_definitions,parts=parts+2,clones=1}
    local receipt=if parts>0 then budget:reserve(account,cost) else nil
    if not receipt then
        clone:Destroy();return reject(key,"empty source or mobile budget")
    end
    local section=Districts.byKey(sector or "")
    for _,node in ipairs(clone:GetDescendants()) do
        if node:IsA("BasePart") then
            node.Anchored=true;node.CanCollide=false;node.CanTouch=false;node.CanQuery=false
            if node:IsA("MeshPart") then node.RenderFidelity=Enum.RenderFidelity.Automatic end
            node.CastShadow=Visual.profile=="SHOWCASE"
            node.AssemblyLinearVelocity=Vector3.zero;node.AssemblyAngularVelocity=Vector3.zero
            -- Vertex color variation and textures remain on the meshes. The
            -- named structural roles receive one common architectural palette.
            local structural=record.category=="Exterior__Buildings" or record.category=="Interior__Architecture"
            local role=Assets.materialRole(node,clone)
            if structural then
                local palette={KC32_CORPS=Theme.stone,KC32_BRONZE=Theme.bronze,
                    KC32_VITRAGE=Theme.glazing,KC32_LUMIERE=Theme.light}
                if palette[role] then node.Color=palette[role] end
                if role=="KC32_BRONZE" then node.Material=Enum.Material.Metal end
                if role=="KC32_LUMIERE" then node.Material=Enum.Material.Neon end
            end
            if Assets.isAccent(node,clone) then
                node.Color=if section then section.color else Districts.base
                if sector=="kreative" then node:SetAttribute("KinKreativeCanvas",true) end
            end
        end
    end
    clone:SetAttribute("KinArtDecoReservation",receipt)
    clone:SetAttribute("KinArtDecoGeneration",generation)
    clone:SetAttribute("KinArtDecoBudgetOwner",account)
    clone:SetAttribute("KinArtDecoAsset",key)
    clone:SetAttribute("KinArtDecoTrianglesEstimate",cost.triangles)
    clone:SetAttribute("KinArtDecoParts",cost.parts)
    clone:SetAttribute("KinSection",sector or "neutral")
    return clone
end
function Assets.restore(world)
    -- Edit-time geometry is cloned by Roblox into Play; reconstruct accounting from that scene.
    Assets.beginBuild()
    for _,node in ipairs(world:GetDescendants()) do
        if node:IsA("Model") and node:GetAttribute("KinArtDecoAsset") then
            local record=records[node:GetAttribute("KinArtDecoAsset")]
            local owner=node:GetAttribute("KinArtDecoBudgetOwner")
            if not record or not accountLimits[owner] then return false end
            local receipt=budget:reserve(owner,{triangles=record.triangles_mesh_definitions,
                parts=node:GetAttribute("KinArtDecoParts"),clones=1})
            if not receipt then return false end
            node:SetAttribute("KinArtDecoGeneration",generation)
            node:SetAttribute("KinArtDecoReservation",receipt)
        end
    end
    return true
end
function Assets.release(model)
    local function refund(node)
        if not node:GetAttribute("KinArtDecoAsset") then return end
        if node:GetAttribute("KinArtDecoGeneration")==generation then
            budget:release(node:GetAttribute("KinArtDecoReservation"))
        end
        node:SetAttribute("KinArtDecoAsset",nil)
    end
    for _,node in ipairs(model:GetDescendants()) do
        if node:IsA("Model") then refund(node) end
    end
    refund(model)
    model:Destroy()
end
function Assets.fit(model,envelope,frame)
    local _,size=model:GetBoundingBox()
    local scale=Policy.fitScale(size,envelope)
    if not scale or scale~=scale or scale<=0 or scale==math.huge then return false end
    model:ScaleTo(model:GetScale()*scale)
    local bounds,newSize=model:GetBoundingBox()
    -- Bounding-box center and bottom, independent of source pivot and GLB origin.
    local target=frame*CFrame.new(0,newSize.Y/2,0)
    model:PivotTo(target*bounds:Inverse()*model:GetPivot())
    return true
end
function Assets.place(parent,key,sector,envelope,frame,account)
    local model=Assets.clone(key,sector,account)
    if not model then return nil end
    local ok,result=pcall(Assets.fit,model,envelope,frame)
    if not ok or not result then Assets.release(model);return reject(key,"invalid dimensions") end
    model.Parent=parent
    return model
end
return Assets
