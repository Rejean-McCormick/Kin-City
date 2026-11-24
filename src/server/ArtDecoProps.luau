--!strict
local Data=require(script.Parent.ArtDecoData)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Visual=require(Shared.VisualConfig)
local Assets=require(script.Parent.ArtDecoAssets)
local Props={}
function Props.selected(kind,step)
    local steps=Data.config.profiles[Visual.profile][if kind=="lamp" then "lamp_steps" else "bench_steps"]
    for _,value in ipairs(steps) do if value==step then return true end end
    return false
end
function Props.roadSteps()
    return Data.config.profiles[Visual.profile].road_steps or {}
end
function Props.street(parent,kind,frame,sector)
    local recipe=Data.placements.street[kind]
    if not recipe then return nil end
    local pool=if string.sub(kind,1,7)=="paving_" then "paving/" else "street/"
    local model=Assets.place(parent,recipe.asset,sector,Vector3.new(table.unpack(recipe.envelope)),frame,pool..sector)
    if model and kind=="bench" then
        local _,size=model:GetBoundingBox()
        local seat=Instance.new("Seat")
        seat.Name="Assise du banc";seat.Size=Vector3.new(size.X*.9,.35,math.min(size.Z,2.2))
        seat.CFrame=frame*CFrame.new(0,size.Y*.48,0)
        seat.Transparency=1;seat.Anchored=true;seat.CanQuery=false;seat.Parent=model
    end
    return model
end
function Props.lightHost(model)
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            local node=part
            while node and node~=model do
                if string.find(node.Name,"KC32_LUMIERE",1,true) then return part end
                node=node.Parent
            end
        end
    end
    return model:FindFirstChildWhichIsA("BasePart",true)
end
function Props.pavilion(parent,frame,sector,index)
    local recipe=Data.placements.pavilion
    -- Stable three-silhouette rotation; the collision/wayfinding fallback remains native.
    local variants=recipe.variants
    local asset=if variants and #variants>0 then variants[((index or 1)-1)%#variants+1] else recipe.asset
    local model=Assets.place(parent,asset,sector,Vector3.new(table.unpack(recipe.envelope)),
        frame*CFrame.Angles(0,math.rad(recipe.yaw_degrees),0),"pavilion/"..sector)
    if model then
        model:SetAttribute("KinExteriorPavilion",true)
        model:SetAttribute("KinPavilionVariant",asset)
        local bounds,size=model:GetBoundingBox()
        local collider=Instance.new("Part")
        collider.Name="Enveloppe extérieure";collider.CFrame=bounds;collider.Size=size
        collider.Anchored=true;collider.Transparency=1;collider.CanCollide=true;collider.CanTouch=false
        collider.Parent=model
    end
    return model
end
function Props.environment(parent,kind,frame,sector)
    local recipe=Data.placements.environment[kind]
    if not recipe or not sector then return nil end
    local used=Assets.accountStats("environment/"..sector)
    -- Native trees are the intentional continuation once this sector's palm
    -- quota is full, not a missing-source warning on every subsequent tree.
    if used and used.clones>=Assets.profile().pools.environment.clones then return nil end
    return Assets.place(parent,recipe.asset,sector,Vector3.new(table.unpack(recipe.envelope)),frame,"environment/"..sector)
end
return Props
