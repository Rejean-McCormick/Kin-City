--!strict
-- KC35 B09 GENERATED from contrib/places/city/Wayfinding.luau sha256=6d1c28ec5a4aff4fd3cb1a955a36cf32d5285da8c3ae2bf1c0026b07cbef8be1
-- B10 / KC34 : éléments d'orientation Art déco non bloquants.
-- Module de contribution en attente d'intégration B09 dans CityGenerator.
-- Aucun teleport, déplacement d'ancre, collision physique ou dépendance kOA.
local Wayfinding = {}
local REVISION = "b10-wayfinding-1.0"
local ROOT_NAME = "KinB10Orientation"
local TEAL = Color3.fromRGB(30,104,100)
local STONE = Color3.fromRGB(214,205,180)
local LIGHT = Color3.fromRGB(247,244,234)
local DARK = Color3.fromRGB(27,38,43)
local RADII = {112,242,354}
local LATERAL = 35

local function decorative(parent: Instance, name: string, size: Vector3, frame: CFrame, color: Color3, material: Enum.Material): BasePart
    local object = Instance.new("Part")
    object.Name = name
    object.Size = size
    object.CFrame = frame
    object.Anchored = true
    object.CanCollide = false
    object.CanTouch = false
    object.CanQuery = false
    object.CastShadow = false
    object.Color = color
    object.Material = material
    object.Parent = parent
    return object
end

local function billboard(host: BasePart, heading: string, caption: string, foreground: Color3, bg: Color3)
    local board = Instance.new("BillboardGui")
    board.Name = "Cartouche Art déco"
    board.Adornee = host
    board.AlwaysOnTop = false
    board.MaxDistance = 115
    board.Size = UDim2.fromOffset(230,84)
    board.StudsOffsetWorldSpace = Vector3.new(0,1.55,0)
    board.Parent = host
    local panel = Instance.new("Frame")
    panel.Name = "Panneau"
    panel.BackgroundColor3 = bg
    panel.BackgroundTransparency = 0.06
    panel.BorderSizePixel = 0
    panel.Size = UDim2.fromScale(1,1)
    panel.Parent = board
    local edge = Instance.new("UIStroke")
    edge.Color = foreground
    edge.Thickness = 2
    edge.Parent = panel
    local title = Instance.new("TextLabel")
    title.Name = "Destination"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromScale(.05,.08)
    title.Size = UDim2.fromScale(.9,.52)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextWrapped = true
    title.TextColor3 = foreground
    title.Text = heading
    title.Parent = panel
    local secondary = Instance.new("TextLabel")
    secondary.Name = "Orientation"
    secondary.BackgroundTransparency = 1
    secondary.Position = UDim2.fromScale(.06,.60)
    secondary.Size = UDim2.fromScale(.88,.30)
    secondary.Font = Enum.Font.Gotham
    secondary.TextScaled = true
    secondary.TextWrapped = true
    secondary.TextColor3 = LIGHT
    secondary.Text = caption
    secondary.Parent = panel
end

local function nearestSector(position: Vector3, districts: any): any
    if position.Magnitude < .01 then return nil end
    local best: any = nil
    local score = -2
    for _, section in ipairs(districts.sections) do
        local dot = (position.X * section.x + position.Z * section.z)/Vector2.new(position.X, position.Z).Magnitude
        if dot > score then
            best = section
            score = dot
        end
    end
    return best
end

local function blockedByStructures(position: Vector3, structures: {any}, clearance: number): boolean
    -- Même convention de yaw / footprint que KoaliUrbanism. Un décor non
    -- collidable pourrait être placé plus près, mais on évite les façades.
    for _, b in ipairs(structures) do
        local dx = position.X - b.center_studs[1]
        local dz = position.Z - b.center_studs[3]
        local theta = math.rad(b.yaw_degrees)
        local localX = math.cos(theta)*dx - math.sin(theta)*dz
        local localZ = math.sin(theta)*dx + math.cos(theta)*dz
        if math.abs(localX) < b.footprint_studs[1]/2 + clearance and math.abs(localZ) < b.footprint_studs[2]/2 + clearance then
            return true
        end
    end
    return false
end

local function clearOfPortals(position: Vector3, anchors: {Vector3}, radius: number): boolean
    for _, anchor in ipairs(anchors) do
        local distance = Vector2.new(position.X-anchor.X, position.Z-anchor.Z).Magnitude
        if distance < radius then return false end
    end
    return true
end

local function inCity(radius: number): boolean
    return radius > 75 and radius < 438
end

local function levelCount(profile: string): number
    if profile == "LITE" then return 1 end
    if profile == "STANDARD" then return 2 end
    if profile == "SHOWCASE" then return 3 end
    error("Profil B10 inconnu : "..tostring(profile))
end

local function getArrivals(plan: any): {any}
    local city
    for _, place in ipairs(plan.places) do
        if place.place_key == "city" then city = place; break end
    end
    assert(city ~= nil, "B10: Place city absente du plan")
    local anchors = {}
    for _, a in ipairs(city.anchors) do anchors[a.anchor_id] = a end
    local arrivals = {}
    local cleared = {}
    for _, d in ipairs(plan.doors) do
        if d.source_place_key == "city" then
            assert(d.destination_place_key ~= "city", "B10: boucle porte ville")
            assert(not cleared[d.door_id], "B10: porte extérieure répétée")
            local door = assert(anchors[d.source_anchor_id], "B10: ancre porte absente "..d.door_id)
            local dest = assert(anchors["city."..d.building_id..".return_spawn"], "B10: retour extérieur absent "..d.door_id)
            cleared[d.door_id] = true
            table.insert(arrivals,{door=d, doorAnchor=Vector3.new(table.unpack(door.position_studs)),
                returnAnchor=Vector3.new(table.unpack(dest.position_studs))})
        end
    end
    assert(#arrivals == 8, "B10: huit portes ville nécessaires; obtenu "..tostring(#arrivals))
    table.sort(arrivals,function(a,b) return a.door.door_id < b.door.door_id end)
    return arrivals
end

local function makeMonument(parent: Instance, position: Vector3, sector: any, heading: string, detail: string, index: string, rich: boolean)
    local group = Instance.new("Model")
    group.Name = "Repère "..index
    group:SetAttribute("KinB10Sector",sector.key)
    group:SetAttribute("KinB10DecorationId","city.wayfinding."..index)
    group:SetAttribute("KinB10NonColliding",true)
    group.Parent = parent
    local base = CFrame.new(position.X,0,position.Z)
    decorative(group,"Socle sarcelle",Vector3.new(2.7,.35,2.7),base*CFrame.new(0,.35,0),TEAL,Enum.Material.Metal)
    decorative(group,"Mât ornemental",Vector3.new(.48,6,.48),base*CFrame.new(0,3.5,0),TEAL,Enum.Material.Metal)
    local top = decorative(group,"Accents de secteur",Vector3.new(2.25,.44,2.25),base*CFrame.new(0,6.53,0),sector.color,Enum.Material.Neon)
    billboard(top,heading,detail,sector.key=="ekole" and LIGHT or sector.color,DARK)
    if rich then
        decorative(group,"Corniche Art déco",Vector3.new(1.4,.34,1.4),base*CFrame.new(0,6.15,0),STONE,Enum.Material.Metal)
    end
    return group
end

local function makeEntrance(parent: Instance, info: any, sector: any, buildingLabel: string)
    -- Aucun objet dans les 6 studs autour de la porte ni du point de retour.
    -- La pancarte se tient vers la gauche de la ligne retour -> porte ; elle
    -- reste traversable même si la parcelle réelle impose un détour.
    local delta = info.doorAnchor - info.returnAnchor
    local flat = Vector3.new(delta.X,0,delta.Z)
    local axis = if flat.Magnitude > .5 then flat.Unit else Vector3.new(0,0,-1)
    local perpendicular = Vector3.new(-axis.Z,0,axis.X)
    local anchor = info.returnAnchor - axis*3 + perpendicular*9
    if (anchor-info.doorAnchor).Magnitude < 6 then
        anchor = info.returnAnchor - axis*3 - perpendicular*9
    end
    return makeMonument(parent,anchor,sector,buildingLabel,"ENTRÉE  •  RETOUR VILLE",info.door.destination_place_key,false)
end

function Wayfinding.build(city: Instance, plan: any, districts: any, profile: string?): (Instance, {[string]:number})
    assert(city and city.Name == "Ville", "B10 : dossier Ville attendu")
    assert(type(plan)=="table" and type(plan.structures)=="table", "B10: plan absent")
    assert(type(districts)=="table" and type(districts.sections)=="table" and #districts.sections==6,
        "B10: six secteurs requis")
    local quality = profile or "STANDARD"
    local levels = levelCount(quality)
    local arrivals = getArrivals(plan) -- Validate all entry contracts BEFORE modifying city.
    local anchorVectors = {}
    for _,info in ipairs(arrivals) do
        table.insert(anchorVectors,info.doorAnchor)
        table.insert(anchorVectors,info.returnAnchor)
    end
    local previous = city:FindFirstChild(ROOT_NAME)
    if previous and previous:GetAttribute("KinB10Revision")==REVISION
        and previous:GetAttribute("KinB10Profile")==quality then
        return previous,{avenue=previous:GetAttribute("KinB10AvenueMarkers") or 0,
            entrances=previous:GetAttribute("KinB10EntranceMarkers") or 0,skipped=previous:GetAttribute("KinB10Skipped") or 0}
    end
    local draft = Instance.new("Folder")
    draft.Name = ROOT_NAME.."_PREPARE"
    draft:SetAttribute("KinB10Revision",REVISION)
    draft:SetAttribute("KinB10Profile",quality)
    local avenueMarkers = 0
    local skipped = 0
    for _,section in ipairs(districts.sections) do
        local axis=Vector3.new(section.x,0,section.z)
        local side=Vector3.new(-section.z,0,section.x)
        for i=1,levels do
            -- Repli de l'autre côté de l'avenue si une façade ou un portail
            -- occupe l'accotement choisi en premier.
            local selected: Vector3? = nil
            for _,polarity in ipairs({1,-1}) do
                local candidate=axis*RADII[i]+side*LATERAL*polarity
                if inCity(candidate.Magnitude)
                    and not blockedByStructures(candidate,plan.structures,10)
                    and clearOfPortals(candidate,anchorVectors,12) then
                    selected=candidate
                    break
                end
            end
            if selected then
                makeMonument(draft,selected,section,section.name,"SECTEUR  •  "..tostring(section.hour).." H",
                    section.key.."-"..tostring(i),quality=="SHOWCASE")
                avenueMarkers += 1
            else
                skipped += 1
            end
        end
    end
    local placeTitles = {
        city_hall="Accueil civique", ekoh_tower="Tour EkoH", library="Bibliothèque",
        campus="Université King Klown", justice_palace="Palais de justice",
        innovation_lab="Atelier d'innovation", museum="Musée Kreative", orgo_center="Centre Orgo",
    }
    local entranceMarkers = 0
    for _,info in ipairs(arrivals) do
        local k=info.door.destination_place_key
        local sector=nearestSector(info.doorAnchor, districts)
        -- Pour les institutions centrales : socle sarcelle, sans faire croire
        -- à une septième section périphérique.
        local chosen=assert(sector,"B10: aucun secteur pour une entrée")
        if string.sub(info.door.building_id,1,8)=="central." or info.door.building_id=="orgo.admin_center" then
            chosen={key="central",color=TEAL}
        end
        if k=="museum" then
            -- The exterior museum portal is intentionally barred: no false "ENTER" sign.
            makeMonument(draft,info.returnAnchor,chosen,"MUSÉE — FERMÉ",
                "BROADCAST YOUTUBE À PROXIMITÉ", "museum-ferme", false)
        else
            makeEntrance(draft,info,chosen,placeTitles[k] or k)
        end
        entranceMarkers += 1
    end
    draft:SetAttribute("KinB10AvenueMarkers",avenueMarkers)
    draft:SetAttribute("KinB10EntranceMarkers",entranceMarkers)
    draft:SetAttribute("KinB10Skipped",skipped)
    if previous then previous:Destroy() end
    draft.Name=ROOT_NAME
    draft.Parent=city
    return draft,{avenue=avenueMarkers,entrances=entranceMarkers,skipped=skipped}
end

return Wayfinding
