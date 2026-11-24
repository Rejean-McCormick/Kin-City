--!strict
local Data=require(script.Parent.ArtDecoData)
local Assets=require(script.Parent.ArtDecoAssets)
local Planner=require(script.Parent.ArtDecoSurfacePlan)
local Surfaces={}
local function render(parent,place,origin,sector,slots)
    local count=0
    for _,slot in ipairs(slots) do
        local frame=CFrame.new(origin+Vector3.new(table.unpack(slot.center)))*CFrame.Angles(0,math.rad(slot.yaw),0)
        local model=Assets.place(parent,slot.asset,sector,Vector3.new(table.unpack(slot.size)),frame,"architecture/"..place.place_key)
        if model then
            model.Name=slot.name
            model:SetAttribute("KinInteriorSurface",slot.kind)
            model:SetAttribute("KinPlaceKey",place.place_key)
            -- The native substrate stays walkable; only these non-interactive
            -- decorative surfaces participate in the existing local detail LOD.
            if slot.kind~="exit" then
                for _,part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then part:SetAttribute("KinOptionalDetail",true) end
                end
            end
            count+=1
        end
    end
    return count
end
function Surfaces.room(parent,place,room,origin,index,sector)
    local program=Data.placements.interior_programs[place.place_key]
    local slots=Planner.room(room,place,program,index,Data.placements.surfaces,Assets.profile())
    local count=render(parent,place,origin,sector,slots)
    parent:SetAttribute("KinArtDecoSurfaceCount",count)
    parent:SetAttribute("KinArtDecoSurfaceExpected",#slots)
    return count
end
function Surfaces.connectors(parent,place,origin,sector)
    local slots=Planner.portals(place,Data.placements.surfaces)
    local count=render(parent,place,origin,sector,slots)
    parent:SetAttribute("KinArtDecoConnectorCount",count)
    parent:SetAttribute("KinArtDecoConnectorExpected",#slots)
    return count
end
function Surfaces.upper(parent,place,origin,sector)
    local slots=Planner.upper(Data.placements.surfaces)
    local count=render(parent,place,origin,sector,slots)
    parent:SetAttribute("KinArtDecoUpperCount",count)
    parent:SetAttribute("KinArtDecoUpperExpected",#slots)
    return count
end
return Surfaces
