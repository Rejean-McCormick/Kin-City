--!strict
-- Extension spatiale déterministe des huit institutions.
-- Les salles et ancres canoniques v3 ne changent pas; ailes supplémentaires à IDs permanents.
local Wings={}
local titles={
    library={"Archives ouvertes","Salle de lecture libre","Jardin des connaissances"},
    campus={"Laboratoire pédagogique","Salle d'exploration","Atrium universitaire"},
    justice_palace={"Salle des témoignages","Salle de médiation","Atrium de la justice"},
    city_hall={"Salle des projets","Salle des assemblées","Atrium civique"},
    ekoh_tower={"Observatoire EkoH","Galerie du mérite","Forum de la connaissance"},
    innovation_lab={"Atelier de prototypage","Galerie des inventions","Hall de l'innovation"},
    museum={"Archives du patrimoine","Galerie des créations","Atrium artistique"},
    orgo_center={"Salle des opérations","Bureau communautaire","Atrium des services"},
}
function Wings.expand(place)
    if place.place_key=="city" then return place end
    local extended=table.clone(place)
    extended.rooms=table.clone(place.rooms)
    extended.portals=table.clone(place.portals)
    local key=place.place_key
    local t=titles[key] or {"Aile ouest","Aile est","Grand atrium"}
    local extra={
        {room_id=key..".west_wing",display_name=t[1],center_studs={-79,0,7},size_studs={52,16,50},decor_density="rich",has_walkable_floor=true},
        {room_id=key..".east_wing",display_name=t[2],center_studs={79,0,7},size_studs={52,16,50},decor_density="rich",has_walkable_floor=true},
        {room_id=key..".rear_atrium",display_name=t[3],center_studs={0,0,76},size_studs={100,16,56},decor_density="rich",has_walkable_floor=true},
    }
    for _,room in ipairs(extra) do table.insert(extended.rooms,room) end
    local connectors={
        {portal_id=key..".gallery_to_west",from_room=key..".gallery",to_room=key..".west_wing",center_studs={-51,0,16},clear_width_studs=8},
        {portal_id=key..".chamber_to_east",from_room=key..".chamber",to_room=key..".east_wing",center_studs={51,0,16},clear_width_studs=8},
        {portal_id=key..".gallery_to_rear",from_room=key..".gallery",to_room=key..".rear_atrium",center_studs={-27,0,45.5},clear_width_studs=8},
        {portal_id=key..".chamber_to_rear",from_room=key..".chamber",to_room=key..".rear_atrium",center_studs={27,0,45.5},clear_width_studs=8},
    }
    for _,link in ipairs(connectors) do table.insert(extended.portals,link) end
    return extended
end
return Wings
