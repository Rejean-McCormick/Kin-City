# Worlds & Institutions

Kin City has two complementary spatial experiences: an exterior city intended for social exploration and **eight large, themed institution interiors** intended for longer visits.

## Exterior city (`city`)

The exterior generator covers civic facades, radial streets, neighborhoods and residential courts, craft and commercial areas, markets, gardens, public art, intermodal transport, an archipelago, marinas, and outdoor activities. Existing modules include trams, ferries, minibuses, urban and residential citizens, wildlife, interactive local mechanisms and visitor-facing guides.

A visitor sees the facades and entrances of all eight major institutions **without loading all eight detailed interiors into this Place** in the v26 split preview.

## The eight interior destinations

| Place key | In-world identity | Thematic content |
| --- | --- | --- |
| `city_hall` | City Hall | Civic architecture, public participation exhibits |
| `ekoh_tower` | EkoH Tower | Tower spaces and thematic galleries; **no real EkoH account balance** |
| `library` | Great Library | Archives, reading, knowledge and discovery |
| `campus` | KonnectED University | Education, science, observation and learning |
| `justice_palace` | Justice Palace | Justice, ethics and civic exhibits; **no legal service** |
| `innovation_lab` | Innovation Park/Lab | Experiments, engineering and invention |
| `museum` | Kreative Museum | Art, interpretation and interactive displays |
| `orgo_center` | Orgo Center | Organization and network-inspired spaces; **no active Orgo workflow** |

The interiors contain rooms, additional wings, vertical architectural features, skylit pavilions, galleries, furniture, lighting and local discovery objects. Version 23 introduced four-chapter interactive *living atlases* for the institutions. Some local activities may be available; **kOA-linked services remain stubs**.

## Local experiences vs. future services

An exhibit that moves, changes its chapter, or updates a per-session exploration journal can be a real **local Roblox activity**. A terminal labeled “Fonctionnalité à venir” does **not** submit votes, perform identity verification, retrieve education credentials, run Orgo tasks, or grant EkoH rewards.

Discovery journals operate **per session** in the documented v26 baseline. Do not present them as permanent cross-session saved achievements.

## Spatial consistency

The architectural style is unified across exterior facades and interiors, but the scenes are intentionally separate. Interior exits are routed through stable door and anchor IDs. The `LOCAL_UNIVERSE` fallback instead places their interiors far from the city in one Workspace for internal testing only.

[Architecture](Architecture) · [Controls & Interactions](Controls-and-Interactions) · [Places & Teleportation](Places-and-Teleportation)
