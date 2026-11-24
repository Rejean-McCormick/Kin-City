--!strict
local Data={
    metadata={
        branch_id="B07",
        place_key="museum",
        revision="1.0.0",
        accent_rgb={203,128,157},
        entry_policy="BARRED_EXTERIOR_PROMPT",
        broadcast_screen_policy="YOUTUBE_BROADCAST_NEARBY_VISIBLE",
    },
    rooms={
        {room_id="museum.lobby", display_name="Accueil expositions", center={0,0,-29}, size={100,16,34}, role="orientation"},
        {room_id="museum.gallery", display_name="Galerie permanente", center={-27,0,17}, size={44,16,52}, role="heritage"},
        {room_id="museum.chamber", display_name="Galerie temporaire", center={27,0,17}, size={44,16,52}, role="temporary"},
        {room_id="museum.west_wing", display_name="Archives du patrimoine", center={-79,0,7}, size={52,16,50}, role="archives"},
        {room_id="museum.east_wing", display_name="Galerie des créations", center={79,0,7}, size={52,16,50}, role="creation"},
        {room_id="museum.rear_atrium", display_name="Atrium artistique", center={0,0,76}, size={100,16,56}, role="atrium"},
    },
    exterior={
        target_door_id="city.kreative.museum.entry",
        target_anchor_id="city.kreative.museum.front_door",
        return_spawn_anchor_id="city.kreative.museum.return_spawn",
        screen_offset_studs={-14,0,10},
        sign_offset_studs={-7,0,5},
        message_heading="BROADCAST YOUTUBE",
        message_body="PORTE BARRÉE — DIFFUSION À PROXIMITÉ",
    },
    profiles={LITE=16, STANDARD=26, SHOWCASE=36},
}
return Data
