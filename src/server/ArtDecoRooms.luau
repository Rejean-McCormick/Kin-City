--!strict
-- Functional room planning in catalog coordinates; central circulation and canonical anchors are exclusion zones.
local Rooms={}
local function overlaps(ax,az,aw,ad,bx,bz,bw,bd)
    return math.abs(ax-bx)<(aw+bw)/2 and math.abs(az-bz)<(ad+bd)/2
end
function Rooms.clear(slot,room,place)
    local x,z=slot.center[1],slot.center[3]
    local w,d=slot.size[1],slot.size[3]
    local cx,cz=room.center_studs[1],room.center_studs[3]
    local rw,rd=room.size_studs[1],room.size_studs[3]
    if math.abs(x-cx)+w/2>rw/2-2 or math.abs(z-cz)+d/2>rd/2-2 then return false end
    -- A cross-shaped main route remains clear through the center of every room.
    if math.abs(x-cx)<w/2+5 or math.abs(z-cz)<d/2+5 then return false end
    for _,portal in ipairs(place.portals) do
        if portal.from_room==room.room_id or portal.to_room==room.room_id then
            local c=portal.center_studs
            local margin=portal.clear_width_studs+4
            if overlaps(x,z,w,d,c[1],c[3],margin,margin) then return false end
        end
    end
    for _,item in ipairs(place.furnishings) do
        local c=item.position_studs
        if overlaps(x,z,w,d,c[1],c[3],12,12) then return false end
    end
    return true
end
function Rooms.compile(room,place,program,index)
    local result={}
    local role=""
    if index==1 then role="lounge"
    elseif program.role=="gallery" or program.role=="observatory" then role="exhibit"
    else role="work" end
    for _,side in ipairs({-1,1}) do
        local slot={role=role,name=role..side,size={10,5,10},
            center={room.center_studs[1]+side*room.size_studs[1]*.28,0,room.center_studs[3]+room.size_studs[3]*.28}}
        if Rooms.clear(slot,room,place) then table.insert(result,slot) end
    end
    return result
end
return Rooms
