--!strict
local Factory = require(script.Parent.Factory)
local PropGenerator = {}

-- Single explicit registry used by Studio's preflight before generating the world.
-- Each ID must also have a matching construction branch in make().
local SUPPORTED_ASSETS = {
    ["prop.bookshelf"] = true,
    ["prop.terminal"] = true,
    ["prop.kiosk"] = true,
    ["prop.board"] = true,
    ["prop.panel"] = true,
    ["prop.display"] = true,
    ["prop.table"] = true,
    ["prop.desk"] = true,
    ["prop.bench"] = true,
    ["prop.planter"] = true,
    ["prop.lamp"] = true,
}

function PropGenerator.supports(assetId)
    return SUPPORTED_ASSETS[assetId] == true
end

local function piece(parent, name, size, base, dx, dy, dz, color, material)
    return Factory.part(parent, name, size, base * CFrame.new(dx,dy,dz),color,material)
end

function PropGenerator.make(parent, item, position, palette)
    local model = Instance.new("Model")
    model.Name = item.furnishing_id
    model:SetAttribute("KinFurnishingId",item.furnishing_id)
    model:SetAttribute("KinAssetId",item.asset_id)
    model:SetAttribute("KinPlaceKey",item.place_key or "")
    if item.anchor_id then model:SetAttribute("KinAnchorId",item.anchor_id) end
    model.Parent = parent
    local base = CFrame.new(position) * CFrame.Angles(0, math.rad(item.yaw_degrees or 0),0)
    local wood = Color3.fromRGB(113,79,51)
    local stone = palette.trim
    local teal = palette.accent
    local metal = Color3.fromRGB(57,72,79)
    local asset = item.asset_id
    local root
    if asset == "prop.bookshelf" then
        root = piece(model,"Bookshelf",Vector3.new(9,9,1.7),base,0,4.5,0,wood,Enum.Material.Wood)
        for h=1,4 do
            piece(model,"Shelf",Vector3.new(8.5,0.25,2.1),base,0,h*1.8,0,stone)
            for j=1,12 do
                local col = Color3.fromHSV(((h*12+j)*0.073)%1,0.45,0.80)
                piece(model,"Book",Vector3.new(0.38,1.3,1.3),base,-3.9+(j-1)*0.67,h*1.8+0.8,0,col)
            end
        end
    elseif asset == "prop.terminal" or asset == "prop.kiosk" then
        root = piece(model,"Terminal",Vector3.new(4.2,4.2,2.2),base,0,2.1,0,metal,Enum.Material.Metal)
        piece(model,"Screen",Vector3.new(3.4,2.2,0.22),base,0,3.1,-1.2,Color3.fromRGB(54,168,177),Enum.Material.Neon)
        piece(model,"ControlDesk",Vector3.new(4.8,0.3,2.8),base,0,1.8,-0.6,stone)
    elseif asset == "prop.board" or asset == "prop.panel" or asset == "prop.display" then
        root = piece(model,"Panel",Vector3.new(7,5,0.75),base,0,4.2,0,metal)
        piece(model,"DisplaySurface",Vector3.new(6.3,4.3,0.14),base,0,4.2,-0.43,teal,Enum.Material.SmoothPlastic)
        piece(model,"Stand",Vector3.new(0.6,2.1,0.6),base,0,1,0,wood)
    elseif asset == "prop.desk" then
        -- The innovation laboratory's canonical interaction desk. Keep its
        -- furnishing ID and anchor attributes unchanged, and leave the front
        -- clearance open so a player can approach its prompt.
        root = piece(model,"DeskTop",Vector3.new(7.6,0.55,3.6),base,0,3.1,0,wood,Enum.Material.Wood)
        piece(model,"DeskFront",Vector3.new(7.1,2.35,0.45),base,0,1.55,1.3,stone,Enum.Material.Marble)
        for _,x in ipairs({-3.15,3.15}) do
            for _,z in ipairs({-1.25,1.25}) do
                piece(model,"DeskLeg",Vector3.new(0.55,2.8,0.55),base,x,1.4,z,metal,Enum.Material.Metal)
            end
        end
        local display=piece(model,"DeskConsole",Vector3.new(2.8,0.3,1.7),base,1.35,3.55,-0.2,teal,Enum.Material.SmoothPlastic)
        display.CanCollide=false
    elseif asset == "prop.table" then
        root = piece(model,"Tabletop",Vector3.new(8,0.5,4),base,0,3.2,0,wood,Enum.Material.Wood)
        for x=-1,1,2 do for z=-1,1,2 do
            piece(model,"Leg",Vector3.new(0.6,3,0.6),base,x*3.1,1.5,z*1.3,wood)
        end end
    elseif asset == "prop.bench" then
        root = piece(model,"Seat",Vector3.new(7,0.55,2.4),base,0,1.6,0,wood,Enum.Material.Wood)
        piece(model,"Back",Vector3.new(7,2.2,0.5),base,0,2.4,1,wood,Enum.Material.Wood)
        for x=-1,1,2 do piece(model,"Leg",Vector3.new(0.6,1.5,0.6),base,x*2.5,0.75,0,metal) end
    elseif asset == "prop.planter" then
        root = piece(model,"Planter",Vector3.new(3.5,2,3.5),base,0,1,0,stone)
        local foliage = piece(model,"Leaves",Vector3.new(4.2,4.2,4.2),base,0,4,0,Color3.fromRGB(72,124,82),Enum.Material.Grass)
        foliage.Shape=Enum.PartType.Ball
    elseif asset == "prop.lamp" then
        root = piece(model,"LampStand",Vector3.new(0.8,8,0.8),base,0,4,0,metal)
        local shade = piece(model,"LampGlow",Vector3.new(3,0.8,3),base,0,8,0,Color3.fromRGB(255,236,177),Enum.Material.Neon)
        shade.CanCollide=false
        local light=Instance.new("PointLight");light.Brightness=1.6;light.Range=23;light.Parent=shade
    else
        error("Unknown asset generator: "..tostring(asset))
    end
    model.PrimaryPart = root
    if item.collision_policy == "no_collision" then
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
    return root
end

return PropGenerator
