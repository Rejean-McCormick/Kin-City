--!strict
-- B04 standalone overlay PREVIEW, Command Bar, a LOCAL COPY ONLY.
local run=game:GetService("RunService")
assert(run:IsStudio() and not run:IsRunning(),"B04: open Roblox Studio Edit mode, Stop Play")
assert(game.PlaceId==0,"B04: LOCAL PlaceId 0 only; never use in published Places")
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"B04: KC33 scene must already be installed")
assert(world:GetAttribute("KinBuildState")=="Ready","B04: Kin City scene incomplete")
local inside=assert(world:FindFirstChild("Bâtiments visitables"),"B04: missing interiors")
local campus=assert(inside:FindFirstChild("Intérieur — campus"),"B04: missing campus interior")
assert(campus:GetAttribute("KinPlaceKey")=="campus","B04: wrong target")
local origin=assert(campus:GetAttribute("KinInteriorOrigin"),"B04: no canonical campus origin")
local existing=campus:FindFirstChild("B04_CampusDecor_KC34")
assert(not existing or existing:GetAttribute("KinB04Revision")=="B04-CAMPUS-V1-2026-10-26",
    "B04: conflicting revision; manual migration required")
local server=game:GetService("ServerScriptService")
local module=Instance.new("ModuleScript")
module.Name="B04_CampusPreview_Temp"
module.Source=[====[
--!strict
-- Kin City B04 / campus UCKK — optional visual overlay, no routing or gameplay.
-- Never call outside a copy of the campus interior. No asset upload or networking.
local CampusDecor={}

local ACCENT=Color3.fromRGB(117,142,166) -- UCKK, #758EA6 (immutable canonical color)
local TEAL=Color3.fromRGB(30,104,100)  -- KOALI shared #1E6864
local BRASS=Color3.fromRGB(185,147,91)
local INK=Color3.fromRGB(42,59,73)
local STONE=Color3.fromRGB(232,225,212)
local MUTED=Color3.fromRGB(198,207,216)
local REVISION="B04-CAMPUS-V1-2026-10-26"
local ROOT_NAME="B04_CampusDecor_KC34"

local function part(parent:Instance,name:string,size:Vector3,cf:CFrame,color:Color3,material:Enum.Material):Part
    local obj=Instance.new("Part")
    obj.Name=name
    obj.Anchored=true
    obj.CanCollide=false
    obj.CanTouch=false
    obj.CanQuery=false
    obj.CastShadow=false
    obj.Size=size
    obj.CFrame=cf
    obj.Color=color
    obj.Material=material
    obj.Parent=parent
    obj:SetAttribute("KinOptionalDetail",true)
    return obj
end

local function plaque(parent:Instance,origin:Vector3,x:number,y:number,z:number,
                      title:string,subtitle:string,face:Enum.NormalId):number
    local plate=part(parent,"Plaque · "..title,Vector3.new(17.5,3.8,0.14),
        CFrame.new(origin+Vector3.new(x,y,z)),INK,Enum.Material.Metal)
    -- Thin stripe ABOVE the lettering; the text face remains unobstructed.
    part(parent,"Liseré supérieur",Vector3.new(17.1,0.12,0.16),
        plate.CFrame*CFrame.new(0,1.78,if face==Enum.NormalId.Back then 0.09 else -0.09),BRASS,Enum.Material.Metal)
    local gui=Instance.new("SurfaceGui")
    gui.Name="Cartouche didactique"
    gui.Adornee=plate
    gui.Face=face
    gui.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize
    gui.CanvasSize=Vector2.new(700,170)
    gui.LightInfluence=0.2
    gui.AlwaysOnTop=false
    gui.Parent=plate
    local heading=Instance.new("TextLabel")
    heading.Name="Nom de salle"
    heading.BackgroundTransparency=1
    heading.Text=title
    heading.TextColor3=STONE
    heading.Font=Enum.Font.GothamBold
    heading.TextSize=39
    heading.TextScaled=false
    heading.TextWrapped=true
    heading.TextXAlignment=Enum.TextXAlignment.Center
    heading.Size=UDim2.new(1,-20,0,78)
    heading.Position=UDim2.fromOffset(10,9)
    heading.Parent=gui
    local detail=Instance.new("TextLabel")
    detail.Name="Intention pédagogique"
    detail.BackgroundTransparency=1
    detail.Text=subtitle
    detail.TextColor3=MUTED
    detail.Font=Enum.Font.Gotham
    detail.TextSize=23
    detail.TextWrapped=true
    detail.TextXAlignment=Enum.TextXAlignment.Center
    detail.Size=UDim2.new(1,-26,0,66)
    detail.Position=UDim2.fromOffset(13,93)
    detail.Parent=gui
    return 2 -- Part count; SurfaceGui is counted separately by Instances
end

local function panel(parent:Instance,origin:Vector3,x:number,z:number,title:string,detail:string):number
    local face=if z>0 then Enum.NormalId.Front else Enum.NormalId.Back
    return plaque(parent,origin,x,10.0,z,title,detail,face)
end

local function molding(parent:Instance,origin:Vector3,x:number,y:number,z:number,w:number):number
    part(parent,"Moulure laiton",Vector3.new(w,0.16,0.12),
        CFrame.new(origin+Vector3.new(x,y,z)),BRASS,Enum.Material.Metal)
    part(parent,"Filet UCKK",Vector3.new(w-0.8,0.09,0.14),
        CFrame.new(origin+Vector3.new(x,y-0.22,z)),ACCENT,Enum.Material.Metal)
    return 2
end

local function emblem(parent:Instance,origin:Vector3,x:number,z:number):number
    local backing=part(parent,"Médaillon académique",Vector3.new(4.6,4.6,0.18),
        CFrame.new(origin+Vector3.new(x,9,z))*CFrame.Angles(0,0,math.rad(45)),
        TEAL,Enum.Material.Metal)
    backing:SetAttribute("KinArtRole","KC32_CORPS")
    local jewel=part(parent,"Accent universitaire",Vector3.new(2.3,2.3,0.21),
        CFrame.new(origin+Vector3.new(x,9,z+0.13))*CFrame.Angles(0,0,math.rad(45)),
        ACCENT,Enum.Material.Metal)
    jewel:SetAttribute("KinArtRole","KC32_ACCENT")
    return 2
end

local function makeGroup(parent:Instance,name:string):Folder
    local group=Instance.new("Folder")
    group.Name=name
    group.Parent=parent
    return group
end

-- The caller supplies a campus-only Instance built by InteriorGenerator.make.
-- origin must be Spatial.origin('campus'), not an invented 9th PlaceId.
function CampusDecor.build(interior:Instance,origin:Vector3,profile:string):{created:number,skipped:number,revision:string}
    assert(interior:IsA("Model"),"B04: the target must be a Model")
    assert(interior:GetAttribute("KinPlaceKey")=="campus", "B04: incorrect place_key; refusing to draw")
    assert(typeof(origin)=="Vector3","B04: interior origin must be Vector3")
    assert(profile=="LITE" or profile=="STANDARD" or profile=="SHOWCASE", "B04: unknown visual profile")
    local already=interior:FindFirstChild(ROOT_NAME)
    if already then
        assert(already:GetAttribute("KinB04Revision")==REVISION,
            "B04: conflicting campus overlay revision, requires an explicit migration")
        return {created=0,skipped=1,revision=REVISION}
    end
    local root=makeGroup(interior,ROOT_NAME)
    root:SetAttribute("KinB04Revision",REVISION)
    root:SetAttribute("KinPlaceKey","campus")
    root:SetAttribute("KinProfile",profile)
    root:SetAttribute("KinDecorationOnly",true)
    local created=0
    local hall=makeGroup(root,"01 · Hall — orientation")
    -- The canonical exit corridor is x≈0, z≈-45 to -32: no object crosses it.
    created+=panel(hall,origin,-31,-44.15,"UCKK · Campus","Découvrir · Apprendre · Collaborer")
    created+=panel(hall,origin,31,-44.15,"Bienvenue","Six espaces pour explorer les savoirs")
    created+=molding(hall,origin,-31,12.85,-44.10,22)
    created+=molding(hall,origin,31,12.85,-44.10,22)
    if profile~="LITE" then
        created+=emblem(hall,origin,-46,-44.1)
        created+=emblem(hall,origin,46,-44.1)
    end

    local classroom=makeGroup(root,"02 · Salle de cours")
    created+=panel(classroom,origin,-39.5,42.10,"Salle de cours","Leçons, idées et méthodes à découvrir")
    if profile~="LITE" then
        created+=molding(classroom,origin,-27,14.5,42.05,31)
    end
    -- Canonical hall.board_01 is near (-27, 18); these are fixed to a far wall.

    local lab=makeGroup(root,"03 · Laboratoire pédagogique")
    created+=panel(lab,origin,27,42.10,"Laboratoire","Questionner, expérimenter, comprendre")
    if profile~="LITE" then
        created+=molding(lab,origin,27,14.5,42.05,31)
    end

    local west=makeGroup(root,"04 · Laboratoire pédagogique, aile ouest")
    created+=panel(west,origin,-79,31.10,"Aile ouest","Ateliers et méthodes scientifiques")
    if profile=="SHOWCASE" then
        created+=molding(west,origin,-79,14.45,31.05,33)
    end

    local east=makeGroup(root,"05 · Salle d'exploration, aile est")
    created+=panel(east,origin,79,31.10,"Exploration","Chercher, observer, construire des hypothèses")
    if profile=="SHOWCASE" then
        created+=molding(east,origin,79,14.45,31.05,33)
    end

    local atrium=makeGroup(root,"06 · Atrium universitaire")
    created+=panel(atrium,origin,-28,103.10,"Atrium universitaire","Sciences, curiosité et partage")
    if profile~="LITE" then
        created+=panel(atrium,origin,28,103.10,"La connaissance","Expositions éducatives · activités à venir")
    end
    if profile=="SHOWCASE" then
        created+=molding(atrium,origin,-28,14.3,103.05,24)
        created+=molding(atrium,origin,28,14.3,103.05,24)
    end

    root:SetAttribute("KinB04NativeParts",created)
    -- Intentionally no ProximityPrompt, no teleport, no fake course completion.
    -- All Parts are non-collidable; no canonical rooms or existing Instances are changed.
    return {created=created,skipped=0,revision=REVISION}
end

return CampusDecor

]====]
module.Parent=server
local ok,result=pcall(function()
 return require(module).build(campus,origin,"STANDARD")
end)
module:Destroy()
if not ok then error("B04 preview failed: "..tostring(result)) end
print("B04 CAMPUS PREVIEW",result.revision,result.created,"Parts added; Studio ONLY, not a release")
