-- KC34 B01: Studio COPIE LOCALE seulement. Ne modifie jamais la production.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(), "Arrêter Play dans Roblox Studio")
assert(game.PlaceId==0, "Utiliser une COPIE locale PlaceId=0, pas une Place publiée")
local found={}
for _,v in ipairs(workspace:GetDescendants()) do
  if v:IsA("Model") and v.Name=="Intérieur — city_hall" and v:GetAttribute("KinPlaceKey")=="city_hall" then
    table.insert(found,v)
  end
end
assert(#found==1, "Une et une seule copie de l'intérieur B01 doit exister")
local model=found[1]
assert(typeof(model:GetAttribute("KinInteriorOrigin"))=="Vector3", "Origine de l'intérieur non définie")
for _,id in ipairs({"city_hall.lobby","city_hall.gallery","city_hall.chamber","city_hall.west_wing","city_hall.east_wing","city_hall.rear_atrium"}) do
  assert(model:FindFirstChild(id), "Salle nécessaire manquante : "..id)
end
local holder=Instance.new("Folder")
holder.Name="B01_PREVIEW_TEMP"
holder.Parent=game:GetService("ServerScriptService")
local sceneModule=Instance.new("ModuleScript")
sceneModule.Name="CityHallScene"
sceneModule.Source=[=[--!strict
-- B01 city_hall Art Deco civic interior overlay.
-- No shared contract edits. No doors, no anchors, no gameplay remotes.
-- Mount only into the existing "Intérieur — city_hall" Model AFTER canonical generation.
local Spec = require(script.Parent.CityHallSpec)
local Scene = {}

local COLORS = {
    teal = Color3.fromRGB(30, 104, 100),
    bronze = Color3.fromRGB(184, 156, 103),
    ivory = Color3.fromRGB(230, 228, 217),
    charcoal = Color3.fromRGB(41, 56, 59),
}
local PROFILE = {
    LITE = {rays = 4, panels = 1, cap = 64},
    STANDARD = {rays = 8, panels = 2, cap = 128},
    SHOWCASE = {rays = 12, panels = 3, cap = 200},
}
local ROOT_NAME = "KinB01CityHallDecor"

local function part(parent: Instance, name: string, size: Vector3, frame: CFrame, color: Color3, material: Enum.Material): BasePart
    local item = Instance.new("Part")
    item.Name = name
    item.Size = size
    item.CFrame = frame
    item.Color = color
    item.Material = material
    item.Anchored = true
    item.CanCollide = false
    item.CanTouch = false
    item.CanQuery = false
    item.CastShadow = false
    item.Locked = true
    item.Parent = parent
    return item
end

local function plaque(parent: Instance, name: string, text: string, frame: CFrame, width: number, color: Color3, subtitle: boolean)
    local board = part(parent, name, Vector3.new(width, if subtitle then 1.4 else 2.4, 0.12), frame, COLORS.charcoal, Enum.Material.Metal)
    local gui = Instance.new("SurfaceGui")
    gui.Name = "Texte Art déco"
    gui.Face = Enum.NormalId.Front
    gui.AlwaysOnTop = false
    gui.LightInfluence = 0.2
    gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud = 38
    gui.Parent = board
    local label = Instance.new("TextLabel")
    label.Name = "Texte"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.TextWrapped = true
    label.Font = if subtitle then Enum.Font.GothamMedium else Enum.Font.GothamBold
    label.Parent = gui
end

local function star(parent: Instance, base: Vector3, rays: number)
    part(parent, "Emblème civique central", Vector3.new(0.9, 0.9, 0.18), CFrame.new(base), COLORS.teal, Enum.Material.Metal)
    for i = 1, rays do
        local a = (i - 1) * math.pi / rays
        local dx = math.cos(a) * 1.25
        local dy = math.sin(a) * 1.25
        part(parent, "Rayon " .. i, Vector3.new(0.12, 1.65, 0.12),
            CFrame.new(base + Vector3.new(dx, dy, 0)) * CFrame.Angles(0, 0, a), COLORS.bronze, Enum.Material.Metal)
    end
end

local function decorateRoom(root: Model, room, origin: Vector3, profile)
    local c = room.center_studs
    local s = room.size_studs
    local cx, cz, w, d = c[1], c[3], s[1], s[3]
    local roomFolder = Instance.new("Folder")
    roomFolder.Name = room.room_id
    roomFolder:SetAttribute("KinRoomId", room.room_id)
    roomFolder:SetAttribute("KinDecorOnly", true)
    roomFolder.Parent = root

    -- Back-wall decorations only. Doors and portal openings are elsewhere; no gameplay collision.
    -- Gallery/chamber use an offset to stay away from rear portals at their centerlines.
    local offset = if room.room_id == "city_hall.gallery" then math.min(w / 2 - 9, 13)
        elseif room.room_id == "city_hall.chamber" then -math.min(w / 2 - 9, 13)
        else 0
    local x = cx + offset
    local z = cz + d / 2 - 0.58
    local width = math.min(if offset == 0 then 21 else 15, w - 12)
    local center = origin + Vector3.new(x, 0, z)

    -- Frieze and bilingual-ready plaques: every room retains its canonical RoomTitle.
    part(roomFolder, "Corniche civique", Vector3.new(width + 3, 0.18, 0.13),
        CFrame.new(center + Vector3.new(0, 14.25, 0)), COLORS.bronze, Enum.Material.Metal)
    plaque(roomFolder, "Titre civique", room.title,
        CFrame.new(center + Vector3.new(0, 7.55, -0.05)), width, COLORS.ivory, false)
    plaque(roomFolder, "Programme civique", room.subtitle,
        CFrame.new(center + Vector3.new(0, 5.42, -0.05)), width, COLORS.bronze, true)
    star(roomFolder, center + Vector3.new(0, 11.5, -0.09), profile.rays)
    for n = 1, profile.panels do
        local side = if n % 2 == 0 then -1 else 1
        local delta = 2.5 + math.floor((n - 1) / 2) * 2
        part(roomFolder, "Filet architectural " .. n,
            Vector3.new(0.14, 2.0, 0.1),
            CFrame.new(origin + Vector3.new(x + side * (width/2 - delta), 10.0, z - 0.1)),
            COLORS.teal, Enum.Material.Metal)
    end
    return roomFolder
end

local function validate(context)
    assert(type(context) == "table", "B01 attend un contexte")
    assert(context.place_key == Spec.place_key, "B01 ne peut pas construire une autre Place")
    assert(context.contracts_version == Spec.contracts_version, "B01 contrat incompatible")
    assert(typeof(context.place_model) == "Instance" and context.place_model:IsA("Model"), "B01 Model intérieur requis")
    local model = context.place_model
    assert(model:GetAttribute("KinPlaceKey") == "city_hall", "B01 objet parent non city_hall")
    assert(model.Name == "Intérieur — city_hall", "B01 nom modèle intérieur incorrect")
    local origin = model:GetAttribute("KinInteriorOrigin")
    assert(typeof(origin) == "Vector3", "B01 origine canonique manquante")
    local level = PROFILE[context.profile or "STANDARD"]
    assert(level ~= nil, "B01 profil invalide")
    for _, room in ipairs(Spec.rooms) do
        assert(model:FindFirstChild(room.room_id) ~= nil, "B01 salle canonique/extension absente : " .. room.room_id)
    end
    return model, origin, level
end

function Scene.build(context)
    local model, origin, level = validate(context)
    local root = Instance.new("Model")
    root.Name = ROOT_NAME
    root:SetAttribute("KinBranch", "B01")
    root:SetAttribute("KinPlaceKey", "city_hall")
    root:SetAttribute("KinSceneRevision", Spec.revision)
    root:SetAttribute("KinDecorProfile", context.profile or "STANDARD")
    local ok, err = pcall(function()
        for _, room in ipairs(Spec.rooms) do
            decorateRoom(root, room, origin, level)
        end
    end)
    if not ok then
        root:Destroy()
        error("B01 échec de génération sans modification des portes: " .. tostring(err))
    end
    local count = 0
    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:IsA("BasePart") then
            count += 1
            assert(not descendant.CanCollide and not descendant.CanTouch and not descendant.CanQuery,
                "B01 collision décorative interdite")
        end
    end
    assert(count <= level.cap, "B01 budget d'instances dépassé : " .. count)
    root:SetAttribute("KinDecorPartCount", count)
    local previous = model:FindFirstChild(ROOT_NAME)
    root.Parent = model
    if previous then previous:Destroy() end
    return {created = count, skipped = 0, failed = 0, revision = Spec.revision, model = root}
end

function Scene.remove(context)
    assert(type(context) == "table" and context.place_key == "city_hall", "B01 contexte de retrait invalide")
    local model = context.place_model
    assert(typeof(model) == "Instance" and model:IsA("Model"), "B01 Model intérieur requis")
    assert(model:GetAttribute("KinPlaceKey") == "city_hall", "B01 retrait limité à city_hall")
    local previous = model:FindFirstChild(ROOT_NAME)
    if previous then previous:Destroy() end
end

return Scene
]=]
sceneModule.Parent=holder
local specModule=Instance.new("ModuleScript")
specModule.Name="CityHallSpec"
specModule.Source=[=[--!strict
-- GENERATED from city_hall_scene.json; DO NOT EDIT BY HAND.
return {["schema_version"]="kincity.b01-scene/1.0",["place_key"]="city_hall",["building_id"]="central.city_hall",["owner_branch"]="B01",["contracts_version"]="KC34-DOC-1.0",["revision"]="B01.1.0",["status"]="DEVELOPED_NOT_STUDIO_VERIFIED",["seed_policy"]="FIXED_LAYOUT",["origin_mode"]="read_KinInteriorOrigin_attribute",["style"]={["architectural"]="Art déco civique, courbes et rayons stylisés",["teal"]="#1E6864",["bronze"]="#B89C67",["ivory"]="#E6E4D9",["charcoal"]="#29383B"},["profile_limits"]={["LITE"]={["max_parts"]=64,["rays_per_room"]=4,["accent_panels"]=1},["STANDARD"]={["max_parts"]=128,["rays_per_room"]=8,["accent_panels"]=2},["SHOWCASE"]={["max_parts"]=200,["rays_per_room"]=12,["accent_panels"]=3}},["protected_anchors"]={{["anchor_id"]="city_hall.lobby.spawn",["position_studs"]={0,3,-32},["protection_radius_studs"]=8},{["anchor_id"]="city_hall.exit.door",["position_studs"]={0,3,-45},["protection_radius_studs"]=8},{["anchor_id"]="hall.kiosk_01",["position_studs"]={-27,3,18},["protection_radius_studs"]=9}},["protected_portals"]={"city_hall.portal.lobby.gallery","city_hall.portal.lobby.chamber","city_hall.gallery_to_west","city_hall.chamber_to_east","city_hall.gallery_to_rear","city_hall.chamber_to_rear"},["rooms"]={{["room_id"]="city_hall.lobby",["display_name"]="Accueil public",["title"]="BIENVENUE À KIN CITY",["subtitle"]="Information · Orientation · Accueil",["center_studs"]={0,0,-29},["size_studs"]={100,16,34},["narrative_prompts"]={"Entrer dans la ville civique","Découvrir les institutions"},["presentation"]="wall-mounted non-collidable frieze and emblem",["gameplay_changes"]=false},{["room_id"]="city_hall.gallery",["display_name"]="Galerie des services",["title"]="SERVICES ET RESSOURCES",["subtitle"]="Citoyenneté · Transparence · Information",["center_studs"]={-27,0,17},["size_studs"]={44,16,52},["narrative_prompts"]={"Consulter les services","Découvrir les initiatives"},["presentation"]="wall-mounted non-collidable frieze and emblem",["gameplay_changes"]=false},{["room_id"]="city_hall.chamber",["display_name"]="Salle du conseil",["title"]="SALLE DU CONSEIL",["subtitle"]="Écoute · Délibération · Dialogue",["center_studs"]={27,0,17},["size_studs"]={44,16,52},["narrative_prompts"]={"Débattre avec respect","Comprendre les décisions"},["presentation"]="wall-mounted non-collidable frieze and emblem",["gameplay_changes"]=false},{["room_id"]="city_hall.west_wing",["display_name"]="Salle des projets",["title"]="PROJETS COMMUNAUTAIRES",["subtitle"]="Idées · Propositions · Collaboration",["center_studs"]={-79,0,7},["size_studs"]={52,16,50},["narrative_prompts"]={"Imaginer ensemble","Présenter une initiative"},["presentation"]="wall-mounted non-collidable frieze and emblem",["gameplay_changes"]=false},{["room_id"]="city_hall.east_wing",["display_name"]="Salle des assemblées",["title"]="ASSEMBLÉES CITOYENNES",["subtitle"]="Participation · Rencontres · Équité",["center_studs"]={79,0,7},["size_studs"]={52,16,50},["narrative_prompts"]={"Participer","Écouter les autres"},["presentation"]="wall-mounted non-collidable frieze and emblem",["gameplay_changes"]=false},{["room_id"]="city_hall.rear_atrium",["display_name"]="Atrium civique",["title"]="L’ATRIUM CIVIQUE",["subtitle"]="Solidarité · Culture · Bien commun",["center_studs"]={0,0,76},["size_studs"]={100,16,56},["narrative_prompts"]={"Célébrer la communauté","Explorer les institutions"},["presentation"]="wall-mounted non-collidable frieze and emblem",["gameplay_changes"]=false}}}
]=]
specModule.Parent=holder
local ok,result=pcall(function()
  local constructor=require(sceneModule)
  return constructor.build({place_key="city_hall",contracts_version="KC34-DOC-1.0",profile="STANDARD",place_model=model})
end)
holder:Destroy()
if not ok then error("B01 NON INSTALLÉ : "..tostring(result)) end
print("B01 décoration locale installée : "..tostring(result.created).." pièces non-collidables. Les portes et le kiosque sont inchangés.")
