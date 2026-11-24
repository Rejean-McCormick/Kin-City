--!strict
-- Pure surface planner. Coordinates remain in each existing institution's local
-- system; no room, portal, anchor, lift or destination is moved by this module.
local Surfaces={}
local function add(plan,name,asset,size,center,yaw,kind)
    table.insert(plan,{name=name,asset=asset,size=size,center=center,yaw=yaw or 0,kind=kind})
end
function Surfaces.wallSegments(room,place,side)
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    local horizontal=side=="front" or side=="back"
    local midpoint=horizontal and cx or cz
    local length=horizontal and w or d
    local wall=side=="front" and cz-d/2 or side=="back" and cz+d/2 or side=="left" and cx-w/2 or cx+w/2
    local gaps={}
    local function gap(c,width)
        local perpendicular=horizontal and c[3] or c[1]
        if math.abs(perpendicular-wall)<3 then
            local axis=horizontal and c[1] or c[3]
            if axis+width/2+1>midpoint-length/2 and axis-width/2-1<midpoint+length/2 then
                table.insert(gaps,{axis-width/2-1,axis+width/2+1})
            end
        end
    end
    for _,portal in ipairs(place.portals) do
        if portal.from_room==room.room_id or portal.to_room==room.room_id then gap(portal.center_studs,portal.clear_width_studs) end
    end
    for _,anchor in ipairs(place.anchors or {}) do
        if anchor.role=="door" then gap(anchor.position_studs,10) end
    end
    table.sort(gaps,function(a,b) return a[1]<b[1] end)
    local start,finish=midpoint-length/2,midpoint+length/2
    local spans={}
    for _,opening in ipairs(gaps) do
        local low,high=math.max(start,opening[1]),math.min(finish,opening[2])
        if low>start then table.insert(spans,{start,low}) end
        start=math.max(start,high)
    end
    if finish>start then table.insert(spans,{start,finish}) end
    return spans,wall,horizontal
end
function Surfaces.room(room,place,program,index,assets,profile)
    local plan={}
    local cx,_,cz=table.unpack(room.center_studs)
    local w,h,d=table.unpack(room.size_studs)
    local serial=0
    for _,side in ipairs({"front","back","left","right"}) do
        local spans,wall,horizontal=Surfaces.wallSegments(room,place,side)
        for _,span in ipairs(spans) do
            local length=span[2]-span[1]
            local count=math.max(1,math.ceil(length/profile.wall_pitch))
            local pitch=length/count
            if pitch>=6 then
                for n=1,count do
                    serial=serial+1
                    local at=span[1]+(n-.5)*pitch
                    local inward=(side=="front" or side=="left") and 1 or -1
                    local x=horizontal and at or wall+inward*1.1
                    local z=horizontal and wall+inward*1.1 or at
                    local yaw=side=="front" and 180 or side=="back" and 0 or side=="left" and -90 or 90
                    local asset=serial%3==0 and assets.window or assets.wall
                    if index==1 and n==2 and side=="back" then asset=assets.glass end
                    add(plan,"WallPanel/"..side.."/"..serial,asset,
                        {pitch-.08,math.min(h-1.2,(pitch-.08)*.9),1.2},{x,.2,z},yaw,"wall")
                end
            end
        end
    end
    -- Square inlays preserve the source geometry's proportions. Native floors
    -- remain the continuous walkable substrate and perimeter frame.
    local nx=math.max(1,math.min(profile.floor_tiles,math.floor(math.sqrt(profile.floor_tiles*w/d)+.5)))
    local nz=math.max(1,math.floor(profile.floor_tiles/nx))
    local edge=math.min((w-6)/nx,(d-6)/nz)
    for x=1,nx do for z=1,nz do
        add(plan,"FloorInlay/"..x.."/"..z,
            program.role=="library" and assets.library_floor or assets.floor,
            {edge,.1,edge},{cx+(x-(nx+1)/2)*edge,.025,cz+(z-(nz+1)/2)*edge},0,"floor")
    end end
    if index==1 then
        add(plan,"EntranceMedallion",assets.medallion,{10,.1,10},{cx,.05,cz},0,"floor")
    end
    -- Tall columns frame the room corners, with all portal and interaction
    -- exclusion zones checked geometrically instead of relying on clone order.
    if index==1 or index==3 or index==6 then
        for _,side in ipairs({-1,1}) do
            local x,z=cx+side*(w/2-3.5),cz+d/2-3.5
            local clear=true
            for _,portal in ipairs(place.portals) do
                local c=portal.center_studs
                if math.abs(x-c[1])<portal.clear_width_studs/2+3 and math.abs(z-c[3])<portal.clear_width_studs/2+3 then clear=false end
            end
            for _,item in ipairs(place.furnishings) do
                local c=item.position_studs
                if math.abs(x-c[1])<7 and math.abs(z-c[3])<7 then clear=false end
            end
            if clear then add(plan,"TallColumn/"..side,assets.column,{2.4,h-2,2.4},{x,0,z},0,"column") end
        end
    end
    return plan
end
function Surfaces.portals(place,assets)
    local slots={}
    for _,portal in ipairs(place.portals) do
        local from,to
        for _,room in ipairs(place.rooms) do
            if room.room_id==portal.from_room then from=room end
            if room.room_id==portal.to_room then to=room end
        end
        local eastWest=from and to and math.abs(from.center_studs[1]-to.center_studs[1])>math.abs(from.center_studs[3]-to.center_studs[3])
        -- AD_Int_Arch_Door includes a closed door leaf and glass: never place
        -- it in a walk-through connection. Use real pack columns on each side.
        for _,side in ipairs({-1,1}) do
            local offset=side*(portal.clear_width_studs/2+1.5)
            add(slots,"PortalColumn/"..portal.portal_id.."/"..side,assets.column,{2,12,2},
                {portal.center_studs[1]+(eastWest and 0 or offset),0,
                 portal.center_studs[3]+(eastWest and offset or 0)},0,"portal")
        end
    end
    for _,anchor in ipairs(place.anchors or {}) do
        if anchor.role=="door" then
            add(slots,"ExitDoor/"..anchor.anchor_id,assets.arch,{12,14,3},
                {anchor.position_studs[1],0,anchor.position_studs[3]},anchor.yaw_degrees or 0,"exit")
        end
    end
    return slots
end
function Surfaces.upper(assets)
    local slots={}
    -- Re-skin the existing upper galleries, at their existing 18-stud level.
    -- Keep all original walking floors, stairs, lift consoles and railings.
    for _,side in ipairs({-1,1}) do
        for n=1,3 do
            add(slots,"UpperGallery/"..side.."/"..n,assets.mezzanine,
                {12,5.1,12},{side*32,18.02-.62*(12/4.05),55+(n-1)*16},side==1 and 180 or 0,"mezzanine")
        end
    end
    return slots
end
return Surfaces
