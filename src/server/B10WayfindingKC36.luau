--!strict
-- B10 KC36 : wayfinding physique. Les enseignes d'avenue sont la propriété de
-- KoaliUrbanism. Aucun BillboardGui / aucune appellation d'horloge.
-- Les huit repères de portes sont des plaques non bloquantes et statiques.
local Wayfinding={}
local REVISION="b10-kc36-physical-signs-1"
local ROOT_NAME="KinB10Orientation"
local TEAL=Color3.fromRGB(30,104,100)
local BRASS=Color3.fromRGB(186,149,94)
local IVORY=Color3.fromRGB(241,232,202)
local INK=Color3.fromRGB(19,33,34)

local function part(parent:Instance,name:string,size:Vector3,frame:CFrame,color:Color3):BasePart
    local p=Instance.new("Part")
    p.Name=name;p.Size=size;p.CFrame=frame;p.Color=color
    p.Material=Enum.Material.Metal;p.Anchored=true;p.CanCollide=false
    p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Parent=parent
    return p
end
local function paint(board:BasePart,face:Enum.NormalId,heading:string,detail:string)
    local gui=Instance.new("SurfaceGui")
    gui.Name=if face==Enum.NormalId.Front then "ReadableSign" else "ReadableSignBack"
    gui.Face=face;gui.AlwaysOnTop=false;gui.LightInfluence=0.14
    gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud=36;gui.MaxDistance=85;gui.Parent=board
    local bg=Instance.new("Frame")
    bg.Name="Background";bg.Size=UDim2.fromScale(1,1);bg.BorderSizePixel=0
    bg.BackgroundColor3=INK;bg.Parent=gui
    local trim=Instance.new("UIStroke")
    trim.Thickness=2;trim.Color=BRASS;trim.Parent=bg
    local text=Instance.new("TextLabel")
    text.Name="Text";text.Size=UDim2.new(0.92,0,0.56,0)
    text.Position=UDim2.fromScale(0.04,0.05)
    text.BackgroundTransparency=1;text.Font=Enum.Font.Garamond
    text.TextScaled=true;text.TextWrapped=true
    text.TextColor3=IVORY;text.Text=heading;text.Parent=bg
    local subtitle=Instance.new("TextLabel")
    subtitle.Name="Description";subtitle.Size=UDim2.new(0.92,0,0.25,0)
    subtitle.Position=UDim2.fromScale(0.04,0.69)
    subtitle.BackgroundTransparency=1;subtitle.Font=Enum.Font.Gotham
    subtitle.TextScaled=true;subtitle.TextWrapped=true
    subtitle.TextColor3=BRASS;subtitle.Text=detail;subtitle.Parent=bg
end
local function plaque(parent:Instance,position:Vector3,yaw:number,title:string,detail:string,id:string)
    local m=Instance.new("Model")
    m.Name="Repère "..id;m:SetAttribute("KinB10DecorationId","city.wayfinding."..id)
    m:SetAttribute("KinB10StaticPhysical",true)
    m.Parent=parent
    local frame=CFrame.new(position.X,0,position.Z)*CFrame.Angles(0,yaw,0)
    local width=10.8
    for _,side in ipairs({-1,1}) do
        part(m,"Colonne latérale",Vector3.new(.42,4.7,.42),frame*CFrame.new(side*(width/2+.35),2.35,0),TEAL)
    end
    local board=part(m,"Plaque physique",Vector3.new(width,2.5,.22),frame*CFrame.new(0,4.55,0),INK)
    board:SetAttribute("KinSignMount","twin-post")
    paint(board,Enum.NormalId.Front,title,detail)
    paint(board,Enum.NormalId.Back,title,detail)
    return m
end
local function nearestSector(position:Vector3,districts:any):any
    local n=Vector2.new(position.X,position.Z)
    if n.Magnitude<0.01 then return districts.sections[1] end
    local best=nil
    local score=-2
    for _,section in ipairs(districts.sections) do
        local dot=(position.X*section.x+position.Z*section.z)/n.Magnitude
        if dot>score then best=section;score=dot end
    end
    return best
end
local function arrivals(plan:any):{any}
    local city=nil
    for _,place in ipairs(plan.places) do
        if place.place_key=="city" then city=place;break end
    end
    assert(city,"B10 : Place city absente")
    local anchors={}
    for _,a in ipairs(city.anchors) do anchors[a.anchor_id]=a end
    local result={}
    local seen={}
    for _,door in ipairs(plan.doors) do
        if door.source_place_key=="city" then
            assert(not seen[door.door_id],"B10 : porte répétée "..door.door_id)
            seen[door.door_id]=true
            local a=assert(anchors[door.source_anchor_id],"B10 : ancre absente "..door.door_id)
            local b=assert(anchors["city."..door.building_id..".return_spawn"],"B10 : retour absent "..door.door_id)
            table.insert(result,{door=door,doorAnchor=Vector3.new(table.unpack(a.position_studs)),
                returnAnchor=Vector3.new(table.unpack(b.position_studs))})
        end
    end
    assert(#result==8,"B10 : huit entrées attendues")
    table.sort(result,function(a,b) return a.door.door_id<b.door.door_id end)
    return result
end
local titles={
    city_hall="Accueil civique",ekoh_tower="Observatoire EkoH",library="Bibliothèque",
    campus="Université King Klown",justice_palace="Agora Korum",
    innovation_lab="Atelier Konstruct",museum="Musée Kreative",orgo_center="Maison Orgo",
}
function Wayfinding.build(city:Instance,plan:any,districts:any,profile:string?):(Instance,{[string]:number})
    assert(city and city.Name=="Ville","B10 : Ville attendue")
    assert(type(plan)=="table" and type(plan.structures)=="table","B10 : plan absent")
    assert(type(districts)=="table" and #districts.sections==6,"B10 : six sections nécessaires")
    local quality=profile or "STANDARD"
    assert(quality=="LITE" or quality=="STANDARD" or quality=="SHOWCASE","B10 : profil inconnu")
    local doors=arrivals(plan)
    local old=city:FindFirstChild(ROOT_NAME)
    if old and old:GetAttribute("KinB10Revision")==REVISION and old:GetAttribute("KinB10Profile")==quality then
        return old,{avenue=0,entrances=old:GetAttribute("KinB10EntranceMarkers") or 0,skipped=0}
    end
    local stage=Instance.new("Folder")
    stage.Name=ROOT_NAME.."_PREPARE"
    stage:SetAttribute("KinB10Revision",REVISION)
    stage:SetAttribute("KinB10Profile",quality)
    for _,record in ipairs(doors) do
        local sector=assert(nearestSector(record.doorAnchor,districts))
        local approach=record.doorAnchor-record.returnAnchor
        local flat=Vector3.new(approach.X,0,approach.Z)
        local normal=if flat.Magnitude>.5 then flat.Unit else Vector3.new(0,0,-1)
        local lateral=Vector3.new(-normal.Z,0,normal.X)
        local position=record.returnAnchor-normal*3+lateral*9
        if (position-record.doorAnchor).Magnitude<6 then
            position=record.returnAnchor-normal*3-lateral*9
        end
        local yaw=math.atan2(normal.X,normal.Z)
        local key=record.door.destination_place_key
        if key=="museum" then
            plaque(stage,position,yaw,"MUSÉE — FERMÉ","Écran de diffusion à proximité",key)
        else
            plaque(stage,position,yaw,titles[key] or key,"ACCÈS AU BÂTIMENT",key)
        end
        -- Secteur de référence : attribut seulement, jamais une heure affichée.
        local marker=stage:FindFirstChild("Repère "..key)
        if marker then marker:SetAttribute("KinB10Sector",sector.key) end
    end
    stage:SetAttribute("KinB10AvenueMarkers",0)
    stage:SetAttribute("KinB10EntranceMarkers",#doors)
    stage:SetAttribute("KinB10Skipped",0)
    if old then old:Destroy() end
    stage.Name=ROOT_NAME;stage.Parent=city
    return stage,{avenue=0,entrances=#doors,skipped=0}
end
return Wayfinding
