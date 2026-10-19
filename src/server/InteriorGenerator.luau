--!strict
local Factory = require(script.Parent.Factory)
local PropGenerator = require(script.Parent.PropGenerator)
local Spatial = require(script.Parent.Spatial)
local InteriorPlus = require(script.Parent.InteriorPlus)
local InteriorWings = require(script.Parent.InteriorWings)
local VerticalArchitecture = require(script.Parent.VerticalArchitecture)
local InstitutionExhibits = require(script.Parent.InstitutionExhibits)
local InteriorCollections = require(script.Parent.InteriorCollections)
local InteriorScenography = require(script.Parent.InteriorScenography)
local SpecializedRooms = require(script.Parent.SpecializedRooms)
local SkyPavilions = require(script.Parent.SkyPavilions)
local InstitutionDiscoveryWings = require(script.Parent.InstitutionDiscoveryWings)
local CrystalInteriors = require(script.Parent.CrystalInteriors)
local InstitutionCraftV20=require(script.Parent.InstitutionCraftV20)
local StoriesV22=require(script.Parent.InstitutionStoriesV22)
local FurnitureV23=require(script.Parent.SculptedFurnitureV23)
local AtlasV23=require(script.Parent.LivingExhibitsV23)
local StageV24=require(script.Parent.InstitutionStagecraftV24)
local InteriorGenerator = {}

local function segment(parent, name, width, height, center, color)
    return Factory.part(parent,name,Vector3.new(width,height,0.85),CFrame.new(center),color,Enum.Material.Concrete)
end

local function wallWithOpening(parent, room, side, place, wallColor, position)
    local cx,_,cz=table.unpack(room.center_studs)
    local width, height, depth=table.unpack(room.size_studs)
    local horiz=(side=="front" or side=="back")
    local wallLength = horiz and width or depth
    local centerCoord= if horiz then cx else cz
    local wallCoord=if side=="front" then cz-depth/2 elseif side=="back" then cz+depth/2 elseif side=="left" then cx-width/2 else cx+width/2
    local openings={}
    for _, portal in ipairs(place.portals) do
        if portal.from_room==room.room_id or portal.to_room==room.room_id then
            local pc=portal.center_studs
            local close= if horiz then math.abs(pc[3]-wallCoord)<3 else math.abs(pc[1]-wallCoord)<3
            if close then
                table.insert(openings,{center=if horiz then pc[1] else pc[3],width=portal.clear_width_studs})
            end
        end
    end
    table.sort(openings,function(a,b)return a.center<b.center end)
    local sections={}
    local start=centerCoord-wallLength/2
    local finish=centerCoord+wallLength/2
    for _,open in ipairs(openings) do
        local lo=math.max(start,open.center-open.width/2)
        local hi=math.min(finish,open.center+open.width/2)
        if lo>start+0.1 then table.insert(sections,{start,lo,16,8}) end
        if hi>lo then table.insert(sections,{lo,hi,7,12.5}) end -- linteau de porte de 9 studs
        start=math.max(start,hi)
    end
    if finish>start+0.1 then table.insert(sections,{start,finish,16,8}) end
    if horiz then
        for _,section in ipairs(sections) do
            local lo,hi,h,y=table.unpack(section)
            segment(parent,"Wall_"..side,hi-lo,h,Vector3.new((hi+lo)/2+position.X,y+position.Y,wallCoord+position.Z),wallColor)
        end
    else
        for _,section in ipairs(sections) do
            local lo,hi,h,y=table.unpack(section)
            Factory.part(parent,"Wall_"..side,Vector3.new(0.85,h,hi-lo),CFrame.new(wallCoord+position.X,y+position.Y,(hi+lo)/2+position.Z),wallColor,Enum.Material.Concrete)
        end
    end
end

function InteriorGenerator.make(parent, canonicalPlace, style)
    local place=InteriorWings.expand(canonicalPlace)
    local origin=Spatial.origin(place.place_key)
    local model=Instance.new("Model")
    model.Name="Intérieur — "..place.place_key
    model:SetAttribute("KinPlaceKey",place.place_key)
    model.Parent=parent
    local walls=Factory.hex(style.palette.wall)
    local floorColor=Factory.hex(style.palette.floor)
    local trim=Factory.hex(style.palette.trim)
    local accent=Factory.hex(style.palette.accent)
    for roomIndex,room in ipairs(place.rooms) do
        local folder=Factory.folder(model,room.room_id)
        local cx,_,cz=table.unpack(room.center_studs)
        local w,h,d=table.unpack(room.size_studs)
        Factory.part(folder,"Floor",Vector3.new(w,1,d),CFrame.new(origin+Vector3.new(cx,-0.5,cz)),floorColor,Enum.Material.Marble)
        for _,side in ipairs({"front","back","left","right"}) do
            wallWithOpening(folder,room,side,place,walls,origin)
        end
        if not string.find(room.room_id,"%.rear_atrium$") then
            Factory.part(folder,"Ceiling",Vector3.new(w,0.65,d),CFrame.new(origin+Vector3.new(cx,16.4,cz)),trim,Enum.Material.SmoothPlastic).CanCollide=false
            Factory.part(folder,"CeilingBorder",Vector3.new(w-2,0.25,d-2),CFrame.new(origin+Vector3.new(cx,15.8,cz)),accent,Enum.Material.Metal).CanCollide=false
        end
        Factory.light(folder,origin+Vector3.new(cx,15.0,cz),1.7,55)
        -- Lecture des noms des pièces à proximité des accès, sans collision.
        Factory.sign(folder,"RoomTitle",origin+Vector3.new(cx,10.8,cz-d/2+0.65),0,room.display_name,math.min(30,w-6),2.5)
        InteriorPlus.decorateRoom(folder,place.place_key,room,origin,style,roomIndex)
        InteriorCollections.make(folder,place.place_key,room,origin,style,roomIndex)
        InteriorScenography.decorate(folder,room,origin,style,place.place_key,roomIndex)
        InstitutionCraftV20.decorate(folder,place.place_key,room,origin,roomIndex)
        StoriesV22.decorate(folder,place.place_key,room,origin,roomIndex)
        FurnitureV23.decorate(folder,place.place_key,room,origin,roomIndex)
        AtlasV23.decorate(folder,place.place_key,room,origin,roomIndex)
        StageV24.decorate(folder,place.place_key,room,origin,roomIndex)
    end
    for _,furn in ipairs(place.furnishings) do
        local palette={wall=walls,trim=trim,accent=accent}
        local inst = table.clone(furn)
        inst.place_key = place.place_key
        PropGenerator.make(model,inst,Spatial.position(place.place_key,furn.position_studs),palette)
    end
    -- Portails décoratifs sur le chemin traversable, sans cloison invisible.
    for _,portal in ipairs(place.portals) do
        local px,_,pz=table.unpack(portal.center_studs)
        local base=origin+Vector3.new(px,0,pz)
        local width=portal.clear_width_studs
        -- Pont de sol sur l’interstice entre pièces (la géométrie v3 prévoit un écart de 3 studs).
        local from,to=nil,nil
        for _,room in ipairs(place.rooms) do
            if room.room_id==portal.from_room then from=room end
            if room.room_id==portal.to_room then to=room end
        end
        local eastWest=from and to and math.abs(from.center_studs[1]-to.center_studs[1]) > math.abs(from.center_studs[3]-to.center_studs[3])
        local bridge=eastWest and Vector3.new(5,1,width) or Vector3.new(width,1,5)
        local header=eastWest and Vector3.new(2.8,0.65,width+2) or Vector3.new(width+2,0.65,2.8)
        Factory.part(model,"PortalThreshold",bridge,CFrame.new(base+Vector3.new(0,-0.5,0)),floorColor,Enum.Material.Marble)
        Factory.part(model,"PortalHeader",header,CFrame.new(base+Vector3.new(0,9.6,0)),accent,Enum.Material.Metal).CanCollide=false
    end
    InstitutionExhibits.make(model,place.place_key,origin)
    SpecializedRooms.make(model,place.place_key,origin)
    VerticalArchitecture.make(model,place.place_key,origin,style)
    SkyPavilions.make(model,place.place_key,origin,style)
    InstitutionDiscoveryWings.make(model,place.place_key,origin,style)
    CrystalInteriors.make(model,place,origin,style)
    require(script.Parent.CrystalRoomStoriesV19).make(model,place,origin,style)
    return model
end

return InteriorGenerator
