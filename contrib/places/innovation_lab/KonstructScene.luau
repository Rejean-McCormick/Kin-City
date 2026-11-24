--!strict
-- B06 Atelier Konstruct: deterministic decorative overlay.
-- Not wired into WorldBuilder. Call build(context) only from a B09-approved adapter.
-- All parts are visual only (CanCollide/CanTouch/CanQuery = false).
-- No PlaceIds, canonical anchors, doors or external KOALI calls are mutated.
local Konstruct={}
local PLACE_KEY="innovation_lab"
local ACCENT=Color3.fromRGB(208,191,134)
local TEAL=Color3.fromRGB(30,104,100)
local BRONZE=Color3.fromRGB(167,126,71)
local DARK=Color3.fromRGB(30,38,45)
local TIERS={LITE=1,STANDARD=2,SHOWCASE=3}
local ROOM_LABELS={["innovation_lab.chamber"]="Salle de démonstration",["innovation_lab.east_wing"]="Galerie des inventions",["innovation_lab.gallery"]="Atelier de fabrication",["innovation_lab.lobby"]="Accueil projets",["innovation_lab.rear_atrium"]="Hall de l'innovation",["innovation_lab.west_wing"]="Atelier de prototypage"}
local PART_CAPS={["LITE"]=24,["SHOWCASE"]=66,["STANDARD"]=42}
local DETAILS={{["id"]="innovation_lab.decor.lobby_01",["position_studs"]={-44,10,-29},["room_id"]="innovation_lab.lobby",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=7},{["id"]="innovation_lab.decor.lobby_02",["position_studs"]={44,10,-29},["room_id"]="innovation_lab.lobby",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=7},{["id"]="innovation_lab.decor.lobby_03",["position_studs"]={0,13,-18},["room_id"]="innovation_lab.lobby",["style"]="hanging_cartouche",["tier"]="STANDARD",["width_studs"]=10},{["id"]="innovation_lab.decor.gallery_01",["position_studs"]={-43,10,4},["room_id"]="innovation_lab.gallery",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=7},{["id"]="innovation_lab.decor.gallery_02",["position_studs"]={-11,10,30},["room_id"]="innovation_lab.gallery",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=7},{["id"]="innovation_lab.decor.gallery_03",["position_studs"]={-27,13,30},["room_id"]="innovation_lab.gallery",["style"]="hanging_cartouche",["tier"]="SHOWCASE",["width_studs"]=9},{["id"]="innovation_lab.decor.chamber_01",["position_studs"]={11,10,4},["room_id"]="innovation_lab.chamber",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=7},{["id"]="innovation_lab.decor.chamber_02",["position_studs"]={43,10,30},["room_id"]="innovation_lab.chamber",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=7},{["id"]="innovation_lab.decor.chamber_03",["position_studs"]={27,13,30},["room_id"]="innovation_lab.chamber",["style"]="hanging_cartouche",["tier"]="STANDARD",["width_studs"]=9},{["id"]="innovation_lab.decor.west_01",["position_studs"]={-97,10,-5},["room_id"]="innovation_lab.west_wing",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=8},{["id"]="innovation_lab.decor.west_02",["position_studs"]={-61,10,24},["room_id"]="innovation_lab.west_wing",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=8},{["id"]="innovation_lab.decor.west_03",["position_studs"]={-79,13,-2},["room_id"]="innovation_lab.west_wing",["style"]="hanging_cartouche",["tier"]="SHOWCASE",["width_studs"]=9},{["id"]="innovation_lab.decor.east_01",["position_studs"]={61,10,-5},["room_id"]="innovation_lab.east_wing",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=8},{["id"]="innovation_lab.decor.east_02",["position_studs"]={97,10,24},["room_id"]="innovation_lab.east_wing",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=8},{["id"]="innovation_lab.decor.east_03",["position_studs"]={79,13,-2},["room_id"]="innovation_lab.east_wing",["style"]="hanging_cartouche",["tier"]="SHOWCASE",["width_studs"]=9},{["id"]="innovation_lab.decor.rear_01",["position_studs"]={-44,10,77},["room_id"]="innovation_lab.rear_atrium",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=10},{["id"]="innovation_lab.decor.rear_02",["position_studs"]={44,10,77},["room_id"]="innovation_lab.rear_atrium",["style"]="wall_ribbon",["tier"]="LITE",["width_studs"]=10},{["id"]="innovation_lab.decor.rear_03",["position_studs"]={0,13,94},["room_id"]="innovation_lab.rear_atrium",["style"]="hanging_cartouche",["tier"]="STANDARD",["width_studs"]=10},{["id"]="innovation_lab.decor.lobby_emblem",["position_studs"]={-23,11,-35},["room_id"]="innovation_lab.lobby",["style"]="diamond_star",["tier"]="SHOWCASE",["width_studs"]=3},{["id"]="innovation_lab.decor.gallery_emblem",["position_studs"]={-42,11,35},["room_id"]="innovation_lab.gallery",["style"]="diamond_star",["tier"]="SHOWCASE",["width_studs"]=3},{["id"]="innovation_lab.decor.chamber_emblem",["position_studs"]={42,11,35},["room_id"]="innovation_lab.chamber",["style"]="diamond_star",["tier"]="SHOWCASE",["width_studs"]=3},{["id"]="innovation_lab.decor.west_wing_emblem",["position_studs"]={-96,11,20},["room_id"]="innovation_lab.west_wing",["style"]="diamond_star",["tier"]="SHOWCASE",["width_studs"]=3},{["id"]="innovation_lab.decor.east_wing_emblem",["position_studs"]={96,11,20},["room_id"]="innovation_lab.east_wing",["style"]="diamond_star",["tier"]="SHOWCASE",["width_studs"]=3},{["id"]="innovation_lab.decor.rear_atrium_emblem",["position_studs"]={0,11,97},["room_id"]="innovation_lab.rear_atrium",["style"]="diamond_star",["tier"]="SHOWCASE",["width_studs"]=3}}

local function visualPart(owner,name,size,frame,color,material)
    local obj=Instance.new("Part")
    obj.Name=name
    obj.Size=size
    obj.CFrame=frame
    obj.Color=color
    obj.Material=material or Enum.Material.SmoothPlastic
    obj.Anchored=true
    obj.CanCollide=false
    obj.CanTouch=false
    obj.CanQuery=false
    obj.CastShadow=false
    obj:SetAttribute("KinOptionalDetail",true)
    obj:SetAttribute("KinPlaceKey",PLACE_KEY)
    obj.Parent=owner
    return obj
end
local function signage(panel,title)
    local gui=Instance.new("SurfaceGui")
    gui.Name="Konstruct_Signalétique"
    gui.Face=Enum.NormalId.Front
    gui.PixelsPerStud=32
    gui.AlwaysOnTop=false
    gui.LightInfluence=0.2
    local line=Instance.new("TextLabel")
    line.Size=UDim2.fromScale(1,1)
    line.BackgroundTransparency=1
    line.Text=title
    line.TextColor3=ACCENT
    line.TextScaled=true
    line.TextWrapped=true
    line.Font=Enum.Font.GothamBold
    line.Parent=gui
    gui.Parent=panel
end

function Konstruct.plan(profile: string)
    assert(TIERS[profile]~=nil,"Profil visuel B06 inconnu")
    local chosen={}
    for _,detail in ipairs(DETAILS) do
        if TIERS[detail.tier]<=TIERS[profile] then
            table.insert(chosen,detail)
        end
    end
    return chosen
end

-- context = {parent=Instance, origin=Vector3, placeKey="innovation_lab", profile="LITE|STANDARD|SHOWCASE"}
-- May be called repeatedly: an existing matching overlay is preserved, never destroyed.
function Konstruct.build(context: any)
    assert(context~=nil and context.parent~=nil,"B06: parent requis")
    assert(context.placeKey==PLACE_KEY,"B06: autre Place interdite")
    local profile=context.profile or "LITE"
    assert(TIERS[profile]~=nil,"B06: profil inconnu")
    local origin=context.origin or Vector3.zero
    local desired=Konstruct.plan(profile)
    local existing=context.parent:FindFirstChild("KinB06_Konstruct_Overlay")
    if existing then
        assert(existing:GetAttribute("KinB06Revision")=="B06-0.1.0" and existing:GetAttribute("KinB06Profile")==profile,
            "B06: overlay existant incompatible; rollback manuel requis")
        return {created=0,reused=true,decorations=#desired,profile=profile}
    end
    local model=Instance.new("Model")
    model.Name="KinB06_Konstruct_Overlay"
    model:SetAttribute("KinPlaceKey",PLACE_KEY)
    model:SetAttribute("KinB06Revision","B06-0.1.0")
    model:SetAttribute("KinB06Profile",profile)
    local created=0
    for _,detail in ipairs(desired) do
        local v=detail.position_studs
        local pos=origin+Vector3.new(v[1],v[2],v[3])
        local frame=CFrame.new(pos)
        local width=detail.width_studs
        if detail.style=="wall_ribbon" then
            visualPart(model,detail.id.."_filet",Vector3.new(width,0.55,0.14),frame,ACCENT,Enum.Material.Metal)
            visualPart(model,detail.id.."_coeur",Vector3.new(width*0.66,0.14,0.18),frame*CFrame.new(0,-0.54,0),TEAL,Enum.Material.Metal)
            created+=2
        elseif detail.style=="hanging_cartouche" then
            local panel=visualPart(model,detail.id.."_cartouche",Vector3.new(width,2.1,0.18),frame,DARK,Enum.Material.SmoothPlastic)
            signage(panel,ROOM_LABELS[detail.room_id] or "KONSTRUCT")
            visualPart(model,detail.id.."_rail_haut",Vector3.new(width+0.5,0.17,0.2),frame*CFrame.new(0,1.17,0),BRONZE,Enum.Material.Metal)
            visualPart(model,detail.id.."_rail_bas",Vector3.new(width+0.5,0.17,0.2),frame*CFrame.new(0,-1.17,0),BRONZE,Enum.Material.Metal)
            created+=3
        elseif detail.style=="diamond_star" then
            visualPart(model,detail.id.."_losange",Vector3.new(width, width, 0.16),
                frame*CFrame.Angles(0,0,math.rad(45)),DARK,Enum.Material.SmoothPlastic)
            visualPart(model,detail.id.."_rayon_h",Vector3.new(width*1.4,0.16,0.22),frame,ACCENT,Enum.Material.Metal)
            visualPart(model,detail.id.."_rayon_v",Vector3.new(0.16,width*1.4,0.22),frame,TEAL,Enum.Material.Metal)
            created+=3
        else
            error("B06: style inconnu")
        end
    end
    assert(created<=PART_CAPS[profile],"B06: budget de parts dépassé")
    -- Mount only after all validation. Incomplete local Model is never left in Workspace.
    model:SetAttribute("KinB06Parts",created)
    model.Parent=context.parent
    return {created=created,reused=false,decorations=#desired,profile=profile}
end
return Konstruct
