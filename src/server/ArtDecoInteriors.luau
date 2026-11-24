--!strict
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Data=require(script.Parent.ArtDecoData)
local Buildings=require(Shared.Buildings)
local Districts=require(Shared.HexagonalDistricts)
local Theme=require(Shared.ArtDecoTheme)
local Factory=require(script.Parent.Factory)
local Assets=require(script.Parent.ArtDecoAssets)
local Rooms=require(script.Parent.ArtDecoRooms)
local Interiors={}
local function sectorForPlace(key)
    for _,building in ipairs(Buildings) do
        if building.interior_place_key==key then return building.district_id end
    end
    return "central"
end
function Interiors.furnishing(parent,item,position)
    -- Keep canonical IDs and interaction hosts while replacing the visible furniture.
    local recipe=Data.placements.furnishings[item.asset_id]
    if not recipe then return nil end
    local frame=CFrame.new(position)*CFrame.Angles(0,math.rad(item.yaw_degrees or 0),0)
    local model=Assets.place(parent,recipe.asset,sectorForPlace(item.place_key),
        Vector3.new(table.unpack(recipe.envelope)),frame,"interior/"..item.place_key)
    if not model then return nil end
    model.Name=item.furnishing_id
    model:SetAttribute("KinFurnishingId",item.furnishing_id)
    model:SetAttribute("KinAssetId",item.asset_id)
    model:SetAttribute("KinPlaceKey",item.place_key or "")
    if item.anchor_id then model:SetAttribute("KinAnchorId",item.anchor_id) end
    local root=Instance.new("Part")
    root.Name="InteractionHost";root.Size=Vector3.new(1,1,1);root.CFrame=frame*CFrame.new(0,2,0)
    root.Transparency=1;root.Anchored=true;root.CanCollide=false;root.CanTouch=false;root.CanQuery=true
    if item.asset_id=="prop.desk" or item.asset_id=="prop.table" then
        local _,size=model:GetBoundingBox()
        root.Size=Vector3.new(size.X*.9,size.Y,size.Z*.9)
        root.CFrame=frame*CFrame.new(0,size.Y/2,0);root.CanCollide=true
    end
    root.Parent=model;model.PrimaryPart=root
    if item.asset_id=="prop.bench" then
        local _,size=model:GetBoundingBox()
        local seat=Instance.new("Seat")
        seat.Name="Assise fonctionnelle";seat.Size=Vector3.new(size.X*.8,.35,math.min(size.Z,2))
        seat.CFrame=frame*CFrame.new(0,1.6,0);seat.Transparency=1;seat.Anchored=true
        seat.CanQuery=false;seat.Parent=model
    end
    if item.asset_id=="prop.lamp" then
        local _,size=model:GetBoundingBox()
        local luminous=Instance.new("Attachment")
        luminous.Name="Source lumineuse";luminous.Position=Vector3.new(0,math.max(0,size.Y-2),0);luminous.Parent=root
        local light=Instance.new("PointLight")
        light.Brightness=1.2;light.Range=18;light.Shadows=false;light:SetAttribute("KinStaticLightLOD",true);light.Parent=luminous
    end
    if item.collision_policy=="no_collision" then
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
    return root
end
local function piece(parent,name,size,cf,color,solid)
    local p=Factory.part(parent,name,size,cf,color,Enum.Material.SmoothPlastic)
    p.CanCollide=solid==true;p.CanTouch=false;p.CanQuery=solid==true;p.CastShadow=solid==true
    return p
end
local function chair(parent,frame,sector,owner)
    local imported=Assets.place(parent,Data.placements.room_furniture.seat,sector,Vector3.new(3.5,3.5,3.5),frame,owner)
    if imported then
        local _,size=imported:GetBoundingBox()
        local seat=Instance.new("Seat")
        seat.Name="Assise fonctionnelle";seat.Size=Vector3.new(size.X*.8,.35,size.Z*.7)
        seat.CFrame=frame*CFrame.new(0,1.5,0);seat.Transparency=1;seat.Anchored=true;seat.CanQuery=false;seat.Parent=imported
        return
    end
    local seat=Instance.new("Seat")
    seat.Name="Assise";seat.Size=Vector3.new(2.4,.5,2.4);seat.CFrame=frame*CFrame.new(0,1.8,0)
    seat.Anchored=true;seat.Color=Theme.teal;seat.Material=Enum.Material.SmoothPlastic;seat.Parent=parent
    piece(parent,"Dossier",Vector3.new(2.4,2,.4),frame*CFrame.new(0,2.8,1.1),Theme.dark,false)
    piece(parent,"Pied",Vector3.new(.7,1.6,.7),frame*CFrame.new(0,.8,0),Theme.bronze,false)
end
function Interiors.room(parent,place,room,origin,index)
    local program=assert(Data.placements.interior_programs[place.place_key],"Missing room program")
    local sector=sectorForPlace(place.place_key)
    local section=Districts.byKey(sector)
    local accent=if section then section.color else Districts.base
    local group=Factory.folder(parent,"Aménagement Art Deco")
    group:SetAttribute("KinRoomProgram",program.role)
    local cx,_,cz=table.unpack(room.center_studs)
    local w,h,d=table.unpack(room.size_studs)
    -- A small common cornice replaces eight overlapping decorative passes.
    for _,side in ipairs({-1,1}) do
        piece(group,"Corniche latérale",Vector3.new(.35,.5,d-2),
            CFrame.new(origin+Vector3.new(cx+side*(w/2-1),h-1.2,cz)),Theme.bronze,false)
    end
    local slots=Rooms.compile(room,place,program,index)
    for n,slot in ipairs(slots) do
        if n>Assets.profile().room_stations then break end
        local base=CFrame.new(origin+Vector3.new(table.unpack(slot.center)))
        local station=Factory.folder(group,slot.name)
        if slot.role=="work" then
            local tableModel=Assets.place(station,Data.placements.room_furniture.desk,sector,
                Vector3.new(8,3.2,4),base,"interior/"..place.place_key)
            if tableModel then
                local _,size=tableModel:GetBoundingBox()
                local collision=piece(tableModel,"Appui de table",Vector3.new(size.X*.9,size.Y,size.Z*.9),
                    base*CFrame.new(0,size.Y/2,0),Theme.stone,true)
                collision.Transparency=1
            else
                piece(station,"Table de travail",Vector3.new(8,.5,4),base*CFrame.new(0,3,0),Theme.stone,true)
                for _,side in ipairs({-1,1}) do
                    piece(station,"Piètement",Vector3.new(.6,2.8,3),base*CFrame.new(side*3.3,1.4,0),Theme.bronze,false)
                end
            end
            chair(station,base*CFrame.new(0,0,3),sector,"interior/"..place.place_key)
        elseif slot.role=="lounge" then
            for _,side in ipairs({-1,1}) do
                chair(station,base*CFrame.new(side*2,0,0),sector,"interior/"..place.place_key)
            end
            local coffee=Assets.place(station,Data.placements.room_furniture.coffee,sector,
                Vector3.new(2.4,1.6,2.4),base*CFrame.new(0,0,-2.5),"interior/"..place.place_key)
            if not coffee then piece(station,"Table basse",Vector3.new(2,.35,2),base*CFrame.new(0,1.4,-2.5),Theme.stone,true) end
        else
            piece(station,"Socle d'exposition",Vector3.new(4,2.5,4),base*CFrame.new(0,1.25,0),Theme.dark,true)
            local object=Assets.place(station,program.feature,sector,Vector3.new(3.5,4,3.5),
                base*CFrame.new(0,2.5,0),"interior/"..place.place_key)
            if not object then
                piece(station,"Œuvre géométrique",Vector3.new(1.8,3,1.8),base*CFrame.new(0,4,0),accent,false)
            end
        end
    end
    -- One intentional architectural source per institution, clear of floor circulation.
    if index==1 then
        local canopy=Data.placements.lobby_canopy
        Assets.place(group,canopy.asset,sector,Vector3.new(math.min(w-8,canopy.envelope[1]),canopy.envelope[2],math.min(d-8,canopy.envelope[3])),
            CFrame.new(origin+Vector3.new(cx,h-canopy.clearance_below_ceiling,cz)),"interior/"..place.place_key)
    end
    if index==1 then
        Assets.place(group,Data.placements.room_furniture.chandelier,sector,Vector3.new(5,5.2,5),
            CFrame.new(origin+Vector3.new(cx,h-6,cz)),"interior/"..place.place_key)
    end
    -- One Art Deco wall piece in each lobby; never cover a portal or change its collider.
    if index==1 then
        local accentRecipe=Data.placements.lobby_accent
        local mirror=Assets.place(group,accentRecipe.asset,sector,
            Vector3.new(table.unpack(accentRecipe.envelope)),
            CFrame.new(origin+Vector3.new(cx+w/2-1.4,7,cz+d/2-7))*CFrame.Angles(0,math.pi/2,0),
            "interior/"..place.place_key)
        if mirror then
            mirror.Name="Miroir de réception Art déco"
            for _,part in ipairs(mirror:GetDescendants()) do
                if part:IsA("BasePart") then part:SetAttribute("KinOptionalDetail",true) end
            end
        end
    end
    -- Gallery journal metadata is retained without recreating the old sculpture stacks.
    local marker=piece(group,"Repère de visite",Vector3.new(.3,.3,.3),CFrame.new(origin+Vector3.new(cx,3,cz)),Theme.teal,false)
    marker.Transparency=1
    marker:SetAttribute("KinGalleryId",place.place_key.."/"..room.room_id)
    marker:SetAttribute("KinGalleryTitle",room.display_name)
    game:GetService("CollectionService"):AddTag(marker,"KinCityGalleryV22")
    return group
end
return Interiors
