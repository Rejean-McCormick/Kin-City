--!strict
-- Exterior shells only. Doors continue to lead to the original remote interiors.
local Data=require(script.Parent.ArtDecoData)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Districts=require(Shared.HexagonalDistricts)
local Theme=require(Shared.ArtDecoTheme)
local Factory=require(script.Parent.Factory)
local Assets=require(script.Parent.ArtDecoAssets)
local Layout=require(script.Parent.ArtDecoLayout)
local Buildings={}
function Buildings.make(parent,structure,building,frame)
    local recipe=assert(Data.placements.buildings[building.building_id],"Missing institution composition")
    local w,d=table.unpack(structure.footprint_studs)
    local plan=Layout.compile(w,d,structure.height_studs,recipe)
    local section=Districts.byKey(building.district_id)
    local colors=table.clone(Theme)
    colors.accent=if section then section.color else Districts.base
    local function imported(slot)
        local model=Assets.place(parent,slot.asset,building.district_id,Vector3.new(table.unpack(slot.size)),
            frame*CFrame.new(table.unpack(slot.center)),"building/"..building.building_id)
        if model then model.Name=slot.name end
        return model
    end
    local shells={}
    -- Reserve major masses first; ornaments cannot starve building architecture.
    for _,slot in ipairs(plan.primary_shells) do
        local model=imported(slot)
        if model then
            model:SetAttribute("KinExteriorShell",true)
            table.insert(shells,model)
        end
    end
    local complete=#shells==#plan.primary_shells
    if not complete then
        for _,model in ipairs(shells) do Assets.release(model) end
    end
    local feature=false
    if complete then
        feature=imported(plan.primary_feature)~=nil
        for _,slot in ipairs(plan.slots) do
            if string.sub(slot.name,1,14)=="EntranceColumn" then imported(slot) end
        end
    else
        -- Explicit fallback keeps the original procedural envelope usable.
        for _,slot in ipairs(plan.slots) do
            if imported(slot) and slot.name=="InstitutionFeature" then feature=true end
        end
    end
    local specs={}
    if complete then
        for _,spec in ipairs(plan.primary_parts) do table.insert(specs,spec) end
        table.insert(specs,plan.parts[1]) -- walkable site floor
    else
        for _,spec in ipairs(plan.parts) do
            local tower=spec.name=="ObservatoryShaft" or string.sub(spec.name,1,8)=="TowerFin"
            if not (tower and feature) then table.insert(specs,spec) end
        end
    end
    for _,spec in ipairs(specs) do
        local piece=Factory.part(parent,spec.name,Vector3.new(table.unpack(spec.size)),
            frame*CFrame.new(table.unpack(spec.center)),assert(colors[spec.role]),
            if spec.role=="bronze" or spec.role=="accent" then Enum.Material.Metal else Enum.Material.SmoothPlastic)
        piece.Transparency=if spec.invisible then 1 else 0
        piece.CanCollide=spec.solid;piece.CanTouch=false;piece.CanQuery=spec.solid
        piece.CastShadow=spec.solid and not spec.invisible
        piece:SetAttribute("KinArchitectureRole",spec.role)
        piece:SetAttribute("KinArchitecturePiece",spec.name)
        if spec.name=="Floor" then
            piece:SetAttribute("KinGroundAuthority","institution-foundation")
            piece:SetAttribute("KinGroundOwner",building.building_id)
            piece:SetAttribute("KinGroundTop",Layout.SITE_FLOOR_TOP_STUDS)
        end
    end
    parent:SetAttribute("KinExteriorShellCount",if complete then #shells else 0)
    parent:SetAttribute("KinInteriorLocation","separate_destination")
    parent:SetAttribute("KinEntranceClearWidth",plan.entry.width)
    parent:SetAttribute("KinArchitectureShape",recipe.shape)
    parent:SetAttribute("KinFootprintWidth",w)
    parent:SetAttribute("KinFootprintDepth",d)
    return plan
end
return Buildings
