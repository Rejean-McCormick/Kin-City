--!strict
-- Institution envelopes are authored from their site and public entrance, independent of pack availability.
local Factory=require(script.Parent.Factory)
local Architecture=require(script.Parent.ArtDecoBuildings)
local Facades={}
function Facades.make(parent,structure,building,_style)
    local model=Instance.new("Model")
    model.Name=building.name
    model:SetAttribute("KinBuildingId",building.building_id)
    model:SetAttribute("KinSection",building.district_id)
    model:SetAttribute("KinArchitectureRevision","imported-street-shells-3")
    model.Parent=parent
    local x,y,z=table.unpack(structure.center_studs)
    local frame=CFrame.new(x,y,z)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local layout=Architecture.make(model,structure,building,frame)
    local sign=layout.sign
    local label=Factory.sign(model,"BuildingSign",(frame*CFrame.new(table.unpack(sign.center))).Position,
        structure.yaw_degrees,building.name,sign.width,sign.height,
        {emblem=true,role="building-primary",section=building.district_id})
    label:SetAttribute("KinSignCompactV316",true)
    label:SetAttribute("KinSignRole","building-primary")
    return model
end
return Facades
