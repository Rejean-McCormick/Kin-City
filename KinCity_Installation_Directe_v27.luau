-- Kin City WORLD_STUB — installation dans Roblox Studio (mode Édition seulement)
-- Collez ce fichier entier dans View > Command Bar et exécutez UNE fois.
-- Aucun appel HTTP / aucune API / aucun jeton.
assert(not game:GetService("RunService"):IsRunning(),"Arrêtez Play avant l'installation.")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerScriptService")
local SP = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
-- Migration du costume autonome; conserver son attribution explicite.
local oldAvatar=SS:FindFirstChild("KinCityKingKlownAvatar")
local preservedOwner=oldAvatar and oldAvatar:GetAttribute("OwnerUserId") or 0
local previousRuntime=SS:FindFirstChild("KinCityRuntime")
if preservedOwner==0 and previousRuntime then preservedOwner=previousRuntime:GetAttribute("KingKlownOwnerUserId") or 0 end
if oldAvatar then oldAvatar:Destroy() end
local oldAura=SP:FindFirstChild("KinCityKingKlownAura")
if oldAura then oldAura:Destroy() end
local existing = RS:FindFirstChild("KinCityShared")
if existing then existing:Destroy() end
existing = SS:FindFirstChild("KinCityRuntime")
if existing then existing:Destroy() end
existing = SP:FindFirstChild("KinCityUI")
if existing then existing:Destroy() end
local shared = Instance.new("Folder")
shared.Name = "KinCityShared"
shared.Parent = RS
local server = Instance.new("Script")
server.Name = "KinCityRuntime"
server.Enabled = false
server:SetAttribute("KingKlownOwnerUserId",preservedOwner)
server.Parent = SS
local client = Instance.new("LocalScript")
client.Name = "KinCityUI"
client.Enabled = false
client.Parent = SP
local function source(parent, name, className, content)
    local v=Instance.new(className)
    v.Name=name
    v.Source=content
    v.Parent=parent
end
source(shared,'AudioManifest',"ModuleScript",[[
--!strict
-- Généré automatiquement : manifest sonore utilisateur
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["archives_sound_id"] = nil,
  ["botanical_sound_id"] = nil,
  ["chimes_sound_id"] = nil,
  ["civic_sound_id"] = nil,
  ["enabled"] = false,
  ["harbor_sound_id"] = nil,
  ["laboratory_sound_id"] = nil,
  ["notes"] = "Importer les WAV originaux assets/audio dans Roblox Creator Hub, copier leurs identifiants puis passer enabled à true. Les huit sons sont FACULTATIFS.",
  ["schema_version"] = "1.0.0",
  ["water_sound_id"] = nil,
  ["wind_sound_id"] = nil,
}

]])
source(shared,'BoulevardRoutes',"ModuleScript",[[
--!strict
-- Six lignes de navettes de surface entre l'entrée de boulevard et chaque quartier.
-- Réseau local. Aucune billettique ni suivi de compte kOA.
local RS=game:GetService("ReplicatedStorage")
local residential=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local routes={}
for i,g in ipairs(residential) do
    local radial=Vector3.new(math.cos(g.angle),0,math.sin(g.angle))
    local tangent=Vector3.new(-radial.Z,0,radial.X)
    local offset=tangent*10
    local a=radial*162+offset
    local b=radial*290+offset
    table.insert(routes,{
        id=string.format("kin.boulevard.bus.%02d",i),
        title="Navette · "..g.title,
        quarter_id=g.id,
        color=g.color,
        start_studs={a.X,0,a.Z},
        finish_studs={b.X,0,b.Z},
        station_names={"Entrée du boulevard",g.title},
    })
end
return routes

]])
source(shared,'BuildIdentity',"ModuleScript",[[
--!strict
-- Généré automatiquement : empreinte exacte du build v27
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["input_count"] = 152,
  ["plan_sha256"] = "0f218410500752602e40e5a000c7f52ca67112b7881070ebda9c64edfd9e6385",
  ["sha256"] = "af1ba991d9beba5ae113a72e0155ab9300cbce072d0f92f61088134b5647d08b",
  ["version"] = "build-v27",
}

]])
source(shared,'Buildings',"ModuleScript",[[
--!strict
-- Généré automatiquement : noms et gabarits des bâtiments
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  {
    ["building_id"] = "central.city_hall",
    ["district_id"] = "central",
    ["entry_door_id"] = "city.central.city_hall.entry",
    ["exit_door_id"] = "city_hall.exit",
    ["exterior_template"] = "civic.hall.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "city_hall",
    ["interior_template"] = "civic.hall.interior",
    ["name"] = "Hôtel de ville",
    ["visual_seed"] = 2200,
  },
  {
    ["building_id"] = "central.ekoh_tower",
    ["district_id"] = "central",
    ["entry_door_id"] = "city.central.ekoh_tower.entry",
    ["exit_door_id"] = "ekoh_tower.exit",
    ["exterior_template"] = "civic.tower.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "ekoh_tower",
    ["interior_template"] = "civic.tower.interior",
    ["name"] = "Tour du Savoir",
    ["visual_seed"] = 2217,
  },
  {
    ["building_id"] = "konnected.library",
    ["district_id"] = "konnected",
    ["entry_door_id"] = "city.konnected.library.entry",
    ["exit_door_id"] = "library.exit",
    ["exterior_template"] = "education.library.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "library",
    ["interior_template"] = "education.library.interior",
    ["name"] = "Grande Bibliothèque",
    ["visual_seed"] = 2234,
  },
  {
    ["building_id"] = "konnected.university",
    ["district_id"] = "konnected",
    ["entry_door_id"] = "city.konnected.university.entry",
    ["exit_door_id"] = "campus.exit",
    ["exterior_template"] = "education.campus.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "campus",
    ["interior_template"] = "education.campus.interior",
    ["name"] = "Univers-Cité",
    ["visual_seed"] = 2251,
  },
  {
    ["building_id"] = "ethikos.justice_palace",
    ["district_id"] = "ethikos",
    ["entry_door_id"] = "city.ethikos.justice_palace.entry",
    ["exit_door_id"] = "justice_palace.exit",
    ["exterior_template"] = "civic.justice.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "justice_palace",
    ["interior_template"] = "civic.justice.interior",
    ["name"] = "Palais de justice",
    ["visual_seed"] = 2268,
  },
  {
    ["building_id"] = "keenkonnect.innovation_lab",
    ["district_id"] = "keenkonnect",
    ["entry_door_id"] = "city.keenkonnect.innovation_lab.entry",
    ["exit_door_id"] = "innovation_lab.exit",
    ["exterior_template"] = "innovation.lab.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "innovation_lab",
    ["interior_template"] = "innovation.lab.interior",
    ["name"] = "Laboratoire d’innovation",
    ["visual_seed"] = 2285,
  },
  {
    ["building_id"] = "kreative.museum",
    ["district_id"] = "kreative",
    ["entry_door_id"] = "city.kreative.museum.entry",
    ["exit_door_id"] = "museum.exit",
    ["exterior_template"] = "culture.museum.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "museum",
    ["interior_template"] = "culture.museum.interior",
    ["name"] = "Musée Kreative",
    ["visual_seed"] = 2302,
  },
  {
    ["building_id"] = "orgo.admin_center",
    ["district_id"] = "orgo",
    ["entry_door_id"] = "city.orgo.admin_center.entry",
    ["exit_door_id"] = "orgo_center.exit",
    ["exterior_template"] = "services.admin.frontage",
    ["interior_mode"] = "separate_place",
    ["interior_place_key"] = "orgo_center",
    ["interior_template"] = "services.admin.interior",
    ["name"] = "Centre administratif",
    ["visual_seed"] = 2319,
  },
}

]])
source(shared,'CivicDestinations',"ModuleScript",[[
--!strict
-- Six scènes publiques autonomes au bord des quartiers résidentiels.
local RS=game:GetService("ReplicatedStorage")
local homes=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local themes={
    {name="Scène du Vivant",theme="jardin",activity="Jardin de lumière"},
    {name="Forum des Savoirs",theme="lecture",activity="Rosace des idées"},
    {name="Esplanade des Arts",theme="arts",activity="Mobile des couleurs"},
    {name="Agora du Mouvement",theme="sport",activity="Cercle des rythmes"},
    {name="Place des Rencontres",theme="communaute",activity="Luminaires partagés"},
    {name="Terrasse des Inventions",theme="science",activity="Réacteur lumineux"},
}
local destinations={}
for i,home in ipairs(homes) do
    local t=themes[i]
    local radius=425
    table.insert(destinations,{
        id=string.format("kin.civic.stage.%02d",i),
        title=t.name,theme=t.theme,activity=t.activity,
        quarter_id=home.id,
        center_studs={math.cos(home.angle)*radius,0,math.sin(home.angle)*radius},
        yaw=math.pi/2-home.angle,
        color=home.color,
    })
end
return destinations

]])
source(shared,'CommunityDestinations',"ModuleScript",[[
--!strict
-- Registre unique des marchés et maisons communautaires v11.
-- Les constructions partent des mêmes coordonnées que les six quartiers v10.
local RS=game:GetService("ReplicatedStorage")
local neighborhoods=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local themes={
    {market="Halle des récoltes",community="Maison des jardins",activity="Atelier botanique",special="serres"},
    {market="Marché du livre",community="Maison des connaissances",activity="Laboratoire de lecture",special="books"},
    {market="Galerie des artisans",community="Maison de la création",activity="Studio des couleurs",special="arts"},
    {market="Halle des promenades",community="Maison du mouvement",activity="Atelier des cycles",special="movement"},
    {market="Marché coopératif",community="Maison des rencontres",activity="Salle de la coopération",special="commons"},
    {market="Halle des inventions",community="Maison de la lumière",activity="Atelier des optiques",special="light"},
}
local places={}
for i,quarter in ipairs(neighborhoods) do
    local t=themes[i]
    local center=Vector3.new(quarter.center_studs[1],0,quarter.center_studs[3])
    local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-quarter.angle,0)
    for _,kind in ipairs({"market","community"}) do
        local offset=if kind=="market" then 78 else -78
        local pos=(base*CFrame.new(offset,0,0)).Position
        table.insert(places,{
            id=quarter.id.."."..kind,
            district=quarter.id,
            kind=kind,
            title=if kind=="market" then t.market else t.community,
            activity=t.activity,
            special=t.special,
            color=quarter.color,
            center_studs={pos.X,0,pos.Z},
            -- Façades orientées vers la place collective du quartier.
            facing=math.pi/2-quarter.angle+(if kind=="market" then math.pi/2 else -math.pi/2),
        })
    end
end
return places

]])
source(shared,'CrystalTheme',"ModuleScript",[[
--!strict
-- Généré automatiquement : direction artistique sarcelle/cristal v17
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["brand"] = {
    ["champagne"] = "#E5D7AF",
    ["deep"] = "#123E3C",
    ["medium"] = "#327C78",
    ["opal"] = "#C5F4F0",
    ["pearl"] = "#EDFDFC",
    ["primary"] = "#1E6864",
    ["stone"] = "#CEE0DA",
    ["water"] = "#407E8E",
    ["wood"] = "#967858",
  },
  ["budgets"] = {
    ["hero_point_light_range"] = 18,
    ["hero_translucent_parts_per_spire"] = 1,
    ["max_crystal_spires_per_major_facade"] = 5,
    ["noncolliding_ornamentation"] = true,
  },
  ["crystal_renders"] = {
    ["glow"] = "petite inclusion Neon",
    ["hero"] = "verre translucide limité aux monuments",
    ["opaque"] = "Slate/SmoothPlastic avec facettes",
  },
  ["design_name"] = "Sarcelle minérale et cristal opalin",
  ["institution_accents"] = {
    ["campus"] = "#A7CFF3",
    ["city_hall"] = "#E5D7AF",
    ["ekoh_tower"] = "#A2EDD2",
    ["innovation_lab"] = "#83DDD8",
    ["justice_palace"] = "#E3CCB0",
    ["library"] = "#E6C99F",
    ["museum"] = "#F1BCCA",
    ["orgo_center"] = "#B8D2ED",
  },
  ["notes"] = {
    "La palette prime sur les anciennes couleurs globales mais conserve une accentuation unique par institution.",
    "Les objets interactifs conservent leurs IDs, CanCollide et capacités; seuls des ornements sont ajoutés.",
    "Ne pas transformer chaque part en verre transparent, le rendu mobile souffrirait de la surimpression.",
  },
  ["schema_version"] = "kincity.crystal/1.0",
}

]])
source(shared,'InteriorOrigins',"ModuleScript",[[
--!strict
-- Généré automatiquement : positions stables des intérieurs
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["campus"] = {
    1800,
    0,
    1800,
  },
  ["city_hall"] = {
    2850,
    0,
    1800,
  },
  ["ekoh_tower"] = {
    3900,
    0,
    1800,
  },
  ["innovation_lab"] = {
    4950,
    0,
    1800,
  },
  ["justice_palace"] = {
    1800,
    0,
    3050,
  },
  ["library"] = {
    2850,
    0,
    3050,
  },
  ["museum"] = {
    3900,
    0,
    3050,
  },
  ["orgo_center"] = {
    4950,
    0,
    3050,
  },
}

]])
source(shared,'IntermodalNetwork',"ModuleScript",[[
--!strict
-- Réseau de correspondances physiques v12, défini une seule fois pour la 3D et l'UI.
-- Ces accès sont des liaisons locales instantanées clairement indiquées, pas des
-- faux voyages en bus, ni des opérations kOA ou des destinations Place publiées.
local RS = game:GetService("ReplicatedStorage")
local routes = require(RS:WaitForChild("KinCityShared"):WaitForChild("BoulevardRoutes"))
local Network = {}
Network.hub = {id="kin.intermodal.central",title="Gare centrale des Connexions",center_studs={0,0,114}}
Network.gates = {}
Network.returns = {}
for i,route in ipairs(routes) do
    local side = if i <= 3 then -1 else 1
    local row = ((i-1)%3)
    local localZ = -19+row*19
    local gateX = side*18
    local item = {
        id=string.format("kin.intermodal.gate.%02d",i),
        line_id=route.id,
        title=route.title,
        color=route.color,
        position_studs={gateX,0,114+localZ},
        arrival_studs={route.start_studs[1],0,route.start_studs[3]},
    }
    table.insert(Network.gates,item)
    for _,direction in ipairs({"start","finish"}) do
        local station=if direction=="start" then route.start_studs else route.finish_studs
        local radial=Vector3.new(station[1],0,station[3])
        local rad=if radial.Magnitude>0 then radial.Unit else Vector3.new(1,0,0)
        local tangent=Vector3.new(-rad.Z,0,rad.X)
        local p=radial+tangent*13
        table.insert(Network.returns,{
            id=string.format("kin.intermodal.return.%02d.%s",i,direction),
            title=route.title,
            line_id=route.id,
            position_studs={p.X,0,p.Z},
            arrival_studs={0,0,71},
            color=route.color,
            direction=direction,
        })
    end
end
return Network

]])
source(shared,'IslandDestinations',"ModuleScript",[[
--!strict
-- Définition commune de l'archipel : villes, bateau et guide lisent la même géographie.
-- Aucun compte, contenu métier ni lien extérieur.
local themes={
    {slug="gardens",title="Île des Jardins suspendus",subtitle="Promenade botanique et serre",color={110,187,141},symbol="botanical"},
    {slug="arts",title="Île des Arts vivants",subtitle="Scène ouverte et installations",color={219,146,154},symbol="arts"},
    {slug="energy",title="Île des Énergies",subtitle="Mouvement et phénomènes",color={236,190,103},symbol="energy"},
    {slug="stars",title="Île de l'Observatoire",subtitle="Ciel et mouvement des astres",color={133,177,219},symbol="stars"},
    {slug="archives",title="Île des Histoires",subtitle="Livres, mémoire et récits",color={184,163,214},symbol="archives"},
    {slug="commons",title="Île des Rencontres",subtitle="Place publique et hospitalité",color={129,208,199},symbol="commons"},
}
local result={}
for i,theme in ipairs(themes) do
    -- Alignement exact sur les quais publics impairs (1, 3, 5, 7, 9, 11).
    local angle=(i-1)*math.pi/3+math.pi/24
    table.insert(result,{
        id="kin.island."..theme.slug,
        kind=theme.slug,
        title=theme.title,
        caption=theme.subtitle,
        symbol=theme.symbol,
        color=theme.color,
        angle=angle,
        radius=700,
        center_studs={700*math.cos(angle),0,700*math.sin(angle)},
        -- Les bateaux suivent la rive droite des passerelles, hors des garde-corps.
        ferry_lane_offset=24,
        ferry_start_radius=540,
        ferry_end_radius=690,
    })
end
return result

]])
source(shared,'KingKlownConfig',"ModuleScript",[[
--!strict
-- Généré automatiquement : King Klown v6 : attribution serveur
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["ownerUserId"] = 0,
  ["studioPreview"] = true,
}

]])
source(shared,'MarinaDestinations',"ModuleScript",[[
--!strict
-- Registre géographique de deux marinas. Commun aux générateurs et au guide.
-- Les activités physiques sont des jeux locaux sans compte ni crédits kOA.
local result={}
for index,angle in ipairs({math.pi/8,9*math.pi/8}) do
    table.insert(result,{
        id=string.format("kin.marina.%02d",index),
        title=if index==1 then "Marina des Découvertes" else "Port des Artisans",
        angle=angle,
        radius=480,
        center_studs={480*math.cos(angle),0,480*math.sin(angle)},
        color=if index==1 then {84,180,203} else {227,170,103},
    })
end
return result

]])
source(shared,'MeshManifest',"ModuleScript",[[
--!strict
-- Généré automatiquement : IDs optionnels des modèles OBJ / bibliothèque Studio v25
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["crystal_canopy"] = nil,
  ["crystal_rosette"] = nil,
  ["harbor_crest"] = nil,
  ["mineral_column"] = nil,
  ["mineral_pediment"] = nil,
  ["mineral_planter"] = nil,
  ["notes"] = "Facultatif : 11 meshes originaux v23-v25. Importer dans Roblox Studio et enregistrer dans ServerStorage.KinCityAssetLibrary; null = géométrie native sans API externe.",
  ["opal_arch"] = nil,
  ["opal_chandelier"] = nil,
  ["opal_console"] = nil,
  ["opal_lattice"] = nil,
  ["opal_spire"] = nil,
  ["schema_version"] = "1.0.0",
}

]])
source(shared,'Messages',"ModuleScript",[[
--!strict
-- Généré automatiquement : textes fr-CA
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["prompt.consult"] = "Consulter",
  ["prompt.enter"] = "Entrer",
  ["prompt.exit"] = "Sortir",
  ["title.ballots"] = "Consultations Smart Vote",
  ["title.catalog"] = "Catalogue de la bibliothèque",
  ["title.consultations"] = "Consultations eThikos",
  ["title.courses"] = "Cours Univers-Cité",
  ["title.ekoh"] = "Profil EkoH",
  ["title.exhibits"] = "Collections du musée",
  ["title.projects"] = "Projets de recherche",
  ["title.tasks"] = "Services administratifs",
  ["ui.close"] = "Fermer",
  ["ui.coming_soon"] = "Fonctionnalité à venir",
  ["ui.no_operation"] = "Aucune opération n’a été effectuée.",
  ["ui.teleport_unavailable"] = "Impossible d’entrer pour le moment.",
}

]])
source(shared,'PlaceRouting',"ModuleScript",[[
--!strict
-- Généré automatiquement : routage de publication
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["campus"] = nil,
  ["city"] = nil,
  ["city_hall"] = nil,
  ["ekoh_tower"] = nil,
  ["innovation_lab"] = nil,
  ["justice_palace"] = nil,
  ["library"] = nil,
  ["museum"] = nil,
  ["orgo_center"] = nil,
}

]])
source(shared,'PromenadeCommerce',"ModuleScript",[[
--!strict
-- Kin City v13 : adresses stables des commerces sur la promenade extérieure.
-- Aucun achat réel; toutes les consultations métier restent WORLD_STUB.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Civic=require(Shared:WaitForChild("CivicDestinations"))
local Public=require(Shared:WaitForChild("PublicDestinations"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local styles={
    {slug="bookbind",name="Atelier de reliure",subtitle="Papier, livres et impression",color={159,184,213}},
    {slug="botanic",name="Herboristerie",subtitle="Plantes et parfums",color={132,191,151}},
    {slug="ceramics",name="Maison des céramiques",subtitle="Matières et techniques",color={222,163,139}},
    {slug="weaving",name="Atelier textile",subtitle="Fibres et tissus",color={203,165,217}},
    {slug="optics",name="Atelier des lumières",subtitle="Couleurs et transparence",color={217,195,115}},
    {slug="instrument",name="Lutherie et sons",subtitle="Musique et fabrication",color={132,196,197}},
}
local output={}
local function near(x,z,pos,r)
    local dx=x-pos[1]
    local dz=z-pos[3]
    return dx*dx+dz*dz<r*r
end
for slot=1,48 do
    local a=2*math.pi*(slot-0.3)/48
    local r=459
    local x,z=math.cos(a)*r,math.sin(a)*r
    local clear=true
    for _,stage in ipairs(Civic) do
        if near(x,z,stage.center_studs,58) then clear=false;break end
    end
    if clear then
        for _,place in ipairs(Public) do
            if near(x,z,place.center_studs,50) then clear=false;break end
        end
    end
    -- Aucun kiosque n'occulte les panoramas, les marinas ou les accès aux quais.
    if clear then
        for _,marinaAngle in ipairs({math.pi/8,9*math.pi/8}) do
            if near(x,z,{480*math.cos(marinaAngle),0,480*math.sin(marinaAngle)},86) then clear=false;break end
        end
    end
    if clear then
        for n=1,8 do
            local theta=n*math.pi/4
            if near(x,z,{467*math.cos(theta),0,467*math.sin(theta)},24) then clear=false;break end
        end
    end
    if clear then
        for n=1,12 do
            local theta=(n-1)*math.pi/6+math.pi/24
            local diff=math.atan2(math.sin(a-theta),math.cos(a-theta))
            if math.abs(diff)<0.06 then clear=false;break end
        end
    end
    if clear then
        for _,b in ipairs(Plan.structures) do
            if near(x,z,b.center_studs,76) then clear=false;break end
        end
    end
    if clear then
        for i=0,5 do
            local bridge=i*math.pi/3+math.pi/24
            local delta=math.atan2(math.sin(a-bridge),math.cos(a-bridge))
            if math.abs(delta)<0.086 then clear=false;break end
        end
    end
    if clear then
        local theme=styles[(slot-1)%#styles+1]
        table.insert(output,{
            id=string.format("kin.commerce.promenade.%02d",slot),
            slot=slot,kind=theme.slug,title=theme.name,
            subtitle=theme.subtitle,color=theme.color,
            center_studs={x,0,z},angle=a,
            yaw=math.pi/2-a,
        })
    end
end
return output

]])
source(shared,'PublicDestinations',"ModuleScript",[[
--!strict
-- Points de visite non métier partagés entre la construction 3D et l'orientation.
-- Positions absolues en studs; aucune identité ni information kOA.
local names={
    {"optics","Maison de la lumière","Réflexion et couleurs",{108,189,218}},
    {"astronomy","Observatoire planétaire","Orbites et gravitation",{174,146,218}},
    {"ecology","Serre des écosystèmes","Biodiversité locale",{112,198,138}},
    {"engineering","Atelier des forces","Équilibre et leviers",{231,176,98}},
    {"water","Atelier de l'eau","Cycles et courants",{92,174,212}},
    {"energy","Pavillon de l'énergie","Circuits et transformation",{238,199,99}},
    {"sound","Jardin des résonances","Ondes et vibrations",{219,142,165}},
    {"nature","Laboratoire végétal","Croissance et adaptation",{149,190,116}},
}
local output={}
for index,item in ipairs(names) do
    local a=(index-1)*math.pi/4+0.27
    table.insert(output,{
        id="kin.conservatory."..item[1],kind=item[1],title=item[2],caption=item[3],color=item[4],
        center_studs={math.cos(a)*414,0,math.sin(a)*414},
        angle=a
    })
end
return output

]])
source(shared,'ResidentialDestinations',"ModuleScript",[[
--!strict
-- Six îlots résidentiels. Coordonnées partagées par le constructeur, la carte et le guide.
-- Les édifices et interventions sont autonomes : aucune identité ou API kOA.
local groups={
    {id="kin.habitat.nord",title="Les Terrasses du Nord",angle=math.rad(75),style="jardin",color={113,177,132}},
    {id="kin.habitat.sagesse",title="Les Maisons des Savoirs",angle=math.rad(135),style="atelier",color={147,178,204}},
    {id="kin.habitat.arts",title="Les Cours des Arts",angle=math.rad(195),style="culture",color={212,152,143}},
    {id="kin.habitat.promenade",title="Le Clos des Promenades",angle=math.rad(255),style="jardin",color={178,181,125}},
    {id="kin.habitat.cooperation",title="Le Village Coopératif",angle=math.rad(315),style="collectif",color={201,169,111}},
    {id="kin.habitat.lumiere",title="Le Quartier de la Lumière",angle=math.rad(350),style="atelier",color={159,178,214}},
}
for _,g in ipairs(groups) do
    g.radius=352
    g.center_studs={g.radius*math.cos(g.angle),0,g.radius*math.sin(g.angle)}
    g.homes=4
end
return groups

]])
source(shared,'RuntimeConfig',"ModuleScript",[[
--!strict
-- Identité propre à cette installation.
return {
  ["mode"] = "SPLIT_PREVIEW",
  ["target_place_key"] = "city",
}

]])
source(shared,'UrbanV14Destinations',"ModuleScript",[[
--!strict
-- Catalogue spatial unique pour les nouvelles constructions v14.
-- Pas de comptes, pas de monnaie, aucune capacité métier simulée.
local RS=game:GetService("ReplicatedStorage")
local stages=require(RS:WaitForChild("KinCityShared"):WaitForChild("CivicDestinations"))
local register={arcades={},workshops={}}
local crafts={
    {title="Librairie des voyages",kind="books",color={205,165,108}},
    {title="Atelier des horloges",kind="clock",color={137,188,187}},
    {title="Salon des jardins",kind="botany",color={123,180,120}},
    {title="Cabinet des inventions",kind="science",color={148,164,219}},
    {title="Maison des couleurs",kind="art",color={220,154,142}},
    {title="Atelier de musique",kind="music",color={202,169,203}},
    {title="Cartographie du monde",kind="maps",color={162,182,205}},
    {title="Objets du mouvement",kind="motion",color={222,189,112}},
}
for i,design in ipairs(crafts) do
    local side=if i<=4 then -1 else 1
    local row=(i-1)%4
    local center={side*64,0,85+row*21}
    table.insert(register.arcades,{
        id=string.format("kin.station.arcade.%02d",i),title=design.title,
        kind=design.kind,color=design.color,center_studs=center,
        yaw=-side*math.pi/2,side=side,
    })
end
local titles={
    "Atelier du vivant","Atelier du savoir","Atelier des couleurs",
    "Atelier du mouvement","Atelier du lien","Atelier des inventions",
}
for i,stage in ipairs(stages) do
    local cf=CFrame.new(stage.center_studs[1],0,stage.center_studs[3])*CFrame.Angles(0,stage.yaw,0)*CFrame.new(-43,0,-3)
    local p=cf.Position
    table.insert(register.workshops,{
        id=string.format("kin.public.workshop.%02d",i),title=titles[i],
        theme=stage.theme,color=stage.color,
        center_studs={p.X,0,p.Z},yaw=stage.yaw,stage_id=stage.id,
    })
end
return register

]])
source(shared,'VisualConfig',"ModuleScript",[[
--!strict
-- Généré automatiquement : budget géométrique cristal v17
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["profile"] = "STANDARD",
  ["settings"] = {
    ["central_jalons"] = 12,
    ["description"] = "style minéral opalin équilibré",
    ["facets_per_spire"] = 4,
    ["glass_hero"] = true,
    ["interior_spires_per_room"] = 2,
    ["mandala_rays"] = 8,
  },
}

]])
source(shared,'WorldPlan',"ModuleScript",[[
--!strict
-- Généré automatiquement : plan spatial Kin City
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["assets"] = {
    {
      ["asset_id"] = "civic.hall.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "civic.hall.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "civic.justice.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "civic.justice.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "civic.tower.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "civic.tower.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "culture.museum.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "culture.museum.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "education.campus.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "education.campus.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "education.library.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "education.library.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "innovation.lab.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "innovation.lab.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.bench",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_bench",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.board",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_board",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.bookshelf",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_bookshelf",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.desk",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_desk",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.display",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_display",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.kiosk",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_kiosk",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.lamp",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_lamp",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.panel",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_panel",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.planter",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_planter",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.table",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_table",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "prop.terminal",
      ["class"] = "prop",
      ["dependencies"] = {},
      ["fallback"] = "primitive_terminal",
      ["generator"] = "PropNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "services.admin.frontage",
      ["class"] = "facade",
      ["dependencies"] = {},
      ["fallback"] = "geometric_facade",
      ["generator"] = "FacadeNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "services.admin.interior",
      ["class"] = "interior",
      ["dependencies"] = {},
      ["fallback"] = "geometric_interior",
      ["generator"] = "InteriorNativeV1",
      ["license"] = "project_original",
      ["revision"] = "native-1",
      ["source"] = "native_procedural",
    },
    {
      ["asset_id"] = "v23.audio.archives",
      ["class"] = "audio",
      ["dependencies"] = {},
      ["fallback"] = "silence",
      ["generator"] = "tools/generate_v23_soundbeds.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.audio.botanique",
      ["class"] = "audio",
      ["dependencies"] = {},
      ["fallback"] = "silence",
      ["generator"] = "tools/generate_v23_soundbeds.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.audio.harmonie_civique",
      ["class"] = "audio",
      ["dependencies"] = {},
      ["fallback"] = "silence",
      ["generator"] = "tools/generate_v23_soundbeds.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.audio.laboratoire",
      ["class"] = "audio",
      ["dependencies"] = {},
      ["fallback"] = "silence",
      ["generator"] = "tools/generate_v23_soundbeds.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.audio.port",
      ["class"] = "audio",
      ["dependencies"] = {},
      ["fallback"] = "silence",
      ["generator"] = "tools/generate_v23_soundbeds.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.material.champagne_mineral",
      ["class"] = "material",
      ["dependencies"] = {},
      ["fallback"] = "native_roblox_material",
      ["generator"] = "tools/generate_v23_materials.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.material.opale_massive",
      ["class"] = "material",
      ["dependencies"] = {},
      ["fallback"] = "native_roblox_material",
      ["generator"] = "tools/generate_v23_materials.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.material.pierre_promenoir",
      ["class"] = "material",
      ["dependencies"] = {},
      ["fallback"] = "native_roblox_material",
      ["generator"] = "tools/generate_v23_materials.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.material.sarcelle_pierre",
      ["class"] = "material",
      ["dependencies"] = {},
      ["fallback"] = "native_roblox_material",
      ["generator"] = "tools/generate_v23_materials.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.mesh.crystal_rosette",
      ["class"] = "mesh",
      ["dependencies"] = {},
      ["fallback"] = "native_faceted_part",
      ["generator"] = "tools/generate_v23_meshes.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.mesh.mineral_column",
      ["class"] = "mesh",
      ["dependencies"] = {},
      ["fallback"] = "native_faceted_part",
      ["generator"] = "tools/generate_v23_meshes.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.mesh.opal_arch",
      ["class"] = "mesh",
      ["dependencies"] = {},
      ["fallback"] = "native_faceted_part",
      ["generator"] = "tools/generate_v23_meshes.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.mesh.opal_chandelier",
      ["class"] = "mesh",
      ["dependencies"] = {},
      ["fallback"] = "native_faceted_part",
      ["generator"] = "tools/generate_v23_meshes.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
    {
      ["asset_id"] = "v23.mesh.opal_spire",
      ["class"] = "mesh",
      ["dependencies"] = {},
      ["fallback"] = "native_faceted_part",
      ["generator"] = "tools/generate_v23_meshes.py",
      ["license"] = "project_original",
      ["revision"] = "v23",
      ["source"] = "local_source",
    },
  },
  ["canonical_sha256"] = "0f218410500752602e40e5a000c7f52ca67112b7881070ebda9c64edfd9e6385",
  ["city_id"] = "kin_city",
  ["compiler"] = "offline-plan-1",
  ["doors"] = {
    {
      ["building_id"] = "konnected.university",
      ["destination_anchor_id"] = "city.konnected.university.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "campus.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.konnected.university.entry",
      ["source_anchor_id"] = "campus.exit.door",
      ["source_place_key"] = "campus",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "central.city_hall",
      ["destination_anchor_id"] = "city_hall.lobby.spawn",
      ["destination_place_key"] = "city_hall",
      ["door_id"] = "city.central.city_hall.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city_hall.exit",
      ["source_anchor_id"] = "city.central.city_hall.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "central.ekoh_tower",
      ["destination_anchor_id"] = "ekoh_tower.lobby.spawn",
      ["destination_place_key"] = "ekoh_tower",
      ["door_id"] = "city.central.ekoh_tower.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "ekoh_tower.exit",
      ["source_anchor_id"] = "city.central.ekoh_tower.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "ethikos.justice_palace",
      ["destination_anchor_id"] = "justice_palace.lobby.spawn",
      ["destination_place_key"] = "justice_palace",
      ["door_id"] = "city.ethikos.justice_palace.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "justice_palace.exit",
      ["source_anchor_id"] = "city.ethikos.justice_palace.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "keenkonnect.innovation_lab",
      ["destination_anchor_id"] = "innovation_lab.lobby.spawn",
      ["destination_place_key"] = "innovation_lab",
      ["door_id"] = "city.keenkonnect.innovation_lab.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "innovation_lab.exit",
      ["source_anchor_id"] = "city.keenkonnect.innovation_lab.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "konnected.library",
      ["destination_anchor_id"] = "library.lobby.spawn",
      ["destination_place_key"] = "library",
      ["door_id"] = "city.konnected.library.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "library.exit",
      ["source_anchor_id"] = "city.konnected.library.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "konnected.university",
      ["destination_anchor_id"] = "campus.lobby.spawn",
      ["destination_place_key"] = "campus",
      ["door_id"] = "city.konnected.university.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "campus.exit",
      ["source_anchor_id"] = "city.konnected.university.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "kreative.museum",
      ["destination_anchor_id"] = "museum.lobby.spawn",
      ["destination_place_key"] = "museum",
      ["door_id"] = "city.kreative.museum.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "museum.exit",
      ["source_anchor_id"] = "city.kreative.museum.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "orgo.admin_center",
      ["destination_anchor_id"] = "orgo_center.lobby.spawn",
      ["destination_place_key"] = "orgo_center",
      ["door_id"] = "city.orgo.admin_center.entry",
      ["is_operational_required"] = true,
      ["return_door_id"] = "orgo_center.exit",
      ["source_anchor_id"] = "city.orgo.admin_center.front_door",
      ["source_place_key"] = "city",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "central.city_hall",
      ["destination_anchor_id"] = "city.central.city_hall.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "city_hall.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.central.city_hall.entry",
      ["source_anchor_id"] = "city_hall.exit.door",
      ["source_place_key"] = "city_hall",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "central.ekoh_tower",
      ["destination_anchor_id"] = "city.central.ekoh_tower.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "ekoh_tower.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.central.ekoh_tower.entry",
      ["source_anchor_id"] = "ekoh_tower.exit.door",
      ["source_place_key"] = "ekoh_tower",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "keenkonnect.innovation_lab",
      ["destination_anchor_id"] = "city.keenkonnect.innovation_lab.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "innovation_lab.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.keenkonnect.innovation_lab.entry",
      ["source_anchor_id"] = "innovation_lab.exit.door",
      ["source_place_key"] = "innovation_lab",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "ethikos.justice_palace",
      ["destination_anchor_id"] = "city.ethikos.justice_palace.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "justice_palace.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.ethikos.justice_palace.entry",
      ["source_anchor_id"] = "justice_palace.exit.door",
      ["source_place_key"] = "justice_palace",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "konnected.library",
      ["destination_anchor_id"] = "city.konnected.library.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "library.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.konnected.library.entry",
      ["source_anchor_id"] = "library.exit.door",
      ["source_place_key"] = "library",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "kreative.museum",
      ["destination_anchor_id"] = "city.kreative.museum.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "museum.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.kreative.museum.entry",
      ["source_anchor_id"] = "museum.exit.door",
      ["source_place_key"] = "museum",
      ["transition_kind"] = "teleport",
    },
    {
      ["building_id"] = "orgo.admin_center",
      ["destination_anchor_id"] = "city.orgo.admin_center.return_spawn",
      ["destination_place_key"] = "city",
      ["door_id"] = "orgo_center.exit",
      ["is_operational_required"] = true,
      ["return_door_id"] = "city.orgo.admin_center.entry",
      ["source_anchor_id"] = "orgo_center.exit.door",
      ["source_place_key"] = "orgo_center",
      ["transition_kind"] = "teleport",
    },
  },
  ["interactions"] = {
    {
      ["anchor_id"] = "hall.kiosk_01",
      ["building_id"] = "central.city_hall",
      ["capability_id"] = "smartvote.ballots.browse",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.ballots",
      ["interaction_id"] = "central.city_hall.vote_01",
      ["place_key"] = "city_hall",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "tower.panel_01",
      ["building_id"] = "central.ekoh_tower",
      ["capability_id"] = "ekoh.profile.view",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.ekoh",
      ["interaction_id"] = "central.ekoh_tower.display_01",
      ["place_key"] = "ekoh_tower",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "hall.terminal_01",
      ["building_id"] = "ethikos.justice_palace",
      ["capability_id"] = "ethikos.consultation.list",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.consultations",
      ["interaction_id"] = "ethikos.justice_palace.terminal_01",
      ["place_key"] = "justice_palace",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "hall.desk_01",
      ["building_id"] = "keenkonnect.innovation_lab",
      ["capability_id"] = "keenkonnect.projects.browse",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.projects",
      ["interaction_id"] = "keenkonnect.innovation_lab.desk_01",
      ["place_key"] = "innovation_lab",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "hall.bookshelf_01",
      ["building_id"] = "konnected.library",
      ["capability_id"] = "konnected.catalog.browse",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.catalog",
      ["interaction_id"] = "konnected.library.bookshelf_01",
      ["place_key"] = "library",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "hall.board_01",
      ["building_id"] = "konnected.university",
      ["capability_id"] = "uckk.courses.browse",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.courses",
      ["interaction_id"] = "konnected.university.board_01",
      ["place_key"] = "campus",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "hall.panel_01",
      ["building_id"] = "kreative.museum",
      ["capability_id"] = "kreative.exhibits.read",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.exhibits",
      ["interaction_id"] = "kreative.museum.panel_01",
      ["place_key"] = "museum",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
    {
      ["anchor_id"] = "hall.terminal_01",
      ["building_id"] = "orgo.admin_center",
      ["capability_id"] = "orgo.tasks.browse",
      ["display_message_key"] = "ui.coming_soon",
      ["display_title_key"] = "title.tasks",
      ["interaction_id"] = "orgo.admin_center.terminal_01",
      ["place_key"] = "orgo_center",
      ["prompt_label_key"] = "prompt.consult",
      ["provider_mode"] = "stub",
    },
  },
  ["mode"] = "WORLD_STUB",
  ["pedestrian_paths"] = {
    {
      ["arrival"] = "city.central.city_hall.return_spawn",
      ["building_id"] = "central.city_hall",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          0,
          0,
          -60,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.central.ekoh_tower.return_spawn",
      ["building_id"] = "central.ekoh_tower",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          60,
          0,
          0,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.ethikos.justice_palace.return_spawn",
      ["building_id"] = "ethikos.justice_palace",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          0,
          0,
          200,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.keenkonnect.innovation_lab.return_spawn",
      ["building_id"] = "keenkonnect.innovation_lab",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          -190,
          0,
          0,
        },
        {
          -190,
          0,
          70,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.konnected.library.return_spawn",
      ["building_id"] = "konnected.library",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          70,
          0,
          0,
        },
        {
          70,
          0,
          30,
        },
        {
          150,
          0,
          30,
        },
        {
          150,
          0,
          50,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.konnected.university.return_spawn",
      ["building_id"] = "konnected.university",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          70,
          0,
          0,
        },
        {
          70,
          0,
          30,
        },
        {
          140,
          0,
          30,
        },
        {
          140,
          0,
          110,
        },
        {
          170,
          0,
          110,
        },
        {
          170,
          0,
          120,
        },
        {
          190,
          0,
          120,
        },
        {
          190,
          0,
          130,
        },
        {
          260,
          0,
          130,
        },
        {
          260,
          0,
          120,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.kreative.museum.return_spawn",
      ["building_id"] = "kreative.museum",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          -170,
          0,
          0,
        },
        {
          -170,
          0,
          -150,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
    {
      ["arrival"] = "city.orgo.admin_center.return_spawn",
      ["building_id"] = "orgo.admin_center",
      ["path_xyz_studs"] = {
        {
          0,
          0,
          0,
        },
        {
          70,
          0,
          0,
        },
        {
          70,
          0,
          -30,
        },
        {
          110,
          0,
          -30,
        },
        {
          110,
          0,
          -200,
        },
      },
      ["start"] = "city.central.spawn",
      ["width_studs"] = 6,
    },
  },
  ["places"] = {
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "campus.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "campus.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "campus.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "campus.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "hall.board_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "campus.gallery",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.board_01",
          ["asset_id"] = "prop.board",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "campus.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "campus.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "campus.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "campus.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "campus.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "campus.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "campus.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "campus.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "campus.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "campus.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "campus.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "campus.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "campus.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "campus.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "campus",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "campus.lobby",
          ["portal_id"] = "campus.portal.lobby.chamber",
          ["to_room"] = "campus.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "campus.lobby",
          ["portal_id"] = "campus.portal.lobby.gallery",
          ["to_room"] = "campus.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Laboratoire pédagogique",
          ["has_walkable_floor"] = true,
          ["room_id"] = "campus.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle de cours",
          ["has_walkable_floor"] = true,
          ["room_id"] = "campus.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Hall du campus",
          ["has_walkable_floor"] = true,
          ["room_id"] = "campus.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 23,
      ["anchors"] = {
        {
          ["anchor_id"] = "city.central.city_hall.front_door",
          ["position_studs"] = {
            -0.0,
            3.0,
            -71.0,
          },
          ["role"] = "door",
          ["yaw_degrees"] = 180.0,
        },
        {
          ["anchor_id"] = "city.central.city_hall.return_spawn",
          ["position_studs"] = {
            -0.0,
            3.0,
            -58.0,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 180.0,
        },
        {
          ["anchor_id"] = "city.central.ekoh_tower.front_door",
          ["position_studs"] = {
            78.0,
            3.0,
            -0.0,
          },
          ["role"] = "door",
          ["yaw_degrees"] = 90.0,
        },
        {
          ["anchor_id"] = "city.central.ekoh_tower.return_spawn",
          ["position_studs"] = {
            65.0,
            3.0,
            -0.0,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 90.0,
        },
        {
          ["anchor_id"] = "city.central.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            0.0,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.district.central.hub",
          ["position_studs"] = {
            0.0,
            3.0,
            0.0,
          },
          ["role"] = "hub",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.district.ethikos.hub",
          ["position_studs"] = {
            0.0,
            3.0,
            155.0,
          },
          ["role"] = "hub",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.district.keenkonnect.hub",
          ["position_studs"] = {
            -145.652,
            3.0,
            53.013,
          },
          ["role"] = "hub",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.district.konnected.hub",
          ["position_studs"] = {
            145.652,
            3.0,
            53.013,
          },
          ["role"] = "hub",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.district.kreative.hub",
          ["position_studs"] = {
            -99.632,
            3.0,
            -118.737,
          },
          ["role"] = "hub",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.district.orgo.hub",
          ["position_studs"] = {
            77.5,
            3.0,
            -134.234,
          },
          ["role"] = "hub",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.ethikos.justice_palace.front_door",
          ["position_studs"] = {
            0.0,
            3.0,
            213.0,
          },
          ["role"] = "door",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.ethikos.justice_palace.return_spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            200.0,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city.keenkonnect.innovation_lab.front_door",
          ["position_studs"] = {
            -200.881,
            3.0,
            73.365,
          },
          ["role"] = "door",
          ["yaw_degrees"] = -69.937,
        },
        {
          ["anchor_id"] = "city.keenkonnect.innovation_lab.return_spawn",
          ["position_studs"] = {
            -188.67,
            3.0,
            68.906,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = -69.937,
        },
        {
          ["anchor_id"] = "city.konnected.library.front_door",
          ["position_studs"] = {
            163.9,
            3.0,
            59.139,
          },
          ["role"] = "door",
          ["yaw_degrees"] = 70.159,
        },
        {
          ["anchor_id"] = "city.konnected.library.return_spawn",
          ["position_studs"] = {
            151.671,
            3.0,
            54.727,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 70.159,
        },
        {
          ["anchor_id"] = "city.konnected.university.front_door",
          ["position_studs"] = {
            276.066,
            3.0,
            128.109,
          },
          ["role"] = "door",
          ["yaw_degrees"] = 65.106,
        },
        {
          ["anchor_id"] = "city.konnected.university.return_spawn",
          ["position_studs"] = {
            264.274,
            3.0,
            122.637,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 65.106,
        },
        {
          ["anchor_id"] = "city.kreative.museum.front_door",
          ["position_studs"] = {
            -178.109,
            3.0,
            -158.711,
          },
          ["role"] = "door",
          ["yaw_degrees"] = -131.704,
        },
        {
          ["anchor_id"] = "city.kreative.museum.return_spawn",
          ["position_studs"] = {
            -168.403,
            3.0,
            -150.062,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = -131.704,
        },
        {
          ["anchor_id"] = "city.orgo.admin_center.front_door",
          ["position_studs"] = {
            120.737,
            3.0,
            -213.75,
          },
          ["role"] = "door",
          ["yaw_degrees"] = 150.54,
        },
        {
          ["anchor_id"] = "city.orgo.admin_center.return_spawn",
          ["position_studs"] = {
            114.344,
            3.0,
            -202.431,
          },
          ["role"] = "spawn",
          ["yaw_degrees"] = 150.54,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["radius_studs"] = 495,
        ["shape"] = "disc",
      },
      ["furnishing_count"] = 0,
      ["furnishings"] = {},
      ["place_id"] = nil,
      ["place_key"] = "city",
      ["portals"] = {},
      ["publication_state"] = "unpublished",
      ["room_count"] = 0,
      ["rooms"] = {},
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "city_hall.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "city_hall.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "city_hall.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "city_hall.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "hall.kiosk_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "city_hall.gallery",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.kiosk_01",
          ["asset_id"] = "prop.kiosk",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "city_hall.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "city_hall.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "city_hall.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "city_hall.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "city_hall.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "city_hall.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "city_hall.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "city_hall.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "city_hall.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "city_hall.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "city_hall.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "city_hall.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "city_hall.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "city_hall.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "city_hall",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "city_hall.lobby",
          ["portal_id"] = "city_hall.portal.lobby.chamber",
          ["to_room"] = "city_hall.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "city_hall.lobby",
          ["portal_id"] = "city_hall.portal.lobby.gallery",
          ["to_room"] = "city_hall.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle du conseil",
          ["has_walkable_floor"] = true,
          ["room_id"] = "city_hall.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Galerie des services",
          ["has_walkable_floor"] = true,
          ["room_id"] = "city_hall.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Accueil public",
          ["has_walkable_floor"] = true,
          ["room_id"] = "city_hall.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "ekoh_tower.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "ekoh_tower.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "ekoh_tower.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "ekoh_tower.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "tower.panel_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "ekoh_tower.gallery",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "tower.panel_01",
          ["asset_id"] = "prop.panel",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "ekoh_tower.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "ekoh_tower.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "ekoh_tower.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "ekoh_tower.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "ekoh_tower.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "ekoh_tower.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "ekoh_tower.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "ekoh_tower.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "ekoh_tower.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "ekoh_tower.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "ekoh_tower.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "ekoh_tower.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "ekoh_tower.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "ekoh_tower.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "ekoh_tower",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "ekoh_tower.lobby",
          ["portal_id"] = "ekoh_tower.portal.lobby.chamber",
          ["to_room"] = "ekoh_tower.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "ekoh_tower.lobby",
          ["portal_id"] = "ekoh_tower.portal.lobby.gallery",
          ["to_room"] = "ekoh_tower.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle d’observation",
          ["has_walkable_floor"] = true,
          ["room_id"] = "ekoh_tower.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Galerie des contributions",
          ["has_walkable_floor"] = true,
          ["room_id"] = "ekoh_tower.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Accueil",
          ["has_walkable_floor"] = true,
          ["room_id"] = "ekoh_tower.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "hall.desk_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "innovation_lab.gallery",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "innovation_lab.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "innovation_lab.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "innovation_lab.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "innovation_lab.lobby",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.desk_01",
          ["asset_id"] = "prop.desk",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "innovation_lab.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "innovation_lab.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "innovation_lab.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "innovation_lab.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "innovation_lab.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "innovation_lab.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "innovation_lab.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "innovation_lab.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "innovation_lab.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "innovation_lab.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "innovation_lab.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "innovation_lab.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "innovation_lab.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "innovation_lab.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "innovation_lab",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "innovation_lab.lobby",
          ["portal_id"] = "innovation_lab.portal.lobby.chamber",
          ["to_room"] = "innovation_lab.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "innovation_lab.lobby",
          ["portal_id"] = "innovation_lab.portal.lobby.gallery",
          ["to_room"] = "innovation_lab.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle de démonstration",
          ["has_walkable_floor"] = true,
          ["room_id"] = "innovation_lab.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Atelier de fabrication",
          ["has_walkable_floor"] = true,
          ["room_id"] = "innovation_lab.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Accueil projets",
          ["has_walkable_floor"] = true,
          ["room_id"] = "innovation_lab.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "hall.terminal_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "justice_palace.gallery",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "justice_palace.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "justice_palace.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "justice_palace.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "justice_palace.lobby",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.terminal_01",
          ["asset_id"] = "prop.terminal",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "justice_palace.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "justice_palace.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "justice_palace.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "justice_palace.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "justice_palace.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "justice_palace.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "justice_palace.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "justice_palace.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "justice_palace.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "justice_palace.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "justice_palace.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "justice_palace.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "justice_palace.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "justice_palace.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "justice_palace",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "justice_palace.lobby",
          ["portal_id"] = "justice_palace.portal.lobby.chamber",
          ["to_room"] = "justice_palace.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "justice_palace.lobby",
          ["portal_id"] = "justice_palace.portal.lobby.gallery",
          ["to_room"] = "justice_palace.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle de délibération",
          ["has_walkable_floor"] = true,
          ["room_id"] = "justice_palace.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle de consultation",
          ["has_walkable_floor"] = true,
          ["room_id"] = "justice_palace.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Hall civique",
          ["has_walkable_floor"] = true,
          ["room_id"] = "justice_palace.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "hall.bookshelf_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "library.gallery",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "library.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "library.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "library.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "library.lobby",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.bookshelf_01",
          ["asset_id"] = "prop.bookshelf",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "library.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "library.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "library.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "library.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "library.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "library.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "library.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "library.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "library.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "library.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "library.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "library.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "library.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "library.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "library",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "library.lobby",
          ["portal_id"] = "library.portal.lobby.chamber",
          ["to_room"] = "library.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "library.lobby",
          ["portal_id"] = "library.portal.lobby.gallery",
          ["to_room"] = "library.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle de lecture",
          ["has_walkable_floor"] = true,
          ["room_id"] = "library.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Galerie des rayonnages",
          ["has_walkable_floor"] = true,
          ["room_id"] = "library.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Hall des lecteurs",
          ["has_walkable_floor"] = true,
          ["room_id"] = "library.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "hall.panel_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "museum.gallery",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "museum.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "museum.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "museum.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "museum.lobby",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.panel_01",
          ["asset_id"] = "prop.panel",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "museum.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "museum.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "museum.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "museum.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "museum.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "museum.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "museum.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "museum.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "museum.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "museum.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "museum.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "museum.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "museum.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "museum.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "museum",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "museum.lobby",
          ["portal_id"] = "museum.portal.lobby.chamber",
          ["to_room"] = "museum.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "museum.lobby",
          ["portal_id"] = "museum.portal.lobby.gallery",
          ["to_room"] = "museum.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Galerie temporaire",
          ["has_walkable_floor"] = true,
          ["room_id"] = "museum.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Galerie permanente",
          ["has_walkable_floor"] = true,
          ["room_id"] = "museum.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Accueil expositions",
          ["has_walkable_floor"] = true,
          ["room_id"] = "museum.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
    {
      ["anchor_count"] = 3,
      ["anchors"] = {
        {
          ["anchor_id"] = "hall.terminal_01",
          ["position_studs"] = {
            -27.0,
            3.0,
            18.0,
          },
          ["role"] = "interaction",
          ["room_id"] = "orgo_center.gallery",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "orgo_center.exit.door",
          ["position_studs"] = {
            0.0,
            3.0,
            -45.0,
          },
          ["role"] = "door",
          ["room_id"] = "orgo_center.lobby",
          ["yaw_degrees"] = 0.0,
        },
        {
          ["anchor_id"] = "orgo_center.lobby.spawn",
          ["position_studs"] = {
            0.0,
            3.0,
            -32.0,
          },
          ["role"] = "spawn",
          ["room_id"] = "orgo_center.lobby",
          ["yaw_degrees"] = 0.0,
        },
      },
      ["bounds"] = {
        ["ground_y_studs"] = 0,
        ["height_studs"] = 22,
        ["shape"] = "rectangle",
        ["size_studs"] = {
          110,
          100,
        },
      },
      ["furnishing_count"] = 7,
      ["furnishings"] = {
        {
          ["anchor_id"] = "hall.terminal_01",
          ["asset_id"] = "prop.terminal",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "orgo_center.interactive.01",
          ["position_studs"] = {
            -27,
            0,
            18,
          },
          ["room_id"] = "orgo_center.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "orgo_center.prop.01",
          ["position_studs"] = {
            15,
            0,
            -29,
          },
          ["room_id"] = "orgo_center.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.planter",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "orgo_center.prop.02",
          ["position_studs"] = {
            -39,
            0,
            -28,
          },
          ["room_id"] = "orgo_center.lobby",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.table",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "orgo_center.prop.03",
          ["position_studs"] = {
            27,
            0,
            20,
          },
          ["room_id"] = "orgo_center.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.lamp",
          ["collision_policy"] = "no_collision",
          ["furnishing_id"] = "orgo_center.prop.04",
          ["position_studs"] = {
            38,
            0,
            38,
          },
          ["room_id"] = "orgo_center.chamber",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.display",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "orgo_center.prop.05",
          ["position_studs"] = {
            -14,
            0,
            37,
          },
          ["room_id"] = "orgo_center.gallery",
          ["yaw_degrees"] = 0,
        },
        {
          ["asset_id"] = "prop.bench",
          ["collision_policy"] = "solid",
          ["furnishing_id"] = "orgo_center.prop.06",
          ["position_studs"] = {
            -32,
            0,
            37,
          },
          ["room_id"] = "orgo_center.gallery",
          ["yaw_degrees"] = 0,
        },
      },
      ["place_id"] = nil,
      ["place_key"] = "orgo_center",
      ["portals"] = {
        {
          ["center_studs"] = {
            27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "orgo_center.lobby",
          ["portal_id"] = "orgo_center.portal.lobby.chamber",
          ["to_room"] = "orgo_center.chamber",
        },
        {
          ["center_studs"] = {
            -27,
            0,
            -10.5,
          },
          ["clear_width_studs"] = 10,
          ["from_room"] = "orgo_center.lobby",
          ["portal_id"] = "orgo_center.portal.lobby.gallery",
          ["to_room"] = "orgo_center.gallery",
        },
      },
      ["publication_state"] = "unpublished",
      ["room_count"] = 3,
      ["rooms"] = {
        {
          ["center_studs"] = {
            27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Salle des opérations",
          ["has_walkable_floor"] = true,
          ["room_id"] = "orgo_center.chamber",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            -27,
            0,
            17,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Espace dossiers",
          ["has_walkable_floor"] = true,
          ["room_id"] = "orgo_center.gallery",
          ["size_studs"] = {
            44,
            16,
            52,
          },
        },
        {
          ["center_studs"] = {
            0,
            0,
            -29,
          },
          ["decor_density"] = "rich",
          ["display_name"] = "Accueil administratif",
          ["has_walkable_floor"] = true,
          ["room_id"] = "orgo_center.lobby",
          ["size_studs"] = {
            100,
            16,
            34,
          },
        },
      },
    },
  },
  ["schema_version"] = "kincity.plan/1.0",
  ["seed"] = 20261018,
  ["structures"] = {
    {
      ["building_id"] = "central.city_hall",
      ["center_studs"] = {
        0,
        0,
        -100,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "civic.hall.frontage",
      ["footprint_studs"] = {
        70,
        56,
      },
      ["height_studs"] = 29,
      ["place_key"] = "city",
      ["style_id"] = "civic_stone",
      ["yaw_degrees"] = 180.0,
    },
    {
      ["building_id"] = "central.ekoh_tower",
      ["center_studs"] = {
        100,
        0,
        0,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "civic.tower.frontage",
      ["footprint_studs"] = {
        42,
        42,
      },
      ["height_studs"] = 73,
      ["place_key"] = "city",
      ["style_id"] = "central_glass",
      ["yaw_degrees"] = 90.0,
    },
    {
      ["building_id"] = "ethikos.justice_palace",
      ["center_studs"] = {
        0,
        0,
        242,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "civic.justice.frontage",
      ["footprint_studs"] = {
        76,
        56,
      },
      ["height_studs"] = 28,
      ["place_key"] = "city",
      ["style_id"] = "civic_stone",
      ["yaw_degrees"] = 0.0,
    },
    {
      ["building_id"] = "keenkonnect.innovation_lab",
      ["center_studs"] = {
        -230,
        0,
        84,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "innovation.lab.frontage",
      ["footprint_studs"] = {
        76,
        60,
      },
      ["height_studs"] = 24,
      ["place_key"] = "city",
      ["style_id"] = "innovation_glass",
      ["yaw_degrees"] = -69.937,
    },
    {
      ["building_id"] = "konnected.library",
      ["center_studs"] = {
        194,
        0,
        70,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "education.library.frontage",
      ["footprint_studs"] = {
        78,
        62,
      },
      ["height_studs"] = 24,
      ["place_key"] = "city",
      ["style_id"] = "warm_academic",
      ["yaw_degrees"] = 70.159,
    },
    {
      ["building_id"] = "konnected.university",
      ["center_studs"] = {
        306,
        0,
        142,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "education.campus.frontage",
      ["footprint_studs"] = {
        82,
        64,
      },
      ["height_studs"] = 31,
      ["place_key"] = "city",
      ["style_id"] = "warm_academic",
      ["yaw_degrees"] = 65.106,
    },
    {
      ["building_id"] = "kreative.museum",
      ["center_studs"] = {
        -202,
        0,
        -180,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "culture.museum.frontage",
      ["footprint_studs"] = {
        82,
        62,
      },
      ["height_studs"] = 24,
      ["place_key"] = "city",
      ["style_id"] = "cultural_copper",
      ["yaw_degrees"] = -131.704,
    },
    {
      ["building_id"] = "orgo.admin_center",
      ["center_studs"] = {
        135,
        0,
        -239,
      },
      ["entrance_clearance_studs"] = 10,
      ["facade_asset_id"] = "services.admin.frontage",
      ["footprint_studs"] = {
        72,
        56,
      },
      ["height_studs"] = 26,
      ["place_key"] = "city",
      ["style_id"] = "service_brick",
      ["yaw_degrees"] = 150.54,
    },
  },
  ["styles"] = {
    ["central_glass"] = {
      ["fenestration"] = "vertical",
      ["identity"] = "tour savoir et transparence",
      ["palette"] = {
        ["accent"] = "#BEEBE4",
        ["floor"] = "#DAEEEA",
        ["trim"] = "#1E6864",
        ["wall"] = "#A6D0CB",
      },
      ["roof"] = "spire",
      ["signage"] = "light_vertical",
    },
    ["civic_stone"] = {
      ["fenestration"] = "rhythmic",
      ["identity"] = "institution publique accessible",
      ["palette"] = {
        ["accent"] = "#E5D7AF",
        ["floor"] = "#E7ECE5",
        ["trim"] = "#1E6864",
        ["wall"] = "#C9D6CD",
      },
      ["roof"] = "flat_parapet",
      ["signage"] = "large_bilingual_ready",
    },
    ["cultural_copper"] = {
      ["fenestration"] = "varied",
      ["identity"] = "mémoire et création",
      ["palette"] = {
        ["accent"] = "#E3BDB1",
        ["floor"] = "#E9E4DC",
        ["trim"] = "#1E6864",
        ["wall"] = "#D2C9BA",
      },
      ["roof"] = "vault",
      ["signage"] = "museum",
    },
    ["innovation_glass"] = {
      ["fenestration"] = "broad",
      ["identity"] = "expérimentation ouverte",
      ["palette"] = {
        ["accent"] = "#83DDD8",
        ["floor"] = "#DCEDE9",
        ["trim"] = "#1E6864",
        ["wall"] = "#B3D4D1",
      },
      ["roof"] = "flat_parapet",
      ["signage"] = "technical",
    },
    ["service_brick"] = {
      ["fenestration"] = "grid",
      ["identity"] = "système discret et lisible",
      ["palette"] = {
        ["accent"] = "#B8D2ED",
        ["floor"] = "#DDE8E2",
        ["trim"] = "#1E6864",
        ["wall"] = "#BDCEC8",
      },
      ["roof"] = "flat_parapet",
      ["signage"] = "quiet",
    },
    ["warm_academic"] = {
      ["fenestration"] = "rhythmic",
      ["identity"] = "apprentissage et lecture",
      ["palette"] = {
        ["accent"] = "#E6C99F",
        ["floor"] = "#EFE6D7",
        ["trim"] = "#1E6864",
        ["wall"] = "#D5CBB1",
      },
      ["roof"] = "gable",
      ["signage"] = "scholarly",
    },
  },
  ["units"] = "stud",
}

]])
source(server,"ArchitecturePlus","ModuleScript",[[
--!strict
-- Grammaire architecturale distincte selon la destination du bâtiment.
-- Aucun asset importé : tout est fabriqué à partir de pièces natives Roblox.
local F = require(script.Parent.Factory)
local A = {}
local function piece(parent,name,base,size,offset,color,material)
    return F.part(parent,name,size,base*CFrame.new(offset),color,material)
end
local function orb(parent,name,base,size,offset,color,material)
    local p=piece(parent,name,base,size,offset,color,material)
    p.Shape=Enum.PartType.Ball
    return p
end
local function cylinder(parent,name,base,diameter,height,offset,color,material)
    local p=piece(parent,name,base,Vector3.new(height,diameter,diameter),offset,color,material)
    -- Cylindre Roblox aligné sur X : conserver son axe vertical avec une rotation locale.
    p.CFrame=base*CFrame.new(offset)*CFrame.Angles(0,0,math.pi/2)
    p.Shape=Enum.PartType.Cylinder
    return p
end
local function pillar(parent,base,x,z,h,stone,accent)
    piece(parent,"Pilier",base,Vector3.new(2.2,h,2.2),Vector3.new(x,h/2,z),stone,Enum.Material.Marble)
    piece(parent,"Chapiteau",base,Vector3.new(3.5,1.0,3.5),Vector3.new(x,h+0.4,z),accent,Enum.Material.Marble)
    piece(parent,"Pied",base,Vector3.new(3.1,0.7,3.1),Vector3.new(x,0.4,z),accent,Enum.Material.Slate)
end
local function staircase(parent,base,d,stone)
    for n=1,3 do
        local depth=2+n*1.3
        local step=piece(parent,"Marche principale",base,Vector3.new(15+n*3,0.35,depth),Vector3.new(0,0.18,-d/2-2-n*1.05),stone,Enum.Material.Marble)
    end
end
local function windowMullions(parent,base,w,d,h,metal)
    local count=math.max(2,math.floor(w/10))
    for level=1,math.max(1,math.floor(h/9)) do
        local y=level*7
        if y<h-4 then
            for i=1,count do
                local x=-w/2+i*w/(count+1)
                piece(parent,"Meneau",base,Vector3.new(0.23,4.6,0.4),Vector3.new(x,y,-d/2-0.45),metal,Enum.Material.Metal).CanCollide=false
                piece(parent,"Linteau fenêtre",base,Vector3.new(4.5,0.34,0.5),Vector3.new(x,y+2.5,-d/2-0.47),metal,Enum.Material.Metal).CanCollide=false
            end
        end
    end
end
function A.decorate(model,structure,building,style)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local w,d=table.unpack(structure.footprint_studs)
    local h=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local accent=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local wall=F.hex(style.palette.wall)
    local id=building.building_id
    local family=structure.style_id
    staircase(model,base,d,trim)
    windowMullions(model,base,w,d,h,trim)
    -- Nombre limité d'ornements répétables pour les appareils modestes.
    if family=="civic_stone" then
        for i=-2,2 do
            pillar(model,base,i*9,-d/2-3,math.min(13,h-4),trim,accent)
        end
        piece(model,"Fronton civique",base,Vector3.new(w-4,2,5),Vector3.new(0,math.min(16,h-3),-d/2-2.4),accent,Enum.Material.Marble)
        for i=-2,2 do
            piece(model,"Parapet",base,Vector3.new(7,3,3),Vector3.new(i*(w-8)/5,h+1,-d/2+1),trim,Enum.Material.Marble)
        end
        if string.find(id,"justice") then
            cylinder(model,"Rotonde",base,19,4,Vector3.new(0,h+2,0),trim,Enum.Material.Marble)
            orb(model,"Coupole",base,Vector3.new(20,10,20),Vector3.new(0,h+8,0),accent,Enum.Material.Slate)
            cylinder(model,"Flèche",base,1.5,8,Vector3.new(0,h+14,0),trim,Enum.Material.Metal)
        else
            cylinder(model,"Cloche du conseil",base,12,6,Vector3.new(0,h+3,0),trim,Enum.Material.Marble)
            orb(model,"Dôme hôtel de ville",base,Vector3.new(14,8,14),Vector3.new(0,h+8,0),accent,Enum.Material.Metal)
        end
    elseif family=="warm_academic" then
        for x=-w/2+5,w/2-5,9 do
            pillar(model,base,x,-d/2-1.2,math.min(12,h-4),trim,wall)
        end
        for i=-2,2 do
            piece(model,"Toiture académique",base,Vector3.new(math.max(8,w/5-1),1.3,d+2),Vector3.new(i*w/5,h+1.1,0),accent,Enum.Material.Slate)
        end
        for side=-1,1,2 do
            piece(model,"Tourelle",base,Vector3.new(7,12,7),Vector3.new(side*(w/2-5),h+5,-d/2+6),wall,Enum.Material.Brick)
            piece(model,"Couronnement",base,Vector3.new(10,2,10),Vector3.new(side*(w/2-5),h+11,-d/2+6),trim,Enum.Material.Slate)
        end
        if string.find(id,"university") then
            piece(model,"Beffroi",base,Vector3.new(12,15,12),Vector3.new(0,h+7,0),trim,Enum.Material.Marble)
            piece(model,"Toit beffroi",base,Vector3.new(15,3,15),Vector3.new(0,h+16,0),accent,Enum.Material.Slate)
        end
    elseif family=="central_glass" then
        for y=9,h-5,10 do
            piece(model,"Bande lumineuse",base,Vector3.new(w+0.3,0.5,d+0.3),Vector3.new(0,y,0),accent,Enum.Material.Neon).CanCollide=false
        end
        for x=-w/2+4,w/2-4,8 do
            piece(model,"Nervure tour",base,Vector3.new(1,h,1),Vector3.new(x,h/2,-d/2-0.8),trim,Enum.Material.Metal)
        end
        orb(model,"Sphère du savoir",base,Vector3.new(11,11,11),Vector3.new(0,h+13,0),accent,Enum.Material.Glass)
        piece(model,"Antenne",base,Vector3.new(1,19,1),Vector3.new(0,h+25,0),trim,Enum.Material.Metal)
    elseif family=="innovation_glass" then
        for side=-1,1,2 do
            piece(model,"Aile laboratoire",base,Vector3.new(w*0.26,h*0.55,d*0.75),Vector3.new(side*w*0.36,h*0.275,4),wall,Enum.Material.Glass)
            piece(model,"Aile accent",base,Vector3.new(w*0.28,1.5,d*0.78),Vector3.new(side*w*0.36,h*0.55,4),accent,Enum.Material.Metal)
        end
        for i=-2,2 do
            piece(model,"Lames solaires",base,Vector3.new(w*0.17,0.4,d*0.5),Vector3.new(i*w/5,h+2,-d/5),Color3.fromRGB(56,92,114),Enum.Material.Glass)
        end
    elseif family=="cultural_copper" then
        for x=-w/2+8,w/2-8,14 do
            piece(model,"Niche musée",base,Vector3.new(8,h*0.53,0.7),Vector3.new(x,h*0.54,-d/2-0.7),trim,Enum.Material.Marble)
            orb(model,"Médaillon",base,Vector3.new(5,5,1),Vector3.new(x,h*0.75,-d/2-1.2),accent,Enum.Material.Metal)
        end
        orb(model,"Verrière musée",base,Vector3.new(w*0.55,12,d*0.5),Vector3.new(0,h+2,0),Color3.fromRGB(130,180,178),Enum.Material.Glass)
        for i=-2,2 do
            piece(model,"Patine cuivre",base,Vector3.new(w/6,1.2,d+1),Vector3.new(i*w/6,h+1,0),accent,Enum.Material.CorrodedMetal)
        end
    elseif family=="service_brick" then
        for y=7,h-3,6 do
            piece(model,"Bande admin",base,Vector3.new(w+0.4,0.6,d+0.4),Vector3.new(0,y,0),accent,Enum.Material.Metal)
        end
        for x=-w/2+8,w/2-8,12 do
            piece(model,"Pilastre admin",base,Vector3.new(1,h-2,2.5),Vector3.new(x,h/2,-d/2-1),trim,Enum.Material.Brick)
        end
    end
    -- Enseigne cohérente avec le style, visible depuis la rue.
    local under=piece(model,"Bande enseigne",base,Vector3.new(math.min(w-9,52),4.4,0.4),Vector3.new(0,math.min(h-3,18),-d/2-2),Color3.fromRGB(36,48,54),Enum.Material.Metal)
    under.CanCollide=false
    return model
end
return A

]])
source(server,"ArtisanGeometryV22","ModuleScript",[[
--!strict
-- Kin City : grammaire de scènes sculptées. Déjà placés, tous les détails sont natifs Roblox.
-- Ces objets sont VISUELS, sans collisions, ni logique métier, ni boucle serveur.
local Kit=require(script.Parent.CrystalKit)
local Studio={}
local function color(kind)
    if kind=="opal" then return Kit.opal end
    if kind=="gold" then return Kit.gold end
    if kind=="deep" then return Kit.deep end
    if kind=="medium" then return Kit.medium end
    return Kit.primary
end
function Studio.part(parent,name,size,frame,pigment,material,optional)
    local p=Kit.part(parent,"Part",name,size,frame,color(pigment),material or Enum.Material.Slate)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    p:SetAttribute("KinDecorV22",true)
    return p
end
function Studio.wedge(parent,name,size,frame,pigment,optional)
    local p=Kit.part(parent,"WedgePart",name,size,frame,color(pigment),Enum.Material.Slate)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    p:SetAttribute("KinDecorV22",true)
    return p
end
function Studio.orb(parent,name,diameter,frame,pigment,optional)
    local p=Studio.part(parent,name,Vector3.new(diameter,diameter,diameter),frame,pigment,Enum.Material.Slate,optional)
    p.Shape=Enum.PartType.Ball
    return p
end
function Studio.beam(parent,name,from,to,thickness,pigment,optional)
    local dir=to-from
    if dir.Magnitude<0.1 then return nil end
    return Studio.part(parent,name,Vector3.new(thickness,thickness,dir.Magnitude),
        CFrame.lookAt((from+to)*0.5,to),pigment,Enum.Material.Metal,optional)
end
function Studio.facet(parent,name,base,radius,height,pigment,optional)
    local h=math.max(0.4,height)
    Studio.part(parent,name.." / cœur",Vector3.new(radius*0.9,h*0.68,radius*0.9),
        base*CFrame.new(0,h*0.34,0),pigment,Enum.Material.Slate,optional)
    local faces=if Kit.profile=="LITE" then 2 else 4
    for k=1,faces do
        local a=2*math.pi*k/faces
        Studio.wedge(parent,name.." / facette",Vector3.new(radius*1.2,h*0.32,radius*0.8),
            base*CFrame.new(math.sin(a)*radius*0.17,h*0.85,math.cos(a)*radius*0.17)*CFrame.Angles(0,a,0),
            if k%2==0 then "opal" else pigment,optional)
    end
end
function Studio.motif(parent,frame,signature,accent,scale)
    -- Lecture claire à distance : au maximum 12 volumes par motif.
    local s=scale or 1
    Studio.orb(parent,"Cœur",1.8*s,frame*CFrame.new(0,0,0),"opal",false)
    if signature=="archive" or signature=="knowledge" then
        for k=-2,2 do
            Studio.part(parent,"Volume gravé",Vector3.new(0.75*s,(2.2+0.2*math.abs(k))*s,0.65*s),
                frame*CFrame.new(k*1.05*s,-0.85*s,0),if k%2==0 then "gold" else accent,
                Enum.Material.Slate,k%2~=0)
        end
    elseif signature=="orbit" then
        for k=1,8 do
            local a=2*math.pi*k/8
            Studio.orb(parent,"Corps céleste",(if k%2==0 then 0.62 else 0.4)*s,
                frame*CFrame.new(math.sin(a)*3*s,math.cos(a)*1.45*s,0),accent,true)
        end
    elseif signature=="balance" then
        Studio.beam(parent,"Traverse",(frame*CFrame.new(-3*s,1.5*s,0)).Position,
            (frame*CFrame.new(3*s,1.5*s,0)).Position,0.24*s,"gold",false)
        for _,side in ipairs({-1,1}) do
            Studio.beam(parent,"Suspente",(frame*CFrame.new(side*2.3*s,1.4*s,0)).Position,
                (frame*CFrame.new(side*2.3*s,-1.4*s,0)).Position,0.12*s,accent,true)
            Studio.part(parent,"Plateau",Vector3.new(2.2*s,0.18*s,1.3*s),
                frame*CFrame.new(side*2.3*s,-1.5*s,0),"opal",Enum.Material.Metal,true)
        end
    elseif signature=="mechanism" then
        for k=1,8 do
            local a=2*math.pi*k/8
            Studio.wedge(parent,"Aube",Vector3.new(1.1*s,2.3*s,0.34*s),
                frame*CFrame.new(math.sin(a)*2.0*s,math.cos(a)*2.0*s,0)*CFrame.Angles(0,0,-a),
                if k%2==0 then accent else "gold",true)
        end
    elseif signature=="art" then
        for k=1,5 do
            Studio.wedge(parent,"Forme",Vector3.new(1.2*s,(1.2+k*0.35)*s,0.72*s),
                frame*CFrame.new((k-3)*1.4*s,((k%3)-1)*0.6*s,0)*CFrame.Angles(0,k*0.4,k*0.13),
                if k%2==0 then accent else "gold",true)
        end
    elseif signature=="network" then
        for k=1,6 do
            local a=2*math.pi*k/6
            local tip=(frame*CFrame.new(math.sin(a)*3*s,math.cos(a)*1.7*s,0)).Position
            Studio.beam(parent,"Lien",frame.Position,tip,0.16*s,"gold",true)
            Studio.orb(parent,"Nœud",0.55*s,CFrame.new(tip),accent,true)
        end
    else -- civic
        for k=-2,2 do
            Studio.part(parent,"Bâtiment miniature",Vector3.new(0.85*s,(1.2+0.4*(k%3))*s,0.78*s),
                frame*CFrame.new(k*1.3*s,-0.7*s,0),if k%2==0 then accent else "gold",Enum.Material.Slate,true)
        end
    end
end
return Studio

]])
source(server,"ArtisanStreets","ModuleScript",[[
--!strict
-- V6: petites rues d'artisans physiquement visitables, avec tables, vitrines et bornes.
local F=require(script.Parent.Factory)
local Courts=require(script.Parent.InstitutionForecourts)
local Artisan={}
local styles={
    {name="Librairie de quartier",tag="Livres",wall=Color3.fromRGB(184,163,133),roof=Color3.fromRGB(75,96,114)},
    {name="Atelier de céramique",tag="Art",wall=Color3.fromRGB(206,166,148),roof=Color3.fromRGB(137,86,85)},
    {name="Serre communautaire",tag="Nature",wall=Color3.fromRGB(142,178,151),roof=Color3.fromRGB(81,115,91)},
    {name="Café du savoir",tag="Rencontres",wall=Color3.fromRGB(208,185,141),roof=Color3.fromRGB(124,82,61)},
    {name="Atelier de réparation",tag="Savoir-faire",wall=Color3.fromRGB(163,180,197),roof=Color3.fromRGB(76,100,119)},
    {name="Galerie des voisins",tag="Patrimoine",wall=Color3.fromRGB(187,163,192),roof=Color3.fromRGB(93,82,120)},
}
local function part(root,label,cf,size,color,mat,solid)
    local p=F.part(root,label,size,cf,color,mat)
    if solid==false then p.CanCollide=false end
    return p
end
local function offset(root,name,base,x,y,z,size,color,mat,solid)
    return part(root,name,base*CFrame.new(x,y,z),size,color,mat,solid)
end
local function pathDistance(x,z,path)
    local nearest=math.huge
    for j=2,#path.path_xyz_studs do
        local a=path.path_xyz_studs[j-1]
        local b=path.path_xyz_studs[j]
        local x1,z1,x2,z2=a[1],a[3],b[1],b[3]
        local dx,dz=x2-x1,z2-z1
        local len=dx*dx+dz*dz
        if len>0 then
            local t=math.clamp(((x-x1)*dx+(z-z1)*dz)/len,0,1)
            local ddx,ddz=x-(x1+dx*t),z-(z1+dz*t)
            nearest=math.min(nearest,math.sqrt(ddx*ddx+ddz*ddz))
        end
    end
    return nearest
end
local function reservedPromenade(x,z)
    for i=1,36 do
        local a=2*math.pi*(i-1)/36+0.11
        local r=344+(i%3)*9
        local dx=x-math.cos(a)*r
        local dz=z-math.sin(a)*r
        if dx*dx+dz*dz<37*37 then return true end
    end
    return false
end
local function canBuild(x,z,plan)
    if Courts.isReserved(x,z,plan.structures) or reservedPromenade(x,z) then return false end
    for _,s in ipairs(plan.structures) do
        local dx=x-s.center_studs[1]
        local dz=z-s.center_studs[3]
        if math.sqrt(dx*dx+dz*dz)<90 then return false end
    end
    for _,path in ipairs(plan.pedestrian_paths) do
        if pathDistance(x,z,path)<(path.width_studs/2+17) then return false end
    end
    return true
end
local function booth(root,index,base,style,yaw)
    local mdl=Instance.new("Model")
    mdl.Name=style.name.." "..tostring(index)
    mdl:SetAttribute("KinArtisanId",string.format("artisan.%02d",index))
    mdl.Parent=root
    local trim=Color3.fromRGB(236,220,189)
    local timber=Color3.fromRGB(130,92,62)
    local metal=Color3.fromRGB(42,66,75)
    local w,h,d=24,13,24
    offset(mdl,"Plancher accessible",base,0,-0.35,0,Vector3.new(w,0.7,d),trim,Enum.Material.WoodPlanks,true)
    offset(mdl,"Mur du fond",base,0,h/2,d/2,Vector3.new(w,h,0.85),style.wall,Enum.Material.Brick,true)
    for _,s in ipairs({-1,1}) do
        offset(mdl,"Mur latéral",base,s*w/2,h/2,0,Vector3.new(0.85,h,d),style.wall,Enum.Material.Brick,true)
        offset(mdl,"Pilier entrée",base,s*5.1,h/2,-d/2,Vector3.new(1.0,h,1.0),trim,Enum.Material.Marble,true)
        offset(mdl,"Façade",base,s*8.7,h/2,-d/2,Vector3.new(6.5,h,0.85),style.wall,Enum.Material.Brick,true)
        offset(mdl,"Vitrine",base,s*8.7,7,-d/2-0.47,Vector3.new(4.6,5.2,0.18),Color3.fromRGB(127,198,207),Enum.Material.Glass,false).Transparency=0.35
        offset(mdl,"Châssis doré",base,s*8.7,10.3,-d/2-0.6,Vector3.new(5.2,0.25,0.28),trim,Enum.Material.Metal,false)
    end
    offset(mdl,"Poutre d'entrée",base,0,11,-d/2,Vector3.new(10,3.8,1.1),trim,Enum.Material.Marble,true)
    offset(mdl,"Toiture inclinée",base,0,h+0.8,0,Vector3.new(w+3,1.4,d+3),style.roof,Enum.Material.Slate,true)
    offset(mdl,"Marquise",base,0,9.9,-14.7,Vector3.new(13.5,0.6,6.4),style.roof,Enum.Material.Metal,false)
    offset(mdl,"Paillasson",base,0,0.18,-13,Vector3.new(7,0.15,3.6),Color3.fromRGB(162,132,102),Enum.Material.Fabric,false)
    -- Les tabourets sont de vrais Seats Roblox : le joueur peut s'y asseoir.
    for j=1,3 do
        local x=(j-2)*6
        offset(mdl,"Comptoir artisan",base,x,2.9,3,Vector3.new(4.7,0.6,4),timber,Enum.Material.WoodPlanks,true)
        local chair=Instance.new("Seat")
        chair.Name="Siège de consultation"
        chair.Size=Vector3.new(2.8,0.9,2.8)
        chair.CFrame=base*CFrame.new(x,1.2,-3.8)
        chair.Color=metal
        chair.Material=Enum.Material.WoodPlanks
        chair.Anchored=true
        chair.Parent=mdl
    end
    for level=1,3 do
        offset(mdl,"Rayon mural",base,-8.3,1.5+level*2.5,9,Vector3.new(4.6,0.35,2.5),timber,Enum.Material.WoodPlanks,true)
        for j=1,4 do
            local clr=Color3.fromHSV((index*0.12+j*0.11+level*0.21)%1,0.4,0.8)
            offset(mdl,"Collection exposée",base,-10.2+(j-1)*1.15,2.4+level*2.5,8.6,Vector3.new(0.8,1.5,1.0),clr,Enum.Material.Fabric,false)
        end
    end
    local counter=offset(mdl,"Terminal de l'atelier",base,7.5,2.2,8,Vector3.new(3.5,4.4,2.2),metal,Enum.Material.Metal,true)
    offset(mdl,"Écran de l'atelier",base,7.5,2.9,6.8,Vector3.new(2.9,2.4,0.14),Color3.fromRGB(112,208,198),Enum.Material.Neon,false)
    counter:SetAttribute("KinStubInteractionId",string.format("artisan.%02d.counter",index))
    counter:SetAttribute("KinStubCapabilityId","future.artisan."..style.tag)
    counter:SetAttribute("KinStubTitle",style.name)
    F.prompt(counter,"Consulter",style.name)
    F.sign(mdl,"Enseigne",(base*CFrame.new(0,12.3,-15)).Position,math.deg(yaw),style.name,20,2.7).CanCollide=false
    return mdl
end
function Artisan.make(city,plan)
    local root=F.folder(city,"Ruelles artisanales et boutiques")
    local count=0
    for i=1,48 do
        local theta=(i-0.6)*math.pi*2/48
        local radius=302+(i%3)*13
        local x,z=math.cos(theta)*radius,math.sin(theta)*radius
        if canBuild(x,z,plan) then
            local base=CFrame.new(x,0.1,z)*CFrame.Angles(0,math.pi/2-theta,0)
            booth(root,i,base,styles[(i-1)%#styles+1],math.pi/2-theta)
            count+=1
        end
    end
    root:SetAttribute("KinArtisanShopsCreated",count)
    return root
end
return Artisan

]])
source(server,"BotanicalKitV20","ModuleScript",[[
--!strict
-- Kin City v20 — arbres architecturaux, profils de détails, géométrie Roblox native.
-- Un tronc porteur et des feuillages sans collision. Aucune boucle, lumière ou asset externe.
local Factory=require(script.Parent.Factory)
local Crystal=require(script.Parent.CrystalKit)
local Botanical={}
local palette={
    Color3.fromRGB(46,112,89), Color3.fromRGB(63,131,103),
    Color3.fromRGB(76,135,116), Color3.fromRGB(73,119,103),
    Color3.fromRGB(58,131,113), Color3.fromRGB(91,135,105),
}
local function leaf(parent,label,size,frame,color)
    local p=Factory.part(parent,label,size,frame,color,Enum.Material.Grass)
    p.Shape=Enum.PartType.Ball
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    p:SetAttribute("KinBotanicalDetail",true)
    p:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    return p
end
local function twig(parent,base,x,y,z,length,angle)
    local p=Factory.part(parent,"Rameau courbé",Vector3.new(0.5,length,0.5),
        base*CFrame.new(x,y,z)*CFrame.Angles(0,0,angle),Color3.fromRGB(111,86,67),Enum.Material.Wood)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    p:SetAttribute("KinOptionalDetail",true)
end
function Botanical.tree(parent,x,z,seed)
    local model=Instance.new("Model")
    model.Name="Arbre minéral — "..tostring(seed)
    model:SetAttribute("KinBotanicalId","city.tree."..tostring(seed))
    model:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    model.Parent=parent
    local kind=seed%3
    local height=11+(seed%5)
    local base=CFrame.new(x,0,z)
    local trunk=Factory.part(model,"Tronc porteur",Vector3.new(1.8,height,1.8),base*CFrame.new(0,height/2,0),
        Color3.fromRGB(111,86,67),Enum.Material.Wood)
    trunk.CanTouch=false;trunk.CastShadow=true
    local green=palette[seed%#palette+1]
    if kind==0 then
        -- Silhouette élancée : couronne étagée, quatre parties au plus en STANDARD.
        leaf(model,"Cime conique basse",Vector3.new(7.4,6.5,7.4),base*CFrame.new(0,height+1.7,0),green)
        leaf(model,"Cime conique haute",Vector3.new(5.5,7.2,5.5),base*CFrame.new(0,height+5,0),palette[(seed+2)%#palette+1])
    elseif kind==1 then
        -- Silhouette étalée de jardin.
        leaf(model,"Canopée principale",Vector3.new(10.5,7,9.8),base*CFrame.new(0,height+2,0),green)
        if Crystal.profile~="LITE" then
            leaf(model,"Canopée latérale",Vector3.new(5.1,5.5,6.2),base*CFrame.new(3.1,height+0.3,-1.3),palette[(seed+1)%#palette+1])
        end
    else
        -- Silhouette ovale, sommet en cristal végétal (pas de Glass).
        leaf(model,"Couronne arrondie",Vector3.new(7.3,9.8,7.3),base*CFrame.new(0,height+2.7,0),green)
        leaf(model,"Cime claire",Vector3.new(4.2,5.3,4.3),base*CFrame.new(-1,height+6.5,0.5),palette[(seed+3)%#palette+1])
    end
    if Crystal.profile~="LITE" and seed%2==0 then
        twig(model,base,-1.2,height-1,0,5.2,0.55)
        twig(model,base,1.25,height-1.2,0,4.5,-0.57)
    end
    if Crystal.profile=="SHOWCASE" and seed%5==0 then
        -- Une inclusion opaline rare dans la cime, sans lumière dynamique.
        local jewel=Crystal.part(model,"Part","Fruit opalin",Vector3.new(0.8,1.5,0.8),
            base*CFrame.new(1.7,height+3,-2),Crystal.opal,Enum.Material.Neon)
        jewel:SetAttribute("KinOptionalDetail",true)
    end
    return model
end
return Botanical

]])
source(server,"BoulevardBuses","ModuleScript",[[
--!strict
-- Kin City v11 : six lignes de minibus électriques, huit passagers par véhicule.
-- Lignes le long des boulevards existants, de l'entrée au quartier résidentiel.
-- Animation ancrée serveur; aucune billettique, économie ni service kOA.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RS=game:GetService("ReplicatedStorage")
local Routes=require(RS:WaitForChild("KinCityShared"):WaitForChild("BoulevardRoutes"))
local F=require(script.Parent.Factory)
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local Buses={}
local CAPACITY=8
local BOARD_SECONDS=6
local SPEED=22
local BASS=Color3.fromRGB(30,104,100)
local ROOF=Color3.fromRGB(233,220,186)
local routesById={}
for _,r in ipairs(Routes) do routesById[r.id]=r end
local queues={}
local occupied={}
local activeTrips={}
local sequence=0

local function v(p,y)
    return Vector3.new(p[1],y or 2.2,p[3])
end
local function modelPart(parent,name,sz,cf,col,mat,collide)
    local p=F.part(parent,name,sz,cf,col,mat)
    if collide==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function makeBus(parent,id,route)
    local car=Instance.new("Model")
    car.Name="Minibus collectif "..id
    car.Parent=parent
    car:SetAttribute("KinBoulevardBus",route.id)
    car:SetAttribute("KinBusCapacity",CAPACITY)
    local color=Color3.fromRGB(route.color[1],route.color[2],route.color[3])
    local pivot=modelPart(car,"Pivot",Vector3.new(0.4,0.4,0.4),CFrame.new(),BASS,Enum.Material.Metal,false)
    pivot.Transparency=1
    car.PrimaryPart=pivot
    modelPart(car,"Plateforme roulante",Vector3.new(12.5,0.8,24),CFrame.new(0,1.5,0),BASS,Enum.Material.Metal,false)
    modelPart(car,"Sol intérieur",Vector3.new(11.5,0.45,21.7),CFrame.new(0,2.2,0),ROOF,Enum.Material.WoodPlanks,false)
    modelPart(car,"Toit panoramique",Vector3.new(13.0,0.55,23.0),CFrame.new(0,8.6,0),ROOF,Enum.Material.Metal,false)
    for _,side in ipairs({-1,1}) do
        modelPart(car,"Flanc vitré",Vector3.new(0.35,4.4,21),CFrame.new(side*6.1,5.4,0),Color3.fromRGB(156,212,220),Enum.Material.Glass,false).Transparency=0.42
        modelPart(car,"Bande de couleur",Vector3.new(0.4,0.75,23),CFrame.new(side*6.2,3.3,0),color,Enum.Material.Neon,false)
        for _,z in ipairs({-9,9}) do
            modelPart(car,"Roue",Vector3.new(3,3,1.1),CFrame.new(side*6.3,0.8,z)*CFrame.Angles(0,math.pi/2,0),Color3.fromRGB(30,43,45),Enum.Material.SmoothPlastic,false).Shape=Enum.PartType.Cylinder
        end
    end
    modelPart(car,"Face avant",Vector3.new(12,5.8,0.5),CFrame.new(0,5,-11.6),BASS,Enum.Material.Metal,false)
    modelPart(car,"Face arrière",Vector3.new(12,5.8,0.5),CFrame.new(0,5,11.6),BASS,Enum.Material.Metal,false)
    for _,x in ipairs({-4.3,4.3}) do
        modelPart(car,"Phare électrique",Vector3.new(1.5,1.0,0.2),CFrame.new(x,4,-11.95),ROOF,Enum.Material.Neon,false)
    end
    for slot=1,CAPACITY do
        local x=if slot%2==1 then -3.05 else 3.05
        local z=-7.3+math.floor((slot-1)/2)*4.7
        modelPart(car,"Banquette "..slot,Vector3.new(3.3,0.8,2.7),CFrame.new(x,3,z),color,Enum.Material.Fabric,false)
        modelPart(car,"Dossier "..slot,Vector3.new(3.3,1.8,0.4),CFrame.new(x,3.9,z+1.2),BASS,Enum.Material.Metal,false)
    end
    return car
end
local function station(root,route,atStart)
    local name=if atStart then "Entrée" else "Quartier"
    local position=v(if atStart then route.start_studs else route.finish_studs,0)
    local direction=(v(route.finish_studs,0)-v(route.start_studs,0)).Unit
    if not atStart then direction=-direction end
    local cf=CFrame.lookAt(position,position+direction)
    local m=Instance.new("Model")
    m.Name="Station "..name.." — "..route.title
    m.Parent=root
    m:SetAttribute("KinBusStationId",route.id.."/"..(if atStart then "out" else "back"))
    modelPart(m,"Quai de la navette",Vector3.new(17,0.4,17),cf*CFrame.new(0,0.2,0),ROOF,Enum.Material.Cobblestone)
    for _,x in ipairs({-7.5,7.5}) do
        modelPart(m,"Pilier de l'abri",Vector3.new(0.6,8,0.6),cf*CFrame.new(x,4,-5),BASS,Enum.Material.Metal)
    end
    modelPart(m,"Auvent de station",Vector3.new(17,0.65,9),cf*CFrame.new(0,8.0,-4.8),ROOF,Enum.Material.Slate,false)
    local banner=modelPart(m,"Étiquette du trajet",Vector3.new(11,2.6,0.4),cf*CFrame.new(0,6.1,-7),BASS,Enum.Material.Metal,false)
    local s=Instance.new("SurfaceGui")
    s.Face=Enum.NormalId.Front;s.PixelsPerStud=32;s.CanvasSize=Vector2.new(750,180);s.Parent=banner
    local label=Instance.new("TextLabel")
    label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
    label.Font=Enum.Font.GothamBold;label.TextScaled=true;label.TextWrapped=true
    label.TextColor3=ROOF
    label.Text=if atStart then "NAVETTE VERS LE QUARTIER" else "NAVETTE VERS LE CENTRE"
    label.Parent=s
    local pole=modelPart(m,"Borne de transport",Vector3.new(3.4,3.8,1.7),cf*CFrame.new(0,2.2,3.3),BASS,Enum.Material.Metal)
    pole:SetAttribute("KinBusRoute",route.id)
    pole:SetAttribute("KinBusDirection",if atStart then "out" else "back")
    F.prompt(pole,"Monter · 8 places",route.title)
    for _,x in ipairs({-5,5}) do
        modelPart(m,"Assise de l'abri",Vector3.new(3.8,0.8,2.4),cf*CFrame.new(x,1.8,-2.3),Color3.fromRGB(145,109,77),Enum.Material.WoodPlanks)
    end
    return m
end
function Buses.build(city)
    local root=F.folder(city,"Navettes électriques — six boulevards")
    for _,route in ipairs(Routes) do
        station(root,route,true)
        station(root,route,false)
        -- Les trajets suivent les boulevards bâtis en v10 : repérage au sol.
        local start=v(route.start_studs,0.20)
        local finish=v(route.finish_studs,0.20)
        local middle=(start+finish)/2
        local base=CFrame.lookAt(middle,finish)
        modelPart(root,"Voie des minibus "..route.id,Vector3.new(14.5,0.22,(finish-start).Magnitude),base,Color3.fromRGB(114,123,116),Enum.Material.Concrete)
        for _,side in ipairs({-1,1}) do
            modelPart(root,"Bande de voie "..route.id,Vector3.new(0.5,0.15,(finish-start).Magnitude),base*CFrame.new(side*6.75,0.2,0),Color3.fromRGB(235,196,115),Enum.Material.Neon,false)
        end
    end
    root:SetAttribute("KinBusLines",#Routes)
    root:SetAttribute("KinBusMaxPassengers",CAPACITY)
    return root
end
local function send(reply,player,record)
    if player.Parent~=Players then return end
    reply:FireClient(player,record)
end
local function groupSize(trip)
    local count=0
    for player,record in pairs(trip.members) do
        if occupied[player]==record then count+=1 end
    end
    return count
end
local function notify(reply,trip,state,time)
    local count=groupSize(trip)
    for player,record in pairs(trip.members) do
        if occupied[player]==record then
            send(reply,player,{kind="boulevard.bus.v11",trip_id=trip.id,state=state,
                destination=trip.destination,count=count,capacity=CAPACITY,duration=time or 0})
        end
    end
end
local function release(player,record,target)
    if occupied[player]~=record then return end
    occupied[player]=nil
    TravelSession.finish(player,record.travelToken)
    record.trip.members[player]=nil
    player:SetAttribute("KinBusActive",false)
    local char=record.character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root and root.Parent then root.Anchored=false end
    if hum and hum.Parent then
        hum.WalkSpeed=record.walk
        hum.JumpPower=record.jumpPower
        hum.JumpHeight=record.jumpHeight
        hum.AutoRotate=record.rotate
    end
    if target and char and char.Parent and player.Character==char then char:PivotTo(CFrame.new(target)) end
end
local function stopTrip(trip)
    if trip.closed then return end
    trip.closed=true
    if queues[trip.key]==trip then queues[trip.key]=nil end
    activeTrips[trip]=nil
    for player,record in pairs(trip.members) do
        if trip.reply and player.Parent==Players then
            send(trip.reply,player,{kind="boulevard.bus.v11",trip_id=trip.id,state="cancel",duration=0})
        end
        release(player,record,trip.start+Vector3.new((record.slot-4)*1.8,4,0))
    end
    if trip.model and trip.model.Parent then trip.model:Destroy() end
end
local function slotOffset(slot)
    return Vector3.new(if slot%2==1 then -3.05 else 3.05,4.8,-7.3+math.floor((slot-1)/2)*4.7)
end
local function positionTrip(trip,cf)
    trip.model:PivotTo(cf)
    for player,record in pairs(trip.members) do
        local char=record.character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if occupied[player]~=record or player.Parent~=Players or not char or not char.Parent or player.Character~=char or not hum or hum.Health<=0 then
            release(player,record,nil)
        else
            char:PivotTo(cf*CFrame.new(slotOffset(record.slot)))
        end
    end
end
local function travel(reply,trip)
    if trip.closed then return end
    trip.state="moving"
    if queues[trip.key]==trip then queues[trip.key]=nil end
    if groupSize(trip)==0 then stopTrip(trip);return end
    local direction=(trip.finish-trip.start).Unit
    local duration=(trip.finish-trip.start).Magnitude/SPEED
    notify(reply,trip,"depart",duration)
    local started=os.clock()
    local ok,err=pcall(function()
        while not trip.closed and trip.world.Parent and groupSize(trip)>0 do
            local t=math.clamp((os.clock()-started)/duration,0,1)
            local eased=t*t*(3-2*t)
            local p=trip.start:Lerp(trip.finish,eased)
            positionTrip(trip,CFrame.lookAt(p,p+direction))
            if t>=1 then break end
            task.wait(0.07)
        end
    end)
    if not ok then warn("Kin City navette de boulevard",err) end
    if ok and not trip.closed and trip.world.Parent and groupSize(trip)>0 then
        notify(reply,trip,"arrive",0)
        local sideways=Vector3.new(-direction.Z,0,direction.X)
        for player,record in pairs(trip.members) do
            release(player,record,trip.finish+sideways*((record.slot-4.5)*2.1)+Vector3.new(0,4,0))
        end
    end
    stopTrip(trip)
end
local function boarding(reply,trip)
    while not trip.closed and trip.world.Parent and groupSize(trip)>0 and groupSize(trip)<CAPACITY and os.clock()<trip.deadline do
        notify(reply,trip,"boarding",math.max(0,trip.deadline-os.clock()))
        task.wait(0.7)
    end
    if trip.closed then return end
    if groupSize(trip)==0 then stopTrip(trip);return end
    travel(reply,trip)
end
local function join(reply,trip,player)
    if occupied[player] or trip.closed or trip.state~="boarding" then return end
    if player:GetAttribute("KinFerryActive") or player:GetAttribute("KinBusActive") then return end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or hum.Health<=0 or not root or root.Anchored or hum.SeatPart then return end
    local filled={}
    for _,record in pairs(trip.members) do filled[record.slot]=true end
    local slot=nil
    for i=1,CAPACITY do if not filled[i] then slot=i;break end end
    if not slot then return end
    local token=TravelSession.begin(player,"bus")
    if not token then return end
    local record={trip=trip,slot=slot,character=char,travelToken=token,walk=hum.WalkSpeed,
        jumpPower=hum.JumpPower,jumpHeight=hum.JumpHeight,rotate=hum.AutoRotate}
    occupied[player]=record
    trip.members[player]=record
    player:SetAttribute("KinBusActive",true)
    root.Anchored=true
    hum.WalkSpeed=0;hum.JumpPower=0;hum.JumpHeight=0;hum.AutoRotate=false
    local direction=(trip.finish-trip.start).Unit
    positionTrip(trip,CFrame.lookAt(trip.start,trip.start+direction))
    notify(reply,trip,"boarding",math.max(0,trip.deadline-os.clock()))
end
local function board(world,reply,player,route,direction)
    if occupied[player] then return end
    local key=route.id.."/"..direction
    local trip=queues[key]
    if not trip or trip.closed or trip.state~="boarding" or groupSize(trip)>=CAPACITY then
        sequence+=1
        local start=v(if direction=="out" then route.start_studs else route.finish_studs,2.2)
        local finish=v(if direction=="out" then route.finish_studs else route.start_studs,2.2)
        local vehicles=world:FindFirstChild("Navettes actives")
        if not vehicles then vehicles=F.folder(world,"Navettes actives") end
        trip={id=tostring(sequence),key=key,world=world,reply=reply,start=start,finish=finish,route=route,
            destination=if direction=="out" then route.station_names[2] else route.station_names[1],
            state="boarding",deadline=os.clock()+BOARD_SECONDS,closed=false,members={},
            model=makeBus(vehicles,sequence,route)}
        queues[key]=trip
        activeTrips[trip]=true
        trip.model:PivotTo(CFrame.lookAt(start,finish))
        task.defer(boarding,reply,trip)
    end
    join(reply,trip,player)
end
function Buses.start(world,reply)
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinBusRoute")
        local direction=host:GetAttribute("KinBusDirection")
        if type(id)~="string" or (direction~="out" and direction~="back") then return end
        if not RateLimiter.allowed(player,"bus/"..id,0.9) then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        local route=routesById[id]
        if route then board(world,reply,player,route,direction) end
    end)
    Players.PlayerRemoving:Connect(function(player)
        local rec=occupied[player]
        if rec then release(player,rec,nil) end
    end)
    world.Destroying:Connect(function()
        for trip in pairs(activeTrips) do stopTrip(trip) end
    end)
end
return Buses

]])
source(server,"CanonicalInteractions","ModuleScript",[[
--!strict
-- Liaison canonique : le prompt est attaché à l'objet physique existant.
-- Utilisée après génération complète et après régénération de chaque intérieur.
local Factory=require(script.Parent.Factory)
local Binder={}

function Binder.bindPlace(interior, placeKey, interactions, records)
    assert(interior and interior:IsA("Model"),"Intérieur physique manquant: "..tostring(placeKey))
    local byAnchor={}
    for _,model in ipairs(interior:GetDescendants()) do
        if model:IsA("Model") and model:GetAttribute("KinFurnishingId")
            and model:GetAttribute("KinPlaceKey")==placeKey then
            local anchor=model:GetAttribute("KinAnchorId")
            if anchor and model.PrimaryPart then
                assert(not byAnchor[anchor],"Mobilier d'ancre en double: "..placeKey.."/"..anchor)
                byAnchor[anchor]=model.PrimaryPart
            end
        end
    end
    local count=0
    for _,interaction in ipairs(interactions) do
        if interaction.place_key==placeKey then
            local prop=byAnchor[interaction.anchor_id]
            assert(prop,"Mobilier interactif introuvable: "..interaction.interaction_id)
            prop:SetAttribute("KinInteractionId",interaction.interaction_id)
            prop:SetAttribute("KinCapabilityId",interaction.capability_id)
            prop:SetAttribute("KinAnchorId",interaction.anchor_id)
            local prompt=prop:FindFirstChild("KinCityPrompt")
            if not prompt or not prompt:IsA("ProximityPrompt") then
                prompt=Factory.prompt(prop,"Consulter","Kin City")
            end
            if records then records[prompt]={kind="interaction",data=interaction} end
            count+=1
        end
    end
    return count
end
return Binder

]])
source(server,"CitizenPropsV21","ModuleScript",[[
--!strict
-- Objets narratifs légers, soudés au rig natif R15 : aucune texture / API externe.
-- Ils n'affectent ni la navigation ni les collisions des habitants.
local Props={}
local teal=Color3.fromRGB(30,104,100)
local opal=Color3.fromRGB(197,244,240)
local gold=Color3.fromRGB(229,215,175)

local function accessory(parent:Model,hand:BasePart,label:string,size:Vector3,offset:CFrame,color:Color3,material:Enum.Material)
    local p=Instance.new("Part")
    p.Name=label
    p.Size=size
    p.CFrame=hand.CFrame*offset
    p.Anchored=false
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.Massless=true
    p.CastShadow=false
    p.Material=material
    p.Color=color
    p.Parent=parent
    local weld=Instance.new("WeldConstraint")
    weld.Part0=hand
    weld.Part1=p
    weld.Parent=p
    return p
end

function Props.attach(model:Model,role:string,index:number)
    local hand=model:FindFirstChild("RightHand")
    if not hand or not hand:IsA("BasePart") then return end
    -- Mini livre, carnet, outil ou prisme selon le métier.
    local kind=index%4
    if string.find(role,"Biblioth") or string.find(role,"Archiv") or kind==0 then
        accessory(model,hand,"Livre de voyage",Vector3.new(0.65,0.82,0.16),CFrame.new(0,-0.38,-0.28)*CFrame.Angles(0.22,0,0),teal,Enum.Material.SmoothPlastic)
        accessory(model,hand,"Tranche opaline",Vector3.new(0.53,0.72,0.05),CFrame.new(0,-0.38,-0.39)*CFrame.Angles(0.22,0,0),opal,Enum.Material.SmoothPlastic)
    elseif string.find(role,"Jardin") or kind==1 then
        accessory(model,hand,"Outil botanique",Vector3.new(0.13,1.05,0.13),CFrame.new(0,-0.45,-0.15),gold,Enum.Material.Metal)
    elseif string.find(role,"Guide") or kind==2 then
        accessory(model,hand,"Carnet sarcelle",Vector3.new(0.54,0.75,0.12),CFrame.new(0,-0.36,-0.2),teal,Enum.Material.SmoothPlastic)
    else
        local prism=accessory(model,hand,"Prisme de recherche",Vector3.new(0.43,0.65,0.43),CFrame.new(0,-0.42,-0.2),opal,Enum.Material.SmoothPlastic)
        prism.Shape=Enum.PartType.Ball
    end
end
return Props

]])
source(server,"Citizens","ModuleScript",[[
--!strict
-- Citoyens procéduraux : coiffures, teintes, vêtements, marche articulée et interactions.
-- Aucun avatar externe, aucune identité kOA et aucun ID asset obligatoire.
local TweenService=game:GetService("TweenService")
local F=require(script.Parent.Factory)
local Presence=require(script.Parent.ViewerPresenceV21)
local Citizens={}
local outfits={
    {"Bibliothécaire","Savoirs"},{"Guide du savoir","Accueil"},{"Étudiante","Université"},
    {"Chercheur","Innovation"},{"Artisane","Création"},{"Médiateur","Éthique"},
    {"Curatrice","Musée"},{"Citoyen","Place publique"},{"Architecte","Urbanisme"},
    {"Conseillère","Hôtel de ville"},{"Historien","Archives"},{"Technicienne","Orgo"},
}
local tones={Color3.fromRGB(239,196,155),Color3.fromRGB(194,137,97),Color3.fromRGB(105,69,55),Color3.fromRGB(158,106,77),Color3.fromRGB(224,173,136),Color3.fromRGB(85,56,49)}
local coats={Color3.fromRGB(53,127,130),Color3.fromRGB(115,82,142),Color3.fromRGB(173,99,72),Color3.fromRGB(76,132,103),Color3.fromRGB(182,140,75),Color3.fromRGB(69,104,153),Color3.fromRGB(175,105,116)}
local hairs={Color3.fromRGB(56,44,39),Color3.fromRGB(149,108,66),Color3.fromRGB(203,164,108),Color3.fromRGB(81,63,56),Color3.fromRGB(42,42,57)}
local dark=Color3.fromRGB(43,58,75)
local function makeCitizen(parent,index)
    local named=outfits[(index-1)%#outfits+1]
    local name=string.format("%s %02d",named[1],index)
    local model=Instance.new("Model")
    model.Name=name
    model:SetAttribute("KinCitizen",true)
    model:SetAttribute("CitizenIndex",index)
    model.Parent=parent
    local skin=tones[(index*7-1)%#tones+1]
    local coat=coats[(index*5-1)%#coats+1]
    local hair=hairs[(index*3-1)%#hairs+1]
    local root=F.part(model,"Root",Vector3.new(0.7,0.7,0.7),CFrame.new(),Color3.new(1,1,1))
    root.Transparency=1;root.CanCollide=false;root.CanTouch=false
    model.PrimaryPart=root
    local function make(name,size,offset,color,mat)
        local p=F.part(model,name,size,CFrame.new(offset),color,mat or Enum.Material.SmoothPlastic)
        p.CanCollide=false;p.CanTouch=false
        return p
    end
    make("Chemise",Vector3.new(2.35,2.9,1.3),Vector3.new(0,3.4,0),coat)
    make("Col",Vector3.new(1,0.5,1.4),Vector3.new(0,4.9,0),Color3.fromRGB(233,229,211))
    make("Cou",Vector3.new(0.75,0.5,0.72),Vector3.new(0,5.25,0),skin)
    local head=make("Visage",Vector3.new(1.65,1.85,1.56),Vector3.new(0,6.1,0),skin)
    head.Shape=Enum.PartType.Ball
    for _,s in ipairs({-1,1}) do
        local eye=make("Oeil",Vector3.new(0.19,0.16,0.09),Vector3.new(s*0.34,6.23,-0.77),dark)
        eye.Shape=Enum.PartType.Ball
    end
    if index%4==0 then
        make("Chapeau",Vector3.new(2.1,0.35,2.1),Vector3.new(0,7.18,0),hair)
        make("Calotte",Vector3.new(1.55,0.7,1.5),Vector3.new(0,7.6,0),hair)
    elseif index%3==0 then
        local cap=make("Coiffure longue",Vector3.new(1.8,1.2,1.6),Vector3.new(0,6.78,0.18),hair)
        cap.CanCollide=false
    else
        make("Coiffure",Vector3.new(1.75,0.65,1.63),Vector3.new(0,6.96,0),hair)
    end
    local arms={}
    local legs={}
    for _,s in ipairs({-1,1}) do
        local a=make(s<0 and "Bras gauche" or "Bras droit",Vector3.new(0.72,2.5,0.85),Vector3.new(s*1.58,3.43,0),skin)
        table.insert(arms,a)
        local b=make(s<0 and "Jambe gauche" or "Jambe droite",Vector3.new(0.95,2.5,1),Vector3.new(s*0.6,1.2,0),dark)
        table.insert(legs,b)
        make("Chaussure",Vector3.new(0.96,0.45,1.3),Vector3.new(s*0.6,0.25,-0.15),Color3.fromRGB(50,50,52))
    end
    if index%5==1 then
        make("Sac",Vector3.new(2.1,2,0.8),Vector3.new(0,3.1,1),Color3.fromRGB(123,84,62))
    elseif index%5==3 then
        make("Badge",Vector3.new(0.55,0.65,0.12),Vector3.new(-0.65,4,-0.75),Color3.fromRGB(246,204,116))
    end
    local marker=Instance.new("BillboardGui")
    marker.Name="Nom"
    marker.Size=UDim2.fromOffset(170,40)
    marker.StudsOffset=Vector3.new(0,2.0,0)
    marker.MaxDistance=70
    marker.AlwaysOnTop=false
    marker.Adornee=head
    marker.Parent=head
    local txt=Instance.new("TextLabel")
    txt.Size=UDim2.fromScale(1,1)
    txt.BackgroundColor3=Color3.fromRGB(26,48,56)
    txt.BackgroundTransparency=0.23
    txt.TextColor3=Color3.fromRGB(249,248,233)
    txt.TextSize=13
    txt.Font=Enum.Font.GothamMedium
    txt.Text=name
    txt.Parent=marker
    local rounded=Instance.new("UICorner");rounded.CornerRadius=UDim.new(0,9);rounded.Parent=txt
    head:SetAttribute("KinStubInteractionId",string.format("citizen.%03d.dialogue",index))
    head:SetAttribute("KinStubCapabilityId","future.citizen.dialogue")
    head:SetAttribute("KinStubTitle",named[1].." — "..named[2])
    F.prompt(head,"Parler",named[1])
    return model,arms,legs
end
local function orbit(index)
    -- Anneaux publics dégagés : les personnages ne traversent pas les façades.
    local radii={34,46,58,70}
    local r=radii[(index-1)%#radii+1]
    local angle=index*2.399963
    return r,angle
end
function Citizens.make(parent)
    local folder=F.folder(parent,"Citoyens")
    for i=1,36 do
        local model=makeCitizen(folder,i)
        local r,theta=orbit(i)
        model:PivotTo(CFrame.new(r*math.cos(theta),0.15,r*math.sin(theta)))
    end
    return folder
end
function Citizens.start(world)
    local city=world:FindFirstChild("Ville")
    local folder=city and city:FindFirstChild("Citoyens")
    if not folder then return end
    for _,m in ipairs(folder:GetChildren()) do
        local index=m:GetAttribute("CitizenIndex")
        if index and m:IsA("Model") then
            task.spawn(function()
                local radius,angle=orbit(index)
                local root=m.PrimaryPart
                local current=0
                local arms={m:FindFirstChild("Bras gauche"),m:FindFirstChild("Bras droit")}
                local legs={m:FindFirstChild("Jambe gauche"),m:FindFirstChild("Jambe droite")}
                while root and root.Parent and world.Parent do
                    if not Presence.near(m:GetPivot().Position,200) then
                        task.wait(3)
                        continue
                    end
                    local nextAngle=angle+0.28
                    local speed=7.2+(index%5)*0.65
                    local destination=CFrame.new(radius*math.cos(nextAngle),0.15,radius*math.sin(nextAngle))*CFrame.Angles(0,-nextAngle+math.pi/2,0)
                    local proxy=Instance.new("CFrameValue")
                    proxy.Value=m:GetPivot()
                    local last=0
                    local conn=proxy.Changed:Connect(function(cf)
                        if not m.Parent then return end
                        local now=os.clock()
                        if now-last<0.085 then return end
                        last=now
                        current+=0.37
                        m:PivotTo(cf)
                        local wave=math.sin(current)
                        for j,arm in ipairs(arms) do
                            if arm then arm.CFrame=cf*CFrame.new((j==1 and -1 or 1)*1.58,3.43,0)*CFrame.Angles(wave*(j==1 and 0.27 or -0.27),0,0) end
                        end
                        for j,leg in ipairs(legs) do
                            if leg then leg.CFrame=cf*CFrame.new((j==1 and -1 or 1)*0.6,1.2,0)*CFrame.Angles(wave*(j==1 and -0.22 or 0.22),0,0) end
                        end
                    end)
                    local tween=TweenService:Create(proxy,TweenInfo.new(speed,Enum.EasingStyle.Linear),{Value=destination})
                    tween:Play();tween.Completed:Wait()
                    conn:Disconnect()
                    if m.Parent then m:PivotTo(destination) end
                    proxy:Destroy()
                    angle=nextAngle
                    task.wait(index%3==0 and 0.8 or 0.1)
                end
            end)
        end
    end
end
return Citizens

]])
source(server,"CityGenerator","ModuleScript",[[
--!strict
local Factory=require(script.Parent.Factory)
local FacadeGenerator=require(script.Parent.FacadeGenerator)
local UrbanDetails=require(script.Parent.UrbanDetails)
local Citizens=require(script.Parent.Citizens)
local DistrictLandmarks=require(script.Parent.DistrictLandmarks)
local Wildlife=require(script.Parent.Wildlife)
local PromenadeLife=require(script.Parent.PromenadeLife)
local OutdoorAtmosphere=require(script.Parent.OutdoorAtmosphere)
local InstitutionForecourts=require(script.Parent.InstitutionForecourts)
local ScenicCoast=require(script.Parent.ScenicCoast)
local PedestrianWayfinding=require(script.Parent.PedestrianWayfinding)
local WaterfrontDistrict=require(script.Parent.WaterfrontDistrict)
local ArtisanStreets=require(script.Parent.ArtisanStreets)
local InteractiveGardens=require(script.Parent.InteractiveGardens)
local LearningConservatories=require(script.Parent.LearningConservatories)
local DiscoveryPromenade=require(script.Parent.DiscoveryPromenade)
local OuterIslands=require(script.Parent.OuterIslands)
local MarinaDistrict=require(script.Parent.MarinaDistrict)
local IslandAnnexes=require(script.Parent.IslandAnnexes)
local IslandFootpaths=require(script.Parent.IslandFootpaths)
local ResidentialQuarters=require(script.Parent.ResidentialQuarters)
local CommunityBuildings=require(script.Parent.CommunityBuildings)
local IntermodalHub=require(script.Parent.IntermodalHub)
local CivicStages=require(script.Parent.CivicStages)
local PromenadeCommerce=require(script.Parent.PromenadeCommerce)
local SecondaryStreets=require(script.Parent.SecondaryStreets)
local CooperativeInstallations=require(script.Parent.CooperativeInstallations)
local StationArcades=require(script.Parent.StationArcades)
local PublicWorkshops=require(script.Parent.PublicWorkshops)
local CrystalPublic=require(script.Parent.CrystalPublic)
local OpalWayfindingV19=require(script.Parent.OpalWayfindingV19)
local BotanicalKitV20=require(script.Parent.BotanicalKitV20)
local CrystalRestStopsV22=require(script.Parent.CrystalRestStopsV22)
local CrystalLandingsV24=require(script.Parent.CrystalLandingsV24)
local CityGenerator={}

local function nearestBuildings(x,z,structures)
    for _,b in ipairs(structures) do
        local cx,_,cz=table.unpack(b.center_studs)
        local yaw=math.rad(b.yaw_degrees)
        local dx=x-cx
        local dz=z-cz
        local localX=math.cos(yaw)*dx-math.sin(yaw)*dz
        local localZ=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(localX)<b.footprint_studs[1]/2+14 and math.abs(localZ)<b.footprint_studs[2]/2+14 then return true end
    end
    return false
end

local function distanceToPath(x,z,path)
    local p=Vector3.new(x,0,z)
    local nearest=math.huge
    for i=2,#path.path_xyz_studs do
        local a=path.path_xyz_studs[i-1]
        local b=path.path_xyz_studs[i]
        local av=Vector3.new(a[1],0,a[3])
        local bv=Vector3.new(b[1],0,b[3])
        local segment=bv-av
        if segment.Magnitude>0.1 then
            local t=math.clamp((p-av):Dot(segment)/segment:Dot(segment),0,1)
            nearest=math.min(nearest,(p-(av+segment*t)).Magnitude)
        end
    end
    return nearest
end
local function tree(parent,x,z,seed)
    return BotanicalKitV20.tree(parent,x,z,seed)
end

local function pavement(parent,name,a,b,width,color)
    local vector=b-a
    local length=Vector3.new(vector.X,0,vector.Z).Magnitude
    if length<0.5 then return end
    local midpoint=(a+b)/2
    Factory.part(parent,name,Vector3.new(width,0.24,length),CFrame.lookAt(Vector3.new(midpoint.X,0.09,midpoint.Z),Vector3.new(b.X,0.09,b.Z)),color,Enum.Material.Cobblestone)
end

function CityGenerator.make(parent,plan,buildingsById)
    local city=Factory.folder(parent,"Ville")
    local disk=Factory.part(city,"Île circulaire",Vector3.new(2,990,990),CFrame.new(0,-1,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(84,141,107),Enum.Material.Grass)
    disk.Shape=Enum.PartType.Cylinder
    local water=Factory.part(city,"Lac périphérique",Vector3.new(1,1800,1800),CFrame.new(0,-3.8,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(47,125,163),Enum.Material.SmoothPlastic)
    water.Shape=Enum.PartType.Cylinder
    local plaza=Factory.part(city,"Place centrale",Vector3.new(2,110,110),CFrame.new(0,0,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(198,220,211),Enum.Material.Cobblestone)
    plaza.Shape=Enum.PartType.Cylinder
    plaza.CanCollide=false
    local roads=Factory.folder(city,"Sentiers piétons")
    for _,path in ipairs(plan.pedestrian_paths) do
        for i=2,#path.path_xyz_studs do
            local p=path.path_xyz_studs[i-1]
            local q=path.path_xyz_studs[i]
            pavement(roads,path.building_id,Vector3.new(p[1],0,p[3]),Vector3.new(q[1],0,q[3]),path.width_studs,Color3.fromRGB(211,200,175))
        end
    end
    local facades=Factory.folder(city,"Bâtiments")
    for _,b in ipairs(plan.structures) do
        local building=buildingsById[b.building_id]
        assert(building,"Missing building: "..b.building_id)
        FacadeGenerator.make(facades,b,building,plan.styles[b.style_id])
    end
    local gardens=Factory.folder(city,"Nature")
    local rng=Random.new(plan.seed)
    local planted=0
    for i=1,185 do
        local angle=rng:NextNumber(0,2*math.pi)
        local radius=rng:NextNumber(90,465)
        local x,z=math.cos(angle)*radius,math.sin(angle)*radius
        if not nearestBuildings(x,z,plan.structures) and not InstitutionForecourts.isReserved(x,z,plan.structures) and not LearningConservatories.isReserved(x,z) and not DiscoveryPromenade.isReserved(x,z) and not ResidentialQuarters.isReserved(x,z) and not CommunityBuildings.isReserved(x,z) and not IntermodalHub.isReserved(x,z) and not CivicStages.isReserved(x,z) and not PromenadeCommerce.isReserved(x,z) and not CooperativeInstallations.isReserved(x,z) and not SecondaryStreets.isReserved(x,z) and not StationArcades.isReserved(x,z) and not PublicWorkshops.isReserved(x,z) then
            local blockedPath=false
            for _,path in ipairs(plan.pedestrian_paths) do
                if distanceToPath(x,z,path)<path.width_studs/2+7 then
                    blockedPath=true
                    break
                end
            end
            if not blockedPath then
                tree(gardens,x,z,i);planted+=1
            end
        end
    end
    local monument=Factory.part(city,"Monument du savoir",Vector3.new(5,19,5),CFrame.new(0,9.5,39),Color3.fromRGB(30,104,100),Enum.Material.Marble)
    Factory.sign(city,"Bienvenue",Vector3.new(0,7,17),0,"KIN CITY",28,5)
    local spawn=Instance.new("SpawnLocation")
    spawn.Name="Arrivée Kin City"
    spawn.Size=Vector3.new(12,1,12)
    spawn.CFrame=CFrame.new(0,0.8,0)
    spawn.Anchored=true
    spawn.Neutral=true
    spawn.CanCollide=true
    spawn.Transparency=0.25
    spawn.Parent=city
    UrbanDetails.make(city,plan)
    InstitutionForecourts.make(city,plan)
    CrystalLandingsV24.make(city,plan)
    ScenicCoast.make(city)
    WaterfrontDistrict.make(city)
    OuterIslands.make(city)
    MarinaDistrict.make(city)
    IslandAnnexes.make(city)
    IslandFootpaths.make(city)
    ResidentialQuarters.make(city)
    CommunityBuildings.make(city)
    IntermodalHub.make(city)
    StationArcades.make(city)
    PublicWorkshops.make(city)
    CivicStages.make(city)
    CooperativeInstallations.make(city)
    PromenadeCommerce.make(city)
    SecondaryStreets.make(city)
    ArtisanStreets.make(city,plan)
    InteractiveGardens.make(city,plan)
    LearningConservatories.make(city)
    DiscoveryPromenade.make(city)
    PedestrianWayfinding.make(city,plan,buildingsById)
    DistrictLandmarks.make(city,plan)
    PromenadeLife.make(city,plan)
    OutdoorAtmosphere.make(city)
    Citizens.make(city)
    Wildlife.make(city)
    CrystalPublic.make(city)
    OpalWayfindingV19.make(city,plan)
    CrystalRestStopsV22.make(city,plan)
    return city
end
return CityGenerator

]])
source(server,"CivicStageRuntime","ModuleScript",[[
--!strict
-- Actions locales serveur pour les six places. Aucun point, vote ou service kOA.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
function Runtime.start(world,reply)
    local lamps={}
    local art={}
    local enabled={}
    local running={}
    for _,child in ipairs(world:GetDescendants()) do
        if child:IsA("BasePart") then
            local id=child:GetAttribute("KinCivicLamp")
            if type(id)=="string" then
                lamps[id]=lamps[id] or {}
                table.insert(lamps[id],child)
            end
        elseif child:IsA("Model") then
            local id=child:GetAttribute("KinCivicArt")
            if type(id)=="string" then art[id]=child end
        end
    end
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local kind=host:GetAttribute("KinCivicAction")
        local id=host:GetAttribute("KinCivicStageId")
        if (kind~="lights" and kind~="mobile") or type(id)~="string" then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp or (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"civic/"..id.."/"..kind,0.7) then return end
        local text=""
        if kind=="lights" then
            local on=enabled[id]==false
            enabled[id]=on
            for _,lamp in ipairs(lamps[id] or {}) do
                if lamp.Parent then
                    local light=lamp:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=on end
                    lamp.Transparency=if on then 0 else 0.72
                end
            end
            text=if on then "L'agora s'illumine." else "Les lumières de l'agora sont éteintes."
        else
            local model=art[id]
            if not model or not model.Parent or running[id] then return end
            running[id]=true
            local start=model:GetPivot()
            task.spawn(function()
                local ok,reason=pcall(function()
                    local begin=os.clock()
                    while model.Parent and world.Parent do
                        local t=math.clamp((os.clock()-begin)/2.1,0,1)
                        local eased=t*t*(3-2*t)
                        model:PivotTo(start*CFrame.Angles(0,eased*2*math.pi,0))
                        if t>=1 then break end
                        RunService.Heartbeat:Wait()
                    end
                end)
                if not ok then warn("Kin City sculpture de quartier",reason) end
                running[id]=nil
            end)
            text="Le mobile de la place s'anime."
        end
        if player.Parent==Players then
            reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",
                title="Agora de quartier",message=text,
                notice="Activité physique locale · aucune opération kOA"})
        end
    end)
end
return Runtime

]])
source(server,"CivicStages","ModuleScript",[[
--!strict
-- Six places de quartier : amphithéâtres, scènes, jeux de jardin, éclairage
-- et mobiles activables. Géométrie native, durable en mode édition.
local RS=game:GetService("ReplicatedStorage")
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("CivicDestinations"))
local F=require(script.Parent.Factory)
local Stages={}
local STONE=Color3.fromRGB(217,211,182)
local DARK=Color3.fromRGB(30,104,100)
local WOOD=Color3.fromRGB(142,108,79)
local GOLD=Color3.fromRGB(223,186,112)
local GREEN=Color3.fromRGB(89,139,99)
local function p(root,label,cf,x,y,z,w,h,d,color,mat,solid)
    local o=F.part(root,label,Vector3.new(w,h,d),cf*CFrame.new(x,y,z),color,mat)
    if solid==false then o.CanCollide=false;o.CanTouch=false;o.CanQuery=false end
    return o
end
local function lighting(root,cf,x,y,z,id,color)
    local bulb=p(root,"Orbe d'ambiance",cf,x,y,z,1.3,1.3,1.3,color,Enum.Material.Neon,false)
    bulb.Shape=Enum.PartType.Ball
    bulb:SetAttribute("KinCivicLamp",id)
    local light=Instance.new("PointLight")
    light.Brightness=1.1;light.Range=20;light.Parent=bulb
end
local function planting(root,cf,x,z,seed)
    p(root,"Bac de plantation",cf,x,1.1,z,5,1.4,3.3,WOOD,Enum.Material.WoodPlanks)
    for n=1,3 do
        local stalk=p(root,"Feuilles publiques",cf,x+(n-2)*1.2,3.4,z,2.5+(seed%2),2.9,2.5,GREEN,Enum.Material.Grass,false)
        stalk.Shape=Enum.PartType.Ball
    end
end
local function bench(root,cf,x,z)
    local s=Instance.new("Seat")
    s.Name="Banc de l'agora";s.Size=Vector3.new(4.5,0.8,2.2)
    s.CFrame=cf*CFrame.new(x,1.8,z);s.Anchored=true;s.Material=Enum.Material.WoodPlanks;s.Color=WOOD;s.Parent=root
    p(root,"Dossier",cf,x,2.7,z+1,4.6,1.7,0.4,DARK,Enum.Material.Wood)
end
local function buildOne(parent,item)
    local m=Instance.new("Model");m.Name=item.title;m.Parent=parent
    m:SetAttribute("KinCivicStageId",item.id)
    local center=Vector3.new(item.center_studs[1],0,item.center_studs[3])
    local cf=CFrame.new(center)*CFrame.Angles(0,item.yaw,0)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    p(m,"Dallage place publique",cf,0,0.05,0,44,0.55,48,STONE,Enum.Material.Cobblestone)
    p(m,"Scène culturelle",cf,0,1.35,13,23,2.4,13,WOOD,Enum.Material.WoodPlanks)
    p(m,"Fond de scène",cf,0,5.7,19,24,8.3,0.7,DARK,Enum.Material.Slate)
    p(m,"Auvent scène",cf,0,11.2,13,26,0.7,16,tint,Enum.Material.Fabric,false)
    for _,side in ipairs({-1,1}) do
        for _,zz in ipairs({7,18}) do
            p(m,"Structure scène",cf,side*12.4,5.7,zz,0.7,10.7,0.7,GOLD,Enum.Material.Metal)
        end
        for n=1,3 do
            bench(m,cf,side*8,-16+(n-1)*5.6)
        end
        planting(m,cf,side*18,if side==1 then 10 else -9,side)
    end
    -- Amphithéâtre bas avec entrée centrale libre et éclairage public.
    for row=1,3 do
        for _,side in ipairs({-1,1}) do
            local zz=2-(row-1)*6
            p(m,"Gradin communautaire",cf,side*11,0.65,zz,15,0.7,3.8,STONE,Enum.Material.Cobblestone)
        end
    end
    for i=1,8 do
        local a=i*math.pi/4
        local x=math.cos(a)*19
        local z=math.sin(a)*20
        lighting(m,cf,x,7.2,z,item.id,tint)
        p(m,"Mât de lumière",cf,x,3.5,z,0.6,6.5,0.6,DARK,Enum.Material.Metal)
    end
    -- Grand mobile identitaire et projection lumineuse visible depuis la promenade.
    local art=Instance.new("Model")
    art.Name="Mobile cinétique — "..item.theme
    art.Parent=m
    art:SetAttribute("KinCivicArt",item.id)
    local pivot=p(art,"Pivot",cf,0,4.3,12,0.3,0.3,0.3,GOLD,Enum.Material.Metal,false)
    pivot.Transparency=1;art.PrimaryPart=pivot
    local rail=p(art,"Anneau lumineux",cf,0,6.3,12,7,0.7,7,tint,Enum.Material.Neon,false)
    rail.Shape=Enum.PartType.Cylinder
    for k=1,5 do
        local a=k*math.pi*2/5
        local x=math.cos(a)*3.0
        local z=12+math.sin(a)*3.0
        local bead=p(art,"Éclat en orbite",cf,x,6.3,z,1.5,1.5,1.5,if k%2==0 then GOLD else tint,Enum.Material.Neon,false)
        bead.Shape=Enum.PartType.Ball
    end
    -- Commandes physiques distinctes pour les deux actions réelles.
    local lampSwitch=p(m,"Console lumières",cf,-14,2.1,-18,2.7,3.8,2.0,DARK,Enum.Material.Metal)
    lampSwitch:SetAttribute("KinCivicAction","lights")
    lampSwitch:SetAttribute("KinCivicStageId",item.id)
    F.prompt(lampSwitch,"Allumer / éteindre",item.activity)
    local mobileSwitch=p(m,"Console sculpture",cf,14,2.1,-18,2.7,3.8,2.0,DARK,Enum.Material.Metal)
    mobileSwitch:SetAttribute("KinCivicAction","mobile")
    mobileSwitch:SetAttribute("KinCivicStageId",item.id)
    F.prompt(mobileSwitch,"Faire tourner",item.activity)
    -- Toute fonction métier future reste explicite et inchangée.
    local future=p(m,"Borne de la communauté",cf,16,2.1,16,2.8,4,2.0,DARK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",item.id..".future")
    future:SetAttribute("KinStubCapabilityId","future.public.engagement")
    future:SetAttribute("KinStubTitle",item.title)
    F.prompt(future,"Consulter","Fonction à venir")
    -- Pancarte orientée dans le repère de l'îlot.
    local sign=F.sign(m,"Nom de l'agora",(cf*CFrame.new(0,6,-24)).Position,math.deg(item.yaw),item.title,29,3.5)
    sign.CanCollide=false
    return m
end
function Stages.isReserved(x,z)
    for _,item in ipairs(Destinations) do
        local dx=x-item.center_studs[1]
        local dz=z-item.center_studs[3]
        if dx*dx+dz*dz<37*37 then return true end
    end
    return false
end
function Stages.make(city)
    local root=F.folder(city,"Agoras et scènes des quartiers")
    for _,item in ipairs(Destinations) do buildOne(root,item) end
    root:SetAttribute("KinCivicStages",#Destinations)
    return root
end
return Stages

]])
source(server,"CommunityActivities","ModuleScript",[[
--!strict
-- Activités réellement locales : éclairages des halles et rotation d'une sculpture.
-- L'achat, l'inscription et les services institutionnels restent des stubs.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Activities={}
function Activities.start(world,reply)
    local states={}
    local arts={}
    -- Index construit une seule fois, plutôt que parcourir toute la ville à chaque E.
    local lamps={}
    local sculptures={}
    for _,desc in ipairs(world:GetDescendants()) do
        if desc:IsA("BasePart") then
            local lightId=desc:GetAttribute("KinCommunityLamp")
            if type(lightId)=="string" then
                lamps[lightId]=lamps[lightId] or {}
                table.insert(lamps[lightId],desc)
            end
        end
    end
    for _,desc in ipairs(world:GetDescendants()) do
        if desc:IsA("Model") then
            local artId=desc:GetAttribute("KinCommunityArt")
            if type(artId)=="string" then sculptures[artId]=desc end
        end
    end
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local action=host:GetAttribute("KinCommunityAction")
        local id=host:GetAttribute("KinCommunityId")
        if type(id)~="string" or (action~="lights" and action~="art") then return end
        if not RateLimiter.allowed(player,"community/"..id,0.75) then return end
        local char=player.Character
        local human=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not human or human.Health<=0 or not hrp or (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        local message=""
        if action=="lights" then
            local enabled=not (states[id]~=false)
            states[id]=enabled
            for _,bulb in ipairs(lamps[id] or {}) do
                if bulb.Parent then
                    local point=bulb:FindFirstChildOfClass("PointLight")
                    if point then point.Enabled=enabled end
                    bulb.Transparency=if enabled then 0 else 0.6
                end
            end
            message=if enabled then "Les luminaires de la halle sont allumés." else "Les luminaires de la halle sont éteints."
        else
            local model=sculptures[id]
            if not model or not model.Parent then return end
            if arts[id] then return end
            arts[id]=true
            local origin=model:GetPivot()
            task.spawn(function()
                local ok,reason=pcall(function()
                    local started=os.clock()
                    while model.Parent and world.Parent do
                        local t=math.clamp((os.clock()-started)/1.8,0,1)
                        local eased=t*t*(3-2*t)
                        model:PivotTo(origin*CFrame.Angles(0,eased*math.pi*2,0))
                        if t>=1 then break end
                        RunService.Heartbeat:Wait()
                    end
                end)
                if not ok then warn("Kin City mobile communautaire",reason) end
                arts[id]=nil
            end)
            message="Le mobile tourne : expérience locale activée."
        end
        if player.Parent==Players then
            reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Espace communautaire",message=message,notice="Interaction physique de Kin City · aucune opération kOA"})
        end
    end)
end
return Activities

]])
source(server,"CommunityBuildings","ModuleScript",[[
--!strict
-- Construction v11 : six marchés couverts et six maisons communautaires.
-- Chaque marché et maison est physiquement accessible, meublé et doté d'une
-- animation locale; aucun achat, dossier, note ou fonction kOA n'est exécuté.
local RS=game:GetService("ReplicatedStorage")
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("CommunityDestinations"))
local F=require(script.Parent.Factory)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local Community={}
local STONE=Color3.fromRGB(232,219,192)
local FRAME=Color3.fromRGB(30,104,100)
local TIMBER=Color3.fromRGB(148,104,71)
local GLASS=Color3.fromRGB(197,244,240)
local GOLD=Color3.fromRGB(224,190,114)

local function block(m,n,cf,x,y,z,w,h,d,color,material,collision)
    local p=F.part(m,n,Vector3.new(w,h,d),cf*CFrame.new(x,y,z),color,material)
    if collision==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function orb(m,n,cf,x,y,z,diam,col)
    local o=block(m,n,cf,x,y,z,diam,diam,diam,col,Enum.Material.Neon,false)
    o.Shape=Enum.PartType.Ball
    return o
end
local function lamp(m,cf,x,y,z,id,color)
    local bulb=orb(m,"Luminaire communautaire",cf,x,y,z,1.2,color)
    bulb:SetAttribute("KinCommunityLamp",id)
    local point=Instance.new("PointLight")
    point.Brightness=1.0;point.Range=19;point.Shadows=false;point.Parent=bulb
    return bulb
end
local function sign(m,cf,at,text,width)
    local p=F.sign(m,"Enseigne publique",(cf*CFrame.new(at)).Position,math.deg(math.atan2(-cf.LookVector.X,-cf.LookVector.Z)),text,width,3)
    p.CanCollide=false
end
local function stub(m,cf,x,y,z,id,title)
    local terminal=block(m,"Terminal futur",cf,x,y,z,2.6,4,1.4,FRAME,Enum.Material.Metal)
    terminal:SetAttribute("KinStubInteractionId",id..".future.terminal")
    terminal:SetAttribute("KinStubCapabilityId","future.community.local")
    terminal:SetAttribute("KinStubTitle",title)
    F.prompt(terminal,"Consulter",title)
    local glass=block(m,"Écran en veille",cf,x,y+0.8,z-0.79,1.9,1.6,0.1,GLASS,Enum.Material.Glass,false)
    OpalGlazingV22.apply(glass,false)
end
local function seat(m,cf,x,y,z,color)
    local s=Instance.new("Seat")
    s.Name="Chaise utilisable";s.Size=Vector3.new(2.4,0.7,2.2)
    s.CFrame=cf*CFrame.new(x,y,z);s.Anchored=true;s.Material=Enum.Material.WoodPlanks;s.Color=color;s.Parent=m
    block(m,"Dossier",cf,x,y+0.9,z+1,2.45,1.75,0.35,FRAME,Enum.Material.Wood)
end
local function kiosk(m,cf,i,id,color)
    local x=if i%2==0 then 12 else -12
    local z=-19+math.floor((i-1)/2)*8.2
    block(m,"Étal du marché "..i,cf,x,1.8,z,8,2.6,5,TIMBER,Enum.Material.WoodPlanks)
    block(m,"Vitrine de l'étal",cf,x,3.38,z-1.1,7.2,0.25,2.6,color,Enum.Material.SmoothPlastic,false)
    for n=1,6 do
        local dx=-2.8+(n-1)*1.12
        local shade=if (n+i)%3==0 then GOLD elseif n%2==0 then color else Color3.fromRGB(122,172,126)
        local item=block(m,"Collection exposée",cf,x+dx,3.8,z-1.1,0.9,0.9,1.15,shade,Enum.Material.SmoothPlastic,false)
        item.Shape=if n%2==0 then Enum.PartType.Ball else Enum.PartType.Block
    end
    for _,side in ipairs({-1,1}) do
        block(m,"Montant du kiosque",cf,x+side*3.5,5.5,z,0.35,5,0.35,FRAME,Enum.Material.Wood)
    end
    block(m,"Auvent textile",cf,x,8.15,z,8.5,0.45,6.4,color,Enum.Material.Fabric,false)
    if i<=2 then
        local target=block(m,"Étiquette de collection",cf,x,5.0,z-3.0,2,2.5,0.8,FRAME,Enum.Material.Metal)
        target:SetAttribute("KinStubInteractionId",id..".stall."..i)
        target:SetAttribute("KinStubCapabilityId","future.community.market")
        target:SetAttribute("KinStubTitle","Collection de l'étal "..i)
        F.prompt(target,"Découvrir","Collection — bientôt")
    end
end
local function commonShell(m,cf,kind,color)
    local isMarket=kind=="market"
    local width=if isMarket then 46 else 38
    local depth=if isMarket then 58 else 43
    local halfX=width/2
    local halfZ=depth/2
    block(m,"Parvis",cf,0,-0.02,-halfZ-8,width+8,0.26,18,STONE,Enum.Material.Cobblestone)
    block(m,"Sol accessible",cf,0,0.15,0,width,0.55,depth,STONE,Enum.Material.Cobblestone)
    for _,side in ipairs({-1,1}) do
        local x=side*halfX
        block(m,"Mur longitudinal",cf,x,6.3,0,0.85,12.4,depth,TIMBER,Enum.Material.Brick)
        for n=1,4 do
            local z=-halfZ+8+(n-1)*13
            local pane=block(m,"Vitrail latéral",cf,x+side*0.5,6,z,0.16,5.5,5.9,GLASS,Enum.Material.Glass,false)
            OpalGlazingV22.apply(pane,false)
            block(m,"Traverse de façade",cf,x+side*0.58,6,z,0.23,0.28,6,GOLD,Enum.Material.Metal,false)
        end
    end
    block(m,"Mur arrière",cf,0,6.3,halfZ,width,12.4,0.85,TIMBER,Enum.Material.Brick)
    -- Panneaux frontaux de part et d'autre d'une ouverture de 9 studs.
    local edgeWidth=(width-9)/2
    for _,side in ipairs({-1,1}) do
        block(m,"Façade principale",cf,side*(4.5+edgeWidth/2),6.3,-halfZ,edgeWidth,12.4,0.8,TIMBER,Enum.Material.Brick)
    end
    block(m,"Linteau de porte",cf,0,11.2,-halfZ,9.3,2.4,0.85,FRAME,Enum.Material.Metal)
    -- Toiture à pans inclinés et claire-voie laissant entrer la lumière.
    for _,side in ipairs({-1,1}) do
        block(m,"Pan de toiture",cf,side*halfX/2,16.2,0,width/2+2,0.85,depth+3,color,Enum.Material.Slate,false)
        for _,z in ipairs({-halfZ+6,0,halfZ-6}) do
            local pane=block(m,"Lanterneau",cf,side*(halfX/2),16.8,z,6,0.22,3.9,GLASS,Enum.Material.Glass,false)
            OpalGlazingV22.apply(pane,true)
        end
    end
    for _,x in ipairs({-halfX+3,halfX-3}) do
        block(m,"Poutre de nef",cf,x,12,0,0.9,21,0.9,FRAME,Enum.Material.Wood)
    end
    -- Entrée et piétonnier libres pour l'avatar.
    block(m,"Seuil de pierre",cf,0,0.2,-halfZ-1,8.5,0.4,3,STONE,Enum.Material.Cobblestone)
    return halfX,halfZ
end
local function createMarket(parent,data,color,cf)
    local m=Instance.new("Model");m.Name=data.title;m.Parent=parent
    m:SetAttribute("KinCommunityId",data.id)
    m:SetAttribute("KinCommunityType","market")
    local _,halfZ=commonShell(m,cf,"market",color)
    -- Douze étals réels laissant un corridor central d'au moins 10 studs.
    for n=1,12 do kiosk(m,cf,n,data.id,color) end
    block(m,"Place de dégustation",cf,0,1.9,19,9,1,8,TIMBER,Enum.Material.WoodPlanks)
    for _,side in ipairs({-1,1}) do seat(m,cf,side*7,1.55,19,color) end
    for n=1,6 do lamp(m,cf,if n%2==0 then 16 else -16,11,-20+n*7,data.id,GOLD) end
    block(m,"Rosace de hall",cf,0,0.55,0,12,0.2,12,color,Enum.Material.Marble,false)
    local switch=block(m,"Commande des éclairages",cf,-18,2,-halfZ+7,2.5,3.4,1.5,FRAME,Enum.Material.Metal)
    switch:SetAttribute("KinCommunityAction","lights")
    switch:SetAttribute("KinCommunityId",data.id)
    F.prompt(switch,"Ambiance","Lumières du marché")
    stub(m,cf,18,2.1,halfZ-6,data.id,data.title)
    sign(m,cf,Vector3.new(0,13,-halfZ-0.6),data.title,30)
    SecondaryArchitectureV25.hall(m,cf,"market",color)
    return m
end
local function specialist(m,cf,data,color)
    local kind=data.special
    for n=1,5 do
        local x=-11+(n-1)*5.5
        if kind=="books" then
            block(m,"Étagère publique",cf,x,3,11,3.7,5,2.0,TIMBER,Enum.Material.Wood)
            for row=1,3 do for book=1,2 do
                block(m,"Volumes de lecture",cf,x-0.8+book*0.6,1.4+row*1.05,9.7,0.8,0.95,1.0,if row%2==0 then color else GOLD,Enum.Material.Fabric,false)
            end end
        elseif kind=="serres" then
            block(m,"Bac botanique",cf,x,1.3,11,3.5,2.2,4.5,TIMBER,Enum.Material.Wood)
            for leaf=1,2 do
                local crown=block(m,"Jardin vivant",cf,x+(leaf-1)*1.1,3.8,11,2.0,2.0,2.0,Color3.fromRGB(100,175,120),Enum.Material.Grass,false)
                crown.Shape=Enum.PartType.Ball
            end
        elseif kind=="arts" then
            block(m,"Chevalet créatif",cf,x,4,11,3.2,5,0.8,FRAME,Enum.Material.Wood,false)
            block(m,"Toile d'exposition",cf,x,4.2,10.5,2.7,4.3,0.25,if n%2==0 then color else GOLD,Enum.Material.Fabric,false)
        elseif kind=="movement" then
            local c=orb(m,"Mobile cinétique",cf,x,4.4,11,2.5,color)
            c:SetAttribute("KinCommunityOrnament",data.id)
        elseif kind=="light" then
            block(m,"Réfracteur de lumière",cf,x,3.6,11,2.7,5,2.1,GLASS,Enum.Material.Glass,false).Transparency=0.24
            lamp(m,cf,x,7.2,11,data.id,color)
        else
            block(m,"Table de collaboration",cf,x,2.3,11,4,1,4,TIMBER,Enum.Material.WoodPlanks)
            seat(m,cf,x,1.5,15,color)
        end
    end
end
local function createCommunity(parent,data,color,cf)
    local m=Instance.new("Model");m.Name=data.title;m.Parent=parent
    m:SetAttribute("KinCommunityId",data.id)
    m:SetAttribute("KinCommunityType","community")
    local _,halfZ=commonShell(m,cf,"community",color)
    -- Mezzanine latérale non traversante, accessible par un vrai escalier.
    block(m,"Mezzanine ouest",cf,-12.7,10.2,1,10.5,0.5,33,STONE,Enum.Material.WoodPlanks)
    block(m,"Mezzanine palier arrière",cf,0,10.2,16,16,0.5,5,STONE,Enum.Material.WoodPlanks)
    for n=1,14 do
        local z=-12+(n-1)*1.62
        block(m,"Escalier de lecture "..n,cf,-9,0.63+n*0.67,z,4.5,0.5,1.7,STONE,Enum.Material.Cobblestone)
    end
    for _,z in ipairs({-13,1,15}) do
        block(m,"Balustrade de galerie",cf,-7,11.1,z,0.35,1.7,8,GOLD,Enum.Material.Metal,false)
    end
    -- Lieu avec un véritable programme physique distinct de l'écran métier futur.
    block(m,"Grande table de quartier",cf,0,1.9,-2.5,10,1,5,TIMBER,Enum.Material.WoodPlanks)
    for _,z in ipairs({-6,1}) do
        for _,x in ipairs({-4,4}) do seat(m,cf,x,1.4,z,color) end
    end
    specialist(m,cf,data,color)
    for n=1,4 do lamp(m,cf,if n%2==0 then 12 else -12,10,-14+n*8,data.id,color) end
    local rotor=Instance.new("Model")
    rotor.Name="Mobile cinétique des rencontres"
    rotor:SetAttribute("KinCommunityArt",data.id)
    rotor.Parent=m
    local pivot=orb(rotor,"Noyau lumineux",cf,0,6,8,3,color)
    rotor.PrimaryPart=pivot
    for arm=1,4 do
        local a=arm*math.pi/2
        local dx,dz=math.cos(a),math.sin(a)
        local wing=block(rotor,"Branche artistique "..arm,cf,dx*2.8,6,8+dz*2.8,0.5,0.55,5.5,GOLD,Enum.Material.Metal,false)
        wing.CFrame=cf*CFrame.new(dx*2.8,6,8+dz*2.8)*CFrame.Angles(0,math.pi/2-a,0)
        orb(rotor,"Prisme mobile",cf,dx*5.3,6,8+dz*5.3,1.8,if arm%2==0 then color else GOLD)
    end
    local handle=block(m,"Commande artistique",cf,13,2,-9,2.6,3.2,1.5,FRAME,Enum.Material.Metal)
    handle:SetAttribute("KinCommunityAction","art")
    handle:SetAttribute("KinCommunityId",data.id)
    F.prompt(handle,"Animer","Sculpture locale")
    stub(m,cf,-15,2,halfZ-4,data.id,data.title)
    sign(m,cf,Vector3.new(0,13,-halfZ-0.6),data.title,30)
    SecondaryArchitectureV25.hall(m,cf,"community",color)
    return m
end

function Community.isReserved(x,z)
    for _,data in ipairs(Destinations) do
        local p=Vector3.new(data.center_studs[1],0,data.center_studs[3])
        if (Vector3.new(x,0,z)-p).Magnitude<40 then return true end
    end
    return false
end
function Community.make(city)
    local root=F.folder(city,"Halles et maisons publiques — douze édifices")
    local markets=0
    local centres=0
    for _,data in ipairs(Destinations) do
        local pos=Vector3.new(data.center_studs[1],0,data.center_studs[3])
        local cf=CFrame.new(pos)*CFrame.Angles(0,data.facing,0)
        local color=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
        if data.kind=="market" then createMarket(root,data,color,cf);markets+=1
        else createCommunity(root,data,color,cf);centres+=1 end
        -- La place communale existante mène directement à chacune des deux entrées.
        local dir=cf.LookVector
        block(root,"Allée de liaison",cf,0,0.1,-33,8,0.22,24,STONE,Enum.Material.Cobblestone)
    end
    root:SetAttribute("KinMarketHalls",markets)
    root:SetAttribute("KinCommunityCentres",centres)
    return root
end
return Community

]])
source(server,"CooperativeInstallations","ModuleScript",[[
--!strict
-- Six installations collaboratives aux abords des agoras v12.
-- Deux joueurs distincts activent une sculpture; aucun point ou vote fictif.
local RS=game:GetService("ReplicatedStorage")
local D=require(RS:WaitForChild("KinCityShared"):WaitForChild("CivicDestinations"))
local F=require(script.Parent.Factory)
local Installations={}
local INK=Color3.fromRGB(47,74,85)
local STONE=Color3.fromRGB(226,209,173)
local GOLD=Color3.fromRGB(232,193,115)
local function p(parent,name,cf,x,y,z,w,h,d,color,material,solid)
    local part=F.part(parent,name,Vector3.new(w,h,d),cf*CFrame.new(x,y,z),color,material)
    if solid==false then part.CanCollide=false;part.CanQuery=false;part.CanTouch=false end
    return part
end
local function makeOne(parent,item)
    local m=Instance.new("Model")
    m.Name="Installation collaborative · "..item.title
    m:SetAttribute("KinCoopId",item.id)
    m.Parent=parent
    local base=CFrame.new(item.center_studs[1],0,item.center_studs[3])*CFrame.Angles(0,item.yaw,0)*CFrame.new(33,0,-3)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    p(m,"Plateforme commune",base,0,0.11,0,16,0.45,18,STONE,Enum.Material.Cobblestone)
    p(m,"Dallage de raccordement",base,-9,0.09,0,11,0.2,5,STONE,Enum.Material.Cobblestone)
    for side=1,2 do
        local x=if side==1 then -5.4 else 5.4
        local console=p(m,"Commande du participant "..side,base,x,1.9,-4,2.5,3.5,2.3,INK,Enum.Material.Metal)
        console:SetAttribute("KinCoopAction","participate")
        console:SetAttribute("KinCoopId",item.id)
        console:SetAttribute("KinCoopSide",side)
        F.prompt(console,"Activer en équipe", "2 personnes requises")
        local lamp=p(m,"Voyant du participant",base,x,4.1,-4,1.3,1.3,1.3,Color3.fromRGB(89,132,145),Enum.Material.Neon,false)
        lamp.Shape=Enum.PartType.Ball
        lamp:SetAttribute("KinCoopIndicator",item.id)
        lamp:SetAttribute("KinCoopSide",side)
    end
    for _,x in ipairs({-6.3,6.3}) do
        p(m,"Arc en alliage",base,x,4.7,2.5,0.65,8.7,0.65,GOLD,Enum.Material.Metal)
    end
    p(m,"Poutre de rencontre",base,0,9.1,2.5,13.2,0.65,0.65,GOLD,Enum.Material.Metal)
    local sculpture=Instance.new("Model")
    sculpture.Name="Cœur collaboratif"
    sculpture.Parent=m
    sculpture:SetAttribute("KinCoopSculpture",item.id)
    local pivot=p(sculpture,"Pivot",base,0,5.4,2.5,0.35,0.35,0.35,GOLD,Enum.Material.Metal,false)
    pivot.Transparency=1
    sculpture.PrimaryPart=pivot
    local core=p(sculpture,"Noyau lumineux",base,0,5.4,2.5,4.1,4.1,4.1,tint,Enum.Material.Neon,false)
    core.Shape=Enum.PartType.Ball
    core:SetAttribute("KinCoopCore",item.id)
    local light=Instance.new("PointLight")
    light.Name="Lumière commune";light.Range=22;light.Brightness=0.4;light.Parent=core
    for n=1,5 do
        local angle=n*math.pi*2/5
        local bead=p(sculpture,"Éclat solidaire",base,math.cos(angle)*3.2,5.4,2.5+math.sin(angle)*3.2,1.0,1.0,1.0,GOLD,Enum.Material.Neon,false)
        bead.Shape=Enum.PartType.Ball
    end
    F.sign(m,"Équipe",(base*CFrame.new(0,11.0,2.5)).Position,math.deg(item.yaw),"DEUX PERSONNES · UNE LUMIÈRE",20,2.4).CanCollide=false
    return m
end
function Installations.isReserved(x,z)
    for _,item in ipairs(D) do
        local base=CFrame.new(item.center_studs[1],0,item.center_studs[3])*CFrame.Angles(0,item.yaw,0)*CFrame.new(33,0,-3)
        local point=base:PointToObjectSpace(Vector3.new(x,0,z))
        if math.abs(point.X)<15 and math.abs(point.Z)<13 then return true end
    end
    return false
end
function Installations.make(city)
    local folder=F.folder(city,"Installations coopératives")
    for _,item in ipairs(D) do makeOne(folder,item) end
    folder:SetAttribute("KinCooperativeActivities",#D)
    return folder
end
return Installations

]])
source(server,"CooperativeRuntime","ModuleScript",[[
--!strict
-- Deux explorateurs, deux consoles, une activité collective purement visuelle.
-- Fenêtre 14 secondes, un joueur ne peut pas valider les deux commandes.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Coop={}
local WINDOW=14
local ACTIVE=14
local function send(reply,player,text,status,id)
    if player and player.Parent==Players then
        reply:FireClient(player,{kind="coop.update.v1",text=text,state=status,coop_id=id})
    end
end
function Coop.start(world,reply)
    local sculptures={}
    local indicators={}
    local cores={}
    local pending={}
    local busy={}
    for _,item in ipairs(world:GetDescendants()) do
        local id=nil
        if item:IsA("Model") then
            id=item:GetAttribute("KinCoopSculpture")
            if type(id)=="string" then sculptures[id]=item end
        elseif item:IsA("BasePart") then
            id=item:GetAttribute("KinCoopIndicator")
            if type(id)=="string" then
                indicators[id]=indicators[id] or {}
                indicators[id][item:GetAttribute("KinCoopSide")]=item
            end
            id=item:GetAttribute("KinCoopCore")
            if type(id)=="string" then cores[id]=item end
        end
    end
    local function indicator(id,side,on)
        local light=indicators[id] and indicators[id][side]
        if light and light.Parent then light.Color=if on then Color3.fromRGB(129,249,192) else Color3.fromRGB(89,132,145) end
    end
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if host:GetAttribute("KinCoopAction")~="participate" then return end
        local id=host:GetAttribute("KinCoopId")
        local side=host:GetAttribute("KinCoopSide")
        if type(id)~="string" or (side~=1 and side~=2) then return end
        if busy[id] then
            send(reply,player,"L'installation collective est en mouvement !","active",id)
            return
        end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not root then return end
        if (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"coop/"..id.."/"..side,1.0) then return end
        local now=os.clock()
        local entry=pending[id]
        if entry and now-entry.time>WINDOW then
            indicator(id,1,false);indicator(id,2,false)
            pending[id]=nil
            send(reply,entry.player,"Le délai est écoulé. Essaie à nouveau avec quelqu'un !","timeout",id)
            entry=nil
        end
        if not entry then
            pending[id]={player=player,side=side,time=now}
            indicator(id,side,true)
            send(reply,player,"Un autre explorateur doit activer l'autre console dans les 14 secondes.","waiting",id)
            task.delay(WINDOW+0.1,function()
                local live=pending[id]
                if live and live.player==player and live.time==now then
                    pending[id]=nil
                    indicator(id,1,false);indicator(id,2,false)
                    send(reply,player,"Personne n'a rejoint la console. Tu peux recommencer.","timeout",id)
                end
            end)
            return
        end
        if entry.player==player then
            send(reply,player,"Il faut deux visiteurs différents pour l'activité.","waiting",id)
            return
        end
        if entry.side==side then
            send(reply,player,"Choisis la console opposée pour activer le cœur.","waiting",id)
            return
        end
        if entry.player.Parent~=Players or not entry.player.Character then
            pending[id]=nil
            indicator(id,entry.side,false)
            send(reply,player,"L'autre explorateur est parti. Relance l'activité.","timeout",id)
            return
        end
        pending[id]=nil
        busy[id]=true
        indicator(id,1,true);indicator(id,2,true)
        send(reply,entry.player,"Bravo ! Vous avez activé le cœur ensemble.","success",id)
        send(reply,player,"Bravo ! Vous avez activé le cœur ensemble.","success",id)
        local model=sculptures[id]
        local core=cores[id]
        task.spawn(function()
            local ok,reason=pcall(function()
                if not model or not model.Parent then return end
                local original=model:GetPivot()
                local start=os.clock()
                local light=core and core:FindFirstChildOfClass("PointLight")
                if light then light.Brightness=3.0;light.Range=35 end
                while model.Parent and world.Parent do
                    local elapsed=os.clock()-start
                    local angle=elapsed*math.pi*2/5
                    model:PivotTo(original*CFrame.Angles(0,angle,0))
                    if elapsed>=ACTIVE then break end
                    RunService.Heartbeat:Wait()
                end
                if model.Parent then model:PivotTo(original) end
                if light then light.Brightness=0.4;light.Range=22 end
            end)
            if not ok then warn("Kin City coopération",reason) end
            busy[id]=nil
            indicator(id,1,false);indicator(id,2,false)
        end)
    end)
end
return Coop

]])
source(server,"CrystalEverydayV19","ModuleScript",[[
--!strict
-- Motifs sarcelle/opale pour les maisons et ateliers EXISTANTS.
-- Une grammaire courte : cadre, ligne de toiture, clef cristalline.
-- N'affecte pas les ouvertures et n'ajoute pas de physique.
local Kit=require(script.Parent.CrystalKit)
local Everyday={}
local function item(parent,name,cf,size,color,optional)
    local p=Kit.part(parent,"Part",name,size,cf,color,Enum.Material.Metal)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
function Everyday.frame(model,base,width,depth,roofHeight,variant)
    local folder=Instance.new("Folder")
    folder.Name="Habillage opalin — v19"
    folder.Parent=model
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    local entrance=-depth/2-0.95
    local pillars=math.min(width*0.34,7)
    local doorHeight=math.min(roofHeight-2,9)
    -- Bordure disjointe de la porte, laisse le passage central libre.
    for _,side in ipairs({-1,1}) do
        item(folder,"Jambage minéral",base*CFrame.new(side*pillars,doorHeight/2,entrance),
            Vector3.new(0.4,doorHeight,0.32),Kit.primary,false)
        item(folder,"Chemin de lumière",base*CFrame.new(side*pillars,doorHeight*0.6,entrance-0.21),
            Vector3.new(0.12,doorHeight*0.6,0.1),Kit.opal,true)
    end
    item(folder,"Traverse supérieure",base*CFrame.new(0,doorHeight,entrance),
        Vector3.new(pillars*2+0.4,0.4,0.45),Kit.gold,false)
    item(folder,"Liseré de toiture",base*CFrame.new(0,roofHeight-0.45,entrance+0.7),
        Vector3.new(math.max(9,width-1.5),0.36,0.46),Kit.primary,true)
    -- Clef de voûte dans le bandeau, non sur le passage.
    local key=item(folder,"Clef opaline",base*CFrame.new(0,doorHeight+0.35,entrance-0.25),
        Vector3.new(0.95,0.95,0.3),Kit.opal,false)
    key.CFrame=key.CFrame*CFrame.Angles(0,0,math.pi/4)
    if Kit.profile~="LITE" then
        for _,side in ipairs({-1,1}) do
            item(folder,"Trame horizontale",base*CFrame.new(side*(width*0.34),roofHeight*0.77,entrance+0.45),
                Vector3.new(math.max(1.2,width*0.16),0.24,0.3),Kit.gold,true)
        end
    end
    folder:SetAttribute("KinDecorationRole",variant or "everyday")
    return folder
end
return Everyday

]])
source(server,"CrystalFacades","ModuleScript",[[
--!strict
-- Identité structurelle v17 : formes cristallines asymétriques, fronton et toiture.
local Kit=require(script.Parent.CrystalKit)
local Facades={}
function Facades.make(model,structure,building,_style)
    local place=building.interior_place_key
    local cx,cy,cz=table.unpack(structure.center_studs)
    local width,depth=table.unpack(structure.footprint_studs)
    local height=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local front=-depth/2-3
    local accent=Kit.accent(place)
    local root=Instance.new("Folder")
    root.Name="Architecture sarcelle + cristal v17"
    root.Parent=model
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v17")
    -- Rythme vertical lisible, la porte à x=0 reste dégagée.
    for _,side in ipairs({-1,1}) do
        local x=side*math.min(width*0.35,27)
        local post=Kit.part(root,"Part","Contrefort sarcelle",Vector3.new(1.45,math.max(13,height*0.6),1.35),
            base*CFrame.new(x,math.max(13,height*0.6)/2,front+1.2),Kit.primary,Enum.Material.Slate)
        local jewelBase=base*CFrame.new(x,height*0.66,front-0.45)
        Kit.spire(root,"Cristal d'arcature",jewelBase,1.5,6.5,{accent=accent})
        Kit.spire(root,"Cristal de la corniche",base*CFrame.new(x*0.84,height+0.5,-depth*0.18),1.9,9,{accent=accent})
    end
    Kit.band(root,"Bandeau sarcelle supérieur",base,math.max(12,width-8),height*0.80,front+1.25,Kit.primary)
    Kit.rosette(root,"Rosace minérale",base*CFrame.new(0,math.max(17,height*0.74),front-0.05),4.7,accent,8)
    -- Un cristal majeur par toiture. Basse opacité uniquement sur cette pièce maîtresse.
    Kit.spire(root,"Couronne du bâtiment",base*CFrame.new(0,height+1.0,depth*0.17),3.2,16,
        {accent=accent,metal=Kit.primary,hero=true})
    -- Poutre d'identité : sarcelle sur fond pierre, conserve le lettrage d'origine.
    local sig=Kit.part(root,"Part","Bordure d'identité",Vector3.new(math.min(width-10,35),0.35,0.5),
        base*CFrame.new(0,math.min(height-3,15.8),front+0.65),Kit.gold,Enum.Material.Metal)
    return root
end
return Facades

]])
source(server,"CrystalInteriors","ModuleScript",[[
--!strict
-- Les cristaux existent dans les ESPACES, pas seulement sur les toitures.
local Kit=require(script.Parent.CrystalKit)
local Interior={}
function Interior.make(model,place,origin,_style)
    local key=place.place_key
    if key=="city" then return end
    local root=Instance.new("Folder")
    root.Name="Signature intérieure sarcelle et cristal v17"
    root.Parent=model
    local accent=Kit.accent(key)
    for index,room in ipairs(place.rooms) do
        local x,_,z=table.unpack(room.center_studs)
        local width,_,depth=table.unpack(room.size_studs)
        local base=CFrame.new(origin+Vector3.new(x,0,z))
        -- Éléments sur les murs latéraux, hors du mobilier et des traversées.
        local axisX=width*0.43
        for indexSide,side in ipairs({-1,1}) do
            if indexSide>Kit.settings.interior_spires_per_room then break end
            Kit.spire(root,"Prisme mural - "..room.room_id,
                base*CFrame.new(side*axisX,5.4,depth*0.25),1.0,7.8,{accent=accent})
        end
        -- Motif incrusté sans collision, limité à la pièce d'entrée pour éviter le bruit visuel.
        if index==1 then
            Kit.mosaic(root,base*CFrame.new(0,0.04,4),7)
            Kit.rosette(root,"Emblème de l'atrium",base*CFrame.new(width*0.31,10.7,depth/2-0.35)*CFrame.Angles(0,math.pi,0),
                3.4,accent,6)
        end
    end
    -- Accent ponctuel sur le parcours vertical, sans transformer tous les meubles en verre.
    local lookout=CFrame.new(origin+Vector3.new(0,26,60))
    Kit.spire(root,"Signal du parcours supérieur",lookout,2.1,8,{accent=accent})
    return root
end
return Interior

]])
source(server,"CrystalKit","ModuleScript",[[
--!strict
-- Pièces cristallines PROCÉDURALES : aucun mesh, aucune API externe.
-- Ornements sans collision ni requête physique; une seule facette Glass sur certains héros.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Theme=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("CrystalTheme"))
local F=require(script.Parent.Factory)
local Visual=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("VisualConfig"))
local Kit={}
local B=Theme.brand
Kit.profile=Visual.profile
Kit.settings=Visual.settings
Kit.deep=F.hex(B.deep)
Kit.primary=F.hex(B.primary)
Kit.medium=F.hex(B.medium)
Kit.stone=F.hex(B.stone)
Kit.opal=F.hex(B.opal)
Kit.pearl=F.hex(B.pearl)
Kit.gold=F.hex(B.champagne)
function Kit.accent(placeKey)
    return F.hex(Theme.institution_accents[placeKey] or B.opal)
end
local function ornament(parent,kind,name,size,frame,color,material,transparency)
    local object=Instance.new(kind)
    object.Name=name
    object.Size=size
    object.CFrame=frame
    object.Color=color
    object.Material=material or Enum.Material.Slate
    object.Anchored=true
    object.CanCollide=false
    object.CanTouch=false
    object.CanQuery=false
    object.CastShadow=false
    object.Transparency=transparency or 0
    object.Parent=parent
    object:SetAttribute("KinArtTheme","sarcelle-cristal-v17")
    return object
end
Kit.part=ornament

function Kit.spire(parent,label,base,radius,height,variant)
    -- Base = CFrame au PIED de la sculpture. Géométrie de 6 à 7 primitives max.
    local m=Instance.new("Model")
    m.Name=label
    m:SetAttribute("KinArtTheme","sarcelle-cristal-v17")
    m.Parent=parent
    local hue=variant and variant.accent or Kit.opal
    local metallic=variant and variant.metal or Kit.primary
    local stemH=height*0.66
    local p=ornament(m,"Part","Prisme minéral",Vector3.new(radius*1.5,stemH,radius*1.5),base*CFrame.new(0,stemH/2,0),metallic,Enum.Material.Slate)
    p.CFrame=p.CFrame*CFrame.Angles(0,math.rad(45),0)
    local peakH=height-stemH
    local step=if Visual.settings.facets_per_spire==2 then 2 else 1
    for side=0,3,step do
        local angle=side*math.pi/2
        local face=ornament(m,"WedgePart","Facette taillée",Vector3.new(radius*1.6,peakH,radius*1.16),
            base*CFrame.new(math.sin(angle)*radius*0.28,stemH+peakH/2,math.cos(angle)*radius*0.28)*CFrame.Angles(0,angle,0),
            if side%2==0 then hue else Kit.stone,Enum.Material.Slate)
    end
    local lightCore=ornament(m,"Part","Veine lumineuse",Vector3.new(radius*0.26,stemH*0.88,radius*0.26),base*CFrame.new(0,stemH*0.53,0),Kit.opal,Enum.Material.Neon)
    if variant and variant.hero and Visual.settings.glass_hero then
        -- Le seul vitrage superposé du cristal; jamais de centaines de panneaux transparents.
        local glass=ornament(m,"Part","Éclat translucide",Vector3.new(radius*0.9,peakH*0.5,radius*0.16),
            base*CFrame.new(0,stemH+peakH*0.47,radius*0.37),hue,Enum.Material.Glass,0.26)
        glass.Reflectance=0.04
    end
    return m
end

function Kit.band(parent,name,base,width,y,z,color)
    return ornament(parent,"Part",name,Vector3.new(width,0.48,0.57),base*CFrame.new(0,y,z),color or Kit.primary,Enum.Material.Metal)
end
function Kit.pedestal(parent,name,base,width,height,color)
    local shape=ornament(parent,"Part",name,Vector3.new(width,height,width),base*CFrame.new(0,height/2,0),color or Kit.primary,Enum.Material.Slate)
    local edge=ornament(parent,"Part",name.." / dalle",Vector3.new(width+0.7,0.28,width+0.7),base*CFrame.new(0,height,0),Kit.gold,Enum.Material.Metal)
    return shape
end
function Kit.rosette(parent,name,frame,radius,accent,beams)
    local folder=Instance.new("Folder")
    folder.Name=name;folder.Parent=parent
    local count=if Visual.profile=="LITE" then math.min(beams or 8,4) else (beams or 8)
    local core=ornament(folder,"Part","Noyau opalin",Vector3.new(1.7,1.7,0.32),frame,Kit.opal,Enum.Material.Neon)
    core.Shape=Enum.PartType.Ball
    for k=1,count do
        local a=k*math.pi*2/count
        local beam=ornament(folder,"Part","Rayon cristallin",Vector3.new(0.35,radius*0.74,0.3),
            frame*CFrame.new(math.sin(a)*radius*0.42,math.cos(a)*radius*0.42,0)*CFrame.Angles(0,0,-a),
            if k%2==0 then accent or Kit.primary else Kit.gold,Enum.Material.Metal)
        beam:SetAttribute("KinOptionalDetail",true)
    end
    return folder
end
function Kit.mosaic(parent,base,radius)
    local m=Instance.new("Folder");m.Name="Mandala de pierre et cristal";m.Parent=parent
    local rays=Visual.settings.mandala_rays
    for n=1,rays do
        local a=n*2*math.pi/rays
        local inlay=ornament(m,"Part","Incrustation radiale",Vector3.new(0.33,0.08,radius*0.82),
            base*CFrame.Angles(0,a,0)*CFrame.new(0,0.08,-radius*0.33),
            if n%2==0 then Kit.primary else Kit.gold,Enum.Material.Metal)
        inlay:SetAttribute("KinOptionalDetail",true)
    end
    ornament(m,"Part","Noyau en pierre",Vector3.new(1.8,0.12,1.8),base*CFrame.new(0,0.11,0),Kit.primary,Enum.Material.Slate)
    return m
end
function Kit.heroGlow(parent,position)
    local anchor=ornament(parent,"Part","Cœur éclairant",Vector3.new(0.8,0.8,0.8),CFrame.new(position),Kit.opal,Enum.Material.Neon)
    local light=Instance.new("PointLight")
    light.Name="Éclat local"
    light.Brightness=if Visual.profile=="LITE" then 0 else 0.65
    light.Range=18
    light.Shadows=false
    light.Parent=anchor
    return anchor
end
return Kit

]])
source(server,"CrystalLandingsV24","ModuleScript",[[
--!strict
-- Petits espaces d'arrivée et sculptures civiques autour des 8 monuments.
-- Ne déplace pas de routes, portes ou points de téléportation.
local Kit=require(script.Parent.CrystalKit)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Factory=require(script.Parent.Factory)
local Landings={}
local function decor(parent,name,size,cf,color,material)
    local p=Kit.part(parent,"Part",name,size,cf,color,material or Enum.Material.Slate)
    p:SetAttribute("KinOptionalDetail",true)
    return p
end
function Landings.make(city,plan)
    local root=Instance.new("Folder")
    root.Name="Parterres de cristal et ateliers des matières v24"
    root:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    root.Parent=city
    for _,structure in ipairs(plan.structures) do
        local w,d=table.unpack(structure.footprint_studs)
        local x,y,z=table.unpack(structure.center_studs)
        local frame=CFrame.new(x,y,z)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
        local group=Instance.new("Model")
        group.Name="Parterre des matières — "..structure.building_id
        group:SetAttribute("KinBuildingId",structure.building_id)
        group.Parent=root
        for _,side in ipairs({-1,1}) do
            -- Sur les bas-côtés extérieurs de la façade : pas sur l'axe de la porte.
            local base=frame*CFrame.new(side*(w*0.5+13),0,-d*0.5-8)
            decor(group,"Nappe de pierre",Vector3.new(8.1,0.22,7.5),
                base*CFrame.new(0,0.12,0),Kit.stone,Enum.Material.Cobblestone)
            Meshes.decorate(group,"Jardinière minérale","mineral_planter",Vector3.new(5.5,2.4,5.1),
                base*CFrame.new(0,1.5,0),Kit.primary)
            local count=if Kit.profile=="LITE" then 2 else 4
            for i=1,count do
                local a=(i-1)*2*math.pi/count
                local sprout=decor(group,"Feuille facettée",Vector3.new(0.8,2.6,1.0),
                    base*CFrame.new(math.cos(a)*1.25,3.25,math.sin(a)*1.2)*CFrame.Angles(0,a,math.rad(15)),
                    if i%2==0 then Kit.opal else Kit.medium,Enum.Material.Slate)
                sprout:SetAttribute("KinDecorRole","botanical")
            end
        end
        if Kit.profile~="LITE" then
            -- Un pupitre d'observation des matières : visite libre, sans faux service métier.
            local cf=frame*CFrame.new(w*0.5+13,0,-d*0.5+4)*CFrame.Angles(0,-math.pi/2,0)
            Meshes.decorate(group,"Pupitre de collection","opal_console",Vector3.new(3.2,4.1,3.2),
                cf*CFrame.new(0,2.1,0),Kit.opal)
            local sign=Factory.sign(group,"Cartel des matières",
                (cf*CFrame.new(0,4.4,0.0)).Position,structure.yaw_degrees+90,
                "PIERRE + CRISTAL",8,1.7)
            sign.CanCollide=false;sign.CanTouch=false;sign.CanQuery=false
        end
    end
    return root
end
return Landings

]])
source(server,"CrystalLuminairesV23","ModuleScript",[[
--!strict
-- Un luminaire sculptural par pièce, au lieu de trois sphères de verre identiques.
-- Réutilise l'éclairage existant : aucune PointLight/SpotLight supplémentaire.
local Kit=require(script.Parent.CrystalKit)
local Studio=require(script.Parent.ArtisanGeometryV22)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Luminaires={}
local roles={city_hall="civic",ekoh_tower="knowledge",library="archive",campus="orbit",
    justice_palace="balance",innovation_lab="mechanism",museum="art",orgo_center="network"}
function Luminaires.decorate(parent,room,origin,placeKey,index)
    local cx,_,cz=table.unpack(room.center_studs)
    local role=roles[placeKey] or "civic"
    local root=Instance.new("Folder")
    root.Name="Luminaire minéral v23"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v23")
    root.Parent=parent
    local base=CFrame.new(origin+Vector3.new(cx,12.9,cz))
    Studio.part(root,"Tige de suspension",Vector3.new(0.24,3.1,0.24),base*CFrame.new(0,2.1,0),"gold",Enum.Material.Metal,false)
    Studio.part(root,"Couronne suspendue",Vector3.new(5.8,0.44,5.8),base,"deep",Enum.Material.Slate,false)
    Studio.part(root,"Plafonnier opalin",Vector3.new(4.8,0.3,4.8),base*CFrame.new(0,-0.4,0),"opal",Enum.Material.Slate,false)
    Meshes.decorate(root,"Prisme de lustre", "opal_chandelier",Vector3.new(3.2,2.7,3.2),base*CFrame.new(0,-1.0,0),Kit.opal)
    if Kit.profile~="LITE" then
        local count=if Kit.profile=="SHOWCASE" then 8 else 5
        for i=1,count do
            local a=i*2*math.pi/count
            local r=2.45
            local p=Studio.part(root,"Pendeloque cristalline",Vector3.new(0.52,1.55+(i%2)*0.35,0.52),
                base*CFrame.new(math.cos(a)*r,-1.4,math.sin(a)*r)*CFrame.Angles(0,a,math.rad((i%2)*13)),
                if i%3==0 then "gold" else "opal",Enum.Material.Slate,true)
            p:SetAttribute("KinDecorRole",role)
        end
    end
    if role=="orbit" or role=="knowledge" then
        local dot=Studio.orb(root,"Astrolabe central",1.35,base*CFrame.new(0,-1.4,0),"gold",true)
    elseif role=="archive" or role=="balance" then
        Studio.part(root,"Carreau axial",Vector3.new(1.0,2.0,1.0),base*CFrame.new(0,-1.4,0),"medium",Enum.Material.Slate,true)
    elseif role=="art" or role=="mechanism" then
        Studio.wedge(root,"Fragment central",Vector3.new(1.8,1.5,0.8),base*CFrame.new(0,-1.1,0)*CFrame.Angles(0,0.6,0),"gold",true)
    end
    return root
end
return Luminaires

]])
source(server,"CrystalPorticosV19","ModuleScript",[[
--!strict
-- v19 : portiques monumentaux facetés et silhouettes institutionnelles.
-- Surfaces ornementales, sans collisions, sans requêtes ni lumières permanentes.
local Kit=require(script.Parent.CrystalKit)
local M={}
local signatures={
    city_hall={name="Cité",shape="civic",scale=1.0},
    ekoh_tower={name="Savoirs",shape="constellation",scale=1.13},
    library={name="Archives",shape="leaves",scale=1.05},
    campus={name="Campus",shape="orbit",scale=1.06},
    justice_palace={name="Équilibres",shape="balance",scale=1.00},
    innovation_lab={name="Inventions",shape="gear",scale=0.95},
    museum={name="Création",shape="prism",scale=1.10},
    orgo_center={name="Réseaux",shape="network",scale=1.00},
}
local function art(parent,name,size,frame,color,material,optional)
    local p=Kit.part(parent,"Part",name,size,frame,color,material)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
local function bar(parent,name,from,to,thickness,color,optional)
    local delta=to-from
    if delta.Magnitude<0.05 then return nil end
    return art(parent,name,Vector3.new(thickness,thickness,delta.Magnitude),
        CFrame.lookAt((from+to)*0.5,to),color,Enum.Material.Metal,optional)
end
local function emblem(parent,frame,kind,color,radius)
    local r=radius
    if kind=="balance" then
        bar(parent,"Fléau",(frame*CFrame.new(-r,0,0)).Position,(frame*CFrame.new(r,0,0)).Position,0.38,Kit.gold,false)
        bar(parent,"Axe",(frame*CFrame.new(0,-r*0.65,0)).Position,(frame*CFrame.new(0,r*0.55,0)).Position,0.36,color,false)
        for _,s in ipairs({-1,1}) do
            bar(parent,"Chaîne",(frame*CFrame.new(s*r*0.75,0,0)).Position,(frame*CFrame.new(s*r*0.75,-r*0.55,0)).Position,0.20,Kit.gold,true)
            art(parent,"Plateau",Vector3.new(r*0.74,0.17,0.65),frame*CFrame.new(s*r*0.75,-r*0.55,0),color,Enum.Material.Slate,true)
        end
    elseif kind=="leaves" then
        bar(parent,"Tige",(frame*CFrame.new(0,-r,0)).Position,(frame*CFrame.new(0,r,0)).Position,0.28,Kit.gold,false)
        for i=1,4 do
            local y=-r+i*(2*r)/5
            local side=if i%2==0 then 1 else -1
            local leaf=art(parent,"Page-feuille",Vector3.new(r*0.64,r*0.33,0.22),
                frame*CFrame.new(side*r*0.31,y,0)*CFrame.Angles(0,0,side*0.38),color,Enum.Material.Slate,true)
            leaf:SetAttribute("KinDecorationRole","knowledge")
        end
    elseif kind=="network" or kind=="constellation" then
        local points={Vector3.new(-r,0,0),Vector3.new(-r*0.3,r*0.8,0),Vector3.new(r*0.7,r*0.55,0),Vector3.new(r,-r*0.65,0),Vector3.new(-r*0.45,-r*0.85,0)}
        for i=1,#points do
            local a=points[i]
            local b=points[i%#points+1]
            bar(parent,"Lien minéral",(frame*CFrame.new(a)).Position,(frame*CFrame.new(b)).Position,0.22,Kit.gold,true)
            local sphere=art(parent,"Nœud",Vector3.new(0.8,0.8,0.8),frame*CFrame.new(a),color,Enum.Material.Neon,true)
            sphere.Shape=Enum.PartType.Ball
        end
    elseif kind=="orbit" or kind=="gear" then
        local n=if kind=="gear" then 8 else 6
        for i=1,n do
            local a=(i-1)*math.pi*2/n
            local b=i*math.pi*2/n
            bar(parent,"Arc orbital",(frame*CFrame.new(math.cos(a)*r,math.sin(a)*r,0)).Position,
                (frame*CFrame.new(math.cos(b)*r,math.sin(b)*r,0)).Position,0.29,if i%2==0 then Kit.gold else color,true)
        end
        local core=art(parent,"Cœur orbital",Vector3.new(1.6,1.6,0.6),frame,color,Enum.Material.Neon,false)
        core.Shape=Enum.PartType.Ball
    elseif kind=="prism" then
        for i=1,3 do
            local angle=(i-1)*2.094
            bar(parent,"Composition prismatique",(frame*CFrame.new(math.sin(angle)*r,math.cos(angle)*r,0)).Position,
                (frame*CFrame.new(math.sin(angle+2.094)*r,math.cos(angle+2.094)*r,0)).Position,0.55,if i==1 then Kit.gold else color,false)
        end
    else
        for i=1,4 do
            local a=i*math.pi/2
            bar(parent,"Rayon civique",frame.Position,(frame*CFrame.new(math.cos(a)*r,math.sin(a)*r,0)).Position,0.36,if i%2==0 then color else Kit.gold,false)
        end
    end
end
function M.make(model,structure,building,_style)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local width,depth=table.unpack(structure.footprint_studs)
    local height=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local front=-depth*0.5-2.5
    local variant=signatures[building.interior_place_key] or {name="Cité",shape="civic",scale=1}
    local accent=Kit.accent(building.interior_place_key)
    local root=Instance.new("Folder")
    root.Name="Portique de cristal — v19"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    root.Parent=model
    local reach=math.min(width*0.35,21)
    local top=math.min(19,height*0.65)
    local thick=1.35*variant.scale
    -- Deux supports externes : le passage et les prompts à x=0 restent entièrement libres.
    for _,side in ipairs({-1,1}) do
        local x=side*reach
        art(root,"Pilastre sculpté",Vector3.new(thick,top,thick),base*CFrame.new(x,top/2,front),Kit.primary,Enum.Material.Slate,false)
        art(root,"Incrustation opaline",Vector3.new(0.36,top*0.76,0.24),base*CFrame.new(x,top*0.53,front-0.8),accent,Enum.Material.Neon,true)
        Kit.spire(root,"Fleuron",base*CFrame.new(x,top+0.6,front),1.1,6.7,{accent=accent})
    end
    local left=(base*CFrame.new(-reach,top,front)).Position
    local right=(base*CFrame.new(reach,top,front)).Position
    local peak=(base*CFrame.new(0,top+math.min(6,height*0.13),front)).Position
    bar(root,"Chevron gauche",left,peak,thick*0.85,Kit.primary,false)
    bar(root,"Chevron droit",peak,right,thick*0.85,Kit.primary,false)
    bar(root,"Frise horizontale",left,right,0.6,Kit.gold,true)
    -- Héraldique différente pour chacun des 8 édifices; au-dessus de la porte.
    emblem(root,base*CFrame.new(0,top+1.4,front-0.45),variant.shape,accent,math.min(4,reach*0.27))
    root:SetAttribute("KinInstitutionKey",building.interior_place_key)
    return root
end
return M

]])
source(server,"CrystalPublic","ModuleScript",[[
--!strict
-- Axes de place, pétales urbains et bornes en cristal, géométrie légère.
local Kit=require(script.Parent.CrystalKit)
local Public={}
function Public.make(city)
    local folder=Instance.new("Folder")
    folder.Name="Mandala sarcelle et cristal v17"
    folder.Parent=city
    Kit.mosaic(folder,CFrame.new(0,1.10,0),16)
    -- Couronne : les ornements sont sans collision pour ne fermer AUCUN itinéraire.
    local count=Kit.settings.central_jalons
    for i=1,count do
        local a=2*math.pi*i/count
        local x,z=math.cos(a)*62,math.sin(a)*62
        local at=CFrame.new(x,0.1,z)*CFrame.Angles(0,-a,0)
        Kit.pedestal(folder,"Socle cardinal",at,3.4,0.8,Kit.primary)
        Kit.spire(folder,"Jalon de cristal",at*CFrame.new(0,0.8,0),1.7,8,
            {accent=if i%3==0 then Kit.gold else Kit.opal})
    end
    -- Huit portes thématiques le long de la couronne. Les poutres sont un décor optique.
    local accents={"city_hall","ekoh_tower","library","campus","justice_palace","innovation_lab","museum","orgo_center"}
    for i,key in ipairs(accents) do
        local a=(i-1)*math.pi/4
        local center=Vector3.new(math.cos(a)*342,0.4,math.sin(a)*342)
        local frame=CFrame.new(center)*CFrame.Angles(0,-a,0)
        local accent=Kit.accent(key)
        local exhibit=Instance.new("Folder")
        exhibit.Name="Signal de quartier / "..key
        exhibit.Parent=folder
        for _,side in ipairs({-1,1}) do
            Kit.spire(exhibit,"Pylône de district",frame*CFrame.new(side*11,0,0),2.15,10,
                {accent=accent})
        end
        local bar=Kit.part(exhibit,"Part","Pont cristallin",Vector3.new(24,0.7,1.0),
            frame*CFrame.new(0,12,0),Kit.primary,Enum.Material.Metal)
        Kit.rosette(exhibit,"Médaillon district",frame*CFrame.new(0,12,0.75),2.8,accent,6)
    end
    -- Signature sur le monument existant (0,0,39), sans masquer sa façade.
    Kit.spire(folder,"Flèche du savoir",CFrame.new(0,19.4,39),2.9,12,{accent=Kit.opal,hero=true})
    Kit.heroGlow(folder,Vector3.new(0,27,39))
    return folder
end
return Public

]])
source(server,"CrystalRestStopsV22","ModuleScript",[[
--!strict
-- Petites stations de repos près des trajets EXISTANTS : bancs, pergolas, jardin minéral.
-- Chaque station est lue du chemin canonique; aucun nouveau quartier.
local Kit=require(script.Parent.CrystalKit)
local Studio=require(script.Parent.ArtisanGeometryV22)
local Stops={}
local function pointAt(path,fraction)
    local coords=path.path_xyz_studs
    if not coords or #coords<2 then return nil,nil end
    local lengths={}
    local total=0
    for i=2,#coords do
        local a,b=coords[i-1],coords[i]
        local dist=Vector3.new(b[1]-a[1],0,b[3]-a[3]).Magnitude
        lengths[i]=dist
        total+=dist
    end
    local remaining=total*fraction
    for i=2,#coords do
        if remaining<=lengths[i] or i==#coords then
            local a,b=coords[i-1],coords[i]
            local dir=Vector3.new(b[1]-a[1],0,b[3]-a[3])
            if dir.Magnitude<0.1 then return nil,nil end
            local t=math.clamp(remaining/math.max(lengths[i],0.01),0,1)
            local pos=Vector3.new(a[1],0,a[3])+dir*t
            return pos,dir.Unit
        end
        remaining-=lengths[i]
    end
    return nil,nil
end
local function restStop(folder,position,tangent,index,side)
    local root=Instance.new("Model")
    root.Name="Halte opaline "..index
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    root.Parent=folder
    local normal=Vector3.new(-tangent.Z,0,tangent.X)*side
    local center=position+normal*12
    local base=CFrame.lookAt(center,center+normal)
    local deck=Studio.part(root,"Esplanade minérale",Vector3.new(13,0.4,8.5),
        base*CFrame.new(0,0.06,0),"medium",Enum.Material.Slate,false)
    -- Banc physique, utilisable en s'asseyant. À 12 studs du tracé et hors de son axe.
    local seat=Instance.new("Seat")
    seat.Name="Banc de promenade"
    seat.Size=Vector3.new(5.5,0.65,2.2)
    seat.CFrame=base*CFrame.new(0,1.6,-1.5)
    seat.Anchored=true
    seat.CanCollide=true
    seat.Material=Enum.Material.Wood
    seat.Color=Kit.deep
    seat.Parent=root
    Studio.part(root,"Dossier sarcelle",Vector3.new(5.6,2.3,0.43),
        base*CFrame.new(0,2.8,-2.5),"deep",Enum.Material.Wood,false)
    for _,x in ipairs({-5.7,5.7}) do
        Studio.part(root,"Pilier en pierre",Vector3.new(0.6,6.8,0.6),
            base*CFrame.new(x,3.6,0),"deep",Enum.Material.Slate,false)
        Studio.facet(root,"Gemme de pergola",base*CFrame.new(x,6.85,0),0.55,2.2,"opal",true)
    end
    Studio.part(root,"Traverse de pergola",Vector3.new(12,0.55,0.7),
        base*CFrame.new(0,6.9,0),"gold",Enum.Material.Metal,false)
    for _,x in ipairs({-4.9,4.9}) do
        Studio.part(root,"Jardinière",Vector3.new(2.8,0.9,2.8),
            base*CFrame.new(x,0.65,2.3),"deep",Enum.Material.Slate,false)
        if Kit.profile~="LITE" then
            Studio.facet(root,"Flore minérale",base*CFrame.new(x,1.1,2.3),0.48,2.4,"opal",true)
        end
    end
    return root
end
function Stops.make(city,plan)
    local folder=Instance.new("Folder")
    folder.Name="Haltes de promenade cristallines v22"
    folder.Parent=city
    local index=0
    for routeIndex,path in ipairs(plan.pedestrian_paths) do
        local count=if Kit.profile=="LITE" then 1 else 2
        for n=1,count do
            local p,dir=pointAt(path,if n==1 then 0.37 else 0.64)
            if p and dir then
                index+=1
                restStop(folder,p,dir,index,if (routeIndex+n)%2==0 then 1 else -1)
            end
        end
    end
    return folder
end
return Stops

]])
source(server,"CrystalRoomStoriesV19","ModuleScript",[[
--!strict
-- v19 : une narration visuelle différente pour chacune des 8 institutions.
-- Installations murales hautes : la surface praticable et les portails restent libres.
local Kit=require(script.Parent.CrystalKit)
local F=require(script.Parent.Factory)
local RoomStories={}
local themes={
    city_hall={title="Cité solidaire",form="mandala",tones=7},
    ekoh_tower={title="Cartographie du savoir",form="constellation",tones=9},
    library={title="Archives vivantes",form="books",tones=8},
    campus={title="Univers des possibles",form="orbits",tones=8},
    justice_palace={title="Harmonie des équilibres",form="symmetry",tones=8},
    innovation_lab={title="Fabrique expérimentale",form="gears",tones=7},
    museum={title="Matières et couleurs",form="ribbons",tones=9},
    orgo_center={title="Réseau de coopération",form="network",tones=8},
}
local function ornament(parent,name,size,cf,color,material,optional)
    local p=Kit.part(parent,"Part",name,size,cf,color,material)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
local function line(parent,name,a,b,width,color,optional)
    local d=b-a
    if d.Magnitude<0.04 then return nil end
    return ornament(parent,name,Vector3.new(width,width,d.Magnitude),CFrame.lookAt((a+b)*0.5,b),color,Enum.Material.Metal,optional)
end
local function tableau(root,frame,form,accent,radius,count)
    -- Tous les panneaux sont au-dessus des avatars, devant un mur d'exposition.
    if form=="books" then
        for n=1,5 do
            local x=(n-3)*1.65
            local leaf=ornament(root,"Volume des archives",Vector3.new(1.25,4.6+(n%2)*0.6,0.4),
                frame*CFrame.new(x,0,0),if n%2==0 then accent else Kit.gold,Enum.Material.Slate,n>3)
            leaf.CFrame=leaf.CFrame*CFrame.Angles(0,0,(n-3)*0.075)
        end
    elseif form=="symmetry" then
        line(root,"Fléau symétrique",(frame*CFrame.new(-radius,0,0)).Position,(frame*CFrame.new(radius,0,0)).Position,0.45,Kit.gold,false)
        line(root,"Socle vertical",(frame*CFrame.new(0,-radius,0)).Position,(frame*CFrame.new(0,radius,0)).Position,0.45,accent,false)
        for _,s in ipairs({-1,1}) do
            ornament(root,"Coupelle",Vector3.new(2.9,0.22,0.5),frame*CFrame.new(s*radius*0.73,-radius*0.48,0),accent,Enum.Material.Metal,true)
        end
    else
        local sides=if form=="mandala" then 8 elseif form=="ribbons" then 5 else 6
        for i=1,sides do
            local a=(i-1)*2*math.pi/sides
            local b=i*2*math.pi/sides
            local pos1=(frame*CFrame.new(math.cos(a)*radius,math.sin(a)*radius,0)).Position
            local pos2=(frame*CFrame.new(math.cos(b)*radius,math.sin(b)*radius,0)).Position
            if form=="network" or form=="gears" or form=="orbits" then
                line(root,"Connexion opaline",pos1,pos2,0.28,if i%2==0 then accent else Kit.gold,i>3)
            else
                line(root,"Facette murale",frame.Position,pos1,0.28,if i%2==0 then accent else Kit.gold,i>3)
            end
            if i<=count and (form=="constellation" or form=="network") then
                local star=ornament(root,"Cristal de connaissance",Vector3.new(0.6,0.6,0.4),CFrame.new(pos1),accent,Enum.Material.Neon,true)
                star.Shape=Enum.PartType.Ball
            end
        end
        if form=="gears" or form=="orbits" then
            local core=ornament(root,"Centre de la découverte",Vector3.new(1.5,1.5,0.6),frame,Kit.opal,Enum.Material.Neon,false)
            core.Shape=Enum.PartType.Ball
        end
    end
end
function RoomStories.make(model,place,origin,_style)
    local theme=themes[place.place_key]
    if not theme then return nil end
    local root=Instance.new("Folder")
    root.Name="Galeries narratives — v19"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    root.Parent=model
    local accent=Kit.accent(place.place_key)
    for i,room in ipairs(place.rooms) do
        -- Ne pas surcharger les 6 salles. L'entrée et deux salles de parcours font la signature.
        if i<=3 then
            local x,_,z=table.unpack(room.center_studs)
            local w,_,d=table.unpack(room.size_studs)
            local width=math.max(6,math.min(15,(w-12)*0.45))
            local wallZ=z+d/2-1.45
            -- Le centre du mur est réservé aux panneaux de signalétique existants.
            local muralX=x-w*0.32
            local base=CFrame.new(origin+Vector3.new(muralX,10.7,wallZ))*CFrame.Angles(0,math.pi,0)
            -- Encadrement haut, dégagé du plancher et du mobilier.
            local border=ornament(root,"Panneau d'institution",Vector3.new(width,6.8,0.24),
                base*CFrame.new(0,0,0.12),Kit.deep,Enum.Material.Slate,false)
            border.Transparency=0.07
            ornament(root,"Bandeau supérieur",Vector3.new(width+0.7,0.34,0.38),base*CFrame.new(0,3.5,0),Kit.gold,Enum.Material.Metal,true)
            ornament(root,"Liseré inférieur",Vector3.new(width+0.7,0.23,0.38),base*CFrame.new(0,-3.5,0),Kit.primary,Enum.Material.Metal,true)
            tableau(root,base*CFrame.new(0,0,-0.35),theme.form,accent,math.min(2.8,width*0.22),theme.tones)
        end
    end
    return root
end
return RoomStories

]])
source(server,"DiscoveryLedger","ModuleScript",[[
--!strict
-- Découvertes pédagogiques par session, sans compte externe ni crédits métier.
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local RateLimiter=require(script.Parent.RateLimiter)
local Ledger={}
local perPlayer={}
local TOTAL=24
function Ledger.start(world,reply)
    local function register(player)
        perPlayer[player]={}
        player:SetAttribute("KinTrailCount",0)
        player:SetAttribute("KinTrailTotal",TOTAL)
    end
    Players.PlayerAdded:Connect(register)
    for _,p in ipairs(Players:GetPlayers()) do register(p) end
    Players.PlayerRemoving:Connect(function(p)perPlayer[p]=nil end)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled or not player then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinTrailId")
        if type(id)~="string" or not id:match("^kin%.trail%.%d%d$") then return end
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health<=0 or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"trail/"..id,0.6) then return end
        local discovered=perPlayer[player]
        if not discovered then return end
        local first=not discovered[id]
        if first then
            discovered[id]=true
            local total=0
            for _ in pairs(discovered) do total+=1 end
            player:SetAttribute("KinTrailCount",total)
        end
        local count=player:GetAttribute("KinTrailCount") or 0
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",
            title=host:GetAttribute("KinTrailTitle") or "Halte pédagogique",
            message=host:GetAttribute("KinTrailText") or "Découverte de Kin City",
            notice=string.format("%d/%d haltes découvertes%s",count,TOTAL,if first then " — nouvelle découverte !" else " — déjà visitée")
        })
    end)
end
return Ledger

]])
source(server,"DiscoveryPromenade","ModuleScript",[[
--!strict
-- Parcours de vingt-quatre bornes de découverte. Les visites restent locales à la session.
local F=require(script.Parent.Factory)
local Trail={}
local captions={
    {"La place centrale","La ville est organisée autour d'un espace commun."},
    {"Les huit quartiers","Chaque quartier possède une identité et des usages distincts."},
    {"Le lac annulaire","Les paysages naturels peuvent inspirer l'urbanisme."},
    {"La bibliothèque","Les connaissances deviennent plus utiles quand elles sont partagées."},
    {"La démarche scientifique","Observer, tester et expliquer sont trois étapes complémentaires."},
    {"Le jardin vivant","Une ville peut offrir de nombreux habitats à la biodiversité."},
    {"Les métiers du monde","Les techniques s'apprennent aussi par l'expérimentation."},
    {"L'architecture civique","Un bâtiment public doit accueillir différentes personnes."},
    {"Les matériaux","Bois, pierre et métal ont des propriétés différentes."},
    {"Le cycle de l'eau","L'eau circule entre la terre, les rivières et l'atmosphère."},
    {"La lumière du jour","L'orientation des bâtiments influence leur ensoleillement."},
    {"La mobilité douce","Des rues piétonnes donnent une place au déplacement lent."},
    {"Les rencontres","Les espaces communs permettent des échanges inattendus."},
    {"L'observation","Voir un phénomène ne suffit pas toujours à l'expliquer."},
    {"La création","Arts et sciences peuvent enrichir une même expérience."},
    {"La transmission","L'enseignement relie les générations et les communautés."},
    {"Le patrimoine","Préserver une trace aide à comprendre son histoire."},
    {"Le dialogue","Écouter plusieurs perspectives améliore la compréhension."},
    {"L'éthique","Une décision peut avoir des conséquences différentes selon les personnes."},
    {"La collaboration","Un projet collectif demande une coordination explicite."},
    {"La réparation","Réutiliser et réparer peut limiter le gaspillage."},
    {"L'énergie","Toute transformation d'énergie a des contraintes physiques."},
    {"Le temps long","Une ville évolue et se transforme au fil des usages."},
    {"Le chemin parcouru","Explorer un lieu aide à se construire des repères."},
}
function Trail.make(city)
    local root=F.folder(city,"Sentier pédagogique — 24 haltes")
    for i,item in ipairs(captions) do
        local a=(i-1)*math.pi*2/#captions+0.09
        local r=376+(i%2)*6
        local x,z=math.cos(a)*r,math.sin(a)*r
        local angle=math.pi/2-a
        local base=CFrame.new(x,0,z)*CFrame.Angles(0,angle,0)
        local m=Instance.new("Model")
        m.Name=string.format("Halte %02d — %s",i,item[1]);m.Parent=root
        local floor=F.part(m,"Pavement de la halte",Vector3.new(9,0.24,7),base*CFrame.new(0,-0.14,0),Color3.fromRGB(216,206,184),Enum.Material.Cobblestone)
        local pedestal=F.part(m,"Borne de découverte",Vector3.new(2.3,3.6,1.6),base*CFrame.new(0,1.9,0.5),Color3.fromRGB(42,71,82),Enum.Material.Metal)
        pedestal:SetAttribute("KinTrailId",string.format("kin.trail.%02d",i))
        pedestal:SetAttribute("KinTrailTitle",item[1]);pedestal:SetAttribute("KinTrailText",item[2])
        F.prompt(pedestal,"Découvrir",item[1])
        local cap=F.part(m,"Lanterne",Vector3.new(1.7,0.75,1.7),base*CFrame.new(0,4.0,0.5),Color3.fromRGB(241,208,146),Enum.Material.Neon)
        cap.CanCollide=false
        F.sign(m,"Plaque",(base*CFrame.new(0,5.6,0.5)).Position,math.deg(angle),string.format("%02d  %s",i,item[1]),12,2.1).CanCollide=false
    end
    root:SetAttribute("KinTrailStops",#captions)
    return root
end
function Trail.isReserved(x,z)
    for i=1,#captions do
        local a=(i-1)*math.pi*2/#captions+0.09
        local r=376+(i%2)*6
        local dx=x-math.cos(a)*r
        local dz=z-math.sin(a)*r
        if dx*dx+dz*dz<11*11 then return true end
    end
    return false
end
return Trail

]])
source(server,"DistrictLandmarks","ModuleScript",[[
--!strict
-- Six places publiques reconnaissables, installées au voisinage des hubs canoniques.
local F=require(script.Parent.Factory)
local Landmarks={}
local profiles={
    central={label="Jardin des communes",color=Color3.fromRGB(189,163,113),kind="columns"},
    konnected={label="Jardin des livres",color=Color3.fromRGB(100,143,187),kind="books"},
    ethikos={label="Agora de l'écoute",color=Color3.fromRGB(205,174,138),kind="agora"},
    keenkonnect={label="Atelier des idées",color=Color3.fromRGB(77,171,171),kind="tech"},
    kreative={label="Promenade des arts",color=Color3.fromRGB(206,119,115),kind="art"},
    orgo={label="Réseau des connexions",color=Color3.fromRGB(106,140,194),kind="network"},
}
local function part(parent,name,size,cf,color,material)
    return F.part(parent,name,size,cf,color,material)
end
local function stone(parent,pos,w,d,color)
    return part(parent,"Place paysagère",Vector3.new(w,0.35,d),CFrame.new(pos+Vector3.new(0,0.12,0)),color,Enum.Material.Cobblestone)
end
local function theme(parent,pos,profile)
    local c=profile.color
    local themeName=profile.kind
    if themeName=="books" then
        for i=-2,2 do
            local p=part(parent,"Livre monument",Vector3.new(3,8+math.abs(i%3)*2,7),CFrame.new(pos+Vector3.new(i*6,6,-1)),Color3.fromHSV((i+4)*0.11,0.4,0.78),Enum.Material.Marble)
            p.CanCollide=false
        end
    elseif themeName=="agora" then
        for i=0,8 do
            local theta=i*math.pi/8
            local x=math.cos(theta)*17
            local z=math.sin(theta)*10
            part(parent,"Gradin de discussion",Vector3.new(5,1.6,5),CFrame.new(pos+Vector3.new(x,0.8,z)),c,Enum.Material.Marble)
        end
    elseif themeName=="tech" then
        for i=-2,2 do
            local p=part(parent,"Nervure technologique",Vector3.new(1.1,8,1.1),CFrame.new(pos+Vector3.new(i*7,4,0)),c,Enum.Material.Metal)
            part(parent,"Module lumineux",Vector3.new(3,2,3),CFrame.new(pos+Vector3.new(i*7,9,0)),Color3.fromRGB(122,233,221),Enum.Material.Neon).CanCollide=false
        end
    elseif themeName=="art" then
        for i=-2,2 do
            local p=part(parent,"Stèle créative",Vector3.new(4,4,4),CFrame.new(pos+Vector3.new(i*7,6,0))*CFrame.Angles(0,i*.35,math.rad(22+i*5)),Color3.fromHSV((i+4)*0.17,.5,.8),Enum.Material.Metal)
            p.CanCollide=false
        end
    elseif themeName=="network" then
        for i=1,7 do
            local a=i*math.pi*2/7
            local v=Vector3.new(math.cos(a)*11,5,math.sin(a)*11)
            part(parent,"Noeud réseau",Vector3.new(2,9,2),CFrame.new(pos+v),c,Enum.Material.Glass)
        end
    else
        for i=-2,2 do
            part(parent,"Colonne de place",Vector3.new(2,9,2),CFrame.new(pos+Vector3.new(i*7,4.5,0)),c,Enum.Material.Marble)
            part(parent,"Chapiteau",Vector3.new(3.5,1,3.5),CFrame.new(pos+Vector3.new(i*7,9.4,0)),Color3.fromRGB(238,214,164),Enum.Material.Marble)
        end
    end
end
function Landmarks.make(city,plan)
    local group=F.folder(city,"Jardins et places thématiques")
    for _,place in ipairs(plan.places) do
        if place.place_key=="city" then
            for _,a in ipairs(place.anchors) do
                local district=string.match(a.anchor_id,"^city%.district%.([%a]+)%.hub$")
                local profile=district and profiles[district]
                if profile and district~="central" then
                    -- Le repère reste près du hub, mais en retrait du sentier central.
                    local center=Vector3.new(a.position_studs[1],0,a.position_studs[3])
                    local radial=(center.Magnitude>1) and center.Unit or Vector3.new(1,0,0)
                    local side=Vector3.new(-radial.Z,0,radial.X)
                    local pos=center+side*28+radial*3
                    local folder=F.folder(group,profile.label)
                    stone(folder,pos,41,28,Color3.fromRGB(205,194,170))
                    theme(folder,pos,profile)
                    local booth=part(folder,"Borne des quartiers",Vector3.new(3.5,4.5,2),CFrame.new(pos+Vector3.new(0,2.4,-13)),Color3.fromRGB(37,61,72),Enum.Material.Metal)
                    part(folder,"Écran de découverte",Vector3.new(2.9,2.6,0.2),CFrame.new(pos+Vector3.new(0,3.1,-14.1)),profile.color,Enum.Material.Neon).CanCollide=false
                    booth:SetAttribute("KinStubInteractionId","district."..district..".information")
                    booth:SetAttribute("KinStubCapabilityId","future.district."..district)
                    booth:SetAttribute("KinStubTitle",profile.label)
                    F.prompt(booth,"Découvrir",profile.label)
                    F.sign(folder,"Nom du jardin",pos+Vector3.new(0,12,13),0,profile.label,31,3.1).CanCollide=false
                end
            end
        end
    end
    return group
end
return Landmarks

]])
source(server,"FacadeDetail","ModuleScript",[[
--!strict
-- Couche volumétrique de façades : arches, cadres, balcons, bannières, toiture.
-- Géométrie locale, reproductible, sans asset externe.
local F=require(script.Parent.Factory)
local Detail={}
local pale=Color3.fromRGB(230,225,213)
local dark=Color3.fromRGB(18,62,60)
local function part(parent,name,base,offset,size,color,mat,solid)
    local p=F.part(parent,name,size,base*CFrame.new(offset),color,mat or Enum.Material.Metal)
    if solid==false then p.CanCollide=false;p.CastShadow=false end
    return p
end
function Detail.make(model,structure,building,style)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local width,depth=table.unpack(structure.footprint_studs)
    local height=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local accent=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local folder=F.folder(model,"Détails façades v4")
    -- Accès monumental en arcade : dégagement non bloquant devant la porte de téléportation.
    part(folder,"Auvent",base,Vector3.new(0,10,-depth/2-5.2),Vector3.new(20,0.85,9),trim,Enum.Material.Marble,false)
    for _,s in ipairs({-1,1}) do
        part(folder,"Pylône d'entrée",base,Vector3.new(s*9.2,5,-depth/2-6.5),Vector3.new(1.7,10,1.7),accent,Enum.Material.Marble,false)
        part(folder,"Ornement d'entrée",base,Vector3.new(s*9.2,10.6,-depth/2-6.5),Vector3.new(3.1,1.1,3.1),trim,Enum.Material.Metal,false)
        -- Étendard de quartier, sans collision.
        part(folder,"Hampe verticale",base,Vector3.new(s*12.4,15,-depth/2-0.8),Vector3.new(0.3,10,0.3),dark,Enum.Material.Metal,false)
        part(folder,"Bannière",base,Vector3.new(s*12.4,14.5,-depth/2-1.4),Vector3.new(3.2,6.6,0.15),accent,Enum.Material.Fabric,false)
        part(folder,"Pointe bannière",base,Vector3.new(s*12.4,10.7,-depth/2-1.4),Vector3.new(0.85,0.6,0.25),pale,Enum.Material.Metal,false)
    end
    local levels=math.max(1,math.min(5,math.floor(height/9)))
    local count=math.max(2,math.min(8,math.floor(width/12)))
    for floor=1,levels do
        local y=6+floor*6
        if y<height-4 then
            for n=1,count do
                local x=-width/2+n*width/(count+1)
                -- Encadrements, tableaux de fenêtre et garde-corps visuels.
                local z=-depth/2-0.47
                part(folder,"Linteau sculpté",base,Vector3.new(x,y+2.25,z),Vector3.new(5,0.45,0.55),trim,Enum.Material.Marble,false)
                part(folder,"Appui de fenêtre",base,Vector3.new(x,y-2.35,z),Vector3.new(5.2,0.48,0.8),trim,Enum.Material.Marble,false)
                part(folder,"Croisée verticale",base,Vector3.new(x,y,z-0.2),Vector3.new(0.17,4.3,0.25),dark,Enum.Material.Metal,false)
                part(folder,"Croisée horizontale",base,Vector3.new(x,y,z-0.2),Vector3.new(4.0,0.14,0.25),dark,Enum.Material.Metal,false)
                if floor%2==0 and n%2==0 then
                    part(folder,"Balcon décoratif",base,Vector3.new(x,y-2.7,z-1.1),Vector3.new(6.2,0.35,2.4),accent,Enum.Material.Metal,false)
                    part(folder,"Garde-corps balcon",base,Vector3.new(x,y-0.85,z-2.1),Vector3.new(6.2,2.4,0.25),dark,Enum.Material.Metal,false)
                end
            end
        end
    end
    -- Silhouette de toit : lucarnes et lanternon. Limiter les détails sur les petites façades.
    for n=-2,2 do
        local x=n*(width-13)/6
        part(folder,"Lucarne principale",base,Vector3.new(x,height+2,0),Vector3.new(5,4,5),trim,Enum.Material.Marble,false)
        part(folder,"Verrière de lucarne",base,Vector3.new(x,height+2,-2.7),Vector3.new(3.6,2.4,0.17),Color3.fromRGB(92,175,195),Enum.Material.Glass,false)
    end
    part(folder,"Lanternon de toiture",base,Vector3.new(0,height+4,0),Vector3.new(10,6,10),Color3.fromRGB(68,112,126),Enum.Material.Glass,false)
    part(folder,"Chapeau du lanternon",base,Vector3.new(0,height+7.2,0),Vector3.new(12,0.75,12),accent,Enum.Material.Metal,false)
    return folder
end
return Detail

]])
source(server,"FacadeGenerator","ModuleScript",[[
--!strict
local Factory = require(script.Parent.Factory)
local ArchitecturePlus = require(script.Parent.ArchitecturePlus)
local FacadeDetail = require(script.Parent.FacadeDetail)
local HeritageFacadesV16 = require(script.Parent.HeritageFacadesV16)
local CrystalFacades = require(script.Parent.CrystalFacades)
local CrystalPorticosV19 = require(script.Parent.CrystalPorticosV19)
local SkylineV22=require(script.Parent.InstitutionSkylineV22)
local FacadeKitV24=require(script.Parent.InstitutionFacadeKitV24)
local FacadeGenerator = {}

local function element(parent, name, size, frame, offset, color, material)
    return Factory.part(parent,name,size,frame*CFrame.new(offset),color,material)
end

function FacadeGenerator.make(parent, structure, building, style)
    local model=Instance.new("Model")
    model.Name=building.name
    model:SetAttribute("KinBuildingId",building.building_id)
    model.Parent=parent
    local cx,cy,cz=table.unpack(structure.center_studs)
    local w,d=table.unpack(structure.footprint_studs)
    local h=structure.height_studs
    local yaw=structure.yaw_degrees
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(yaw),0)
    local walls=Factory.hex(style.palette.wall)
    local trim=Factory.hex(style.palette.trim)
    local accent=Factory.hex(style.palette.accent)
    local glazing=Color3.fromRGB(197,244,240)
    local function mineralPane(name,size,offset)
        local pane=element(model,name,size,base,offset,glazing,Enum.Material.SmoothPlastic)
        pane.CanCollide=false;pane.CanTouch=false;pane.CanQuery=false;pane.CastShadow=false
        pane.Reflectance=0.09
        pane:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
        return pane
    end
    element(model,"BuildingCore",Vector3.new(w,h,d),base,Vector3.new(0,h/2,0),walls,Enum.Material.Concrete)
    element(model,"BasePlinth",Vector3.new(w+3,1,d+3),base,Vector3.new(0,0.5,0),trim,Enum.Material.Slate)
    element(model,"Cornice",Vector3.new(w+3,1.5,d+3),base,Vector3.new(0,h-1,0),trim,Enum.Material.Concrete)
    element(model,"Roof",Vector3.new(w+2,1,d+2),base,Vector3.new(0,h,0),accent,Enum.Material.Metal)
    -- Fenêtres par bandes et corniches, contrôlées par la hauteur réelle.
    local levels = math.max(1,math.floor((h-8)/8))
    local count=math.max(2,math.floor((w-12)/9))
    for level=1,levels do
        local y=5+level*6
        if y<h-3 then
            for col=1,count do
                local x=-w/2 + col*w/(count+1)
                mineralPane("WindowFront",Vector3.new(3.6,3.8,0.25),Vector3.new(x,y,-d/2-0.17))
                mineralPane("WindowBack",Vector3.new(3.6,3.8,0.25),Vector3.new(x,y,d/2+0.17))
            end
        end
    end
    for i=1,math.max(2, math.floor((d-10)/11)) do
        local z=-d/2 + i*d/(math.max(2,math.floor((d-10)/11))+1)
        mineralPane("SideWindowL",Vector3.new(0.22,4.3,3.5),Vector3.new(-w/2-0.13,h*0.49,z))
        mineralPane("SideWindowR",Vector3.new(0.22,4.3,3.5),Vector3.new(w/2+0.13,h*0.49,z))
    end
    -- Façade d'entrée bien visible (ne prétend pas avoir une ouverture géométrique : transition au prompt).
    element(model,"MainEntrance",Vector3.new(9,8,0.75),base,Vector3.new(0,4,-d/2-0.6),Color3.fromRGB(45,60,65),Enum.Material.Metal)
    for side=-1,1,2 do
        element(model,"EntranceColumn",Vector3.new(1.4,10,1.4),base,Vector3.new(side*6.5,5,-d/2-1.2),trim,Enum.Material.Marble)
    end
    Factory.sign(model,"BuildingSign",(base*CFrame.new(0,math.min(h-3,13),-d/2-1.25)).Position,yaw,building.name,math.min(w-12,40),3.3)
    if style.roof=="spire" then
        element(model,"Spire",Vector3.new(3,math.min(15,h*0.32),3),base,Vector3.new(0,h+math.min(15,h*0.32)/2,0),accent,Enum.Material.Metal)
    elseif style.roof=="gable" then
        element(model,"RoofRidge",Vector3.new(w+2,2.5,4),base,Vector3.new(0,h+1,0),accent,Enum.Material.Slate)
    end
    ArchitecturePlus.decorate(model,structure,building,style)
    FacadeDetail.make(model,structure,building,style)
    HeritageFacadesV16.make(model,structure,building,style)
    CrystalFacades.make(model,structure,building,style)
    CrystalPorticosV19.make(model,structure,building,style)
    SkylineV22.make(model,structure,building)
    FacadeKitV24.make(model,structure,building)
    return model
end

return FacadeGenerator

]])
source(server,"Factory","ModuleScript",[[
--!strict
-- Primitives natives. Aucune ressource Toolbox et aucun asset payant.
local Factory = {}

function Factory.part(parent, name, size, frame, color, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = frame
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = true
    part.CastShadow = true
    part.Parent = parent
    return part
end

function Factory.folder(parent, name)
    local f = Instance.new("Folder")
    f.Name = name
    f.Parent = parent
    return f
end

function Factory.sign(parent, name, position, yaw, text, width, height)
    local rotation = CFrame.Angles(0, math.rad(yaw or 0), 0)
    local board = Factory.part(parent, name, Vector3.new(width or 15, height or 3.4, 0.35), CFrame.new(position) * rotation, Color3.fromRGB(18, 62, 60), Enum.Material.Metal)
    board.CanCollide = false
    local sg = Instance.new("SurfaceGui")
    sg.Name = "ReadableSign"
    sg.Face = Enum.NormalId.Front
    sg.CanvasSize = Vector2.new(900, 200)
    sg.PixelsPerStud = 42
    sg.LightInfluence = 0
    sg.Parent = board
    local txt = Instance.new("TextLabel")
    txt.Name = "Text"
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.fromScale(1, 1)
    txt.Text = text
    txt.TextScaled = true
    txt.TextWrapped = true
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = Color3.fromRGB(237, 253, 252)
    txt.Parent = sg
    return board
end

function Factory.light(parent, pos, brightness, range)
    local bulb = Factory.part(parent, "LightBulb", Vector3.new(0.6, 0.3, 0.6), CFrame.new(pos), Color3.fromRGB(255, 242, 199), Enum.Material.Neon)
    bulb.CanCollide = false
    local light = Instance.new("PointLight")
    light.Brightness = brightness or 1.3
    light.Range = range or 30
    light.Shadows = false
    light.Parent = bulb
    return bulb
end

function Factory.prompt(part, verb, subject)
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "KinCityPrompt"
    prompt.ActionText = verb
    prompt.ObjectText = subject
    prompt.MaxActivationDistance = 11
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0.1
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    prompt.Parent = part
    return prompt
end

function Factory.hex(colorHex)
    local clean = string.gsub(colorHex, "#", "")
    return Color3.fromRGB(tonumber(string.sub(clean,1,2),16) or 128,tonumber(string.sub(clean,3,4),16) or 128,tonumber(string.sub(clean,5,6),16) or 128)
end

return Factory

]])
source(server,"HarborAndTrailsRuntime","ModuleScript",[[
--!strict
-- Interactions locales pour marinas, maisons insulaires et sentiers.
-- Tous les compteurs sont éphémères (session). Aucune autorité kOA, réseau ou DataStore.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local Limiter=require(script.Parent.RateLimiter)
local Runtime={}
local marinaSeen={}
local roomsSeen={}
local trailsSeen={}
local rotating={}
local function send(reply,player,title,msg,notice)
    if player.Parent==Players then
        reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=msg,notice=notice or "Activité locale • aucun service kOA sollicité."})
    end
end
local function findPart(model,attribute,id)
    for _,desc in ipairs(model:GetDescendants()) do
        if desc:IsA("BasePart") and desc:GetAttribute(attribute)==id then return desc end
    end
    return nil
end
local function register(player)
    marinaSeen[player]={};roomsSeen[player]={};trailsSeen[player]={}
    player:SetAttribute("KinMarinaDiscoveries",0)
    player:SetAttribute("KinMarinaTotal",2)
    player:SetAttribute("KinAnnexRoomsVisited",0)
    player:SetAttribute("KinAnnexRoomsTotal",12)
    player:SetAttribute("KinIslandTrailVisits",0)
    player:SetAttribute("KinIslandTrailTotal",24)
end
local function mark(player,registry,key,attribute)
    local discovered=registry[player]
    if not discovered or discovered[key] then return false end
    discovered[key]=true
    local count=0
    for _ in pairs(discovered) do count+=1 end
    player:SetAttribute(attribute,count)
    return true
end
local function interactionInReach(prompt,player,world)
    local host=prompt.Parent
    if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return nil end
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health<=0 or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return nil end
    return host
end
local function marinaAction(host,player,reply)
    local action=host:GetAttribute("KinMarinaAction")
    local id=host:GetAttribute("KinMarinaId")
    if type(id)~="string" or (action~="beacon" and action~="crane" and action~="collect") then return false end
    local building=host.Parent
    if not building or not building:IsA("Model") or building:GetAttribute("KinMarinaId")~=id then return false end
    if not Limiter.allowed(player,"marina/"..id.."/"..action,0.9) then return true end
    if action=="collect" then
        local fresh=mark(player,marinaSeen,id,"KinMarinaDiscoveries")
        send(reply,player,building.Name,if fresh then "Nouveau port inscrit dans ton carnet maritime !" else "Cette marina figure déjà dans ton carnet.",
            string.format("Marinas visitées : %d/2",player:GetAttribute("KinMarinaDiscoveries") or 0))
    elseif action=="beacon" then
        local on=not (building:GetAttribute("KinMarinaLightActive")==false)
        building:SetAttribute("KinMarinaLightActive",not on)
        local lens=findPart(building,"KinMarinaLightLens",id)
        if lens then
            lens.Material=if on then Enum.Material.Glass else Enum.Material.Neon
            lens.Transparency=if on then 0.55 else 0.02
        end
        local beam=findPart(building,"KinMarinaBeam",id)
        if beam then beam.Transparency=if on then 1 else 0.25 end
        send(reply,player,"Phare de la marina",if on then "Phare éteint." else "Phare allumé : le faisceau balaye le lac.")
    elseif action=="crane" then
        local arm=findPart(building,"KinMarinaCraneArm",id)
        if arm then
            local rest=arm:GetAttribute("KinCraneHome")
            if typeof(rest)~="CFrame" then rest=arm.CFrame;arm:SetAttribute("KinCraneHome",rest) end
            local active=not (building:GetAttribute("KinCraneExtended")==true)
            building:SetAttribute("KinCraneExtended",active)
            TweenService:Create(arm,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),
                {CFrame=if active then rest*CFrame.Angles(0,math.rad(64),0) else rest}):Play()
        end
        send(reply,player,"Grue du port","La grue effectue sa manoeuvre locale.")
    end
    return true
end
local function annexAction(host,player,reply)
    local id=host:GetAttribute("KinAnnexExperienceId")
    if type(id)~="string" then return false end
    local model=host.Parent
    local islandId=host:GetAttribute("KinAnnexIslandId")
    if not model or not model:IsA("Model") or model:GetAttribute("KinAnnexIslandId")~=islandId then return false end
    if not Limiter.allowed(player,"annex/"..id,0.9) then return true end
    mark(player,roomsSeen,id,"KinAnnexRoomsVisited")
    local active=not (host:GetAttribute("KinAnnexActive")==true)
    host:SetAttribute("KinAnnexActive",active)
    local stem=id:match("%.room%.([AB])$")
    if stem then
        local z=if stem=="A" then 6 else 28
        local consolePos=host.Position
        for _,obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") and obj:GetAttribute("KinAnnexReactive")==true and obj:GetAttribute("KinAnnexRoomZ")==z then
                TweenService:Create(obj,TweenInfo.new(0.65),{Transparency=if active then 0.02 else 0.55}):Play()
            end
        end
    end
    send(reply,player,"Maison des découvertes",if active then "Les collections de cette salle s'illuminent." else "La salle retrouve son éclairage de repos.",
        string.format("Salles découvertes : %d/12",player:GetAttribute("KinAnnexRoomsVisited") or 0))
    return true
end
local function trailAction(host,player,reply)
    local id=host:GetAttribute("KinIslandTrailId")
    if type(id)~="string" then return false end
    local n=host:GetAttribute("KinTrailStopNumber")
    if type(n)~="number" or n<1 or n>4 then return false end
    if not Limiter.allowed(player,"trail/"..id,0.5) then return true end
    local fresh=mark(player,trailsSeen,id,"KinIslandTrailVisits")
    send(reply,player,"Sentier de l'archipel",if fresh then "Nouvelle halte de randonnée découverte !" else "Tu connais déjà cette halte.",
        string.format("Haltes insulaires : %d/24",player:GetAttribute("KinIslandTrailVisits") or 0))
    return true
end
function Runtime.start(world,reply)
    Players.PlayerAdded:Connect(register)
    for _,p in ipairs(Players:GetPlayers()) do register(p) end
    Players.PlayerRemoving:Connect(function(p) marinaSeen[p]=nil;roomsSeen[p]=nil;trailsSeen[p]=nil end)
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("KinMarinaBeam") then
            local model=obj.Parent
            local id=obj:GetAttribute("KinMarinaBeam")
            if model and model:IsA("Model") then
                model:SetAttribute("KinMarinaLightActive",true)
                local lens=findPart(model,"KinMarinaLightLens",id)
                if lens then table.insert(rotating,{beam=obj,lens=lens,marina=model,angle=0}) end
            end
        end
    end
    local accumulator=0
    local heartbeat=RunService.Heartbeat:Connect(function(dt)
        accumulator+=dt
        if accumulator<0.12 then return end
        local step=accumulator;accumulator=0
        if not world.Parent then return end
        for _,entry in ipairs(rotating) do
            if entry.beam.Parent and entry.lens.Parent and entry.marina:GetAttribute("KinMarinaLightActive")==true then
                entry.angle=(entry.angle+step*0.8)%(math.pi*2)
                local center=entry.lens.Position
                entry.beam.CFrame=CFrame.new(center)*CFrame.Angles(0,entry.angle,0)*CFrame.new(0,0,-9)
            end
        end
    end)
    world.Destroying:Connect(function() heartbeat:Disconnect() end)
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled or not player then return end
        local host=interactionInReach(prompt,player,world)
        if not host then return end
        if host:GetAttribute("KinMarinaAction") then
            marinaAction(host,player,reply)
        elseif host:GetAttribute("KinAnnexExperienceId") then
            annexAction(host,player,reply)
        elseif host:GetAttribute("KinIslandTrailId") then
            trailAction(host,player,reply)
        end
    end)
end
return Runtime

]])
source(server,"HeritageFacadesV16","ModuleScript",[[
--!strict
-- Kin City v16 : façades emblématiques propres aux huit institutions.
-- Ornements non-collidables devant la façade : les portes restent accessibles.
local F=require(script.Parent.Factory)
local Facades={}
local COLD=Color3.fromRGB(37,60,71)
local WARM=Color3.fromRGB(233,216,176)
local GLASS=Color3.fromRGB(143,213,221)
local STYLES={
    city_hall={"HÔTEL DE VILLE","city",Color3.fromRGB(229,183,112)},
    ekoh_tower={"LA TOUR DES SAVOIRS","network",Color3.fromRGB(97,215,192)},
    library={"GRANDE BIBLIOTHÈQUE","books",Color3.fromRGB(142,195,225)},
    campus={"UNIVERS-CITÉ","orbits",Color3.fromRGB(183,157,226)},
    justice_palace={"PALAIS DES ÉQUILIBRES","balance",Color3.fromRGB(222,189,131)},
    innovation_lab={"LABORATOIRE D'INNOVATION","turbine",Color3.fromRGB(94,214,226)},
    museum={"MUSÉE KREATIVE","art",Color3.fromRGB(229,144,165)},
    orgo_center={"CENTRE ORGO","network",Color3.fromRGB(138,184,232)},
}
local function p(parent,name,base,x,y,z,sx,sy,sz,color,mat)
    local q=F.part(parent,name,Vector3.new(sx,sy,sz),base*CFrame.new(x,y,z),color,mat)
    q.CanCollide=false;q.CanTouch=false;q.CanQuery=false
    return q
end
local function orb(parent,name,base,x,y,z,size,color)
    local q=p(parent,name,base,x,y,z,size,size,size,color,Enum.Material.Glass)
    q.Shape=Enum.PartType.Ball
    return q
end
local function link(parent,base,a,b,size,color)
    local from=(base*CFrame.new(a)).Position
    local dest=(base*CFrame.new(b)).Position
    local delta=dest-from
    local part=F.part(parent,"Liaison sculpturale",Vector3.new(size,size,delta.Magnitude),CFrame.lookAt((from+dest)*0.5,dest),color,Enum.Material.Metal)
    part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
end
local function motif(parent,base,kind,accent,front,w,height)
    local y=math.min(height-7,math.max(13,height*0.65))
    if kind=="city" then
        for i=-3,3 do
            p(parent,"Colonnade citoyenne",base,i*4.3,y*0.46,front-0.55,0.65,y*0.8,0.65,accent,Enum.Material.Marble)
        end
        p(parent,"Frise civique",base,0,y*0.88,front-0.7,33,1.1,0.8,WARM,Enum.Material.Marble)
        orb(parent,"Hologramme central",base,0,y+1.5,front-1.5,3.6,accent)
    elseif kind=="books" then
        for n=1,9 do
            local x=-20+(n-1)*5
            local h=4+(n%3)*2
            local book=p(parent,"Ouvrage architectural",base,x,y,front-0.65,3.1,h,0.5,if n%2==0 then accent else WARM,Enum.Material.Marble)
            book.CFrame=book.CFrame*CFrame.Angles(0,0,math.rad((n%3-1)*5))
        end
    elseif kind=="orbits" then
        orb(parent,"Soleil du campus",base,0,y,front-1,4.5,WARM)
        for n=1,8 do
            local a=2*math.pi*n/8
            local x=math.cos(a)*14
            local yy=y+math.sin(a)*7
            orb(parent,"Astres du savoir",base,x,yy,front-1.1,1.5+(n%3)*0.4,accent)
            if n%2==0 then link(parent,base,Vector3.new(0,y,front-1),Vector3.new(x,yy,front-1.1),0.22,WARM) end
        end
    elseif kind=="balance" then
        p(parent,"Axe de la justice",base,0,y,front-1,0.9,12,0.8,WARM,Enum.Material.Marble)
        p(parent,"Traverse de l'équilibre",base,0,y+4.8,front-1,25,0.8,0.8,accent,Enum.Material.Metal)
        for _,side in ipairs({-1,1}) do
            p(parent,"Suspension",base,side*10, y+1.7,front-1,0.3,6,0.3,WARM,Enum.Material.Metal)
            p(parent,"Plateau",base,side*10, y-1.5,front-1,5.5,0.5,4.3,accent,Enum.Material.Metal)
        end
    elseif kind=="turbine" then
        orb(parent,"Coeur mécanique",base,0,y,front-1,5,accent)
        for n=1,10 do
            local a=n*2*math.pi/10
            local blade=p(parent,"Pale architecturale",base,math.cos(a)*9,y+math.sin(a)*7,front-1,4.2,1.0,0.5,if n%2==0 then accent else WARM,Enum.Material.Metal)
            blade.CFrame=blade.CFrame*CFrame.Angles(0,0,a)
        end
    elseif kind=="art" then
        for n=1,11 do
            local x=-22+n*4
            local yy=y+math.sin(n*0.9)*5
            local s=p(parent,"Vitrail sculptural",base,x,yy,front-1,2.4,4.8,0.35,Color3.fromHSV(n/11,0.53,0.92),Enum.Material.Glass)
            s.Transparency=0.16
        end
    else
        local nodes={}
        for n=1,9 do
            local a=n*2*math.pi/9
            local v=Vector3.new(math.cos(a)*17,y+math.sin(a)*6,front-1)
            nodes[n]=v
            orb(parent,"Noeud de savoir",base,v.X,v.Y,v.Z,1.8,accent)
        end
        for n=1,9 do
            link(parent,base,nodes[n],nodes[n%9+1],0.3,WARM)
        end
    end
end
function Facades.make(model,structure,building,style)
    local key=building.interior_place_key
    local subject=STYLES[key]
    if not subject then return nil end
    local cx,cy,cz=table.unpack(structure.center_studs)
    local w,d=table.unpack(structure.footprint_studs)
    local h=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local accent=subject[3]
    local folder=F.folder(model,"Façade emblématique v16")
    local front=-d/2-1.8
    -- Strates horizontales et trame de vitraux à faible coût en primitives.
    for _,heightFraction in ipairs({0.28,0.5,0.75}) do
        local y=h*heightFraction
        p(folder,"Ruban de pierre",base,0,y,front+1,math.min(w-5,70),0.45,0.6,accent,Enum.Material.Marble)
    end
    for _,s in ipairs({-1,1}) do
        local x=s*math.min(w*0.38,29)
        p(folder,"Ailette de façade",base,x,h*0.5,front+0.8,0.65,h*0.72,1.2,accent,Enum.Material.Metal)
        for y=10,math.max(10,h-8),9 do
            local glass=p(folder,"Vitrail de quartier",base,x-s*3,y,front+0.25,2.7,4.5,0.25,GLASS,Enum.Material.Glass)
            glass.Transparency=0.25
        end
        p(folder,"Colonne monumentale",base,s*12,7.2,front-1,1.4,14.4,1.5,WARM,Enum.Material.Marble)
        p(folder,"Chapiteau monumental",base,s*12,14.6,front-1,3,1,2.5,accent,Enum.Material.Marble)
    end
    -- Le motif est au-dessus du seuil; aucune pièce ne barre la porte centrale.
    motif(folder,base,subject[2],accent,front,w,h)
    return folder
end
return Facades

]])
source(server,"InstitutionCraftV20","ModuleScript",[[
--!strict
-- Kin City v20 — mobilier sculpté/minéral pour les six pièces de chaque institution.
-- Éléments purement architecturaux, jamais de remplacement des interactions canoniques.
local Factory=require(script.Parent.Factory)
local Kit=require(script.Parent.CrystalKit)
local Craft={}
local signatures={
    city_hall="civic", ekoh_tower="knowledge", library="archive", campus="orbit",
    justice_palace="balance", innovation_lab="mechanism", museum="art", orgo_center="network"
}
local function decor(parent,kind,name,size,frame,color,material,optional)
    local part=Kit.part(parent,kind,name,size,frame,color,material)
    if optional then part:SetAttribute("KinOptionalDetail",true) end
    return part
end
local function cabinet(parent,base,label,accent,signature,seed,light)
    local m=Instance.new("Model");m.Name=label;m.Parent=parent
    m:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    local xSize=7.2
    decor(m,"Part","Socle en pierre",Vector3.new(xSize,0.7,2.3),base*CFrame.new(0,0.35,0),Kit.deep,Enum.Material.Slate,false)
    for _,side in ipairs({-1,1}) do
        decor(m,"Part","Pilastre sarcelle",Vector3.new(0.48,5.4,1.7),base*CFrame.new(side*3.15,3,0),Kit.primary,Enum.Material.Marble,false)
    end
    for layer=1,2 do
        decor(m,"Part","Tablette gravée",Vector3.new(6.7,0.24,1.9),base*CFrame.new(0,1.2+layer*1.5,0),Kit.gold,Enum.Material.Metal,false)
    end
    decor(m,"Part","Fronton minéral",Vector3.new(7.5,0.46,2.1),base*CFrame.new(0,6.1,0),Kit.medium,Enum.Material.Slate,false)
    local accentPiece=decor(m,"WedgePart","Gemme taillée",Vector3.new(2.0,2.3,1.3),
        base*CFrame.new(0,4.9,-0.25)*CFrame.Angles(0,math.rad((seed%3)*23),0),accent,Enum.Material.Slate,false)
    accentPiece:SetAttribute("KinInstitutionSignature",signature)
    -- Une texture de silhouettes propre à l'institution, par volumes simples.
    if signature=="archive" or signature=="knowledge" then
        for n=1,3 do
            decor(m,"Part","Volume d'archives",Vector3.new(0.75,1.25+0.15*(n%2),0.85),
                base*CFrame.new((n-2)*1.15,1.2+1.5+0.7,-0.5),
                if n%2==0 then Kit.gold else accent,Enum.Material.Slate,true)
        end
    elseif signature=="orbit" or signature=="network" then
        for n=1,3 do
            local a=(n-1)*math.pi*2/3
            local orb=decor(m,"Part","Nœud de savoir",Vector3.new(0.8,0.8,0.8),
                base*CFrame.new(math.cos(a)*2.2,2.0+math.sin(a)*0.7,-0.65),accent,Enum.Material.Neon,true)
            orb.Shape=Enum.PartType.Ball
        end
    elseif signature=="balance" or signature=="civic" then
        decor(m,"Part","Barre d'équilibre",Vector3.new(4.7,0.2,0.3),base*CFrame.new(0,3.6,-1.1),Kit.gold,Enum.Material.Metal,true)
    else
        for n=1,2 do
            local tile=decor(m,"WedgePart","Étude facettée",Vector3.new(1.1,1.4,1.0),
                base*CFrame.new((n-1.5)*3.7,2.1,-0.65)*CFrame.Angles(0,n*0.6,0),
                if n==1 then accent else Kit.gold,Enum.Material.Slate,true)
        end
    end
    if light then
        decor(m,"Part","Filet lumineux",Vector3.new(6.5,0.12,0.24),
            base*CFrame.new(0,6.45,-0.6),Kit.opal,Enum.Material.Neon,true)
    end
    return m
end
function Craft.decorate(roomFolder,placeKey,room,origin,roomIndex)
    local x,_,z=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<20 or d<20 then return end
    local signature=signatures[placeKey] or "civic"
    local root=Instance.new("Folder")
    root.Name="Ébénisterie cristalline v20"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    root.Parent=roomFolder
    local accent=Kit.accent(placeKey)
    -- Sur les deux côtés du mur arrière, loin du passage central de porte.
    -- Les meubles sont sans collision pour préserver la circulation au sein des pièces.
    local count=if Kit.profile=="LITE" then 1 else 2
    for n=1,count do
        local side=if n==1 then -1 else 1
        local bx=x+side*(w/2-5.7)
        local bz=z+d/2-3.4
        local base=CFrame.new(origin+Vector3.new(bx,0,bz))*CFrame.Angles(0,math.pi,0)
        cabinet(root,base,"Vitrine institutionnelle "..n,accent,signature,roomIndex+n,Kit.profile=="SHOWCASE" or roomIndex==1)
    end
    return root
end
return Craft

]])
source(server,"InstitutionDiscoveryRuntime","ModuleScript",[[
--!strict
-- Kin City v16 : fonctionnement des expositions physiques; aucune opération kOA.
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
local OFF=Color3.fromRGB(63,82,91)
local TOTAL=16
local function send(remote,player,title,message)
    if player.Parent~=Players then return end
    remote:FireClient(player,{
        kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=message,
        notice="Installation locale · aucun service kOA",
    })
end
local function eligible(prompt,host,player,world)
    if not prompt.Enabled or not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return false end
    local zone=host:GetAttribute("KinV16PlaceKey")
    if type(zone)~="string" or player:GetAttribute("KinZone")~=zone then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return hum~=nil and hum.Health>0 and root~=nil and (root.Position-host.Position).Magnitude<=prompt.MaxActivationDistance+3
end
local function spin(model,seconds,turns)
    local start=model:GetPivot()
    local begun=os.clock()
    while model.Parent and model:IsDescendantOf(workspace) do
        local a=math.clamp((os.clock()-begun)/seconds,0,1)
        local eased=a*a*(3-2*a)
        model:PivotTo(start*CFrame.Angles(0,eased*math.pi*2*turns,0))
        if a>=1 then break end
        RunService.Heartbeat:Wait()
    end
    if model.Parent then model:PivotTo(start) end
end
function Runtime.start(world,remote)
    local machines={}
    local lamps={}
    local active={}
    local lightOn={}
    local visited={}
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("Model") then
            local id=obj:GetAttribute("KinV16MechanismId")
            if type(id)=="string" then machines[id]=obj end
        elseif obj:IsA("BasePart") then
            local place=obj:GetAttribute("KinV16LampPlace")
            if type(place)=="string" then
                lamps[place]=lamps[place] or {}
                table.insert(lamps[place],{part=obj,color=obj.Color})
                lightOn[place]=true
            end
        end
    end
    Players.PlayerRemoving:Connect(function(player) visited[player]=nil end)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local action=host:GetAttribute("KinV16Action")
        if action~="mechanism" and action~="lighting" then return end
        if not eligible(prompt,host,player,world) then return end
        local place=host:GetAttribute("KinV16PlaceKey")
        if type(place)~="string" then return end
        if action=="lighting" then
            if not RateLimiter.allowed(player,"winglight/"..place,0.8) then return end
            local nextState=not lightOn[place]
            lightOn[place]=nextState
            for _,rec in ipairs(lamps[place] or {}) do
                local lamp=rec.part
                if lamp.Parent then
                    lamp.Material=if nextState then Enum.Material.Neon else Enum.Material.Metal
                    lamp.Color=if nextState then rec.color else OFF
                    local light=lamp:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=nextState end
                end
            end
            send(remote,player,"Grande galerie",if nextState then "L'éclairage de la galerie est activé." else "La galerie passe en ambiance douce.")
            return
        end
        local id=host:GetAttribute("KinV16MechanismId")
        if type(id)~="string" then return end
        if not RateLimiter.allowed(player,"wing/"..id,1) then return end
        local model=machines[id]
        if not model or not model.Parent then return end
        if active[id] then
            send(remote,player,"Galerie des découvertes","La démonstration est déjà en cours.")
            return
        end
        active[id]=true
        local records=visited[player]
        if not records then records={};visited[player]=records end
        records[id]=true
        local count=0
        for _ in pairs(records) do count+=1 end
        send(remote,player,"Galerie des découvertes","Démonstration activée. Oeuvres distinctes découvertes : "..count.." / "..TOTAL..".")
        task.spawn(function()
            local ok,err=pcall(spin,model,5,2)
            if not ok then warn("Kin City v16 : mécanisme",id,err) end
            active[id]=nil
        end)
    end)
end
return Runtime

]])
source(server,"InstitutionDiscoveryWings","ModuleScript",[[
--!strict
-- Kin City v16 : huit ailes d'exposition visitables, rattachées physiquement
-- à l'atrium arrière de chaque institution. Constructions natives, sans asset distant.
-- Repère local de chaque intérieur : aile z=110..192, mezzanines à y=18.
-- Identifiants persistants : <place_key>.discovery.<01|02>.
local F=require(script.Parent.Factory)
local Wings={}

local INK=Color3.fromRGB(36,57,70)
local STONE=Color3.fromRGB(220,211,191)
local GOLD=Color3.fromRGB(204,166,103)
local GLASS=Color3.fromRGB(126,190,204)
local WOOD=Color3.fromRGB(127,87,63)
local THEMES={
    city_hall={"GALERIE DE LA CITÉ","Territoire en mouvement","Liens entre quartiers","urban",Color3.fromRGB(235,177,108)},
    ekoh_tower={"ATELIER DES SAVOIRS","Constellation de concepts","Arbre des découvertes","network",Color3.fromRGB(98,220,189)},
    library={"GRANDE AILE DES ARCHIVES","Bibliothèque cinétique","Mémoires en mouvement","books",Color3.fromRGB(141,188,230)},
    campus={"GALERIE DES SCIENCES","Orbites pédagogiques","Cycle des planètes","orbits",Color3.fromRGB(181,161,230)},
    justice_palace={"ESPACE DES ÉQUILIBRES","Mécanique des équilibres","Symétries du monde","balance",Color3.fromRGB(234,192,131)},
    innovation_lab={"FABRIQUE DES IDÉES","Assemblage inventif","Moteur des possibles","turbine",Color3.fromRGB(100,208,228)},
    museum={"GALERIE DES FORMES","Sculpture chromatique","Mouvement du patrimoine","art",Color3.fromRGB(234,145,174)},
    orgo_center={"ATELIER DES RÉSEAUX","Topologie des services","Circulation des flux","network",Color3.fromRGB(139,192,239)},
}

local function part(parent,name,origin,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),CFrame.new(origin+Vector3.new(x,y,z)),color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function orb(parent,name,origin,x,y,z,diameter,color,material)
    local p=part(parent,name,origin,x,y,z,diameter,diameter,diameter,color,material,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function beam(parent,name,origin,a,b,thickness,color)
    local delta=b-a
    local center=(a+b)*0.5
    local p=F.part(parent,name,Vector3.new(thickness,thickness,delta.Magnitude),
        CFrame.lookAt(origin+center,origin+b),color,Enum.Material.Metal)
    p.CanCollide=false
    return p
end
local function rampStairs(parent,origin,x,accent,stone)
    -- 26 marches contiguës : la dernière rejoint la mezzanine y=18.
    local steps=26
    for i=1,steps do
        local rise=18*i/steps
        local z=119+(i-0.5)*1.5
        part(parent,"Escalier galerie · marche "..i,origin,x,rise/2,z,7,rise,1.56,stone,Enum.Material.Marble,true)
        if i%4==0 then
            for _,s in ipairs({-1,1}) do
                part(parent,"Montant de rampe",origin,x+s*3.95,rise+1.55,z,0.24,3.1,0.24,accent,Enum.Material.Metal,false)
            end
        end
    end
    for _,s in ipairs({-1,1}) do
        -- La rampe est un élément de décor haut, pour ne pas obstruer les marches.
        local start=Vector3.new(x+s*4,3.0,119)
        local finish=Vector3.new(x+s*4,21.0,157.5)
        beam(parent,"Rampe inclinée",origin,start,finish,0.32,accent)
    end
end
local function sculpture(parent,origin,x,z,kind,accent,variant,id)
    local platform=part(parent,"Socle de collection",origin,x,1.45,z,15,2.9,15,STONE,Enum.Material.Marble,true)
    part(parent,"Filet du socle",origin,x,2.9,z,15.4,0.22,15.4,GOLD,Enum.Material.Metal,false)
    local mobile=Instance.new("Model")
    mobile.Name="Oeuvre interactive · "..kind
    mobile:SetAttribute("KinV16MechanismId",id)
    mobile.Parent=parent
    local axis=part(mobile,"Pivot de l'oeuvre",origin,x,8,z,0.2,0.2,0.2,INK,Enum.Material.Metal,false)
    axis.Transparency=1
    mobile.PrimaryPart=axis
    if kind=="urban" then
        for i=1,8 do
            local a=2*math.pi*i/8
            local height=2.3+(i%4)*1.5
            part(mobile,"Miniature d'un quartier",origin,x+math.cos(a)*4.5,4+height/2,z+math.sin(a)*4.5,
                1.9,height,1.9,if i%2==0 then accent else GOLD,Enum.Material.Marble,false)
        end
        orb(mobile,"Coeur de cité",origin,x,8,z,3.5,accent,Enum.Material.Glass)
    elseif kind=="network" then
        local nodes={}
        for i=1,9 do
            local a=i*math.pi*2/9
            local point=Vector3.new(x+math.cos(a)*4.5,7+(i%3)*1.5,z+math.sin(a)*4.5)
            nodes[i]=point
            orb(mobile,"Noeud du savoir",origin,point.X,point.Y,point.Z,1.8,accent,Enum.Material.Neon)
        end
        for i=1,#nodes do
            local j=i%#nodes+1
            beam(mobile,"Lien des savoirs",origin,nodes[i],nodes[j],0.25,GOLD)
        end
    elseif kind=="books" then
        for i=1,7 do
            local angle=i*2*math.pi/7
            local q=part(mobile,"Livre sculptural",origin,x+math.cos(angle)*4,7+(i%3),z+math.sin(angle)*4,
                1.4,4,3,if i%2==0 then accent else GOLD,Enum.Material.WoodPlanks,false)
            q.CFrame=q.CFrame*CFrame.Angles(0,angle,0)
        end
    elseif kind=="orbits" then
        orb(mobile,"Soleil central",origin,x,8,z,4.2,GOLD,Enum.Material.Neon)
        for i=1,6 do
            local a=i*math.pi/3
            orb(mobile,"Planète pédagogique",origin,x+math.cos(a)*5,8+(i%3)*1.1,z+math.sin(a)*5,
                0.9+(i%3)*0.55,accent,Enum.Material.Glass)
        end
    elseif kind=="balance" then
        part(mobile,"Axe des équilibres",origin,x,8,z,0.8,9,0.8,GOLD,Enum.Material.Metal,false)
        part(mobile,"Traverse des équilibres",origin,x,12,z,11,0.65,0.65,accent,Enum.Material.Metal,false)
        for _,side in ipairs({-1,1}) do
            part(mobile,"Câble de plateau",origin,x+side*4.7,9.4,z,0.22,4.4,0.22,GOLD,Enum.Material.Metal,false)
            part(mobile,"Plateau des équilibres",origin,x+side*4.7,7.1,z,4.3,0.45,4.3,accent,Enum.Material.Metal,false)
        end
    elseif kind=="turbine" then
        part(mobile,"Mât de turbine",origin,x,8,z,1.1,9,1.1,INK,Enum.Material.Metal,false)
        for i=1,8 do
            local a=i*math.pi/4
            local blade=part(mobile,"Pale de turbine",origin,x+math.cos(a)*3,9,z+math.sin(a)*3,
                1.5,0.4,5.0,accent,Enum.Material.Metal,false)
            blade.CFrame=blade.CFrame*CFrame.Angles(0,a,math.rad(17))
        end
    else
        for i=1,8 do
            local a=2*math.pi*i/8
            local ball=orb(mobile,"Forme de couleur",origin,x+math.cos(a)*4.3,6+(i%4),z+math.sin(a)*4.3,
                1.7+(i%2)*0.6,Color3.fromHSV((i/8+variant*0.17)%1,0.5,0.92),Enum.Material.Glass)
            ball.Transparency=0.17
        end
    end
    local control=part(parent,"Commande de l'oeuvre",origin,x+9.1,2.3,z+8.8,3.7,4.6,2.4,INK,Enum.Material.Metal,true)
    part(parent,"Interface de l'oeuvre",origin,x+9.1,2.9,z+7.5,2.9,2.4,0.16,accent,Enum.Material.Neon,false)
    control:SetAttribute("KinV16Action","mechanism")
    control:SetAttribute("KinV16MechanismId",id)
    control:SetAttribute("KinV16PlaceKey",string.match(id,"^[^.]+") or "")
    control:SetAttribute("KinV16Title",if variant==1 then "Oeuvre A" else "Oeuvre B")
    F.prompt(control,"Animer","Galerie des découvertes")
    return platform
end
local function bench(parent,origin,x,z)
    local seat=Instance.new("Seat")
    seat.Name="Banc de galerie"
    seat.Anchored=true
    seat.Size=Vector3.new(5,0.7,2.6)
    seat.CFrame=CFrame.new(origin+Vector3.new(x,1.7,z))
    seat.Material=Enum.Material.WoodPlanks
    seat.Color=WOOD
    seat.Parent=parent
    part(parent,"Dossier du banc",origin,x,2.65,z+1.1,5,2.2,0.5,INK,Enum.Material.Metal,true)
end
local function cutOriginalWall(model,origin,trim)
    -- Ouvre réellement le mur arrière de l'atrium; une ouverture seulement
    -- visuelle empêcherait le visiteur de rejoindre cette nouvelle aile.
    local atrium=model:FindFirstChild("city_hall.rear_atrium")
    if not atrium then
        for _,child in ipairs(model:GetChildren()) do
            if child.Name:find("%.rear_atrium$",1,false) then atrium=child;break end
        end
    end
    if not atrium then error("Kin City : atrium arrière absent pour la nouvelle aile") end
    local removed=0
    for _,obj in ipairs(atrium:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name=="Wall_back" then
            obj:Destroy()
            removed+=1
        end
    end
    if removed==0 then error("Kin City : mur arrière introuvable") end
    part(atrium,"Mur arrière · ouest",origin,-29,8,104,42,16,0.85,trim,Enum.Material.Concrete,true)
    part(atrium,"Mur arrière · est",origin,29,8,104,42,16,0.85,trim,Enum.Material.Concrete,true)
    part(atrium,"Linteau de galerie",origin,0,14.5,104,16,3,1,trim,Enum.Material.Marble,true)
end
function Wings.make(model,key,origin,style)
    local theme=THEMES[key]
    if not theme then return nil end
    local trim=F.hex(style.palette.trim)
    local accent=F.hex(style.palette.accent)
    local wall=F.hex(style.palette.wall)
    local section=F.folder(model,"Aile des découvertes v16")
    section:SetAttribute("KinV16PlaceKey",key)
    cutOriginalWall(model,origin,wall)
    -- Le seuil relie sans trou l'atrium historique (jusqu'à z=104) au nouveau volume.
    part(section,"Seuil de l'aile",origin,0,-0.5,106.5,18,1,7,trim,Enum.Material.Marble,true)
    part(section,"Sol de la grande galerie",origin,0,-0.5,150.5,92,1,83,trim,Enum.Material.Marble,true)
    for _,s in ipairs({-1,1}) do
        part(section,"Mur latéral de galerie",origin,s*46,9,150.5,1.1,18,83,wall,Enum.Material.Concrete,true)
        part(section,"Portique de la nouvelle aile",origin,s*27,9,109,38,18,1,wall,Enum.Material.Concrete,true)
        for z=119,179,12 do
            local window=part(section,"Fenêtre haute",origin,s*46.8,10.4,z,0.24,6.6,6.2,GLASS,Enum.Material.Glass,false)
            window.Transparency=0.19
            part(section,"Cadre de fenêtre",origin,s*47,14.0,z,0.35,0.65,7.0,accent,Enum.Material.Metal,false)
        end
    end
    part(section,"Mur du fond",origin,0,9,192,93,18,1,wall,Enum.Material.Concrete,true)
    part(section,"Linteau d'entrée",origin,0,14.5,109,17,3.0,1,accent,Enum.Material.Metal,true)
    -- Deux mezzanines reliées à l'arrière, accès par escaliers physiques.
    for _,s in ipairs({-1,1}) do
        part(section,"Mezzanine",origin,s*36.5,17.5,174,17,1,32,trim,Enum.Material.Marble,true)
        -- Garde-corps interrompu au raccord de la passerelle (z=173..185) :
        -- sans cette ouverture, la mezzanine serait visuellement connectée mais impraticable.
        part(section,"Garde-corps avant",origin,s*27.7,20.0,165,0.65,3.8,12,accent,Enum.Material.Metal,true)
        part(section,"Garde-corps arrière",origin,s*27.7,20.0,188,0.65,3.8,4,accent,Enum.Material.Metal,true)
        for z=164,184,10 do
            part(section,"Potelet de mezzanine",origin,s*27.7,19.6,z,0.6,4,0.6,GOLD,Enum.Material.Metal,false)
        end
        rampStairs(section,origin,s*36.5,accent,trim)
        bench(section,origin,s*36,176)
    end
    part(section,"Passerelle transversale",origin,0,17.5,179,55,1,12,trim,Enum.Material.Marble,true)
    part(section,"Garde-corps de passerelle",origin,0,20,173.2,52,3.8,0.65,accent,Enum.Material.Metal,true)
    -- Verrière translucide : les matériaux et reliefs sont visibles de loin.
    local pane=part(section,"Verrière monumentale",origin,0,34.1,150,91,0.65,80,GLASS,Enum.Material.Glass,false)
    pane.Transparency=0.48
    for x=-42,42,14 do
        part(section,"Nervure de verrière",origin,x,34.6,150,0.45,1,82,accent,Enum.Material.Metal,false)
    end
    for z=117,187,14 do
        part(section,"Traverse de verrière",origin,0,34.6,z,92,1,0.5,accent,Enum.Material.Metal,false)
    end
    for _,s in ipairs({-1,1}) do
        for z=123,183,20 do
            local lum=part(section,"Lustre de galerie",origin,s*19,26,z,2.3,1.3,2.3,theme[5],Enum.Material.Neon,false)
            lum.Shape=Enum.PartType.Ball
            local light=Instance.new("PointLight")
            light.Brightness=1.2;light.Range=22;light.Shadows=false;light.Parent=lum
            lum:SetAttribute("KinV16LampPlace",key)
        end
    end
    F.sign(section,"Enseigne de la grande galerie",origin+Vector3.new(0,12,110.0),0,theme[1],38,3.1).CanCollide=false
    for i,s in ipairs({-1,1}) do
        local id=key..".discovery."..string.format("%02d",i)
        sculpture(section,origin,s*23,153,theme[4],theme[5],i,id)
        F.sign(section,"Titre de collection",origin+Vector3.new(s*22,8,164),0,theme[i+1],23,2.9).CanCollide=false
    end
    for _,x in ipairs({-15,0,15}) do bench(section,origin,x,182) end
    local console=part(section,"Console d'ambiance",origin,0,2.25,187,3.5,4.5,2.5,INK,Enum.Material.Metal,true)
    part(section,"Ecran de console",origin,0,2.8,185.65,2.6,2.5,0.2,theme[5],Enum.Material.Neon,false)
    console:SetAttribute("KinV16Action","lighting")
    console:SetAttribute("KinV16PlaceKey",key)
    F.prompt(console,"Changer l'ambiance","Grande galerie")
    -- Fonctionnalité métier explicitement conservée à l'état futur.
    local terminal=part(section,"Terminal du futur",origin,13,2.4,188,3.5,4.8,2.5,INK,Enum.Material.Metal,true)
    part(section,"Ecran du terminal",origin,13,3,186.65,2.6,2.5,0.2,GLASS,Enum.Material.Neon,false)
    terminal:SetAttribute("KinStubInteractionId",key..".discovery.future.01")
    terminal:SetAttribute("KinStubCapabilityId","future."..key..".discovery")
    terminal:SetAttribute("KinStubTitle",theme[1])
    F.prompt(terminal,"Consulter","Futures activités")
    return section
end
return Wings

]])
source(server,"InstitutionExhibits","ModuleScript",[[
--!strict
-- Sculptures éducatives uniques au centre des huit grands atriums.
-- Objets navigables, sans contenu sensible ni connexion réseau.
local F=require(script.Parent.Factory)
local Exhibit={}
local stone=Color3.fromRGB(220,205,177)
local iron=Color3.fromRGB(58,77,86)
local blue=Color3.fromRGB(80,179,198)
local copper=Color3.fromRGB(190,149,89)
local function part(parent,name,origin,size,x,y,z,color,material)
    return F.part(parent,name,size,CFrame.new(origin+Vector3.new(x,y,z)),color,material)
end
local function orb(parent,name,origin,radius,x,y,z,color)
    local p=part(parent,name,origin,Vector3.new(radius,radius,radius),x,y,z,color,Enum.Material.Glass)
    p.Shape=Enum.PartType.Ball
    p.CanCollide=false
    return p
end
local function interactive(parent,key,origin,title)
    local box=part(parent,"Socle interactif",origin,Vector3.new(3.7,4.2,2.0),14,2.1,68,iron,Enum.Material.Metal)
    part(parent,"Écran d'exposition",origin,Vector3.new(3.0,2.6,0.2),14,3.1,66.9,blue,Enum.Material.Neon).CanCollide=false
    box:SetAttribute("KinStubInteractionId",key..".atrium.exhibit")
    box:SetAttribute("KinStubCapabilityId","future."..key..".exhibit")
    box:SetAttribute("KinStubTitle",title)
    F.prompt(box,"Explorer",title)
end
local function library(parent,origin)
    for _,x in ipairs({-16,-8,0,8}) do
        local case=part(parent,"Archive verticale",origin,Vector3.new(6,11,2.4),x,5.5,68,Color3.fromRGB(119,78,49),Enum.Material.WoodPlanks)
        for y=2,9,2 do
            for n=1,6 do
                part(parent,"Volume relié",origin,Vector3.new(0.6,1.25,1.5),x-2.5+n*0.73,y,66.8,Color3.fromHSV((n+y)*0.084,0.55,0.80),Enum.Material.SmoothPlastic)
            end
        end
    end
end
local function justice(parent,origin)
    part(parent,"Colonne de justice",origin,Vector3.new(1.6,10,1.6),-4,5,68,stone,Enum.Material.Marble)
    part(parent,"Balance",origin,Vector3.new(17,0.6,0.8),-4,10.2,68,copper,Enum.Material.Metal)
    for _,x in ipairs({-12,4}) do
        part(parent,"Chaîne balance",origin,Vector3.new(0.25,3,0.25),x,8.4,68,copper,Enum.Material.Metal)
        local bowl=part(parent,"Plateau balance",origin,Vector3.new(5,0.7,5),x,6.8,68,stone,Enum.Material.Marble)
        bowl.Shape=Enum.PartType.Cylinder
    end
end
local function university(parent,origin)
    orb(parent,"Soleil du savoir",origin,5,-6,10,68,Color3.fromRGB(255,198,74))
    for i=1,6 do
        local theta=i*1.04
        local x=-6+math.cos(theta)*9
        local z=68+math.sin(theta)*6
        orb(parent,"Planète",origin,1.8+(i%3)*0.6,x,7+i%3,z,Color3.fromHSV(i/7,0.55,0.85))
    end
end
local function innovation(parent,origin)
    part(parent,"Prototypage",origin,Vector3.new(20,1,10),-3,1.5,68,stone,Enum.Material.Metal)
    part(parent,"Tour de démonstration",origin,Vector3.new(2,10,2),-3,7,68,iron,Enum.Material.Metal)
    for i=0,3 do
        local rad=math.rad(i*90)
        local blade=part(parent,"Rotor",origin,Vector3.new(1.3,8,0.5),-3+math.sin(rad)*4,12,68+math.cos(rad)*4,blue,Enum.Material.Metal)
        blade.CFrame=CFrame.new(blade.Position)*CFrame.Angles(0,0,rad)
        blade.CanCollide=false
    end
end
local function museum(parent,origin)
    for i=-2,2 do
        local x=-4+i*5
        part(parent,"Piédestal d'oeuvre",origin,Vector3.new(3.5,3.3,3.5),x,1.6,68,stone,Enum.Material.Marble)
        local art=orb(parent,"Œuvre d'art",origin,2.4,x,5.2,68,Color3.fromHSV((i+3)*0.16,0.34,0.88))
        art.Material=Enum.Material.Metal
    end
end
local function cityhall(parent,origin)
    part(parent,"Maquette de ville",origin,Vector3.new(18,2,11),-4,1.1,69,stone,Enum.Material.Marble)
    for i=1,14 do
        local x=-12+(i%5)*3.5
        local z=64+math.floor(i/5)*3
        local h=2+(i*7)%6
        part(parent,"Miniature urbaine",origin,Vector3.new(2,h,1.9),x,2+h/2,z,Color3.fromHSV(i*0.09,0.22,0.85),Enum.Material.Concrete)
    end
end
local function ekoh(parent,origin)
    part(parent,"Socle du savoir",origin,Vector3.new(12,2,12),-5,1,68,stone,Enum.Material.Marble)
    for i=1,14 do
        local a=i*0.56
        local y=2.4+i*0.85
        local p=orb(parent,"Cristal de connaissances",origin,2.3,-5+math.sin(a)*3.1,y,68+math.cos(a)*3.1,Color3.fromHSV(i*0.09,0.4,0.85))
        p.Material=Enum.Material.Neon
    end
end
local function orgo(parent,origin)
    for i=1,4 do
        local x=-14+(i-1)*6
        part(parent,"Serveur Orgo",origin,Vector3.new(4,9,3),x,4.5,68,iron,Enum.Material.Metal)
        for j=1,6 do
            local p=part(parent,"Indicateur",origin,Vector3.new(2.5,0.17,0.16),x,1+j*1.1,66.35,j%2==0 and blue or copper,Enum.Material.Neon)
            p.CanCollide=false
        end
    end
end
local renderer={library=library,justice_palace=justice,campus=university,innovation_lab=innovation,museum=museum,city_hall=cityhall,ekoh_tower=ekoh,orgo_center=orgo}
local titles={library="Conservatoire des livres",justice_palace="Justice et médiation",campus="Sciences et découvertes",innovation_lab="Fabrique des inventions",museum="Patrimoine vivant",city_hall="Plans de la cité",ekoh_tower="Savoir collectif",orgo_center="Réseau des services"}
function Exhibit.make(model,key,origin)
    local folder=F.folder(model,"Œuvre centrale de l'atrium")
    local fn=renderer[key]
    if fn then fn(folder,origin) end
    interactive(folder,key,origin,titles[key] or "Exposition")
    return folder
end
return Exhibit

]])
source(server,"InstitutionFacadeKitV24","ModuleScript",[[
--!strict
-- Reprise discrète des accès: vrais meshes Studio quand fournis, primitives sinon.
-- Aucune modification de l'entrée ou des ProximityPrompts.
local Kit=require(script.Parent.CrystalKit)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Facades={}
function Facades.make(model,structure,building)
    local place=building.interior_place_key
    if not place then return end
    local w,d=table.unpack(structure.footprint_studs)
    local x,y,z=table.unpack(structure.center_studs)
    local h=structure.height_studs
    local cf=CFrame.new(x,y,z)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local root=Instance.new("Folder")
    root.Name="Architecture minérale v24"
    root:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    root.Parent=model
    local accent=Kit.accent(place)
    -- L'arche reste décorative; devant la partie supérieure du portail, jamais
    -- une seconde porte ou une collision invisible.
    Meshes.decorate(root,"Arc de fronton","opal_arch",Vector3.new(12,5.3,1.45),
        cf*CFrame.new(0,11.5,-d*0.5-1.95),Kit.gold)
    for _,side in ipairs({-1,1}) do
        Meshes.decorate(root,"Pilastre d'identité","mineral_column",Vector3.new(1.25,11.0,1.25),
            cf*CFrame.new(side*(w*0.5-3.6),h*0.5,-d*0.5-1.28),Kit.primary)
        Meshes.decorate(root,"Rosace de façade","crystal_rosette",Vector3.new(3.8,3.8,0.6),
            cf*CFrame.new(side*w*0.31,math.min(h-3,17),-d*0.5-1.65)*CFrame.Angles(0,0,side*0.2),accent)
        if Kit.profile~="LITE" then
            Meshes.decorate(root,"Épi opalin de toiture","opal_spire",Vector3.new(2.25,7.4,2.25),
                cf*CFrame.new(side*w*0.38,h+3.7,0),Kit.opal)
        end
    end
    if Kit.profile=="SHOWCASE" then
        Meshes.decorate(root,"Couronnement principal","crystal_canopy",Vector3.new(math.min(w*0.35,22),3.0,7),
            cf*CFrame.new(0,h+2,0),accent)
    end
    return root
end
return Facades

]])
source(server,"InstitutionForecourts","ModuleScript",[[
--!strict
-- V5 — Cours publiques accessibles et différenciées pour les huit institutions.
-- Géométrie totalement locale. Les bornes métier restent des stubs.
local F = require(script.Parent.Factory)
local Courts = {}
local STONE = Color3.fromRGB(213,201,173)
local DARK = Color3.fromRGB(30,104,100)
local WOOD = Color3.fromRGB(147,104,70)
local BRASS = Color3.fromRGB(188,149,91)

local function block(parent,name,base,x,y,z,sx,sy,sz,color,material,collision)
    local part = F.part(parent,name,Vector3.new(sx,sy,sz),base*CFrame.new(x,y,z),color,material)
    if collision==false then part.CanCollide=false;part.CastShadow=false end
    return part
end
local function sphere(parent,name,base,x,y,z,size,color)
    local p=block(parent,name,base,x,y,z,size,size,size,color,Enum.Material.Glass,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function torusApprox(parent,base,radius,height,color)
    for i=1,16 do
        local a=i*math.pi*2/16
        local b=(i+1)*math.pi*2/16
        local mid=(a+b)/2
        local chord=2*radius*math.sin(math.pi/16)+0.18
        local p=block(parent,"Anneau du savoir",base,math.cos(mid)*radius,height,math.sin(mid)*radius,chord,0.75,0.75,color,Enum.Material.Metal,false)
        p.CFrame=base*CFrame.new(math.cos(mid)*radius,height,math.sin(mid)*radius)*CFrame.Angles(0,-mid-math.pi/2,0)
    end
end
local themes={
    ["central.city_hall"]={label="Parvis des citoyens",kind="assembly",color=Color3.fromRGB(197,168,106)},
    ["central.ekoh_tower"]={label="Jardin des connaissances",kind="spiral",color=Color3.fromRGB(97,196,185)},
    ["ethikos.justice_palace"]={label="Cour de la délibération",kind="balance",color=Color3.fromRGB(182,150,115)},
    ["keenkonnect.innovation_lab"]={label="Cour des inventions",kind="lab",color=Color3.fromRGB(96,180,190)},
    ["konnected.library"]={label="Parvis des lecteurs",kind="books",color=Color3.fromRGB(140,175,206)},
    ["konnected.university"]={label="Jardin astronomique",kind="astronomy",color=Color3.fromRGB(184,163,212)},
    ["kreative.museum"]={label="Cour des arts",kind="arts",color=Color3.fromRGB(214,146,134)},
    ["orgo.admin_center"]={label="Place des échanges",kind="nodes",color=Color3.fromRGB(128,173,199)},
}

local function candidate(structure,side)
    local x,_,z=table.unpack(structure.center_studs)
    local w=structure.footprint_studs[1]
    local angle=math.rad(structure.yaw_degrees)
    local orientation=CFrame.new(x,0,z)*CFrame.Angles(0,angle,0)
    return orientation*CFrame.new(side*(w/2+36),0,0)
end

local function overlaps(position,structures,owner)
    local x,z=position.X,position.Z
    if math.sqrt(x*x+z*z)>452 then return true end
    for _,b in ipairs(structures) do
        if b.building_id~=owner then
            local cx,_,cz=table.unpack(b.center_studs)
            local a=math.rad(b.yaw_degrees)
            local dx,dz=x-cx,z-cz
            local lx=math.cos(a)*dx-math.sin(a)*dz
            local lz=math.sin(a)*dx+math.cos(a)*dz
            if math.abs(lx)<b.footprint_studs[1]/2+32 and math.abs(lz)<b.footprint_studs[2]/2+29 then return true end
        end
    end
    return false
end

local function choose(structure,structures)
    -- Recherche déterministe d'un côté dont le parvis ne heurte pas les autres institutions.
    for _,side in ipairs({1,-1}) do
        local cf=candidate(structure,side)
        if not overlaps(cf.Position,structures,structure.building_id) then return cf,side end
    end
    return nil,nil
end
function Courts.isReserved(x,z,structures)
    for _,structure in ipairs(structures) do
        local cf=choose(structure,structures)
        if cf then
            local p=cf:PointToObjectSpace(Vector3.new(x,0,z))
            if math.abs(p.X)<27 and math.abs(p.Z)<23 then return true end
        end
    end
    return false
end

local function seat(parent,base,x,z,accent)
    block(parent,"Banc du parvis",base,x,1.5,z,7,0.55,2.6,WOOD,Enum.Material.WoodPlanks,true)
    block(parent,"Dossier de banc",base,x,2.8,z+1,7,2.1,0.45,accent,Enum.Material.Metal,true)
    for _,s in ipairs({-1,1}) do
        block(parent,"Pied de banc",base,x+s*2.6,0.7,z,0.6,1.4,2.1,DARK,Enum.Material.Metal,true)
    end
end
local function planter(parent,base,x,z,index)
    block(parent,"Bac fleuri",base,x,0.8,z,4.5,1.6,4.5,STONE,Enum.Material.Marble,true)
    for i=1,5 do
        local a=i*math.pi*2/5
        local px,pz=x+math.cos(a)*1.35,z+math.sin(a)*1.35
        block(parent,"Tige du jardin",base,px,2.25,pz,0.24,2.3,0.24,Color3.fromRGB(51,132,79),Enum.Material.Grass,false)
        sphere(parent,"Fleur",base,px,3.45,pz,1.2,Color3.fromHSV((index+i*0.14)%1,0.55,0.9))
    end
end
local function centerpiece(parent,base,theme)
    local accent=theme.color
    block(parent,"Socle patrimonial",base,0,1,2,16,2,14,STONE,Enum.Material.Marble,true)
    local kind=theme.kind
    if kind=="assembly" then
        for i=-3,3 do
            block(parent,"Siège de l'assemblée",base,i*2.2,3.2,2,1.9,2.2,2.5,DARK,Enum.Material.WoodPlanks,true)
            block(parent,"Dossier civique",base,i*2.2,4.3,3.1,1.9,2.2,0.5,accent,Enum.Material.Metal,false)
        end
        block(parent,"Tribune",base,0,4.3,-3.5,6,4,2,accent,Enum.Material.Marble,true)
    elseif kind=="spiral" then
        for i=1,14 do
            local a=i*0.55
            sphere(parent,"Connaissance",base,math.cos(a)*4,2.8+i*0.65,2+math.sin(a)*3.5,1.9,Color3.fromHSV(i/16,0.42,0.9))
        end
        torusApprox(parent,base,6,8,accent)
    elseif kind=="balance" then
        block(parent,"Colonne de justice",base,0,5.5,2,1.4,9,1.4,accent,Enum.Material.Marble,true)
        block(parent,"Fléau",base,0,10,2,13,0.65,0.65,BRASS,Enum.Material.Metal,false)
        for _,x in ipairs({-5,5}) do
            block(parent,"Chaîne",base,x,7.8,2,0.26,4,0.26,BRASS,Enum.Material.Metal,false)
            block(parent,"Plateau",base,x,5.8,2,4.3,0.5,3.7,STONE,Enum.Material.Marble,false)
        end
    elseif kind=="lab" then
        block(parent,"Colonne d'énergie",base,0,7,2,3.2,12,3.2,DARK,Enum.Material.Metal,true)
        for i=1,6 do
            local a=i*math.pi/3
            local p=sphere(parent,"Atome lumineux",base,math.cos(a)*5,7+math.sin(a)*2.6,2+math.sin(a)*5,2.2,accent)
            p.Material=Enum.Material.Neon
        end
        torusApprox(parent,base,6,8,BRASS)
    elseif kind=="books" then
        for i=-3,3 do
            local height=5+(i+7)%4*1.4
            block(parent,"Livre monumental",base,i*1.8,2+height/2,2,1.5,height,6,Color3.fromHSV((i+5)*0.11,0.34,0.82),Enum.Material.Marble,true)
            block(parent,"Dos doré",base,i*1.8,2+height/2,-1.1,0.35,height-0.5,0.22,BRASS,Enum.Material.Metal,false)
        end
    elseif kind=="astronomy" then
        sphere(parent,"Soleil",base,0,10,2,5,Color3.fromRGB(255,205,104)).Material=Enum.Material.Neon
        for i=1,6 do
            local a=i*1.07
            sphere(parent,"Planète",base,math.cos(a)*5,6+(i%3)*2,2+math.sin(a)*4,1.6+(i%3)*0.5,Color3.fromHSV(i/7,0.52,0.86))
        end
        torusApprox(parent,base,6,5,accent)
    elseif kind=="arts" then
        for i=-2,2 do
            block(parent,"Colonne d'art",base,i*2.5,4,2,1.3,5,1.3,STONE,Enum.Material.Marble,true)
            local p=block(parent,"Sculpture",base,i*2.5,7,2,2.8,3,2.8,Color3.fromHSV((i+3)/6,0.5,0.9),Enum.Material.Metal,false)
            p.CFrame=p.CFrame*CFrame.Angles(0,math.rad(20*i),math.rad(35+i*12))
        end
    else
        for i=1,8 do
            local a=i*math.pi/4
            sphere(parent,"Noeud du réseau",base,math.cos(a)*5,6,2+math.sin(a)*4,2.2,accent)
            block(parent,"Connecteur vertical",base,math.cos(a)*5,3,2+math.sin(a)*4,0.5,5,0.5,DARK,Enum.Material.Metal,false)
        end
    end
end

function Courts.make(city,plan)
    local root=F.folder(city,"Parvis des institutions")
    local count=0
    for _,structure in ipairs(plan.structures) do
        local theme=themes[structure.building_id]
        local cf,side=choose(structure,plan.structures)
        if theme and cf and side then
            local m=Instance.new("Model")
            m.Name=theme.label
            m:SetAttribute("KinPublicSpaceId","court."..structure.building_id)
            m.Parent=root
            local accent=theme.color
            block(m,"Pavement de cour",cf,0,0.18,0,46,0.35,33,STONE,Enum.Material.Cobblestone,false)
            for _,s in ipairs({-1,1}) do
                block(m,"Bordure du parvis",cf,0,0.45,s*16.5,46,0.8,0.65,BRASS,Enum.Material.Marble,true)
                seat(m,cf,s*16,-9,accent)
                planter(m,cf,s*16,9,s+4)
                block(m,"Colonnade du parvis",cf,s*21,5,-6,1,10,1,accent,Enum.Material.Marble,true)
                block(m,"Arche latérale",cf,s*21,10,0,1.8,1,15,accent,Enum.Material.Marble,false)
            end
            centerpiece(m,cf,theme)
            local console=block(m,"Console d'accueil",cf,11,2.4,-12,4.2,4.8,2.3,DARK,Enum.Material.Metal,true)
            block(m,"Écran informatif",cf,11,3.1,-13.25,3.3,2.2,0.18,accent,Enum.Material.Neon,false)
            local id="court."..structure.building_id..".terminal"
            console:SetAttribute("KinStubInteractionId",id)
            console:SetAttribute("KinStubCapabilityId","future."..structure.building_id..".outdoor")
            console:SetAttribute("KinStubTitle",theme.label)
            F.prompt(console,"Consulter",theme.label)
            F.sign(m,"Nom du parvis",(cf*CFrame.new(0,12,-15)).Position,structure.yaw_degrees,theme.label,34,3.1).CanCollide=false
            -- Belvédère fonctionnel : la caméra observe la façade depuis le parvis.
            local marker=block(m,"Longue-vue",cf,-15,2.4,-10,2.6,4.7,2.6,DARK,Enum.Material.Metal,true)
            block(m,"Lentille",cf,-15,4.3,-11.6,2.1,1.1,1.1,accent,Enum.Material.Glass,false)
            marker:SetAttribute("KinVistaId","vista.court."..structure.building_id)
            marker:SetAttribute("KinVistaTitle",theme.label)
            marker:SetAttribute("KinVistaCameraPosition",(cf*CFrame.new(-8,15,-25)).Position)
            marker:SetAttribute("KinVistaLookAt",Vector3.new(structure.center_studs[1],13,structure.center_studs[3]))
            F.prompt(marker,"Observer",theme.label)
            -- Connexion piétonne vers le côté du bâtiment sans téléportation.
            local b= CFrame.new(structure.center_studs[1],0,structure.center_studs[3]) * CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
            block(m,"Allée de liaison",b,side*(structure.footprint_studs[1]/2+15),0.2,0,31,0.35,7,STONE,Enum.Material.Cobblestone,false)
            count+=1
        end
    end
    root:SetAttribute("KinForecourtsCreated",count)
    return root
end
return Courts

]])
source(server,"InstitutionSkylineV22","ModuleScript",[[
--!strict
-- Silhouettes fonctionnelles sur les TOITS existants : pas de second bâtiment ni de fermeture de porte.
local Studio=require(script.Parent.ArtisanGeometryV22)
local Kit=require(script.Parent.CrystalKit)
local Skyline={}
local variants={city_hall="civic",ekoh_tower="knowledge",library="archive",campus="orbit",
    justice_palace="balance",innovation_lab="mechanism",museum="art",orgo_center="network"}
function Skyline.make(model,structure,building)
    local place=building.interior_place_key
    local role=variants[place] or "civic"
    local w,d=table.unpack(structure.footprint_studs)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local h=structure.height_studs
    local frame=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local roof=frame*CFrame.new(0,h+0.8,0)
    local gallery=Instance.new("Folder")
    gallery.Name="Silhouette cristalline v22 — "..role
    gallery:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    gallery.Parent=model
    local width=math.min(w-12,34)
    local depth=math.min(d-12,25)
    -- Gabarit de toiture reculé : jamais devant la porte d'entrée.
    for _,side in ipairs({-1,1}) do
        Studio.part(gallery,"Couronnement sarcelle",Vector3.new(width*0.38,0.65,2),
            roof*CFrame.new(side*width*0.3,0,depth*0.2),"deep",Enum.Material.Slate,false)
        Studio.facet(gallery,"Pointe de couronne",roof*CFrame.new(side*width*0.37,0.3,depth*0.2),
            1.25,if Kit.profile=="LITE" then 4.6 else 6.5,"opal",true)
    end
    Studio.part(gallery,"Bandeau de faîtage",Vector3.new(width*0.8,0.42,1),
        roof*CFrame.new(0,1,-depth*0.24),"gold",Enum.Material.Metal,false)
    if role=="civic" then
        Studio.facet(gallery,"Flèche du conseil",roof*CFrame.new(0,0,0),3,16,"opal",false)
        for _,side in ipairs({-1,1}) do
            Studio.part(gallery,"Voûte civique",Vector3.new(3.2,8,2.5),roof*CFrame.new(side*9,4,0),"medium",Enum.Material.Slate,true)
        end
    elseif role=="knowledge" then
        for i=1,5 do
            local a=i*math.pi*2/5
            Studio.facet(gallery,"Constellation du savoir",roof*CFrame.new(math.sin(a)*9,0,math.cos(a)*7),1.5,5.5+i*1.2,
                if i%2==0 then "gold" else "opal",true)
        end
    elseif role=="archive" then
        for i=-2,2 do
            Studio.wedge(gallery,"Livre de pierre",Vector3.new(3,7+math.abs(i)*1.4,3),
                roof*CFrame.new(i*4,4,0)*CFrame.Angles(0,0,0.11*i),
                if i%2==0 then "medium" else "opal",true)
        end
    elseif role=="orbit" then
        for i=1,12 do
            local a=2*math.pi*i/12
            Studio.orb(gallery,"Étoile d'observatoire",if i%3==0 then 1.45 else 0.8,
                roof*CFrame.new(math.sin(a)*10,8+math.cos(a)*4,math.cos(a)*7),
                if i%2==0 then "gold" else "opal",true)
        end
        Studio.facet(gallery,"Observatoire",roof*CFrame.new(0,0,0),2.4,12,"medium",false)
    elseif role=="balance" then
        Studio.facet(gallery,"Axe d'équilibre",roof*CFrame.new(0,0,0),1.6,12,"opal",false)
        Studio.beam(gallery,"Traverse du droit",(roof*CFrame.new(-11,11,0)).Position,
            (roof*CFrame.new(11,11,0)).Position,0.85,"gold",false)
        for _,side in ipairs({-1,1}) do
            Studio.facet(gallery,"Plateau de pierre",roof*CFrame.new(side*11,0,0),2.3,6,"medium",true)
        end
    elseif role=="mechanism" then
        Studio.facet(gallery,"Noyau d'invention",roof*CFrame.new(0,0,0),3.1,10,"opal",false)
        for i=1,6 do
            local a=i*math.pi/3
            Studio.wedge(gallery,"Aube géométrique",Vector3.new(2.5,8,1.1),
                roof*CFrame.new(math.sin(a)*7.3,6,math.cos(a)*5.7)*CFrame.Angles(0,a,0),"gold",true)
        end
    elseif role=="art" then
        for i=-1,1 do
            Studio.facet(gallery,"Prisme des arts",roof*CFrame.new(i*7,0,(i%2)*3),2.8,10+i*3,
                if i==0 then "opal" else "gold",false)
        end
    elseif role=="network" then
        for _,x in ipairs({-9,9}) do
            for _,z in ipairs({-5,5}) do
                Studio.facet(gallery,"Nœud de réseau",roof*CFrame.new(x,0,z),1.6,8,"opal",true)
            end
        end
        for _,z in ipairs({-5,5}) do
            Studio.beam(gallery,"Réseau aérien",(roof*CFrame.new(-9,8,z)).Position,
                (roof*CFrame.new(9,8,z)).Position,0.46,"gold",true)
        end
    end
    return gallery
end
return Skyline

]])
source(server,"InstitutionStagecraftV24","ModuleScript",[[
--!strict
-- Fresques de salle et alcôves architecturales. Motifs typés, et non un empilement
-- de vitrage/PointLight : budget décoratif réduit selon le profil de construction.
local Kit=require(script.Parent.CrystalKit)
local Factory=require(script.Parent.Factory)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Stage={}
local ICON={
    city_hall={"LA CITÉ", "Places, routes et rencontres", "urban"},
    ekoh_tower={"LES SAVOIRS", "Observer, relier, comprendre", "star"},
    library={"LES ARCHIVES", "Des traces et des récits", "book"},
    campus={"LES SCIENCES", "Questions et expériences", "orbit"},
    justice_palace={"LES ÉQUILIBRES", "Écouter, comparer, respecter", "balance"},
    innovation_lab={"LES INVENTIONS", "Explorer les mécanismes", "gear"},
    museum={"LES ARTS", "Des formes qui dialoguent", "facet"},
    orgo_center={"LES RÉSEAUX", "Construire les passages", "network"},
}
local function detail(parent,name,size,cf,color,material)
    local p=Kit.part(parent,"Part",name,size,cf,color,material or Enum.Material.Slate)
    p:SetAttribute("KinOptionalDetail",true)
    return p
end
local function orb(parent,name,size,cf,color)
    local p=detail(parent,name,Vector3.new(size,size,size),cf,color,Enum.Material.Slate)
    p.Shape=Enum.PartType.Ball
    return p
end
local function glyph(parent,shape,root,index,accent)
    if shape=="urban" then
        for i=-2,2 do
            detail(parent,"Édifice du plan",Vector3.new(0.5,1.1+math.abs(i)*0.34,0.65),
                root*CFrame.new(i*0.8,0.4+math.abs(i)*0.16,0),if i%2==0 then accent else Kit.gold)
        end
    elseif shape=="book" then
        for i=-2,2 do
            detail(parent,"Volume d'archives",Vector3.new(0.47,1.5+(i%3)*0.17,0.54),
                root*CFrame.new(i*0.62,0,0),if i%2==0 then Kit.gold else accent)
        end
    elseif shape=="balance" then
        detail(parent,"Axe",Vector3.new(0.22,2.2,0.22),root,Kit.gold)
        detail(parent,"Fléau",Vector3.new(3.9,0.2,0.24),root*CFrame.new(0,0.8,0),Kit.gold)
        for _,x in ipairs({-1.55,1.55}) do
            detail(parent,"Plateau",Vector3.new(1.25,0.2,0.6),root*CFrame.new(x,-0.5,0),accent)
        end
    elseif shape=="gear" then
        for i=1,6 do
            local a=math.pi*2*i/6
            detail(parent,"Aube",Vector3.new(0.32,1.65,0.45),
                root*CFrame.new(math.cos(a),math.sin(a),0)*CFrame.Angles(0,0,a),accent)
        end
        orb(parent,"Moyeu",0.85,root,Kit.gold)
    elseif shape=="network" then
        for i=1,5 do
            local a=math.pi*2*i/5
            orb(parent,"Nœud",0.55,root*CFrame.new(math.cos(a)*1.55,math.sin(a)*1.2,0),accent)
            detail(parent,"Liaison",Vector3.new(0.15,1.2,0.15),
                root*CFrame.new(math.cos(a)*0.7,math.sin(a)*0.53,0)*CFrame.Angles(0,0,a),Kit.gold)
        end
    elseif shape=="orbit" or shape=="star" then
        orb(parent,"Cœur",1.0,root,Kit.gold)
        for i=1,5 do
            local a=math.pi*2*i/5
            orb(parent,"Satellite",0.35+(i%2)*0.13,
                root*CFrame.new(math.cos(a)*1.55,math.sin(a)*1.2,0),accent)
        end
    else
        for i=1,4 do
            local a=i*math.pi/2
            detail(parent,"Facet de galerie",Vector3.new(0.75,1.65,0.4),
                root*CFrame.new(math.cos(a)*1.1,math.sin(a)*0.8,0)*CFrame.Angles(0,0,a),
                if i%2==0 then Kit.gold else accent)
        end
    end
end
function Stage.decorate(roomFolder,placeKey,room,origin,index)
    local desc=ICON[placeKey]
    if not desc then return end
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<26 or d<25 then return end
    local label,sub,shape=table.unpack(desc)
    local group=Instance.new("Folder")
    group.Name="Alcôves minérales v24"
    group:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    group:SetAttribute("KinRoomId",room.room_id)
    group.Parent=roomFolder
    -- Un des murs latéraux au fond de la salle, à distance des portails centraux.
    local count=if Kit.profile=="LITE" then 1 elseif Kit.profile=="SHOWCASE" then 2 else 1
    for n=1,count do
        local x=cx+(if n==1 then -w*0.28 else w*0.28)
        local face=CFrame.new(origin+Vector3.new(x,8.5,cz+d*0.5-1.15))*CFrame.Angles(0,math.pi,0)
        local accent=Kit.accent(placeKey)
        detail(group,"Fond de niche",Vector3.new(9.8,10.3,0.55),face,Kit.deep)
        detail(group,"Champ sarcelle",Vector3.new(8.7,9.2,0.22),face*CFrame.new(0,0,0.45),Kit.primary)
        for _,side in ipairs({-1,1}) do
            Meshes.decorate(group,"Colonne sculptée","mineral_column",Vector3.new(0.8,9.5,0.75),
                face*CFrame.new(side*4.4,0,0.8),Kit.gold)
        end
        detail(group,"Bandeau opalin",Vector3.new(8.4,0.28,0.42),face*CFrame.new(0,4.35,0.75),Kit.opal)
        glyph(group,shape,face*CFrame.new(0,0.6,0.88),index,accent)
        local plaque=Factory.sign(group,"Cartel architectural",(face*CFrame.new(0,-3.7,0.86)).Position,180,
            label,7.9,1.0)
        plaque.CanCollide=false;plaque.CanTouch=false;plaque.CanQuery=false
    end
    return group
end
return Stage

]])
source(server,"InstitutionStoriesV22","ModuleScript",[[
--!strict
-- Scénographie lisible et THÉMATIQUE dans chacune des six salles institutionnelles.
-- Zones murales en retrait; zéro collision et zéro nouveau faux terminal métier.
local Studio=require(script.Parent.ArtisanGeometryV22)
local Kit=require(script.Parent.CrystalKit)
local CollectionService=game:GetService("CollectionService")
local Stories={}
local profile=Kit.profile
local info={
    city_hall={role="civic",theme="L'assemblée des quartiers",body="La ville se construit autour d'espaces communs."},
    ekoh_tower={role="knowledge",theme="L'échange des savoirs",body="Une constellation de connaissances, à explorer ensemble."},
    library={role="archive",theme="La mémoire vivante",body="Chaque ouvrage ouvre une nouvelle perspective."},
    campus={role="orbit",theme="Le ciel et les sciences",body="Observer, questionner et expérimenter."},
    justice_palace={role="balance",theme="Les équilibres",body="Écoute, responsabilité et respect mutuel."},
    innovation_lab={role="mechanism",theme="Les inventions",body="Idées, essais et découvertes en mouvement."},
    museum={role="art",theme="La créativité",body="Les formes dialoguent avec les couleurs."},
    orgo_center={role="network",theme="Les liens invisibles",body="Relier les gens, les lieux et les initiatives."},
}
local function inscription(parent,text,base)
    local p=Studio.part(parent,"Cartouche minéral",Vector3.new(8.6,1.9,0.32),base,"deep",Enum.Material.Slate,false)
    local ui=Instance.new("SurfaceGui")
    ui.Name="Cartouche lisible"
    ui.Face=Enum.NormalId.Front
    ui.PixelsPerStud=45
    ui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    ui.LightInfluence=0
    ui.Parent=p
    local label=Instance.new("TextLabel")
    label.Name="Texte"
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundTransparency=1
    label.Text=text
    label.Font=Enum.Font.GothamSemibold
    label.TextColor3=Kit.pearl
    label.TextSize=25
    label.TextWrapped=true
    label.Parent=ui
end
function Stories.decorate(parent,placeKey,room,origin,index)
    local spec=info[placeKey]
    if not spec then return end
    local x,_,z=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<21 or d<20 then return end
    local scene=Instance.new("Folder")
    scene.Name="Scénographie narrative v22"
    scene:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    scene.Parent=parent
    local side=if index%2==0 then -1 else 1
    -- Sur le mur arrière latéral; le centre du passage demeure complètement dégagé.
    local anchor=CFrame.new(origin+Vector3.new(x+side*(w/2-7.8),8.3,z+d/2-1.1))
    Studio.part(scene,"Encadrement sculpté",Vector3.new(12.4,10.0,0.42),anchor,"deep",Enum.Material.Slate,false)
    Studio.part(scene,"Panneau opalin",Vector3.new(11.55,9.1,0.3),anchor*CFrame.new(0,0,-0.31),"medium",Enum.Material.Marble,false)
    Studio.part(scene,"Frise supérieure",Vector3.new(12.3,0.24,0.55),anchor*CFrame.new(0,5.2,-0.35),"gold",Enum.Material.Metal,true)
    local face=anchor*CFrame.new(0,0,-0.65)
    Studio.motif(scene,face*CFrame.new(0,0.9,0),spec.role,"opal",0.9)
    inscription(scene,spec.theme,anchor*CFrame.new(0,-3.55,-0.78))
    inscription(scene,spec.body,anchor*CFrame.new(0,-5.65,-0.78))
    -- Petit marqueur invisible NON INTERACTIF : découverte géométrique côté client.
    local marker=Instance.new("Part")
    marker.Name="Découverte de galerie"
    marker.Size=Vector3.new(0.2,0.2,0.2)
    marker.CFrame=CFrame.new(origin+Vector3.new(x,4,z))
    marker.Anchored=true
    marker.Transparency=1
    marker.CanCollide=false
    marker.CanTouch=false
    marker.CanQuery=false
    marker:SetAttribute("KinGalleryId",placeKey.."/"..room.room_id)
    marker:SetAttribute("KinGalleryTitle",room.display_name.." — "..spec.theme)
    marker.Parent=scene
    CollectionService:AddTag(marker,"KinCityGalleryV22")
    -- Salle 1 et salles alternées : petits reliefs secondaires; LITE reste dépouillé.
    if profile~="LITE" and index%2==1 then
        for _,side2 in ipairs({-1,1}) do
            Studio.facet(scene,"Cadran de cristal",anchor*CFrame.new(side2*5.15,-4.55,-0.9),0.45,1.5,
                if side2==-1 then "gold" else "opal",true)
        end
    end
    scene:SetAttribute("KinStoryTitle",spec.theme)
    scene:SetAttribute("KinStoryDescription",spec.body)
    return scene
end
return Stories

]])
source(server,"InteractiveGardens","ModuleScript",[[
--!strict
-- V6 : jardins où l'interaction produit un effet PHYSIQUE LOCAL.
-- Les bornes des services métier restent des stubs ailleurs dans Kin City.
local F=require(script.Parent.Factory)
local Gardens={}
local Courts=require(script.Parent.InstitutionForecourts)
local GRASS=Color3.fromRGB(79,139,97)
local STONE=Color3.fromRGB(222,210,188)
local IRON=Color3.fromRGB(41,68,80)
local GOLD=Color3.fromRGB(206,162,93)
local function part(parent,name,base,x,y,z,sx,sy,sz,color,mat,solid)
    local p=F.part(parent,name,Vector3.new(sx,sy,sz),base*CFrame.new(x,y,z),color,mat)
    if solid==false then p.CanCollide=false end
    return p
end
local function clearSpot(x,z,plan)
    if Courts.isReserved(x,z,plan.structures) then return false end
    for _,b in ipairs(plan.structures) do
        local dx=x-b.center_studs[1];local dz=z-b.center_studs[3]
        if math.sqrt(dx*dx+dz*dz)<85 then return false end
    end
    for _,path in ipairs(plan.pedestrian_paths) do
        local pts=path.path_xyz_studs
        for i=2,#pts do
            local a=pts[i-1];local b=pts[i]
            local dx=b[1]-a[1];local dz=b[3]-a[3]
            local l=dx*dx+dz*dz
            if l>0 then
                local t=math.clamp(((x-a[1])*dx+(z-a[3])*dz)/l,0,1)
                local xx=a[1]+dx*t;local zz=a[3]+dz*t
                local dist=math.sqrt((x-xx)^2+(z-zz)^2)
                if dist<path.width_studs/2+13 then return false end
            end
        end
    end
    return true
end
local types={
    {title="Jardin de l'énergie",kind="light",shade=Color3.fromRGB(113,226,212)},
    {title="Laboratoire des rotations",kind="motion",shade=Color3.fromRGB(228,159,96)},
    {title="Atelier de la lumière",kind="light",shade=Color3.fromRGB(207,144,224)},
    {title="Monument cinétique",kind="motion",shade=Color3.fromRGB(117,183,231)},
}
local function assemble(root,index,base,design,yaw)
    local m=Instance.new("Model")
    m.Name=design.title.." "..index
    m:SetAttribute("KinPublicSpaceId",string.format("city.discovery.%02d",index))
    m:SetAttribute("KinLocalMechanismActive",false)
    m.Parent=root
    part(m,"Jardin pavé",base,0,0.05,0,26,0.35,26,STONE,Enum.Material.Cobblestone,false)
    for _,sx in ipairs({-1,1}) do
        for _,sz in ipairs({-1,1}) do
            part(m,"Pilier du jardin",base,sx*11,3.2,sz*11,1.1,6,1.1,IRON,Enum.Material.Metal,true)
            part(m,"Orbe d'énergie",base,sx*11,6.6,sz*11,1.3,1.3,1.3,design.shade,Enum.Material.Neon,false)
            local pot=part(m,"Jardin vertical",base,sx*8,1.1,sz*8,3.2,2.2,3.2,GRASS,Enum.Material.Grass,true)
            pot.Shape=Enum.PartType.Ball
        end
    end
    part(m,"Socle de l'installation",base,0,1,1,9,2,9,IRON,Enum.Material.Metal,true)
    for i=1,8 do
        local a=i*math.pi/4
        local xx=math.cos(a)*5.2;local zz=1+math.sin(a)*5.2
        local orb=part(m,"Cristal interactif",base,xx,5,zz,2,2,2,design.shade,Enum.Material.Glass,false)
        orb.Shape=Enum.PartType.Ball
        orb.Transparency=0.65
        orb:SetAttribute("KinReactiveLight",true)
        local light=Instance.new("PointLight")
        light.Enabled=false;light.Range=16;light.Brightness=0.7;light.Color=design.shade;light.Parent=orb
    end
    if design.kind=="motion" then
        for n=1,4 do
            local piece=part(m,"Aile mobile",base,0,6.6,1,1.1,1.1,13,design.shade,Enum.Material.Metal,false)
            piece.CFrame=base*CFrame.new(0,6.6,1)*CFrame.Angles(0,n*math.pi/4,math.pi/5)
            piece:SetAttribute("KinReactiveRotor",true)
        end
        part(m,"Axe cinétique",base,0,6.5,1,1.2,9,1.2,GOLD,Enum.Material.Metal,false)
    else
        local crown=part(m,"Sphère de réflexion",base,0,8.4,1,5.5,5.5,5.5,design.shade,Enum.Material.Glass,false)
        crown.Shape=Enum.PartType.Ball
        crown.Transparency=0.75
        crown:SetAttribute("KinReactiveLight",true)
        local light=Instance.new("PointLight")
        light.Enabled=false;light.Range=25;light.Brightness=2;light.Color=design.shade;light.Parent=crown
    end
    local console=part(m,"Commande physique",base,8,2.2,-8,3.2,4.4,2.2,IRON,Enum.Material.Metal,true)
    part(m,"Écran de commande",base,8,3,-9.15,2.6,2.2,0.15,design.shade,Enum.Material.Neon,false)
    console:SetAttribute("KinLocalMechanismId",string.format("city.discovery.%02d",index))
    console:SetAttribute("KinLocalMechanismKind",design.kind)
    F.prompt(console,"Activer",design.title)
    F.sign(m,"Panneau",(base*CFrame.new(0,11,-12.2)).Position,math.deg(yaw),design.title,24,2.7).CanCollide=false
end
function Gardens.make(city,plan)
    local root=F.folder(city,"Jardins d'expérimentation interactive")
    local count=0
    for i=1,20 do
        local theta=(i-0.3)*2*math.pi/20
        local radius=195+(i%2)*14
        local x,z=math.cos(theta)*radius,math.sin(theta)*radius
        if clearSpot(x,z,plan) then
            local base=CFrame.new(x,0.2,z)*CFrame.Angles(0,math.pi/2-theta,0)
            assemble(root,i,base,types[(i-1)%#types+1],math.pi/2-theta)
            count+=1
        end
    end
    root:SetAttribute("KinGardensCreated",count)
    return root
end
return Gardens

]])
source(server,"InteriorCollections","ModuleScript",[[
--!strict
-- Kin City v4 : collections architecturales thématiques natives, sans assets distants.
-- Les objets se trouvent près des murs latéraux afin de préserver la circulation.
local F = require(script.Parent.Factory)
local Collection = {}

local INK=Color3.fromRGB(32,54,63)
local GOLD=Color3.fromRGB(194,151,86)
local IVORY=Color3.fromRGB(229,217,189)
local WOOD=Color3.fromRGB(116,78,56)
local GLASS=Color3.fromRGB(110,193,208)

local function p(parent,name,cf,size,color,mat,solid)
    local q=F.part(parent,name,size,cf,color,mat or Enum.Material.SmoothPlastic)
    if solid==false then q.CanCollide=false; q.CastShadow=false end
    return q
end
local function box(parent,name,base,x,y,z,sx,sy,sz,color,mat,solid)
    return p(parent,name,base*CFrame.new(x,y,z),Vector3.new(sx,sy,sz),color,mat,solid)
end
local function orb(parent,name,base,x,y,z,s,clr)
    local q=box(parent,name,base,x,y,z,s,s,s,clr,Enum.Material.Glass,false)
    q.Shape=Enum.PartType.Ball
    return q
end
local function exhibitPrompt(part,key,title,index)
    part:SetAttribute("KinStubInteractionId",key..".collection."..index)
    part:SetAttribute("KinStubCapabilityId","future."..key..".collection")
    part:SetAttribute("KinStubTitle",title)
    F.prompt(part,"Explorer",title)
end
local function tablet(parent,base,x,z,title,key,index,accent)
    local pod=box(parent,"Borne de consultation",base,x,2.35,z,5.2,4.7,2.8,INK,Enum.Material.Metal,true)
    box(parent,"Écran de consultation",base,x,3.3,z-1.48,4.2,2.25,0.2,accent,Enum.Material.Neon,false)
    box(parent,"Tablette de contrôle",base,x,1.15,z-1.7,4.4,0.28,0.8,GOLD,Enum.Material.Metal,false)
    exhibitPrompt(pod,key,title,index)
end
local function bookcase(parent,base,x,z,accent,seed)
    box(parent,"Bibliothèque en chêne",base,x,5.1,z,10.3,10.2,2.25,WOOD,Enum.Material.WoodPlanks,true)
    for level=1,4 do
        box(parent,"Rayon renforcé",base,x,1.9+level*1.8,z-0.8,10,0.25,2.1,accent,Enum.Material.Metal,false)
        for j=1,10 do
            local shade=Color3.fromHSV(((seed+j*11+level*17)%101)/101,0.25+0.08*(j%3),0.68)
            box(parent,"Ouvrage relié",base,x-4.6+j*0.85,1.05+level*1.8,z-1.14,0.55,1.3+(j%3)*0.12,0.8,shade,Enum.Material.Fabric,false)
        end
    end
end
local function hallScreen(parent,base,x,z,accent,title)
    box(parent,"Panneau numérique",base,x,7.4,z,14,8,0.7,INK,Enum.Material.Metal,false)
    box(parent,"Affichage lumineux",base,x,7.4,z-0.43,12.4,6.5,0.16,accent,Enum.Material.Neon,false)
    F.sign(parent,"Titre écran",(base*CFrame.new(x,7.4,z-0.6)).Position,0,title,11.3,3.2).CanCollide=false
end
local function workstation(parent,base,x,z,accent)
    box(parent,"Bureau",base,x,2.5,z,11,0.6,4.6,WOOD,Enum.Material.WoodPlanks,true)
    for _,side in ipairs({-1,1}) do
        box(parent,"Piètement",base,x+side*4,1.25,z,0.55,2.5,3.7,INK,Enum.Material.Metal,true)
    end
    box(parent,"Écran informatique",base,x,4.2,z+0.75,5.6,3,0.4,INK,Enum.Material.Metal,true)
    box(parent,"Interface",base,x,4.2,z+0.47,4.9,2.4,0.08,accent,Enum.Material.Neon,false)
    box(parent,"Clavier",base,x,2.86,z-1.25,4.4,0.12,1.1,IVORY,Enum.Material.SmoothPlastic,false)
    box(parent,"Siège",base,x,1,z-5.2,3.2,2,2.8,INK,Enum.Material.Fabric,true)
end
local function artWall(parent,base,x,z,accent,variant)
    box(parent,"Cadre du patrimoine",base,x,8.2,z,9,7,0.65,GOLD,Enum.Material.Metal,false)
    box(parent,"Œuvre encadrée",base,x,8.2,z-0.43,7.9,5.8,0.15,Color3.fromHSV(variant*0.16%1,0.42,0.68),Enum.Material.SmoothPlastic,false)
    orb(parent,"Relief artistique",base,x,8.2,z-0.78,3,accent)
end
local function laboratory(parent,base,x,z,accent)
    box(parent,"Paillasse scientifique",base,x,2.45,z,12,0.65,4.2,IVORY,Enum.Material.Marble,true)
    for n=1,4 do
        local xx=x-4.5+n*2
        local stand=box(parent,"Éprouvette",base,xx,4,z,0.9,2.6,0.9,GLASS,Enum.Material.Glass,false)
        stand.Transparency=0.35
        local light=orb(parent,"Échantillon",base,xx,5.4,z,1.1,accent)
        light.Material=Enum.Material.Neon
    end
    box(parent,"Microscope",base,x+4.5,4.1,z-0.4,1.4,3,1.6,INK,Enum.Material.Metal,false)
end
local function justice(parent,base,x,z,accent)
    box(parent,"Banc du conseil",base,x,2.1,z,13,4.2,2.7,WOOD,Enum.Material.WoodPlanks,true)
    for n=1,3 do
        box(parent,"Dossier du tribunal",base,x+(n-2)*4,4.9,z+0.6,3.3,2.8,0.5,accent,Enum.Material.Fabric,false)
    end
    box(parent,"Registre",base,x,4.45,z-0.8,4.2,0.3,3,IVORY,Enum.Material.Fabric,false)
end
local function cityHall(parent,base,x,z,accent)
    box(parent,"Table citoyenne",base,x,2.2,z,12,0.5,6,GOLD,Enum.Material.WoodPlanks,true)
    for j=-2,2 do
        box(parent,"Dossier de projet",base,x+j*2.1,2.55,z,1.5,0.15,2.1,IVORY,Enum.Material.Fabric,false)
    end
    orb(parent,"Modèle symbolique du conseil",base,x,5.2,z,3.2,accent)
end
local function ekoh(parent,base,x,z,accent)
    for i=1,5 do
        box(parent,"Panneau de savoir",base,x-5+i*1.8,1.8+i*0.5,z,1.1,3.5+i*0.5,2.4,accent,Enum.Material.Neon,false)
    end
    box(parent,"Socle du mérite",base,x,1,z-4,9,2,1.8,INK,Enum.Material.Metal,true)
end
local function archive(parent,base,x,z,accent)
    for j=1,3 do
        box(parent,"Casier du réseau",base,x+(j-2)*3,4.4,z,2.6,6.8,2.8,INK,Enum.Material.Metal,true)
        box(parent,"Indicateur",base,x+(j-2)*3,5.5,z-1.5,1.8,1.2,0.14,accent,Enum.Material.Neon,false)
    end
end
local renderers={
    library=function(parent,base,x,z,accent,index) bookcase(parent,base,x,z,accent,index) end,
    campus=function(parent,base,x,z,accent,index) laboratory(parent,base,x,z,accent) end,
    justice_palace=function(parent,base,x,z,accent,index) justice(parent,base,x,z,accent) end,
    city_hall=function(parent,base,x,z,accent,index) cityHall(parent,base,x,z,accent) end,
    ekoh_tower=function(parent,base,x,z,accent,index) ekoh(parent,base,x,z,accent) end,
    innovation_lab=function(parent,base,x,z,accent,index) laboratory(parent,base,x,z,accent) end,
    museum=function(parent,base,x,z,accent,index) artWall(parent,base,x,z,accent,index) end,
    orgo_center=function(parent,base,x,z,accent,index) archive(parent,base,x,z,accent) end,
}
local titles={
    library="Catalogue des savoirs",campus="Parcours d'apprentissage",justice_palace="Registre de médiation",
    city_hall="Projets citoyens",ekoh_tower="Cartographie de l'expertise",innovation_lab="Projets et inventions",
    museum="Collection culturelle",orgo_center="Tableau des services",
}
function Collection.make(parent,key,room,origin,style,index)
    local x,_,z=table.unpack(room.center_studs)
    local width,_,depth=table.unpack(room.size_studs)
    local base=CFrame.new(origin+Vector3.new(x,0,z))
    local accent=F.hex(style.palette.accent)
    local folder=F.folder(parent,"Collections thématiques")
    -- Deux dispositifs placés à proximité du mur arrière, hors axe principal.
    local stationX=math.max(12,math.min(width*0.24,19))
    local backZ=math.min(depth/2-7,depth*0.24)
    local build=renderers[key]
    if build then
        build(folder,base,-stationX,backZ,accent,index)
        if width>=48 then build(folder,base,stationX,backZ,accent,index+3) end
    end
    -- Une borne explicite reste attachée à un objet physique. Le prompt est routé au serveur.
    local frontZ=-math.min(depth*0.18,7)
    tablet(folder,base,stationX,frontZ,titles[key] or "Centre de découverte",key.."."..room.room_id,index,accent)
    if index==1 and width>38 then
        hallScreen(folder,base,0,depth/2-1.7,accent,string.upper(titles[key] or "KIN CITY"))
    end
    return folder
end
return Collection

]])
source(server,"InteriorGenerator","ModuleScript",[[
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

]])
source(server,"InteriorPlus","ModuleScript",[[
--!strict
-- Vocabulaire intérieur spécifique aux institutions, sans bloquer les axes de circulation.
local F=require(script.Parent.Factory)
local Interiors={}
local function place(parent,base,name,size,offset,color,material)
    return F.part(parent,name,size,base*CFrame.new(offset),color,material)
end
local function ball(parent,base,name,size,offset,color,material)
    local p=place(parent,base,name,size,offset,color,material)
    p.Shape=Enum.PartType.Ball
    return p
end
local cream=Color3.fromRGB(244,234,213)
local graphite=Color3.fromRGB(48,63,75)
local bronze=Color3.fromRGB(176,131,73)
local textile=Color3.fromRGB(66,123,120)
local timber=Color3.fromRGB(134,95,62)
local function tableDesk(parent,base,x,z,metalColor)
    place(parent,base,"Bureau",Vector3.new(7,0.5,3.5),Vector3.new(x,2.5,z),timber,Enum.Material.WoodPlanks)
    for _,sx in ipairs({-2.6,2.6}) do
        place(parent,base,"Pied",Vector3.new(0.4,2.2,0.5),Vector3.new(x+sx,1.1,z),metalColor,Enum.Material.Metal)
    end
    place(parent,base,"Document",Vector3.new(2,0.08,1.5),Vector3.new(x+0.8,2.82,z),cream,Enum.Material.SmoothPlastic).CanCollide=false
end
local function shelf(parent,base,x,z)
    place(parent,base,"Bibliothèque",Vector3.new(6.5,9,1.6),Vector3.new(x,4.5,z),timber,Enum.Material.WoodPlanks)
    for row=1,4 do
        place(parent,base,"Planche",Vector3.new(6.2,0.22,2),Vector3.new(x,row*1.9,z),bronze,Enum.Material.Wood)
        for col=1,7 do
            local clr=Color3.fromHSV((row*0.13+col*0.107)%1,0.5,0.8)
            place(parent,base,"Livre",Vector3.new(0.5,1.2,1.2),Vector3.new(x-2.7+(col-1)*0.85,row*1.9+0.75,z),clr,Enum.Material.SmoothPlastic)
        end
    end
end
local function podium(parent,base,x,z)
    place(parent,base,"Socle",Vector3.new(8,1.1,5),Vector3.new(x,0.55,z),bronze,Enum.Material.Marble)
    place(parent,base,"Pupitre",Vector3.new(3.4,3.4,2.3),Vector3.new(x,3.0,z),timber,Enum.Material.Wood)
    place(parent,base,"Plateau",Vector3.new(4.3,0.45,2.9),Vector3.new(x,4.8,z),cream,Enum.Material.Marble)
end
local function researchDesk(parent,base,x,z)
    tableDesk(parent,base,x,z,graphite)
    place(parent,base,"Instrument",Vector3.new(2,2.3,1.1),Vector3.new(x-1,4,z),graphite,Enum.Material.Metal)
    place(parent,base,"Ecran instrument",Vector3.new(1.6,1.5,0.15),Vector3.new(x-1,4.1,z-0.63),Color3.fromRGB(98,213,206),Enum.Material.Neon).CanCollide=false
    for n=1,3 do
        ball(parent,base,"Éprouvette",Vector3.new(0.7,1.5,0.7),Vector3.new(x+1+n*0.4,3.9,z),Color3.fromHSV(n/5,0.65,0.85),Enum.Material.Glass).CanCollide=false
    end
end
local function exhibit(parent,base,x,z,seed)
    place(parent,base,"Piédestal",Vector3.new(4.4,3,4.4),Vector3.new(x,1.5,z),cream,Enum.Material.Marble)
    local obj=ball(parent,base,"Œuvre",Vector3.new(3,4.8,3),Vector3.new(x,5.6,z),Color3.fromHSV(seed*0.21,0.4,0.73),Enum.Material.Metal)
    obj.CanCollide=false
    place(parent,base,"Cartel",Vector3.new(3.5,0.3,1.2),Vector3.new(x,3,z+2),graphite,Enum.Material.Metal).CanCollide=false
end
local function panel(parent,base,x,z,title,accent)
    local p=place(parent,base,"Panneau",Vector3.new(9,6,0.3),Vector3.new(x,7,z),graphite,Enum.Material.Metal)
    p.CanCollide=false
    F.sign(parent,"Panneau : "..title,(base*CFrame.new(x,7,z-0.3)).Position,0,title,8,2.6).CanCollide=false
    place(parent,base,"Bande",Vector3.new(8.5,0.3,0.5),Vector3.new(x,10,z),accent,Enum.Material.Neon).CanCollide=false
end
local function chandelier(parent,base,x,z,accent)
    place(parent,base,"Chaîne",Vector3.new(0.3,2.2,0.3),Vector3.new(x,13.4,z),graphite,Enum.Material.Metal).CanCollide=false
    local p=ball(parent,base,"Lustre",Vector3.new(5,1.3,5),Vector3.new(x,12.0,z),accent,Enum.Material.Neon)
    p.CanCollide=false
    local light=Instance.new("PointLight");light.Brightness=1.1;light.Range=30;light.Parent=p
end
function Interiors.decorateRoom(parent,placeKey,room,origin,style,roomIndex)
    local x,_,z=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    local base=CFrame.new(origin+Vector3.new(x,0,z))
    local tint=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local rug=place(parent,base,"Tapis central",Vector3.new(math.min(18,w*0.45),0.08,math.min(15,d*0.34)),Vector3.new(0,0.07,0),tint,Enum.Material.Fabric)
    rug.CanCollide=false
    -- Allées centrales entièrement dégagées : décoration contre les murs latéraux.
    for _,side in ipairs({-1,1}) do
        local wallX=side*(w/2-3.2)
        for i=-1,1 do
            place(parent,base,"Lambris",Vector3.new(1.1,6,7),Vector3.new(side*(w/2-0.8),3,i*d/4),trim,Enum.Material.Wood).CanCollide=false
        end
        place(parent,base,"Colonne décorative",Vector3.new(1.8,13,1.8),Vector3.new(side*(w/2-1.6),6.5,-d/2+2),trim,Enum.Material.Marble)
        place(parent,base,"Socle colonnette",Vector3.new(2.6,0.6,2.6),Vector3.new(side*(w/2-1.6),0.3,-d/2+2),tint,Enum.Material.Marble)
        if placeKey=="library" then
            shelf(parent,base,wallX,side*2.5)
            shelf(parent,base,wallX,-side*10)
        elseif placeKey=="campus" then
            tableDesk(parent,base,wallX,side*7,graphite)
            place(parent,base,"Tableau cours",Vector3.new(1,5,10),Vector3.new(side*(w/2-0.5),8,0),graphite,Enum.Material.Slate).CanCollide=false
        elseif placeKey=="justice_palace" or placeKey=="city_hall" then
            tableDesk(parent,base,wallX,side*8,bronze)
            podium(parent,base,wallX,-side*8)
        elseif placeKey=="museum" then
            exhibit(parent,base,wallX,side*8,roomIndex+side)
            exhibit(parent,base,wallX,-side*8,roomIndex+4)
        elseif placeKey=="innovation_lab" then
            researchDesk(parent,base,wallX,side*7)
            researchDesk(parent,base,wallX,-side*9)
        elseif placeKey=="orgo_center" then
            tableDesk(parent,base,wallX,side*8,graphite)
            panel(parent,base,side*(w/2-1),-side*7,"SERVICES",tint)
        elseif placeKey=="ekoh_tower" then
            exhibit(parent,base,wallX,side*8,roomIndex+side)
            panel(parent,base,side*(w/2-1),-side*6,"EKO H",tint)
        end
    end
    for n=1,3 do
        local zz=-d/2+8+n*(d-16)/4
        local beam=place(parent,base,"Poutre plafond",Vector3.new(w-3,0.45,0.6),Vector3.new(0,15.2,zz),trim,Enum.Material.Wood)
        beam.CanCollide=false
    end
    chandelier(parent,base,0,0,tint)
    local title=room.display_name or room.room_id
    -- Frise d'identification sur un pan non traversant.
    F.sign(parent,"Identité de pièce",(base*CFrame.new(0,11,d/2-0.45)).Position,180,title,math.min(w-9,30),2.3).CanCollide=false
end
return Interiors

]])
source(server,"InteriorScenography","ModuleScript",[[
--!strict
-- V5 : décors architecturaux de salles, sans masquer les couloirs ou portails.
-- Réutilisable pour tous les huit intérieurs et toutes leurs ailes.
local F=require(script.Parent.Factory)
local Scenography={}
local function part(parent,name,origin,size,pos,color,material,solid)
    local p=F.part(parent,name,size,CFrame.new(origin+pos),color,material)
    if solid==false then p.CanCollide=false;p.CastShadow=false end
    return p
end
function Scenography.decorate(parent,room,origin,style,placeKey,index)
    local cx,_,cz=table.unpack(room.center_studs)
    local w,h,d=table.unpack(room.size_studs)
    local accent=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local title=room.display_name or "Espace public"
    local rot=if index%2==0 then 1 else -1
    -- Tapis/rosace plane; l'épaisseur n'entrave pas la marche.
    local floor=part(parent,"Rosace du patrimoine",origin,Vector3.new(math.min(w-14,26),0.08,math.min(d-14,19)),Vector3.new(cx,0.07,cz),accent,Enum.Material.Fabric,false)
    floor.Transparency=0.53
    for ring=1,2 do
        local r=5+ring*4
        for i=1,12 do
            local theta=i*math.pi/6
            local tile=part(parent,"Mosaïque",origin,Vector3.new(1.5,0.1,1.5),Vector3.new(cx+math.cos(theta)*r,0.12,cz+math.sin(theta)*r),trim,Enum.Material.Marble,false)
            tile.CFrame=tile.CFrame*CFrame.Angles(0,theta,0)
        end
    end
    -- Frises murales placées près du plafond et loin des zones de passage.
    for _,side in ipairs({-1,1}) do
        part(parent,"Frise supérieure",origin,Vector3.new(0.35,1.0,d-3),Vector3.new(cx+side*(w/2-0.8),13.5,cz),accent,Enum.Material.Metal,false)
        for n=1,3 do
            local zz=cz-d/2+4+n*(d-8)/4
            local frame=part(parent,"Emblème mural",origin,Vector3.new(0.35,3,3),Vector3.new(cx+side*(w/2-1.0),10.6,zz),trim,Enum.Material.Marble,false)
            frame.Transparency=0.2
        end
    end
    -- Luminaire sculptural signé, sans tripler les vitrages ni les lumières.
    require(script.Parent.CrystalLuminairesV23).decorate(parent,room,origin,placeKey,index)
    -- Plaque murale explicite : zone prête pour son interface future.
    local board=part(parent,"Emblème de salle",origin,Vector3.new(10,2.8,0.25),Vector3.new(cx,11.1,cz+d/2-0.8),Color3.fromRGB(39,60,72),Enum.Material.Metal,false)
    -- Le texte de surface ne remplace pas le contenu kOA : il nomme seulement l'espace.
    F.sign(parent,"Signalétique intérieure",origin+Vector3.new(cx,11.1,cz+d/2-1.0),180,title,9.2,2.2).CanCollide=false
end
return Scenography

]])
source(server,"InteriorWings","ModuleScript",[[
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

]])
source(server,"IntermodalHub","ModuleScript",[[
--!strict
-- Gare centrale visitable : grande halle traversante, deux niveaux,
-- escaliers physiques, kiosques, galeries, bornes de correspondance
-- et douze panneaux de retour aux stations des navettes v11.
local RS=game:GetService("ReplicatedStorage")
local Network=require(RS:WaitForChild("KinCityShared"):WaitForChild("IntermodalNetwork"))
local F=require(script.Parent.Factory)
local Hub={}
local C={stone=Color3.fromRGB(222,213,189),steel=Color3.fromRGB(30,104,100),gold=Color3.fromRGB(215,175,107),glass=Color3.fromRGB(197,244,240),wood=Color3.fromRGB(148,107,79),green=Color3.fromRGB(95,147,116)}
local function part(parent,name,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),CFrame.new(x,y,z),color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function seat(parent,x,y,z)
    local s=Instance.new("Seat")
    s.Name="Banquette de la gare";s.Anchored=true
    s.Size=Vector3.new(3.8,0.8,2.7);s.CFrame=CFrame.new(x,y,z)
    s.Material=Enum.Material.WoodPlanks;s.Color=C.wood;s.Parent=parent
    part(parent,"Dossier",x,y+1,z+1.2,3.8,2,0.4,C.steel,Enum.Material.Wood)
end
local function glass(parent,x,y,z,w,h,d)
    local p=part(parent,"Vitrail de la gare",x,y,z,w,h,d,C.glass,Enum.Material.Glass,false)
    p.Transparency=0.36
end
local function orb(parent,name,x,y,z,r,color)
    local p=part(parent,name,x,y,z,r,r,r,color,Enum.Material.Neon,false)
    p.Shape=Enum.PartType.Ball
    local light=Instance.new("PointLight")
    light.Range=18;light.Brightness=0.9;light.Parent=p
    return p
end
local function sign(parent,name,x,y,z,text,w)
    local s=F.sign(parent,name,Vector3.new(x,y,z),0,text,w or 24,3.4)
    s.CanCollide=false
    return s
end
local function stairs(parent,side)
    -- 14 marches pour une galerie à Y=12; 2 stud de profondeur chacune.
    local x=side*30
    for step=1,14 do
        local height=step*0.85
        local z=90+(step-1)*1.85
        part(parent,"Marche de la galerie",x,height/2,z,7,height,1.95,C.stone,Enum.Material.Cobblestone)
        for _,railSide in ipairs({-1,1}) do
            part(parent,"Montant d'escalier",x+railSide*3.7,height+1.4,z,0.3,2.8,0.3,C.steel,Enum.Material.Metal,false)
        end
    end
    -- Palier de liaison : marche 14 arrive à Y=11.9, galerie à Y=12.
    part(parent,"Palier galerie",x,11.85,118,9,0.45,7,C.stone,Enum.Material.Cobblestone)
end
local function shell(root)
    local m=Instance.new("Model");m.Name="Gare centrale des Connexions";m.Parent=root
    m:SetAttribute("KinIntermodalHubId",Network.hub.id)
    local z=114
    part(m,"Parvis gare",0,0.02,79,94,0.3,21,C.stone,Enum.Material.Cobblestone)
    part(m,"Halle - dallage",0,0.14,z,84,0.55,70,C.stone,Enum.Material.Marble)
    part(m,"Promenade traversante nord",0,0.16,156,16,0.34,22,C.stone,Enum.Material.Cobblestone)
    part(m,"Axe piéton depuis la place",0,0.14,65,13,0.3,27,C.stone,Enum.Material.Cobblestone)
    for _,x in ipairs({-42,42}) do
        part(m,"Mur latéral",x,10.1,z,1.2,20,68,C.steel,Enum.Material.Brick)
        for j=1,6 do
            glass(m,x+((x>0) and 0.7 or -0.7),11,84+j*9,0.13,7.5,5.7)
        end
    end
    -- Deux passages ouverts de 15 studs, au sud et au nord, sans porte factice.
    for _,endZ in ipairs({79,149}) do
        for _,side in ipairs({-1,1}) do
            part(m,"Façade de gare",side*24.75,10.3,endZ,34.5,20.2,1,C.steel,Enum.Material.Brick)
            glass(m,side*26,11,endZ+((endZ==79) and -0.6 or 0.6),13,8,0.12)
        end
        part(m,"Linteau central",0,18.0,endZ,16,4.1,1.3,C.gold,Enum.Material.Metal)
    end
    for _,x in ipairs({-39,39}) do
        for _,zz in ipairs({88,107,126,142}) do
            part(m,"Colonne de la nef",x,12,zz,1.5,23,1.5,C.gold,Enum.Material.Marble)
        end
    end
    -- Verrière haute translucide, non bloquante pour le cadrage caméra.
    for i=1,8 do
        local zz=79+i*8.0
        local pane=part(m,"Verrière de la nef",0,25.5,zz,83,0.45,8.5,C.glass,Enum.Material.Glass,false)
        pane.Transparency=0.43
        part(m,"Arceau de verrière",0,25.8,zz-4.3,83,0.6,0.4,C.steel,Enum.Material.Metal,false)
    end
    for _,side in ipairs({-1,1}) do
        part(m,"Galerie haute accessible",side*26,12.0,z,28,0.85,63,C.wood,Enum.Material.WoodPlanks)
        -- Rampe qui empêche la chute sur la nef centrale.
        part(m,"Garde-corps intérieur",side*12.4,15,z,0.5,5,63,C.steel,Enum.Material.Metal)
        for _,zz in ipairs({90,112,135}) do
            glass(m,side*12.1,15.2,zz,0.1,3,13)
        end
        stairs(m,side)
        for _,zz in ipairs({103,130}) do seat(m,side*23,13,zz) end
    end
    -- Pont galerie au nord (la traversée au sol demeure libre).
    part(m,"Passerelle haute",0,12,141,25,0.85,7,C.wood,Enum.Material.WoodPlanks)
    for _,x in ipairs({-12.5,12.5}) do
        part(m,"Console de passerelle",x,14.8,141,0.5,5.2,7,C.gold,Enum.Material.Metal)
    end
    sign(m,"Fronton monumental",0,22,78,"GARE DES CONNEXIONS",42)
    sign(m,"Direction jardin de justice",0,18.3,149,"ETHIKOS  ↑",24)
    sign(m,"Orientation depuis la place",0,5.2,75,"6 LIGNES DE CORRESPONDANCE",36)
    for _,x in ipairs({-9,9}) do
        for _,zz in ipairs({95,118,135}) do
            orb(m,"Luminaire de la nef",x,20,zz,1.6,C.gold)
        end
    end
    -- Café et bibliothèque d'attente : pas de commerce fictif ni économie.
    for _,side in ipairs({-1,1}) do
        local x=side*33
        part(m,"Comptoir d'accueil",x,2.4,142,11,2.8,3.5,C.wood,Enum.Material.WoodPlanks)
        part(m,"Table haute",x,2.2,136,7,1.0,4,C.wood,Enum.Material.WoodPlanks)
        for _,sx in ipairs({-3,3}) do seat(m,x+sx,1.65,131) end
        part(m,"Présentoir de lecture",x,4,145,8,6,1.5,C.steel,Enum.Material.Wood)
        for k=1,7 do
            part(m,"Livres de voyage",x-3.5+k,5,144.1,0.7,2.6,0.7,if k%2==0 then C.gold else C.green,Enum.Material.Fabric,false)
        end
    end
    -- Écrans avec futurs services toujours en stub.
    local terminal=part(m,"Borne information à venir",0,2.6,133,3,4.3,1.7,C.steel,Enum.Material.Metal)
    terminal:SetAttribute("KinStubInteractionId","kin.intermodal.info.future")
    terminal:SetAttribute("KinStubCapabilityId","future.intermodal.information")
    terminal:SetAttribute("KinStubTitle","Informations de la gare")
    F.prompt(terminal,"Consulter","Informations futures")
    return m
end
function Hub.isReserved(x,z)
    -- Empêcher les arbres générés en amont de traverser la nef et ses parvis.
    return math.abs(x)<52 and z>52 and z<164
end
function Hub.make(city)
    local root=F.folder(city,"Gare centrale et correspondances")
    shell(root)
    for i,gate in ipairs(Network.gates) do
        local pos=gate.position_studs
        local x,z=pos[1],pos[3]
        local color=Color3.fromRGB(gate.color[1],gate.color[2],gate.color[3])
        local desk=part(root,"Comptoir de correspondance "..i,x,2.3,z,8.5,3.2,3.2,C.steel,Enum.Material.Metal)
        local band=part(root,"Bande lumineuse de ligne",x,4.2,z-1.5,8.5,0.45,0.2,color,Enum.Material.Neon,false)
        desk:SetAttribute("KinIntermodalTransfer",gate.id)
        desk:SetAttribute("KinIntermodalFrom","hub")
        desk:SetAttribute("KinIntermodalLine",gate.line_id)
        F.prompt(desk,"Rejoindre la station",gate.title)
        sign(root,"Panneau de correspondance "..i,x,7,z-1.9,"LIGNE "..i,8)
        local light=Instance.new("PointLight")
        light.Range=13;light.Brightness=0.7;light.Parent=band
    end
    -- Correspondance retour depuis les 12 stations déjà présentes dans les boulevards.
    for _,ret in ipairs(Network.returns) do
        local x,z=ret.position_studs[1],ret.position_studs[3]
        local color=Color3.fromRGB(ret.color[1],ret.color[2],ret.color[3])
        part(root,"Socle retour",x,0.3,z,5.3,0.4,5.3,C.stone,Enum.Material.Cobblestone)
        local pole=part(root,"Correspondance retour à la gare",x,2.3,z,2.7,3.9,2.7,color,Enum.Material.Metal)
        pole:SetAttribute("KinIntermodalTransfer",ret.id)
        pole:SetAttribute("KinIntermodalFrom","station")
        pole:SetAttribute("KinIntermodalLine",ret.line_id)
        F.prompt(pole,"Retour gare centrale","Correspondance rapide")
        local beam=part(root,"Lumière de station",x,5.4,z,1.3,1.3,1.3,C.gold,Enum.Material.Neon,false)
        beam.Shape=Enum.PartType.Ball
        local p=Instance.new("PointLight");p.Range=15;p.Parent=beam
    end
    root:SetAttribute("KinIntermodalGates",#Network.gates)
    root:SetAttribute("KinIntermodalReturns",#Network.returns)
    return root
end
return Hub

]])
source(server,"IntermodalTransfers","ModuleScript",[[
--!strict
-- Correspondances intermodales locales. Pas de pass inventé, billet ou API.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RS=game:GetService("ReplicatedStorage")
local Network=require(RS:WaitForChild("KinCityShared"):WaitForChild("IntermodalNetwork"))
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local Transfers={}
local destinations={}
for _,gate in ipairs(Network.gates) do
    destinations[gate.id]={target=gate.arrival_studs,from="hub",name=gate.title}
end
for _,ret in ipairs(Network.returns) do
    destinations[ret.id]={target=ret.arrival_studs,from="station",name="Gare centrale des Connexions"}
end
local function eligible(player)
    if player.Parent~=Players or player:GetAttribute("KinZone")~="city" then return nil end
    if player:GetAttribute("KinBusActive") or player:GetAttribute("KinFerryActive") then return nil end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not hrp or hum.Health<=0 or hrp.Anchored or hum.SeatPart then return nil end
    return char,hrp
end
function Transfers.start(world,reply)
    Prompts.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinIntermodalTransfer")
        if type(id)~="string" then return end
        local data=destinations[id]
        if not data or host:GetAttribute("KinIntermodalFrom")~=data.from then return end
        local char,hrp=eligible(player)
        if not char or not hrp then return end
        if (host.Position-hrp.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"intermodal/"..id,2.5) then return end
        local session=TravelSession.begin(player,"intermodal")
        if not session then return end
        local target=Vector3.new(data.target[1],4.2,data.target[3])
        pcall(function()player:RequestStreamAroundAsync(target,3) end)
        if not TravelSession.valid(player,session) then
            TravelSession.finish(player,session)
            return
        end
        char:PivotTo(CFrame.new(target))
        TravelSession.finish(player,session)
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",
            title="Correspondance — Kin City",
            message="Arrivée : "..data.name,
            notice="Déplacement rapide local. Les véhicules restent accessibles aux stations."
        })
    end)
end
return Transfers

]])
source(server,"IslandAnnexes","ModuleScript",[[
--!strict
-- V9 : six maisons insulaires autonomes, deux salles intérieures chacune,
-- terrasses de toit accessibles par seize marches. Aucune téléportation.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Islands=require(RS:WaitForChild("KinCityShared"):WaitForChild("IslandDestinations"))
local Annex={}
local STONE=Color3.fromRGB(231,222,197)
local DECK=Color3.fromRGB(159,121,86)
local DARK=Color3.fromRGB(42,75,84)
local GOLD=Color3.fromRGB(230,189,115)
local function p(m,name,base,x,y,z,w,h,d,color,material,solid)
    local r=F.part(m,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then r.CanCollide=false;r.CanTouch=false end
    return r
end
local function bulb(m,base,x,y,z,color)
    local lamp=p(m,"Luminaire suspendu",base,x,y,z,1.5,1.5,1.5,color,Enum.Material.Neon,false)
    lamp.Shape=Enum.PartType.Ball
    local light=Instance.new("PointLight");light.Brightness=0.8;light.Range=14;light.Parent=lamp
    lamp:SetAttribute("KinAnnexLamp",true)
    return lamp
end
-- Collections sculptées à partir de primitives et adaptées aux six vocations.
-- Chaque variante occupe le fond de la pièce, hors du passage central.
local function thematicInstallation(m,base,theme,z,clr)
    local focusX=-68
    local focusZ=z-5
    if theme=="gardens" then
        for n=1,6 do
            local xx=focusX+(n%3)*2.1
            local zz=focusZ+math.floor((n-1)/3)*2.6
            p(m,"Bac de jardin botanique",base,xx,2,zz,2.1,1.2,1.7,DECK,Enum.Material.Wood)
            p(m,"Tige de recherche",base,xx,3.7,zz,0.35,2.3,0.35,Color3.fromRGB(90,170,117),Enum.Material.Grass,false)
            local bulb=p(m,"Feuille de serre",base,xx,5,zz,2.1,1.1,1.5,clr,Enum.Material.Grass,false)
            bulb.Shape=Enum.PartType.Ball
        end
    elseif theme=="arts" then
        for n=1,7 do
            local theta=n*2*math.pi/7
            local x=focusX+math.cos(theta)*3.2
            local zz=focusZ+math.sin(theta)*3.2
            local height=2+(n%3)*1.3
            p(m,"Volume d'art abstrait",base,x,2.9+height/2,zz,1.3,height,1.3,
                if n%2==0 then GOLD else clr,Enum.Material.Marble,false)
        end
    elseif theme=="energy" then
        for n=1,5 do
            local theta=n*math.pi*2/5
            local x=focusX+math.cos(theta)*2.8
            local zz=focusZ+math.sin(theta)*2.8
            local blade=p(m,"Aube de dynamo",base,x,5.5,zz,4.8,0.35,0.65,GOLD,Enum.Material.Metal,false)
            blade:SetAttribute("KinAnnexReactive",true)
        end
        p(m,"Socle de turbine",base,focusX,3.2,focusZ,6,1.5,6,DARK,Enum.Material.Metal)
    elseif theme=="stars" then
        local sun=p(m,"Étoile de l'observatoire",base,focusX,6.5,focusZ,3.3,3.3,3.3,GOLD,Enum.Material.Neon,false)
        sun.Shape=Enum.PartType.Ball
        for n=1,5 do
            local theta=n*math.pi*2/5
            local orb=p(m,"Planète de la maquette",base,focusX+math.cos(theta)*3.7,5.8+(n%2),focusZ+math.sin(theta)*3.1,1.0+n%2,1.0+n%2,1.0+n%2,clr,Enum.Material.Glass,false)
            orb.Shape=Enum.PartType.Ball
        end
    elseif theme=="archives" then
        for level=1,3 do
            p(m,"Rayon d'archives",base,focusX,2.0+level*2,focusZ,8,0.35,2,DECK,Enum.Material.WoodPlanks)
            for n=1,8 do
                p(m,"Livre de la mémoire",base,focusX-3.6+n*0.82,2.8+level*2,focusZ,0.55,1.5+(n%3)*0.2,1.2,
                    if n%3==0 then GOLD else clr,Enum.Material.Fabric,false)
            end
        end
    else
        for n=1,6 do
            local theta=n*math.pi/3
            p(m,"Assise de cercle civique",base,focusX+math.cos(theta)*3.2,1.9,focusZ+math.sin(theta)*3.2,2.6,0.8,1.9,DECK,Enum.Material.WoodPlanks)
        end
        p(m,"Table des rencontres",base,focusX,3.0,focusZ,3.8,0.9,3.8,clr,Enum.Material.Marble)
    end
end
local function room(m,base,item,roomId,z,clr)
    local theme=item.kind
    p(m,"Table de médiation",base,-60,2.8,z,11,1.2,4,DECK,Enum.Material.WoodPlanks)
    p(m,"Socle du thème",base,-64,2.4,z-5,4,2.9,4,DARK,Enum.Material.Marble)
    local core=p(m,"Pièce centrale de la salle",base,-64,5.2,z-5,3.2,3.2,3.2,clr,Enum.Material.Neon,false)
    core.Shape=if theme=="stars" or theme=="gardens" then Enum.PartType.Ball else Enum.PartType.Block
    core:SetAttribute("KinAnnexReactive",true)
    for j=1,5 do
        local x=-71+j*3
        local piece=p(m,"Collection "..roomId.."-"..j,base,x,4.5,z+4,1.5,2.4,2,
            if j%2==0 then GOLD else clr,
            if theme=="archives" then Enum.Material.Fabric else Enum.Material.Glass,false)
        if theme=="gardens" or theme=="stars" then piece.Shape=Enum.PartType.Ball end
        piece:SetAttribute("KinAnnexReactive",true)
        p(m,"Étagère du thème",base,x,3,z+4,2.4,0.35,2.5,DECK,Enum.Material.WoodPlanks)
    end
    for _,xx in ipairs({-70,-51}) do
        p(m,"Colonne décorative",base,xx,6.2,z,0.7,9.5,0.7,DARK,Enum.Material.Metal)
    end
    bulb(m,base,-59,9.2,z,clr)
    thematicInstallation(m,base,theme,z,clr)
    -- Chaque salle possède son propre ensemble de sculptures actives.
    for _,element in ipairs(m:GetDescendants()) do
        if element:IsA("BasePart") and element:GetAttribute("KinAnnexReactive")==true and element:GetAttribute("KinAnnexRoomZ")==nil then
            element:SetAttribute("KinAnnexRoomZ",z)
        end
    end
    local console=p(m,"Console de découverte locale",base,-50.8,3,z+5,2.0,3.8,1.9,DARK,Enum.Material.Metal)
    console:SetAttribute("KinAnnexExperienceId",item.id..".room."..roomId)
    console:SetAttribute("KinAnnexIslandId",item.id)
    F.prompt(console,"Activer la salle","Expérience locale")
    local future=p(m,"Bibliothèque numérique future",base,-50,4,z-5,1.8,4.4,1.4,STONE,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",item.id..".room."..roomId..".future")
    future:SetAttribute("KinStubCapabilityId","future.island."..theme..".room")
    future:SetAttribute("KinStubTitle",item.title.." — salle "..roomId)
    F.prompt(future,"Consulter","Fonctionnalité à venir")
end
local function buildHouse(root,item,index)
    local worldPosition=Vector3.new(item.center_studs[1],0,item.center_studs[3])
    local base=CFrame.new(worldPosition)*CFrame.Angles(0,math.pi/2-item.angle,0)
    local clr=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local m=Instance.new("Model")
    m.Name="Maison des découvertes — "..item.title
    m:SetAttribute("KinAnnexIslandId",item.id)
    m.Parent=root
    -- Terrasse annexe sur pilotis au-delà de l'ancien bord de l'île.
    p(m,"Plateforme insulaire",base,-59,0.55,17,34,1.3,46,DECK,Enum.Material.WoodPlanks)
    for _,xx in ipairs({-74,-44}) do for _,zz in ipairs({-4,38}) do
        p(m,"Pieu de fondation",base,xx,-2.2,zz,1.7,7.5,1.7,DARK,Enum.Material.Metal)
    end end
    -- Accès de plain-pied par une passerelle latérale vers l'entrée EST.
    p(m,"Passerelle d'accès",base,-32,0.85,17,31,0.55,7,STONE,Enum.Material.WoodPlanks)
    for _,zz in ipairs({13,21}) do
        p(m,"Garde-corps d'accès",base,-32,2.2,zz,30,0.35,0.35,GOLD,Enum.Material.Metal,false)
    end
    p(m,"Revêtement intérieur",base,-59,1.3,17,29,0.3,42,STONE,Enum.Material.Marble)
    p(m,"Mur ouest",base,-74.3,6,17,0.8,9.9,42,DARK,Enum.Material.Slate)
    p(m,"Mur nord",base,-59,6,-3.5,31,9.9,0.8,DARK,Enum.Material.Slate)
    p(m,"Mur sud",base,-59,6,37.5,31,9.9,0.8,DARK,Enum.Material.Slate)
    -- Le mur côté île comporte un passage central de 8 studs de large.
    for _,zz in ipairs({3,31}) do
        p(m,"Façade est à ouverture",base,-44.5,6,zz,0.8,9.9,13,DARK,Enum.Material.Slate)
        local window=p(m,"Grande fenêtre d'atelier",base,-44.0,7.0,zz,0.3,3.4,8,Color3.fromRGB(157,205,221),Enum.Material.Glass,false)
        window.Transparency=0.4
    end
    -- Partition intérieure : porte réelle au centre, pas de mur invisible.
    for _,xx in ipairs({-68.0,-50.0}) do
        p(m,"Cloison percée",base,xx,5.9,17,12,9.5,0.7,DARK,Enum.Material.Wood)
    end
    p(m,"Linteau du passage intérieur",base,-59,10,17,6,1.5,0.8,GOLD,Enum.Material.Wood)
    p(m,"Toiture terrasse",base,-59,11.8,17,32,0.8,44,clr,Enum.Material.Slate)
    for _,xx in ipairs({-75,-43}) do
        p(m,"Balustrade de toiture",base,xx,13.2,17,0.4,2.2,43,GOLD,Enum.Material.Metal,false)
    end
    for _,zz in ipairs({-4,38}) do
        p(m,"Parapet de toiture",base,-59,13.2,zz,31,2.2,0.4,GOLD,Enum.Material.Metal,false)
    end
    -- Escalier indépendant au sud : 16 marches montant du terrain jusqu'au toit.
    for i=1,16 do
        local xx=-17-(i*1.8)
        local yy=0.9+i*0.69
        local step=p(m,"Marche panoramique "..i,base,xx,yy,38.5,1.9,0.4,5.0,STONE,Enum.Material.Cobblestone)
        step:SetAttribute("KinAnnexStair",i)
    end
    p(m,"Palier de terrasse",base,-46.5,11.9,38.5,8,0.6,6.5,STONE,Enum.Material.Cobblestone)
    for _,zz in ipairs({35.5,41.4}) do
        p(m,"Rampe d'escalier",base,-33.0,7.6,zz,32,0.4,0.5,GOLD,Enum.Material.Metal,false)
    end
    room(m,base,item,"A",6,clr)
    room(m,base,item,"B",28,clr)
    local seat=Instance.new("Seat");seat.Name="Siège panoramique"
    seat.Size=Vector3.new(5,0.7,2.4);seat.CFrame=base*CFrame.new(-59,12.6,3)
    seat.Color=DECK;seat.Material=Enum.Material.WoodPlanks;seat.Anchored=true;seat.Parent=m
    local beacon=p(m,"Signal de terrasse",base,-60,15.3,34,2,2,2,clr,Enum.Material.Neon,false)
    beacon.Shape=Enum.PartType.Ball
    F.sign(m,"Maison de l'île",(base*CFrame.new(-44,8.3,17)).Position,math.deg(-item.angle),"MAISON DES DÉCOUVERTES",23,3).CanCollide=false
    return m
end
function Annex.make(city)
    local root=F.folder(city,"Maisons insulaires et terrasses")
    for i,item in ipairs(Islands) do buildHouse(root,item,i) end
    root:SetAttribute("KinVisitables",#Islands)
    root:SetAttribute("KinSpecialRooms",2*#Islands)
    return root
end
return Annex

]])
source(server,"IslandExperiences","ModuleScript",[[
--!strict
-- Installations physiques de l'archipel: cycles lumineux et mécaniques locaux.
-- Les bornes métiers, distinctes, restent des stubs kOA.
local ProximityPromptService=game:GetService("ProximityPromptService")
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local F=require(script.Parent.Factory)
local RateLimiter=require(script.Parent.RateLimiter)
local Islands={}
function Islands.start(world,reply)
    local discovered={}
    local function register(player)
        discovered[player]={}
        player:SetAttribute("KinIslandsVisited",0)
        player:SetAttribute("KinIslandsTotal",6)
    end
    Players.PlayerAdded:Connect(register)
    for _,player in ipairs(Players:GetPlayers()) do register(player) end
    Players.PlayerRemoving:Connect(function(player) discovered[player]=nil end)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not player or not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinIslandExperienceId")
        if type(id)~="string" or not id:match("^kin%.island%.[%w_]+$") then return end
        local model=host.Parent
        if not model or not model:IsA("Model") or model:GetAttribute("KinIslandId")~=id then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health<=0 or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"island/"..id,1.4) then return end
        local visited=discovered[player]
        if visited and not visited[id] then
            visited[id]=true
            local count=0
            for _ in pairs(visited) do count+=1 end
            player:SetAttribute("KinIslandsVisited",count)
        end
        local active=not (model:GetAttribute("KinIslandActive")==true)
        model:SetAttribute("KinIslandActive",active)
        local exhibit=model:FindFirstChild("Installation — "..tostring(model:GetAttribute("KinIslandCaption")))
        if not exhibit then
            for _,child in ipairs(model:GetChildren()) do
                if child:IsA("Model") and string.find(child.Name,"Installation",1,true) then exhibit=child;break end
            end
        end
        if exhibit then
            for _,piece in ipairs(exhibit:GetDescendants()) do
                if piece:IsA("BasePart") then
                    if piece:GetAttribute("KinIslandReactive") then
                        if piece:GetAttribute("KinIslandRestTransparency")==nil then
                            piece:SetAttribute("KinIslandRestTransparency",piece.Transparency)
                        end
                        TweenService:Create(piece,TweenInfo.new(0.8),{Transparency=active and 0.02 or 0.65}):Play()
                        local light=piece:FindFirstChildOfClass("PointLight")
                        if not light then
                            light=Instance.new("PointLight")
                            light.Range=11;light.Brightness=0.8;light.Parent=piece
                        end
                        light.Enabled=active
                    end
                    if piece:GetAttribute("KinIslandRotor") then
                        local rest=piece:GetAttribute("KinIslandRestFrame")
                        if typeof(rest)~="CFrame" then rest=piece.CFrame;piece:SetAttribute("KinIslandRestFrame",rest) end
                        TweenService:Create(piece,TweenInfo.new(1.5,Enum.EasingStyle.Sine),{CFrame=if active then rest*CFrame.Angles(0,math.pi,0) else rest}):Play()
                    end
                end
            end
        end
        prompt.ActionText=active and "Éteindre" or "Activer"
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=model.Name,
            message=if active then "Installation insulaire activée" else "Installation insulaire arrêtée",
            notice=string.format("Archipel : %d/6 îles explorées • sans connexion à kOA.",player:GetAttribute("KinIslandsVisited") or 0)
        })
    end)
end
return Islands

]])
source(server,"IslandFerries","ModuleScript",[[
--!strict
-- Kin City v10 : traversées COLLECTIVES, six passagers maximum par bateau.
-- Embarquement partagé de 7 secondes, bateau unique par groupe, places fixes,
-- déplacement synchronisé serveur, débarquement individualisé et nettoyage.
-- Pas d'économie ni de stockage ni de requête externe.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Destinations=require(Shared:WaitForChild("IslandDestinations"))
local F=require(script.Parent.Factory)
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local Ferry={}
local CAPACITY=6
local BOARDING_SECONDS=7
local SPEED=18
local HULL=Color3.fromRGB(43,88,102)
local BRASS=Color3.fromRGB(225,191,120)
local DECK=Color3.fromRGB(176,135,87)
local lines={}
-- Construit depuis le registre partagé même quand le monde est réutilisé en Play
-- (dans ce cas Ferry.build n'est pas réexécuté).
for _,item in ipairs(Destinations) do lines[item.id]=item end
local trips={} -- uniquement les groupes EN COURS d'embarquement, par ligne et direction
local passengers={} -- Player -> record, inclut les passagers en mouvement
local sequence=0

local function worldPosition(item,radius)
    local radial=Vector3.new(math.cos(item.angle),0,math.sin(item.angle))
    local tangent=Vector3.new(-radial.Z,0,radial.X)
    return radial*radius+tangent*item.ferry_lane_offset+Vector3.new(0,0.65,0)
end
local function piece(parent,name,size,cf,color,material)
    local p=F.part(parent,name,size,cf,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
    return p
end
local function boat(parent,tripId)
    local vessel=Instance.new("Model")
    vessel.Name="Ferry collectif "..tripId
    vessel:SetAttribute("KinFerryCapacity",CAPACITY)
    vessel:SetAttribute("KinFerryShared",true)
    vessel.Parent=parent
    local pivot=piece(vessel,"Pivot",Vector3.new(0.4,0.4,0.4),CFrame.new(),HULL,Enum.Material.Metal)
    pivot.Transparency=1;vessel.PrimaryPart=pivot
    piece(vessel,"Coque catamaran gauche",Vector3.new(3,2.8,25),CFrame.new(-5,0,0),HULL,Enum.Material.Metal)
    piece(vessel,"Coque catamaran droite",Vector3.new(3,2.8,25),CFrame.new(5,0,0),HULL,Enum.Material.Metal)
    piece(vessel,"Pont collectif",Vector3.new(12.5,0.8,24),CFrame.new(0,2.0,0),DECK,Enum.Material.WoodPlanks)
    piece(vessel,"Proue",Vector3.new(10,1.1,3),CFrame.new(0,1,-12),HULL,Enum.Material.Metal)
    for _,x in ipairs({-5.5,5.5}) do
        for _,z in ipairs({-10.5,10.5}) do
            piece(vessel,"Poteau de toit",Vector3.new(0.55,5.4,0.55),CFrame.new(x,5.1,z),BRASS,Enum.Material.Metal)
        end
        piece(vessel,"Garde-corps de pont",Vector3.new(0.35,1.1,22),CFrame.new(x,4.0,0),BRASS,Enum.Material.Metal)
    end
    piece(vessel,"Auvent",Vector3.new(13.0,0.7,20),CFrame.new(0,8.1,0),Color3.fromRGB(224,211,177),Enum.Material.WoodPlanks)
    for index=1,CAPACITY do
        local x=if index%2==1 then -2.6 else 2.6
        local z=(math.floor((index-1)/2)-1)*5.5
        piece(vessel,"Banquette passager "..index,Vector3.new(3.8,0.9,2.5),CFrame.new(x,3.6,z),Color3.fromRGB(77,121,119),Enum.Material.Fabric)
        piece(vessel,"Dossier passager "..index,Vector3.new(3.8,2,0.4),CFrame.new(x,4.5,z+1.2),Color3.fromRGB(51,84,87),Enum.Material.Metal)
    end
    piece(vessel,"Cabine du pilote",Vector3.new(6,4.2,2.8),CFrame.new(0,4.6,-9.8),Color3.fromRGB(54,87,96),Enum.Material.Metal)
    piece(vessel,"Phare de navigation",Vector3.new(2,1,0.6),CFrame.new(0,5.2,-12.6),BRASS,Enum.Material.Neon)
    return vessel
end
local function platform(parent,item,side)
    local city=side=="city"
    local name=if city then "Embarcadère de la cité — "..item.title else "Embarcadère de l'île — "..item.title
    local dock=Instance.new("Model")
    dock.Name=name;dock.Parent=parent
    local radius=if city then item.ferry_start_radius else item.ferry_end_radius
    local pos=worldPosition(item,radius)
    local inward=Vector3.new(-math.cos(item.angle),0,-math.sin(item.angle))
    local base=CFrame.lookAt(pos,pos+inward)
    F.part(dock,"Plateforme maritime",Vector3.new(16,0.75,18),base*CFrame.new(0,-0.15,0),DECK,Enum.Material.WoodPlanks)
    for _,x in ipairs({-7,7}) do
        for _,z in ipairs({-7,7}) do
            F.part(dock,"Pilotis",Vector3.new(0.85,5.8,0.85),base*CFrame.new(x,-2.5,z),HULL,Enum.Material.Metal)
        end
        local guard=F.part(dock,"Rebord de sécurité",Vector3.new(0.5,1.6,16),base*CFrame.new(x,1.7,0),BRASS,Enum.Material.Metal)
        guard.CanCollide=false
    end
    local sign=F.part(dock,"Borne d'embarquement collectif",Vector3.new(3.4,4.2,1.8),base*CFrame.new(0,2.4,3),HULL,Enum.Material.Metal)
    sign:SetAttribute("KinFerryIslandId",item.id)
    sign:SetAttribute("KinFerryDirection",if city then "out" else "back")
    local prompt=F.prompt(sign,"Embarquer (6 places)","Ferry collectif")
    prompt.HoldDuration=0.25
    local clr=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local lamp=F.part(dock,"Balise de quai",Vector3.new(1.5,1.5,1.5),base*CFrame.new(-4.8,4.6,0),clr,Enum.Material.Neon)
    lamp.Shape=Enum.PartType.Ball;lamp.CanCollide=false
    local board=F.sign(dock,"Destination du ferry",(base*CFrame.new(0,7.0,7)).Position,math.deg(math.pi/2-item.angle),item.title.." · 6 PLACES",19,2.7)
    board.CanCollide=false
    -- Chemin piéton depuis la promenade; le groupe n'est pas téléporté dans l'océan.
    local tangent=Vector3.new(-math.sin(item.angle),0,math.cos(item.angle))
    local origin=pos-tangent*item.ferry_lane_offset+Vector3.new(0,0.4,0)
    local endp=pos+Vector3.new(0,0.4,0)
    F.part(dock,"Liaison piétonne",Vector3.new(8,0.7,(endp-origin).Magnitude+2),CFrame.lookAt((origin+endp)/2,endp),DECK,Enum.Material.WoodPlanks)
end
function Ferry.build(city)
    local root=F.folder(city,"Ferries collectifs — six lignes")
    for _,item in ipairs(Destinations) do
        lines[item.id]=item
        platform(root,item,"city")
        platform(root,item,"island")
    end
    root:SetAttribute("KinFerryLines",#Destinations)
    root:SetAttribute("KinFerryCapacity",CAPACITY)
    return root
end
local function key(id,direction)
    return id.."/"..direction
end
local function send(reply,player,data)
    if player.Parent==Players then reply:FireClient(player,data) end
end
local function positionOnBoat(slot)
    return Vector3.new(if slot%2==1 then -2.6 else 2.6,5.2,(math.floor((slot-1)/2)-1)*5.5)
end
local function announce(reply,trip,state,remaining)
    local people=0
    for player in pairs(trip.members) do
        if passengers[player] and player.Parent==Players then people+=1 end
    end
    for player in pairs(trip.members) do
        if passengers[player] and player.Parent==Players then
            send(reply,player,{
                kind="ferry.group.v2",state=state,tripId=trip.id,
                destination=trip.item.title,passengers=people,capacity=CAPACITY,
                duration=remaining or 0,
            })
        end
    end
end
local function release(player,record,destination)
    if passengers[player]~=record then return end
    passengers[player]=nil
    TravelSession.finish(player,record.travelToken)
    local trip=record.trip
    trip.members[player]=nil
    if player.Parent==Players then player:SetAttribute("KinFerryActive",false) end
    local char=record.character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if root and root.Parent then root.Anchored=false end
    if hum and hum.Parent then
        hum.WalkSpeed=record.speed
        hum.JumpPower=record.jumpPower
        hum.JumpHeight=record.jumpHeight
        hum.AutoRotate=record.autoRotate
    end
    if destination and char and char.Parent and root and root.Parent then
        char:PivotTo(CFrame.new(destination))
    end
end
local function sizeOf(trip)
    local n=0
    for player,record in pairs(trip.members) do
        if passengers[player]==record then n+=1 end
    end
    return n
end
local function abort(trip)
    if trip.closed then return end
    trip.closed=true
    if trips[trip.key]==trip then trips[trip.key]=nil end
    for player,record in pairs(trip.members) do
        if trip.reply and player.Parent==Players then
            send(trip.reply,player,{kind="ferry.group.v2",tripId=trip.id,state="cancel",duration=0})
        end
        local pos=trip.start+Vector3.new((record.slot-3)*2.2,4,0)
        release(player,record,pos)
    end
    if trip.vessel.Parent then trip.vessel:Destroy() end
end
local function orient(trip,cf)
    if trip.closed then return end
    trip.vessel:PivotTo(cf)
    for player,record in pairs(trip.members) do
        local char=record.character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if passengers[player]~=record or player.Parent~=Players or player.Character~=char
            or not char or not char.Parent or not hum or hum.Health<=0 then
            release(player,record,nil)
        else
            char:PivotTo(cf*CFrame.new(positionOnBoat(record.slot)))
        end
    end
end
local function sail(reply,trip)
    if trip.closed then return end
    trip.state="sailing"
    if trips[trip.key]==trip then trips[trip.key]=nil end
    if sizeOf(trip)==0 then abort(trip);return end
    local forward=(trip.finish-trip.start).Unit
    local duration=(trip.finish-trip.start).Magnitude/SPEED
    announce(reply,trip,"depart",duration)
    local t0=os.clock()
    local ok,err=pcall(function()
        while not trip.closed and trip.world.Parent and sizeOf(trip)>0 do
            local t=math.clamp((os.clock()-t0)/math.max(0.1,duration),0,1)
            local smooth=t*t*(3-2*t)
            local point=trip.start:Lerp(trip.finish,smooth)
            orient(trip,CFrame.lookAt(point,point+forward))
            if t>=1 then break end
            task.wait(0.075)
        end
    end)
    if not ok then warn("Kin City ferry collectif",err) end
    if ok and not trip.closed and trip.world.Parent and sizeOf(trip)>0 then
        announce(reply,trip,"arrive",0)
        for player,record in pairs(trip.members) do
            -- Évite de déposer plusieurs visiteurs au même endroit.
            local side=(record.slot-3.5)*2.9
            local lateral=Vector3.new(-forward.Z,0,forward.X)
            local drop=trip.finish+lateral*side+Vector3.new(0,4,0)
            release(player,record,drop)
        end
    end
    abort(trip)
end
local function countdown(reply,trip)
    while os.clock()<trip.deadline and not trip.closed and trip.world.Parent
        and sizeOf(trip)>0 and sizeOf(trip)<CAPACITY do
        announce(reply,trip,"boarding",math.max(0,trip.deadline-os.clock()))
        task.wait(0.9)
    end
    if trip.closed then return end
    if sizeOf(trip)==0 then abort(trip);return end
    sail(reply,trip)
end
local function addPassenger(reply,trip,player)
    if passengers[player] or trip.closed or trip.state~="boarding" then return end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or hum.Health<=0 or not root or root.Anchored or hum.SeatPart then return end
    local filled={}
    for _,r in pairs(trip.members) do filled[r.slot]=true end
    local slot=nil
    for n=1,CAPACITY do if not filled[n] then slot=n;break end end
    if not slot then return end
    local token=TravelSession.begin(player,"ferry")
    if not token then return end
    local record={trip=trip,character=char,slot=slot,travelToken=token,
        speed=hum.WalkSpeed,jumpPower=hum.JumpPower,jumpHeight=hum.JumpHeight,autoRotate=hum.AutoRotate}
    passengers[player]=record
    trip.members[player]=record
    player:SetAttribute("KinFerryActive",true)
    root.Anchored=true
    hum.WalkSpeed=0;hum.JumpPower=0;hum.JumpHeight=0;hum.AutoRotate=false
    local forward=(trip.finish-trip.start).Unit
    local frame=CFrame.lookAt(trip.start,trip.start+forward)
    orient(trip,frame)
    announce(reply,trip,"boarding",math.max(0,trip.deadline-os.clock()))
end
local function board(world,reply,player,item,direction)
    if passengers[player] then return end
    local id=key(item.id,direction)
    local trip=trips[id]
    if not trip or trip.closed or trip.state~="boarding" or sizeOf(trip)>=CAPACITY then
        sequence+=1
        local startRadius=if direction=="out" then item.ferry_start_radius else item.ferry_end_radius
        local endRadius=if direction=="out" then item.ferry_end_radius else item.ferry_start_radius
        local start=worldPosition(item,startRadius)
        local finish=worldPosition(item,endRadius)
        local active=world:FindFirstChild("Ferries actifs")
        if not active then active=F.folder(world,"Ferries actifs") end
        trip={id=tostring(sequence),key=id,item=item,world=world,reply=reply,
            start=start,finish=finish,members={},state="boarding",closed=false,
            deadline=os.clock()+BOARDING_SECONDS,vessel=boat(active,sequence)}
        trips[id]=trip
        local forward=(finish-start).Unit
        trip.vessel:PivotTo(CFrame.lookAt(start,start+forward))
        task.defer(countdown,reply,trip) -- Laisser embarquer le premier passager avant de démarrer le compte à rebours
    end
    addPassenger(reply,trip,player)
end
function Ferry.start(world,reply)
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinFerryIslandId")
        local direction=host:GetAttribute("KinFerryDirection")
        if type(id)~="string" or (direction~="out" and direction~="back") then return end
        if not RateLimiter.allowed(player,"ferry/"..id,1.0) then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        local item=lines[id]
        if item then board(world,reply,player,item,direction) end
    end)
    Players.PlayerRemoving:Connect(function(player)
        local record=passengers[player]
        if record then release(player,record,nil) end
    end)
    -- La destruction du monde libère immédiatement chaque personnage embarqué.
    world.Destroying:Connect(function()
        local collection={}
        for _,trip in pairs(trips) do collection[trip]=true end
        for _,record in pairs(passengers) do collection[record.trip]=true end
        for trip in pairs(collection) do abort(trip) end
    end)
end
return Ferry

]])
source(server,"IslandFootpaths","ModuleScript",[[
--!strict
-- Six boucles paysagères, 24 bornes de randonnée, 6 petits belvédères.
-- Les promenades sont physiques et accessibles sans téléportation.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("IslandDestinations"))
local Paths={}
local STONE=Color3.fromRGB(216,199,168)
local COPPER=Color3.fromRGB(207,165,102)
local NAVY=Color3.fromRGB(45,86,90)
local function simple(m,name,cf,size,color,material,collides)
    local part=F.part(m,name,size,cf,color,material)
    if collides==false then part.CanCollide=false;part.CanTouch=false end
    return part
end
function Paths.make(city)
    local root=F.folder(city,"Sentiers de l'archipel")
    for index,item in ipairs(Destinations) do
        local trail=F.folder(root,"Circuit de randonnée — "..item.title)
        local origin=Vector3.new(item.center_studs[1],0,item.center_studs[3])
        local base=CFrame.new(origin)*CFrame.Angles(0,math.pi/2-item.angle,0)
        local n=32
        local r=37
        for step=1,n do
            local a=(step-1)*math.pi*2/n
            local b=step*math.pi*2/n
            local av=(base*CFrame.new(math.cos(a)*r,0.95,math.sin(a)*r)).Position
            local bv=(base*CFrame.new(math.cos(b)*r,0.95,math.sin(b)*r)).Position
            local delta=bv-av
            simple(trail,"Chemin de ronde",CFrame.lookAt((av+bv)/2,bv),Vector3.new(4.5,0.28,delta.Magnitude+0.3),STONE,Enum.Material.Cobblestone,true)
            if step%4==0 then
                local lamp=simple(trail,"Balise du sentier",CFrame.new((av+bv)/2+Vector3.new(0,2.9,0)),Vector3.new(0.9,0.9,0.9),COPPER,Enum.Material.Neon,false)
                lamp.Shape=Enum.PartType.Ball
            end
        end
        for station=1,4 do
            local a=(station-1)*math.pi/2+0.32
            local pos=(base*CFrame.new(math.cos(a)*34,0,math.sin(a)*34)).Position
            local marker=simple(trail,"Halte insulaire "..station,CFrame.new(pos+Vector3.new(0,2.2,0)),Vector3.new(2.2,3.8,1.8),NAVY,Enum.Material.Metal,true)
            marker:SetAttribute("KinIslandTrailId",item.id..".stop."..station)
            marker:SetAttribute("KinTrailIslandId",item.id)
            marker:SetAttribute("KinTrailStopNumber",station)
            F.prompt(marker,"Découvrir","Halte du sentier")
            local rim=simple(trail,"Socle de la halte",CFrame.new(pos+Vector3.new(0,0.7,0)),Vector3.new(5,0.3,5),COPPER,Enum.Material.Cobblestone)
            rim.CanCollide=false
        end
        local spot=(base*CFrame.new(19,0.8,-31)).Position
        simple(trail,"Belvédère du sentier",CFrame.new(spot),Vector3.new(12,0.7,9),STONE,Enum.Material.WoodPlanks)
        for _,dx in ipairs({-5,5}) do
            local bar=simple(trail,"Garde-corps de belvédère",CFrame.new(spot+Vector3.new(dx,2.0,0)),Vector3.new(0.35,2.0,9),COPPER,Enum.Material.Metal,false)
            bar.CanCollide=false
        end
        trail:SetAttribute("KinTrailStops",4)
    end
    root:SetAttribute("KinTrailTotalStops",#Destinations*4)
    return root
end
return Paths

]])
source(server,"KingKlownAvatar","ModuleScript",[[
--!strict
-- KING KLOWN / Costume jouable pour Kin City
-- Uniquement les personnages des vrais joueurs, jamais les PNJ.
-- Les couleurs et toutes les pièces sont générées localement, sans AssetId.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")

local TEAL=Color3.fromRGB(30,104,100)
local DEEP=Color3.fromRGB(16,47,55)
local OPAL=Color3.fromRGB(197,244,240)
local GOLD=Color3.fromRGB(229,215,175)
local MID=Color3.fromRGB(47,127,119)
local PALE=Color3.fromRGB(244,239,231)
local BLACK=Color3.fromRGB(23,36,40)

local CollectionService=game:GetService("CollectionService")
local Avatar={}
local config={ownerUserId=0,studioPreview=true}
local records={}
local started=false
local OUTFIT_NAME="KingKlownCostume"

local function part(costume:Model,ref:BasePart,name:string,size:Vector3,offset:CFrame,
                  tint:Color3,material:Enum.Material,shape:Enum.PartType?,wedge:boolean?):BasePart
    local p=Instance.new(if wedge then "WedgePart" else "Part")
    p.Name=name
    p.Size=size
    p.Color=tint
    p.Material=material
    p.Transparency=0
    if shape and p:IsA("Part") then p.Shape=shape end
    p.Anchored=false
    p.Massless=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.CFrame=ref.CFrame*offset
    p.Parent=costume
    local w=Instance.new("WeldConstraint")
    w.Name="Fixation du costume"
    w.Part0=ref
    w.Part1=p
    w.Parent=p
    return p
end

local function findPart(character:Model,...:string):BasePart?
    for _,name in ipairs({...}) do
        local item=character:FindFirstChild(name)
        if item and item:IsA("BasePart") then return item end
    end
    return nil
end

local function decorate(player:Player,character:Model)
    if player.Character~=character then return false end
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return false end
    local head=findPart(character,"Head")
    local torso=findPart(character,"UpperTorso","Torso")
    if not head or not torso then return false end

    local record=records[player]
    for _,connection in ipairs(record.faceConnections) do connection:Disconnect() end
    table.clear(record.faceConnections)
    local old=character:FindFirstChild(OUTFIT_NAME)
    if old then old:Destroy() end
    -- Le nom King Klown v2 était attaché directement à la tête.
    -- Ne pas le conserver lorsqu'un nouveau costume est équipé.
    local oldNameplate=head:FindFirstChild("KingKlownNameplate")
    if oldNameplate then oldNameplate:Destroy() end
    -- Le style reste visible sans accessoires Roblox ajoutés par-dessus.
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants")
            or child:IsA("ShirtGraphic") then
            child:Destroy()
        end
    end

    local colors=character:FindFirstChildOfClass("BodyColors")
    if not colors then colors=Instance.new("BodyColors");colors.Parent=character end
    colors.HeadColor3=PALE
    colors.TorsoColor3=DEEP
    colors.LeftArmColor3=TEAL
    colors.RightArmColor3=TEAL
    colors.LeftLegColor3=TEAL
    colors.RightLegColor3=TEAL

    local costume=Instance.new("Model")
    costume.Name=OUTFIT_NAME
    costume:SetAttribute("KinCityPlayableAvatar",true)
    costume:SetAttribute("KingKlownStyle","Trickster v6 #1E6864 : tête sculptée et aura locale")
    costume.Parent=character

    -- Une coque ellipsoïdale complète remplace VISUELLEMENT la tête native.
    -- Les joints, la caméra et la physique de la vraie Head sont conservés.
    -- Cela masque aussi les visages intégrés aux têtes MeshPart/dynamiques.
    head.Transparency=1
    part(costume,head,"Tête ronde King Klown",head.Size,CFrame.identity,
        PALE,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    local function hideNativeFace(item)
        if item:IsA("Decal") or item:IsA("Texture") then item.Transparency=1 end
        if item:IsA("SurfaceGui") then item.Enabled=false end
    end
    for _,item in ipairs(head:GetDescendants()) do hideNativeFace(item) end
    table.insert(record.faceConnections,head.DescendantAdded:Connect(hideNativeFace))
    table.insert(record.faceConnections,head:GetPropertyChangedSignal("Transparency"):Connect(function()
        if head.Transparency~=1 then head.Transparency=1 end
    end))

    -- Projette chaque détail sur une ellipsoïde épousant les dimensions de
    -- la tête (y compris les variantes R6/R15). Le nez, les yeux et la bouche
    -- ne reposent plus sur une grande surface rectangulaire rigide.
    local function facePose(x:number,y:number,angle:number?):CFrame
        x=x*head.Size.X/2
        y=y*head.Size.Y
        local rx=math.max(head.Size.X*0.5,0.01)
        local ry=math.max(head.Size.Y*0.5,0.01)
        local rz=math.max(head.Size.Z*0.5,0.01)
        local u=math.clamp(x/rx,-0.86,0.86)
        local v=math.clamp(y/ry,-0.86,0.86)
        local z=-rz*math.sqrt(math.max(0.16,1-u*u-v*v))
        local surface=Vector3.new(x,y,z)
        local normal=Vector3.new(x/(rx*rx),y/(ry*ry),z/(rz*rz)).Unit
        local point=surface+normal*0.035
        return CFrame.lookAt(point,point+normal)*CFrame.Angles(0,0,angle or 0)
    end

    local function hair(name,size,offset,tint,material,shape,wedge)
        local scale=Vector3.new(head.Size.X/2,head.Size.Y,head.Size.Z)
        local position=offset.Position*scale
        return part(costume,head,name,size*scale,CFrame.new(position)*offset.Rotation,tint,material,shape,wedge)
    end
    -- Chevelure ÉCHEVELÉE : épis de cheveux opaques, sans couronne ni glow.
    -- Toute la chevelure suit naturellement les animations de la tête.
    hair("Masse de cheveux sarcelle",Vector3.new(1.77,0.58,1.44),
        CFrame.new(0,0.65,0.07),DEEP,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    hair("Toupet désordonné",Vector3.new(1.49,0.35,0.67),
        CFrame.new(-0.06,0.61,-0.48)*CFrame.Angles(0,0,math.rad(-9)),TEAL,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    for i=1,13 do
        local a=i*2*math.pi/13
        local x=math.cos(a)*0.67
        local z=math.sin(a)*0.54
        local tall=0.52+((i*7)%5)*0.14
        local outward=math.rad(18+((i*11)%4)*9)
        local tilt=math.atan2(x,0.75)+math.sin(i*2.3)*0.22
        hair("Mèche folle "..i,Vector3.new(0.32,tall,0.33),
            CFrame.new(x,0.86+((i%3)-1)*0.06,z)
                *CFrame.Angles(outward*math.sin(a),a*0.45,-tilt),
            if i%4==0 then MID elseif i%3==0 then DEEP else TEAL,
            Enum.Material.SmoothPlastic,nil,true)
    end
    -- Frange en diagonale + deux mèches latérales reconnaissables de loin.
    for i=-2,2 do
        hair("Frange rebelle "..i,Vector3.new(0.28,0.40+(i%2)*0.05,0.30),
            CFrame.new(i*0.27,0.61-i*0.005,-0.60)
                *CFrame.Angles(math.rad(-21),0,math.rad(-22+i*8)),
            if i==0 then DEEP else TEAL,Enum.Material.SmoothPlastic,nil,true)
    end
    for _,side in ipairs({-1,1}) do
        hair("Mèche latérale",Vector3.new(0.30,0.74,0.30),
            CFrame.new(side*0.79,0.31,0.09)*CFrame.Angles(0,0,side*math.rad(-28)),
            TEAL,Enum.Material.SmoothPlastic,nil,true)
    end

    -- EXPRESSION V5 : une seule paire d'yeux, deux sourcils expressifs et
    -- un seul sourire. Les détails suivent la COURBURE de la tête ronde.
    part(costume,head,"Œil gauche ouvert",Vector3.new(0.215,0.225,0.09),
        facePose(-0.255,0.085),BLACK,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    part(costume,head,"Œil droit mi-clos",Vector3.new(0.21,0.135,0.09),
        facePose(0.255,0.085,math.rad(-5)),BLACK,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    -- Reflet MINUSCULE placé dans le premier œil, jamais un troisième œil.
    part(costume,head,"Reflet opalin",Vector3.new(0.026,0.026,0.018),
        facePose(-0.28,0.125)*CFrame.new(0,0,-0.052),OPAL,Enum.Material.SmoothPlastic,Enum.PartType.Ball)

    part(costume,head,"Sourcil espiègle relevé",Vector3.new(0.35,0.050,0.078),
        facePose(-0.255,0.300,math.rad(-10)),DEEP,Enum.Material.SmoothPlastic)
    part(costume,head,"Sourcil complice",Vector3.new(0.33,0.050,0.078),
        facePose(0.250,0.230,math.rad(3)),DEEP,Enum.Material.SmoothPlastic)

    -- Un sourire courbé, sans moustache ni grimace. Chacun des 4 morceaux suit
    -- la sphère et est joint au suivant pour donner UN arc continu.
    local grin={
        Vector2.new(-0.28,-0.192),
        Vector2.new(-0.15,-0.235),
        Vector2.new( 0.015,-0.246),
        Vector2.new( 0.17,-0.215),
        Vector2.new( 0.30,-0.145),
    }
    local smooth={}
    for i=1,#grin-1 do
        for j=0,2 do table.insert(smooth,grin[i]:Lerp(grin[i+1],j/3)) end
    end
    table.insert(smooth,grin[#grin])
    grin=smooth
    for i=1,#grin-1 do
        local a,b=grin[i],grin[i+1]
        local delta=b-a
        local midpoint=(a+b)*0.5
        part(costume,head,"Sourire du trickster · arc "..i,
            Vector3.new(delta.Magnitude+0.018,0.044,0.085),
            facePose(midpoint.X,midpoint.Y,math.atan2(delta.Y,delta.X)),
            DEEP,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    end

    -- Tenue trickster sarcelle, en fines incrustations qui suivent le torse.
    local front=-(torso.Size.Z/2+0.095)
    part(costume,torso,"Veston trickster",Vector3.new(torso.Size.X*0.93,torso.Size.Y*0.88,0.18),
        CFrame.new(0,0.02,front),TEAL,Enum.Material.SmoothPlastic)
    for _,side in ipairs({-1,1}) do
        part(costume,torso,"Revers de veste",Vector3.new(torso.Size.X*0.35,torso.Size.Y*0.59,0.10),
            CFrame.new(side*torso.Size.X*0.19,0.10,front-0.13)*CFrame.Angles(0,0,side*math.rad(19)),
            DEEP,Enum.Material.SmoothPlastic)
        part(costume,torso,"Passementerie",Vector3.new(0.08,torso.Size.Y*0.66,0.08),
            CFrame.new(side*torso.Size.X*0.38,-0.02,front-0.17),GOLD,Enum.Material.Metal)
    end
    part(costume,torso,"Insigne du fripon",Vector3.new(0.36,0.36,0.16),
        CFrame.new(0,0.15,front-0.22)*CFrame.Angles(0,0,math.pi/4),OPAL,Enum.Material.SmoothPlastic)
    for n=1,3 do
        part(costume,torso,"Bouton de cérémonie "..n,Vector3.new(0.13,0.13,0.13),
            CFrame.new(0,-0.15-(n-1)*0.21,front-0.25),GOLD,Enum.Material.Metal,Enum.PartType.Ball)
    end

    -- Cape sarcelle et bleu nuit à trois pans. Tous les pans sont souples VISUELLEMENT :
    -- soudés au torse, sans collisions ou simulateur de tissu gourmand.
    for i=-1,1 do
        local width=torso.Size.X*(if i==0 then 0.51 else 0.37)
        part(costume,torso,"Cape sarcelle "..i,Vector3.new(width,torso.Size.Y*1.60,0.10),
            CFrame.new(i*torso.Size.X*0.29,-torso.Size.Y*0.83,torso.Size.Z/2+0.12)
                *CFrame.Angles(math.rad(-9),0,math.rad(-i*6)),
            if i==0 then TEAL else DEEP,Enum.Material.SmoothPlastic)
    end
    part(costume,torso,"Broche opaline",Vector3.new(0.26,0.26,0.24),
        CFrame.new(torso.Size.X*0.32,torso.Size.Y*0.35,front-0.20),OPAL,Enum.Material.SmoothPlastic,Enum.PartType.Ball)

    -- Gants, poignets, chaussures. Prend en charge R15 et R6.
    for _,side in ipairs({"Left","Right"}) do
        local arm=findPart(character,side.."LowerArm",side.." Arm",side.."UpperArm")
        if arm then
            part(costume,arm,"Manchette de scène "..side,
                Vector3.new(arm.Size.X*1.07,0.24,arm.Size.Z*1.07),
                CFrame.new(0,-arm.Size.Y*0.29,0),GOLD,Enum.Material.Metal)
        end
        local foot=findPart(character,side.."Foot",side.." Leg")
        if foot then
            part(costume,foot,"Chaussure de spectacle "..side,
                Vector3.new(foot.Size.X*1.07,math.max(0.22,foot.Size.Y*0.49),foot.Size.Z*1.11),
                CFrame.new(0,-foot.Size.Y*0.26,-0.06),DEEP,Enum.Material.SmoothPlastic)
            part(costume,foot,"Boucle chaussure "..side,Vector3.new(0.23,0.18,0.10),
                CFrame.new(0,-foot.Size.Y*0.11,-foot.Size.Z*0.53),GOLD,Enum.Material.Metal)
        end
    end

    -- Baguette de tours fixée à la main droite; cela ne crée aucun Tool et
    -- n'empêche pas les interactions avec E, la marche ou les transports.
    local hand=findPart(character,"RightHand","Right Arm")
    if hand then
        part(costume,hand,"Baguette du trickster",Vector3.new(0.12,1.4,0.12),
            CFrame.new(0,-0.53,-0.28)*CFrame.Angles(math.rad(-16),0,0),GOLD,Enum.Material.Metal)
        part(costume,hand,"Éclat de la baguette",Vector3.new(0.42,0.42,0.42),
            CFrame.new(0,0.19,-0.43),OPAL,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    end

    -- Aura créée par chaque client, jamais animée/répliquée par le serveur.
    costume:SetAttribute("KingKlownAura",true)
    CollectionService:AddTag(costume,"KingKlownAvatar")

    -- Nom affiché à distance raisonnable, sans duplicata du nom Roblox.
    humanoid.DisplayName="King Klown"
    humanoid.NameDisplayDistance=0
    local sign=Instance.new("BillboardGui")
    sign.Name="KingKlownNameplate"
    sign.Adornee=head
    sign.Size=UDim2.fromOffset(240,45)
    sign.StudsOffsetWorldSpace=Vector3.new(0,3.25,0)
    sign.MaxDistance=85
    sign.AlwaysOnTop=false
    sign.Parent=costume
    local text=Instance.new("TextLabel")
    text.Size=UDim2.fromScale(1,1)
    text.BackgroundTransparency=1
    text.Font=Enum.Font.GothamBlack
    text.Text="✦ KING KLOWN ✦"
    text.TextColor3=GOLD
    text.TextStrokeColor3=DEEP
    text.TextStrokeTransparency=0.12
    text.TextScaled=true
    text.Parent=sign

    character:SetAttribute("KinCityCharacter","King Klown")
    return true
end

local function selected(player:Player):boolean
    if config.ownerUserId>0 then return player.UserId==config.ownerUserId end
    if RunService:IsStudio() then return config.studioPreview end
    return game.CreatorType==Enum.CreatorType.User and game.CreatorId>0
        and player.UserId==game.CreatorId
end

local function bind(player)
    if records[player] or not selected(player) then return end
    local record={connections={},faceConnections={},generation=0,dressed=nil}
    records[player]=record
    local function schedule(character,appearanceLoaded)
        record.generation+=1
        local generation=record.generation
        task.spawn(function()
            if not character:WaitForChild("HumanoidRootPart",12) then return end
            if not character:WaitForChild("Head",12) then return end
            local humanoid=character:WaitForChild("Humanoid",12)
            if not humanoid or not humanoid:IsA("Humanoid") then return end
            local torsoName=if humanoid.RigType==Enum.HumanoidRigType.R15 then "UpperTorso" else "Torso"
            if not character:WaitForChild(torsoName,12) then return end
            if not appearanceLoaded and not player:HasAppearanceLoaded() then task.wait(2.5) end
            if records[player]~=record or generation~=record.generation
                or player.Character~=character then return end
            -- L'événement tardif d'apparence reconstruit le costume une seule fois.
            local ok,result=pcall(decorate,player,character)
            if ok and result then record.dressed=character
            elseif not ok then warn("King Klown : "..tostring(result)) end
        end)
    end
    table.insert(record.connections,player.CharacterAdded:Connect(function(character)
        schedule(character,false)
    end))
    table.insert(record.connections,player.CharacterAppearanceLoaded:Connect(function(character)
        if player.Character==character then schedule(character,true) end
    end))
    table.insert(record.connections,player.CharacterRemoving:Connect(function()
        record.generation+=1
        record.dressed=nil
        for _,connection in ipairs(record.faceConnections) do connection:Disconnect() end
        table.clear(record.faceConnections)
    end))
    if player.Character then schedule(player.Character,player:HasAppearanceLoaded()) end
end
function Avatar.start(options)
    if started then return end
    started=true
    config=options or config
    config.ownerUserId=tonumber(config.ownerUserId) or 0
    Players.PlayerAdded:Connect(bind)
    Players.PlayerRemoving:Connect(function(player)
        local record=records[player]
        if not record then return end
        record.generation+=1
        for _,connection in ipairs(record.connections) do connection:Disconnect() end
        for _,connection in ipairs(record.faceConnections) do connection:Disconnect() end
        records[player]=nil
    end)
    for _,player in ipairs(Players:GetPlayers()) do bind(player) end
end
return Avatar

]])
source(server,"LearningConservatories","ModuleScript",[[
--!strict
-- Huit pavillons d'expérimentation, construits en matériaux Roblox natifs.
-- Activités pédagogiques locales, indépendantes des cours et API kOA.
local F=require(script.Parent.Factory)
local Pavilions={}
local TEAL=Color3.fromRGB(42,77,82)
local BRASS=Color3.fromRGB(201,170,110)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local themes=require(Shared:WaitForChild("PublicDestinations"))
local function part(m,name,base,x,y,z,w,h,d,c,material,solid)
    local p=F.part(m,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),c,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false end
    return p
end
local function model(root,id,name)
    local m=Instance.new("Model");m.Name=name;m:SetAttribute("KinScienceExhibitId",id);m.Parent=root
    return m
end
local function sphere(m,name,base,x,y,z,size,c)
    local p=part(m,name,base,x,y,z,size,size,size,c,Enum.Material.Neon,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function exhibit(parent,base,theme,index)
    local modelRoot=model(parent,"kin.science."..theme.kind,theme.title)
    part(modelRoot,"Socle de manipulation",base,0,1.6,-1,8.6,3.2,7.2,TEAL,Enum.Material.Marble,true)
    local front=part(modelRoot,"Console d'expérience",base,0,3.4,-4.6,5,3,1.2,BRASS,Enum.Material.Metal,true)
    front:SetAttribute("KinScienceExhibitId","kin.science."..theme.kind)
    front:SetAttribute("KinScienceKind",theme.kind)
    F.prompt(front,"Expérimenter",theme.title)
    local orb=sphere(modelRoot,"Noyau lumineux",base,0,5,-1,3,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]))
    orb:SetAttribute("KinScienceLight",true)
    orb.Transparency=0.6
    local light=Instance.new("PointLight")
    light.Color=Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]);light.Range=15;light.Brightness=0.2;light.Parent=orb
    if theme.kind=="astronomy" then
        for i=1,5 do
            local a=2*math.pi*i/5
            local p=sphere(modelRoot,"Planète orbitale",base,math.cos(a)*(3.5+i*0.35),4.5+math.sin(a)*1.1,math.sin(a)*(3.5+i*0.35),1.0+(i%2)*0.5,Color3.fromHSV(i/6,0.6,0.9))
            p:SetAttribute("KinScienceRotor",true)
        end
    elseif theme.kind=="optics" then
        for i=1,7 do
            local beam=part(modelRoot,"Spectre",base,(i-4)*0.7,5.1,2,0.45,0.5,7,Color3.fromHSV(i/7,0.9,1),Enum.Material.Neon,false)
            beam:SetAttribute("KinScienceLight",true);beam.Transparency=0.83
        end
    elseif theme.kind=="water" then
        for i=1,6 do
            local blade=part(modelRoot,"Roue hydraulique",base,math.cos(i*math.pi/3)*3,4.9,math.sin(i*math.pi/3)*3-1,3.3,0.45,0.65,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Metal,false)
            blade:SetAttribute("KinScienceRotor",true)
        end
    elseif theme.kind=="energy" then
        for i=1,5 do
            local circuit=part(modelRoot,"Circuit électroluminescent",base,-4+i*1.8,4.2,1.8,1.0,0.15,5,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Neon,false)
            circuit:SetAttribute("KinScienceLight",true);circuit.Transparency=0.82
        end
    elseif theme.kind=="engineering" then
        local lever=part(modelRoot,"Levier mécanique",base,0,5.3,1.5,10,0.55,0.75,BRASS,Enum.Material.Metal,false)
        lever:SetAttribute("KinScienceRotor",true)
        for _,side in ipairs({-1,1}) do
            sphere(modelRoot,"Contrepoids",base,side*4.7,4.25,1.5,1.8,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]))
        end
    elseif theme.kind=="sound" then
        for i=1,7 do
            local chime=part(modelRoot,"Tube vibrant",base,(i-4)*1.2,6.2-(i%3)*0.6,2.6,0.42,5.3+(i%3),0.45,BRASS,Enum.Material.Metal,false)
            chime:SetAttribute("KinScienceRotor",true)
        end
    else
        for i=1,7 do
            local a=i*2.399963
            local bud=sphere(modelRoot,"Organisme",base,math.cos(a)*3.5,4.5+(i%3),math.sin(a)*2.8+0.5,1.1+(i%2)*0.8,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]))
            bud:SetAttribute("KinScienceLight",true);bud.Transparency=0.35
        end
    end
end
local function pavilion(root,theme,index)
    local angle=theme.angle
    local center=Vector3.new(theme.center_studs[1],0.15,theme.center_studs[3])
    local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-angle,0)
    local m=model(root,theme.id,theme.title)
    part(m,"Plancher de la serre",base,0,-0.33,0,29,0.7,32,Color3.fromRGB(221,208,174),Enum.Material.Marble,true)
    -- Trois murs vitrés; la façade sud demeure largement ouverte.
    for _,x in ipairs({-14,14}) do
        for _,z in ipairs({-13,0,13}) do
            part(m,"Poteau de serre",base,x,8,z,0.8,16,0.8,TEAL,Enum.Material.Metal,true)
        end
        local glass=part(m,"Verrière latérale",base,x,9,0,0.2,14,26,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Glass,false)
        glass.Transparency=0.69
    end
    for _,x in ipairs({-12,0,12}) do
        part(m,"Poutre du fond",base,x,8,15,0.8,16,0.8,TEAL,Enum.Material.Metal,true)
    end
    local rear=part(m,"Verrière du fond",base,0,8,15,25,14,0.2,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Glass,false)
    rear.Transparency=0.72
    -- Toit en couronne : lumière et ciel visibles du centre.
    for _,x in ipairs({-10,10}) do part(m,"Bande vitrée supérieure",base,x,16,0,8.5,0.65,32,Color3.fromRGB(theme.color[1],theme.color[2],theme.color[3]),Enum.Material.Glass,false).Transparency=0.35 end
    for _,z in ipairs({-13,13}) do part(m,"Linteau supérieur",base,0,16,z,29,0.7,2.4,TEAL,Enum.Material.Metal,true) end
    for _,x in ipairs({-11,11}) do
        local s=Instance.new("Seat")
        s.Name="Siège d'observation";s.Size=Vector3.new(3.6,0.8,3.0)
        s.CFrame=base*CFrame.new(x,1.1,-9);s.Anchored=true;s.Material=Enum.Material.WoodPlanks;s.Color=Color3.fromRGB(162,122,82);s.Parent=m
    end
    for _,x in ipairs({-10,10}) do for _,z in ipairs({-3,7}) do
        part(m,"Jardinière",base,x,1.2,z,3.3,2.2,4.0,Color3.fromRGB(117,95,76),Enum.Material.Slate,true)
        local leaf=part(m,"Plante pédagogique",base,x,3.15,z,3.9,3.5,3.9,Color3.fromRGB(67+index*8,157,111),Enum.Material.Grass,false)
        leaf.Shape=Enum.PartType.Ball
    end end
    exhibit(m,base,theme,index)
    local label=F.sign(m,"Enseigne du pavillon",(base*CFrame.new(0,14,-16.7)).Position,math.deg(math.pi/2-angle),theme.title,23,3)
    label.CanCollide=false
    -- Alignement de pierres entre les promenades et l'entrée.
    for j=1,5 do
        part(m,"Pas japonais",base,0,-0.08,-17-j*2,4.4,0.2,1.6,Color3.fromRGB(227,215,185),Enum.Material.Cobblestone,false)
    end
end
function Pavilions.make(city)
    local root=F.folder(city,"Pavillons scientifiques publics")
    for i,theme in ipairs(themes) do pavilion(root,theme,i) end
    root:SetAttribute("KinSciencePavilions",#themes)
    return root
end
function Pavilions.isReserved(x,z)
    for index=1,#themes do
        local dx=x-themes[index].center_studs[1]
        local dz=z-themes[index].center_studs[3]
        if dx*dx+dz*dz<35*35 then return true end
    end
    return false
end
return Pavilions

]])
source(server,"LivingExhibitsV23","ModuleScript",[[
--!strict
-- Huit expositions interactives à quatre chapitres. Les textes sont locaux,
-- consultables sans kOA; les changements de sculpture et de panneau répliquent.
-- Aucune décision, note ou vote n'est simulé.
local ProximityPromptService=game:GetService("ProximityPromptService")
local Kit=require(script.Parent.CrystalKit)
local Factory=require(script.Parent.Factory)
local Atlas={}
local pages={
    city_hall={
        {"La cité", "Les rues et places forment un espace de rencontre."},
        {"Les quartiers", "Chaque quartier possède sa silhouette et ses usages."},
        {"La place centrale", "Le mandala relie les promenades de Kin City."},
        {"La visite", "Explore les jardins, bâtiments et espaces publics."},
    },
    ekoh_tower={
        {"Curiosité", "Une idée naît souvent d'une question simple."},
        {"Transmission", "Observer et expliquer sont deux gestes complémentaires."},
        {"Constellations", "Des points distincts dessinent un savoir partagé."},
        {"Exploration", "La ville offre des découvertes sans score."},
    },
    library={
        {"Les livres", "Chaque volume invite à découvrir une histoire."},
        {"Les archives", "Conserver permet de retrouver et comparer."},
        {"Les cartes", "Les plans racontent la forme de notre cité."},
        {"L'imaginaire", "Les récits relient des mondes possibles."},
    },
    campus={
        {"Observer", "Une expérience commence par une observation."},
        {"Mesurer", "Les instruments nous aident à comparer."},
        {"Les orbites", "Les trajectoires révèlent des régularités."},
        {"Questionner", "Chaque réponse peut ouvrir une autre question."},
    },
    justice_palace={
        {"Écouter", "Un dialogue demande du temps et de l'attention."},
        {"Comprendre", "Les perspectives d'une situation peuvent varier."},
        {"Équilibre", "Une balance symbolise la recherche de justesse."},
        {"Respect", "La dignité de chacun guide les espaces de rencontre."},
    },
    innovation_lab={
        {"Imaginer", "Une invention commence par une possibilité."},
        {"Fabriquer", "Un premier assemblage rend l'idée tangible."},
        {"Essayer", "Les prototypes permettent d'apprendre."},
        {"Repenser", "Améliorer une machine exige d'observer ses effets."},
    },
    museum={
        {"Matière", "Les formes changent selon la lumière."},
        {"Couleurs", "Les teintes créent une ambiance singulière."},
        {"Mouvement", "Une œuvre peut se lire en marchant autour."},
        {"Création", "L'art propose des rencontres inattendues."},
    },
    orgo_center={
        {"Relier", "Un chemin associe deux lieux distincts."},
        {"Assembler", "De petites unités composent un ensemble."},
        {"Circuler", "Les passages permettent de traverser la ville."},
        {"Coordonner", "Un réseau vivant évolue au fil des usages."},
    },
}
local function piece(parent,kind,name,size,cf,color,material,optional)
    local obj=Kit.part(parent,kind,name,size,cf,color,material or Enum.Material.Slate)
    if optional then obj:SetAttribute("KinOptionalDetail",true) end
    return obj
end
local function caption(parent,name,position,size,text,textSize)
    local gui=Instance.new("SurfaceGui")
    gui.Name=name
    gui.Face=Enum.NormalId.Front
    gui.CanvasSize=Vector2.new(700,280)
    gui.LightInfluence=0
    gui.Parent=parent
    local label=Instance.new("TextLabel")
    label.Name="Contenu"
    label.Size=UDim2.fromScale(1,1)
    label.Position=UDim2.fromScale(0,0)
    label.BackgroundTransparency=1
    label.TextColor3=Kit.pearl
    label.Font=Enum.Font.GothamMedium
    label.TextWrapped=true
    label.TextSize=textSize
    label.Text=text
    label.Parent=gui
    return label
end
local function render(host,placeKey,pageIndex)
    local collection=pages[placeKey]
    if not collection then return end
    local page=collection[pageIndex]
    if not page then return end
    local heading=host:FindFirstChild("TitreChapitre",true)
    local body=host:FindFirstChild("TexteChapitre",true)
    local progress=host:FindFirstChild("Pagination",true)
    if heading and heading:IsA("TextLabel") then heading.Text=page[1] end
    if body and body:IsA("TextLabel") then body.Text=page[2] end
    if progress and progress:IsA("TextLabel") then progress.Text=tostring(pageIndex).." / "..tostring(#collection) end
    local gem=host.Parent and host.Parent:FindFirstChild("Noyau de chapitre")
    if gem and gem:IsA("BasePart") then
        local initial=gem:GetAttribute("KinOriginalCFrame")
        -- Référence reconstructible depuis une position fixe; pas de dérive cumulative.
        local base=host.CFrame*CFrame.new(0,2.65,0.2)
        gem.CFrame=base*CFrame.Angles(0,(pageIndex-1)*math.pi/2,math.rad(12))
        gem.Color=if pageIndex%2==0 then Kit.gold else Kit.accent(placeKey)
    end
    host:SetAttribute("KinAtlasPage",pageIndex)
end
function Atlas.decorate(roomFolder,placeKey,room,origin,index)
    local collection=pages[placeKey]
    if index~=1 or not collection then return end
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<30 or d<28 then return end
    local root=Instance.new("Model")
    root.Name="Atlas vivant — "..placeKey
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v23")
    root.Parent=roomFolder
    local localBase=CFrame.new(origin+Vector3.new(cx+w/2-10,0,cz-d/2+13))*CFrame.Angles(0,math.pi/2,0)
    piece(root,"Part","Socle de consultation",Vector3.new(7.8,1.2,4),localBase*CFrame.new(0,0.6,0),Kit.deep,Enum.Material.Marble,false)
    piece(root,"Part","Feuillet champagne",Vector3.new(7.6,0.22,4.1),localBase*CFrame.new(0,1.32,0),Kit.gold,Enum.Material.Metal,false)
    local host=piece(root,"Part","Écran de chapitres",Vector3.new(7.0,4.4,0.45),localBase*CFrame.new(0,4.3,1.38),Kit.deep,Enum.Material.Slate,false)
    host:SetAttribute("KinExhibitV23",true)
    host:SetAttribute("KinExhibitPlace",placeKey)
    host:SetAttribute("KinAtlasPage",1)
    local headingSurface=Instance.new("SurfaceGui")
    headingSurface.Name="Panneau de titre"
    headingSurface.Face=Enum.NormalId.Front
    headingSurface.CanvasSize=Vector2.new(700,200)
    headingSurface.LightInfluence=0
    headingSurface.Parent=host
    local heading=Instance.new("TextLabel")
    heading.Name="TitreChapitre"
    heading.Size=UDim2.fromScale(0.94,0.4)
    heading.Position=UDim2.fromScale(0.03,0.04)
    heading.TextColor3=Kit.gold
    heading.BackgroundTransparency=1
    heading.Font=Enum.Font.GothamBold
    heading.TextWrapped=true
    heading.TextSize=39
    heading.Parent=headingSurface
    local body=Instance.new("TextLabel")
    body.Name="TexteChapitre"
    body.Size=UDim2.fromScale(0.94,0.48)
    body.Position=UDim2.fromScale(0.03,0.46)
    body.TextColor3=Kit.pearl
    body.BackgroundTransparency=1
    body.Font=Enum.Font.Gotham
    body.TextWrapped=true
    body.TextSize=30
    body.Parent=headingSurface
    local progress=Instance.new("TextLabel")
    progress.Name="Pagination"
    progress.Size=UDim2.fromScale(0.2,0.17)
    progress.Position=UDim2.fromScale(0.78,0.01)
    progress.TextColor3=Kit.gold
    progress.BackgroundTransparency=1
    progress.Font=Enum.Font.GothamBold
    progress.TextSize=21
    progress.Parent=headingSurface
    piece(root,"WedgePart","Noyau de chapitre",Vector3.new(1.8,1.7,1.5),host.CFrame*CFrame.new(0,2.65,0.2),Kit.accent(placeKey),Enum.Material.Slate,false)
    local prompt=Factory.prompt(host,"Chapitre suivant","Exposition de Kin City")
    prompt.MaxActivationDistance=12
    render(host,placeKey,1)
    return root
end
function Atlas.start(world)
    local last=setmetatable({},{__mode="k"})
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or host:GetAttribute("KinExhibitV23")~=true then return end
        if not host:IsDescendantOf(world) then return end
        local placeKey=host:GetAttribute("KinExhibitPlace")
        local collection=pages[placeKey]
        if not collection then return end
        local character=player.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local rootPart=character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or humanoid.Health<=0 or not rootPart or not rootPart:IsA("BasePart") then return end
        if (rootPart.Position-host.Position).Magnitude>15 then return end
        local now=os.clock()
        if last[player] and now-last[player]<0.35 then return end
        last[player]=now
        local current=host:GetAttribute("KinAtlasPage") or 1
        render(host,placeKey,(current%#collection)+1)
    end)
end
return Atlas

]])
source(server,"LocalMechanisms","ModuleScript",[[
--!strict
-- Service central des mécanismes purement LOCAUX. Aucune requête réseau.
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RateLimiter=require(script.Parent.RateLimiter)
local Mechanisms={}

function Mechanisms.start(world,reply)
    -- Les ouvrages ont été générés dans Studio : les attributs restent la source de vérité.
    -- Le routeur métier ignore volontairement ces prompts.
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local id=host:GetAttribute("KinLocalMechanismId")
        if type(id)~="string" or not prompt.Enabled or not host:IsDescendantOf(world) then return end
        local parent=host.Parent
        if not parent or not parent:IsA("Model") or parent:GetAttribute("KinPublicSpaceId")~=id then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not root then return end
        if (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"mechanism/"..id,1.5) then return end
        local active=not (parent:GetAttribute("KinLocalMechanismActive")==true)
        parent:SetAttribute("KinLocalMechanismActive",active)
        for _,part in ipairs(parent:GetDescendants()) do
            if part:IsA("BasePart") then
                if part:GetAttribute("KinReactiveLight")==true then
                    TweenService:Create(part,TweenInfo.new(0.65),{Transparency=active and 0.05 or 0.65}):Play()
                    local light=part:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=active end
                end
                if part:GetAttribute("KinReactiveRotor")==true then
                    local initial=part:GetAttribute("KinRotorRestFrame")
                    if typeof(initial)~="CFrame" then
                        initial=part.CFrame
                        part:SetAttribute("KinRotorRestFrame",initial)
                    end
                    local destination=if active then initial*CFrame.Angles(0,math.pi,0) else initial
                    TweenService:Create(part,TweenInfo.new(1.2,Enum.EasingStyle.Sine),{CFrame=destination}):Play()
                end
            end
        end
        prompt.ActionText=active and "Désactiver" or "Activer"
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Installation interactive",
            message=active and "Installation activée" or "Installation désactivée",
            notice="Cette démonstration fonctionne dans Roblox, sans accès à kOA."
        })
    end)
end
return Mechanisms

]])
source(server,"MarinaDistrict","ModuleScript",[[
--!strict
-- V9 : deux vraies marinas, quatre ateliers couverts visitables sans téléportation,
-- phares, petits jardins de sel, kiosques et quais d'observation. 100% natif.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("MarinaDestinations"))
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local Marina={}
local HULL=Color3.fromRGB(30,104,100)
local WOOD=Color3.fromRGB(163,116,77)
local SAND=Color3.fromRGB(224,211,179)
local BRASS=Color3.fromRGB(230,184,111)
local GLASS=Color3.fromRGB(197,244,240)
local function part(parent,name,base,x,y,z,w,h,d,color,material,collide)
    local p=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if collide==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function ball(parent,name,base,x,y,z,diam,color,material)
    local p=part(parent,name,base,x,y,z,diam,diam,diam,color,material,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function seat(parent,base,x,z)
    local p=Instance.new("Seat")
    p.Name="Siège de marina";p.Size=Vector3.new(4.5,0.9,2.2)
    p.Anchored=true;p.Material=Enum.Material.WoodPlanks;p.Color=WOOD
    p.CFrame=base*CFrame.new(x,1.45,z);p.Parent=parent
    part(parent,"Dossier de siège",base,x,2.5,z+1.1,4.5,2.0,0.4,HULL,Enum.Material.Wood)
end
local function workshop(parent,base,x,theme,index)
    local localBase=base*CFrame.new(x,0,-30)
    local m=Instance.new("Model");m.Name=theme.." — atelier visitable";m.Parent=parent
    m:SetAttribute("KinMarinaWorkshop",theme)
    part(m,"Sol de l'atelier",localBase,0,1.15,0,22,0.45,25,SAND,Enum.Material.WoodPlanks)
    part(m,"Mur arrière",localBase,0,6.0,-12,22,9.8,0.7,HULL,Enum.Material.Wood)
    -- Façade ouverte en deux pans : entrée de 8 studs réellement franchissable.
    for _,xx in ipairs({-8,8}) do
        part(m,"Façade ouverte",localBase,xx,6,12,6,9.8,0.7,HULL,Enum.Material.Wood)
        local glass=part(m,"Fenêtre d'atelier",localBase,xx,7.7,12.4,3,2.9,0.18,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(glass,false)
    end
    for _,xx in ipairs({-10.7,10.7}) do
        part(m,"Mur latéral",localBase,xx,6,0,0.7,9.8,24,HULL,Enum.Material.Wood)
    end
    part(m,"Poutre d'auvent",localBase,0,11.4,0,24,0.8,27,BRASS,Enum.Material.Wood)
    part(m,"Toiture inclinée ouest",localBase,-5.7,12.5,0,12.4,0.7,28,Color3.fromRGB(103,132,130),Enum.Material.Slate,false)
    part(m,"Toiture inclinée est",localBase,5.7,12.5,0,12.4,0.7,28,Color3.fromRGB(103,132,130),Enum.Material.Slate,false)
    part(m,"Table de fabrication",localBase,0,2.9,-4,9,1.2,4,WOOD,Enum.Material.WoodPlanks)
    for col=1,4 do
        local xx=(col-2.5)*3.8
        local item=part(m,"Objet d'atelier "..col,localBase,xx,4.1,-4,1.9,1.5,1.9,
            if index==1 then GLASS else BRASS,if index==1 then Enum.Material.Glass else Enum.Material.Metal,false)
        if index==1 then item.Shape=Enum.PartType.Ball end
    end
    for level=1,3 do
        part(m,"Étagère de rangement",localBase,-8.7,2.1+level*2.2,-6,2,0.4,10,WOOD,Enum.Material.Wood)
    end
    part(m,"Comptoir d'accueil",localBase,7,2.1,6,5,2.2,2.5,BRASS,Enum.Material.Wood)
    seat(m,localBase,4,1)
    local screen=part(m,"Borne de service futur",localBase,7.0,4.1,5.5,1.7,2.2,0.45,GLASS,Enum.Material.Glass,false)
    screen:SetAttribute("KinStubInteractionId",string.format("%s.workshop.%d.future",parent:GetAttribute("KinMarinaId"),index))
    screen:SetAttribute("KinStubCapabilityId","future.marina.workshop")
    screen:SetAttribute("KinStubTitle",theme)
    F.prompt(screen,"Consulter","Fonctionnalité à venir")
    SecondaryArchitectureV25.marina(m,localBase,index)
    return m
end
local function makeMarina(root,item,index)
    local radial=Vector3.new(math.cos(item.angle),0,math.sin(item.angle))
    local base=CFrame.lookAt(radial*item.radius,radial*(item.radius+1))
    local m=Instance.new("Model");m.Name=item.title;m.Parent=root
    m:SetAttribute("KinMarinaId",item.id)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    -- Débarcadère qui commence à l'intérieur de la côte r=480 et atteint le lac.
    part(m,"Promenade d'accès",base,0,0.88,-30,12,0.85,99,WOOD,Enum.Material.WoodPlanks)
    part(m,"Esplanade sur pilotis",base,0,0.88,-29,89,0.85,58,SAND,Enum.Material.WoodPlanks)
    part(m,"Brise-lames principal",base,0,0.88,-84,13,0.85,53,WOOD,Enum.Material.WoodPlanks)
    for _,xx in ipairs({-41,41}) do
        for _,zz in ipairs({-50,-35,-18,-6}) do
            part(m,"Pilotis portuaire",base,xx,-2.2,zz,1.8,7.6,1.8,HULL,Enum.Material.Metal)
        end
        part(m,"Garde-corps",base,xx,2.4,-29,0.55,1.8,54,BRASS,Enum.Material.Metal,false)
    end
    for _,xx in ipairs({-25,25}) do
        part(m,"Liaison aux ateliers",base,xx,0.88,0,11,0.85,19,WOOD,Enum.Material.WoodPlanks)
    end
    workshop(m,base,-26,if index==1 then "Atelier des courants" else "Atelier du bois flotté",1)
    workshop(m,base,26,if index==1 then "Cabinet du lac" else "Atelier des voiles",2)
    for _,xx in ipairs({-34,34}) do
        seat(m,base,xx,-47)
        for _,zz in ipairs({-3,-51}) do
            local lamp=ball(m,"Boule d'amarrage",base,xx,4.6,zz,1.4,tint,Enum.Material.Neon)
            local light=Instance.new("PointLight");light.Brightness=0.4;light.Range=16;light.Parent=lamp
            part(m,"Mât d'amarrage",base,xx,2.7,zz,0.8,4,0.8,HULL,Enum.Material.Metal)
        end
    end
    -- Phare sur un plateau distinct du passage central.
    part(m,"Plateau du phare",base,19,0.95,-93,25,0.7,25,SAND,Enum.Material.Cobblestone)
    for level=1,3 do
        part(m,"Tour du phare niveau "..level,base,19,4.4+(level-1)*7,-93,7-level*0.5,7,7-level*0.5,HULL,Enum.Material.Metal)
        part(m,"Corniche phare",base,19,8.1+(level-1)*7,-93,8,0.5,8,BRASS,Enum.Material.Metal,false)
    end
    local beacon=ball(m,"Lentille du phare",base,19,26.5,-93,5,GLASS,Enum.Material.Neon)
    beacon:SetAttribute("KinMarinaLightLens",item.id)
    local rotating=part(m,"Faisceau maritime",base,19,26.5,-102,1.8,1.8,16,tint,Enum.Material.Neon,false)
    rotating.Transparency=0.25;rotating:SetAttribute("KinMarinaBeam",item.id)
    local switch=part(m,"Commande du phare",base,9,2.7,-87,2.5,4.1,2.5,HULL,Enum.Material.Metal)
    switch:SetAttribute("KinMarinaAction","beacon")
    switch:SetAttribute("KinMarinaId",item.id)
    F.prompt(switch,"Allumer / éteindre","Phare de la marina")
    -- Grue de port dynamique (rotation locale de la poutre, pas de simulation physique).
    part(m,"Socle de grue",base,-20,2.5,-79,8,3,8,HULL,Enum.Material.Metal)
    part(m,"Pylône de grue",base,-20,11,-79,1.8,16,1.8,HULL,Enum.Material.Metal)
    local arm=part(m,"Bras mobile de grue",base,-20,20,-88,1.6,1.2,21,BRASS,Enum.Material.Metal,false)
    arm:SetAttribute("KinMarinaCraneArm",item.id)
    local craneSwitch=part(m,"Commande de grue",base,-9,2.6,-74,2.3,3.7,2.3,HULL,Enum.Material.Metal)
    craneSwitch:SetAttribute("KinMarinaAction","crane")
    craneSwitch:SetAttribute("KinMarinaId",item.id)
    F.prompt(craneSwitch,"Déplacer la grue","Atelier maritime")
    local collectible=part(m,"Borne carnet maritime",base,0,2.6,-54,2.8,4.0,2.1,tint,Enum.Material.Metal)
    collectible:SetAttribute("KinMarinaAction","collect")
    collectible:SetAttribute("KinMarinaId",item.id)
    F.prompt(collectible,"Observer le port","Carnet de navigation")
    F.sign(m,"Enseigne maritime",(base*CFrame.new(0,8.1,8)).Position,math.deg(math.pi/2-item.angle),item.title,29,3.8).CanCollide=false
    return m
end
function Marina.make(city)
    local root=F.folder(city,"Marinas et ateliers maritimes")
    for i,item in ipairs(Destinations) do makeMarina(root,item,i) end
    root:SetAttribute("KinMarinas",#Destinations)
    root:SetAttribute("KinWorkshops",#Destinations*2)
    return root
end
return Marina

]])
source(server,"MaterialLibraryV25","ModuleScript",[[
--!strict
-- Application sélective de matériaux PBR déjà importés dans Studio.
-- Jamais d'AssetId inventé; la géométrie native fonctionne sans bibliothèque.
-- La SurfaceAppearance est copiée uniquement sur des MeshParts facultatifs.
local ServerStorage=game:GetService("ServerStorage")
local Library={}
local MATERIAL_FOR_MESH={
    mineral_column="sarcelle_pierre",
    opal_spire="opale_massive",
    crystal_rosette="opale_massive",
    opal_arch="sarcelle_pierre",
    opal_chandelier="champagne_mineral",
    crystal_canopy="opale_massive",
    mineral_planter="pierre_promenoir",
    opal_console="champagne_mineral",
    opal_lattice="opale_massive",
    mineral_pediment="sarcelle_pierre",
    harbor_crest="champagne_mineral",
}
local VALID={sarcelle_pierre=true,opale_massive=true,champagne_mineral=true,pierre_promenoir=true}
function Library.materialFor(assetKey)
    return MATERIAL_FOR_MESH[assetKey]
end
function Library.apply(mesh,assetKey,profile)
    if not mesh or not mesh:IsA("MeshPart") or profile=="LITE" then return false end
    local key=MATERIAL_FOR_MESH[assetKey]
    if not key or not VALID[key] then return false end
    -- Respecter un SurfaceAppearance déjà présent sur l'asset importé.
    if mesh:FindFirstChildOfClass("SurfaceAppearance") then return false end
    local root=ServerStorage:FindFirstChild("KinCityMaterialLibrary")
    local template=root and root:FindFirstChild(key)
    if not template or not template:IsA("SurfaceAppearance") then return false end
    local finish=template:Clone()
    finish.Name="Finition Kin City — "..key
    finish.Parent=mesh
    mesh:SetAttribute("KinMaterialKey",key)
    return true
end
return Library

]])
source(server,"NativeR15Citizens","ModuleScript",[[
--!strict
-- Avatars Roblox R15 créés par l'API officielle, SANS identifiant d'avatar externe requis.
-- L'échec d'un chargement Roblox ne doit jamais empêcher l'ouverture de Kin City.
-- Ces citoyens complètent la population stylisée déjà présente dans l'édition du monde.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local CitizenProps=require(script.Parent.CitizenPropsV21)
local Presence=require(script.Parent.ViewerPresenceV21)
local F=require(script.Parent.Factory)
local R15={}
local skins={
    Color3.fromRGB(239,193,145),Color3.fromRGB(157,97,70),Color3.fromRGB(109,71,54),
    Color3.fromRGB(210,158,112),Color3.fromRGB(86,57,42),Color3.fromRGB(192,125,93),
}
local coats={
    Color3.fromRGB(43,115,124),Color3.fromRGB(169,109,71),Color3.fromRGB(111,91,160),
    Color3.fromRGB(71,132,100),Color3.fromRGB(177,146,72),Color3.fromRGB(92,115,146),
}
local roles={"Bibliothécaire","Étudiante","Chercheuse","Médiateur","Artiste","Guide","Inventrice","Archiviste","Citoyenne","Technicien"}
local function description(index)
    local d=Instance.new("HumanoidDescription")
    local skin=skins[(index-1)%#skins+1]
    local coat=coats[(index-1)%#coats+1]
    d.HeadColor=skin
    d.LeftArmColor=coat
    d.RightArmColor=coat
    d.TorsoColor=coat
    d.LeftLegColor=Color3.fromRGB(58,74,86)
    d.RightLegColor=Color3.fromRGB(58,74,86)
    d.HeightScale=0.92+(index%4)*0.055
    d.WidthScale=0.86+(index%3)*0.075
    d.DepthScale=0.95
    d.HeadScale=1
    d.BodyTypeScale=0
    d.ProportionScale=0
    return d
end
local function badger(model,part,title)
    local bb=Instance.new("BillboardGui")
    bb.Name="Métier"
    bb.Size=UDim2.fromOffset(155,30)
    bb.StudsOffset=Vector3.new(0,2.2,0)
    bb.MaxDistance=65
    bb.AlwaysOnTop=false
    bb.Adornee=part
    bb.Parent=part
    local text=Instance.new("TextLabel")
    text.Size=UDim2.fromScale(1,1)
    text.BackgroundColor3=Color3.fromRGB(31,53,60)
    text.BackgroundTransparency=0.26
    text.TextColor3=Color3.fromRGB(247,237,216)
    text.Font=Enum.Font.GothamMedium
    text.TextSize=13
    text.Text=title
    text.Parent=bb
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,8)
    corner.Parent=text
end
local function make(index,parent)
    local desc=description(index)
    local ok,model=pcall(function()
        return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
    end)
    desc:Destroy()
    if not ok or not model then
        warn("Kin City : impossible de charger citoyen R15 "..index,model)
        return nil
    end
    local role=roles[(index-1)%#roles+1]
    model.Name=role.." R15 "..index
    model:SetAttribute("KinR15Citizen",true)
    model:SetAttribute("KinCitizenRole",role)
    local humanoid=model:FindFirstChildOfClass("Humanoid")
    local root=model:FindFirstChild("HumanoidRootPart")
    local head=model:FindFirstChild("Head")
    if not humanoid or not root or not head then model:Destroy();return nil end
    humanoid.WalkSpeed=7+(index%3)
    humanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
    humanoid.BreakJointsOnDeath=false
    root.CanCollide=false
    -- Retirer toute invitation à récupérer une identité ou à déclencher des requêtes externes.
    head:SetAttribute("KinStubInteractionId",string.format("city.r15.%02d.dialogue",index))
    head:SetAttribute("KinStubCapabilityId","future.citizen.dialogue")
    head:SetAttribute("KinStubTitle",role.." — Kin City")
    F.prompt(head,"Parler",role)
    badger(model,head,role)
    model:SetAttribute("KinNPCPhase",index*0.73)
    model:SetAttribute("KinNPCMotion","idle")
    model:SetAttribute("KinNPCActivity","Accueil")
    model.Parent=parent
    CitizenProps.attach(model,role,index)
    CollectionService:AddTag(model,"KinCityAnimatedNPC")
    return model,humanoid,root
end
local function walk(model,humanoid,index,world)
    -- Le serveur choisit uniquement les destinations et publie l'activité.
    -- Les gestes R15 sont rendus par CitizenAnimationV21 côté client.
    local radius=76+(index%3)*5
    local theta=index*math.pi*2/10
    local start=Vector3.new(radius*math.cos(theta),2.5,radius*math.sin(theta))
    model:PivotTo(CFrame.new(start))
    local root=model:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        pcall(function() root:SetNetworkOwner(nil) end)
    end
    local activities={"Promenade", "Observer", "Lecture", "Accueil", "Rencontre"}
    task.spawn(function()
        local lap=0
        while model.Parent and world.Parent and humanoid.Health>0 do
            if not Presence.near(model:GetPivot().Position,200) then
                model:SetAttribute("KinNPCMotion","idle")
                task.wait(2.5)
                continue
            end
            lap+=1
            theta+=0.21
            local pos=Vector3.new(radius*math.cos(theta),1.8,radius*math.sin(theta))
            model:SetAttribute("KinNPCMotion","walk")
            model:SetAttribute("KinNPCActivity","Promenade")
            humanoid:MoveTo(pos)
            local finished=false
            local conn=humanoid.MoveToFinished:Connect(function() finished=true end)
            local untilTime=os.clock()+10
            while not finished and os.clock()<untilTime and model.Parent and world.Parent and humanoid.Health>0 do
                task.wait(0.3)
            end
            conn:Disconnect()
            if not model.Parent or not world.Parent then break end
            local activity=activities[(lap+index-2)%#activities+1]
            model:SetAttribute("KinNPCMotion",if activity=="Lecture" then "read" elseif activity=="Accueil" or activity=="Rencontre" then "greet" else "idle")
            model:SetAttribute("KinNPCActivity",activity)
            task.wait(1.5+(index%3)*0.55)
        end
        model:SetAttribute("KinNPCMotion","idle")
    end)
end
function R15.start(world)
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local folder=F.folder(city,"Citoyens Roblox R15")
    -- Chargement asynchrone, peu de modèles, population stylisée conservée comme repli.
    task.spawn(function()
        for i=1,10 do
            if not world.Parent then break end
            local model,humanoid=make(i,folder)
            if model and humanoid then walk(model,humanoid,i,world) end
            task.wait(0.35)
        end
    end)
end
return R15

]])
source(server,"NeighborhoodRooflinesV22","ModuleScript",[[
--!strict
-- 24 maisons habitées : géométrie de toit sarcelle, lucarnes opalines, faîtages par quartier.
-- Ne touche pas aux volumes porteurs, escaliers ni aux ouvertures des bâtiments visitables.
local Studio=require(script.Parent.ArtisanGeometryV22)
local Kit=require(script.Parent.CrystalKit)
local Roof={}
local function palette(style)
    if style=="culture" then return "gold" end
    if style=="atelier" then return "medium" end
    if style=="collectif" then return "opal" end
    return "deep"
end
function Roof.make(parent,base,width,depth,height,style,seed)
    local folder=Instance.new("Folder")
    folder.Name="Toiture minérale v22"
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    folder.Parent=parent
    local tint=palette(style)
    local peak=if seed%3==0 then 4.2 elseif seed%3==1 then 3.2 else 5.0
    -- Bande sculptée uniquement au BORD AVANT. Les plantations situées derrière restent visibles.
    for _,s in ipairs({-1,1}) do
        Studio.wedge(folder,"Aile de toiture",Vector3.new(width*0.46,peak,depth*0.18),
            base*CFrame.new(s*width*0.245,height+peak*0.5,-depth*0.4)*CFrame.Angles(0,if s>0 then math.pi else 0,0),
            if s==1 then tint else "deep",true)
    end
    Studio.part(folder,"Ligne de faîtage",Vector3.new(width*0.9,0.55,0.6),
        base*CFrame.new(0,height+peak,-depth*0.4),"gold",Enum.Material.Metal,false)
    local count=if Kit.profile=="LITE" then 1 else 3
    for k=1,count do
        local x=(k-(count+1)/2)*6.0
        Studio.part(folder,"Panneau de lucarne",Vector3.new(3.6,1.9,0.23),
            base*CFrame.new(x,height+peak*0.65,-depth*0.33),"opal",Enum.Material.Slate,true)
        Studio.part(folder,"Traverse de lucarne",Vector3.new(3.8,0.21,0.36),
            base*CFrame.new(x,height+peak*0.68,-depth*0.35),"gold",Enum.Material.Metal,true)
    end
    -- Les petites gemmes indiquent le district, mais elles ne sont ni un téléporteur ni un terminal.
    for _,x in ipairs({-width*0.40,width*0.40}) do
        Studio.facet(folder,"Clef de quartier",base*CFrame.new(x,height+0.1,-depth*0.38),0.7,
            if Kit.profile=="LITE" then 2 else 3.6,"opal",true)
    end
    return folder
end
return Roof

]])
source(server,"Neighborhoods","ModuleScript",[[
--!strict
-- Petits pavillons réellement accessibles depuis la rue :
-- pas de téléportation, porte physique ouverte et terminal local en stub.
local F=require(script.Parent.Factory)
local Neighborhoods={}
local Conservatories=require(script.Parent.LearningConservatories)
local categories={
    {name="Café des idées",room="Rencontres",color=Color3.fromRGB(208,168,119)},
    {name="Atelier citoyen",room="Création",color=Color3.fromRGB(143,176,153)},
    {name="Maison des découvertes",room="Savoir",color=Color3.fromRGB(179,172,204)},
    {name="Galerie de quartier",room="Culture",color=Color3.fromRGB(212,158,144)},
    {name="Pavillon communautaire",room="Entraide",color=Color3.fromRGB(168,193,213)},
    {name="Atelier de réparation",room="Innovation",color=Color3.fromRGB(197,179,139)}
}
local function part(parent,name,base,size,offset,color,material)
    return F.part(parent,name,size,base*CFrame.new(offset),color,material)
end
local function capsule(parent,base,x,z,color)
    part(parent,"Table",base,Vector3.new(5,0.5,3),Vector3.new(x,2.5,z),Color3.fromRGB(103,77,59),Enum.Material.WoodPlanks)
    for _,sign in ipairs({-1,1}) do
        part(parent,"Tabouret",base,Vector3.new(1.7,1.6,1.7),Vector3.new(x+sign*4,0.8,z),color,Enum.Material.Wood)
    end
end
function Neighborhoods.make(parent,plan)
    local root=F.folder(parent,"Pavillons de quartier")
    local prompts={}
    local exterior=plan.structures
    for index=1,60 do
        local theta=(index-0.5)*math.pi*2/60
        local radius=420+(index%3)*7
        local x,z=radius*math.cos(theta),radius*math.sin(theta)
        local blocked=false
        for _,s in ipairs(exterior) do
            local dx=x-s.center_studs[1]
            local dz=z-s.center_studs[3]
            if math.sqrt(dx*dx+dz*dz)<64 then blocked=true;break end
        end
        if not blocked and not Conservatories.isReserved(x,z) then
            local category=categories[(index-1)%#categories+1]
            local name=string.format("%s %02d",category.name,index)
            local model=Instance.new("Model");model.Name=name;model:SetAttribute("KinNeighborhoodId","neighborhood."..index);model.Parent=root
            local yaw=math.pi/2-theta
            local base=CFrame.new(x,0,z)*CFrame.Angles(0,yaw,0)
            local w,d,h=22,22,13
            local wall=category.color
            local trim=Color3.fromRGB(233,223,203)
            part(model,"Sol accessible",base,Vector3.new(w,1,d),Vector3.new(0,-0.45,0),trim,Enum.Material.WoodPlanks)
            part(model,"Mur arrière",base,Vector3.new(w,h,1),Vector3.new(0,h/2,d/2),wall,Enum.Material.Brick)
            for _,side in ipairs({-1,1}) do
                part(model,"Mur côté",base,Vector3.new(1,h,d),Vector3.new(side*w/2,h/2,0),wall,Enum.Material.Brick)
                local half=(w-8)/2
                part(model,"Façade latérale",base,Vector3.new(half,h,1),Vector3.new(side*(8/2+half/2),h/2,-d/2),wall,Enum.Material.Brick)
                local pane=part(model,"Fenêtre",base,Vector3.new(4,4,0.18),Vector3.new(side*7,7,-d/2-0.6),Color3.fromRGB(94,157,171),Enum.Material.Glass)
                pane.CanCollide=false
                part(model,"Encadrement",base,Vector3.new(1,h,1.5),Vector3.new(side*4,h/2,-d/2-0.2),trim,Enum.Material.Marble)
            end
            part(model,"Linteau",base,Vector3.new(8,4,1.4),Vector3.new(0,h-2,-d/2),trim,Enum.Material.Marble)
            part(model,"Toit",base,Vector3.new(w+3,1,d+3),Vector3.new(0,h+0.4,0),Color3.fromRGB(66,90,93),Enum.Material.Slate)
            for n=-2,2 do
                part(model,"Lucarne",base,Vector3.new(2.1,0.7,2.1),Vector3.new(n*3.4,h+1.1,-4),category.color,Enum.Material.Metal)
            end
            F.sign(model,"Enseigne pavillon",(base*CFrame.new(0,10.8,-d/2-1.5)).Position,math.deg(yaw),name,18,2.6).CanCollide=false
            local mat=part(model,"Paillasson",base,Vector3.new(8,0.15,3),Vector3.new(0,0.08,-d/2-2),Color3.fromRGB(170,140,96),Enum.Material.Fabric)
            mat.CanCollide=false
            capsule(model,base,-5,4,category.color)
            capsule(model,base,4,5,category.color)
            local console=part(model,"Borne",base,Vector3.new(3,4,1.7),Vector3.new(0,2.1,8),Color3.fromRGB(53,72,77),Enum.Material.Metal)
            part(model,"Écran",base,Vector3.new(2.5,2.2,0.25),Vector3.new(0,3.1,7.05),Color3.fromRGB(66,184,182),Enum.Material.Neon).CanCollide=false
            local prompt=F.prompt(console,"Découvrir",category.room)
            local interactionId=string.format("neighborhood.%02d.terminal",index)
            console:SetAttribute("KinInteractionId",interactionId)
            console:SetAttribute("KinCapabilityId", "future."..category.room)
            prompts[prompt]={kind="ambient",data={interaction_id=interactionId,capability_id="future."..category.room,title=name}}
        end
    end
    return prompts
end
return Neighborhoods

]])
source(server,"OpalGlazingV22","ModuleScript",[[
--!strict
-- Traitement cohérent et économique des vitrages répétés.
-- Les verres partiellement transparents se superposent : ici l'opale est d'abord opaque.
local Kit=require(script.Parent.CrystalKit)
local Glass={}
function Glass.apply(part:BasePart,hero:boolean)
    part.Color=Kit.opal
    if Kit.profile=="SHOWCASE" and hero then
        part.Material=Enum.Material.Glass
        part.Transparency=0.28
        part.Reflectance=0.025
    else
        part.Material=Enum.Material.SmoothPlastic
        part.Transparency=0
        part.Reflectance=0.07
    end
    part.CanCollide=false
    part.CanTouch=false
    part.CanQuery=false
    part.CastShadow=false
    part:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    return part
end
return Glass

]])
source(server,"OpalWayfindingV19","ModuleScript",[[
--!strict
-- Incrustations opalines intégrées dans le pavage (sans collision ni éclairages coûteux).
-- Parcours dérivés des mêmes points que les véritables sentiers piétons.
local Kit=require(script.Parent.CrystalKit)
local Wayfinding={}
local function stripe(folder,p,q,offset,color)
    local direction=q-p
    local horizontal=Vector3.new(direction.X,0,direction.Z)
    local distance=horizontal.Magnitude
    if distance<3 then return end
    local forward=horizontal.Unit
    local sideways=Vector3.new(forward.Z,0,-forward.X)
    local center=(p+q)*0.5+sideways*offset
    center=Vector3.new(center.X,0.27,center.Z)
    local frame=CFrame.lookAt(center,center+forward)
    local part=Kit.part(folder,"Part","Veine de guidage",Vector3.new(0.24,0.08,distance),frame,color,Enum.Material.Metal)
    part:SetAttribute("KinOptionalDetail",true)
end
function Wayfinding.make(city,plan)
    local folder=Instance.new("Folder")
    folder.Name="Filigranes de promenade — v19"
    folder.Parent=city
    folder:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    local density=Kit.profile=="LITE" and 1 or 2
    for routeIndex,path in ipairs(plan.pedestrian_paths) do
        for i=2,#path.path_xyz_studs do
            local a,b=path.path_xyz_studs[i-1],path.path_xyz_studs[i]
            local p=Vector3.new(a[1],0,a[3])
            local q=Vector3.new(b[1],0,b[3])
            local halfWidth=math.max(1.25,math.min(path.width_studs*0.31,3.5))
            stripe(folder,p,q,-halfWidth,Kit.primary)
            if density==2 then stripe(folder,p,q,halfWidth,Kit.gold) end
        end
    end
    return folder
end
return Wayfinding

]])
source(server,"OutdoorAtmosphere","ModuleScript",[[
--!strict
-- Sources d'ambiance entièrement natives : lucioles, halos, scintillements, fanions.
local F=require(script.Parent.Factory)
local Lighting=game:GetService("Lighting")
local Atmos={}
local fol=Color3.fromRGB(79,143,98)
local function spot(parent,x,z,index)
    local m=F.folder(parent,"Jardin lumineux")
    local stem=F.part(m,"Rosier",Vector3.new(0.7,6,0.7),CFrame.new(x,3,z),fol,Enum.Material.Grass)
    stem.CanCollide=false
    local orb=F.part(m,"Orbe végétal",Vector3.new(2.4,2.4,2.4),CFrame.new(x,6.6,z),Color3.fromRGB(170,224,210),Enum.Material.Slate)
    orb.CanCollide=false
    orb.Shape=Enum.PartType.Ball
    for n=1,3 do
        local a=n*math.pi*2/3
        local x2,z2=x+math.cos(a)*3,z+math.sin(a)*3
        local lamp=F.part(m,"Lanterne",Vector3.new(0.7,0.7,0.7),CFrame.new(x2,4.5+(index%2),z2),Color3.fromRGB(254,207,119),Enum.Material.Neon)
        lamp.Shape=Enum.PartType.Ball
        lamp.CanCollide=false
        lamp:SetAttribute("KinFirefly",true)
        lamp:SetAttribute("KinFireflyPhase",index*0.7+n)
        -- Un seul émetteur par jardin de trois lanternes : conserver les
        -- trois lueurs de matière sans trois coûts d'éclairage distincts.
        if n==1 then
            local point=Instance.new("PointLight")
            point.Brightness=0.26
            point.Range=9
            point.Shadows=false
            point.Parent=lamp
        end
    end
end
function Atmos.make(city)
    local folder=F.folder(city,"Paysages d'ambiance")
    for i=1,24 do
        local angle=2*math.pi*(i-1)/24
        local radius=124+(i%3)*20
        spot(folder,math.cos(angle)*radius,math.sin(angle)*radius,i)
    end
    local shrine=F.folder(folder,"Anneaux de la connaissance")
    for i=1,8 do
        local angle=2*math.pi*i/8
        local r=28
        local orb=F.part(shrine,"Pierre du savoir",Vector3.new(3.6,3.6,3.6),CFrame.new(math.cos(angle)*r,2.2,math.sin(angle)*r),Color3.fromRGB(197,239,231),Enum.Material.Slate)
        orb.Shape=Enum.PartType.Ball
        orb.CanCollide=false
        local aura=Instance.new("PointLight")
        aura.Brightness=0.35;aura.Range=11;aura.Parent=orb
    end
    return folder
end
function Atmos.start(world)
    -- On adapte doucement la lumière aux heures de la journée.
    -- Les ressources ne changent pas de propriétaire et ne sont jamais reconnectées à une API.
    task.spawn(function()
        local parts={}
        local city=world:FindFirstChild("Ville")
        local f=city and city:FindFirstChild("Paysages d'ambiance")
        if not f then return end
        for _,p in ipairs(f:GetDescendants()) do
            if p:IsA("BasePart") and p:GetAttribute("KinFirefly") then table.insert(parts,p) end
        end
        while world.Parent do
            local night=(Lighting.ClockTime<6.4 or Lighting.ClockTime>18.2)
            local now=os.clock()
            for _,p in ipairs(parts) do
                if p.Parent then
                    local light=p:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=night;light.Brightness=0.22+0.1*math.sin(now*1.8+(p:GetAttribute("KinFireflyPhase") or 0)) end
                    p.Transparency=night and 0.06 or 0.58
                end
            end
            task.wait(2.4)
        end
    end)
end
return Atmos

]])
source(server,"OuterIslands","ModuleScript",[[
--!strict
-- Six îles, ponts piétons élevés et installations physiques actionnables.
-- Le lac agrandi est créé par CityGenerator, puis l'archipel par ce module.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Destinations=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("IslandDestinations"))
local Islands={}
local NAVY=Color3.fromRGB(30,104,100)
local STONE=Color3.fromRGB(219,210,190)
local WOOD=Color3.fromRGB(147,108,76)
local GOLD=Color3.fromRGB(218,178,106)
local function add(parent,name,cf,size,color,material,solid)
    local p=F.part(parent,name,size,cf,color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false end
    return p
end
local function localPart(parent,name,base,x,y,z,w,h,d,color,mat,solid)
    return add(parent,name,base*CFrame.new(x,y,z),Vector3.new(w,h,d),color,mat,solid)
end
local function rounded(parent,name,cf,diameter,height,color)
    local p=add(parent,name,cf*CFrame.Angles(0,0,math.pi/2),Vector3.new(height,diameter,diameter),color,Enum.Material.Grass,true)
    p.Shape=Enum.PartType.Cylinder
    return p
end
local function globe(parent,name,cf,d,clr,mat)
    local p=add(parent,name,cf,Vector3.new(d,d,d),clr,mat or Enum.Material.SmoothPlastic,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function plantedTree(parent,base,index,x,z)
    local height=8+(index%3)*2
    localPart(parent,"Tronc de l'île",base,x,height/2,z,1.4,height,1.4,WOOD,Enum.Material.Wood,true)
    local leaf=globe(parent,"Feuillage insulaire",base*CFrame.new(x,height+2.4,z),7+(index%2)*2,Color3.fromRGB(73+(index%3)*10,154+(index%2)*17,116),Enum.Material.Grass)
    leaf.CanCollide=false
end
local function bridge(root,item)
    local t=item.angle
    local radial=Vector3.new(math.cos(t),0,math.sin(t))
    local tangent=Vector3.new(-radial.Z,0,radial.X)
    local bridgeRoot=F.folder(root,"Passerelle — "..item.title)
    bridgeRoot:SetAttribute("KinBridgeId",item.id)
    local function height(f)
        if f<0.23 then return 0.35+16*(f/0.23) end
        if f>0.76 then return 0.35+16*((1-f)/0.24) end
        return 16.35
    end
    local pieces=28
    local from=477
    local to=701
    for step=1,pieces do
        local f1=(step-1)/pieces
        local f2=step/pieces
        local a=radial*(from+(to-from)*f1)+Vector3.new(0,height(f1),0)
        local b=radial*(from+(to-from)*f2)+Vector3.new(0,height(f2),0)
        local segment=b-a
        local length=segment.Magnitude
        local cf=CFrame.lookAt((a+b)/2,b)
        add(bridgeRoot,"Tablier du pont",cf,Vector3.new(12,0.85,length+0.12),STONE,Enum.Material.Cobblestone,true)
        for _,side in ipairs({-1,1}) do
            -- Garde-corps continus; la circulation au centre reste dégagée.
            local rail=add(bridgeRoot,"Garde-corps",cf*CFrame.new(side*5.7,2.2,0),Vector3.new(0.3,0.55,length+0.16),GOLD,Enum.Material.Metal,false)
            rail.CanCollide=false
            if step%2==0 then
                add(bridgeRoot,"Balustre",cf*CFrame.new(side*5.7,1.0,0),Vector3.new(0.38,2.0,0.38),NAVY,Enum.Material.Metal,true)
            end
        end
        if step%7==0 then
            local pos=(a+b)/2-tangent*0
            for _,side in ipairs({-1,1}) do
                local lamp=globe(bridgeRoot,"Lanterne de liaison",CFrame.new(pos+tangent*side*5.8+Vector3.new(0,4,0)),1.0,Color3.fromRGB(255,226,151),Enum.Material.Neon)
                lamp.CanCollide=false
            end
        end
    end
    return bridgeRoot
end
local function islandSection(parent,item,index)
    local angle=item.angle
    local radial=Vector3.new(math.cos(angle),0,math.sin(angle))
    local origin=radial*item.radius
    local base=CFrame.new(origin)*CFrame.Angles(0,math.pi/2-angle,0)
    local clr=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local model=Instance.new("Model")
    model.Name=item.title
    model:SetAttribute("KinIslandId",item.id)
    model.Parent=parent
    rounded(model,"Terre de l'île",CFrame.new(origin+Vector3.new(0,-2.2,0)),90,5.4,Color3.fromRGB(73,143,104))
    rounded(model,"Pavement insulaire",CFrame.new(origin+Vector3.new(0,0.55,0)),53,0.4,STONE)
    localPart(model,"Esplanade",base,0,0.7,-15,17,0.35,48,STONE,Enum.Material.Cobblestone,true)
    for k=1,10 do
        local a=k*2.399963+index
        local radius=26+(k%3)*4
        local x=math.cos(a)*radius
        local z=math.sin(a)*radius
        plantedTree(model,base,k,x,z)
    end
    -- Trois pavillons couverts, ouverts au public et utilisables sans téléportation.
    for n=1,3 do
        local a=(n-1)*math.pi*2/3+0.5
        local x,z=math.cos(a)*25,math.sin(a)*25
        localPart(model,"Sol du kiosque",base,x,0.9,z,17,0.55,15,STONE,Enum.Material.Marble,true)
        for _,dx in ipairs({-7,7}) do for _,dz in ipairs({-6,6}) do
            localPart(model,"Colonne d'abri",base,x+dx,5.6,z+dz,0.8,9.3,0.8,NAVY,Enum.Material.Metal,true)
        end end
        localPart(model,"Toit d'abri",base,x,10.5,z,19,1.2,17,clr,Enum.Material.Slate,false)
        local bench=Instance.new("Seat")
        bench.Name="Banc de l'île";bench.Size=Vector3.new(5,0.8,2.8)
        bench.CFrame=base*CFrame.new(x,1.5,z)
        bench.Anchored=true;bench.Color=WOOD;bench.Material=Enum.Material.WoodPlanks;bench.Parent=model
    end
    local exhibit=Instance.new("Model")
    exhibit.Name="Installation — "..item.caption
    exhibit.Parent=model
    localPart(exhibit,"Piédestal de l'installation",base,0,2.1,9,13,3.6,13,NAVY,Enum.Material.Marble,true)
    if item.kind=="gardens" then
        for ring=1,3 do
            local d=3+ring*2.6
            for k=1,8 do
                local a=k*math.pi/4
                local flower=globe(exhibit,"Jardin lumineux",base*CFrame.new(math.cos(a)*d,4.1+ring*0.25,9+math.sin(a)*d),1.2,Color3.fromHSV((k/8+ring*0.13)%1,0.52,0.94),Enum.Material.Neon)
                flower:SetAttribute("KinIslandReactive",true)
            end
        end
    elseif item.kind=="arts" then
        for k=1,8 do
            local a=k*math.pi/4
            local sculpture=localPart(exhibit,"Sculpture de scène",base,math.sin(a)*4.7,5.6+math.sin(a)*1.5,9+math.cos(a)*4.7,1.1,4.8,1.1,clr,Enum.Material.Neon,false)
            sculpture:SetAttribute("KinIslandReactive",true)
        end
    elseif item.kind=="energy" then
        for k=1,6 do
            local a=k*math.pi/3
            local turbine=localPart(exhibit,"Aube énergétique",base,math.cos(a)*3.5,6.6,9+math.sin(a)*3.5,5.5,0.4,0.55,GOLD,Enum.Material.Metal,false)
            turbine:SetAttribute("KinIslandRotor",true)
        end
    elseif item.kind=="stars" then
        globe(exhibit,"Soleil symbolique",base*CFrame.new(0,7.1,9),5,GOLD,Enum.Material.Neon):SetAttribute("KinIslandReactive",true)
        for k=1,5 do
            local a=k*1.2566
            globe(exhibit,"Planète",base*CFrame.new(math.cos(a)*5,5.3+(k%2)*2,9+math.sin(a)*5),1.1+(k%2),clr,Enum.Material.Glass)
        end
    elseif item.kind=="archives" then
        for shelf=1,5 do
            local x=(shelf-3)*2.5
            localPart(exhibit,"Volume monumental",base,x,5.8,9,1.7,3.5+(shelf%3),3.4,Color3.fromHSV(shelf/7,0.49,0.8),Enum.Material.Fabric,false):SetAttribute("KinIslandReactive",true)
        end
    else
        for k=1,8 do
            local a=k*math.pi/4
            globe(exhibit,"Anneau de rencontre",base*CFrame.new(math.cos(a)*4.5,5.1,9+math.sin(a)*4.5),1.7,clr,Enum.Material.Neon):SetAttribute("KinIslandReactive",true)
        end
    end
    local terminal=localPart(model,"Console de l'installation locale",base,0,2.5,-2,3.5,4.5,2.0,NAVY,Enum.Material.Metal,true)
    terminal:SetAttribute("KinIslandExperienceId",item.id)
    F.prompt(terminal,"Activer","Installation interactive")
    local info=localPart(model,"Borne du futur service",base,-13,2.4,-3,2.6,4.5,1.7,Color3.fromRGB(48,77,88),Enum.Material.Metal,true)
    info:SetAttribute("KinStubInteractionId",item.id..".kOA")
    info:SetAttribute("KinStubCapabilityId","future.island."..item.kind)
    info:SetAttribute("KinStubTitle",item.title)
    F.prompt(info,"Consulter","Fonction future")
    F.sign(model,"Enseigne de l'île",(base*CFrame.new(0,7.9,-26)).Position,math.deg(math.pi/2-angle),item.title,29,3.5).CanCollide=false
    local beacon=globe(model,"Phare d'orientation",base*CFrame.new(0,15,21),3,clr,Enum.Material.Neon)
    beacon.CanCollide=false
    localPart(model,"Mât du phare",base,0,8,21,1.4,13.8,1.4,NAVY,Enum.Material.Metal,true)
    return model
end
function Islands.make(city)
    local root=F.folder(city,"Archipel des six îles")
    for i,item in ipairs(Destinations) do
        bridge(root,item)
        islandSection(root,item,i)
    end
    root:SetAttribute("KinIslandCount",#Destinations)
    root:SetAttribute("KinBridgeCount",#Destinations)
    return root
end
return Islands

]])
source(server,"PedestrianWayfinding","ModuleScript",[[
--!strict
-- Réseau de jalonnement de la ville. Suit les itinéraires calculés par le compilateur.
local F=require(script.Parent.Factory)
local Wayfinding={}
local STONE=Color3.fromRGB(220,204,171)
local BRASS=Color3.fromRGB(194,155,95)
local INK=Color3.fromRGB(38,69,78)
function Wayfinding.make(city,plan,buildingsById)
    local folder=F.folder(city,"Jalonnement piéton")
    local total=0
    for _,path in ipairs(plan.pedestrian_paths) do
        local points=path.path_xyz_studs
        local building=buildingsById[path.building_id]
        local name=building and building.name or path.building_id
        for idx=2,#points do
            local prev=points[idx-1]
            local next=points[idx]
            local a=Vector3.new(prev[1],0,prev[3])
            local b=Vector3.new(next[1],0,next[3])
            local vec=b-a
            local len=vec.Magnitude
            if len>6 then
                local direction=vec.Unit
                local cross=Vector3.new(-direction.Z,0,direction.X)
                -- Pastilles au sol, espacées; n'interfèrent pas avec les déplacements.
                for step=1,math.floor(len/20) do
                    local t=step*20
                    if t<len-4 then
                        local pos=a+direction*t
                        local circle=F.part(folder,"Repère de parcours",Vector3.new(0.13,2.2,2.2),CFrame.new(pos+Vector3.new(0,0.29,0)),BRASS,Enum.Material.Metal)
                        circle.Shape=Enum.PartType.Cylinder
                        circle.CFrame=circle.CFrame*CFrame.Angles(0,0,math.pi/2)
                        circle.CanCollide=false
                    end
                end
                -- Pas plus de trois poteaux par trajet : lisibilité et budget de parts.
                if idx<=4 then
                    local point=a+direction*math.min(len-2,9)+cross*6.5
                    local post=F.part(folder,"Poteau d'orientation",Vector3.new(0.7,8,0.7),CFrame.new(point+Vector3.new(0,4.0,0)),INK,Enum.Material.Metal)
                    local yaw=math.deg(math.atan2(-direction.X,-direction.Z))
                    local label=F.sign(folder,"Vers "..name,point+Vector3.new(0,8.2,0),yaw,"→ "..name,19,3.1)
                    label.CanCollide=false
                    total+=1
                end
            end
        end
    end
    folder:SetAttribute("KinDirectionSigns",total)
    return folder
end
return Wayfinding

]])
source(server,"PendingTravel","ModuleScript",[[
--!strict
-- Corrélation pure des requêtes : les retours tardifs ne libèrent pas un autre voyage.
local PendingTravel={}
function PendingTravel.new()
    local requests={}
    local store={}
    function store.begin(player,request)
        if requests[player] then return false end
        requests[player]=request
        return true
    end
    function store.get(player) return requests[player] end
    function store.take(player,id)
        local request=requests[player]
        if not request or request.id~=id then return nil end
        requests[player]=nil
        return request
    end
    function store.clear(player)
        local request=requests[player]
        requests[player]=nil
        return request
    end
    return store
end
return PendingTravel

]])
source(server,"PlacePortalsV26","ModuleScript",[[
--!strict
-- Les portes sont des frontières explicites entre le monde extérieur et les
-- huit Places institutionnelles. La décoration ne porte AUCUNE collision.
local F=require(script.Parent.Factory)
local Portals={}
local names={
 city="Kin City",city_hall="Hôtel de ville",ekoh_tower="Tour EkoH",
 library="Grande Bibliothèque",campus="Université KonnectED",
 justice_palace="Palais de justice",innovation_lab="Parc de l'Innovation",
 museum="Musée Kreative",orgo_center="Centre Orgo",
}
local teal=Color3.fromRGB(30,104,100)
local opal=Color3.fromRGB(197,244,240)
local gold=Color3.fromRGB(229,215,175)
local function ornament(parent,name,size,frame,color,material)
 local p=F.part(parent,name,size,frame,color,material)
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
 p:SetAttribute("KinOptionalDetail",true)
 return p
end
function Portals.decorate(parent,door,frame,mode)
 local name=names[door.destination_place_key] or door.destination_place_key
 local isEntry=door.source_place_key=="city"
 local deco=Instance.new("Folder")
 deco.Name="Seuil de Place — "..door.door_id
 deco:SetAttribute("KinPortalBoundary",true)
 deco:SetAttribute("KinFromPlace",door.source_place_key)
 deco:SetAttribute("KinToPlace",door.destination_place_key)
 deco.Parent=parent
 for _,side in ipairs({-1,1}) do
  ornament(deco,"Pilastre sarcelle",Vector3.new(0.65,8.0,0.9),
   frame*CFrame.new(side*5.0,1.7,0),teal,Enum.Material.Metal)
  ornament(deco,"Cristal opalin",Vector3.new(0.85,1.15,0.85),
   frame*CFrame.new(side*5.0,6.25,0)*CFrame.Angles(0,0,math.rad(45)),opal,Enum.Material.Neon)
 end
 ornament(deco,"Linteau champagne",Vector3.new(11.3,0.5,1.1),
  frame*CFrame.new(0,5.95,0),gold,Enum.Material.Metal)
 local tag=if isEntry then "ENTRÉE • "..name else "RETOUR • KIN CITY"
 local label=F.sign(deco,"Signalétique de la Place",(frame*CFrame.new(0,4.7,-0.55)).Position,
  math.deg(math.atan2(-frame.LookVector.X,-frame.LookVector.Z)),tag,9.5,1.6)
 label.CastShadow=false;label.CanTouch=false;label.CanQuery=false
 if mode=="SPLIT_PREVIEW" then
  local info=F.sign(deco,"Statut de publication",(frame*CFrame.new(0,3.5,-0.65)).Position,
    math.deg(math.atan2(-frame.LookVector.X,-frame.LookVector.Z)),"PLACE DISTINCTE • À PUBLIER",8,0.8)
  info.CanTouch=false;info.CanQuery=false;info.CastShadow=false
 end
 return deco
end
return Portals

]])
source(server,"PlayerTravel","ModuleScript",[[
--!strict
local Players=game:GetService("Players")
local TeleportService=game:GetService("TeleportService")
local Spatial=require(script.Parent.Spatial)
local Plan=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("WorldPlan"))
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local PlayerTravel={}
local pending=require(script.Parent.PendingTravel).new()
local where={}
local doorById={}
for _,d in ipairs(Plan.doors) do doorById[d.door_id]=d end
local replyEvent=nil
local placeNames={}
for _,place in ipairs(Plan.places) do placeNames[place.place_key]=place.display_name or place.place_key end
local function finishPending(player,id)
    local request=pending.take(player,id)
    if request then TravelSession.finish(player,request.token) end
    return request
end

local function report(player,status,message)
    if replyEvent and player.Parent==Players then
        replyEvent:FireClient(player,{kind="travel.failure.v1",status=status,message=message})
    end
end
local function destination(place,anchor)
    local cf=Spatial.anchorCFrame(place,anchor)
    if not cf then return nil end
    return cf*CFrame.new(0,1.4,0)
end
local function move(player,place,anchor,existingToken)
    local cf=destination(place,anchor)
    if not cf then
        if existingToken then TravelSession.finish(player,existingToken) end
        return false
    end
    local token=existingToken or TravelSession.begin(player,"spawn")
    if not token then return false end
    do
        -- Le stream est opportuniste : après toute suspension la session
        -- et le personnage doivent encore être valides.
        pcall(function() player:RequestStreamAroundAsync(cf.Position,4) end)
    end
    if not TravelSession.valid(player,token) then
        TravelSession.finish(player,token)
        return false
    end
    token.character:PivotTo(cf)
    where[player]={place=place,anchor=anchor}
    player:SetAttribute("KinZone",place)
    TravelSession.finish(player,token)
    return true
end
local function safeStart(currentPlace)
    if currentPlace=="city" then return "city.central.spawn" end
    local place=Spatial.place(currentPlace)
    assert(place,"Place inconnue: "..tostring(currentPlace))
    for _,a in ipairs(place.anchors) do
        if a.role=="spawn" then return a.anchor_id end
    end
    error("No safe start for "..currentPlace)
end
local function arrivalFromJoin(player,currentPlace)
    if Spatial.mode()=="LOCAL_UNIVERSE" then return nil end
    local ok,join=pcall(function()return player:GetJoinData() end)
    if not ok or type(join)~="table" then return nil end
    local td=join.TeleportData
    if type(td)~="table" or td.v~=1 then return nil end
    local src=doorById[td.sourceDoorId]
    if not src or src.destination_place_key~=currentPlace then return nil end
    if src.destination_anchor_id~=td.destinationAnchorId then return nil end
    return td.destinationAnchorId
end
function PlayerTravel.setup(state,events)
    replyEvent=events
    local startKey=state.currentPlace
    local function register(player)
        local requested=arrivalFromJoin(player,startKey)
        local anchor=requested or safeStart(startKey)
        where[player]={place=startKey,anchor=anchor}
        player:SetAttribute("KinZone",startKey)
        local function onCharacter(char)
            pending.clear(player)
            TravelSession.cancel(player)
            task.defer(function()
                if not char:WaitForChild("HumanoidRootPart",12) then return end
                if not char:WaitForChild("Humanoid",12) then return end
                if player.Character~=char then return end
                local current=where[player]
                if current then move(player,current.place,current.anchor) end
            end)
        end
        player.CharacterAdded:Connect(onCharacter)
        if player.Character then onCharacter(player.Character) end
    end
    Players.PlayerAdded:Connect(register)
    for _,p in ipairs(Players:GetPlayers()) do register(p) end
    Players.PlayerRemoving:Connect(function(p)
        pending.clear(p)
        where[p]=nil
        TravelSession.cancel(p)
        RateLimiter.clear(p)
    end)
    TeleportService.TeleportInitFailed:Connect(function(p,result,message,placeId,options)
        local request=pending.get(p)
        if not request or request.targetId~=placeId or not options then return end
        local ok,data=pcall(function() return options:GetTeleportData() end)
        if not ok or type(data)~="table" or data.requestId~=request.id then return end
        if finishPending(p,request.id) then report(p,"UNAVAILABLE","Le passage a échoué. Réessayez.") end
    end)
end

local allowedShuttles={}
for _,door in ipairs(Plan.doors) do
    if door.source_place_key=="city" then allowedShuttles[door.source_anchor_id]=true end
end
allowedShuttles["city.central.spawn"]=true

function PlayerTravel.tryShuttle(player,data)
    local current=where[player]
    if not current or current.place~="city" or not allowedShuttles[data.anchor] then return end
    if not RateLimiter.allowed(player,"shuttle",2.0) then return end
    if not move(player,"city",data.anchor) then
        report(player,"BUSY","Un autre déplacement est en cours.")
    end
end

function PlayerTravel.tryLift(player,data)
    local current=where[player]
    if not current or current.place~=data.place_key then return end
    if typeof(data.destination)~="Vector3" then return end
    if not RateLimiter.allowed(player,"lift/"..tostring(data.lift_id),1.2) then return end
    local token=TravelSession.begin(player,"lift")
    if not token then return end
    pcall(function() player:RequestStreamAroundAsync(data.destination,4) end)
    if TravelSession.valid(player,token) then
        token.character:PivotTo(CFrame.new(data.destination))
    end
    TravelSession.finish(player,token)
end

function PlayerTravel.tryDoor(player,door,state)
    local zone=where[player]
    if not zone or zone.place~=door.source_place_key then return end
    if not RateLimiter.allowed(player,"door",1.6) then return end
    local dest=door.destination_place_key
    local anchor=door.destination_anchor_id
    local token=TravelSession.begin(player,"door")
    if not token then return end
    if Spatial.mode()=="LOCAL_UNIVERSE" then
        if not move(player,dest,anchor,token) then
            report(player,"UNAVAILABLE","Passage indisponible actuellement.")
        end
        return
    end
    if Spatial.mode()=="SPLIT_PREVIEW" then
        TravelSession.finish(player,token)
        report(player,"UNPUBLISHED","Intérieur dans une Place distincte : publication requise. Utiliser l’aperçu dédié dans Studio.")
        return
    end
    local targetId=Spatial.placeId(dest)
    if not targetId then
        TravelSession.finish(player,token)
        report(player,"UNPUBLISHED","Ce lieu n'est pas publié.")
        return
    end
    if not TravelSession.valid(player,token) then
        TravelSession.finish(player,token)
        return
    end
    local opts=Instance.new("TeleportOptions")
    opts:SetTeleportData({v=1,sourceDoorId=door.door_id,destinationAnchorId=anchor,requestId=token.id})
    if not pending.begin(player,{id=token.id,token=token,targetId=targetId}) then
        TravelSession.finish(player,token)
        return
    end
    if replyEvent then replyEvent:FireClient(player,{kind="travel.pending.v1",destination=placeNames[dest]}) end
    -- Borne de récupération, sans relancer automatiquement une téléportation.
    task.delay(30,function()
        if finishPending(player,token.id) then
            report(player,"TIMEOUT","Le passage prend trop de temps. Vous pouvez réessayer.")
        end
    end)
    local success,reason=pcall(function()
        TeleportService:TeleportAsync(targetId,{player},opts)
    end)
    if not success and finishPending(player,token.id) then
        warn("Kin City transit failure",door.door_id,reason)
        report(player,"ERROR","Impossible de franchir cette porte.")
    end
    -- Succès de l'appel : garder la réservation jusqu'au départ, échec ou délai.
end
return PlayerTravel

]])
source(server,"PromenadeCommerce","ModuleScript",[[
--!strict
-- Façades colorées et véritables boutiques traversables de la couronne v13.
-- Construction en mode édition avec primitives natives, aucune Toolbox.
local RS=game:GetService("ReplicatedStorage")
local Places=require(RS:WaitForChild("KinCityShared"):WaitForChild("PromenadeCommerce"))
local Factory=require(script.Parent.Factory)
local CrystalEverydayV19=require(script.Parent.CrystalEverydayV19)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local Shops={}
local STONE=Color3.fromRGB(224,211,187)
local COPPER=Color3.fromRGB(173,120,76)
local INK=Color3.fromRGB(30,104,100)
local GLASS=Color3.fromRGB(197,244,240)
local GOLD=Color3.fromRGB(233,190,113)
local function part(root,label,base,x,y,z,w,h,d,color,material,solid)
    local obj=Factory.part(root,label,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then obj.CanCollide=false;obj.CanQuery=false;obj.CanTouch=false end
    return obj
end
local function seat(root,base,x,z)
    local s=Instance.new("Seat")
    s.Name="Chaise de la promenade"
    s.Size=Vector3.new(2.5,0.7,2.3)
    s.CFrame=base*CFrame.new(x,1.5,z)
    s.Anchored=true;s.Color=COPPER;s.Material=Enum.Material.Wood;s.Parent=root
    part(root,"Dossier",base,x,2.4,z+1.15,2.7,1.8,0.3,INK,Enum.Material.Wood)
end
local function plant(root,base,x,z,shade)
    part(root,"Jardinière",base,x,0.9,z,2.6,1.4,2.4,COPPER,Enum.Material.Wood)
    for i=1,3 do
        local bud=part(root,"Feuille",base,x+(i-2)*0.6,2.3,z,1.1,1.8,1.2,shade,Enum.Material.Grass,false)
        bud.Shape=Enum.PartType.Ball
    end
end
local function shop(parent,item)
    local mdl=Instance.new("Model")
    mdl.Name=item.title.." · numéro "..item.slot
    mdl:SetAttribute("KinCommerceId",item.id)
    mdl.Parent=parent
    local center=Vector3.new(item.center_studs[1],0,item.center_studs[3])
    -- Façade orientée vers le centre de l'île (z négatif = accès sur la promenade).
    local base=CFrame.new(center)*CFrame.Angles(0,item.yaw,0)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local roof=Color3.fromRGB(math.floor(item.color[1]*0.55),math.floor(item.color[2]*0.55),math.floor(item.color[3]*0.55))
    part(mdl,"Fondation ouverte",base,0,0.2,0,17,0.6,21,STONE,Enum.Material.Cobblestone)
    part(mdl,"Mur arrière",base,0,6.5,10.5,17,12.5,0.8,tint,Enum.Material.Brick)
    for _,side in ipairs({-1,1}) do
        part(mdl,"Mur latéral",base,side*8.5,6.5,0,0.8,12.5,21,tint,Enum.Material.Brick)
        local glass=part(mdl,"Vitrine",base,side*5.75,5.6,-10.55,5.5,6.6,0.25,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(glass,false)
        part(mdl,"Volet de vitrine",base,side*5.7,10.8,-10.65,5.7,0.4,0.3,COPPER,Enum.Material.Wood,false)
        part(mdl,"Pilier",base,side*8.4,6.4,-10.5,0.9,12.5,0.9,INK,Enum.Material.Metal)
        plant(mdl,base,side*12,-11,tint)
    end
    -- Passage central de 5,6 studs : pas de mur ou porte bloquante.
    part(mdl,"Linteau",base,0,11,-10.6,5.8,3.2,0.7,COPPER,Enum.Material.Wood)
    part(mdl,"Toiture ardoise",base,0,13.4,0,19.5,0.9,23,roof,Enum.Material.Slate)
    part(mdl,"Auvent textile",base,0,10.6,-13.0,14,0.5,5.4,tint,Enum.Material.Fabric,false)
    part(mdl,"Chemin du trottoir",base,0,0.11,-15,7,0.2,13,STONE,Enum.Material.Cobblestone)
    for i=1,3 do
        local xx=if i%2==0 then 3.8 else -3.8
        local zz=-2+(i-1)*4
        part(mdl,"Comptoir de fabrication",base,xx,2.1,zz,4.9,0.6,2.5,COPPER,Enum.Material.WoodPlanks)
        local palette=Color3.fromHSV((item.slot*0.072+i*0.17)%1,0.4,0.82)
        for k=1,4 do
            local piece=part(mdl,"Objet fait main",base,xx-1.7+(k-1)*1.12,2.95,zz,0.65,1.1+(k%2)*0.6,0.85,palette,Enum.Material.SmoothPlastic,false)
            if item.kind=="ceramics" then piece.Shape=Enum.PartType.Cylinder end
        end
    end
    for level=1,3 do
        part(mdl,"Rayon d'exposition",base,-6.4,1.8+level*2.45,7,2.1,0.35,4.5,COPPER,Enum.Material.Wood)
        for row=1,3 do
            part(mdl,"Collection",base,-6.4,2.5+level*2.45,5.2+row*0.9,1.1,1.45,0.6,tint,Enum.Material.Fabric,false)
        end
    end
    seat(mdl,base,4.5,-6)
    local switch=part(mdl,"Commande de vitrine cinétique",base,6.5,2.2,7.1,2.5,3.6,1.7,INK,Enum.Material.Metal)
    switch:SetAttribute("KinCommerceAction","display")
    switch:SetAttribute("KinCommerceId",item.id)
    Factory.prompt(switch,"Animer l'atelier",item.title)
    local mobile=Instance.new("Model")
    mobile.Name="Présentoir mobile"
    mobile:SetAttribute("KinCommerceDisplay",item.id)
    mobile.Parent=mdl
    local pivot=part(mobile,"Pivot",base,0,4.2,4.4,0.4,0.4,0.4,GOLD,Enum.Material.Metal,false)
    pivot.Transparency=1;mobile.PrimaryPart=pivot
    part(mobile,"Socle du présentoir",base,0,3.7,4.4,3.5,0.5,3.5,COPPER,Enum.Material.Wood)
    for n=1,4 do
        local ang=n*math.pi/2
        local jewel=part(mobile,"Pièce tournante",base,math.cos(ang)*1.2,5.2,4.4+math.sin(ang)*1.2,0.95,1.8,0.95,if n%2==0 then GOLD else tint,Enum.Material.Neon,false)
        jewel.Shape=Enum.PartType.Ball
    end
    -- Consultation préparée pour une future fonctionnalité : aucun achat ni débit.
    local future=part(mdl,"Terminal de future activité",base,-5.6,2.3,-3.8,2.4,3.8,1.5,INK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",item.id..".catalog.future")
    future:SetAttribute("KinStubCapabilityId","future.commerce.catalog")
    future:SetAttribute("KinStubTitle",item.title)
    Factory.prompt(future,"Consulter", "Fonctionnalité à venir")
    part(mdl,"Écran du catalogue",base,-5.6,3.1,-4.65,1.9,1.8,0.15,GLASS,Enum.Material.Neon,false)
    Factory.sign(mdl,"Enseigne d'atelier",(base*CFrame.new(0,11.8,-12.7)).Position,math.deg(item.yaw),item.title,18,2.5).CanCollide=false
    CrystalEverydayV19.frame(mdl,base,17,21,13.4,"commerce")
    SecondaryArchitectureV25.boutique(mdl,base,item.kind,tint)
    return mdl
end
function Shops.isReserved(x,z)
    for _,item in ipairs(Places) do
        local dx=x-item.center_studs[1]
        local dz=z-item.center_studs[3]
        if dx*dx+dz*dz<17*17 then return true end
    end
    return false
end
function Shops.make(city)
    local root=Factory.folder(city,"Promenade des métiers — boutiques visitables")
    local last=nil
    for _,item in ipairs(Places) do
        shop(root,item)
        -- Petites allées tangentielles entre voisins proches, sans pont à travers
        -- les agoras et les débarcadères explicitement exclus du registre.
        if last and item.slot-last.slot<=2 then
            local a=Vector3.new(last.center_studs[1],0.13,last.center_studs[3])
            local b=Vector3.new(item.center_studs[1],0.13,item.center_studs[3])
            local d=b-a
            local seg=Factory.part(root,"Rue des artisans",Vector3.new(5,0.24,d.Magnitude),CFrame.lookAt((a+b)/2,b),STONE,Enum.Material.Cobblestone)
            seg.CanCollide=false
        end
        last=item
    end
    root:SetAttribute("KinCommerceShopsBuilt",#Places)
    return root
end
return Shops

]])
source(server,"PromenadeCraftRuntime","ModuleScript",[[
--!strict
-- Animation locale des présentoirs de métiers. Le client n'écrit aucun état monde.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
function Runtime.start(world,reply)
    local displays={}
    local busy={}
    for _,thing in ipairs(world:GetDescendants()) do
        if thing:IsA("Model") then
            local id=thing:GetAttribute("KinCommerceDisplay")
            if type(id)=="string" and thing.PrimaryPart then displays[id]=thing end
        end
    end
    Prompts.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if host:GetAttribute("KinCommerceAction")~="display" then return end
        local id=host:GetAttribute("KinCommerceId")
        if type(id)~="string" or busy[id] then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp or (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"craft/"..id,0.8) then return end
        local model=displays[id]
        if not model or not model.Parent then return end
        busy[id]=true
        local initial=model:GetPivot()
        task.spawn(function()
            local ok,reason=pcall(function()
                local start=os.clock()
                while model.Parent and world.Parent do
                    local t=math.clamp((os.clock()-start)/3.0,0,1)
                    model:PivotTo(initial*CFrame.Angles(0,t*2*math.pi,0))
                    if t>=1 then break end
                    RunService.Heartbeat:Wait()
                end
                if model.Parent then model:PivotTo(initial) end
            end)
            if not ok then warn("Kin City présentoir",reason) end
            busy[id]=nil
        end)
        if player.Parent==Players then
            reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Atelier de la promenade",message="Le présentoir se met en mouvement.",notice="Animation locale · aucune opération kOA"})
        end
    end)
end
return Runtime

]])
source(server,"PromenadeLife","ModuleScript",[[
--!strict
-- Animations et activités publiques de Kin City : marchés, pergolas, exposition en plein air.
-- Installations permanentes. Toutes les interactions métier sont des stubs identifiés.
local F=require(script.Parent.Factory)
local Promenade={}
local STONE=Color3.fromRGB(211,196,168)
local WOOD=Color3.fromRGB(140,106,74)
local IRON=Color3.fromRGB(42,73,84)
local CYAN=Color3.fromRGB(85,188,180)
local function part(parent,name,base,size,offset,color,material,solid)
    local p=F.part(parent,name,size,base*CFrame.new(offset),color,material)
    if solid==false then p.CanCollide=false;p.CastShadow=false end
    return p
end
local function ball(parent,name,base,size,offset,color)
    local p=part(parent,name,base,size,offset,color,Enum.Material.Glass,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function blocked(x,z,structures)
    for _,b in ipairs(structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        if math.sqrt(dx*dx+dz*dz)<math.max(64,math.max(b.footprint_studs[1],b.footprint_studs[2])*0.68+20) then return true end
    end
    return false
end
local themes={
    {"Atelier des idées","Rencontre et création",Color3.fromRGB(130,188,164)},
    {"Jardin de lecture","Littérature et savoir",Color3.fromRGB(211,165,113)},
    {"Forum du dialogue","Écoute et médiation",Color3.fromRGB(144,173,210)},
    {"Passage des inventions","Science collaborative",Color3.fromRGB(203,148,177)},
    {"Scène des cultures","Créativité partagée",Color3.fromRGB(208,186,106)},
    {"Pavillon du vivant","Écologie et découverte",Color3.fromRGB(120,184,126)},
}
local function pavilion(root,base,index,spec)
    local m=Instance.new("Model")
    m.Name=spec[1].." "..index
    m:SetAttribute("KinPublicSpaceId",string.format("city.promenade.%02d",index))
    m.Parent=root
    local accent=spec[3]
    part(m,"Estrade",base,Vector3.new(26,0.85,22),Vector3.new(0,0.38,0),STONE,Enum.Material.Marble,true)
    for _,sx in ipairs({-1,1}) do
        for _,sz in ipairs({-1,1}) do
            part(m,"Colonne de pergola",base,Vector3.new(0.9,13,0.9),Vector3.new(sx*11,7,sz*9),WOOD,Enum.Material.Wood,true)
            part(m,"Socle de colonne",base,Vector3.new(2.4,1.2,2.4),Vector3.new(sx*11,0.8,sz*9),STONE,Enum.Material.Marble,true)
        end
    end
    for _,zz in ipairs({-8.5,8.5}) do
        part(m,"Poutre de pergola",base,Vector3.new(25,0.7,1.3),Vector3.new(0,13.6,zz),WOOD,Enum.Material.WoodPlanks,false)
    end
    for n=-3,3 do
        part(m,"Treillage ouvert",base,Vector3.new(0.8,0.55,20),Vector3.new(n*3.1,14.2,0),WOOD,Enum.Material.WoodPlanks,false)
    end
    local kiosk=part(m,"Borne de quartier",base,Vector3.new(4.5,4.7,3),Vector3.new(0,2.6,7.2),IRON,Enum.Material.Metal,true)
    part(m,"Écran public",base,Vector3.new(3.8,2.7,0.12),Vector3.new(0,3.3,5.62),accent,Enum.Material.Neon,false)
    kiosk:SetAttribute("KinStubInteractionId","city.public.pavilion."..index)
    kiosk:SetAttribute("KinStubCapabilityId","future.public.activities")
    kiosk:SetAttribute("KinStubTitle",spec[2])
    F.prompt(kiosk,"Découvrir",spec[1])
    for _,x in ipairs({-7.5,7.5}) do
        part(m,"Banc d'atelier",base,Vector3.new(7.1,0.6,2.3),Vector3.new(x,1.55,-2.7),WOOD,Enum.Material.WoodPlanks,true)
        part(m,"Dossier",base,Vector3.new(7.1,2,0.45),Vector3.new(x,2.5,-1.7),IRON,Enum.Material.Metal,false)
        ball(m,"Lampe d'ambiance",base,Vector3.new(1.3,1.3,1.3),Vector3.new(x,12.8,-3),accent)
    end
    F.sign(m,"Enseigne",(base*CFrame.new(0,11,-9.7)).Position,math.deg(math.atan2(-base.LookVector.X,-base.LookVector.Z)),spec[1],20,2.5).CanCollide=false
end
function Promenade.make(parent,plan)
    local folder=F.folder(parent,"Promenades citoyennes")
    local total=0
    for i=1,36 do
        local angle=2*math.pi*(i-1)/36 + 0.11
        local radius=344+(i%3)*9
        local x,z=math.cos(angle)*radius,math.sin(angle)*radius
        if not blocked(x,z,plan.structures) then
            local base=CFrame.new(x,0.13,z)*CFrame.Angles(0,-angle,0)
            local theme=themes[(i-1)%#themes+1]
            pavilion(folder,base,i,theme)
            total+=1
        end
    end
    folder:SetAttribute("KinPavilionsCreated",total)
    return folder
end
return Promenade

]])
source(server,"PromptRouter","ModuleScript",[[
--!strict
local ProximityPromptService=game:GetService("ProximityPromptService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Messages=require(Shared:WaitForChild("Messages"))
local RateLimiter=require(script.Parent.RateLimiter)
local PlayerTravel=require(script.Parent.PlayerTravel)
local PromptRouter={}

function PromptRouter.start(state,reply)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local record=state.prompts[prompt]
        -- Les citoyens R15 arrivent après la construction : leurs prompts
        -- restent reconnus sans les copier dans le registre statique initial.
        if not record then
            local dynamicHost=prompt.Parent
            if dynamicHost and dynamicHost:IsA("BasePart") and dynamicHost:GetAttribute("KinStubInteractionId") then
                record={kind="ambient",data={
                    interaction_id=dynamicHost:GetAttribute("KinStubInteractionId"),
                    capability_id=dynamicHost:GetAttribute("KinStubCapabilityId") or "future.local",
                    title=dynamicHost:GetAttribute("KinStubTitle") or "Kin City"
                }}
            end
        end
        if not record or not prompt.Enabled or not prompt:IsDescendantOf(state.world) then return end
        if not player or not player:IsA("Player") then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp then return end
        local base=prompt.Parent
        if not base or not base:IsA("BasePart") then return end
        if (base.Position-hrp.Position).Magnitude > prompt.MaxActivationDistance+3 then return end
        if record.kind=="door" then
            PlayerTravel.tryDoor(player,record.data,state)
        elseif record.kind=="shuttle" then
            PlayerTravel.tryShuttle(player,record.data)
        elseif record.kind=="lift" then
            PlayerTravel.tryLift(player,record.data)
        elseif record.kind=="vista" then
            local data=record.data
            if typeof(data.camera_position)~="Vector3" or typeof(data.look_at)~="Vector3" then return end
            if not RateLimiter.allowed(player,"vista/"..tostring(data.vista_id),0.8) then return end
            reply:FireClient(player,{
                kind="scenic.view.v1",vista_id=data.vista_id,
                title=data.title or "Panorama de Kin City",
                camera_position=data.camera_position,look_at=data.look_at
            })
        elseif record.kind=="ambient" then
            local data=record.data
            if not RateLimiter.allowed(player,"ambient/"..data.interaction_id,0.8) then return end
            reply:FireClient(player,{
                kind="interaction.reply.v1",status="COMING_SOON",
                interaction_id=data.interaction_id,capability_id=data.capability_id,
                title=data.title,message="Fonctionnalité à venir",
                notice="Ce pavillon sera relié aux services de Kin City ultérieurement."
            })
        elseif record.kind=="interaction" then
            local data=record.data
            if not RateLimiter.allowed(player,"interaction/"..data.interaction_id,0.75) then return end
            if data.provider_mode~="stub" then return end
            reply:FireClient(player,{
                kind="interaction.reply.v1",
                status="COMING_SOON",
                interaction_id=data.interaction_id,
                capability_id=data.capability_id,
                title=Messages[data.display_title_key] or "Kin City",
                message=Messages[data.display_message_key] or "Fonctionnalité à venir",
                notice=Messages["ui.no_operation"] or "Aucune opération n’a été effectuée."
            })
        end
    end)
end
return PromptRouter

]])
source(server,"PropGenerator","ModuleScript",[[
--!strict
local Factory = require(script.Parent.Factory)
local PropGenerator = {}

local function piece(parent, name, size, base, dx, dy, dz, color, material)
    return Factory.part(parent, name, size, base * CFrame.new(dx,dy,dz),color,material)
end

function PropGenerator.make(parent, item, position, palette)
    local model = Instance.new("Model")
    model.Name = item.furnishing_id
    model:SetAttribute("KinFurnishingId",item.furnishing_id)
    model:SetAttribute("KinAssetId",item.asset_id)
    model:SetAttribute("KinPlaceKey",item.place_key or "")
    if item.anchor_id then model:SetAttribute("KinAnchorId",item.anchor_id) end
    model.Parent = parent
    local base = CFrame.new(position) * CFrame.Angles(0, math.rad(item.yaw_degrees or 0),0)
    local wood = Color3.fromRGB(113,79,51)
    local stone = palette.trim
    local teal = palette.accent
    local metal = Color3.fromRGB(57,72,79)
    local asset = item.asset_id
    local root
    if asset == "prop.bookshelf" then
        root = piece(model,"Bookshelf",Vector3.new(9,9,1.7),base,0,4.5,0,wood,Enum.Material.Wood)
        for h=1,4 do
            piece(model,"Shelf",Vector3.new(8.5,0.25,2.1),base,0,h*1.8,0,stone)
            for j=1,12 do
                local col = Color3.fromHSV(((h*12+j)*0.073)%1,0.45,0.80)
                piece(model,"Book",Vector3.new(0.38,1.3,1.3),base,-3.9+(j-1)*0.67,h*1.8+0.8,0,col)
            end
        end
    elseif asset == "prop.terminal" or asset == "prop.kiosk" then
        root = piece(model,"Terminal",Vector3.new(4.2,4.2,2.2),base,0,2.1,0,metal,Enum.Material.Metal)
        piece(model,"Screen",Vector3.new(3.4,2.2,0.22),base,0,3.1,-1.2,Color3.fromRGB(54,168,177),Enum.Material.Neon)
        piece(model,"ControlDesk",Vector3.new(4.8,0.3,2.8),base,0,1.8,-0.6,stone)
    elseif asset == "prop.board" or asset == "prop.panel" or asset == "prop.display" then
        root = piece(model,"Panel",Vector3.new(7,5,0.75),base,0,4.2,0,metal)
        piece(model,"DisplaySurface",Vector3.new(6.3,4.3,0.14),base,0,4.2,-0.43,teal,Enum.Material.SmoothPlastic)
        piece(model,"Stand",Vector3.new(0.6,2.1,0.6),base,0,1,0,wood)
    elseif asset == "prop.table" then
        root = piece(model,"Tabletop",Vector3.new(8,0.5,4),base,0,3.2,0,wood,Enum.Material.Wood)
        for x=-1,1,2 do for z=-1,1,2 do
            piece(model,"Leg",Vector3.new(0.6,3,0.6),base,x*3.1,1.5,z*1.3,wood)
        end end
    elseif asset == "prop.bench" then
        root = piece(model,"Seat",Vector3.new(7,0.55,2.4),base,0,1.6,0,wood,Enum.Material.Wood)
        piece(model,"Back",Vector3.new(7,2.2,0.5),base,0,2.4,1,wood,Enum.Material.Wood)
        for x=-1,1,2 do piece(model,"Leg",Vector3.new(0.6,1.5,0.6),base,x*2.5,0.75,0,metal) end
    elseif asset == "prop.planter" then
        root = piece(model,"Planter",Vector3.new(3.5,2,3.5),base,0,1,0,stone)
        local foliage = piece(model,"Leaves",Vector3.new(4.2,4.2,4.2),base,0,4,0,Color3.fromRGB(72,124,82),Enum.Material.Grass)
        foliage.Shape=Enum.PartType.Ball
    elseif asset == "prop.lamp" then
        root = piece(model,"LampStand",Vector3.new(0.8,8,0.8),base,0,4,0,metal)
        local shade = piece(model,"LampGlow",Vector3.new(3,0.8,3),base,0,8,0,Color3.fromRGB(255,236,177),Enum.Material.Neon)
        shade.CanCollide=false
        local light=Instance.new("PointLight");light.Brightness=1.6;light.Range=23;light.Parent=shade
    else
        error("Unknown asset generator: "..tostring(asset))
    end
    model.PrimaryPart = root
    if item.collision_policy == "no_collision" then
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
    return root
end

return PropGenerator

]])
source(server,"PublicWorkshops","ModuleScript",[[
--!strict
-- V14 · Six ateliers en plein air à 3 étapes, visibles depuis les agoras.
-- La manipulation d'objets est réelle; aucune note, récompense ou requête kOA.
local RS=game:GetService("ReplicatedStorage")
local Registry=require(RS:WaitForChild("KinCityShared"):WaitForChild("UrbanV14Destinations"))
local F=require(script.Parent.Factory)
local Workshop={}
local STONE=Color3.fromRGB(219,211,184)
local INK=Color3.fromRGB(30,104,100)
local GOLD=Color3.fromRGB(233,195,117)
local WOOD=Color3.fromRGB(148,106,73)
local function part(parent,name,base,x,y,z,w,h,d,color,material,solid)
    local obj=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false end
    return obj
end
local function one(parent,data)
    local root=Instance.new("Model")
    root.Name=data.title;root.Parent=parent
    root:SetAttribute("KinWorkshopId",data.id)
    local base=CFrame.new(data.center_studs[1],0,data.center_studs[3])*CFrame.Angles(0,data.yaw,0)
    local accent=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
    part(root,"Parvis accessible",base,0,0.1,0,24,0.4,28,STONE,Enum.Material.Cobblestone)
    -- Raccord au parvis civique (centre de l'agora 43 studs vers +X).
    part(root,"Raccord piétonnier",base,18,0.1,-3,18,0.3,5,STONE,Enum.Material.Cobblestone)
    for _,x in ipairs({-10,10}) do
        for _,z in ipairs({-11,11}) do
            part(root,"Pilier de l'atelier",base,x,5.5,z,0.85,11,0.85,INK,Enum.Material.Metal)
        end
    end
    for _,z in ipairs({-11,11}) do
        part(root,"Poutre ouverte",base,0,11,z,21,0.5,0.5,GOLD,Enum.Material.Metal,false)
    end
    for n=-2,2 do
        part(root,"Lattis de pergola",base,n*4.1,11.8,0,0.55,0.35,23,WOOD,Enum.Material.WoodPlanks,false)
    end
    local machine=Instance.new("Model")
    machine.Name="Machine pédagogique activable";machine.Parent=root
    machine:SetAttribute("KinWorkshopMachine",data.id)
    local pivot=part(machine,"Pivot central",base,0,4.7,5,0.25,0.25,0.25,GOLD,Enum.Material.Metal,false)
    machine.PrimaryPart=pivot;pivot.Transparency=1
    local core=part(machine,"Cœur expérimental",base,0,4.7,5,4,4,4,accent,Enum.Material.Neon,false)
    core:SetAttribute("KinWorkshopCore",data.id)
    core.Shape=Enum.PartType.Ball
    local light=Instance.new("PointLight")
    light.Brightness=0.35;light.Range=14;light.Parent=core
    for i=1,6 do
        local angle=(i/6)*2*math.pi
        local bead=part(machine,"Orbiteur mécanique",base,math.cos(angle)*3.1,4.7,5+math.sin(angle)*3.1,1.2,1.2,1.2,GOLD,Enum.Material.Neon,false)
        bead.Shape=Enum.PartType.Ball
    end
    local stages={"1 · ASSEMBLER","2 · CALIBRER","3 · ANIMER"}
    for step=1,3 do
        local x=-7+(step-1)*7
        local console=part(root,"Console d'expérience "..step,base,x,1.95,-6,3.4,3.4,2.5,INK,Enum.Material.Metal)
        console:SetAttribute("KinWorkshopId",data.id)
        console:SetAttribute("KinWorkshopStep",step)
        F.prompt(console,stages[step],data.title)
        local screen=part(root,"Voyant étape "..step,base,x,4.15,-6.3,1.4,1.4,1.4,Color3.fromRGB(94,124,136),Enum.Material.Neon,false)
        screen.Shape=Enum.PartType.Ball
        screen:SetAttribute("KinWorkshopIndicator",data.id)
        screen:SetAttribute("KinWorkshopIndicatorStep",step)
    end
    for _,x in ipairs({-8,8}) do
        local seat=Instance.new("Seat")
        seat.Name="Banc de l'atelier";seat.Size=Vector3.new(3.2,0.8,2.4)
        seat.Anchored=true;seat.Color=WOOD;seat.Material=Enum.Material.WoodPlanks
        seat.CFrame=base*CFrame.new(x,1.6,9.6);seat.Parent=root
    end
    local s=F.sign(root,"Instructions",(base*CFrame.new(0,10,-13)).Position,math.deg(data.yaw),data.title.." · 3 ÉTAPES",22,2.5)
    s.CanCollide=false
    -- Le terminal métier est distinct des 3 mécanismes locaux qui fonctionnent.
    local future=part(root,"Terminal futur",base,9,2.3,2.3,2.7,4,1.9,INK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",data.id..".future")
    future:SetAttribute("KinStubCapabilityId","future.public.workshops")
    future:SetAttribute("KinStubTitle",data.title)
    F.prompt(future,"Consulter","Fonctionnalité à venir")
    return root
end
function Workshop.isReserved(x,z)
    for _,data in ipairs(Registry.workshops) do
        local base=CFrame.new(data.center_studs[1],0,data.center_studs[3])*CFrame.Angles(0,data.yaw,0)
        local p=base:PointToObjectSpace(Vector3.new(x,0,z))
        if math.abs(p.X)<17 and math.abs(p.Z)<19 then return true end
    end
    return false
end
function Workshop.make(city)
    local folder=F.folder(city,"Ateliers pedagogiques en trois etapes")
    for _,data in ipairs(Registry.workshops) do one(folder,data) end
    folder:SetAttribute("KinWorkshopCount",#Registry.workshops)
    return folder
end
return Workshop

]])
source(server,"RateLimiter","ModuleScript",[[
--!strict
local RateLimiter={}
local last={}
function RateLimiter.allowed(player,action,interval)
    local now=os.clock()
    local byUser=last[player.UserId]
    if not byUser then byUser={};last[player.UserId]=byUser end
    if now-(byUser[action] or -1e12)<interval then return false end
    byUser[action]=now
    return true
end
function RateLimiter.clear(player)
    last[player.UserId]=nil
end
return RateLimiter

]])
source(server,"ResidentialLife","ModuleScript",[[
--!strict
-- Les lanternes sont une action purement physique, sans identité ni métier kOA.
local ProximityPromptService=game:GetService("ProximityPromptService")
local Players=game:GetService("Players")
local RateLimiter=require(script.Parent.RateLimiter)
local Life={}
function Life.start(world,reply)
    local states={}
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if host:GetAttribute("KinResidentialAction")~="lights" then return end
        local id=host:GetAttribute("KinResidentialQuarterId")
        if type(id)~="string" or not RateLimiter.allowed(player,"residential/"..id,0.8) then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        local enabled=(states[id]==false) -- Les lanternes sont déjà allumées à la génération.
        states[id]=enabled
        -- Coloration locale des lanternes, par ID stable de quartier.
        for _,item in ipairs(world:GetDescendants()) do
            if item:IsA("BasePart") and item:GetAttribute("KinResidentialLampGroup")==id then
                local light=item:FindFirstChildOfClass("PointLight")
                if light then light.Enabled=enabled end
                local original=item:GetAttribute("KinResidentialDefaultColor")
                if typeof(original)=="Color3" then item.Color=if enabled then original else Color3.fromRGB(75,89,91) end
            end
        end
        if player.Parent==Players then
            reply:FireClient(player,{
                kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Lanternes du quartier",
                message=if enabled then "Les lanternes éclairent la place commune." else "Les lanternes de la place sont éteintes.",
                notice="Activité locale · aucun service externe"
            })
        end
    end)
end
return Life

]])
source(server,"ResidentialQuarters","ModuleScript",[[
--!strict
-- Kin City v10 : six îlots résidentiels, quatre maisons à DEUX NIVEAUX chacun.
-- Intérieurs physiquement accessibles, escalier praticable, mobilier, cours,
-- plantations, toitures végétalisées et éclairage commandable localement.
-- Fabriqué uniquement avec des primitives Roblox. Aucun mesh payant ni HTTP.
local RS=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local CrystalEverydayV19=require(script.Parent.CrystalEverydayV19)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local NeighborhoodRooflinesV22=require(script.Parent.NeighborhoodRooflinesV22)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local Groups=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local Residential={}
local WOOD=Color3.fromRGB(153,112,83)
local CREAM=Color3.fromRGB(234,223,200)
local INK=Color3.fromRGB(30,104,100)
local GOLD=Color3.fromRGB(226,184,109)
local GREEN=Color3.fromRGB(85,145,99)
local GLASS=Color3.fromRGB(197,244,240)

local function block(parent,label,base,x,y,z,w,h,d,color,material,solid)
    local r=F.part(parent,label,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then r.CanCollide=false;r.CanTouch=false;r.CanQuery=false end
    return r
end
local function globe(parent,base,name,x,y,z,diameter,color,material)
    local r=block(parent,name,base,x,y,z,diameter,diameter,diameter,color,material,false)
    r.Shape=Enum.PartType.Ball
    return r
end
local function chair(parent,base,x,y,z,color)
    local seat=Instance.new("Seat")
    seat.Name="Assise utilisable"
    seat.Size=Vector3.new(2.5,0.7,2.2)
    seat.CFrame=base*CFrame.new(x,y,z)
    seat.Anchored=true;seat.Color=color;seat.Material=Enum.Material.WoodPlanks;seat.Parent=parent
    block(parent,"Dossier de chaise",base,x,y+1.0,z+1.0,2.6,1.9,0.35,INK,Enum.Material.Wood)
end
local function plant(parent,base,x,y,z,color,large)
    local height=if large then 2.2 else 1.3
    block(parent,"Bac de verdure",base,x,y,z,if large then 4 else 2.3,1.1,if large then 3.2 else 2.3,WOOD,Enum.Material.Wood)
    for n=1,3 do
        local dx=(n-2)*(if large then 1.0 else 0.52)
        block(parent,"Tige",base,x+dx,y+1.1+height/2,z,0.23,height,0.23,GREEN,Enum.Material.Grass,false)
        globe(parent,base,"Feuillage",x+dx,y+height+1.3,z,if large then 1.8 else 1.25,color,Enum.Material.Grass)
    end
end
local function lamp(parent,base,x,y,z,color,tag)
    local a=globe(parent,base,"Lanternon habité",x,y,z,1.8,color,Enum.Material.Neon)
    local light=Instance.new("PointLight")
    light.Brightness=0.9;light.Range=18;light.Shadows=false;light.Parent=a
    if tag then
        a:SetAttribute("KinResidentialLampGroup",tag)
        a:SetAttribute("KinResidentialDefaultColor",color)
    end
    return a
end
local function home(root,group,groupIndex,index,base,theme)
    local m=Instance.new("Model")
    m.Name=string.format("Maison %02d — %s",index,group.title)
    m.Parent=root
    local stableId=string.format("%s.home.%02d",group.id,index)
    m:SetAttribute("KinResidenceId",stableId)
    m:SetAttribute("KinResidenceQuarter",group.id)
    m:SetAttribute("KinResidenceLevels",2)
    local tint=Color3.fromRGB(theme[1],theme[2],theme[3])
    local wall=if group.style=="culture" then Color3.fromRGB(202,170,157) elseif group.style=="atelier" then Color3.fromRGB(178,200,201) elseif group.style=="collectif" then Color3.fromRGB(216,195,156) else Color3.fromRGB(191,204,176)
    local roof=if index%2==0 then Color3.fromRGB(18,62,60) else Color3.fromRGB(43,114,108)
    local w,d=23,25
    -- Deux niveaux construits à hauteur réelle et sans volume de collision fictif.
    block(m,"Fondation",base,0,-0.3,0,w+1,1.1,d+1,CREAM,Enum.Material.Cobblestone)
    block(m,"Plancher du rez-de-chaussée",base,0,0.38,0,w,0.52,d,WOOD,Enum.Material.WoodPlanks)
    -- Sol étage : passage de 5.5 studs à droite pour la volée d'escalier.
    block(m,"Étage — aile ouest",base,-4.9,10.7,0,13.2,0.52,24,CREAM,Enum.Material.WoodPlanks)
    block(m,"Étage — galerie est",base,9.9,10.7,0,3.1,0.52,24,CREAM,Enum.Material.WoodPlanks)
    block(m,"Étage — palier de jonction",base,2.9,10.7,10.3,11,0.52,4.2,CREAM,Enum.Material.WoodPlanks)
    for _,side in ipairs({-1,1}) do
        local xx=side*(w/2)
        block(m,"Mur porteur latéral",base,xx,5.2,0,0.68,9.5,d,wall,Enum.Material.Brick)
        block(m,"Mur de l'étage",base,xx,15.7,0,0.68,9.7,d,wall,Enum.Material.Brick)
        for _,z in ipairs({-6,5}) do
            local glass=block(m,"Baie vitrée latérale",base,xx+side*0.39,15.8,z,0.19,3.7,4.8,GLASS,Enum.Material.Glass,false)
            OpalGlazingV22.apply(glass,false)
            block(m,"Traverse de baie",base,xx+side*0.54,15.8,z,0.21,0.21,4.9,CREAM,Enum.Material.Metal,false)
        end
    end
    block(m,"Mur arrière",base,0,5.2,d/2,w,9.5,0.68,wall,Enum.Material.Brick)
    block(m,"Mur arrière étage",base,0,15.7,d/2,w,9.7,0.68,wall,Enum.Material.Brick)
    -- Entrée au rez-de-chaussée : ouverture de 8 studs de large, non bloquée.
    for _,side in ipairs({-1,1}) do
        block(m,"Façade ouverte",base,side*7.7,5.2,-d/2,7.5,9.5,0.68,wall,Enum.Material.Brick)
        local pane=block(m,"Vitrine d'entrée",base,side*8,5.9,-d/2-0.42,4.0,3.3,0.18,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(pane,false)
        block(m,"Poutre de porte",base,side*4.1,6,-d/2,0.55,7.5,0.9,CREAM,Enum.Material.Marble)
    end
    block(m,"Linteau de l'entrée",base,0,9.25,-d/2,8.8,1.3,1.0,CREAM,Enum.Material.Marble)
    -- Étage vitré donnant sur le jardin commun.
    for _,xx in ipairs({-8,-2.7,2.7,8}) do
        local pane=block(m,"Fenêtre de l'étage",base,xx,15.3,-d/2,4.1,5.6,0.25,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(pane,false)
    end
    block(m,"Sol de toiture",base,0,21.2,0,w+2,0.75,d+2,roof,Enum.Material.Slate)
    for _,xx in ipairs({-12,12}) do
        block(m,"Parapet vertical",base,xx,22.5,0,0.36,2.1,d+2,GOLD,Enum.Material.Metal,false)
    end
    for _,zz in ipairs({-13.5,13.5}) do
        block(m,"Parapet de terrasse",base,0,22.5,zz,w+2,2.1,0.36,GOLD,Enum.Material.Metal,false)
    end
    -- Escalier intérieur réel de 14 marches, montant au palier du 2e niveau.
    -- Il longe la façade EST; chaque marche présente une surface porteuse.
    for step=1,14 do
        local z=-9.8+(step-1)*1.46
        local y=0.65+step*0.7
        block(m,"Escalier intérieur — marche "..step,base,5.05,y,z,4.8,0.48,1.55,CREAM,Enum.Material.Cobblestone)
    end
    for _,x in ipairs({2.45,7.55}) do
        block(m,"Main courante de l'escalier",base,x,7.4,0.1,0.26,0.32,20,GOLD,Enum.Material.Metal,false)
    end
    -- Séjour, bibliothèque et petite cuisine au rez-de-chaussée.
    block(m,"Table de séjour",base,-4.5,2.6,-1.5,6,1.0,3.8,WOOD,Enum.Material.WoodPlanks)
    chair(m,base,-8,1.5,-1.5,tint)
    chair(m,base,-1,1.5,-1.5,tint)
    block(m,"Comptoir collectif",base,-6.8,1.9,7.4,7,2.3,2.2,INK,Enum.Material.Wood)
    for n=1,4 do
        block(m,"Collection domestique "..n,base,-9.5+n*1.25,3.2,7.4,0.9,1.4,0.8,if n%2==0 then tint else GOLD,Enum.Material.Fabric,false)
    end
    -- Étude et repos en galerie au deuxième étage.
    block(m,"Bureau panoramique",base,-6.6,12.1,-4.2,6.9,1,3.2,WOOD,Enum.Material.WoodPlanks)
    chair(m,base,-6.5,11.7,-0.9,tint)
    block(m,"Bibliothèque de l'étage",base,-9.5,13.3,6.8,2.2,4,5.5,INK,Enum.Material.Wood)
    for shelf=1,2 do
        block(m,"Livres et archives",base,-9.5,12.8+shelf*1.3,6.8,1.2,0.7,4.0,tint,Enum.Material.Fabric,false)
    end
    block(m,"Couchage d'appoint",base,-1.1,11.4,-6.1,4,1,5.6,Color3.fromRGB(226,216,196),Enum.Material.Fabric)
    -- Toiture végétalisée : décor uniquement, sans accès promis au public.
    for n=1,4 do
        local x=-8+(n-1)*5
        block(m,"Bac vert de toiture",base,x,21.85,6.4,3.8,0.7,4.2,WOOD,Enum.Material.Wood)
        for stem=1,2 do
            globe(m,base,"Plante de toit",x+(stem-1)*1.1,23.0,6.4,1.4,GREEN,Enum.Material.Grass)
        end
    end
    block(m,"Auvent de bienvenue",base,0,9.5,-15.4,11,0.55,5.8,roof,Enum.Material.Slate,false)
    block(m,"Chemin vers la cour",base,0,0.08,-16.3,7,0.2,10,CREAM,Enum.Material.Cobblestone)
    local mailbox=block(m,"Boîte d'information à venir",base,-9.5,2,-16,2.2,3.5,1.0,INK,Enum.Material.Metal)
    mailbox:SetAttribute("KinStubInteractionId",stableId..".mail.future")
    mailbox:SetAttribute("KinStubCapabilityId","future.residential.services")
    mailbox:SetAttribute("KinStubTitle","Services de la maison")
    F.prompt(mailbox,"Consulter","Fonctionnalité à venir")
    F.sign(m,"Numéro de la maison",(base*CFrame.new(0,8.5,-13.2)).Position,math.deg(group.angle),string.format("MAISON %02d",index),10,2.0).CanCollide=false
    lamp(m,base,9,7.8,-14.6,tint,group.id)
    CrystalEverydayV19.frame(m,base,w,d,21.2,"residence")
    NeighborhoodRooflinesV22.make(m,base,w,d,21.2,group.style,groupIndex*4+index)
    SecondaryArchitectureV25.home(m,base,group.style,groupIndex*4+index)
    return m
end

local function plot(m,base,x,z,color)
    block(m,"Jardin partagé",base,x,0.5,z,8,1,5,WOOD,Enum.Material.Wood)
    for n=1,4 do
        local plantColor=if n%2==0 then GREEN else color
        globe(m,base,"Cultures du jardin",x+(n-2.5)*1.65,1.6,z,2.0,plantColor,Enum.Material.Grass)
    end
end
local function plaza(m,base,group,color)
    block(m,"Place collective pavée",base,0,0.03,0,38,0.24,38,CREAM,Enum.Material.Cobblestone)
    for _,offset in ipairs({-19.7,19.7}) do
        block(m,"Liseré de la place",base,offset,0.17,0,0.5,0.3,39,GOLD,Enum.Material.Metal,false)
        block(m,"Liseré de la place",base,0,0.17,offset,39,0.3,0.5,GOLD,Enum.Material.Metal,false)
    end
    block(m,"Kiosque de rencontres",base,0,0.9,0,14,0.6,14,WOOD,Enum.Material.WoodPlanks)
    block(m,"Toit du kiosque",base,0,10.1,0,17,0.7,17,color,Enum.Material.Slate,false)
    for _,x in ipairs({-7,7}) do for _,z in ipairs({-7,7}) do
        block(m,"Pilier du kiosque",base,x,5.3,z,0.8,9.5,0.8,INK,Enum.Material.Wood)
    end end
    block(m,"Table des voisins",base,0,3.2,0,5.8,0.8,4.4,WOOD,Enum.Material.WoodPlanks)
    for _,z in ipairs({-4,4}) do chair(m,base,0,1.5,z,color) end
    for _,x in ipairs({-14,14}) do for _,z in ipairs({-14,14}) do
        lamp(m,base,x,4.5,z,color,group.id)
    end end
    for _,x in ipairs({-15,15}) do
        plot(m,base,x,0,color)
        plant(m,base,x,1.1,10,color,false)
    end
    -- Installation mécanique locale : lumières de la cour ON/OFF.
    local switch=block(m,"Commande des lanternes communes",base,0,2.2,11.8,2.2,3.5,1.8,INK,Enum.Material.Metal)
    switch:SetAttribute("KinResidentialAction","lights")
    switch:SetAttribute("KinResidentialQuarterId",group.id)
    F.prompt(switch,"Allumer / éteindre","Lanternes de quartier")
    -- Tableau de services futurs clairement délimité du mécanisme physique.
    local future=block(m,"Tableau de services de quartier",base,0,3.0,-12.7,2.6,4.8,0.9,INK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",group.id..".services.future")
    future:SetAttribute("KinStubCapabilityId","future.residential.neighborhood")
    future:SetAttribute("KinStubTitle",group.title)
    F.prompt(future,"Consulter","Fonctionnalité à venir")
end
-- Empêche les arbres procéduraux de pousser dans les maisons et leur accès.
function Residential.isReserved(x,z)
    for _,group in ipairs(Groups) do
        local center=Vector3.new(group.center_studs[1],0,group.center_studs[3])
        local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-group.angle,0)
        local localPosition=base:PointToObjectSpace(Vector3.new(x,0,z))
        if math.abs(localPosition.X)<45 and math.abs(localPosition.Z)<45 then return true end
        if math.abs(localPosition.X)<11 and localPosition.Z>=-90 and localPosition.Z<=-35 then return true end
        -- Boulevard piéton depuis la place centrale jusqu'au quartier.
        local radial=Vector3.new(math.cos(group.angle),0,math.sin(group.angle))
        local along=x*radial.X+z*radial.Z
        local across=math.abs(x*radial.Z-z*radial.X)
        if along>=65 and along<=335 and across<22 then return true end
    end
    return false
end

function Residential.make(city)
    local root=F.folder(city,"Quartiers habités — 24 maisons")
    local houses=0
    for k,group in ipairs(Groups) do
        local clr=Color3.fromRGB(group.color[1],group.color[2],group.color[3])
        local center=Vector3.new(group.center_studs[1],0,group.center_studs[3])
        local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-group.angle,0)
        local neighborhood=Instance.new("Model")
        neighborhood.Name=group.title
        neighborhood.Parent=root
        neighborhood:SetAttribute("KinResidentialQuarterId",group.id)
        -- Quatre maisons le long des angles de la cour, façades vers le centre.
        for i,position in ipairs({Vector3.new(-29,0,-29),Vector3.new(29,0,-29),Vector3.new(-29,0,29),Vector3.new(29,0,29)}) do
            local facing=if i<=2 then math.pi else 0
            local orient=base*CFrame.new(position)*CFrame.Angles(0,facing,0)
            home(neighborhood,group,k,i,orient,group.color)
            houses+=1
        end
        plaza(neighborhood,base,group,clr)
        -- Boulevard radiaire CONSTRUIT : connecte le centre de Kin City à la cour.
        local radial=Vector3.new(math.cos(group.angle),0,math.sin(group.angle))
        local boulevardStart=radial*64+Vector3.new(0,0.12,0)
        local boulevardEnd=radial*305+Vector3.new(0,0.12,0)
        local roadCFrame=CFrame.lookAt((boulevardStart+boulevardEnd)/2,boulevardEnd)
        local road=F.part(neighborhood,"Boulevard piéton radial",Vector3.new(10,0.25,(boulevardEnd-boulevardStart).Magnitude),roadCFrame,CREAM,Enum.Material.Cobblestone)
        road:SetAttribute("KinPedestrianBoulevard",group.id)
        for _,distance in ipairs({103,160,217,274}) do
            local point=radial*distance
            local side=Vector3.new(-radial.Z,0,radial.X)
            for _,dir in ipairs({-1,1}) do
                local where=point+side*(dir*11)
                local basis=CFrame.new(where)
                block(neighborhood,"Lanterne de promenade",basis,0,3.3,0,0.6,6.5,0.6,INK,Enum.Material.Metal)
                lamp(neighborhood,basis,0,7.0,0,clr,group.id)
            end
        end
        -- Chemin radiaire de la promenade vers le cœur de l'îlot.
        block(neighborhood,"Accès piéton de quartier",base,0,-0.03,-60,10,0.25,55,CREAM,Enum.Material.Cobblestone)
        for _,xx in ipairs({-6,6}) do
            block(neighborhood,"Bordure végétale",base,xx,0.05,-56,0.7,0.35,40,GREEN,Enum.Material.Grass,false)
        end
        F.sign(neighborhood,"Nom du quartier",(base*CFrame.new(0,6.6,-77)).Position,math.deg(math.pi/2-group.angle),group.title,24,3.2).CanCollide=false
    end
    root:SetAttribute("KinResidentialQuarters",#Groups)
    root:SetAttribute("KinResidentialHomes",houses)
    root:SetAttribute("KinResidentialFloors",houses*2)
    return root
end
return Residential

]])
source(server,"ResidentialResidents","ModuleScript",[[
--!strict
-- Douze habitants R15 supplémentaires, répartis dans les six îlots.
-- Le chargement des avatars est facultatif : la ville reste accessible en cas d'échec.
-- Les conversations sont des stubs. Le mouvement est purement local.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local CitizenProps=require(script.Parent.CitizenPropsV21)
local Presence=require(script.Parent.ViewerPresenceV21)
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Destinations=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local F=require(script.Parent.Factory)
local Residents={}
local roles={"Jardinière", "Résident", "Architecte", "Voisine", "Artisan", "Guide"}
local skin={
    Color3.fromRGB(225,172,128), Color3.fromRGB(124,82,59),
    Color3.fromRGB(186,131,101), Color3.fromRGB(241,193,155),
    Color3.fromRGB(93,63,48), Color3.fromRGB(214,153,112),
}
local clothes={
    Color3.fromRGB(99,160,120), Color3.fromRGB(72,115,148),
    Color3.fromRGB(190,136,107), Color3.fromRGB(132,104,164),
    Color3.fromRGB(169,141,91), Color3.fromRGB(75,151,143),
}
local function newResident(folder,index,quarter)
    local d=Instance.new("HumanoidDescription")
    local color=skin[(index-1)%#skin+1]
    local shirt=clothes[(index-1)%#clothes+1]
    d.HeadColor=color
    d.LeftArmColor=shirt;d.RightArmColor=shirt;d.TorsoColor=shirt
    d.LeftLegColor=Color3.fromRGB(68,77,91)
    d.RightLegColor=Color3.fromRGB(68,77,91)
    d.HeightScale=0.96+(index%3)*0.05
    d.WidthScale=0.92+(index%2)*0.08
    d.DepthScale=0.96
    local ok,model=pcall(function()
        return Players:CreateHumanoidModelFromDescriptionAsync(d,Enum.HumanoidRigType.R15)
    end)
    d:Destroy()
    if not ok or not model then
        warn("Kin City : habitant résident R15 indisponible : ",index,model)
        return nil
    end
    local hum=model:FindFirstChildOfClass("Humanoid")
    local root=model:FindFirstChild("HumanoidRootPart")
    local head=model:FindFirstChild("Head")
    if not hum or not root or not head then model:Destroy();return nil end
    local role=roles[(index-1)%#roles+1]
    model.Name=role.." — "..quarter.title
    model:SetAttribute("KinResidentId",string.format("kin.resident.%02d",index))
    model:SetAttribute("KinResidenceQuarter",quarter.id)
    hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
    hum.WalkSpeed=5+(index%3)
    root.CanCollide=false
    head:SetAttribute("KinStubInteractionId",string.format("kin.resident.%02d.future",index))
    head:SetAttribute("KinStubCapabilityId","future.residential.dialogue")
    head:SetAttribute("KinStubTitle",role.." · "..quarter.title)
    F.prompt(head,"Parler",role)
    model:SetAttribute("KinNPCPhase",index*1.13)
    model:SetAttribute("KinNPCMotion","idle")
    model:SetAttribute("KinNPCActivity","Repos")
    model.Parent=folder
    CitizenProps.attach(model,role,index+10)
    CollectionService:AddTag(model,"KinCityAnimatedNPC")
    pcall(function() root:SetNetworkOwner(nil) end)
    return model,hum
end
-- Les habitants n'errent plus au hasard : ils suivent une petite routine publique.
-- Points contrôlés dans la cour dégagée, sans navigation vers les maisons closes.
-- Les rôles et les activités visibles sont purement narratifs et locaux.
local tasks={"Promenade", "Jardin partagé", "Lecture", "Rencontre", "Observation", "Repos"}
local function activityBadge(model,role)
    local head=model:FindFirstChild("Head")
    if not head then return nil end
    local gui=Instance.new("BillboardGui")
    gui.Name="Routine quotidienne"
    gui.Size=UDim2.fromOffset(176,43)
    gui.StudsOffset=Vector3.new(0,2.8,0)
    gui.AlwaysOnTop=false;gui.MaxDistance=55;gui.Adornee=head;gui.Parent=head
    local text=Instance.new("TextLabel")
    text.Size=UDim2.fromScale(1,1);text.TextWrapped=true
    text.BackgroundColor3=Color3.fromRGB(34,66,65)
    text.BackgroundTransparency=0.24
    text.TextColor3=Color3.fromRGB(245,236,204)
    text.Font=Enum.Font.GothamMedium;text.TextSize=12
    text.Text=role; text.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,7);corner.Parent=text
    return text
end
local function wander(model,hum,world,quarter,index)
    local center=Vector3.new(quarter.center_studs[1],2.8,quarter.center_studs[3])
    local radius=13.3
    local phase=index*1.87
    local role=model.Name
    local badge=activityBadge(model,role)
    model:PivotTo(CFrame.new(center+Vector3.new(math.cos(phase)*radius,0,math.sin(phase)*radius)))
    task.spawn(function()
        local round=0
        while model.Parent and world.Parent and hum.Health>0 do
            if not Presence.near(center,190) then
                model:SetAttribute("KinNPCMotion","idle")
                task.wait(3)
                continue
            end
            round+=1
            phase+=math.pi/3
            local goal=center+Vector3.new(math.cos(phase)*radius,0,math.sin(phase)*radius)
            local clock=game:GetService("Lighting").ClockTime
            local work=if clock<8 then "Ouverture de quartier" elseif clock>=19 then "Promenade du soir" else tasks[((index+round-2)%#tasks)+1]
            model:SetAttribute("KinResidentActivity",work)
            if badge then badge.Text=work.." · "..role end
            model:SetAttribute("KinNPCActivity",work)
            model:SetAttribute("KinNPCMotion","walk")
            hum:MoveTo(goal)
            local finished=false
            local connection=hum.MoveToFinished:Connect(function() finished=true end)
            local deadline=os.clock()+9
            while not finished and os.clock()<deadline and model.Parent and world.Parent and hum.Health>0 do
                task.wait(0.25)
            end
            connection:Disconnect()
            if model.Parent then
                local motion=if work=="Lecture" then "read" elseif work=="Jardin partagé" then "garden" elseif work=="Rencontre" then "greet" elseif work=="Observation" then "observe" else "idle"
                model:SetAttribute("KinNPCMotion",motion)
                -- Pause devant une place ou un jardin : le lieu n'est pas traversé au pas de course.
                local pause=if round%4==0 then 6.0 else 1.8+(index%3)
                task.wait(pause)
            end
        end
    end)
end
function Residents.start(world)
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local folder=F.folder(city,"Habitants R15 des quartiers")
    task.spawn(function()
        for index=1,12 do
            if not world.Parent then return end
            local quarter=Destinations[math.ceil(index/2)]
            if quarter then
                local model,hum=newResident(folder,index,quarter)
                if model and hum then wander(model,hum,world,quarter,index) end
            end
            task.wait(0.55)
        end
    end)
end
return Residents

]])
source(server,"ReusableMeshesV23","ModuleScript",[[
--!strict
-- Hiérarchie v24: MeshPart déjà importé dans ServerStorage > FileMesh par ID > formes natives.
-- Aucune dépendance à un AssetId fictif. Importer un asset n'exige plus de modifier Luau.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Manifest=require(Shared:WaitForChild("MeshManifest"))
local Kit=require(script.Parent.CrystalKit)
local StudioLibrary=require(script.Parent.StudioAssetLibraryV24)
local Reusable={}
local function segment(parent,name,size,cf,color)
    local part=Kit.part(parent,"Part",name,size,cf,color,Enum.Material.Slate)
    part:SetAttribute("KinOptionalDetail",true)
    return part
end
local function nativeArch(parent,name,size,cf,color)
    local model=Instance.new("Model")
    model.Name=name
    model:SetAttribute("KinArtTheme","sarcelle-cristal-v24")
    model.Parent=parent
    local w,h,d=size.X,size.Y,size.Z
    local pillar=math.max(0.32,math.min(w*0.13,d))
    for _,side in ipairs({-1,1}) do
        segment(model,"Pied de l'arche",Vector3.new(pillar,h*0.69,d),cf*CFrame.new(side*(w-pillar)*0.5,-h*0.155,0),color)
        local diagonal=Kit.part(model,"WedgePart","Épaulement de l'arche",Vector3.new(w*0.23,h*0.23,d),
            cf*CFrame.new(side*w*0.26,h*0.245,0)*CFrame.Angles(0,if side==-1 then math.pi else 0,0),color,Enum.Material.Slate)
        diagonal:SetAttribute("KinOptionalDetail",true)
    end
    segment(model,"Claveau",Vector3.new(w*0.45,h*0.14,d),cf*CFrame.new(0,h*0.44,0),Kit.gold)
    return model
end
function Reusable.decorate(parent,name,assetKey,size,cf,color)
    local imported=StudioLibrary.instantiate(parent,name,assetKey,size,cf,color)
    if imported then return imported end
    local id=Manifest[assetKey]
    if type(id)=="number" and id>0 then
        -- SpecialMesh.FileMesh se redimensionne par Scale en unités de mesh natif,
        -- pas en fonction de la taille du Part. Nos OBJ sont centrés et normalisés.
        local p=segment(parent,name,size,cf,color)
        local mesh=Instance.new("SpecialMesh")
        mesh.Name="FileMesh "..assetKey
        mesh.MeshType=Enum.MeshType.FileMesh
        mesh.MeshId="rbxassetid://"..tostring(id)
        mesh.Scale=size
        mesh.Parent=p
        p:SetAttribute("KinImportedMeshKey",assetKey)
        return p
    end
    if assetKey=="opal_chandelier" or assetKey=="opal_spire" or assetKey=="crystal_canopy" then
        return Kit.spire(parent,name,cf*CFrame.new(0,-size.Y*0.5,0),math.min(size.X,size.Z)*0.27,size.Y,
            {accent=color,metal=Kit.deep})
    elseif assetKey=="crystal_rosette" then
        return Kit.rosette(parent,name,cf,math.min(size.X,size.Y)*0.5,color,6)
    elseif assetKey=="opal_arch" then
        return nativeArch(parent,name,size,cf,color)
    elseif assetKey=="opal_lattice" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        for _,side in ipairs({-1,1}) do
            segment(root,"Traverse verticale",Vector3.new(0.15,size.Y,0.12),cf*CFrame.new(side*size.X*0.42,0,0),color)
            segment(root,"Traverse horizontale",Vector3.new(size.X,0.15,0.12),cf*CFrame.new(0,side*size.Y*0.42,0),Kit.gold)
        end
        if Kit.profile~="LITE" then
            for i=-1,1 do
                segment(root,"Maille opaline",Vector3.new(0.1,size.Y*0.8,0.1),cf*CFrame.new(i*size.X*0.22,0,0),Kit.opal)
            end
        end
        return root
    elseif assetKey=="mineral_pediment" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        for _,side in ipairs({-1,1}) do
            local wedge=Kit.part(root,"WedgePart","Versant de fronton",Vector3.new(size.X*0.5,size.Y,size.Z),
                cf*CFrame.new(side*size.X*0.25,0,0)*CFrame.Angles(0,if side==1 then math.pi else 0,0),color,Enum.Material.Slate)
            wedge:SetAttribute("KinOptionalDetail",true)
        end
        segment(root,"Filet de faîtage",Vector3.new(size.X*0.9,0.18,size.Z*1.1),cf*CFrame.new(0,-size.Y*0.44,0),Kit.gold)
        return root
    elseif assetKey=="harbor_crest" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        segment(root,"Pointe d'amarrage",Vector3.new(size.X*0.10,size.Y*0.8,size.Z),cf,color)
        segment(root,"Traverse maritime",Vector3.new(size.X*0.8,size.Y*0.10,size.Z),cf*CFrame.new(0,size.Y*0.25,0),Kit.gold)
        segment(root,"Moule du port",Vector3.new(size.X*0.62,size.Y*0.12,size.Z),cf*CFrame.new(0,-size.Y*0.37,0),color)
        return root
    elseif assetKey=="mineral_planter" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        segment(root,"Corbeille minérale",size*Vector3.new(1,0.55,1),cf*CFrame.new(0,-size.Y*0.19,0),Kit.deep)
        segment(root,"Bordure champagne",Vector3.new(size.X,0.23,size.Z),cf*CFrame.new(0,size.Y*0.18,0),Kit.gold)
        return root
    elseif assetKey=="opal_console" then
        local root=Instance.new("Model")
        root.Name=name;root.Parent=parent
        segment(root,"Fût console",size*Vector3.new(0.7,0.8,0.65),cf*CFrame.new(0,-size.Y*0.1,0),Kit.deep)
        segment(root,"Tablette opaline",Vector3.new(size.X,0.28,size.Z),cf*CFrame.new(0,size.Y*0.39,0),color)
        return root
    end
    return segment(parent,name,size,cf,color)
end
return Reusable

]])
source(server,"RooftopGardens","ModuleScript",[[
--!strict
-- Troisième espace : terrasse sur le toit de l'atrium. Ascenseur étage <-> toit.
-- Aucun nouveau PlaceId; toutes les structures sont des parts natives.
local F=require(script.Parent.Factory)
local Roof={}
local function block(parent,name,origin,size,x,y,z,color,material)
    return F.part(parent,name,size,CFrame.new(origin+Vector3.new(x,y,z)),color,material)
end
local function planters(parent,origin,x,z,seed)
    block(parent,"Bac paysager",origin,Vector3.new(7,2,4),x,39,z,Color3.fromRGB(184,157,117),Enum.Material.Marble)
    for i=1,3 do
        local stem=block(parent,"Tige",origin,Vector3.new(0.45,3.2,0.45),x-2.1+i*1.1,41,z,Color3.fromRGB(75,112,76),Enum.Material.Wood)
        stem.CanCollide=false
        local plant=block(parent,"Feuillage",origin,Vector3.new(2.1,2.8,2.3),x-2.1+i*1.1,43,z,Color3.fromHSV((seed+i)*0.091%1,0.38,0.62),Enum.Material.Grass)
        plant.Shape=Enum.PartType.Ball
        plant.CanCollide=false
    end
end
local function observatory(parent,origin,key,x,z,title,index,color)
    local base=block(parent,"Borne terrasse",origin,Vector3.new(3.4,3.9,2.1),x,40.0,z,Color3.fromRGB(42,59,66),Enum.Material.Metal)
    block(parent,"Écran extérieur",origin,Vector3.new(2.8,2.0,0.2),x,41.1,z-1.2,color,Enum.Material.Neon).CanCollide=false
    base:SetAttribute("KinStubInteractionId",key..".roof.exhibit."..index)
    base:SetAttribute("KinStubCapabilityId","future."..key..".roof")
    base:SetAttribute("KinStubTitle",title)
    F.prompt(base,"Découvrir",title)
end
local function roofLift(parent,origin,key,x,sourceY,destY,label)
    block(parent,"Plateforme terrasse",origin,Vector3.new(7,0.4,6),x,sourceY+0.2,82,Color3.fromRGB(65,108,119),Enum.Material.Metal)
    local cab=block(parent,"Cabine accès toit",origin,Vector3.new(2.6,3.9,1.5),x+5,sourceY+2.3,82,Color3.fromRGB(48,70,85),Enum.Material.Metal)
    local screen=block(parent,"Voyant cabine",origin,Vector3.new(1.9,1.6,0.15),x+5,sourceY+2.6,81.15,Color3.fromRGB(130,222,208),Enum.Material.Neon)
    screen.CanCollide=false
    cab:SetAttribute("KinLiftId",key..".roof."..label)
    cab:SetAttribute("KinLiftPlaceKey",key)
    cab:SetAttribute("KinLiftPosition",origin+Vector3.new(x,destY+3.5,80))
    F.prompt(cab,sourceY>destY and "Redescendre" or "Accéder au toit","Belvédère")
end
function Roof.make(model,key,origin,style)
    local group=F.folder(model,"Toit jardin et belvédère")
    local light=F.hex(style.palette.trim)
    local accent=F.hex(style.palette.accent)
    local stone=F.hex(style.palette.floor)
    local floor=block(group,"Plancher belvédère",origin,Vector3.new(96,1.1,52),0,37.5,76,stone,Enum.Material.Marble)
    -- Bordures sur les quatre faces, à hauteur d'avatar.
    for _,s in ipairs({-1,1}) do
        block(group,"Garde-corps latéral",origin,Vector3.new(0.75,5,52),s*47.8,40.4,76,accent,Enum.Material.Metal)
        block(group,"Garde-corps transversal",origin,Vector3.new(96,5,0.75),0,40.4,76+s*25.6,accent,Enum.Material.Metal)
    end
    block(group,"Promenade végétale",origin,Vector3.new(83,0.13,11),0,38.15,61,Color3.fromRGB(120,154,102),Enum.Material.Grass).CanCollide=false
    for i=1,8 do
        local x=-41+(i-1)*11.6
        planters(group,origin,x,58,i)
        local color= i%2==0 and accent or light
        local spot=block(group,"Borne lumineuse",origin,Vector3.new(1,3.2,1),x,39.6,98,color,Enum.Material.Neon)
        spot.CanCollide=false
    end
    for _,spec in ipairs({{-28,82},{28,82}}) do
        local x,z=spec[1],spec[2]
        block(group,"Banc toit",origin,Vector3.new(9,0.65,2.6),x,39.3,z,Color3.fromRGB(135,97,68),Enum.Material.WoodPlanks)
        for _,side in ipairs({-1,1}) do
            block(group,"Pied banc",origin,Vector3.new(0.55,1,1.9),x+side*3.5,38.7,z,accent,Enum.Material.Metal)
        end
    end
    observatory(group,origin,key,-33,72,"Panorama historique",1,accent)
    observatory(group,origin,key,33,72,"Observatoire de Kin City",2,accent)
    F.sign(group,"Titre du toit",origin+Vector3.new(0,45,98),180,"BELVÉDÈRE · "..string.upper(key),42,3).CanCollide=false
    roofLift(group,origin,key,-6,18,38,"up")
    roofLift(group,origin,key,-6,38,18,"down")
    return group
end
return Roof

]])
source(server,"ScenicCoast","ModuleScript",[[
--!strict
-- Belvédères côtiers accessibles. Une longue-vue déclenche une vraie caméra locale,
-- sans transport du joueur ni service externe.
local F=require(script.Parent.Factory)
local Coast={}
function Coast.make(city)
    local root=F.folder(city,"Observatoires du littoral")
    for i=1,8 do
        local a=i*math.pi/4
        local radial=Vector3.new(math.cos(a),0,math.sin(a))
        local position=radial*467
        local base=CFrame.new(position)*CFrame.Angles(0,-a+math.pi/2,0)
        local m=F.folder(root,"Observatoire côtier "..i)
        local plinth=F.part(m,"Socle d'orientation",Vector3.new(3.2,3.0,3.2),base*CFrame.new(0,1.6,0),Color3.fromRGB(58,80,91),Enum.Material.Metal)
        local scope=F.part(m,"Tube optique",Vector3.new(1.4,1.5,4),base*CFrame.new(0,3.6,-0.5),Color3.fromRGB(189,150,91),Enum.Material.Metal)
        scope.CanCollide=false
        local lens=F.part(m,"Objectif",Vector3.new(1.0,1.0,0.25),base*CFrame.new(0,3.6,-2.56),Color3.fromRGB(102,197,214),Enum.Material.Glass)
        lens.CanCollide=false
        plinth:SetAttribute("KinVistaId","vista.coast."..i)
        plinth:SetAttribute("KinVistaTitle","Panorama de la cité "..i)
        plinth:SetAttribute("KinVistaCameraPosition",position+Vector3.new(0,34,0)+radial*16)
        plinth:SetAttribute("KinVistaLookAt",Vector3.new(0,25,0))
        F.prompt(plinth,"Observer","Panorama de Kin City")
    end
    return root
end
return Coast

]])
source(server,"ScienceExperiments","ModuleScript",[[
--!strict
-- Expériences manipulables : effets déterministes locaux côté serveur.
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RateLimiter=require(script.Parent.RateLimiter)
local Experiments={}
local descriptions={
    optics="La lumière blanche peut être décomposée en différentes couleurs.",
    astronomy="Les orbites décrivent le mouvement des corps autour d'un autre.",
    ecology="La diversité des organismes aide à maintenir les écosystèmes.",
    engineering="Un levier échange distance et force autour d'un point d'appui.",
    water="L'eau en mouvement peut transmettre de l'énergie mécanique.",
    energy="Un circuit fermé permet la circulation du courant électrique.",
    sound="Les sons résultent de vibrations qui se propagent dans un milieu.",
    nature="Les plantes s'adaptent à leur milieu et utilisent l'énergie lumineuse.",
}
local function parentExhibit(part)
    local node=part.Parent
    while node do
        if node:IsA("Model") and type(node:GetAttribute("KinScienceExhibitId"))=="string" then return node end
        node=node.Parent
    end
    return nil
end
function Experiments.start(world,reply)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled or not player then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local exhibitId=host:GetAttribute("KinScienceExhibitId")
        local kind=host:GetAttribute("KinScienceKind")
        if type(exhibitId)~="string" or type(kind)~="string" then return end
        local root=parentExhibit(host)
        if not root or root:GetAttribute("KinScienceExhibitId")~=exhibitId then return end
        local char=player.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then return end
        if (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"science/"..exhibitId,1.5) then return end
        local active=not (root:GetAttribute("KinExperimentActive")==true)
        root:SetAttribute("KinExperimentActive",active)
        local duration=TweenInfo.new(1.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
        for _,p in ipairs(root:GetDescendants()) do
            if p:IsA("BasePart") then
                if p:GetAttribute("KinScienceLight") then
                    TweenService:Create(p,duration,{Transparency=if active then 0.1 else 0.75}):Play()
                    local light=p:FindFirstChildOfClass("PointLight")
                    if light then light.Brightness=if active then 1.7 else 0.1 end
                elseif p:GetAttribute("KinScienceRotor") then
                    local baseline=p:GetAttribute("KinScienceRest")
                    if typeof(baseline)~="CFrame" then baseline=p.CFrame;p:SetAttribute("KinScienceRest",baseline) end
                    TweenService:Create(p,duration,{CFrame=if active then baseline*CFrame.Angles(0,math.rad(30),0) else baseline}):Play()
                end
            end
        end
        prompt.ActionText=if active then "Réinitialiser" else "Expérimenter"
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",
            title=root.Name,message=if active then "Expérience activée" else "Expérience réinitialisée",
            notice=descriptions[kind] or "Expérience interactive locale."
        })
    end)
end
return Experiments

]])
source(server,"SculptedFurnitureV23","ModuleScript",[[
--!strict
-- Kin City v23: mobilier architectural réellement distinct pour les huit institutions.
-- N'ajoute pas de fausses fonctionnalités kOA. Les structures principales restent
-- visuelles (aucune collision); les sièges sont des Seat Roblox utilisables.
local Kit=require(script.Parent.CrystalKit)
local Factory=require(script.Parent.Factory)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Furniture={}
local ROLE={
    city_hall="civic",ekoh_tower="knowledge",library="archive",campus="orbit",
    justice_palace="balance",innovation_lab="mechanism",museum="art",orgo_center="network",
}
local function detail(parent,kind,label,sz,cf,color,material,optional)
    local p=Kit.part(parent,kind,label,sz,cf,color,material or Enum.Material.Slate)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
local function beam(parent,from,to,thick,color)
    local delta=to-from
    if delta.Magnitude<0.01 then return end
    detail(parent,"Part","Traverse en bronze clair",Vector3.new(thick,thick,delta.Magnitude),
        CFrame.lookAt((from+to)*0.5,to),color,Enum.Material.Metal,false)
end
local function case(parent,root,role,accent,seed)
    detail(parent,"Part","Îlot de pierre",Vector3.new(7.4,0.75,3.9),root*CFrame.new(0,0.42,0),Kit.deep,Enum.Material.Slate,false)
    detail(parent,"Part","Surface ouvragée",Vector3.new(7.7,0.25,4.0),root*CFrame.new(0,0.91,0),Kit.gold,Enum.Material.Metal,false)
    for _,side in ipairs({-1,1}) do
        Meshes.decorate(parent,"Colonne facettée","mineral_column",Vector3.new(0.65,3.3,1.1),
            root*CFrame.new(side*3.1,2.15,0),Kit.primary)
    end
    if role=="archive" or role=="knowledge" then
        -- Les livres, archives et savoirs sont des volumes physiques sculptés.
        for i=1,5 do
            local height=2.0+((i+seed)%3)*0.38
            detail(parent,"Part","Codex minéral",Vector3.new(0.8,height,2.1),
                root*CFrame.new((i-3)*1.13,1.02+height/2,0),if i%2==0 then accent else Kit.stone,
                Enum.Material.Slate,true)
        end
        detail(parent,"Part","Ruban de classement",Vector3.new(6.0,0.15,0.3),root*CFrame.new(0,3.55,-1.1),Kit.gold,Enum.Material.Metal,true)
    elseif role=="orbit" then
        detail(parent,"Part","Socle d'orbite",Vector3.new(0.7,4.1,0.7),root*CFrame.new(0,2.9,0),Kit.gold,Enum.Material.Metal,false)
        for i=1,3 do
            local a=i*math.pi*2/3+seed*0.13
            local r=1.45+i*0.28
            local orb=detail(parent,"Part","Corps céleste",Vector3.new(r,r,r),
                root*CFrame.new(math.cos(a)*2.1,4+math.sin(a)*0.72,math.sin(a)*0.75),
                if i==2 then Kit.gold else accent,Enum.Material.Slate,true)
            orb.Shape=Enum.PartType.Ball
        end
    elseif role=="balance" then
        detail(parent,"Part","Axe d'équilibre",Vector3.new(0.5,3.8,0.5),root*CFrame.new(0,2.95,0),Kit.primary,Enum.Material.Metal,false)
        beam(parent,(root*CFrame.new(-2.6,4.55,0)).Position,(root*CFrame.new(2.6,4.55,0)).Position,0.19,Kit.gold)
        for _,side in ipairs({-1,1}) do
            detail(parent,"Part","Plateau des équilibres",Vector3.new(2.3,0.21,1.8),
                root*CFrame.new(side*2.55,2.95,0),accent,Enum.Material.Metal,true)
            beam(parent,(root*CFrame.new(side*2.55,4.45,0)).Position,
                (root*CFrame.new(side*2.55,3.02,0)).Position,0.1,Kit.gold)
        end
    elseif role=="mechanism" then
        for i=1,4 do
            local angle=i*math.pi*0.5
            detail(parent,"WedgePart","Aube de turbine",Vector3.new(1.1,2.4,1.2),
                root*CFrame.new(math.sin(angle)*1.75,2.7,math.cos(angle)*0.9)*CFrame.Angles(0,angle,0),
                if i%2==0 then accent else Kit.gold,Enum.Material.Metal,true)
        end
        detail(parent,"Part","Moyeu central",Vector3.new(1.1,1.1,1.1),root*CFrame.new(0,2.6,0),Kit.opal,Enum.Material.Slate,true)
    elseif role=="art" then
        for i=1,3 do
            detail(parent,"WedgePart","Prisme de composition",Vector3.new(1.0+i*0.25,2.3+i*0.65,1.4),
                root*CFrame.new((i-2)*1.85,2.0+i*0.24,0)*CFrame.Angles(0,i*0.53,(i-2)*0.17),
                if i==2 then accent else Kit.gold,Enum.Material.Slate,true)
        end
    elseif role=="network" then
        for i=1,5 do
            local a=i*2*math.pi/5
            local target=(root*CFrame.new(math.cos(a)*2.5,2.9+math.sin(a)*1.0,math.sin(a)*1.1)).Position
            beam(parent,(root*CFrame.new(0,2.4,0)).Position,target,0.16,Kit.gold)
            local orb=detail(parent,"Part","Nœud de réseau",Vector3.new(0.68,0.68,0.68),CFrame.new(target),accent,Enum.Material.Slate,true)
            orb.Shape=Enum.PartType.Ball
        end
    else
        for i=-2,2 do
            detail(parent,"Part","Quartier miniature",Vector3.new(0.9,1.8+(i+3)%3,1.1),
                root*CFrame.new(i*1.15,1.9+(i+3)%3*0.5,0),if i%2==0 then accent else Kit.medium,Enum.Material.Marble,true)
        end
    end
end
local function bench(parent,root,accent)
    -- Le siège, contrairement aux incrustations, est réellement utilisable.
    local seat=Instance.new("Seat")
    seat.Name="Banquette de lecture et de rencontre"
    seat.Size=Vector3.new(4.2,0.65,2.15)
    seat.CFrame=root*CFrame.new(0,1.55,-3.75)
    seat.Anchored=true
    seat.Material=Enum.Material.Wood
    seat.Color=Kit.primary
    seat.Parent=parent
    detail(parent,"Part","Dossier orné",Vector3.new(4.35,2.05,0.42),
        root*CFrame.new(0,2.48,-4.8),Kit.deep,Enum.Material.Wood,false)
    detail(parent,"Part","Fil opalin de banquette",Vector3.new(4.45,0.13,0.18),
        root*CFrame.new(0,3.33,-4.51),accent,Enum.Material.Slate,true)
end
function Furniture.decorate(parent,placeKey,room,origin,index)
    local role=ROLE[placeKey]
    if not role then return end
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<28 or d<26 then return end
    local rootFolder=Instance.new("Folder")
    rootFolder.Name="Mobilier sculpté v23"
    rootFolder:SetAttribute("KinArtTheme","sarcelle-cristal-v23")
    rootFolder:SetAttribute("KinFurnitureType",role)
    rootFolder.Parent=parent
    local count=if Kit.profile=="LITE" then 1 elseif Kit.profile=="SHOWCASE" then 3 else 2
    for n=1,count do
        local side=if n%2==1 then -1 else 1
        local slot=if n==3 then 1 else 0
        -- Côté de la salle, dans le premier tiers : les sorties et l'axe central restent libres.
        local x=cx+side*(w/2-7.6)
        local z=cz-d/2+9+slot*9
        local root=CFrame.new(origin+Vector3.new(x,0,z))*CFrame.Angles(0,if side==-1 then -math.pi/2 else math.pi/2,0)
        local group=Instance.new("Model")
        group.Name="Composition de mobilier "..n
        group.Parent=rootFolder
        case(group,root,role,Kit.accent(placeKey),index*3+n)
        if index==1 and n==1 then bench(group,root,Kit.accent(placeKey)) end
    end
    return rootFolder
end
return Furniture

]])
source(server,"SecondaryArchitectureV25","ModuleScript",[[
--!strict
-- V25 : grammaire architecturale des quartiers existants.
-- Chaque détail est statique, sans collision, sans lumière dynamique ni script par pièce.
-- Aucun passage, escalier, terminal ou porte n'est déplacé.
local Kit=require(script.Parent.CrystalKit)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Architecture={}

local function decor(parent,name,size,cf,color,material,optional)
    local item=Kit.part(parent,"Part",name,size,cf,color,material or Enum.Material.Slate)
    if optional then item:SetAttribute("KinOptionalDetail",true) end
    item:SetAttribute("KinV25Architecture",true)
    return item
end
local function folder(model,role)
    local previous=model:FindFirstChild("Architecture de quartier v25")
    if previous then previous:Destroy() end
    local root=Instance.new("Folder")
    root.Name="Architecture de quartier v25"
    root:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    root:SetAttribute("KinArchitectureRole",role)
    root.Parent=model
    return root
end
local function mesh(parent,name,key,size,cf,color)
    local result=Meshes.decorate(parent,name,key,size,cf,color)
    if result then result:SetAttribute("KinV25Architecture",true) end
    return result
end
local function upperFrame(root,base,w,d,height)
    -- Périmètre de toiture; les rails sont à l'extérieur du mur et au-dessus du toit.
    for _,side in ipairs({-1,1}) do
        decor(root,"Bande de corniche avant/arrière",Vector3.new(w+0.9,0.3,0.35),
            base*CFrame.new(0,height,side*(d*0.5+0.31)),Kit.gold,Enum.Material.Metal,true)
        decor(root,"Corniche latérale",Vector3.new(0.35,0.3,d),
            base*CFrame.new(side*(w*0.5+0.31),height,0),Kit.primary,Enum.Material.Metal,true)
    end
end
local function facadePanels(root,base,w,front,top,count,accent)
    for index=1,count do
        local x=(index-(count+1)*0.5)*(w*0.27)
        local p=decor(root,"Pilastre et prisme opalin",Vector3.new(0.38,4.2,0.25),
            base*CFrame.new(x,top-2.2,front-0.22),Kit.primary,Enum.Material.Metal,true)
        decor(root,"Incrustation de pilastre",Vector3.new(0.14,2.4,0.1),
            p.CFrame*CFrame.new(0,0,-0.2),accent,Enum.Material.Neon,true)
    end
end
local function crest(root,base,front,top,width,accent,asset)
    -- Toujours au-dessus du linteau d'entrée : aucune obstruction de passage.
    mesh(root,"Emblème du lieu",asset or "crystal_rosette",Vector3.new(width,width,0.65),
        base*CFrame.new(0,top,front),accent)
end

-- Six halles et six maisons communautaires : nef, couronnement, rosace.
function Architecture.hall(model,base,kind,color)
    local market=kind=="market"
    local w=if market then 46 else 38
    local d=if market then 58 else 43
    local root=folder(model,if market then "marché" else "maison communautaire")
    local front=-d*0.5-0.7
    upperFrame(root,base,w,d,17.25)
    facadePanels(root,base,w,front,11.8,if Kit.profile=="LITE" then 2 else 4,color)
    crest(root,base,front-0.40,14.8,if market then 4.5 else 4.1,color,"crystal_rosette")
    if Kit.profile~="LITE" then
        mesh(root,"Fronton de nef","mineral_pediment",Vector3.new(w*0.30,4.4,0.48),
            base*CFrame.new(0,19.5,front+0.4),Kit.primary)
    end
    -- Deux axes opalins sur le toit ; pas de nouvelles PointLight.
    for _,side in ipairs({-1,1}) do
        local x=side*w*0.34
        decor(root,"Contrefort haut",Vector3.new(1.0,1.4,d*0.72),
            base*CFrame.new(x,17.8,0),Kit.deep,Enum.Material.Slate,true)
        if Kit.profile~="LITE" then
            mesh(root,"Épi de toiture", "opal_spire", Vector3.new(2.8,5.1,2.8),
                base*CFrame.new(x,20.5,-d*0.27),if market then Kit.opal else color)
        end
    end
    if Kit.profile=="SHOWCASE" then
        for _,z in ipairs({-d*0.25,0,d*0.25}) do
            decor(root,"Rainure de nef",Vector3.new(w*0.65,0.16,0.32),
                base*CFrame.new(0,17.65,z),Kit.gold,Enum.Material.Metal,true)
        end
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Neuf boutiques de promenade : silhouette d'atelier et enseigne minérale.
function Architecture.boutique(model,base,style,accent)
    local root=folder(model,"boutique-"..tostring(style))
    upperFrame(root,base,17,21,14.0)
    for _,side in ipairs({-1,1}) do
        decor(root,"Fronton oblique",Vector3.new(6.0,0.42,0.55),
            base*CFrame.new(side*4.3,14.9,-10.95)*CFrame.Angles(0,0,side*math.rad(21)),
            Kit.primary,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            mesh(root,"Résille de métier","opal_lattice",Vector3.new(3.7,3.7,0.3),
                base*CFrame.new(side*5.8,8.4,-10.98),accent)
        end
    end
    local peak=if style=="ceramics" then "opal_spire" else "mineral_column"
    mesh(root,"Clé du faîtage",peak,Vector3.new(2.15,3.1,2.15),
        base*CFrame.new(0,15.25,3),accent)
    if Kit.profile=="SHOWCASE" then
        for n=1,3 do
            decor(root,"Lumière du métier",Vector3.new(0.2,0.2,2.3),
                base*CFrame.new(-5+n*2.5,14.52,-9.1),Kit.opal,Enum.Material.Neon,true)
        end
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Huit ateliers de gare : rythme de marquise sans ajouter une deuxième façade.
function Architecture.arcade(model,base,seed,accent)
    local root=folder(model,"atelier de gare")
    upperFrame(root,base,18,18,12.2)
    for _,side in ipairs({-1,1}) do
        decor(root,"Nervure de marquise",Vector3.new(0.46,0.44,6.0),
            base*CFrame.new(side*7.4,12.4,-10.4),Kit.gold,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            mesh(root,"Jeton d'atelier","opal_lattice",Vector3.new(2.2,2.2,0.4),
                base*CFrame.new(side*6.2,8.1,-9.55),accent)
        end
    end
    local count=if Kit.profile=="SHOWCASE" then 5 else 3
    for n=1,count do
        decor(root,"Trame opaline de lanterneau",Vector3.new(0.26,0.14,3.9),
            base*CFrame.new((n-(count+1)/2)*2.2,12.22,-3.0),
            if (n+seed)%2==0 then Kit.opal else Kit.gold,Enum.Material.Metal,true)
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Vingt-quatre maisons : gardent leur accès sur deux niveaux et leurs jardins de toit.
function Architecture.home(model,base,variant,seed)
    local root=folder(model,"maison-"..tostring(variant))
    local accent=if variant=="culture" then Kit.gold elseif variant=="atelier" then Kit.opal else Kit.medium
    -- Bordure de terrasse avant; éviter la végétation sur le toit à l'arrière (Z positif).
    for _,side in ipairs({-1,1}) do
        decor(root,"Fronton résidentiel",Vector3.new(6.0,0.36,0.48),
            base*CFrame.new(side*5.4,23.8,-10.65)*CFrame.Angles(0,0,side*math.rad(18)),
            accent,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            decor(root,"Gemme de lucarne",Vector3.new(1.15,1.15,0.25),
                base*CFrame.new(side*7.7,21.2,-12.2)*CFrame.Angles(0,0,math.rad(45)),
                Kit.opal,Enum.Material.Slate,true)
        end
    end
    if Kit.profile=="SHOWCASE" and seed%2==0 then
        mesh(root,"Petite clef de toit","opal_spire",Vector3.new(1.5,2.4,1.5),
            base*CFrame.new(0,25.4,-10),accent)
    end
    model:SetAttribute("KinV25Facade",true)
    return root
end

-- Quatre ateliers maritimes : couronnement de façade et petit mât non fonctionnel.
function Architecture.marina(model,base,index)
    local root=folder(model,"atelier maritime")
    -- Façade ouverte à Z=+12 : les décorations restent au-dessus de son ouverture.
    for _,side in ipairs({-1,1}) do
        decor(root,"Traverse du port",Vector3.new(7.3,0.45,0.32),
            base*CFrame.new(side*7.0,11.7,12.45),Kit.gold,Enum.Material.Metal,true)
        if Kit.profile~="LITE" then
            mesh(root,"Ancre minérale abstraite","mineral_column",Vector3.new(1.5,3.4,1.5),
                base*CFrame.new(side*9.2,13.8,-8.0),Kit.primary)
        end
    end
    mesh(root,"Emblème de marin","harbor_crest",Vector3.new(4.1,3.8,0.48),
        base*CFrame.new(0,14.2,12.52),Kit.gold)
    mesh(root,"Éclat de vigie","opal_spire",Vector3.new(2.4,3.8,2.4),
        base*CFrame.new(0,14.6,0),if index==1 then Kit.opal else Kit.gold)
    model:SetAttribute("KinV25Facade",true)
    return root
end
return Architecture

]])
source(server,"SecondaryStreets","ModuleScript",[[
--!strict
-- Kin City v13 : six rues de promenade secondaires entre les quartiers et les agoras.
-- Dalles pavées, terrasses, enseignes, bancs et luminaires; marche libre.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Neighborhoods=require(Shared:WaitForChild("ResidentialDestinations"))
local Factory=require(script.Parent.Factory)
local Streets={}
local STONE=Color3.fromRGB(214,201,174)
local BRASS=Color3.fromRGB(222,182,107)
local WOOD=Color3.fromRGB(148,106,73)
local NAVY=Color3.fromRGB(43,71,82)
local function put(parent,name,size,cf,color,material,solid)
    local part=Factory.part(parent,name,size,cf,color,material)
    if solid==false then part.CanCollide=false;part.CanQuery=false;part.CanTouch=false end
    return part
end
local function chair(root,cf)
    local s=Instance.new("Seat")
    s.Name="Banc de la promenade secondaire"
    s.Size=Vector3.new(5,0.7,2.1)
    s.CFrame=cf
    s.Color=WOOD;s.Material=Enum.Material.WoodPlanks;s.Anchored=true;s.Parent=root
    put(root,"Dossier de banc",Vector3.new(5,1.8,0.35),cf*CFrame.new(0,1.1,1),NAVY,Enum.Material.Wood)
end
function Streets.isReserved(x,z)
    for _,q in ipairs(Neighborhoods) do
        local angle=q.angle
        local along=x*math.cos(angle)+z*math.sin(angle)
        local across=math.abs(-x*math.sin(angle)+z*math.cos(angle))
        if along>=376 and along<=421 and across<=15 then return true end
    end
    return false
end
function Streets.make(city)
    local root=Factory.folder(city,"Rues secondaires et terrasses")
    for index,q in ipairs(Neighborhoods) do
        local radial=Vector3.new(math.cos(q.angle),0,math.sin(q.angle))
        local tangent=Vector3.new(-radial.Z,0,radial.X)
        local frame=CFrame.lookAt(radial*399,radial*430)
        local district=Factory.folder(root,"Promenade vers "..q.title)
        local c=Color3.fromRGB(q.color[1],q.color[2],q.color[3])
        put(district,"Avenue bordée",Vector3.new(10,0.23,48),frame*CFrame.new(0,0.13,0),STONE,Enum.Material.Cobblestone)
        for side=-1,1,2 do
            local xx=side*7.3
            put(district,"Bande de jardin",Vector3.new(2.8,0.55,48),frame*CFrame.new(xx,0.28,0),c,Enum.Material.Grass,false)
            for n=1,3 do
                local point=radial*(381+n*10)+tangent*xx
                local post=put(district,"Lanterne de ruelle",Vector3.new(0.55,7,0.55),CFrame.new(point+Vector3.new(0,3.6,0)),NAVY,Enum.Material.Metal)
                local bulb=put(district,"Lueur piétonne",Vector3.new(1.3,1.3,1.3),CFrame.new(point+Vector3.new(0,7.6,0)),BRASS,Enum.Material.Neon,false)
                bulb.Shape=Enum.PartType.Ball
                local light=Instance.new("PointLight")
                light.Range=20;light.Brightness=0.65;light.Parent=bulb
            end
            local seatPos=radial*398+tangent*(side*13)
            chair(district,CFrame.lookAt(seatPos+Vector3.new(0,1.4,0),radial*398))
        end
        Factory.sign(district,"Panneau de quartier",radial*407+Vector3.new(0,8.3,0),math.deg(math.pi/2-q.angle),q.title,21,2.7).CanCollide=false
    end
    root:SetAttribute("KinSecondaryPromenades",#Neighborhoods)
    return root
end
return Streets

]])
source(server,"SkyDirector","ModuleScript",[[
--!strict
-- Éclairage natif sans texture distante ni bande-son externe.
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local SkyDirector={}
local function singleton(parent,name,class)
    local old=parent:FindFirstChild(name)
    if old and old.ClassName==class then return old end
    if old then old:Destroy() end
    local new=Instance.new(class)
    new.Name=name
    new.Parent=parent
    return new
end
function SkyDirector.configure()
    Lighting.Brightness=2.3
    Lighting.ClockTime=13.8
    Lighting.GlobalShadows=true
    Lighting.EnvironmentDiffuseScale=0.72
    Lighting.EnvironmentSpecularScale=0.75
    Lighting.Ambient=Color3.fromRGB(104,116,121)
    Lighting.OutdoorAmbient=Color3.fromRGB(147,160,158)
    local atmosphere=singleton(Lighting,"KinCityAtmosphere","Atmosphere")
    atmosphere.Density=0.26
    atmosphere.Offset=0.18
    atmosphere.Color=Color3.fromRGB(207,233,229)
    atmosphere.Decay=Color3.fromRGB(116,168,164)
    atmosphere.Glare=0.09
    atmosphere.Haze=1.3
    local correction=singleton(Lighting,"KinCityColor","ColorCorrectionEffect")
    correction.Brightness=0.03
    correction.Contrast=0.08
    correction.Saturation=0.06
    correction.TintColor=Color3.fromRGB(242,252,248)
    local bloom=singleton(Lighting,"KinCityBloom","BloomEffect")
    bloom.Intensity=0.12
    bloom.Size=18
    bloom.Threshold=1.7
    local rays=singleton(Lighting,"KinCitySunRays","SunRaysEffect")
    rays.Intensity=0.035
    rays.Spread=0.75
    local terrain=Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        local clouds=singleton(terrain,"KinCityClouds","Clouds")
        clouds.Cover=0.22
        clouds.Density=0.34
        clouds.Color=Color3.fromRGB(243,247,247)
    end
end
return SkyDirector

]])
source(server,"SkyPavilionRuntime","ModuleScript",[[
--!strict
-- V15 · Mécanismes d'observatoire et carnet de visites par joueur.
-- Toutes les opérations ont lieu dans la session Roblox. Aucune identité/économie kOA.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
local COMPLETE_STATIONS=16
local PALETTE_OFF=Color3.fromRGB(79,109,124)

local function notify(remote,player,title,message)
    if player.Parent~=Players then return end
    remote:FireClient(player,{
        kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=message,
        notice="Expérience locale · aucune opération kOA",
    })
end

local function animate(model,duration,turns)
    if not model or not model.Parent then return end
    local start=model:GetPivot()
    local begun=os.clock()
    while model.Parent and model:IsDescendantOf(workspace) do
        local delta=math.clamp((os.clock()-begun)/duration,0,1)
        local smoothed=delta*delta*(3-2*delta)
        model:PivotTo(start*CFrame.Angles(0,smoothed*math.pi*2*turns,0))
        if delta>=1 then break end
        RunService.Heartbeat:Wait()
    end
    if model.Parent then model:PivotTo(start) end
end

local function valid(prompt,host,player,world)
    if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) or not prompt.Enabled then return false end
    if player:GetAttribute("KinZone")~=host:GetAttribute("KinSkyPlaceKey") then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return hum~=nil and hum.Health>0 and root~=nil and (root.Position-host.Position).Magnitude<=prompt.MaxActivationDistance+3
end

function Runtime.start(world,remote)
    local machines={}
    local lamps={}
    local running={}
    local modes={}
    local discovered={}
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("Model") then
            local id=obj:GetAttribute("KinSkyMechanismId")
            if type(id)=="string" then machines[id]=obj end
        elseif obj:IsA("BasePart") then
            local key=obj:GetAttribute("KinSkyLampPlace")
            if type(key)=="string" then
                lamps[key]=lamps[key] or {}
                table.insert(lamps[key],{part=obj,color=obj.Color})
                modes[key]=true
            end
        end
    end
    Players.PlayerRemoving:Connect(function(player) discovered[player]=nil end)
    Prompts.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local action=host:GetAttribute("KinSkyAction")
        if action~="animate" and action~="lighting" then return end
        if not valid(prompt,host,player,world) then return end
        local key=host:GetAttribute("KinSkyPlaceKey")
        if type(key)~="string" then return end
        if action=="lighting" then
            if not RateLimiter.allowed(player,"skylight/"..key,0.8) then return end
            local on=not modes[key]
            modes[key]=on
            for _,lamp in ipairs(lamps[key] or {}) do
                if lamp.part.Parent then
                    lamp.part.Color=if on then lamp.color else PALETTE_OFF
                    lamp.part.Material=if on then Enum.Material.Neon else Enum.Material.Metal
                    local light=lamp.part:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=on end
                end
            end
            notify(remote,player,"Observatoire · "..key,if on then "Les projecteurs de la verrière sont activés." else "Les projecteurs sont en mode doux.")
            return
        end
        local id=host:GetAttribute("KinSkyMachineId")
        if type(id)~="string" then return end
        if not RateLimiter.allowed(player,"sky/"..id,1) then return end
        local model=machines[id]
        if not model or not model.Parent then return end
        if running[id] then
            notify(remote,player,"Observatoire","Une démonstration est déjà en cours.")
            return
        end
        running[id]=true
        local title=host:GetAttribute("KinSkyStationTitle") or "Station expérimentale"
        local byPlayer=discovered[player]
        if not byPlayer then byPlayer={};discovered[player]=byPlayer end
        if not byPlayer[id] then byPlayer[id]=true end
        local count=0
        for _ in pairs(byPlayer) do count+=1 end
        remote:FireClient(player,{
            kind="sky.discovery.v1",place_key=key,station_id=id,
            title=title,visited=count,total=COMPLETE_STATIONS,
        })
        notify(remote,player,title,"Observe le mécanisme en mouvement. Découverte "..tostring(count).." / "..tostring(COMPLETE_STATIONS)..".")
        task.spawn(function()
            local ok,err=pcall(animate,model,5,2)
            if not ok then warn("Kin City sky apparatus",id,err) end
            running[id]=nil
        end)
    end)
end
return Runtime

]])
source(server,"SkyPavilions","ModuleScript",[[
--!strict
-- V15 · Quatrième niveau visitable pour chacune des huit institutions.
-- Observatoires scénographiques et expériences physiques locales; aucun asset externe.
-- Coordonnées relatives à l'origine de chaque Place : le toit existant est à y=38.
local F=require(script.Parent.Factory)
local Sky={}

local INK=Color3.fromRGB(32,55,72)
local GOLD=Color3.fromRGB(225,190,120)
local PALE=Color3.fromRGB(238,232,210)
local GLASS=Color3.fromRGB(138,215,228)
local GREEN=Color3.fromRGB(87,160,129)

local TOPICS={
    city_hall={"LE FORUM DES CITÉS","Maquette des quartiers","Architecture des places",Color3.fromRGB(238,179,109),"city"},
    ekoh_tower={"LA CONSTELLATION DES SAVOIRS","Réseaux de connaissances","Cartographie des expertises",Color3.fromRGB(92,223,197),"network"},
    library={"LE JARDIN DES LIVRES","Livres en mouvement","Archives du futur",Color3.fromRGB(150,194,233),"books"},
    campus={"LE LABORATOIRE DU CIEL","Orbits et gravitation","Système des découvertes",Color3.fromRGB(187,162,237),"orbits"},
    justice_palace={"L'ATELIER DES ÉQUILIBRES","Mécanique des balances","Symétrie et harmonie",Color3.fromRGB(229,196,138),"balance"},
    innovation_lab={"LA HALLE DES INVENTIONS","Turbine expérimentale","Engrenages créatifs",Color3.fromRGB(124,222,225),"turbine"},
    museum={"LE MUSÉE AÉRIEN","Mouvement des formes","Sculpture chromatique",Color3.fromRGB(239,156,159),"art"},
    orgo_center={"L'OBSERVATOIRE DES RÉSEAUX","Topologie des services","Circuit des connexions",Color3.fromRGB(139,191,237),"network"},
}

local function block(parent,name,base,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then
        p.CanCollide=false
        p.CanTouch=false
        p.CanQuery=false
    end
    return p
end

local function sphere(parent,name,base,x,y,z,r,color,material)
    local p=block(parent,name,base,x,y,z,r,r,r,color,material,false)
    p.Shape=Enum.PartType.Ball
    return p
end

local function seat(parent,base,x,z)
    local s=Instance.new("Seat")
    s.Name="Assise de l'observatoire"
    s.Size=Vector3.new(3,0.65,2.6)
    s.CFrame=base*CFrame.new(x,57.2,z)
    s.Anchored=true
    s.Color=INK
    s.Material=Enum.Material.Fabric
    s.Parent=parent
    block(parent,"Dossier",base,x,58.2,z+1.0,3,2,0.45,GOLD,Enum.Material.Metal)
end

local function apparatus(parent,base,x,z,kind,color,variant,id)
    -- Seules les pièces de ce Model pivotent; le socle et l'utilisateur ne bougent pas.
    block(parent,"Socle de démonstration",base,x,57.2,z,11,2.0,11,PALE,Enum.Material.Marble)
    local model=Instance.new("Model")
    model.Name="Mécanisme · "..kind.." · "..variant
    model:SetAttribute("KinSkyMechanismId",id)
    model.Parent=parent
    local pivot=block(model,"Pivot invisible",base,x,63.0,z,0.2,0.2,0.2,INK,Enum.Material.Metal,false)
    pivot.Transparency=1
    model.PrimaryPart=pivot
    if kind=="city" then
        for i=1,7 do
            local a=i*math.pi*2/7
            local h=3+(i%4)*1.6
            block(model,"Miniature urbaine",base,x+math.cos(a)*3.4,61+h/2,z+math.sin(a)*3.4,1.65,h,1.65,if i%2==0 then color else GOLD,Enum.Material.Marble,false)
        end
        block(model,"Place centrale miniature",base,x,61,z,3.5,0.3,3.5,INK,Enum.Material.Metal,false)
    elseif kind=="books" then
        for i=1,9 do
            local a=i*math.pi*2/9
            local sy=2.1+(i%3)*0.55
            local p=block(model,"Volume suspendu",base,x+math.cos(a)*3.5,63+(i%3)*1.6,z+math.sin(a)*3.5,1.9,sy,0.6,if i%2==0 then color else GOLD,Enum.Material.Fabric,false)
            p.CFrame=p.CFrame*CFrame.Angles(0,a,math.rad(18))
        end
        sphere(model,"Sphère des archives",base,x,64,z,2.5,PALE,Enum.Material.Glass)
    elseif kind=="balance" then
        block(model,"Axe d'équilibre",base,x,63.4,z,0.9,6.8,0.9,GOLD,Enum.Material.Metal,false)
        block(model,"Traverse suspendue",base,x,66.2,z,9.3,0.45,0.5,GOLD,Enum.Material.Metal,false)
        for _,dir in ipairs({-1,1}) do
            block(model,"Chaîne",base,x+dir*3.6,64.4,z,0.18,3.2,0.18,GOLD,Enum.Material.Metal,false)
            local tray=block(model,"Plateau de balance",base,x+dir*3.6,62.6,z,3.1,0.5,3.1,color,Enum.Material.Marble,false)
            tray.Shape=Enum.PartType.Cylinder
            tray.CFrame=tray.CFrame*CFrame.Angles(0,0,math.pi/2)
        end
    elseif kind=="turbine" then
        block(model,"Axe turbine",base,x,62.4,z,0.8,6.2,0.8,GOLD,Enum.Material.Metal,false)
        for i=1,8 do
            local a=i*math.pi/4
            local vane=block(model,"Pale motrice",base,x+math.cos(a)*2.5,63,z+math.sin(a)*2.5,4.5,0.32,1.2,color,Enum.Material.Metal,false)
            vane.CFrame=vane.CFrame*CFrame.Angles(0,-a,math.rad(23))
        end
    elseif kind=="art" then
        for i=1,11 do
            local a=i*math.pi*2/11
            local p=sphere(model,"Œuvre colorée",base,x+math.cos(a)*3.5,62+(i%5)*0.95,z+math.sin(a)*3.5,1.5,Color3.fromHSV(((i*0.091)+(variant*0.15))%1,0.55,0.94),Enum.Material.Glass)
            p.Transparency=0.15
        end
    else -- orbits / network
        sphere(model,"Noyau lumineux",base,x,64,z,3,if kind=="network" then color else GOLD,Enum.Material.Neon)
        for i=1,8 do
            local a=i*math.pi/4
            local r=if kind=="orbits" then 4 else 3.5
            local yy=63+(i%3-1)*1.35
            sphere(model,"Satellite",base,x+math.cos(a)*r,yy,z+math.sin(a)*r,1.1,if i%2==0 then color else PALE,Enum.Material.Glass)
            if kind=="network" then
                local ray=block(model,"Liaison",base,x+math.cos(a)*1.9,(yy+64)/2,z+math.sin(a)*1.9,0.16,0.16,3.8,GOLD,Enum.Material.Neon,false)
                ray.CFrame=CFrame.lookAt(ray.Position,base.Position+Vector3.new(x+math.cos(a)*r,yy,z+math.sin(a)*r))*CFrame.Angles(math.pi/2,0,0)
            end
        end
    end
    return model
end

local function lamp(parent,base,x,z,key,index,color)
    local housing=block(parent,"Balise lumière",base,x,58.3,z,1.2,4.2,1.2,INK,Enum.Material.Metal)
    local bulb=sphere(parent,"Projecteur",base,x,60.6,z,1.7,color,Enum.Material.Neon)
    bulb:SetAttribute("KinSkyLampPlace",key)
    bulb:SetAttribute("KinSkyLampIndex",index)
    local light=Instance.new("PointLight")
    light.Brightness=1.1
    light.Range=22
    light.Shadows=false
    light.Parent=bulb
    return housing
end

local function lift(parent,base,key,sourceY,destY,name)
    block(parent,"Plateforme élévateur "..name,base,12,sourceY+0.25,82,6,0.5,6,GOLD,Enum.Material.Metal)
    local control=block(parent,"Console élévateur "..name,base,16.7,sourceY+2,82,2.6,4,1.5,INK,Enum.Material.Metal)
    block(parent,"Voyant ascenseur",base,16.7,sourceY+2.5,81.15,1.8,1.6,0.15,GLASS,Enum.Material.Neon,false)
    control:SetAttribute("KinLiftId",key..".sky."..name)
    control:SetAttribute("KinLiftPlaceKey",key)
    control:SetAttribute("KinLiftPosition",base.Position+Vector3.new(12,destY+3.4,79.5))
    F.prompt(control,if destY>sourceY then "Monter au pavillon" else "Revenir au toit","Ascenseur du ciel")
end

function Sky.make(interior,key,origin,style)
    local topic=TOPICS[key]
    if not topic then return nil end
    local section=F.folder(interior,"Quatrième niveau · "..topic[1])
    section:SetAttribute("KinSkyPlaceKey",key)
    section:SetAttribute("KinSkyLevel",4)
    local base=CFrame.new(origin)
    local color=topic[4]
    local trim=F.hex(style.palette.trim)
    -- Quatrième niveau construit au-dessus du toit-jardin existant, sans remplacer ses installations.
    block(section,"Plateforme aérienne",base,0,55.55,76,74,1.1,44,PALE,Enum.Material.Marble)
    block(section,"Promenade centrale",base,0,56.17,82,15,0.10,30,color,Enum.Material.SmoothPlastic,false).Transparency=0.48
    for _,x in ipairs({-34,34}) do
        for _,z in ipairs({57,95}) do
            block(section,"Colonne porteuse",base,x,46.5,z,1.6,18.5,1.6,trim,Enum.Material.Metal)
        end
        block(section,"Garde-corps aérien",base,x+(if x<0 then -3 else 3),58.8,76,0.6,5,44,INK,Enum.Material.Metal)
    end
    for _,z in ipairs({54,98}) do
        block(section,"Garde-corps transversal",base,0,58.8,z,75,5,0.6,INK,Enum.Material.Metal)
    end
    -- Structure de verrière semi-ouverte : panneaux translucides sans collision.
    for _,x in ipairs({-33,-16,0,16,33}) do
        block(section,"Arceau de serre",base,x,68.5,76,0.65,3,45,GOLD,Enum.Material.Metal,false)
    end
    for _,z in ipairs({58,70,82,94}) do
        local glass=block(section,"Panneau solaire translucide",base,0,70.25,z,72,0.35,8.8,GLASS,Enum.Material.Glass,false)
        glass.Transparency=0.64
    end
    F.sign(section,"Titre de la serre haute",origin+Vector3.new(0,64,96.7),180,topic[1],47,3.5).CanCollide=false
    for i,side in ipairs({-1,1}) do
        local x=side*23
        local id=key..".sky.station."..string.format("%02d",i)
        apparatus(section,base,x,67,topic[5],color,i,id)
        F.sign(section,"Station "..i,origin+Vector3.new(x,59.6,73.2),180,topic[1+i],17,2.5).CanCollide=false
        local console=block(section,"Console de démonstration",base,x,58.15,78,2.5,4.1,2,INK,Enum.Material.Metal)
        block(section,"Écran console",base,x,58.8,76.85,2,2.5,0.2,color,Enum.Material.Neon,false)
        console:SetAttribute("KinSkyAction","animate")
        console:SetAttribute("KinSkyMachineId",id)
        console:SetAttribute("KinSkyPlaceKey",key)
        console:SetAttribute("KinSkyStationTitle",topic[1+i])
        F.prompt(console,"Démontrer",topic[1+i])
        seat(section,base,x,91)
        lamp(section,base,x+side*10,92,key,i,color)
    end
    lift(section,base,key,38,56,"roof_to_sky")
    lift(section,base,key,56,38,"sky_to_roof")
    local lighting=block(section,"Console d'ambiance",base,-1,58.1,91,3.3,4,2.4,INK,Enum.Material.Metal)
    block(section,"Voyant d'ambiance",base,-1,59,89.7,2.3,2,0.2,color,Enum.Material.Neon,false)
    lighting:SetAttribute("KinSkyAction","lighting")
    lighting:SetAttribute("KinSkyPlaceKey",key)
    F.prompt(lighting,"Changer la lumière","Ambiance du pavillon")
    -- Borne réservée à une future capacité, distincte des vraies expériences locales.
    local future=block(section,"Terminal de la future exposition",base,5,58.2,91,3.3,4.2,2.2,INK,Enum.Material.Metal)
    block(section,"Écran du futur",base,5,58.8,89.8,2.4,2.4,0.2,GLASS,Enum.Material.Neon,false)
    future:SetAttribute("KinStubInteractionId",key..".sky.future.01")
    future:SetAttribute("KinStubCapabilityId","future."..key..".sky")
    future:SetAttribute("KinStubTitle",topic[1])
    F.prompt(future,"Consulter","Futures expositions")
    section:SetAttribute("KinSkyStations",2)
    return section
end
return Sky

]])
source(server,"Soundscape","ModuleScript",[=[
--!strict
-- Soundscape est optionnel : les WAV sont livrés et doivent être importés
-- par l'auteur dans Roblox. Les sons vides n'entravent jamais le chargement.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Config=require(Shared:WaitForChild("AudioManifest"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Residential=require(Shared:WaitForChild("ResidentialDestinations"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local F=require(script.Parent.Factory)
local Audio={}
local function attach(parent,name,id,volume,radius,looped)
    if type(id)~="number" or id<=0 then return end
    local s=Instance.new("Sound")
    s.Name=name
    s.SoundId="rbxassetid://"..tostring(id)
    s.Volume=volume
    s.RollOffMode=Enum.RollOffMode.Inverse
    s.RollOffMaxDistance=radius
    s.RollOffMinDistance=8
    s.Looped=looped
    s.Parent=parent
    s:Play()
    return s
end
function Audio.start(world)
    if not Config.enabled then return end
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local stations=F.folder(city,"Stations sonores")
    local function emitter(title,xyz,soundId,volume,maxDist)
        local p=F.part(stations,title,Vector3.new(0.6,0.6,0.6),CFrame.new(xyz),Color3.new(1,1,1),Enum.Material.SmoothPlastic)
        p.Transparency=1;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
        attach(p,title,soundId,volume,maxDist,true)
    end
    emitter("Vent dans les jardins",Vector3.new(0,8,175),Config.botanical_sound_id or Config.wind_sound_id,0.24,220)
    emitter("Fontaines de la place",Vector3.new(0,4,0),Config.water_sound_id,0.25,95)
    emitter("Promenade du musée",Vector3.new(-202,6,-180),Config.chimes_sound_id,0.12,75)
    emitter("Ambiance des quais",Vector3.new(35,5,420),Config.harbor_sound_id,0.12,90)
    -- Ambiance localisée : cinq pistes originales en plus du trio historique.
    -- Aucune piste n'est obligatoire; les IDs restent nuls jusqu'à l'import Roblox.
    local tones={
        city_hall=Config.civic_sound_id,
        ekoh_tower=Config.chimes_sound_id,
        library=Config.archives_sound_id,
        campus=Config.botanical_sound_id,
        justice_palace=Config.civic_sound_id,
        innovation_lab=Config.laboratory_sound_id,
        museum=Config.chimes_sound_id,
        orgo_center=Config.laboratory_sound_id,
    }
    local placesByBuilding={}
    for _,b in ipairs(Buildings) do placesByBuilding[b.building_id]=b.interior_place_key end
    for i,building in ipairs(Plan.structures) do
        local xyz=building.center_studs
        if xyz then
            emitter("Ambiance · "..building.building_id,
                Vector3.new(xyz[1],6,xyz[3]),tones[placesByBuilding[building.building_id]] or Config.chimes_sound_id,0.08,62)
        end
    end
    for i,quarter in ipairs(Residential) do
        local xyz=quarter.center_studs
        if xyz then
            emitter("Jardin habité "..i,Vector3.new(xyz[1],5,xyz[3]),Config.wind_sound_id,0.09,65)
        end
    end
end
return Audio

]=])
source(server,"Spatial","ModuleScript",[[
--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("KinCityShared")
local WorldPlan = require(Shared:WaitForChild("WorldPlan"))
local PlaceRouting = require(Shared:WaitForChild("PlaceRouting"))
local RuntimeConfig = require(Shared:WaitForChild("RuntimeConfig"))
local RunService = game:GetService("RunService")
local InteriorOrigins = require(Shared:WaitForChild("InteriorOrigins"))

local Spatial = {}
local byPlace = {}
for index, p in ipairs(WorldPlan.places) do
    byPlace[p.place_key] = p
end

function Spatial.mode()
    return RuntimeConfig.mode
end

function Spatial.currentPlace()
    if RuntimeConfig.mode == "LOCAL_UNIVERSE" then return "city" end
    -- Les aperçus sont des Places indépendantes, pas des poches à 3 km dans la ville.
    if RuntimeConfig.mode == "SPLIT_PREVIEW" then
        local key = RuntimeConfig.target_place_key
        assert(type(key)=="string" and byPlace[key],"Cible d'aperçu inconnue")
        return key
    end
    -- En publication, le PlaceId Roblox fait autorité : un script installé dans
    -- la mauvaise Place ne doit JAMAIS instancier silencieusement un autre lieu.
    for key, id in pairs(PlaceRouting) do
        if id == game.PlaceId and id ~= nil then
            assert(RuntimeConfig.target_place_key==nil or RuntimeConfig.target_place_key==key,
                "Installateur appliqué à la mauvaise Place: "..tostring(key))
            return key
        end
    end
    -- Une Place neuve non publiée peut être prévisualisée depuis Studio uniquement.
    if RunService:IsStudio() and game.PlaceId==0 then
        local key=RuntimeConfig.target_place_key
        assert(type(key)=="string" and byPlace[key],"Cible MULTI_PLACE absente de Studio")
        return key
    end
    error("PlaceId courant absent du registre Kin City: " .. tostring(game.PlaceId))
end

function Spatial.place(key)
    return byPlace[key]
end

function Spatial.origin(key)
    if RuntimeConfig.mode ~= "LOCAL_UNIVERSE" or key == "city" then return Vector3.zero end
    -- Origines stables par identifiant : insensibles à l'ordre du catalogue.
    local coordinate=InteriorOrigins[key]
    assert(coordinate,"Origine intérieure absente: "..tostring(key))
    return Vector3.new(coordinate[1],coordinate[2],coordinate[3])
end

function Spatial.position(key, xyz)
    return Spatial.origin(key) + Vector3.new(xyz[1], xyz[2], xyz[3])
end

function Spatial.anchor(key, id)
    local p = byPlace[key]
    if not p then return nil end
    for _, a in ipairs(p.anchors) do
        if a.anchor_id == id then return a end
    end
    return nil
end

function Spatial.anchorCFrame(key, id)
    local anchor = Spatial.anchor(key, id)
    if not anchor then return nil end
    return CFrame.new(Spatial.position(key, anchor.position_studs)) * CFrame.Angles(0, math.rad(anchor.yaw_degrees or 0), 0)
end

function Spatial.placeId(key)
    return PlaceRouting[key]
end

function Spatial.styleForPlace(key)
    for _, door in ipairs(WorldPlan.doors) do
        if door.destination_place_key == key and door.source_place_key == "city" then
            for _, structure in ipairs(WorldPlan.structures) do
                if structure.building_id == door.building_id then
                    return WorldPlan.styles[structure.style_id]
                end
            end
        end
    end
    return WorldPlan.styles.civic_stone
end

return Spatial

]])
source(server,"SpecializedRooms","ModuleScript",[[
--!strict
-- Espaces thématiques dans les grands atriums : réserves, ateliers, documentation.
-- Les activités en stub possèdent leurs futurs IDs ; les sièges sont utilisables.
local F=require(script.Parent.Factory)
local Specialized={}
local INK=Color3.fromRGB(37,63,76)
local GOLD=Color3.fromRGB(189,148,90)
local WOOD=Color3.fromRGB(130,91,64)
local STONE=Color3.fromRGB(220,208,186)
local topics={
    library={"Atelier de reliure","Bibliothèque des archives",Color3.fromRGB(131,175,200)},
    campus={"Station des sciences","Atelier des mathématiques",Color3.fromRGB(192,163,219)},
    justice_palace={"Salle de médiation","Archives juridiques",Color3.fromRGB(206,172,122)},
    city_hall={"Forum des citoyens","Maquette des quartiers",Color3.fromRGB(222,181,111)},
    ekoh_tower={"Cartographie des connaissances","Galerie des méthodes",Color3.fromRGB(124,217,205)},
    innovation_lab={"Atelier de prototypes","Station d'énergie",Color3.fromRGB(110,206,212)},
    museum={"Conservation des œuvres","Atelier des artistes",Color3.fromRGB(231,162,153)},
    orgo_center={"Atelier de coordination","Réseau des opérations",Color3.fromRGB(140,186,220)},
}
local function block(parent,name,base,x,y,z,size,color,material,solid)
    local p=F.part(parent,name,size,base*CFrame.new(x,y,z),color,material)
    if solid==false then p.CanCollide=false end
    return p
end
local function seat(parent,base,x,z)
    local v=Instance.new("Seat")
    v.Name="Siège d'apprentissage"
    v.Anchored=true
    v.Size=Vector3.new(3,0.7,3)
    v.CFrame=base*CFrame.new(x,1.5,z)
    v.Color=INK
    v.Material=Enum.Material.Fabric
    v.Parent=parent
    block(parent,"Dossier",base,x,2.7,z+1.2,Vector3.new(3,2.2,0.5),GOLD,Enum.Material.Metal,true)
end
local function furnish(parent,origin,x,z,section,key,index,accent)
    local base=CFrame.new(origin+Vector3.new(x,0,z))
    local m=Instance.new("Model")
    m.Name=section
    m.Parent=parent
    block(m,"Tapis d'étude",base,0,0.1,0,Vector3.new(16,0.18,15),STONE,Enum.Material.Fabric,false)
    for i=1,3 do
        local bx=(i-2)*4.5
        block(m,"Table d'atelier",base,bx,2.65,1.4,Vector3.new(3.9,0.55,4.2),WOOD,Enum.Material.WoodPlanks,true)
        block(m,"Socle d'atelier",base,bx,1.2,1.4,Vector3.new(0.6,2.4,2.8),INK,Enum.Material.Metal,true)
        block(m,"Échantillon à explorer",base,bx,3.35,1.4,Vector3.new(1.5,1.3,1.5),accent,Enum.Material.Glass,false)
        seat(m,base,bx,-3.3)
    end
    for _,cx in ipairs({-7,7}) do
        block(m,"Rayonnage latéral",base,cx,5.5,5.0,Vector3.new(1.4,10,3.2),WOOD,Enum.Material.WoodPlanks,true)
        for yy=2,8,2 do
            block(m,"Plaque de collection",base,cx,yy,2.9,Vector3.new(1.1,1.2,0.16),accent,Enum.Material.Metal,false)
        end
    end
    local kiosk=block(m,"Terminal documentaire",base,0,2.5,6.8,Vector3.new(3.4,4.6,1.7),INK,Enum.Material.Metal,true)
    block(m,"Écran documentaire",base,0,3.2,5.8,Vector3.new(2.8,2.4,0.16),accent,Enum.Material.Neon,false)
    kiosk:SetAttribute("KinStubInteractionId",string.format("atrium.%s.%02d",key,index))
    kiosk:SetAttribute("KinStubCapabilityId","future."..key..".specialization")
    kiosk:SetAttribute("KinStubTitle",section)
    F.prompt(kiosk,"Découvrir",section)
    return m
end
function Specialized.make(model,key,origin)
    local topic=topics[key]
    if not topic then return nil end
    local section=F.folder(model,"Espaces spécialisés de l'atrium")
    -- Les collections existantes occupent le fond à z=68 ; ces niches sont latérales.
    furnish(section,origin,-23,86,topic[1],key,1,topic[3])
    furnish(section,origin,23,86,topic[2],key,2,topic[3])
    return section
end
return Specialized

]])
source(server,"StationArcades","ModuleScript",[[
--!strict
-- V14 · 8 boutiques-ateliers au flanc de la gare des Connexions.
-- Bâtiments en géométrie native, ouverts physiquement, sans transactions fictives.
local RS=game:GetService("ReplicatedStorage")
local Registry=require(RS:WaitForChild("KinCityShared"):WaitForChild("UrbanV14Destinations"))
local F=require(script.Parent.Factory)
local CrystalEverydayV19=require(script.Parent.CrystalEverydayV19)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local Arcade={}
local P={limestone=Color3.fromRGB(229,216,187),wood=Color3.fromRGB(152,105,70),ink=Color3.fromRGB(30,104,100),glass=Color3.fromRGB(197,244,240),gold=Color3.fromRGB(231,194,124)}
local function part(parent,name,base,x,y,z,w,h,d,color,material,solid)
    local p=F.part(parent,name,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function seat(parent,base,x,z)
    local s=Instance.new("Seat")
    s.Name="Siège de l'atelier";s.Size=Vector3.new(2.2,0.7,2.2)
    s.CFrame=base*CFrame.new(x,1.5,z);s.Anchored=true
    s.Material=Enum.Material.Wood;s.Color=P.wood;s.Parent=parent
    part(parent,"Dossier du siège",base,x,2.6,z+1,2.4,2,0.35,P.ink,Enum.Material.Wood)
end
local function shelf(parent,base,x,z,tint,seed)
    part(parent,"Bibliothèque de présentation",base,x,3.4,z,4.3,5.1,1.4,P.wood,Enum.Material.Wood)
    for row=1,3 do
        part(parent,"Tablette",base,x,1.65+row*1.1,z-0.9,4.5,0.20,2,P.gold,Enum.Material.WoodPlanks,false)
        for n=1,4 do
            local color=if (n+row+seed)%2==0 then tint else P.gold
            local item=part(parent,"Collection d'atelier",base,x-1.6+(n-1)*1.05,2.0+(row-1)*1.15,z-1.08,0.78,0.85,0.65,color,Enum.Material.Fabric,false)
            if (n+row+seed)%3==0 then item.Shape=Enum.PartType.Ball end
        end
    end
end
local function plant(parent,base,x,z)
    part(parent,"Jardinière",base,x,1,z,2.3,1.5,2.3,P.wood,Enum.Material.Wood)
    for i=1,4 do
        local bud=part(parent,"Feuillage",base,x+(i-2.5)*0.48,2.7,z,1,2.1,1.0,Color3.fromRGB(75+i*12,154,97),Enum.Material.Grass,false)
        bud.Shape=Enum.PartType.Ball
    end
end
local function display(parent,base,data,tint)
    local model=Instance.new("Model")
    model.Name="Exposition animable · "..data.kind
    model:SetAttribute("KinArcadeDisplayId",data.id)
    model.Parent=parent
    local pivot=part(model,"Pivot mobile",base,0,4.8,3.1,0.3,0.3,0.3,P.gold,Enum.Material.Metal,false)
    pivot.Transparency=1;model.PrimaryPart=pivot
    local shaft=part(model,"Axe",base,0,4.8,3.1,0.6,5.8,0.6,P.gold,Enum.Material.Metal,false)
    for i=1,5 do
        local theta=i*2*math.pi/5
        local p=part(model,"Objet cinétique",base,math.cos(theta)*2.3,4.8,3.1+math.sin(theta)*2.3,1.3,1.3,1.3,if i%2==0 then tint else P.gold,Enum.Material.Neon,false)
        p.Shape=if data.kind=="clock" then Enum.PartType.Cylinder else Enum.PartType.Ball
    end
    local light=Instance.new("PointLight")
    light.Range=17;light.Brightness=0.6;light.Parent=shaft
    local command=part(parent,"Commande de démonstration",base,-4.5,2,-1.2,2.6,3.3,1.8,P.ink,Enum.Material.Metal)
    command:SetAttribute("KinArcadeAction","animate")
    command:SetAttribute("KinArcadeId",data.id)
    F.prompt(command,"Animer",data.title)
end
local function store(parent,data)
    local m=Instance.new("Model");m.Name=data.title;m.Parent=parent
    m:SetAttribute("KinArcadeId",data.id)
    local cf=CFrame.new(data.center_studs[1],0,data.center_studs[3])*CFrame.Angles(0,data.yaw,0)
    local tint=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
    part(m,"Dallage accessible",cf,0,0.15,0,18,0.5,18,P.limestone,Enum.Material.Marble)
    -- Entrée centrale ouverte de 8 studs côté gare.
    part(m,"Façade gauche",cf,-6.25,5.3,-9,5.5,10.5,0.65,P.ink,Enum.Material.Brick)
    part(m,"Façade droite",cf,6.25,5.3,-9,5.5,10.5,0.65,P.ink,Enum.Material.Brick)
    part(m,"Linteau d'entrée",cf,0,9.4,-9,7.7,2.3,0.7,P.gold,Enum.Material.Metal)
    part(m,"Mur arrière",cf,0,5.3,9,18,10.5,0.75,P.ink,Enum.Material.Brick)
    for _,x in ipairs({-9,9}) do
        part(m,"Mur latéral",cf,x,5.3,0,0.75,10.5,18,P.ink,Enum.Material.Brick)
        local glass=part(m,"Grande vitrine latérale",cf,x+(if x>0 then 0.5 else -0.5),6,0,0.1,5,8,P.glass,Enum.Material.Glass,false)
        OpalGlazingV22.apply(glass,false)
    end
    part(m,"Toit à lanterneaux",cf,0,11.5,0,19.2,0.8,20,tint,Enum.Material.Slate)
    for _,z in ipairs({-3,3}) do
        local g=part(m,"Verrière",cf,0,12,z,7,0.1,3.5,P.glass,Enum.Material.Glass,false)
        OpalGlazingV22.apply(g,true)
    end
    for _,x in ipairs({-6.5,6.5}) do
        shelf(m,cf,x,4,tint,if x<0 then 1 else 2)
        plant(m,cf,x,-5.2)
    end
    part(m,"Table de présentation",cf,0,1.85,2.8,5.8,1.1,4.8,P.wood,Enum.Material.WoodPlanks)
    seat(m,cf,5.4,-2.7)
    display(m,cf,data,tint)
    local terminal=part(m,"Terminal des fonctions futures",cf,4.4,2.4,6.8,2.2,4,1.8,P.ink,Enum.Material.Metal)
    terminal:SetAttribute("KinStubInteractionId",data.id..".terminal")
    terminal:SetAttribute("KinStubCapabilityId","future.station.arcade")
    terminal:SetAttribute("KinStubTitle",data.title)
    F.prompt(terminal,"Consulter","Fonctionnalité à venir")
    local board=F.sign(m,"Enseigne",(cf*CFrame.new(0,13,-9.4)).Position,math.deg(data.yaw),data.title,18,2.8)
    board.CanCollide=false
    CrystalEverydayV19.frame(m,cf,18,18,11.5,"station-atelier")
    SecondaryArchitectureV25.arcade(m,cf,#data.id,tint)
    return m
end
function Arcade.isReserved(x,z)
    -- Évite les arbres et les kiosques intempestifs autour des façades.
    return math.abs(x)>48 and math.abs(x)<84 and z>=70 and z<=168
end
function Arcade.make(city)
    local root=F.folder(city,"Galeries de la gare - huit ateliers")
    for _,data in ipairs(Registry.arcades) do store(root,data) end
    for _,side in ipairs({-1,1}) do
        local x=side*50.5
        part(root,"Promenade des galeries",CFrame.new(),x,0.15,115.5,5.6,0.4,85,P.limestone,Enum.Material.Cobblestone)
        for n=1,7 do
            local z=75+n*10
            local stem=part(root,"Lampadaire d'arcade",CFrame.new(),side*49,4,z,0.4,8,0.4,P.ink,Enum.Material.Metal)
            stem.CanCollide=false
            local lamp=part(root,"Orbe de galerie",CFrame.new(),side*49,8,z,1.7,1.7,1.7,P.gold,Enum.Material.Neon,false)
            lamp.Shape=Enum.PartType.Ball
            local light=Instance.new("PointLight");light.Range=18;light.Brightness=1;light.Parent=lamp
        end
    end
    root:SetAttribute("KinArcadesBuilt",#Registry.arcades)
    return root
end
return Arcade

]])
source(server,"StudioAssetLibraryV24","ModuleScript",[[
--!strict
-- Bibliothèque locale de MeshPart importés dans Roblox Studio.
-- Les modèles ne sont jamais téléchargés, ni obtenus depuis une IA/API.
-- ServerStorage.KinCityAssetLibrary est préservé par l'installateur de la ville.
local ServerStorage = game:GetService("ServerStorage")
local MaterialLibraryV25=require(script.Parent.MaterialLibraryV25)
local Kit=require(script.Parent.CrystalKit)
local Library = {}

local VALID = {
    mineral_column=true, opal_spire=true, crystal_rosette=true,
    opal_arch=true, opal_chandelier=true,
    crystal_canopy=true, mineral_planter=true, opal_console=true,
    opal_lattice=true, mineral_pediment=true, harbor_crest=true,
}
function Library.has(assetKey)
    if not VALID[assetKey] then return false end
    local root=ServerStorage:FindFirstChild("KinCityAssetLibrary")
    local template=root and root:FindFirstChild(assetKey)
    return template~=nil and template:IsA("MeshPart")
end
function Library.instantiate(parent,name,assetKey,size,cf,color)
    if not VALID[assetKey] then return nil end
    local root=ServerStorage:FindFirstChild("KinCityAssetLibrary")
    local template=root and root:FindFirstChild(assetKey)
    if not template or not template:IsA("MeshPart") then return nil end
    local copy=template:Clone()
    copy.Name=name
    copy.Size=size
    copy.CFrame=cf
    copy.Color=color
    copy.Material=Enum.Material.Slate
    copy.Anchored=true
    copy.CanCollide=false
    copy.CanTouch=false
    copy.CanQuery=false
    copy.CastShadow=false
    copy:SetAttribute("KinArtTheme","sarcelle-cristal-v24")
    copy:SetAttribute("KinOptionalDetail",true)
    copy:SetAttribute("KinImportedMeshKey",assetKey)
    MaterialLibraryV25.apply(copy,assetKey,Kit.profile)
    copy.Parent=parent
    return copy
end
return Library

]])
source(server,"Tramways","ModuleScript",[[
--!strict
-- Tramways à la demande : les joueurs embarquent à des bornes physiques.
-- La cabine se déplace sur les chemins compilés, sans aucune API externe.
-- Chaque trajet est isolé : deux visiteurs peuvent emprunter la même ligne.
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Factory=require(script.Parent.Factory)
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local Plan=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("WorldPlan"))
local Tramways={}
local palette={Color3.fromRGB(191,149,89),Color3.fromRGB(75,140,155),Color3.fromRGB(156,111,158),Color3.fromRGB(95,152,119)}
local lines={}
local riding={}
for _,path in ipairs(Plan.pedestrian_paths) do
    local pts={}
    local total=0
    for _,p in ipairs(path.path_xyz_studs) do table.insert(pts,Vector3.new(p[1],0.9,p[3])) end
    for j=2,#pts do total+=(pts[j]-pts[j-1]).Magnitude end
    if #pts>=2 and total>25 then
        local stops={math.min(42,total*0.28),math.max(12,total-7)}
        if stops[2]-stops[1]>=12 then
            lines[path.building_id]={id=path.building_id,path=pts,total=total,stops=stops}
        end
    end
end
local function at(line,distance)
    local d=math.clamp(distance,0,line.total)
    for i=2,#line.path do
        local a,b=line.path[i-1],line.path[i]
        local segment=b-a
        local length=segment.Magnitude
        if d<=length then
            local forward=if length>0.001 then segment.Unit else Vector3.new(0,0,1)
            return a+forward*d,forward
        end
        d-=length
    end
    local last=line.path[#line.path]
    local delta=last-line.path[#line.path-1]
    return last,if delta.Magnitude>0.001 then delta.Unit else Vector3.new(0,0,-1)
end
local function carPart(parent,name,size,localCF,color,material)
    local p=Factory.part(parent,name,size,localCF,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
    return p
end
local function carriage(parent,index)
    local car=Instance.new("Model")
    car.Name="Tramway de visite "..index
    car:SetAttribute("KinTramPlayable",true)
    car.Parent=parent
    local color=palette[(index-1)%#palette+1]
    local root=carPart(car,"Pivot",Vector3.new(0.6,0.6,0.6),CFrame.new(),color,Enum.Material.Metal)
    root.Transparency=1
    car.PrimaryPart=root
    carPart(car,"Plancher",Vector3.new(7.6,0.7,11.7),CFrame.new(0,2.0,0),color,Enum.Material.Metal)
    carPart(car,"Banquette",Vector3.new(5,0.8,2),CFrame.new(0,3.4,1.7),Color3.fromRGB(211,193,155),Enum.Material.WoodPlanks)
    carPart(car,"Dossier",Vector3.new(5,2.1,0.5),CFrame.new(0,4.3,2.7),Color3.fromRGB(49,76,82),Enum.Material.Metal)
    carPart(car,"Auvent",Vector3.new(8.5,0.7,12),CFrame.new(0,8.0,0),Color3.fromRGB(53,74,80),Enum.Material.Metal)
    for _,x in ipairs({-3.6,3.6}) do
        for _,z in ipairs({-4.8,4.8}) do
            carPart(car,"Montant",Vector3.new(0.55,5.5,0.55),CFrame.new(x,5.2,z),Color3.fromRGB(212,173,97),Enum.Material.Metal)
        end
        carPart(car,"Main courante",Vector3.new(0.3,0.4,10),CFrame.new(x,4.0,0),Color3.fromRGB(213,189,129),Enum.Material.Metal)
    end
    for _,z in ipairs({-4.7,4.7}) do
        carPart(car,"Essieu",Vector3.new(9.4,1.2,0.9),CFrame.new(0,1.05,z),Color3.fromRGB(55,62,68),Enum.Material.Metal)
    end
    for _,x in ipairs({-3.5,3.5}) do for _,z in ipairs({-4.3,4.3}) do
        local wheel=carPart(car,"Roue",Vector3.new(1.3,2.0,2.0),CFrame.new(x,1.0,z),Color3.fromRGB(35,43,52),Enum.Material.Metal)
        wheel.Shape=Enum.PartType.Cylinder
    end end
    carPart(car,"Phare",Vector3.new(4,0.6,0.3),CFrame.new(0,5,-5.9),Color3.fromRGB(244,222,139),Enum.Material.Neon)
    return car
end
local function message(reply,player,title,body,detail)
    if player.Parent~=Players then return end
    reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=title,message=body,notice=detail})
end
local function stop(parent,line,name,offset,dir,centralIndex,centralTotal)
    local position,forward=at(line,offset)
    local lateral=Vector3.new(-forward.Z,0,forward.X)
    -- Bornes latérales : ne ferment pas le chemin piéton central.
    local dock=position+lateral*9
    if centralIndex then
        local angle=2*math.pi*(centralIndex-1)/centralTotal + 0.26
        dock=Vector3.new(math.cos(angle)*43,0.9,math.sin(angle)*43)
    end
    local cf=CFrame.lookAt(dock,dock+forward)
    local folder=Factory.folder(parent,name)
    Factory.part(folder,"Quai d'embarquement",Vector3.new(5.8,0.3,8),cf*CFrame.new(0,-0.48,0),Color3.fromRGB(214,205,178),Enum.Material.Cobblestone)
    Factory.part(folder,"Marquise",Vector3.new(6.5,0.5,5.8),cf*CFrame.new(0,7,1),Color3.fromRGB(66,91,99),Enum.Material.Metal).CanCollide=false
    for _,x in ipairs({-2.5,2.5}) do
        Factory.part(folder,"Poteau du quai",Vector3.new(0.4,6.9,0.4),cf*CFrame.new(x,3.5,2.4),Color3.fromRGB(163,144,113),Enum.Material.Metal)
    end
    local kiosk=Factory.part(folder,"Borne de tramway",Vector3.new(2.8,4,1.5),cf*CFrame.new(0,1.85,-1.7),Color3.fromRGB(32,71,78),Enum.Material.Metal)
    kiosk:SetAttribute("KinTramLine",line.id)
    kiosk:SetAttribute("KinTramDirection",dir)
    local marker=Factory.prompt(kiosk,"Monter","Tramway Kin City")
    marker.HoldDuration=0.3
    Factory.sign(folder,"Signalétique du tram",(cf*CFrame.new(0,5.5,1.0)).Position,math.deg(math.atan2(-forward.X,-forward.Z)),name,6,1.8).CanCollide=false
end
function Tramways.build(city)
    local root=Factory.folder(city,"Tramways — stations publiques")
    local ordered={}
    for id in pairs(lines) do table.insert(ordered,id) end
    table.sort(ordered)
    for n,id in ipairs(ordered) do
        local line=lines[id]
        stop(root,line,"Station centrale — "..id,line.stops[1],"out",n,#ordered)
        stop(root,line,"Station du quartier — "..id,line.stops[2],"back",nil,nil)
    end
    local n=#ordered
    root:SetAttribute("KinLines",n)
    return root
end
local function release(player,record,endPosition,endDirection)
    if riding[player]~=record then return end
    riding[player]=nil
    TravelSession.finish(player,record.travelToken)
    local char=record.char
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if root and root.Parent then
        -- Libérer sur le côté du quai, pas au milieu du véhicule.
        if endPosition and endDirection and char and char.Parent then
            local side=Vector3.new(-endDirection.Z,0,endDirection.X)
            char:PivotTo(CFrame.new(endPosition+side*8+Vector3.new(0,3,0)))
        end
        root.Anchored=false
    end
    if hum and hum.Parent then
        hum.WalkSpeed=record.speed
        hum.JumpPower=record.jumpPower
        hum.JumpHeight=record.jumpHeight
        hum.AutoRotate=record.autoRotate
    end
    if record.car and record.car.Parent then record.car:Destroy() end
end
local function beginTrip(world,reply,player,line,direction)
    if riding[player] then return end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health<=0 or not root or not char then return end
    if hum.SeatPart or root.Anchored then return end
    local token=TravelSession.begin(player,"tram")
    if not token then return end
    local startDist=if direction=="out" then line.stops[1] else line.stops[2]
    local endDist=if direction=="out" then line.stops[2] else line.stops[1]
    local first,forward=at(line,startDist)
    if direction=="back" then forward=-forward end
    -- L'entrée du trajet a été vérifiée contre la borne physique du quai.
    local container=world:FindFirstChild("Tramways actifs")
    if not container then container=Factory.folder(world,"Tramways actifs") end
    local car=carriage(container,player.UserId)
    local record={char=char,car=car,travelToken=token,speed=hum.WalkSpeed,jumpPower=hum.JumpPower,jumpHeight=hum.JumpHeight,autoRotate=hum.AutoRotate}
    riding[player]=record
    local distance=startDist
    root.Anchored=true
    hum.WalkSpeed=0;hum.JumpPower=0;hum.JumpHeight=0;hum.AutoRotate=false
    local duration=math.abs(endDist-startDist)/15
    local began=os.clock()
    reply:FireClient(player,{kind="tram.ride.v1",state="depart",duration=duration,destination=line.id})
    task.spawn(function()
        local ok,reason=pcall(function()
            while riding[player]==record and player.Parent==Players and world.Parent and char.Parent and hum.Health>0 do
                local t=math.clamp((os.clock()-began)/math.max(duration,0.1),0,1)
                -- Lissage du démarrage et de l'arrêt.
                local smooth=t*t*(3-2*t)
                distance=startDist+(endDist-startDist)*smooth
                local pos,heading=at(line,distance)
                if direction=="back" then heading=-heading end
                local cf=CFrame.lookAt(pos,pos+heading)
                car:PivotTo(cf)
                char:PivotTo(cf*CFrame.new(0,4.2,0))
                if t>=1 then break end
                task.wait(0.08)
            end
        end)
        local stopPos,stopForward=at(line,endDist)
        if direction=="back" then stopForward=-stopForward end
        local completed=ok and (os.clock()-began)>=duration and riding[player]==record
            and player.Character==char and hum.Health>0 and world.Parent~=nil
        release(player,record,if completed then stopPos else nil,if completed then stopForward else nil)
        if not ok then warn("Kin City trajet tramway:",reason) end
        if player.Parent==Players then
            reply:FireClient(player,{kind="tram.ride.v1",state=if completed then "arrive" else "cancel"})
        end
    end)
end
function Tramways.start(world,reply)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if not prompt.Enabled or not player or not player:IsA("Player") then return end
        local id=host:GetAttribute("KinTramLine")
        local direction=host:GetAttribute("KinTramDirection")
        if type(id)~="string" or (direction~="out" and direction~="back") then return end
        if not RateLimiter.allowed(player,"tram/"..id,2) then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+4 then return end
        local line=lines[id]
        if line then beginTrip(world,reply,player,line,direction) end
    end)
    Players.PlayerRemoving:Connect(function(player)
        local rec=riding[player]
        if rec then release(player,rec,nil,nil) end
    end)
    world.Destroying:Connect(function()
        for player,rec in pairs(riding) do release(player,rec,nil,nil) end
    end)
end
return Tramways

]])
source(server,"TransitNodes","ModuleScript",[[
--!strict
-- Navettes locales entre la place centrale et les entrées institutionnelles.
-- Aucun portail externe, aucun calcul ou paiement. Contrôle de destination côté serveur.
local F=require(script.Parent.Factory)
local Transit={}
local gold=Color3.fromRGB(201,167,107)
local navy=Color3.fromRGB(34,62,73)
local function terminal(parent,position,title,id,anchor)
    local m=F.folder(parent,"Navette "..title)
    F.part(m,"Plateforme",Vector3.new(9,0.4,9),CFrame.new(position+Vector3.new(0,0.15,0)),navy,Enum.Material.Metal)
    for _,side in ipairs({-1,1}) do
        F.part(m,"Colonne",Vector3.new(0.5,8,0.5),CFrame.new(position+Vector3.new(side*3.5,4,2.5)),gold,Enum.Material.Metal)
    end
    F.part(m,"Arche",Vector3.new(8,0.6,1.0),CFrame.new(position+Vector3.new(0,8,2.5)),gold,Enum.Material.Metal)
    local kiosk=F.part(m,"Destination",Vector3.new(5.6,4.3,1.2),CFrame.new(position+Vector3.new(0,2.25,-2.5)),navy,Enum.Material.Metal)
    local label=F.sign(m,"Destination affichée",position+Vector3.new(0,3.3,-3.3),0,title,5,2.8)
    label.CanCollide=false
    kiosk:SetAttribute("KinShuttleId",id)
    kiosk:SetAttribute("KinShuttleAnchor",anchor)
    F.prompt(kiosk,"Se rendre","Destination : "..title)
    return m
end
function Transit.make(parent,plan,named)
    local group=F.folder(parent,"Transport public")
    local destinations={}
    for _,door in ipairs(plan.doors) do
        if door.source_place_key=="city" then table.insert(destinations,door) end
    end
    table.sort(destinations,function(a,b)return a.building_id<b.building_id end)
    for i,door in ipairs(destinations) do
        local label=(named[door.building_id] and named[door.building_id].name) or door.building_id
        local angle=2*math.pi*(i-1)/#destinations
        local pos=Vector3.new(math.sin(angle)*29,0,math.cos(angle)*29)
        terminal(group,pos,label,"shuttle."..door.building_id,door.source_anchor_id)
    end
    for _,door in ipairs(destinations) do
        -- Une borne de retour en ville près de l'entrée, éloignée de la vraie porte.
        local anchor=nil
        for _,p in ipairs(plan.places) do
            if p.place_key=="city" then
                for _,a in ipairs(p.anchors) do
                    if a.anchor_id==door.source_anchor_id then anchor=a;break end
                end
            end
        end
        if anchor then
            local p=Vector3.new(anchor.position_studs[1],0,anchor.position_studs[3])
            local dir=Vector3.new(p.X,0,p.Z).Unit
            local tangent=Vector3.new(-dir.Z,0,dir.X)
            terminal(group,p+tangent*12+dir*6,"Place centrale","shuttle.return."..door.building_id,"city.central.spawn")
        end
    end
    return group
end
return Transit

]])
source(server,"TravelSession","ModuleScript",[[
--!strict
-- Kin City v18 : une seule opération de déplacement/transport par joueur.
-- Réserve la session avant toute attente asynchrone; vérifie le personnage
-- après RequestStreamAroundAsync; empêche une ancienne requête de téléporter
-- un nouveau personnage. Pas de réseau HTTP et aucune autorité client.
local Players=game:GetService("Players")
local TravelSession={}
local current={}
local serial=0

function TravelSession.begin(player,kind)
    if not player or player.Parent~=Players or current[player] then return nil end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not char or not char.Parent or not hum or hum.Health<=0 or not root
        or root.Anchored or hum.SeatPart then return nil end
    if player:GetAttribute("KinBusActive") or player:GetAttribute("KinFerryActive") then return nil end
    serial+=1
    local token={id=serial,kind=kind,character=char,zone=player:GetAttribute("KinZone")}
    current[player]=token
    return token
end

function TravelSession.active(player)
    return current[player]~=nil
end

function TravelSession.valid(player,token)
    if not token or current[player]~=token or player.Parent~=Players then return false end
    local char=token.character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return player.Character==char and char.Parent~=nil and hum~=nil and hum.Health>0
        and root~=nil and root.Parent~=nil
        and player:GetAttribute("KinZone")==token.zone
end

function TravelSession.finish(player,token)
    if current[player]==token then current[player]=nil end
end

function TravelSession.cancel(player)
    current[player]=nil
end

Players.PlayerRemoving:Connect(function(player)
    current[player]=nil
end)
return TravelSession

]])
source(server,"UrbanDetails","ModuleScript",[[
--!strict
-- Espaces publics, bancs, fontaines, belvédères, lampadaires, arbres floraux.
local F=require(script.Parent.Factory)
local Urban={}
local function pos(x,y,z) return Vector3.new(x,y,z) end
local function part(parent,name,xyz,size,color,material)
    return F.part(parent,name,size,CFrame.new(xyz),color,material)
end
local function sphere(parent,name,xyz,size,color,material)
    local p=part(parent,name,xyz,size,color,material)
    p.Shape=Enum.PartType.Ball
    return p
end
local function cylinder(parent,name,xyz,diameter,height,color,material)
    local p=F.part(parent,name,Vector3.new(height,diameter,diameter),CFrame.new(xyz)*CFrame.Angles(0,0,math.pi/2),color,material)
    p.Shape=Enum.PartType.Cylinder
    return p
end
local stone=Color3.fromRGB(201,193,169)
local iron=Color3.fromRGB(30,104,100)
local copper=Color3.fromRGB(181,139,86)
local foliage=Color3.fromRGB(51,132,91)
local function lamp(parent,x,z)
    local model=F.folder(parent,"Réverbère")
    part(model,"Socle",pos(x,0.35,z),Vector3.new(2,0.7,2),stone,Enum.Material.Marble)
    part(model,"Fût",pos(x,5.1,z),Vector3.new(0.7,9.3,0.7),iron,Enum.Material.Metal)
    part(model,"Chapiteau",pos(x,10.2,z),Vector3.new(2.4,1.3,2.4),copper,Enum.Material.Metal)
    local bulb=part(model,"Luminaire",pos(x,10.7,z),Vector3.new(1.2,0.8,1.2),Color3.fromRGB(255,234,172),Enum.Material.Neon)
    bulb.CanCollide=false
    local light=Instance.new("PointLight");light.Brightness=1.1;light.Range=19;light.Shadows=false;light.Parent=bulb
end
local function bench(parent,x,z,yaw)
    local m=F.folder(parent,"Banc public")
    local base=CFrame.new(x,0,z)*CFrame.Angles(0,math.rad(yaw),0)
    F.part(m,"Assise",Vector3.new(8,0.5,2),base*CFrame.new(0,1.8,0),copper,Enum.Material.WoodPlanks)
    F.part(m,"Dossier",Vector3.new(8,2,0.45),base*CFrame.new(0,2.7,1),copper,Enum.Material.Wood)
    for _,s in ipairs({-1,1}) do
        F.part(m,"Pied",Vector3.new(0.55,1.7,1.8),base*CFrame.new(s*3,0.85,0),iron,Enum.Material.Metal)
    end
end
local function planter(parent,x,z,seed)
    local m=F.folder(parent,"Jardinière")
    cylinder(m,"Bordure",pos(x,0.85,z),5.8,1.7,stone,Enum.Material.Cobblestone)
    for n=1,6 do
        local a=n*math.pi/3
        local r=1.8
        local px,pz=x+math.cos(a)*r,z+math.sin(a)*r
        sphere(m,"Fleur",pos(px,2.9,pz),Vector3.new(1.2,1.2,1.2),Color3.fromHSV(((seed+n)*0.17)%1,0.64,0.94),Enum.Material.Grass).CanCollide=false
        part(m,"Tige",pos(px,2,pz),Vector3.new(0.22,1.9,0.22),foliage,Enum.Material.Grass).CanCollide=false
    end
end
local function sculpture(parent,x,z,seed)
    local m=F.folder(parent,"Sculpture publique")
    cylinder(m,"Piédestal",pos(x,1.3,z),7,2.6,stone,Enum.Material.Marble)
    local ring=F.part(m,"Anneau",Vector3.new(9,0.7,9),CFrame.new(x,7,z)*CFrame.Angles(0,0,math.rad(25+seed*7)),copper,Enum.Material.Metal)
    ring.Shape=Enum.PartType.Cylinder;ring.CanCollide=false
    sphere(m,"Noyau",pos(x,7,z),Vector3.new(4.5,4.5,4.5),Color3.fromRGB(84,156,169),Enum.Material.Glass).CanCollide=false
end
local function fountain(parent,x,z)
    local m=F.folder(parent,"Fontaine")
    cylinder(m,"Margelle",pos(x,0.55,z),25,1.1,stone,Enum.Material.Marble)
    cylinder(m,"Bassin",pos(x,1.2,z),21,0.25,Color3.fromRGB(58,153,187),Enum.Material.Glass).CanCollide=false
    cylinder(m,"Pilier",pos(x,3,z),3,5,copper,Enum.Material.Marble)
    sphere(m,"Couronne d'eau",pos(x,6,z),Vector3.new(5,2.3,5),Color3.fromRGB(103,207,229),Enum.Material.Glass).CanCollide=false
    for n=1,6 do
        local a=n*math.pi/3
        local xx,zz=x+math.cos(a)*6,z+math.sin(a)*6
        sphere(m,"Jet",pos(xx,3,zz),Vector3.new(0.5,4,0.5),Color3.fromRGB(149,214,237),Enum.Material.Glass).CanCollide=false
    end
end
local function nearBuilding(x,z,structures,padding)
    for _,b in ipairs(structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        local angle=math.rad(b.yaw_degrees)
        local lx=math.cos(angle)*dx-math.sin(angle)*dz
        local lz=math.sin(angle)*dx+math.cos(angle)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+padding and math.abs(lz)<b.footprint_studs[2]/2+padding then return true end
    end
    return false
end
local function ring(parent,radius,width,structures)
    local segments=96
    for k=1,segments do
        local theta=(k-0.5)*math.pi*2/segments
        local x,z=math.cos(theta)*radius,math.sin(theta)*radius
        if not nearBuilding(x,z,structures,9) then
            local a=(k-1)*math.pi*2/segments
            local b=k*math.pi*2/segments
            local p=Vector3.new(math.cos(a)*radius,0.17,math.sin(a)*radius)
            local q=Vector3.new(math.cos(b)*radius,0.17,math.sin(b)*radius)
            local v=q-p
            local section=F.part(parent,"Promenade annulaire",Vector3.new(width,0.23,v.Magnitude+1.3),CFrame.lookAt((p+q)/2,q),Color3.fromRGB(204,187,159),Enum.Material.Cobblestone)
            section.CanCollide=false
        end
    end
end
local districtNames={
    central="Place de la Gouvernance",konnected="Quartier du Savoir",
    ethikos="Place de l'Éthique",keenkonnect="Parc de l'Innovation",
    kreative="Quartier Créatif",orgo="Infrastructure Orgo"
}
function Urban.make(parent,plan)
    local folder=F.folder(parent,"Vie urbaine et jardins")
    local promenades=F.folder(folder,"Promenades concentriques")
    ring(promenades,71,5.5,plan.structures)
    ring(promenades,327,7,plan.structures)
    local details=F.folder(folder,"Places et monuments")
    fountain(details,-30,-29)
    for n=1,7 do
        local a=math.pi*2*n/7
        local radius=42
        local x,z=math.cos(a)*radius,math.sin(a)*radius
        bench(details,x,z,(a*180/math.pi)+90)
        planter(details,math.cos(a)*52,math.sin(a)*52,n)
    end
    for n=1,4 do
        local a=n*math.pi/2+math.pi/4
        lamp(details,math.cos(a)*59,math.sin(a)*59)
    end
    for _,anchor in ipairs(plan.places) do
        if anchor.place_key=="city" then
            for _,hub in ipairs(anchor.anchors) do
                local district=string.match(hub.anchor_id,"^city%.district%.([%a]+)%.hub$")
                if district and district~="central" then
                    local x,z=hub.position_studs[1],hub.position_studs[3]
                    local dir=Vector3.new(x,0,z).Unit
                    local right=Vector3.new(-dir.Z,0,dir.X)
                    local spot=Vector3.new(x,0,z)
                    local sign=F.sign(details,"Orientation "..district,spot+Vector3.new(0,6,0),-math.deg(math.atan2(dir.X,dir.Z)),districtNames[district] or district,23,3.8)
                    sign.CanCollide=false
                    for s=-1,1,2 do
                        local point=spot+right*s*16
                        bench(details,point.X,point.Z,math.deg(math.atan2(dir.X,dir.Z)))
                        planter(details,point.X+dir.X*8,point.Z+dir.Z*8,math.floor(math.abs(x)+math.abs(z)+s))
                        lamp(details,point.X-dir.X*8,point.Z-dir.Z*8)
                    end
                end
            end
        end
    end
    -- Axes radiaux vers les quartiers périphériques, sans traverser les bâtiments.
    for spoke=1,16 do
        local angle=(spoke-1)*math.pi/8
        for radius=335,425,15 do
            local mid=radius+7.5
            local x,z=math.cos(angle)*mid,math.sin(angle)*mid
            if not nearBuilding(x,z,plan.structures,8) then
                local base=CFrame.new(x,0.19,z)*CFrame.Angles(0,-angle+math.pi/2,0)
                local sidewalk=F.part(promenades,"Allée radiale",Vector3.new(6,0.23,16.5),base,stone,Enum.Material.Cobblestone)
                sidewalk.CanCollide=false
            end
        end
    end
    -- Belvédères sur la rive de l'île, pour explorer la couronne naturelle.
    for n=1,8 do
        local angle=n*math.pi/4
        local cx,cz=math.cos(angle)*476,math.sin(angle)*476
        local base=CFrame.new(cx,0,cz)*CFrame.Angles(0,-angle+math.pi/2,0)
        local terrace=F.folder(details,"Belvédère littoral")
        F.part(terrace,"Terrasse",Vector3.new(22,0.7,18),base*CFrame.new(0,0.2,0),Color3.fromRGB(142,111,75),Enum.Material.WoodPlanks)
        for _,side in ipairs({-1,1}) do
            F.part(terrace,"Garde-corps",Vector3.new(0.5,3.3,16),base*CFrame.new(side*10.5,2,0),iron,Enum.Material.Metal)
        end
        F.part(terrace,"Balustrade",Vector3.new(21,3.3,0.5),base*CFrame.new(0,2,8.8),iron,Enum.Material.Metal)
        local a=base*CFrame.new(0,0,-2)
        bench(terrace,a.Position.X,a.Position.Z,math.deg(-angle+math.pi/2))
    end
    sculpture(details,58,48,2)
    sculpture(details,-65,56,5)
    -- Lumières piétonnes espacées : détail visuel, mais coût maîtrisé.
    for _,path in ipairs(plan.pedestrian_paths) do
        local nodes=path.path_xyz_studs
        if #nodes>=2 then
            local a=Vector3.new(nodes[1][1],0,nodes[1][3])
            local b=Vector3.new(nodes[#nodes][1],0,nodes[#nodes][3])
            local dir=b-a
            if dir.Magnitude>20 then
                local perpendicular=Vector3.new(-dir.Unit.Z,0,dir.Unit.X)
                for _,t in ipairs({0.28,0.69}) do
                    local point=a+dir*t+perpendicular*10
                    if not nearBuilding(point.X,point.Z,plan.structures,3) then
                        lamp(details,point.X,point.Z)
                    end
                end
            end
        end
    end
    return folder
end
return Urban

]])
source(server,"UrbanV14Runtime","ModuleScript",[[
--!strict
-- Actions serveur des galeries et ateliers v14 : cinétiques + expériences à trois étapes.
-- Pas de DataStore, HTTP, récompenses ni données d'identité kOA.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
local TIMELIMIT=48
local function tell(remote,player,title,message)
    if player.Parent~=Players then return end
    remote:FireClient(player,{
        kind="interaction.reply.v1",status="LOCAL_SUCCESS",
        title=title,message=message,
        notice="Expérience physique locale · aucune opération kOA",
    })
end
local function eligible(host,prompt,player,world)
    if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return false end
    if not prompt.Enabled or player:GetAttribute("KinZone")~="city" then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return hum~=nil and root~=nil and hum.Health>0 and (root.Position-host.Position).Magnitude<=prompt.MaxActivationDistance+3
end
local function spin(model,seconds,revolutions)
    if not model or not model.Parent then return end
    local start=model:GetPivot()
    local begun=os.clock()
    while model.Parent and model:IsDescendantOf(workspace) do
        local alpha=math.clamp((os.clock()-begun)/seconds,0,1)
        local eased=alpha*alpha*(3-2*alpha)
        model:PivotTo(start*CFrame.Angles(0,eased*2*math.pi*revolutions,0))
        if alpha>=1 then break end
        RunService.Heartbeat:Wait()
    end
    if model.Parent then model:PivotTo(start) end
end
function Runtime.start(world,reply)
    local art={}
    local machines={}
    local lights={}
    local cores={}
    local states={}
    local spinning={}
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("Model") then
            local aid=obj:GetAttribute("KinArcadeDisplayId")
            if type(aid)=="string" then art[aid]=obj end
            local wid=obj:GetAttribute("KinWorkshopMachine")
            if type(wid)=="string" then machines[wid]=obj end
        elseif obj:IsA("BasePart") then
            local wid=obj:GetAttribute("KinWorkshopIndicator")
            if type(wid)=="string" then
                lights[wid]=lights[wid] or {}
                lights[wid][obj:GetAttribute("KinWorkshopIndicatorStep")]=obj
            end
            local core=obj:GetAttribute("KinWorkshopCore")
            if type(core)=="string" then cores[core]=obj end
        end
    end
    local function progress(host,id,step)
        local model=machines[id]
        local site=model and model:GetPivot().Position or host.Position
        for _,player in ipairs(Players:GetPlayers()) do
            local char=player.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if root and player:GetAttribute("KinZone")=="city" and (root.Position-site).Magnitude<75 then
                reply:FireClient(player,{
                    kind="workshop.progress.v1",title="ATELIER PUBLIC",step=step,id=id
                })
            end
        end
    end
    local function reflect(id,step)
        for k,bulb in pairs(lights[id] or {}) do
            if bulb.Parent then
                bulb.Color=if k<step then Color3.fromRGB(115,245,175) else Color3.fromRGB(94,124,136)
            end
        end
        local core=cores[id]
        if core and core.Parent then
            local glow=core:FindFirstChildOfClass("PointLight")
            if glow then glow.Brightness=if step==4 then 3 else 0.35+step*0.35 end
        end
    end
    Prompts.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not eligible(host,prompt,player,world) then return end
        local arcade=host:GetAttribute("KinArcadeId")
        if host:GetAttribute("KinArcadeAction")=="animate" and type(arcade)=="string" then
            if not RateLimiter.allowed(player,"arcade/"..arcade,1.2) then return end
            local display=art[arcade]
            if not display or spinning[arcade] then
                tell(reply,player,"Galerie des ateliers","Le mécanisme est déjà en mouvement.")
                return
            end
            spinning[arcade]=true
            tell(reply,player,"Galerie des ateliers","La collection s'anime sous tes yeux.")
            task.spawn(function()
                local ok,err=pcall(spin,display,3,2)
                if not ok then warn("Kin City arcade",err) end
                spinning[arcade]=nil
            end)
            return
        end
        local id=host:GetAttribute("KinWorkshopId")
        local nextStep=host:GetAttribute("KinWorkshopStep")
        if type(id)~="string" or type(nextStep)~="number" or nextStep<1 or nextStep>3 then return end
        if not RateLimiter.allowed(player,"workshop/"..id,0.55) then return end
        local now=os.clock()
        local st=states[id]
        if not st or now-st.last>TIMELIMIT then
            st={step=1,last=now,contributors={}}
            states[id]=st
            reflect(id,1)
            progress(host,id,1)
        end
        if st.step==4 then
            tell(reply,player,"Atelier public","La machine est active. Une nouvelle session commencera après le cycle.")
            return
        end
        if nextStep~=st.step then
            tell(reply,player,"Atelier public",string.format("Étape attendue : %d sur 3. Commence par la console correspondante.",st.step))
            return
        end
        st.contributors[player.UserId]=true
        st.last=now
        st.step+=1
        reflect(id,st.step)
        progress(host,id,st.step)
        if st.step<=3 then
            tell(reply,player,"Atelier public",string.format("Étape %d réussie ! Active maintenant la console %d.",nextStep,st.step))
            return
        end
        local total=0
        for _ in pairs(st.contributors) do total+=1 end
        tell(reply,player,"Atelier public",if total>=2 then "Vous avez mis la machine en marche ensemble !" else "Machine activée ! Les trois étapes sont complétées.")
        local model=machines[id]
        task.spawn(function()
            local ok,err=pcall(function()
                spin(model,6,4)
                task.wait(1.5)
            end)
            if not ok then warn("Kin City atelier",err) end
            if states[id]==st then
                states[id]=nil
                reflect(id,1)
            end
        end)
    end)
end
return Runtime

]])
source(server,"VerticalArchitecture","ModuleScript",[[
--!strict
-- Ailes supérieures, promenades panoramiques et escaliers réellement franchissables.
-- Les étages sont intégrés au même modèle et ne requièrent aucun asset / service externe.
local F=require(script.Parent.Factory)
local Vertical={}
local Roof=require(script.Parent.RooftopGardens)
local function block(parent,name,origin,size,x,y,z,color,material)
    return F.part(parent,name,size,CFrame.new(origin+Vector3.new(x,y,z)),color,material)
end
local function panel(parent,origin,key,x,z,accent,title,index)
    local booth=block(parent,"Borne étage "..index,origin,Vector3.new(3.3,4.5,2.2),x,20.6,z,Color3.fromRGB(39,61,73),Enum.Material.Metal)
    local face=block(parent,"Écran interactif",origin,Vector3.new(2.7,2.8,0.2),x,21.2,z-1.2,accent,Enum.Material.Neon)
    face.CanCollide=false
    booth:SetAttribute("KinStubInteractionId",key..".level2.terminal."..index)
    booth:SetAttribute("KinStubCapabilityId","future."..key..".level2")
    booth:SetAttribute("KinStubTitle",title)
    F.prompt(booth,"Consulter",title)
end
local function bookGallery(parent,origin,key,accent,trim)
    -- Galeries de deuxième niveau, bordées d'une balustrade côté atrium.
    for _,s in ipairs({-1,1}) do
        local x=s*34
        block(parent,"Mezzanine latérale",origin,Vector3.new(30,1,49),x,17.5,75,trim,Enum.Material.Marble)
        for z=55,94,8 do
            block(parent,"Poteau de galerie",origin,Vector3.new(0.45,4,0.45),s*18.3,20.1,z,accent,Enum.Material.Metal)
        end
        block(parent,"Main courante",origin,Vector3.new(0.7,0.65,45),s*18.3,22.3,75,accent,Enum.Material.Metal)
        -- On garde le bord intérieur ouvert et une vue sur le rez-de-chaussée.
        for n=1,3 do
            local zz=56+(n-1)*18
            local lamp=block(parent,"Luminaire galerie",origin,Vector3.new(0.45,0.6,0.45),s*34,31,zz,Color3.fromRGB(253,218,145),Enum.Material.Neon)
            lamp.CanCollide=false
        end
    end
    block(parent,"Passerelle arrière",origin,Vector3.new(37,1,10),0,17.5,95,trim,Enum.Material.Marble)
    block(parent,"Balustrade passerelle",origin,Vector3.new(34,4,0.65),0,20.2,90.5,accent,Enum.Material.Metal)
    panel(parent,origin,key,-35,68,accent,"Collections supérieures",1)
    panel(parent,origin,key,35,68,accent,"Salle de recherche",2)
    panel(parent,origin,key,0,96,accent,"Observatoire des connaissances",3)
end
local function stairs(parent,origin,key,x,accent,stone)
    -- 26 marches : hauteur 0,69, giron 1,4. Les volumes sont jointifs.
    -- Chaque marche est un socle plein : pas de plancher invisible entre deux marches.
    local steps=26
    local rise=18/steps
    local depth=1.45
    local startZ=49
    for i=1,steps do
        local height=rise*i
        local z=startZ+(i-0.5)*depth
        block(parent,"Marche "..i,origin,Vector3.new(7.4,height,depth+0.08),x,height/2,z,stone,Enum.Material.Marble)
        if i%3==0 then
            for _,side in ipairs({-1,1}) do
                block(parent,"Montant d'escalier",origin,Vector3.new(0.25,3,0.25),x+side*4.1,height+1.5,z,accent,Enum.Material.Metal).CanCollide=false
            end
        end
    end
    for _,side in ipairs({-1,1}) do
        -- Barrières non bloquantes en hauteur, sans gêner la montée.
        block(parent,"Main courante escalier",origin,Vector3.new(0.3,0.4,37),x+side*4.25,12,68,accent,Enum.Material.Metal).CanCollide=false
    end
end
local function upperFurniture(parent,origin,key,accent)
    local colors={Color3.fromRGB(106,75,51),Color3.fromRGB(47,74,82)}
    for _,s in ipairs({-1,1}) do
        for n=1,3 do
            local x=s*(26+(n%2)*8)
            local z=56+(n-1)*13
            block(parent,"Table étude étage",origin,Vector3.new(7,0.55,4),x,20.4,z,colors[1],Enum.Material.WoodPlanks)
            for _,side in ipairs({-1,1}) do
                block(parent,"Pied table étage",origin,Vector3.new(0.45,2.2,0.45),x+side*2.7,19.1,z,colors[2],Enum.Material.Metal)
            end
            block(parent,"Lampe bureau",origin,Vector3.new(1.2,1.1,1.2),x,21.4,z,accent,Enum.Material.Neon).CanCollide=false
        end
    end
end
local function elevator(parent,origin,key,accent)
    -- Deux stations indépendantes avec une destination côté serveur.
    -- Elles sont placées dans l'atrium, à l'écart des ouvertures centrales.
    for _,spec in ipairs({{name="Rez-de-chaussée",baseY=0,destY=18},{name="Étage panoramique",baseY=18,destY=0}}) do
        local y=spec.baseY
        block(parent,"Palier ascenseur "..spec.name,origin,Vector3.new(7,0.35,6),0,y+0.08,82,accent,Enum.Material.Metal)
        local console=block(parent,"Ascenseur "..spec.name,origin,Vector3.new(2,4,1.3),5,y+2.1,83,Color3.fromRGB(40,64,75),Enum.Material.Metal)
        local display=block(parent,"Afficheur ascenseur",origin,Vector3.new(1.6,1.8,0.15),5,y+2.6,82.3,Color3.fromRGB(115,226,218),Enum.Material.Neon)
        display.CanCollide=false
        console:SetAttribute("KinLiftId",key..(y==0 and ".lift.up" or ".lift.down"))
        console:SetAttribute("KinLiftPlaceKey",key)
        console:SetAttribute("KinLiftPosition",origin+Vector3.new(0,spec.destY+3.5,79))
        local verb=y==0 and "Monter à l'étage" or "Descendre"
        F.prompt(console,verb,"Ascenseur panoramique")
    end
end
function Vertical.make(model,placeKey,origin,style)
    local section=F.folder(model,"Galeries et étage panoramique")
    local trim=F.hex(style.palette.trim)
    local accent=F.hex(style.palette.accent)
    local walls=F.hex(style.palette.wall)
    -- Couronne extérieure au-dessus des murs de l'atrium d'origine (z:48..104, x:-50..50).
    for _,s in ipairs({-1,1}) do
        block(section,"Mur haut latéral",origin,Vector3.new(1,19,56),s*49.7,25.5,76,walls,Enum.Material.Concrete)
    end
    block(section,"Mur arrière haut",origin,Vector3.new(99,19,1),0,25.5,103.8,walls,Enum.Material.Concrete)
    block(section,"Frise haute",origin,Vector3.new(101,1,57),0,34.8,76,trim,Enum.Material.Metal).CanCollide=false
    block(section,"Toit verrière",origin,Vector3.new(97,0.8,53),0,35.3,76,Color3.fromRGB(119,178,185),Enum.Material.Glass).CanCollide=false
    for x=-40,40,16 do
        block(section,"Traverse de verrière",origin,Vector3.new(0.65,1.2,55),x,35.8,76,accent,Enum.Material.Metal).CanCollide=false
    end
    for z=56,96,10 do
        block(section,"Traverse transversale",origin,Vector3.new(99,1.1,0.5),0,35.8,z,accent,Enum.Material.Metal).CanCollide=false
    end
    bookGallery(section,origin,placeKey,accent,trim)
    -- La passerelle médiane connecte les deux mezzanines et porte l'ascenseur.
    block(section,"Passerelle médiane",origin,Vector3.new(98,1,10),0,17.5,82,trim,Enum.Material.Marble)
    for _,z in ipairs({77.3,87.0}) do
        for _,s in ipairs({-1,1}) do
            block(section,"Garde-corps passerelle",origin,Vector3.new(25,3.4,0.55),s*10,19.9,z,accent,Enum.Material.Metal)
        end
    end
    for _,s in ipairs({-1,1}) do
        stairs(section,origin,placeKey,s*37,accent,trim)
    end
    upperFurniture(section,origin,placeKey,accent)
    elevator(section,origin,placeKey,accent)
    Roof.make(model,placeKey,origin,style)
    F.sign(section,"Galerie haute",origin+Vector3.new(0,29.5,100),180,"GALERIE PANORAMIQUE",38,3).CanCollide=false
    return section
end
return Vertical

]])
source(server,"ViewerPresenceV21","ModuleScript",[[
--!strict
-- Suspension légère des mouvements décoratifs quand aucun visiteur ne voit la zone.
-- Ne retire aucun personnage, prompt ou emplacement du monde.
local Players=game:GetService("Players")
local Presence={}
function Presence.near(position:Vector3,radius:number):boolean
    local r2=radius*radius
    for _,player in ipairs(Players:GetPlayers()) do
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if root and root:IsA("BasePart") and humanoid and humanoid.Health>0 then
            local offset=root.Position-position
            if offset:Dot(offset)<=r2 then return true end
        end
    end
    return false
end
return Presence

]])
source(server,"WaterfrontDistrict","ModuleScript",[[
--!strict
-- Kin City v6: promenades et quais accessibles au bord du lac annulaire.
-- Tout est génere avec les primitives natives. Aucun asset distant.
local F=require(script.Parent.Factory)
local Waterfront={}
local WOOD=Color3.fromRGB(153,110,74)
local COPPER=Color3.fromRGB(190,151,94)
local PIER=Color3.fromRGB(220,207,181)
local NAVY=Color3.fromRGB(30,104,100)
local WATER=Color3.fromRGB(83,187,205)

local function block(parent,name,base,offset,size,color,material,collide)
    local p=F.part(parent,name,size,base*CFrame.new(offset),color,material)
    if collide==false then p.CanCollide=false end
    return p
end
local function seat(parent,base,x,z)
    local model=Instance.new("Seat")
    model.Name="Banc accessible"
    model.Size=Vector3.new(5,0.9,2.5)
    model.CFrame=base*CFrame.new(x,1.25,z)
    model.Anchored=true
    model.Color=WOOD
    model.Material=Enum.Material.WoodPlanks
    model.Parent=parent
    block(parent,"Dossier de banc",base,Vector3.new(x,2.25,z+1.3),Vector3.new(5,2.2,0.5),NAVY,Enum.Material.Metal,true)
end
local function pier(root,index,theta)
    -- La berge est à r=495. Les quais prolongent la ville au-dessus du lac.
    local radial=Vector3.new(math.cos(theta),0,math.sin(theta))
    local center=radial*502
    local base=CFrame.lookAt(center,center+radial)
    local m=Instance.new("Model")
    m.Name=string.format("Quai public %02d",index)
    m:SetAttribute("KinWaterfrontId",string.format("city.waterfront.%02d",index))
    m.Parent=root
    block(m,"Passerelle jusqu'au quai",base,Vector3.new(0,0.5,0),Vector3.new(11,1.2,76),WOOD,Enum.Material.WoodPlanks,true)
    block(m,"Plateforme sur le lac",base,Vector3.new(0,0.55,-39),Vector3.new(34,1.25,24),PIER,Enum.Material.WoodPlanks,true)
    -- Piliers dans l'eau : le quai ne flotte pas visuellement dans le vide.
    for _,zz in ipairs({-48,-38,-27,7,28}) do
        for _,xx in ipairs({-5,5}) do
            block(m,"Pieu de fondation",base,Vector3.new(xx,-2,zz),Vector3.new(1.4,6.3,1.4),NAVY,Enum.Material.Metal,true)
        end
    end
    for _,x in ipairs({-15.4,15.4}) do
        for _,z in ipairs({-48,-37,-29}) do
            block(m,"Borne d'amarrage",base,Vector3.new(x,2.1,z),Vector3.new(1.2,3.5,1.2),NAVY,Enum.Material.Metal,true)
        end
        for _,z in ipairs({-44,-34}) do
            block(m,"Garde-corps lac",base,Vector3.new(x,3,z),Vector3.new(0.45,0.6,9),COPPER,Enum.Material.Metal,false)
        end
        seat(m,base,x*0.55,-38)
    end
    for _,z in ipairs({-21,-6,8,23}) do
        for _,x in ipairs({-5,5}) do
            block(m,"Poteau guide",base,Vector3.new(x,1.5,z),Vector3.new(0.45,3.2,0.45),NAVY,Enum.Material.Metal,true)
            local lamp=block(m,"Balise lumineuse",base,Vector3.new(x,3.1,z),Vector3.new(1.0,0.75,1.0),COPPER,Enum.Material.Neon,false)
            if z==-21 then
                local light=Instance.new("PointLight")
                light.Brightness=0.35;light.Range=12;light.Parent=lamp
            end
        end
    end
    -- Pavillon d'observation couvert, accessible en toute saison.
    for _,x in ipairs({-12,12}) do
        for _,z in ipairs({-46,-31}) do
            block(m,"Poteau pavillon",base,Vector3.new(x,5,z),Vector3.new(0.9,9.3,0.9),NAVY,Enum.Material.Metal,true)
        end
    end
    block(m,"Toiture du pavillon",base,Vector3.new(0,9.8,-38.5),Vector3.new(28,0.75,19),COPPER,Enum.Material.Metal,false)
    for _,x in ipairs({-10,10}) do
        block(m,"Plante du quai",base,Vector3.new(x,1.9,-27),Vector3.new(3,2.4,3),Color3.fromRGB(82,144,113),Enum.Material.Grass,false)
    end
    local monument=block(m,"Orbe maritime",base,Vector3.new(0,5.3,-41),Vector3.new(4,4,4),WATER,Enum.Material.Glass,false)
    monument.Shape=Enum.PartType.Ball
    local tablet=block(m,"Borne maritime",base,Vector3.new(0,2.5,-28),Vector3.new(3.3,4.4,2.2),NAVY,Enum.Material.Metal,true)
    tablet:SetAttribute("KinStubInteractionId",string.format("city.waterfront.%02d.guide",index))
    tablet:SetAttribute("KinStubCapabilityId","future.waterfront.discovery")
    tablet:SetAttribute("KinStubTitle","Découvertes maritimes")
    F.prompt(tablet,"Découvrir","Quai de Kin City")
    -- Accès au quai depuis le rebord, sans téléportation.
    return m
end

function Waterfront.make(city)
    local root=F.folder(city,"Promenade lacustre et quais")
    for i=1,12 do
        local theta=(i-1)*2*math.pi/12+math.pi/24
        pier(root,i,theta)
    end
    root:SetAttribute("KinPiersCreated",12)
    return root
end
return Waterfront

]])
source(server,"Wildlife","ModuleScript",[[
--!strict
-- Oiseaux procéduraux en vol, environnement vivant sans modèles tiers.
local TweenService=game:GetService("TweenService")
local F=require(script.Parent.Factory)
local Presence=require(script.Parent.ViewerPresenceV21)
local Wildlife={}
local sky={Color3.fromRGB(245,233,198),Color3.fromRGB(65,85,94),Color3.fromRGB(175,182,181)}
function Wildlife.make(city)
    local folder=F.folder(city,"Oiseaux et vie naturelle")
    for n=1,14 do
        local bird=Instance.new("Model")
        bird.Name="Oiseau "..n
        bird:SetAttribute("KinBirdIndex",n)
        bird.Parent=folder
        local root=F.part(bird,"Pivot",Vector3.new(.4,.4,.4),CFrame.new(),sky[(n-1)%#sky+1])
        root.Transparency=1;root.CanCollide=false
        bird.PrimaryPart=root
        local body=F.part(bird,"Corps",Vector3.new(1,0.45,2),CFrame.new(),sky[(n-1)%#sky+1])
        body.Shape=Enum.PartType.Ball;body.CanCollide=false
        for _,s in ipairs({-1,1}) do
            local wing=F.part(bird,s<0 and "Aile gauche" or "Aile droite",Vector3.new(2.6,0.18,0.9),CFrame.new(s*1.4,0,0),sky[(n-1)%#sky+1])
            wing.CanCollide=false
        end
        local a=n*2.399963
        local radius=100+(n%4)*25
        bird:PivotTo(CFrame.new(math.cos(a)*radius,36+(n%3)*12,math.sin(a)*radius))
    end
    return folder
end
function Wildlife.start(world)
    local city=world:FindFirstChild("Ville")
    local birds=city and city:FindFirstChild("Oiseaux et vie naturelle")
    if not birds then return end
    for _,m in ipairs(birds:GetChildren()) do
        local n=m:GetAttribute("KinBirdIndex")
        if n then
            task.spawn(function()
                local radius=100+(n%4)*25
                local angle=n*2.399963
                local altitude=36+(n%3)*12
                local wave=0
                while m.Parent and world.Parent do
                    if not Presence.near(m:GetPivot().Position,255) then
                        task.wait(3)
                        continue
                    end
                    local nextAngle=angle+0.43
                    local target=CFrame.new(math.cos(nextAngle)*radius,altitude,math.sin(nextAngle)*radius)*CFrame.Angles(0,-nextAngle+math.pi/2,0)
                    local current=Instance.new("CFrameValue")
                    current.Value=m:GetPivot()
                    local last=0
                    local connection=current.Changed:Connect(function(cf)
                        if not m.Parent then return end
                        if os.clock()-last<0.12 then return end
                        last=os.clock()
                        m:PivotTo(cf)
                        wave+=0.65
                        for _,s in ipairs({-1,1}) do
                            local wing=m:FindFirstChild(s<0 and "Aile gauche" or "Aile droite")
                            if wing then wing.CFrame=cf*CFrame.new(s*1.4,0,0)*CFrame.Angles(0,0,s*math.sin(wave)*0.45) end
                        end
                    end)
                    TweenService:Create(current,TweenInfo.new(6+n%4,Enum.EasingStyle.Linear),{Value=target}):Play()
                    task.wait(6+n%4)
                    connection:Disconnect()
                    if m.Parent then m:PivotTo(target) end
                    current:Destroy()
                    angle=nextAngle
                end
            end)
        end
    end
end
return Wildlife

]])
source(server,"WorldAmbience","ModuleScript",[[
--!strict
-- Cycle solaire continu, sans saut brutal du soir au matin.
-- Une journée virtuelle dure environ 24 minutes réelles.
local Lighting=game:GetService("Lighting")
local Ambience={}
function Ambience.start(world)
    task.spawn(function()
        local clock=13.8
        while world.Parent do
            Lighting.ClockTime=clock
            clock=(clock+0.10)%24
            task.wait(6)
        end
    end)
end
return Ambience

]])
source(server,"WorldBuildDiagnosticsV25","ModuleScript",[[
--!strict
-- Diagnostic factuel de construction pour la console Roblox Studio.
-- Aucun benchmark externe et aucun objectif FPS inventé.
local Diagnostics={}
function Diagnostics.capture(world,startClock,profile)
    local stats={parts=0,meshes=0,lights=0,prompts=0,materialFinishes=0,optionalDetails=0,seats=0}
    for _,instance in ipairs(world:GetDescendants()) do
        if instance:IsA("BasePart") then
            stats.parts+=1
            if instance:IsA("MeshPart") then stats.meshes+=1 end
            if instance:IsA("Seat") then stats.seats+=1 end
            if instance:GetAttribute("KinOptionalDetail")==true then stats.optionalDetails+=1 end
        elseif instance:IsA("PointLight") or instance:IsA("SpotLight") or instance:IsA("SurfaceLight") then
            stats.lights+=1
        elseif instance:IsA("ProximityPrompt") then
            stats.prompts+=1
        elseif instance:IsA("SurfaceAppearance") then
            stats.materialFinishes+=1
        end
    end
    local seconds=math.max(0,os.clock()-startClock)
    world:SetAttribute("KinBuildSeconds",math.floor(seconds*1000+0.5)/1000)
    world:SetAttribute("KinGeneratedParts",stats.parts)
    world:SetAttribute("KinGeneratedMeshes",stats.meshes)
    world:SetAttribute("KinGeneratedLights",stats.lights)
    world:SetAttribute("KinGeneratedPrompts",stats.prompts)
    world:SetAttribute("KinGeneratedMaterials",stats.materialFinishes)
    world:SetAttribute("KinGeneratedSeats",stats.seats)
    world:SetAttribute("KinGeneratedOptionalDetails",stats.optionalDetails)
    world:SetAttribute("KinBuildVisualProfile",profile)
    print(string.format("KIN CITY v25 build : %.2fs / %d parts / %d meshes / %d lumières / %d prompts / %d finitions PBR / %d détails facultatifs / profil %s",
        seconds,stats.parts,stats.meshes,stats.lights,stats.prompts,stats.materialFinishes,
        stats.optionalDetails,profile))
    return stats
end
return Diagnostics

]])
source(server,"WorldBuilder","ModuleScript",[[
--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local Shared=ReplicatedStorage:WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local VisualConfig=require(Shared:WaitForChild("VisualConfig"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local BuildIdentity=require(Shared:WaitForChild("BuildIdentity"))
local CanonicalInteractions=require(script.Parent.CanonicalInteractions)
local Spatial=require(script.Parent.Spatial)
local CityGenerator=require(script.Parent.CityGenerator)
local InteriorGenerator=require(script.Parent.InteriorGenerator)
local Factory=require(script.Parent.Factory)
local Neighborhoods=require(script.Parent.Neighborhoods)
local SkyDirector=require(script.Parent.SkyDirector)
local TransitNodes=require(script.Parent.TransitNodes)
local Tramways=require(script.Parent.Tramways)
local IslandFerries=require(script.Parent.IslandFerries)
local BoulevardBuses=require(script.Parent.BoulevardBuses)
local WorldBuildDiagnosticsV25=require(script.Parent.WorldBuildDiagnosticsV25)
local PlacePortalsV26=require(script.Parent.PlacePortalsV26)
local WorldBuilder={}
-- Version de fabrication indépendante des manifestes : toute modification de géométrie
-- doit invalider une scène d'édition issue d'une précédente version du moteur.
local WORLD_BUILD_REVISION="construction-v27.0.0-"..VisualConfig.profile.."-"..BuildIdentity.sha256

-- Réutilise la scène déjà construite en mode Édition par l'installateur.
-- En session Play, le clonage automatique du Workspace évite une génération complète
-- tant que les données canoniques ne changent pas. Les régénérations de WorldEditor
-- continuent d'utiliser build() sans argument et reconstruisent explicitement.
local function rehydrate(world)
    if not world or world:GetAttribute("KinBuildState")~="Ready"
        or world:GetAttribute("KinCompilerSha")~=Plan.canonical_sha256
        or world:GetAttribute("KinWorldBuilderRevision")~=WORLD_BUILD_REVISION
        or world:GetAttribute("KinActivePlace")~=Spatial.currentPlace()
        or world:GetAttribute("KinRoutingMode")~=Spatial.mode() then return nil end
    local current=Spatial.currentPlace()
    local mode=Spatial.mode()
    local prompts={}
    local anchors={}
    local doors={}
    local interactions={}
    for _,d in ipairs(Plan.doors) do doors[d.door_id]=d end
    for _,i in ipairs(Plan.interactions) do interactions[i.interaction_id]=i end
    for _,part in ipairs(world:GetDescendants()) do
        if part:IsA("BasePart") then
            local key=part:GetAttribute("KinAnchorId")
            local place=part:GetAttribute("KinPlaceKey")
            if key and place and part.Parent and part.Parent.Name=="Points de connexion" then
                anchors[place.."/"..key]=part
            end
            for _,prompt in ipairs(part:GetChildren()) do
                if prompt:IsA("ProximityPrompt") then
                    local door=doors[part:GetAttribute("KinDoorId")]
                    local interaction=interactions[part:GetAttribute("KinInteractionId")]
                    if door then
                        prompts[prompt]={kind="door",data=door}
                    elseif interaction then
                        prompts[prompt]={kind="interaction",data=interaction}
                    elseif part:GetAttribute("KinLiftId") then
                        prompts[prompt]={kind="lift",data={
                            lift_id=part:GetAttribute("KinLiftId"),
                            place_key=part:GetAttribute("KinLiftPlaceKey"),
                            destination=part:GetAttribute("KinLiftPosition"),
                        }}
                    elseif part:GetAttribute("KinVistaId") then
                        prompts[prompt]={kind="vista",data={
                            vista_id=part:GetAttribute("KinVistaId"),
                            title=part:GetAttribute("KinVistaTitle"),
                            camera_position=part:GetAttribute("KinVistaCameraPosition"),
                            look_at=part:GetAttribute("KinVistaLookAt"),
                        }}
                    elseif part:GetAttribute("KinShuttleId") then
                        prompts[prompt]={kind="shuttle",data={
                            shuttle_id=part:GetAttribute("KinShuttleId"),
                            anchor=part:GetAttribute("KinShuttleAnchor"),
                        }}
                    elseif part:GetAttribute("KinStubInteractionId") then
                        prompts[prompt]={kind="ambient",data={
                            interaction_id=part:GetAttribute("KinStubInteractionId"),
                            capability_id=part:GetAttribute("KinStubCapabilityId") or "future.local",
                            title=part:GetAttribute("KinStubTitle") or "Kin City",
                        }}
                    end
                end
            end
        end
    end
    -- Une scène sans objets canoniques ne peut pas être réutilisée silencieusement.
    local doorsFound={}
    local interactionsFound={}
    for _,record in pairs(prompts) do
        if record.kind=="door" then doorsFound[record.data.door_id]=true end
        if record.kind=="interaction" then interactionsFound[record.data.interaction_id]=true end
    end
    for _,door in ipairs(Plan.doors) do
        if mode=="LOCAL_UNIVERSE" or door.source_place_key==current then
            if not doorsFound[door.door_id] then return nil end
        end
    end
    for _,interaction in ipairs(Plan.interactions) do
        if mode=="LOCAL_UNIVERSE" or interaction.place_key==current then
            if not interactionsFound[interaction.interaction_id] then return nil end
        end
    end
    for _,place in ipairs(Plan.places) do
        if mode=="LOCAL_UNIVERSE" or place.place_key==current then
            for _,anchor in ipairs(place.anchors) do
                if not anchors[place.place_key.."/"..anchor.anchor_id] then return nil end
            end
        end
    end
    SkyDirector.configure()
    return {world=world,prompts=prompts,anchors=anchors,currentPlace=current,mode=mode,reused=true}
end

function WorldBuilder.build(reuseExisting)
    local old=workspace:FindFirstChild("KinCityGenerated")
    if reuseExisting and old then
        local restored=rehydrate(old)
        if restored then return restored end
    end
    if old then old:Destroy() end
    local startClock=os.clock()
    local world=Instance.new("Folder")
    world.Name="KinCityGenerated"
    world:SetAttribute("KinBuildState","Building")
    world:SetAttribute("KinCompilerSha",Plan.canonical_sha256)
    world:SetAttribute("KinWorldBuilderRevision",WORLD_BUILD_REVISION)
    world:SetAttribute("KinMode","WORLD_STUB")
    world:SetAttribute("KinActivePlace",Spatial.currentPlace())
    world:SetAttribute("KinRoutingMode",Spatial.mode())
    world.Parent=workspace
    local routing=Spatial.mode()
    local active=Spatial.currentPlace()
    local named={}
    for _,b in ipairs(Buildings) do named[b.building_id]=b end
    if routing=="LOCAL_UNIVERSE" or active=="city" then
        CityGenerator.make(world,Plan,named)
    end
    local inside=Factory.folder(world,"Bâtiments visitables")
    for _,place in ipairs(Plan.places) do
        if place.place_key~="city" and (routing=="LOCAL_UNIVERSE" or place.place_key==active) then
            local style=Spatial.styleForPlace(place.place_key)
            InteriorGenerator.make(inside,place,style)
        end
    end
    local promptRecords={}
    if routing=="LOCAL_UNIVERSE" or active=="city" then
        local cityFolder=world:FindFirstChild("Ville")
        if cityFolder then
            TransitNodes.make(cityFolder,Plan,named)
            Tramways.build(cityFolder)
            IslandFerries.build(cityFolder)
            BoulevardBuses.build(cityFolder)
            local neighborhoodPrompts=Neighborhoods.make(cityFolder,Plan)
            for prompt,record in pairs(neighborhoodPrompts) do promptRecords[prompt]=record end
        end
    end
    local anchorParts={}
    local binders=Factory.folder(world,"Points de connexion")
    local placed={}
    local function validPlace(key)
        return routing=="LOCAL_UNIVERSE" or key==active
    end
    for _,place in ipairs(Plan.places) do
        if validPlace(place.place_key) then
            for _,a in ipairs(place.anchors) do
                local pos=Spatial.position(place.place_key,a.position_studs)
                -- Ancre serveur invisible. Unique source de vérité pour le retour de portes.
                local anchor=Factory.part(binders,a.anchor_id,Vector3.new(0.5,0.5,0.5),CFrame.new(pos),Color3.new(1,1,1))
                anchor.Transparency=1;anchor.CanCollide=false;anchor.CanTouch=false
                anchor:SetAttribute("KinPlaceKey",place.place_key)
                anchor:SetAttribute("KinAnchorId",a.anchor_id)
                anchorParts[place.place_key.."/"..a.anchor_id]=anchor
            end
        end
    end
    for _,door in ipairs(Plan.doors) do
        if validPlace(door.source_place_key) then
            local a=Spatial.anchor(door.source_place_key,door.source_anchor_id)
            assert(a,"Missing source anchor: "..door.source_anchor_id)
            local frame=Spatial.anchorCFrame(door.source_place_key,door.source_anchor_id)
            local doorPart=Factory.part(binders,"Porte : "..door.door_id,Vector3.new(7,7.2,0.85),frame*CFrame.new(0,0.5,0),Color3.fromRGB(66,92,101),Enum.Material.Metal)
            doorPart.CanCollide=false
            doorPart:SetAttribute("KinDoorId",door.door_id)
            local enter=(door.source_place_key=="city")
            local prompt=Factory.prompt(doorPart,if enter then "Entrer" else "Sortir",if enter then "Bâtiment" else "Retour à la ville")
            promptRecords[prompt]={kind="door",data=door}
            PlacePortalsV26.decorate(binders,door,frame,routing)
            placed[door.door_id]=true
        end
    end
    -- Contrat partagé avec WorldEditor : après une génération complète ET partielle,
    -- réinstaller exactement les mêmes interactions sur le mobilier physique.
    for _,place in ipairs(Plan.places) do
        if place.place_key~="city" and validPlace(place.place_key) then
            local model=inside:FindFirstChild("Intérieur — "..place.place_key)
            CanonicalInteractions.bindPlace(model,place.place_key,Plan.interactions,promptRecords)
        end
    end
    -- Nouveau mobilier dynamique : la construction déclare les interactions à l'objet,
    -- et le routeur central lie les invites sans scripts copiés sur les meubles.
    for _,piece in ipairs(world:GetDescendants()) do
        if piece:IsA("ProximityPrompt") and not promptRecords[piece] then
            local host=piece.Parent
            if host and host:IsA("BasePart") then
                local liftId=host:GetAttribute("KinLiftId")
                local interactionId=host:GetAttribute("KinStubInteractionId")
                if liftId then
                    promptRecords[piece]={kind="lift",data={
                        lift_id=liftId,
                        place_key=host:GetAttribute("KinLiftPlaceKey"),
                        destination=host:GetAttribute("KinLiftPosition"),
                    }}
                elseif host:GetAttribute("KinVistaId") then
                    promptRecords[piece]={kind="vista",data={
                        vista_id=host:GetAttribute("KinVistaId"),
                        title=host:GetAttribute("KinVistaTitle"),
                        camera_position=host:GetAttribute("KinVistaCameraPosition"),
                        look_at=host:GetAttribute("KinVistaLookAt"),
                    }}
                elseif host:GetAttribute("KinShuttleId") then
                    promptRecords[piece]={kind="shuttle",data={
                        shuttle_id=host:GetAttribute("KinShuttleId"),
                        anchor=host:GetAttribute("KinShuttleAnchor"),
                    }}
                elseif interactionId then
                    promptRecords[piece]={kind="ambient",data={
                        interaction_id=interactionId,
                        capability_id=host:GetAttribute("KinStubCapabilityId") or "future.local",
                        title=host:GetAttribute("KinStubTitle") or "Kin City",
                    }}
                end
            end
        end
    end
    SkyDirector.configure()
    workspace.FallenPartsDestroyHeight=-100
    -- Écrire Ready uniquement lorsque tous les objets et prompts ont été produits.
    -- Aucune transaction/rollback : la génération reste directe conformément au choix produit.
    local expectedDoors=0
    local expectedInteractions=0
    for _,door in ipairs(Plan.doors) do
        if validPlace(door.source_place_key) then expectedDoors+=1 end
    end
    for _,interaction in ipairs(Plan.interactions) do
        if validPlace(interaction.place_key) then expectedInteractions+=1 end
    end
    world:SetAttribute("KinCanonicalDoorCount",expectedDoors)
    world:SetAttribute("KinCanonicalInteractionCount",expectedInteractions)
    world:SetAttribute("KinSeparatedWorld",routing~="LOCAL_UNIVERSE")
    WorldBuildDiagnosticsV25.capture(world,startClock,VisualConfig.profile)
    world:SetAttribute("KinBuildState","Ready")
    return {world=world,prompts=promptRecords,anchors=anchorParts,currentPlace=active,mode=routing}
end
return WorldBuilder

]])
source(server,"WorldEditor","ModuleScript",[[
--!strict
-- Outils de génération incrémentale à utiliser depuis la Command Bar de Studio.
-- Le serveur actif reconstruit le monde au démarrage d'une session Play.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local Spatial=require(script.Parent.Spatial)
local Facade=require(script.Parent.FacadeGenerator)
local Interiors=require(script.Parent.InteriorGenerator)
local FullBuilder=require(script.Parent.WorldBuilder)
local CanonicalInteractions=require(script.Parent.CanonicalInteractions)
local Editor={}
local structures={}
local labels={}
local places={}
for _,b in ipairs(Plan.structures) do structures[b.building_id]=b end
for _,b in ipairs(Buildings) do labels[b.building_id]=b end
for _,p in ipairs(Plan.places) do places[p.place_key]=p end
local function generated()
    return workspace:FindFirstChild("KinCityGenerated")
end
function Editor.regenerateAll()
    return FullBuilder.build()
end
function Editor.regenerateFacade(buildingId)
    local structure=structures[buildingId]
    local b=labels[buildingId]
    assert(structure and b,"ID de bâtiment inconnu: "..tostring(buildingId))
    local world=generated()
    assert(world,"Installer Kin City avant une régénération sélective")
    local city=world:FindFirstChild("Ville")
    assert(city,"Ville absente (Place non central)")
    local folder=city:FindFirstChild("Bâtiments")
    assert(folder,"Dossier des façades absent")
    world:SetAttribute("KinBuildState","Editing")
    for _,m in ipairs(folder:GetChildren()) do
        if m:GetAttribute("KinBuildingId")==buildingId then m:Destroy() end
    end
    local result=Facade.make(folder,structure,b,Plan.styles[structure.style_id])
    world:SetAttribute("KinBuildState","Ready")
    return result
end
function Editor.regenerateInterior(placeKey)
    assert(placeKey~="city","La ville n'est pas un intérieur")
    local place=places[placeKey]
    assert(place,"Place inconnu: "..tostring(placeKey))
    assert(Spatial.mode()=="LOCAL_UNIVERSE" or Spatial.currentPlace()==placeKey,
        "Cet intérieur appartient à une autre Place; ouvrir son installateur dédié")
    local world=generated()
    assert(world,"Installer Kin City avant une régénération sélective")
    local interiors=world:FindFirstChild("Bâtiments visitables")
    assert(interiors,"Dossier intérieur absent")
    local old=interiors:FindFirstChild("Intérieur — "..placeKey)
    world:SetAttribute("KinBuildState","Editing")
    if old then old:Destroy() end
    local style=Spatial.styleForPlace(placeKey)
    local model=Interiors.make(interiors,place,style)
    CanonicalInteractions.bindPlace(model,placeKey,Plan.interactions,nil)
    world:SetAttribute("KinBuildState","Ready")
    return model
end
return Editor

]])
source(client,"ArchipelagoProgressHud","ModuleScript",[[
--!strict
-- Écran discret de progression locale; compatible souris et tactile.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local Hud={}
function Hud.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityProgressV9";gui.ResetOnSpawn=false;gui.DisplayOrder=4
    gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton")
    toggle.Name="CarnetArchipel"
    toggle.Size=UDim2.fromOffset(152,36)
    toggle.Position=UDim2.new(0,16,1,-65)
    toggle.BackgroundColor3=Color3.fromRGB(29,67,77)
    toggle.TextColor3=Color3.fromRGB(238,229,197)
    toggle.Font=Enum.Font.GothamBold;toggle.TextSize=12
    toggle.Text="CARNET DES VOYAGES"
    toggle.Parent=gui
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,8);round.Parent=toggle
    local panel=Instance.new("Frame")
    panel.Name="Carnet de voyage"
    panel.Size=UDim2.fromOffset(254,135)
    panel.Position=UDim2.new(0,16,1,-210)
    panel.BackgroundColor3=Color3.fromRGB(21,45,55)
    panel.Visible=false;panel.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,11);corner.Parent=panel
    local heading=Instance.new("TextLabel")
    heading.BackgroundTransparency=1;heading.Position=UDim2.fromOffset(12,7)
    heading.Size=UDim2.fromOffset(233,24);heading.Text="EXPLORATION LOCALE"
    heading.TextColor3=Color3.fromRGB(242,225,169);heading.TextSize=15
    heading.Font=Enum.Font.GothamBold;heading.Parent=panel
    local stats=Instance.new("TextLabel")
    stats.Name="Progression";stats.BackgroundTransparency=1
    stats.Size=UDim2.fromOffset(228,88);stats.Position=UDim2.fromOffset(13,34)
    stats.TextColor3=Color3.fromRGB(230,239,232)
    stats.Font=Enum.Font.Gotham;stats.TextSize=14
    stats.TextXAlignment=Enum.TextXAlignment.Left;stats.TextYAlignment=Enum.TextYAlignment.Top
    stats.TextWrapped=true;stats.Parent=panel
    local function update()
        stats.Text=string.format("Marinas : %d / 2\nSalles des îles : %d / 12\nHaltes : %d / 24\nProgression de cette session seulement",
            player:GetAttribute("KinMarinaDiscoveries") or 0,
            player:GetAttribute("KinAnnexRoomsVisited") or 0,
            player:GetAttribute("KinIslandTrailVisits") or 0)
    end
    toggle.Activated:Connect(function()panel.Visible=not panel.Visible end)
    for _,k in ipairs({"KinMarinaDiscoveries","KinAnnexRoomsVisited","KinIslandTrailVisits"}) do
        player:GetAttributeChangedSignal(k):Connect(update)
    end
    update()
end
return Hud

]])
source(client,"BoulevardBusHud","ModuleScript",[[
--!strict
-- Interface des minibus collectifs. Tactile, manette et clavier (sans raccourci requis).
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Hud={}
function Hud.start(remote)
    local player=Players.LocalPlayer
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityBoulevardHud";gui.ResetOnSpawn=false;gui.DisplayOrder=23
    gui.Parent=player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.Size=UDim2.fromOffset(320,86)
    panel.AnchorPoint=Vector2.new(0.5,0)
    panel.Position=UDim2.new(0.5,0,0,168)
    panel.BackgroundColor3=Color3.fromRGB(33,73,79)
    panel.BackgroundTransparency=0.06;panel.Visible=false;panel.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,11);corner.Parent=panel
    local label=Instance.new("TextLabel")
    label.BackgroundTransparency=1;label.Size=UDim2.new(1,-20,0,30)
    label.Position=UDim2.fromOffset(10,4)
    label.Font=Enum.Font.GothamBold;label.TextSize=15;label.TextXAlignment=Enum.TextXAlignment.Left
    label.TextColor3=Color3.fromRGB(241,224,175);label.Text="NAVETTE ÉLECTRIQUE";label.Parent=panel
    local detail=Instance.new("TextLabel")
    detail.BackgroundTransparency=1;detail.Position=UDim2.fromOffset(10,34)
    detail.Size=UDim2.new(1,-20,0,45);detail.Font=Enum.Font.Gotham
    detail.TextSize=13;detail.TextWrapped=true;detail.TextXAlignment=Enum.TextXAlignment.Left
    detail.TextColor3=Color3.fromRGB(231,243,238);detail.Parent=panel
    local current="";local active=false;local state="boarding";local remaining=0;local total=0;local count=0
    local function show()
        if not active then return end
        if state=="boarding" then
            detail.Text=string.format("%s · %d/%d passagers · départ dans %ds",current,count,total,math.ceil(remaining))
        else
            detail.Text=string.format("En route vers %s · %ds avant l'arrivée",current,math.ceil(remaining))
        end
    end
    remote.OnClientEvent:Connect(function(event)
        if type(event)~="table" or event.kind~="boulevard.bus.v11" then return end
        state=tostring(event.state or "boarding")
        if state=="arrive" or state=="cancel" then
            active=false;panel.Visible=false;return
        end
        current=tostring(event.destination or "le quartier")
        remaining=tonumber(event.duration) or 0
        count=tonumber(event.count) or 1;total=tonumber(event.capacity) or 8
        active=true;panel.Visible=true;show()
    end)
    RunService.RenderStepped:Connect(function(dt)
        if active then remaining=math.max(0,remaining-dt);show() end
    end)
end
return Hud

]])
source(client,"CitizenAnimationV21","ModuleScript",[[
--!strict
-- Animation de proximité des PNJ. Le serveur publie l'activité, le client anime
-- uniquement les rigs visibles et proches. Compatible Motor6D / AnimationConstraint.
-- Aucun asset d'animation Roblox requis, aucune modification des avatars joueurs.
local CollectionService=game:GetService("CollectionService")
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Animator={}
local TAG="KinCityAnimatedNPC"
local MAX_DISTANCE=155
local UPDATE_HZ=24
local LOD_CHECK_SECONDS=0.7

local poses={
    walk={shoulder=0.30,hip=0.39,waist=0.045,neck=0.035},
    idle={shoulder=0.035,hip=0,waist=0.025,neck=0.045},
    read={shoulder=0.34,hip=0,waist=0.09,neck=-0.13},
    garden={shoulder=0.48,hip=0.02,waist=0.12,neck=-0.10},
    greet={shoulder=0.55,hip=0,waist=0.035,neck=0.11},
    observe={shoulder=0.06,hip=0,waist=0.02,neck=0.14},
}

local function rigJoints(model:Model)
    local joints={}
    for _,item in ipairs(model:GetDescendants()) do
        if item:IsA("Motor6D") or item:IsA("AnimationConstraint") then
            if item.Name=="RightShoulder" or item.Name=="LeftShoulder" or item.Name=="RightHip" or item.Name=="LeftHip" or item.Name=="Waist" or item.Name=="Neck" then
                joints[item.Name]=item
            end
        end
    end
    return joints
end

function Animator.start()
    local npcs={}
    local function register(model:Instance)
        if not model:IsA("Model") or npcs[model] then return end
        npcs[model]={joints=rigJoints(model),enabled=false}
    end
    for _,model in ipairs(CollectionService:GetTagged(TAG)) do register(model) end
    CollectionService:GetInstanceAddedSignal(TAG):Connect(register)
    CollectionService:GetInstanceRemovedSignal(TAG):Connect(function(model)
        npcs[model]=nil
    end)

    local clock=0
    local lodClock=0
    local function distanceFromViewer(model:Model,camera:Camera?,avatarRoot:BasePart?):number
        local root=model:FindFirstChild("HumanoidRootPart")
        if not root or not root:IsA("BasePart") then return math.huge end
        local cameraDistance=if camera then (root.Position-camera.CFrame.Position).Magnitude else math.huge
        local playerDistance=if avatarRoot then (root.Position-avatarRoot.Position).Magnitude else math.huge
        return math.min(cameraDistance,playerDistance)
    end

    RunService.PreSimulation:Connect(function(dt)
        clock+=dt
        lodClock+=dt
        if lodClock>=LOD_CHECK_SECONDS then
            lodClock=0
            local camera=workspace.CurrentCamera
            local character=Players.LocalPlayer.Character
            local root=character and character:FindFirstChild("HumanoidRootPart")
            local avatarRoot=if root and root:IsA("BasePart") then root else nil
            for model,record in pairs(npcs) do
                if not model.Parent then
                    npcs[model]=nil
                else
                    if next(record.joints)==nil then record.joints=rigJoints(model) end
                    local quality=Players.LocalPlayer:GetAttribute("KinCityLocalQuality")
                    local radius=if quality=="LITE" then 80 elseif quality=="SHOWCASE" then 190 else MAX_DISTANCE
                    local visible=distanceFromViewer(model,camera,avatarRoot)<radius
                    if record.enabled and not visible then
                        for _,joint in pairs(record.joints) do
                            if joint.Parent then joint.Transform=CFrame.identity end
                        end
                    end
                    record.enabled=visible
                end
            end
        end
        local hz=if Players.LocalPlayer:GetAttribute("KinCityLocalQuality")=="LITE" then 12 else UPDATE_HZ
        if clock<1/hz then return end
        clock=0
        local now=workspace:GetServerTimeNow()
        for model,record in pairs(npcs) do
            if record.enabled then
                local state=model:GetAttribute("KinNPCMotion") or "idle"
                local preset=poses[state] or poses.idle
                local phase=now*(state=="walk" and 7.0 or 2.1)+(model:GetAttribute("KinNPCPhase") or 0)
                local swing=math.sin(phase)
                for name,joint in pairs(record.joints) do
                    if joint.Parent then
                        local offset=CFrame.identity
                        if name=="RightShoulder" then
                            offset=CFrame.Angles((state=="walk" and swing or 0.30+0.12*swing)*preset.shoulder,0,-0.04)
                        elseif name=="LeftShoulder" then
                            offset=CFrame.Angles((state=="walk" and -swing or 0.22-0.12*swing)*preset.shoulder,0,0.04)
                        elseif name=="RightHip" then
                            offset=CFrame.Angles(-swing*preset.hip,0,0)
                        elseif name=="LeftHip" then
                            offset=CFrame.Angles(swing*preset.hip,0,0)
                        elseif name=="Waist" then
                            offset=CFrame.Angles(preset.waist+0.018*swing,0,0)
                        elseif name=="Neck" then
                            offset=CFrame.Angles(preset.neck,0,0.06*math.sin(phase*0.35))
                        end
                        -- Nos PNJ n'utilisent aucun AnimationTrack : remplacer l'offset
                        -- évite toute accumulation d'angle sur les deux types de joint.
                        joint.Transform=offset
                    end
                end
            end
        end
    end)
end
return Animator

]])
source(client,"CooperativeHud","ModuleScript",[[
--!strict
-- Notification non bloquante : l'exploration continue pendant l'activité.
local Players=game:GetService("Players")
local CooperativeHud={}
function CooperativeHud.start(remote)
    local ui=Instance.new("ScreenGui")
    ui.Name="KinCityCooperativeActivity"
    ui.ResetOnSpawn=false
    ui.DisplayOrder=13
    ui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local box=Instance.new("Frame")
    box.Name="CoopNotice";box.Size=UDim2.new(0.75,0,0,85)
    box.AnchorPoint=Vector2.new(0.5,0)
    box.Position=UDim2.new(0.5,0,0,70)
    box.BackgroundColor3=Color3.fromRGB(32,66,73)
    box.Visible=false;box.Parent=ui
    local constraint=Instance.new("UISizeConstraint")
    constraint.MaxSize=Vector2.new(480,90)
    constraint.Parent=box
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,12);corner.Parent=box
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-24,0,25)
    title.Position=UDim2.fromOffset(12,7)
    title.BackgroundTransparency=1
    title.TextColor3=Color3.fromRGB(238,199,121)
    title.Font=Enum.Font.GothamBold
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.TextSize=16;title.Text="ACTIVITÉ COOPÉRATIVE";title.Parent=box
    local body=Instance.new("TextLabel")
    body.Size=UDim2.new(1,-24,0,43)
    body.Position=UDim2.fromOffset(12,33)
    body.BackgroundTransparency=1
    body.TextColor3=Color3.fromRGB(242,241,222)
    body.TextXAlignment=Enum.TextXAlignment.Left
    body.TextWrapped=true
    body.TextSize=15;body.Font=Enum.Font.Gotham
    body.Parent=box
    local sequence=0
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="coop.update.v1" then return end
        sequence+=1
        local current=sequence
        body.Text=payload.text or "Deux explorateurs peuvent participer."
        box.Visible=true
        task.delay(5.5,function()
            if current==sequence and box.Parent then box.Visible=false end
        end)
    end)
end
return CooperativeHud

]])
source(client,"CrystalDetailLOD","ModuleScript",[[
--!strict
-- LOD LOCAL des ornements décoratifs : aucune modification des structures,
-- portes, prompts ou mécanismes. Les parties optionnelles sont non-collidantes.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Visual=require(RS:WaitForChild("KinCityShared"):WaitForChild("VisualConfig"))
local LOD={}
local player=Players.LocalPlayer

function LOD.start()
    local world=workspace:WaitForChild("KinCityGenerated",30)
    if not world then return end
    local optional={}
    local function add(inst)
        if inst:IsA("BasePart") and inst:GetAttribute("KinOptionalDetail")==true then
            optional[inst]=true
        end
    end
    local function remove(inst)
        if optional[inst] then optional[inst]=nil end
    end
    -- Tout objet tagué est purement visuel : le gameplay n'en dépend pas.
    for _,inst in ipairs(world:GetDescendants()) do add(inst) end
    world.DescendantAdded:Connect(add)
    world.DescendantRemoving:Connect(remove)
    local farDistance=if Visual.profile=="LITE" then 165 elseif Visual.profile=="SHOWCASE" then 570 else 340
    task.spawn(function()
        while world.Parent do
            local char=player.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos=root.Position
                -- La caméra peut observer un panorama distant pendant que l'avatar reste en place.
                local camera=workspace.CurrentCamera
                local viewPos=if camera then camera.CFrame.Position else pos
                local preference=player:GetAttribute("KinCityLocalQuality")
                local effectiveFar=if preference=="LITE" then 150 elseif preference=="SHOWCASE" then 540 else farDistance
                local effectiveNear=effectiveFar-35
                local checked=0
                for part in pairs(optional) do
                    if part.Parent then
                        local avatarDelta=part.Position-pos
                        local viewDelta=part.Position-viewPos
                        local dist=math.min(avatarDelta:Dot(avatarDelta),viewDelta:Dot(viewDelta))
                        if part.LocalTransparencyModifier<1 and dist>effectiveFar*effectiveFar then
                            part.LocalTransparencyModifier=1
                        elseif part.LocalTransparencyModifier>=1 and dist<effectiveNear*effectiveNear then
                            part.LocalTransparencyModifier=0
                        end
                    else
                        optional[part]=nil
                    end
                    checked+=1
                    if checked%180==0 then task.wait() end
                end
            end
            task.wait(1.8)
        end
    end)
end
return LOD

]])
source(client,"ExplorationJournal","ModuleScript",[[
--!strict
-- Carnet de promenade local. Aucun score, compte kOA ou stockage serveur.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Buildings=require(Shared:WaitForChild("Buildings"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local player=Players.LocalPlayer
local Journal={}
local names={}
local visited={}
local keys={}
for _,b in ipairs(Buildings) do names[b.building_id]=b.name end
local seen={}
for _,door in ipairs(Plan.doors) do
    if door.source_place_key=="city" and not seen[door.destination_place_key] then
        seen[door.destination_place_key]=true
        table.insert(keys,{key=door.destination_place_key,name=names[door.building_id] or door.destination_place_key})
    end
end
table.sort(keys,function(a,b) return a.name<b.name end)
local function rounded(frame,n)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,n)
    c.Parent=frame
end
local function txt(parent,content,size,pos,sz,bold)
    local v=Instance.new("TextLabel")
    v.Size=size
    v.Position=pos
    v.BackgroundTransparency=1
    v.Text=content
    v.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    v.TextSize=sz
    v.TextColor3=Color3.fromRGB(244,241,227)
    v.TextWrapped=true
    v.TextXAlignment=Enum.TextXAlignment.Left
    v.Parent=parent
    return v
end
function Journal.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityCarnet"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=9
    gui.Parent=player:WaitForChild("PlayerGui")
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.fromOffset(140,38)
    btn.Position=UDim2.fromOffset(16,140)
    btn.BackgroundColor3=Color3.fromRGB(45,94,104)
    btn.TextColor3=Color3.fromRGB(241,238,220)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=13
    btn.Text="CARNET [J]"
    btn.Parent=gui
    rounded(btn,9)
    local panel=Instance.new("Frame")
    panel.Name="Carnet"
    panel.Size=UDim2.new(0,320,0,410)
    panel.Position=UDim2.fromOffset(16,190)
    panel.BackgroundColor3=Color3.fromRGB(25,48,58)
    panel.Visible=false
    panel.Parent=gui
    rounded(panel,13)
    local title=txt(panel,"MON CARNET DE KIN CITY",UDim2.new(1,-25,0,35),UDim2.fromOffset(14,12),16,true)
    local progress=txt(panel,"",UDim2.new(1,-25,0,45),UDim2.fromOffset(14,48),14,false)
    local subtitle=txt(panel,"Institutions à découvrir",UDim2.new(1,-25,0,22),UDim2.fromOffset(14,93),14,true)
    local entries={}
    for i,entry in ipairs(keys) do
        local row=txt(panel,"",UDim2.new(1,-26,0,32),UDim2.fromOffset(14,121+(i-1)*32),13,false)
        entries[i]=row
    end
    txt(panel,"Les visites sont conservées seulement pendant cette session. Les services restent à venir.",UDim2.new(1,-28,0,55),UDim2.fromOffset(14,355),12,false)
    local function redraw()
        local count=0
        for i,entry in ipairs(keys) do
            local done=visited[entry.key]
            if done then count+=1 end
            entries[i].Text=(done and "✓  " or "○  ")..entry.name
            entries[i].TextColor3=done and Color3.fromRGB(154,224,181) or Color3.fromRGB(223,223,216)
        end
        progress.Text=string.format("%d / %d institutions visitées",count,#keys)
    end
    local function capture()
        local zone=player:GetAttribute("KinZone")
        if zone and zone~="city" and not visited[zone] then
            visited[zone]=true
            redraw()
        end
    end
    local function flip() panel.Visible=not panel.Visible;capture() end
    btn.Activated:Connect(flip)
    UIS.InputBegan:Connect(function(key,processed)
        if not processed and key.KeyCode==Enum.KeyCode.J then flip() end
    end)
    player:GetAttributeChangedSignal("KinZone"):Connect(capture)
    redraw();capture()
end
return Journal

]])
source(client,"FerryGroupHud","ModuleScript",[[
--!strict
-- Panneau compact de ferry collectif, accessible au clavier et au tactile.
-- L'état provient uniquement du serveur. Aucun compteur ou promesse kOA.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Player=Players.LocalPlayer
local FerryHud={}
function FerryHud.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityFerryGroupHud"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=22
    gui.Parent=Player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.AnchorPoint=Vector2.new(0.5,0)
    panel.Position=UDim2.new(0.5,0,0,75)
    panel.Size=UDim2.fromOffset(322,82)
    panel.BackgroundColor3=Color3.fromRGB(24,59,72)
    panel.BackgroundTransparency=0.06
    panel.Visible=false
    panel.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,12)
    corner.Parent=panel
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-20,0,29)
    title.Position=UDim2.fromOffset(10,5)
    title.BackgroundTransparency=1
    title.Font=Enum.Font.GothamBold
    title.TextColor3=Color3.fromRGB(246,238,205)
    title.TextSize=15
    title.Text="FERRY COLLECTIF"
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.Parent=panel
    local state=Instance.new("TextLabel")
    state.Size=UDim2.new(1,-20,0,38)
    state.Position=UDim2.fromOffset(10,36)
    state.BackgroundTransparency=1
    state.Font=Enum.Font.Gotham
    state.TextColor3=Color3.fromRGB(214,235,234)
    state.TextSize=13
    state.TextWrapped=true
    state.TextXAlignment=Enum.TextXAlignment.Left
    state.Parent=panel
    local remaining=0
    local active=false
    local mode="boarding"
    local count=0
    local capacity=6
    local destination=""
    local function redraw()
        if not active then return end
        if mode=="boarding" then
            state.Text=string.format("%s · %d/%d personnes · départ dans %ds",destination,count,capacity,math.max(0,math.ceil(remaining)))
        else
            state.Text=string.format("Traversée vers %s · arrivée dans %ds",destination,math.max(0,math.ceil(remaining)))
        end
    end
    remote.OnClientEvent:Connect(function(payload)
        if type(payload)~="table" or payload.kind~="ferry.group.v2" then return end
        destination=tostring(payload.destination or "l'archipel")
        count=tonumber(payload.passengers) or 1
        capacity=tonumber(payload.capacity) or 6
        mode=tostring(payload.state or "boarding")
        if mode=="arrive" or mode=="cancel" then
            active=false
            panel.Visible=false
            return
        end
        remaining=tonumber(payload.duration) or 0
        active=true
        panel.Visible=true
        redraw()
    end)
    RunService.RenderStepped:Connect(function(dt)
        if active then
            remaining=math.max(0,remaining-dt)
            redraw()
        end
    end)
end
return FerryHud

]])
source(client,"GalleryJournalV22","ModuleScript",[[
--!strict
-- Carnet LOCAL des galeries. Les marqueurs physiques sont créés par InstitutionStoriesV22.
-- Aucun RemoteEvent, aucun DataStore ni point EkoH ; le carnet repart de zéro par session.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local Journal={}
local TAG="KinCityGalleryV22"
local TOTAL=48 -- huit institutions x six salles aménagées
local seen={}
local markers={}
local labels={}
local gui:ScreenGui
local toggle:TextButton
local window:Frame
local summary:TextLabel
local listing:TextLabel
local function count()
    local n=0
    for _ in pairs(seen) do n+=1 end
    return n
end
local function refresh()
    local n=count()
    if toggle then toggle.Text="GALERIES "..n.."/"..TOTAL end
    if summary then summary.Text=tostring(n).." galeries découvertes pendant cette session" end
    if listing then
        local entries={}
        for id,title in pairs(seen) do table.insert(entries,{id=id,title=title}) end
        table.sort(entries,function(a,b) return a.id<b.id end)
        local lines={}
        for _,entry in ipairs(entries) do table.insert(lines,"✦ "..entry.title) end
        listing.Text=if #lines==0 then "Visite les salles des grandes institutions pour compléter ton carnet." else table.concat(lines,"\n")
    end
end
local function add(instance)
    if instance:IsA("BasePart") then markers[instance]=true end
end
local function remove(instance) markers[instance]=nil end
local function openClose()
    if window then window.Visible=not window.Visible end
end
function Journal.start()
    gui=Instance.new("ScreenGui")
    gui.Name="KinCityCarnetGaleriesV22"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.DisplayOrder=5
    gui.Parent=player:WaitForChild("PlayerGui")
    toggle=Instance.new("TextButton")
    toggle.Name="Galeries (T)"
    toggle.AnchorPoint=Vector2.new(0.5,0)
    toggle.Position=UDim2.new(0.5,167,0,45)
    toggle.Size=UDim2.fromOffset(137,32)
    toggle.BackgroundColor3=Color3.fromRGB(30,104,100)
    toggle.TextColor3=Color3.fromRGB(241,252,247)
    toggle.Font=Enum.Font.GothamBold
    toggle.TextSize=12
    toggle.Parent=gui
    local buttonCorner=Instance.new("UICorner")
    buttonCorner.CornerRadius=UDim.new(0,9)
    buttonCorner.Parent=toggle
    toggle.Activated:Connect(openClose)
    window=Instance.new("Frame")
    window.Name="Carnet des galeries"
    window.AnchorPoint=Vector2.new(0.5,0.5)
    window.Position=UDim2.fromScale(0.5,0.52)
    window.Size=UDim2.new(0.88,0,0.76,0)
    window.BackgroundColor3=Color3.fromRGB(18,62,60)
    window.Visible=false
    window.Parent=gui
    local constraint=Instance.new("UISizeConstraint")
    constraint.MaxSize=Vector2.new(520,530)
    constraint.MinSize=Vector2.new(260,190)
    constraint.Parent=window
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,15)
    corner.Parent=window
    local stroke=Instance.new("UIStroke")
    stroke.Color=Color3.fromRGB(229,215,175)
    stroke.Parent=window
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-65,0,35)
    title.Position=UDim2.fromOffset(17,11)
    title.BackgroundTransparency=1
    title.Font=Enum.Font.GothamBold
    title.TextColor3=Color3.fromRGB(229,245,241)
    title.TextSize=20
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.Text="Carnet des galeries"
    title.Parent=window
    local close=Instance.new("TextButton")
    close.Name="Fermer"
    close.Size=UDim2.fromOffset(36,33)
    close.Position=UDim2.new(1,-49,0,11)
    close.Text="✕"
    close.TextSize=18
    close.Font=Enum.Font.GothamBold
    close.TextColor3=Color3.fromRGB(239,254,248)
    close.BackgroundColor3=Color3.fromRGB(42,96,92)
    close.Parent=window
    close.Activated:Connect(openClose)
    summary=Instance.new("TextLabel")
    summary.Name="Progression"
    summary.Size=UDim2.new(1,-35,0,42)
    summary.Position=UDim2.fromOffset(17,52)
    summary.BackgroundTransparency=1
    summary.Font=Enum.Font.Gotham
    summary.TextColor3=Color3.fromRGB(209,227,221)
    summary.TextSize=14
    summary.TextWrapped=true
    summary.TextXAlignment=Enum.TextXAlignment.Left
    summary.Parent=window
    local scroll=Instance.new("ScrollingFrame")
    scroll.Name="Galeries explorées"
    scroll.Position=UDim2.fromOffset(16,101)
    scroll.Size=UDim2.new(1,-32,1,-118)
    scroll.ScrollBarThickness=6
    scroll.BackgroundColor3=Color3.fromRGB(24,75,71)
    scroll.BorderSizePixel=0
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.fromOffset(0,0)
    scroll.Parent=window
    listing=Instance.new("TextLabel")
    listing.BackgroundTransparency=1
    listing.Position=UDim2.fromOffset(12,8)
    listing.Size=UDim2.new(1,-28,0,0)
    listing.AutomaticSize=Enum.AutomaticSize.Y
    listing.TextXAlignment=Enum.TextXAlignment.Left
    listing.TextYAlignment=Enum.TextYAlignment.Top
    listing.TextWrapped=true
    listing.Font=Enum.Font.Gotham
    listing.TextColor3=Color3.fromRGB(223,248,241)
    listing.TextSize=14
    listing.LineHeight=1.65
    listing.Parent=scroll
    UserInputService.InputBegan:Connect(function(input,used)
        if not used and input.KeyCode==Enum.KeyCode.T then openClose() end
    end)
    for _,inst in ipairs(CollectionService:GetTagged(TAG)) do add(inst) end
    CollectionService:GetInstanceAddedSignal(TAG):Connect(add)
    CollectionService:GetInstanceRemovedSignal(TAG):Connect(remove)
    refresh()
    task.spawn(function()
        while gui.Parent do
            local ch=player.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            if root and root:IsA("BasePart") then
                local update=false
                for marker in pairs(markers) do
                    if marker.Parent and (marker.Position-root.Position).Magnitude<12 then
                        local id=marker:GetAttribute("KinGalleryId")
                        if typeof(id)=="string" and not seen[id] then
                            local title=marker:GetAttribute("KinGalleryTitle")
                            seen[id]=if typeof(title)=="string" then title else id
                            update=true
                        end
                    elseif not marker.Parent then markers[marker]=nil end
                end
                if update then refresh() end
            end
            task.wait(1.4)
        end
    end)
end
return Journal

]])
source(client,"Hud","ModuleScript",[[
--!strict
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local GuiService=game:GetService("GuiService")
local player=Players.LocalPlayer
local Hud={}
local titleLabel,bodyLabel,detailLabel,panel,closeButton,frameGui
local messageSequence=0

local function createLabel(parent, text,size,weight,y)
    local label=Instance.new("TextLabel")
    label.BackgroundTransparency=1
    label.Size=UDim2.new(1,-44,0,size)
    label.Position=UDim2.fromOffset(22,y)
    label.Font=weight and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextColor3=Color3.fromRGB(241,243,241)
    label.TextWrapped=true
    label.TextXAlignment=Enum.TextXAlignment.Left
    label.TextYAlignment=Enum.TextYAlignment.Center
    label.TextScaled=false
    label.TextSize=if weight then 24 else 18
    label.Text=text
    label.Parent=parent
    return label
end

local function close()
    if frameGui then frameGui.Enabled=false end
    if closeButton and GuiService.SelectedObject==closeButton then GuiService.SelectedObject=nil end
end

function Hud.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityDialog"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true
    gui.DisplayOrder=15
    gui.Enabled=false
    gui.Parent=player:WaitForChild("PlayerGui")
    frameGui=gui
    local background=Instance.new("Frame")
    background.Name="Dim"
    background.BackgroundColor3=Color3.new(0,0,0)
    background.BackgroundTransparency=0.45
    background.Size=UDim2.fromScale(1,1)
    background.Parent=gui
    local card=Instance.new("Frame")
    card.Name="Message"
    card.AnchorPoint=Vector2.new(0.5,0.5)
    card.Position=UDim2.fromScale(0.5,0.5)
    card.Size=UDim2.new(0.85,0,0,264)
    card.BackgroundColor3=Color3.fromRGB(28,46,54)
    card.Parent=background
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,17);corner.Parent=card
    local outline=Instance.new("UIStroke");outline.Color=Color3.fromRGB(101,153,154);outline.Thickness=2;outline.Parent=card
    local constraint=Instance.new("UISizeConstraint");constraint.MaxSize=Vector2.new(530,300);constraint.MinSize=Vector2.new(280,240);constraint.Parent=card
    titleLabel=createLabel(card,"Kin City",44,true,18)
    bodyLabel=createLabel(card,"Fonctionnalité à venir",60,false,73)
    detailLabel=createLabel(card,"Aucune opération n'a été effectuée.",56,false,137)
    detailLabel.TextColor3=Color3.fromRGB(177,198,205)
    detailLabel.TextSize=14
    local closeBtn=Instance.new("TextButton")
    closeBtn.Name="Fermer"
    closeBtn.Text="Fermer"
    closeBtn.Font=Enum.Font.GothamBold
    closeBtn.TextSize=20
    closeBtn.TextColor3=Color3.new(1,1,1)
    closeBtn.BackgroundColor3=Color3.fromRGB(42,116,124)
    closeBtn.AnchorPoint=Vector2.new(0.5,1)
    closeBtn.Position=UDim2.new(0.5,0,1,-16)
    closeBtn.Size=UDim2.new(1,-44,0,48)
    closeBtn.Parent=card
    local closeCorner=Instance.new("UICorner");closeCorner.CornerRadius=UDim.new(0,10);closeCorner.Parent=closeBtn
    closeButton=closeBtn
    closeBtn.Activated:Connect(close)
    UserInputService.InputBegan:Connect(function(input,processed)
        if gui.Enabled and input.KeyCode==Enum.KeyCode.Escape then close() end
        if gui.Enabled and input.KeyCode==Enum.KeyCode.ButtonB then close() end
    end)
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" then return end
        local kind=payload.kind
        if kind~="interaction.reply.v1" and kind~="travel.failure.v1" then return end
        messageSequence+=1
        titleLabel.Text=if kind=="travel.failure.v1" then "Passage indisponible" else (payload.title or "Kin City")
        bodyLabel.Text=payload.message or "Fonctionnalité à venir"
        detailLabel.Text=payload.notice or "Vous pouvez continuer votre exploration."
        gui.Enabled=true
        GuiService.SelectedObject=closeButton
    end)
end
return Hud

]])
source(client,"IntermodalPanel","ModuleScript",[[
--!strict
-- Panneau de lignes: information purement locale, ne vend ni ne réserve rien.
-- Un bouton tactile permet de consulter les lignes sans clavier.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local Network=require(RS:WaitForChild("KinCityShared"):WaitForChild("IntermodalNetwork"))
local Panel={}
local player=Players.LocalPlayer
local BG=Color3.fromRGB(24,48,55)
local FG=Color3.fromRGB(235,236,219)
local ACCENT=Color3.fromRGB(205,178,113)
local function round(parent,r)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r);c.Parent=parent
end
local function text(parent,value,y,height,size,bold)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1;l.Position=UDim2.fromOffset(16,y)
    l.Size=UDim2.new(1,-30,0,height)
    l.Text=value;l.TextWrapped=true
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.TextColor3=FG;l.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    l.TextSize=size;l.Parent=parent
    return l
end
function Panel.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityIntermodal"
    gui.IgnoreGuiInset=false;gui.ResetOnSpawn=false;gui.DisplayOrder=7
    gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton")
    toggle.Name="GareButton";toggle.Text="GARE";toggle.Font=Enum.Font.GothamBold;toggle.TextSize=12
    toggle.TextColor3=FG;toggle.BackgroundColor3=BG
    toggle.Size=UDim2.fromOffset(78,36)
    toggle.Position=UDim2.new(1,-94,1,-58)
    toggle.Parent=gui;round(toggle,9)
    local window=Instance.new("Frame")
    window.Name="Lignes";window.Visible=false
    window.Size=UDim2.fromOffset(310,410)
    local constraint=Instance.new("UISizeConstraint")
    constraint.MaxSize=Vector2.new(310,410)
    constraint.MinSize=Vector2.new(245,290)
    constraint.Parent=window
    window.AnchorPoint=Vector2.new(1,1)
    window.Position=UDim2.new(1,-14,1,-104)
    window.BackgroundColor3=BG
    window.Parent=gui;round(window,11)
    local uiScale=Instance.new("UIScale")
    uiScale.Parent=window
    local function resize()
        local camera=workspace.CurrentCamera
        local vp=camera and camera.ViewportSize or Vector2.new(900,650)
        uiScale.Scale=math.clamp(math.min((vp.X-24)/340,(vp.Y-126)/420),0.60,1)
    end
    resize()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    end
    text(window,"GARE DES CONNEXIONS",12,30,16,true)
    text(window,"Correspondances rapides vers les stations. Pour prendre le bus, montez à la station.",44,46,12,false)
    local destination=text(window,"",93,34,12,true)
    destination.TextColor3=ACCENT
    for i,gate in ipairs(Network.gates) do
        local row=Instance.new("Frame")
        row.BackgroundColor3=Color3.fromRGB(40,68,74)
        row.Position=UDim2.fromOffset(14,134+(i-1)*40)
        row.Size=UDim2.fromOffset(282,35)
        row.Parent=window;round(row,6)
        local stripe=Instance.new("Frame")
        stripe.Size=UDim2.fromOffset(5,35)
        stripe.BackgroundColor3=Color3.fromRGB(gate.color[1],gate.color[2],gate.color[3]);stripe.Parent=row
        local label=Instance.new("TextLabel")
        label.BackgroundTransparency=1;label.Position=UDim2.fromOffset(13,3)
        label.Size=UDim2.new(1,-20,1,-6)
        label.Text=string.format("%d  %s",i,gate.title)
        label.TextWrapped=true;label.TextSize=12;label.Font=Enum.Font.GothamMedium
        label.TextXAlignment=Enum.TextXAlignment.Left;label.TextColor3=FG
        label.Parent=row
    end
    local function flip()window.Visible=not window.Visible end
    toggle.Activated:Connect(flip)
    UIS.InputBegan:Connect(function(input,handled)
        if not handled and input.KeyCode==Enum.KeyCode.G then flip() end
    end)
    local elapsed=0
    RunService.RenderStepped:Connect(function(dt)
        if not window.Visible then return end
        elapsed+=dt;if elapsed<0.6 then return end;elapsed=0
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then destination.Text="Explorez la gare pour trouver les guichets.";return end
        local hub=Vector3.new(Network.hub.center_studs[1],root.Position.Y,Network.hub.center_studs[3])
        local distance=(root.Position-hub).Magnitude
        if player:GetAttribute("KinZone")~="city" then
            destination.Text="Retournez à la ville pour rejoindre la gare."
        elseif distance<65 then
            destination.Text="Vous êtes à la gare · accès par les guichets physiques."
        else
            destination.Text=string.format("Gare centrale à environ %d studs",math.floor(distance))
        end
    end)
end
return Panel

]])
source(client,"IslandPassportHud","ModuleScript",[[
--!strict
-- Carnet de l'archipel, progression locale par session seulement.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local Passport={}
function Passport.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityIslandPassport"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=5
    gui.Parent=player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.Name="Carnet des îles"
    panel.Size=UDim2.fromOffset(184,41)
    panel.Position=UDim2.new(1,-201,1,-160)
    panel.BackgroundColor3=Color3.fromRGB(29,64,79)
    panel.BackgroundTransparency=0.1
    panel.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,11)
    corner.Parent=panel
    local text=Instance.new("TextLabel")
    text.BackgroundTransparency=1
    text.Size=UDim2.new(1,-10,1,0)
    text.Position=UDim2.fromOffset(5,0)
    text.TextColor3=Color3.fromRGB(243,233,194)
    text.Font=Enum.Font.GothamBold
    text.TextSize=13
    text.Parent=panel
    local function refresh()
        text.Text=string.format("ARCHIPEL  %d / %d îles",player:GetAttribute("KinIslandsVisited") or 0,player:GetAttribute("KinIslandsTotal") or 6)
    end
    player:GetAttributeChangedSignal("KinIslandsVisited"):Connect(refresh)
    player:GetAttributeChangedSignal("KinIslandsTotal"):Connect(refresh)
    refresh()
end
return Passport

]])
source(client,"KingKlownAura","ModuleScript",[[
--!strict
-- Une boucle locale partagée; aucun RemoteEvent, PointLight ou ForceField.
local CollectionService=game:GetService("CollectionService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Aura={}
function Aura.start()
    local player=Players.LocalPlayer
    local playerGui=player:WaitForChild("PlayerGui")
    if playerGui:GetAttribute("KingKlownAuraRunning") then return end
    playerGui:SetAttribute("KingKlownAuraRunning",true)
    local records={}
    local pending={}
    local function remove(model)
        pending[model]=nil
        local record=records[model]
        if record then record.orb:Destroy();records[model]=nil end
    end
    local function add(model)
        if records[model] or pending[model] then return end
        local ticket={}
        pending[model]=ticket
        task.spawn(function()
            local character=model.Parent
            local root=character and character:WaitForChild("HumanoidRootPart",10)
            if pending[model]~=ticket or not root or not root:IsA("BasePart")
                or not model:IsDescendantOf(workspace) then
                if pending[model]==ticket then pending[model]=nil end
                return
            end
            pending[model]=nil
            local orb=Instance.new("Part")
            orb.Name="Aura locale du Trickster"
            orb.Shape=Enum.PartType.Ball
            orb.Size=Vector3.new(7.2,7.2,7.2)
            orb.Color=Color3.fromRGB(197,244,240)
            orb.Material=Enum.Material.Neon
            orb.Transparency=0.965
            orb.Massless=true
            orb.CanCollide=false;orb.CanTouch=false;orb.CanQuery=false;orb.CastShadow=false
            orb.CFrame=root.CFrame*CFrame.new(0,0.25,0)
            orb.Parent=model
            local weld=Instance.new("WeldConstraint")
            weld.Part0=root;weld.Part1=orb;weld.Parent=orb
            local emitter=Instance.new("ParticleEmitter")
            emitter.Texture="rbxasset://textures/particles/sparkles_main.dds"
            emitter.Shape=Enum.ParticleEmitterShape.Sphere
            emitter.ShapeStyle=Enum.ParticleEmitterShapeStyle.Surface
            emitter.Rate=4
            emitter.Lifetime=NumberRange.new(1,1.6)
            emitter.Speed=NumberRange.new(0.02,0.10)
            emitter.LockedToPart=true
            emitter.LightEmission=0.3
            emitter.Color=ColorSequence.new(Color3.fromRGB(30,104,100),Color3.fromRGB(197,244,240))
            emitter.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.3,0.12),NumberSequenceKeypoint.new(1,0)})
            emitter.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.25),NumberSequenceKeypoint.new(1,1)})
            emitter.Parent=orb
            records[model]={orb=orb,emitter=emitter,root=root,character=character,visible=false}
        end)
    end
    CollectionService:GetInstanceAddedSignal("KingKlownAvatar"):Connect(add)
    CollectionService:GetInstanceRemovedSignal("KingKlownAvatar"):Connect(remove)
    for _,model in ipairs(CollectionService:GetTagged("KingKlownAvatar")) do add(model) end
    local elapsed=0
    RunService.Heartbeat:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.05 then return end
        elapsed=0
        local camera=workspace.CurrentCamera
        if not camera then return end
        local quality=player:GetAttribute("KinCityLocalQuality") or "STANDARD"
        local lite=quality=="LITE"
        local distance=if lite then 55 else 110
        local now=os.clock()
        for model,record in pairs(records) do
            if not model:IsDescendantOf(workspace) or not record.root.Parent then remove(model);continue end
            local delta=record.root.Position-camera.CFrame.Position
            local head=record.character:FindFirstChild("Head")
            local firstPerson=record.character==player.Character and head
                and (head.Position-camera.CFrame.Position).Magnitude<2
            local visible=not firstPerson and delta:Dot(delta)<distance*distance
            record.orb.LocalTransparencyModifier=if visible then 0 else 1
            record.emitter.Enabled=visible
            if visible then
                record.emitter.Rate=if lite then 2 elseif quality=="SHOWCASE" then 6 else 4
                record.orb.Transparency=if lite then 0.978 else 0.965+math.sin(now*1.3)*0.009
                if not record.visible then record.emitter:Emit(if lite then 3 else 8) end
            elseif record.visible then record.emitter:Clear() end
            record.visible=visible
        end
    end)
end
return Aura

]])
source(client,"LocalVisualDirectorV22","ModuleScript",[[
--!strict
-- Ambiance locale par visiteur : jamais de RemoteEvent ni d'altération du gameplay.
-- Trois qualités CHOISIES par le joueur; le mode standard reste la valeur initiale.
local Lighting=game:GetService("Lighting")
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local RS=game:GetService("ReplicatedStorage")
local Visual=require(RS:WaitForChild("KinCityShared"):WaitForChild("VisualConfig"))
local player=Players.LocalPlayer
local Director={}
local presets={
    LITE={bloom=0,saturation=-0.015,contrast=0.02},
    STANDARD={bloom=0.07,saturation=0.01,contrast=0.035},
    SHOWCASE={bloom=0.16,saturation=0.045,contrast=0.065},
}
local order={"LITE","STANDARD","SHOWCASE"}
local zones={
    city_hall=Color3.fromRGB(219,242,236),ekoh_tower=Color3.fromRGB(211,248,241),
    library=Color3.fromRGB(230,238,245),campus=Color3.fromRGB(223,229,251),
    justice_palace=Color3.fromRGB(242,236,221),innovation_lab=Color3.fromRGB(205,243,249),
    museum=Color3.fromRGB(247,227,246),orgo_center=Color3.fromRGB(216,239,244),
}
local quality=Visual.profile
local currentZone=""
local cfx:ColorCorrectionEffect
local bloom:BloomEffect
local button:TextButton
local busy:Tween?=nil
local function apply(zone,animate)
    local conf=presets[quality]
    if busy then busy:Cancel();busy=nil end
    local tint=zones[zone] or Color3.fromRGB(242,252,249)
    local goal={TintColor=tint,Saturation=conf.saturation,Contrast=conf.contrast,Brightness=0}
    if animate then
        busy=TweenService:Create(cfx,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),goal)
        busy:Play()
    else
        for key,val in pairs(goal) do (cfx :: any)[key]=val end
    end
    bloom.Intensity=conf.bloom
    bloom.Enabled=conf.bloom>0
    player:SetAttribute("KinCityLocalQuality",quality)
    if button then
        local label=if quality=="LITE" then "LÉGER" elseif quality=="STANDARD" then "NORMAL" else "DÉTAIL"
        button.Text="✦ CRISTAL : "..label
    end
end
local function cycle()
    local i=table.find(order,quality) or 2
    quality=order[(i%#order)+1]
    apply(currentZone,false)
end
function Director.start()
    local existing=Lighting:FindFirstChild("KinCityLocalColorV22")
    if existing then existing:Destroy() end
    local oldBloom=Lighting:FindFirstChild("KinCityLocalBloomV22")
    if oldBloom then oldBloom:Destroy() end
    cfx=Instance.new("ColorCorrectionEffect")
    cfx.Name="KinCityLocalColorV22"
    cfx.Parent=Lighting
    bloom=Instance.new("BloomEffect")
    bloom.Name="KinCityLocalBloomV22"
    bloom.Size=12
    bloom.Threshold=1.7
    bloom.Parent=Lighting
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityQualitéLocale"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.DisplayOrder=2
    gui.Parent=player:WaitForChild("PlayerGui")
    button=Instance.new("TextButton")
    button.Name="Changer la qualité (V)"
    button.AnchorPoint=Vector2.new(0.5,0)
    button.Position=UDim2.new(0.5,0,0,45)
    button.Size=UDim2.fromOffset(156,32)
    button.BackgroundColor3=Color3.fromRGB(18,62,60)
    button.BackgroundTransparency=0.13
    button.TextColor3=Color3.fromRGB(226,249,245)
    button.TextSize=12
    button.Font=Enum.Font.GothamBold
    button.AutoButtonColor=true
    button.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,9)
    corner.Parent=button
    local stroke=Instance.new("UIStroke")
    stroke.Color=Color3.fromRGB(229,215,175)
    stroke.Transparency=0.35
    stroke.Parent=button
    button.Activated:Connect(cycle)
    UserInputService.InputBegan:Connect(function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.V then cycle() end
    end)
    currentZone=player:GetAttribute("KinZone") or ""
    apply(currentZone,false)
    player:GetAttributeChangedSignal("KinZone"):Connect(function()
        local zone=player:GetAttribute("KinZone") or ""
        if currentZone~=zone then currentZone=zone;apply(zone,true) end
    end)
end
return Director

]])
source(client,"MapHud","ModuleScript",[[
--!strict
-- Guide et carte client; exploite le plan partagé, sans RemoteEvent ni réseau externe.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local PublicDestinations=require(Shared:WaitForChild("PublicDestinations"))
local IslandDestinations=require(Shared:WaitForChild("IslandDestinations"))
local MarinaDestinations=require(Shared:WaitForChild("MarinaDestinations"))
local ResidentialDestinations=require(Shared:WaitForChild("ResidentialDestinations"))
local CommunityDestinations=require(Shared:WaitForChild("CommunityDestinations"))
local BoulevardRoutes=require(Shared:WaitForChild("BoulevardRoutes"))
local IntermodalNetwork=require(Shared:WaitForChild("IntermodalNetwork"))
local CivicDestinations=require(Shared:WaitForChild("CivicDestinations"))
local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))
local UrbanV14Destinations=require(Shared:WaitForChild("UrbanV14Destinations"))
local player=Players.LocalPlayer
local MapHud={}
local function label(parent,text,pos,size,bold)
    local t=Instance.new("TextLabel")
    t.BackgroundTransparency=1;t.Text=text;t.Size=size;t.Position=pos
    t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize=bold and 16 or 12;t.TextColor3=Color3.fromRGB(238,240,231)
    t.TextWrapped=true;t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=parent
    return t
end
local names={city="Kin City",campus="Université KonnectED",city_hall="Hôtel de ville",ekoh_tower="Tour EkoH",innovation_lab="Parc de l'Innovation",justice_palace="Palais de justice",library="Grande Bibliothèque",museum="Musée Kreative",orgo_center="Centre Orgo"}
local function round(parent,radius)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,radius);c.Parent=parent
end
local scale=1050
local markers={}
local function point(parent,x,z,clr)
    local dot=Instance.new("Frame")
    dot.AnchorPoint=Vector2.new(0.5,0.5)
    dot.Size=UDim2.fromOffset(7,7)
    dot.Position=UDim2.fromScale(0.5+x/scale,0.5+z/scale)
    dot.BackgroundColor3=clr;dot.BorderSizePixel=0;dot.Parent=parent
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(1,0);corner.Parent=dot
    table.insert(markers,{dot=dot,x=x,z=z})
    return dot
end
function MapHud.start()
    local gui=Instance.new("ScreenGui");gui.Name="KinCityNavigation";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=false;gui.DisplayOrder=7;gui.Parent=player:WaitForChild("PlayerGui")
    local head=Instance.new("Frame");head.Name="Bannière";head.Size=UDim2.fromOffset(280,59);head.Position=UDim2.fromOffset(15,15);head.BackgroundColor3=Color3.fromRGB(30,54,63);head.BackgroundTransparency=0.10;head.Parent=gui
    round(head,10)
    label(head,"KIN CITY",UDim2.fromOffset(12,3),UDim2.fromOffset(235,25),true)
    local area=label(head,"Explore la ville • M pour la carte",UDim2.fromOffset(12,29),UDim2.fromOffset(258,22),false)
    local toggle=Instance.new("TextButton");toggle.Name="Carte";toggle.Text="CARTE  [M]";toggle.Font=Enum.Font.GothamBold;toggle.TextSize=13;toggle.TextColor3=Color3.fromRGB(245,245,241)
    toggle.Size=UDim2.fromOffset(114,38);toggle.Position=UDim2.new(1,-128,0,82);toggle.BackgroundColor3=Color3.fromRGB(40,94,99);toggle.Parent=gui;round(toggle,10)
    local window=Instance.new("Frame");window.Name="Carte";window.Size=UDim2.fromOffset(308,388);window.AnchorPoint=Vector2.new(1,0);window.Position=UDim2.new(1,-14,0,130);window.BackgroundColor3=Color3.fromRGB(23,43,50);window.BackgroundTransparency=0.03;window.Visible=false;window.Parent=gui;round(window,14)
    label(window,"PLAN DE KIN CITY",UDim2.fromOffset(15,10),UDim2.fromOffset(275,26),true)
    local square=Instance.new("Frame");square.Name="Mini-map";square.Size=UDim2.fromOffset(274,274);square.Position=UDim2.fromOffset(17,45);square.BackgroundColor3=Color3.fromRGB(72,108,90);square.BorderSizePixel=0;square.Parent=window;round(square,136)
    local outline=Instance.new("UIStroke");outline.Color=Color3.fromRGB(180,169,127);outline.Thickness=2;outline.Parent=square
    local center=point(square,0,0,Color3.fromRGB(225,201,137));center.Size=UDim2.fromOffset(13,13)
    for _,structure in ipairs(Plan.structures) do
        local dot=point(square,structure.center_studs[1],structure.center_studs[3],Color3.fromRGB(225,230,212))
        dot.Size=UDim2.fromOffset(10,10)
    end
    -- Huit belvédères côtiers et leurs longues-vues réellement utilisables.
    for n=1,8 do
        local a=n*math.pi/4
        local marker=point(square,math.cos(a)*467,math.sin(a)*467,Color3.fromRGB(239,183,103))
        marker.Size=UDim2.fromOffset(8,8)
    end
    -- Les nouveaux quais, ateliers et jardins existent physiquement dans la scène.
    -- Les marqueurs représentent des zones, pas la promesse qu'un kiosque précis a été placé.
    for i=1,12 do
        local a=(i-1)*2*math.pi/12+math.pi/24
        local marker=point(square,math.cos(a)*490,math.sin(a)*490,Color3.fromRGB(127,210,224))
        marker.Size=UDim2.fromOffset(6,6)
    end
    -- Pavillons scientifiques du circuit : même registre partagé que le générateur.
    for _,p in ipairs(PublicDestinations) do
        local marker=point(square,p.center_studs[1],p.center_studs[3],Color3.fromRGB(182,225,157))
        marker.Size=UDim2.fromOffset(8,8)
    end
    for _,item in ipairs(IslandDestinations) do
        local marker=point(square,item.center_studs[1],item.center_studs[3],Color3.fromRGB(246,207,133))
        marker.Size=UDim2.fromOffset(10,10)
    end
    for _,quarter in ipairs(ResidentialDestinations) do
        local dot=point(square,quarter.center_studs[1],quarter.center_studs[3],Color3.fromRGB(245,203,163))
        dot.Size=UDim2.fromOffset(9,9)
    end
    for _,public in ipairs(CommunityDestinations) do
        local dot=point(square,public.center_studs[1],public.center_studs[3],if public.kind=="market" then Color3.fromRGB(248,171,99) else Color3.fromRGB(165,220,195))
        dot.Size=UDim2.fromOffset(8,8)
    end
    for _,line in ipairs(BoulevardRoutes) do
        local a=point(square,line.start_studs[1],line.start_studs[3],Color3.fromRGB(247,229,167))
        a.Size=UDim2.fromOffset(6,6)
        local b=point(square,line.finish_studs[1],line.finish_studs[3],Color3.fromRGB(247,229,167))
        b.Size=UDim2.fromOffset(6,6)
    end
    for _,marina in ipairs(MarinaDestinations) do
        local dot=point(square,marina.center_studs[1],marina.center_studs[3],Color3.fromRGB(118,243,236))
        dot.Size=UDim2.fromOffset(11,11)
    end
    -- Nouveaux lieux physiquement générés en v12.
    local station=IntermodalNetwork.hub.center_studs
    local stationDot=point(square,station[1],station[3],Color3.fromRGB(238,220,134))
    stationDot.Size=UDim2.fromOffset(14,14)
    for _,stage in ipairs(CivicDestinations) do
        local venue=point(square,stage.center_studs[1],stage.center_studs[3],Color3.fromRGB(223,140,179))
        venue.Size=UDim2.fromOffset(9,9)
    end
    for _,shop in ipairs(PromenadeCommerce) do
        local dot=point(square,shop.center_studs[1],shop.center_studs[3],Color3.fromRGB(237,193,131))
        dot.Size=UDim2.fromOffset(5,5)
    end
    for _,shop in ipairs(UrbanV14Destinations.arcades) do
        local dot=point(square,shop.center_studs[1],shop.center_studs[3],Color3.fromRGB(248,212,139))
        dot.Size=UDim2.fromOffset(7,7)
    end
    for _,workshop in ipairs(UrbanV14Destinations.workshops) do
        local dot=point(square,workshop.center_studs[1],workshop.center_studs[3],Color3.fromRGB(141,235,206))
        dot.Size=UDim2.fromOffset(8,8)
    end
    local playerDot=point(square,0,0,Color3.fromRGB(47,211,234))
    playerDot.Size=UDim2.fromOffset(11,11)
    local zoom=Instance.new("TextButton")
    zoom.Name="Échelle de carte";zoom.Size=UDim2.fromOffset(282,27)
    zoom.Position=UDim2.fromOffset(13,324)
    zoom.BackgroundColor3=Color3.fromRGB(53,107,109)
    zoom.TextColor3=Color3.fromRGB(241,238,216)
    zoom.Font=Enum.Font.GothamBold;zoom.TextSize=12;zoom.Text="VILLE  ·  Voir l'archipel"
    zoom.Parent=window;round(zoom,7)
    zoom.Activated:Connect(function()
        scale=if scale==1050 then 1850 else 1050
        zoom.Text=if scale==1050 then "VILLE  ·  Voir l'archipel" else "ARCHIPEL  ·  Revenir à la ville"
        for _,item in ipairs(markers) do
            item.dot.Position=UDim2.fromScale(0.5+item.x/scale,0.5+item.z/scale)
        end
    end)
    label(window,"M : carte  ·  N : destinations  ·  E : interagir",UDim2.fromOffset(15,356),UDim2.fromOffset(286,21),false)
    local function flip()window.Visible=not window.Visible end
    toggle.Activated:Connect(flip)
    UIS.InputBegan:Connect(function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.M then flip() end
    end)
    local elapsed=0
    RunService.RenderStepped:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.25 then return end
        elapsed=0
        local key=player:GetAttribute("KinZone") or "city"
        area.Text=names[key] or "En exploration"
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if root and key=="city" then
            local position=root.Position
            playerDot.Visible=true
            playerDot.Position=UDim2.fromScale(math.clamp(0.5+position.X/scale,0,1),math.clamp(0.5+position.Z/scale,0,1))
        else
            playerDot.Visible=false
        end
    end)
end
return MapHud

]])
source(client,"PlaceIdentityHudV26","ModuleScript",[[
--!strict
-- Guide propre à une Place; ne présente jamais la carte de la ville au milieu d'une institution.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Runtime=require(Shared:WaitForChild("RuntimeConfig"))
local names={city="VILLE EXTÉRIEURE",city_hall="HÔTEL DE VILLE",ekoh_tower="TOUR EKOH",
 library="GRANDE BIBLIOTHÈQUE",campus="UNIVERSITÉ KONNECTED",
 justice_palace="PALAIS DE JUSTICE",innovation_lab="PARC DE L'INNOVATION",
 museum="MUSÉE KREATIVE",orgo_center="CENTRE ORGO"}
local Hud={}
function Hud.start()
 if Runtime.mode=="LOCAL_UNIVERSE" then return end
 local player=Players.LocalPlayer
 local key=Runtime.target_place_key or "city"
 local gui=Instance.new("ScreenGui")
 gui.Name="KinCityPlaceIdentityV26"
 gui.ResetOnSpawn=false
 gui.DisplayOrder=3
 gui.Parent=player:WaitForChild("PlayerGui")
 local frame=Instance.new("Frame")
 frame.Name="Emplacement actuel"
 frame.AnchorPoint=Vector2.new(0.5,0)
 frame.Position=UDim2.new(0.5,0,0,10)
 frame.Size=UDim2.fromOffset(325,42)
 frame.BackgroundColor3=Color3.fromRGB(30,104,100)
 frame.BackgroundTransparency=0.08
 frame.Parent=gui
 local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,10);corner.Parent=frame
 local text=Instance.new("TextLabel")
 text.Name="Nom de la Place"
 text.Size=UDim2.fromScale(1,1)
 text.BackgroundTransparency=1
 text.TextColor3=Color3.fromRGB(237,253,252)
 text.TextScaled=true
 text.Font=Enum.Font.GothamBold
 text.Text=names[key] or key
 text.Parent=frame
 local sub=Instance.new("TextLabel")
 sub.Name="Statut du passage"
 sub.BackgroundTransparency=1
 sub.Text=if Runtime.mode=="SPLIT_PREVIEW" then "Aperçu indépendant • passages actifs après publication" else "Place indépendante • entrées et sorties par les portes"
 sub.Position=UDim2.new(0,0,1,2)
 sub.Size=UDim2.fromOffset(325,18)
 sub.TextSize=11
 sub.TextColor3=Color3.fromRGB(232,217,175)
 sub.Font=Enum.Font.Gotham
 sub.Parent=frame
end
return Hud

]])
source(client,"RouteGuide","ModuleScript",[[
--!strict
-- Guide de lieux : panneau cliquable et indication d'azimut / distance.
-- Fonctionne même sans kOA, sans accès HTTP et sans serveur RemoteEvent.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local PublicDestinations=require(Shared:WaitForChild("PublicDestinations"))
local IslandDestinations=require(Shared:WaitForChild("IslandDestinations"))
local MarinaDestinations=require(Shared:WaitForChild("MarinaDestinations"))
local ResidentialDestinations=require(Shared:WaitForChild("ResidentialDestinations"))
local CommunityDestinations=require(Shared:WaitForChild("CommunityDestinations"))
local IntermodalNetwork=require(Shared:WaitForChild("IntermodalNetwork"))
local CivicDestinations=require(Shared:WaitForChild("CivicDestinations"))
local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))
local UrbanV14Destinations=require(Shared:WaitForChild("UrbanV14Destinations"))
local player=Players.LocalPlayer
local Guide={}
local colors={background=Color3.fromRGB(24,46,57),card=Color3.fromRGB(38,72,79),highlight=Color3.fromRGB(72,132,129),text=Color3.fromRGB(244,242,227)}
local function rounded(parent,r)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r);c.Parent=parent
end
local function text(parent,value,size,position,bold)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1;l.Text=value;l.TextWrapped=true
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextColor3=colors.text;l.TextSize=bold and 16 or 13
    l.Size=size;l.Position=position;l.TextXAlignment=Enum.TextXAlignment.Left
    l.Parent=parent
    return l
end
local pathsByBuilding={}
for _,walk in ipairs(Plan.pedestrian_paths) do pathsByBuilding[walk.building_id]=walk end
local function directionForWalk(playerPosition,path)
    if not path then return nil,math.huge end
    local points=path.path_xyz_studs
    local bestDistance=math.huge
    local nextTarget=nil
    for i=2,#points do
        local a=Vector3.new(points[i-1][1],playerPosition.Y,points[i-1][3])
        local b=Vector3.new(points[i][1],playerPosition.Y,points[i][3])
        local segment=b-a
        local lengthSq=segment:Dot(segment)
        if lengthSq>0.1 then
            local t=math.clamp((playerPosition-a):Dot(segment)/lengthSq,0,1)
            local near=a+segment*t
            local dist=(near-playerPosition).Magnitude
            if dist<bestDistance then
                bestDistance=dist
                local pointIndex=i
                if (b-playerPosition).Magnitude<8 and i<#points then pointIndex=i+1 end
                nextTarget=Vector3.new(points[pointIndex][1],playerPosition.Y,points[pointIndex][3])
            end
        end
    end
    return nextTarget,bestDistance
end
local names={}
for _,b in ipairs(Buildings) do names[b.building_id]=b.name end
local sorted={}
for _,st in ipairs(Plan.structures) do table.insert(sorted,st) end
for _,public in ipairs(PublicDestinations) do
    names[public.id]=public.title
    table.insert(sorted,{building_id=public.id,center_studs=public.center_studs,isPublicAttraction=true})
end
for _,island in ipairs(IslandDestinations) do
    names[island.id]=island.title
    table.insert(sorted,{building_id=island.id,center_studs=island.center_studs,isPublicAttraction=true,isIsland=true})
end
for _,marina in ipairs(MarinaDestinations) do
    names[marina.id]=marina.title
    table.insert(sorted,{building_id=marina.id,center_studs=marina.center_studs,isPublicAttraction=true,isMarina=true})
end
for _,quarter in ipairs(ResidentialDestinations) do
    names[quarter.id]=quarter.title
    table.insert(sorted,{building_id=quarter.id,center_studs=quarter.center_studs,isPublicAttraction=true,isResidential=true})
end
for _,place in ipairs(CommunityDestinations) do
    names[place.id]=place.title
    table.insert(sorted,{building_id=place.id,center_studs=place.center_studs,isPublicAttraction=true,isCommunity=true})
end
local hub=IntermodalNetwork.hub
names[hub.id]=hub.title
table.insert(sorted,{building_id=hub.id,center_studs=hub.center_studs,isPublicAttraction=true})
for _,stage in ipairs(CivicDestinations) do
    names[stage.id]=stage.title
    table.insert(sorted,{building_id=stage.id,center_studs=stage.center_studs,isPublicAttraction=true})
end
for _,shop in ipairs(PromenadeCommerce) do
    names[shop.id]=shop.title.." · Promenade des métiers"
    table.insert(sorted,{building_id=shop.id,center_studs=shop.center_studs,isPublicAttraction=true})
end
for _,shop in ipairs(UrbanV14Destinations.arcades) do
    names[shop.id]=shop.title.." · Galeries de la gare"
    table.insert(sorted,{building_id=shop.id,center_studs=shop.center_studs,isPublicAttraction=true})
end
for _,workshop in ipairs(UrbanV14Destinations.workshops) do
    names[workshop.id]=workshop.title.." · Trois étapes"
    table.insert(sorted,{building_id=workshop.id,center_studs=workshop.center_studs,isPublicAttraction=true})
end
table.sort(sorted,function(a,b)return a.building_id<b.building_id end)
local function createButton(parent,title,y)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-20,0,40);b.Position=UDim2.fromOffset(10,y)
    b.BackgroundColor3=colors.card;b.Font=Enum.Font.GothamMedium
    b.TextColor3=colors.text;b.TextSize=13;b.TextWrapped=true
    b.Text=title;b.Parent=parent;rounded(b,7)
    return b
end
function Guide.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityGuide"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.DisplayOrder=8
    gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton")
    toggle.Name="GuideToggle"
    toggle.Size=UDim2.fromOffset(120,39)
    toggle.Position=UDim2.new(0,17,0,92)
    toggle.BackgroundColor3=colors.card
    toggle.Text="LIEUX [N]"
    toggle.Font=Enum.Font.GothamBold
    toggle.TextColor3=colors.text
    toggle.TextSize=13
    toggle.Parent=gui;rounded(toggle,8)
    local panel=Instance.new("Frame")
    panel.Size=UDim2.new(0,294,0,437)
    panel.Position=UDim2.fromOffset(15,141)
    panel.BackgroundColor3=colors.background
    panel.Visible=false;panel.Parent=gui;rounded(panel,12)
    local heading=text(panel,"DESTINATIONS",UDim2.new(1,-20,0,32),UDim2.fromOffset(12,11),true)
    local selected=sorted[1]
    local buttons={}
    local list=Instance.new("ScrollingFrame")
    list.BackgroundTransparency=1
    list.BorderSizePixel=0
    list.Position=UDim2.fromOffset(0,48)
    list.Size=UDim2.new(1,0,1,-104)
    list.ScrollBarThickness=5
    list.ScrollBarImageColor3=colors.highlight
    list.CanvasSize=UDim2.fromOffset(0,#sorted*48+7)
    list.Parent=panel
    local status=text(panel,"",UDim2.new(1,-26,0,49),UDim2.new(0,13,1,-54),false)
    local guidance=Instance.new("Frame")
    guidance.Name="Direction"
    guidance.BackgroundColor3=colors.background
    guidance.BackgroundTransparency=0.1
    guidance.Size=UDim2.new(0,280,0,47)
    guidance.Position=UDim2.new(0.5,-140,0,15)
    guidance.Parent=gui;rounded(guidance,11)
    local navLabel=text(guidance,"",UDim2.new(1,-20,1,-8),UDim2.fromOffset(10,4),false)
    navLabel.TextSize=13
    for i,st in ipairs(sorted) do
        local b=createButton(list,names[st.building_id] or st.building_id,5+(i-1)*47)
        buttons[i]=b
        b.Activated:Connect(function()
            selected=st
            for j,button in ipairs(buttons) do
                button.BackgroundColor3=j==i and colors.highlight or colors.card
            end
            panel.Visible=false
        end)
    end
    buttons[1].BackgroundColor3=colors.highlight
    local function togglePanel()panel.Visible=not panel.Visible end
    toggle.Activated:Connect(togglePanel)
    UIS.InputBegan:Connect(function(input,processed)
        if processed then return end
        if input.KeyCode==Enum.KeyCode.N then togglePanel() end
    end)
    local elapsed=0
    RunService.RenderStepped:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.25 then return end
        elapsed=0
        local current=player:GetAttribute("KinZone") or "city"
        if current~="city" then
            navLabel.Text="INTÉRIEUR · Parcours libre"
            status.Text="Reviens à l'extérieur pour suivre une destination."
            return
        end
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local p=root.Position
        local destination=Vector3.new(selected.center_studs[1],p.Y,selected.center_studs[3])
        local distance=(destination-p).Magnitude
        local waypoint,pathGap=directionForWalk(p,pathsByBuilding[selected.building_id])
        local target=waypoint or destination
        local delta=target-p
        local bearing=math.deg(math.atan2(delta.X,-delta.Z))%360
        local cardinal=if bearing<45 or bearing>=315 then "N" elseif bearing<135 then "E" elseif bearing<225 then "S" else "O"
        local name=names[selected.building_id] or "Institution"
        if distance<19 then
            navLabel.Text="ARRIVÉE · "..name
            status.Text=if selected.isResidential then "Bienvenue dans le quartier habité !" elseif selected.isIsland then "Bienvenue sur l’île !" elseif selected.isMarina then "Bienvenue au port !" elseif selected.isCommunity then "Bienvenue dans l’espace public !" elseif selected.isPublicAttraction then "Tu es au pavillon scientifique." else "Tu es à proximité de l’institution."
        else
            navLabel.Text=string.format("%s · %d studs %s",name,math.floor(distance+0.5),cardinal)
            status.Text=if selected.isResidential then "Rejoins les cours habitées • direction "..math.floor(bearing).."°" elseif selected.isIsland then "Rejoins une passerelle ou un ferry • direction "..math.floor(bearing).."°" elseif selected.isMarina then "Rejoins la promenade côtière • direction "..math.floor(bearing).."°" elseif selected.isCommunity then "Rejoins la halle ou la maison communautaire • direction "..math.floor(bearing).."°" elseif selected.isPublicAttraction then "Explore le pavillon • direction "..math.floor(bearing).."°" elseif pathGap>30 then "Rejoins le sentier balisé · "..math.floor(pathGap).." studs" else "Suis le jalonnement doré · direction "..math.floor(bearing).."°"
        end
    end)
end
return Guide

]])
source(client,"SkyTourHud","ModuleScript",[[
--!strict
-- Carnet des stations de quatrième niveau; progression locale à la session.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local SkyHud={}
local TOTAL=16

local function rounded(parent,rad)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,rad)
    c.Parent=parent
end
local function title(parent,text,y,size)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1
    l.Position=UDim2.fromOffset(14,y)
    l.Size=UDim2.new(1,-28,0,size)
    l.Font=Enum.Font.GothamSemibold
    l.TextSize=if size>=32 then 19 else 14
    l.TextColor3=Color3.fromRGB(242,234,211)
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextWrapped=true
    l.Text=text
    l.Parent=parent
    return l
end
function SkyHud.start(remote)
    local player=Players.LocalPlayer
    local pg=player:WaitForChild("PlayerGui")
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCitySkyTour"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.Parent=pg
    local button=Instance.new("TextButton")
    button.Name="Pavillons"
    button.AnchorPoint=Vector2.new(1,0)
    button.Position=UDim2.new(1,-15,0,360)
    button.Size=UDim2.fromOffset(121,38)
    button.Text="Ciel · P"
    button.Font=Enum.Font.GothamBold
    button.TextSize=14
    button.TextColor3=Color3.fromRGB(252,248,229)
    button.BackgroundColor3=Color3.fromRGB(39,82,106)
    button.Parent=gui
    rounded(button,10)
    local panel=Instance.new("Frame")
    panel.Name="Carnet des observatoires"
    panel.AnchorPoint=Vector2.new(1,0)
    panel.Position=UDim2.new(1,-14,0,403)
    panel.Size=UDim2.fromOffset(305,174)
    panel.BackgroundColor3=Color3.fromRGB(25,46,62)
    panel.BorderSizePixel=0
    panel.Visible=false
    panel.Parent=gui
    rounded(panel,12)
    title(panel,"PAVILLONS DU CIEL",12,34)
    local counter=title(panel,"0 / 16 mécanismes découverts",50,30)
    local recent=title(panel,"Visite le toit d'une institution, puis monte d'un niveau.",83,54)
    recent.TextSize=12
    local progress=Instance.new("Frame")
    progress.Position=UDim2.new(0,14,1,-24)
    progress.Size=UDim2.new(1,-28,0,8)
    progress.BackgroundColor3=Color3.fromRGB(65,90,105)
    progress.BorderSizePixel=0
    progress.Parent=panel
    rounded(progress,4)
    local fill=Instance.new("Frame")
    fill.Size=UDim2.fromScale(0,1)
    fill.BackgroundColor3=Color3.fromRGB(116,215,182)
    fill.BorderSizePixel=0
    fill.Parent=progress
    rounded(fill,4)
    local toggle=function()panel.Visible=not panel.Visible end
    button.Activated:Connect(toggle)
    UIS.InputBegan:Connect(function(input,handled)
        if not handled and input.KeyCode==Enum.KeyCode.P then toggle() end
    end)
    local seen={}
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="sky.discovery.v1" then return end
        if type(payload.station_id)~="string" then return end
        seen[payload.station_id]=true
        local count=0
        for _ in pairs(seen) do count+=1 end
        counter.Text=string.format("%d / %d mécanismes découverts",count,TOTAL)
        recent.Text=tostring(payload.title or "Station explorée").."\n"..tostring(payload.place_key or "Kin City")
        fill.Size=UDim2.fromScale(math.clamp(count/TOTAL,0,1),1)
        panel.Visible=true
    end)
end
return SkyHud

]])
source(client,"TrailHud","ModuleScript",[[
--!strict
-- Compteur de promenade local, lisible au clavier / tactile / manette.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local Tracker={}
function Tracker.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityDiscoveryTracker";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=false;gui.DisplayOrder=4
    gui.Parent=player:WaitForChild("PlayerGui")
    local chip=Instance.new("Frame")
    chip.Name="Parcours de découverte";chip.AnchorPoint=Vector2.new(1,0)
    chip.Position=UDim2.new(1,-18,0,16);chip.Size=UDim2.fromOffset(216,48)
    chip.BackgroundColor3=Color3.fromRGB(34,70,77);chip.BackgroundTransparency=0.12;chip.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=chip
    local label=Instance.new("TextLabel")
    label.Size=UDim2.new(1,-18,1,-8);label.Position=UDim2.fromOffset(9,4)
    label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(249,242,218)
    label.TextSize=16;label.Font=Enum.Font.GothamBold;label.TextXAlignment=Enum.TextXAlignment.Left
    label.Parent=chip
    local function render()
        local count=player:GetAttribute("KinTrailCount") or 0
        local total=player:GetAttribute("KinTrailTotal") or 24
        label.Text=string.format("Découvertes  %d / %d",count,total)
    end
    player:GetAttributeChangedSignal("KinTrailCount"):Connect(render)
    player:GetAttributeChangedSignal("KinTrailTotal"):Connect(render)
    render()
end
return Tracker

]])
source(client,"TramRideHud","ModuleScript",[[
--!strict
-- Indicateur de trajet non bloquant; le joueur peut admirer la ville pendant le trajet.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local UI={}
function UI.start(remote)
    local screen=Instance.new("ScreenGui")
    screen.Name="KinCityTramRide";screen.ResetOnSpawn=false;screen.DisplayOrder=9;screen.Enabled=false
    screen.Parent=player:WaitForChild("PlayerGui")
    local frame=Instance.new("Frame")
    frame.AnchorPoint=Vector2.new(0.5,1);frame.Position=UDim2.new(0.5,0,1,-85)
    frame.Size=UDim2.new(0.75,0,0,74);frame.BackgroundColor3=Color3.fromRGB(30,64,73)
    frame.Parent=screen
    local size=Instance.new("UISizeConstraint");size.MinSize=Vector2.new(240,64);size.MaxSize=Vector2.new(520,84);size.Parent=frame
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,13);round.Parent=frame
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-28,0,39);title.Position=UDim2.fromOffset(14,3)
    title.BackgroundTransparency=1;title.TextXAlignment=Enum.TextXAlignment.Left;title.Font=Enum.Font.GothamBold
    title.TextColor3=Color3.fromRGB(246,241,221);title.TextSize=16;title.Text="Tramway Kin City"
    title.Parent=frame
    local track=Instance.new("Frame")
    track.Size=UDim2.new(1,-28,0,8);track.Position=UDim2.new(0,14,1,-21)
    track.BackgroundColor3=Color3.fromRGB(86,113,119);track.BorderSizePixel=0;track.Parent=frame
    local progress=Instance.new("Frame");progress.Size=UDim2.fromScale(0,1)
    progress.BackgroundColor3=Color3.fromRGB(241,200,115);progress.BorderSizePixel=0;progress.Parent=track
    local serial=0
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or (payload.kind~="tram.ride.v1" and payload.kind~="ferry.ride.v1") then return end
        local transport=if payload.kind=="ferry.ride.v1" then "Ferry" else "Tramway"
        serial+=1
        local ticket=serial
        if payload.state=="depart" then
            title.Text=transport.." • "..tostring(payload.destination or "Votre destination")
            progress.Size=UDim2.fromScale(0,1)
            screen.Enabled=true
            local duration=math.clamp(tonumber(payload.duration) or 8,2,120)
            TweenService:Create(progress,TweenInfo.new(duration,Enum.EasingStyle.Linear),{Size=UDim2.fromScale(1,1)}):Play()
        elseif payload.state=="arrive" then
            progress.Size=UDim2.fromScale(1,1)
            title.Text=transport.." • Arrivée à destination"
            task.delay(2.5,function() if serial==ticket then screen.Enabled=false end end)
        elseif payload.state=="cancel" then
            screen.Enabled=false
        end
    end)
end
return UI

]])
source(client,"TravelTransition","ModuleScript",[[
--!strict
local Players=game:GetService("Players")
local Transition={}
function Transition.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityTravelStatus";gui.ResetOnSpawn=false;gui.DisplayOrder=12
    gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local label=Instance.new("TextLabel")
    label.AnchorPoint=Vector2.new(0.5,1)
    label.Position=UDim2.new(0.5,0,1,-75)
    label.Size=UDim2.new(0.85,0,0,56)
    label.BackgroundColor3=Color3.fromRGB(30,104,100)
    label.TextColor3=Color3.fromRGB(197,244,240)
    label.Font=Enum.Font.GothamBold;label.TextSize=17;label.TextWrapped=true
    label.Visible=false;label.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=label
    local constraint=Instance.new("UISizeConstraint");constraint.MaxSize=Vector2.new(500,56);constraint.Parent=label
    remote.OnClientEvent:Connect(function(payload)
        if type(payload)~="table" then return end
        if payload.kind=="travel.pending.v1" then
            label.Text="Passage vers "..tostring(payload.destination or "votre destination").."…"
            label.Visible=true
        elseif payload.kind=="travel.failure.v1" or payload.kind=="travel.complete.v1" then
            label.Visible=false
        end
    end)
    Players.LocalPlayer.CharacterAdded:Connect(function() label.Visible=false end)
end
return Transition

]])
source(client,"VistaCamera","ModuleScript",[[
--!strict
-- V5 : points de vue panoramiques locaux. Aucun kOA, HTTP ni asset externe.
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local Vista={}
local active=false
local savedType=nil
local savedFieldOfView=70
local originFrame=CFrame.new()
local angle=0
local fieldOfView=58
local gui=nil
local heading=nil

local function corner(parent,radius)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,radius)
    c.Parent=parent
end
local function restore()
    if not active then return end
    active=false
    if gui then gui.Enabled=false end
    local camera=Workspace.CurrentCamera
    if camera then
        camera.CameraType=savedType or Enum.CameraType.Custom
        camera.FieldOfView=savedFieldOfView
        local character=player.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then camera.CameraSubject=humanoid end
    end
end
local function apply()
    if not active then return end
    local camera=Workspace.CurrentCamera
    if not camera then return end
    camera.CameraType=Enum.CameraType.Scriptable
    camera.CFrame=originFrame*CFrame.Angles(0,math.rad(angle),0)
    camera.FieldOfView=fieldOfView
end
local function control(parent,label,x,width,action)
    local button=Instance.new("TextButton")
    button.Name=label
    button.Size=UDim2.new(0,width,0,40)
    button.Position=UDim2.fromOffset(x,66)
    button.Text=label
    button.TextColor3=Color3.fromRGB(239,243,239)
    button.TextSize=15
    button.Font=Enum.Font.GothamBold
    button.BackgroundColor3=Color3.fromRGB(50,101,111)
    button.Parent=parent
    corner(button,8)
    button.Activated:Connect(action)
    return button
end
function Vista.start(remote)
    local g=Instance.new("ScreenGui")
    g.Name="KinCityPanorama"
    g.ResetOnSpawn=false
    g.IgnoreGuiInset=false
    g.DisplayOrder=35
    g.Enabled=false
    g.Parent=player:WaitForChild("PlayerGui")
    gui=g
    local bar=Instance.new("Frame")
    bar.Size=UDim2.fromOffset(380,119)
    bar.Position=UDim2.new(0.5,-190,1,-148)
    bar.BackgroundColor3=Color3.fromRGB(28,47,58)
    bar.BackgroundTransparency=0.05
    bar.Parent=g
    corner(bar,12)
    local header=Instance.new("TextLabel")
    header.BackgroundTransparency=1
    header.Position=UDim2.fromOffset(13,8)
    header.Size=UDim2.fromOffset(355,28)
    header.Text="PANORAMA · KIN CITY"
    header.TextSize=17
    header.TextColor3=Color3.fromRGB(241,237,218)
    header.Font=Enum.Font.GothamBold
    header.Parent=bar
    heading=header
    local hint=Instance.new("TextLabel")
    hint.BackgroundTransparency=1
    hint.Position=UDim2.fromOffset(12,34)
    hint.Size=UDim2.fromOffset(356,26)
    hint.Text="Regarder autour · Zoomer · F pour revenir"
    hint.TextColor3=Color3.fromRGB(196,220,219)
    hint.TextSize=12
    hint.Font=Enum.Font.Gotham
    hint.Parent=bar
    control(bar,"◀",12,54,function()angle=math.clamp(angle-15,-125,125);apply() end)
    control(bar,"▶",72,54,function()angle=math.clamp(angle+15,-125,125);apply() end)
    control(bar,"+",132,45,function()fieldOfView=math.max(25,fieldOfView-8);apply() end)
    control(bar,"−",183,45,function()fieldOfView=math.min(80,fieldOfView+8);apply() end)
    control(bar,"RETOUR",238,130,restore)
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="scenic.view.v1" then return end
        if typeof(payload.camera_position)~="Vector3" or typeof(payload.look_at)~="Vector3" then return end
        local camera=Workspace.CurrentCamera
        if not camera then return end
        if active then restore() end
        savedType=camera.CameraType
        savedFieldOfView=camera.FieldOfView
        originFrame=CFrame.lookAt(payload.camera_position,payload.look_at)
        heading.Text=payload.title or "PANORAMA · KIN CITY"
        angle=0
        fieldOfView=58
        active=true
        g.Enabled=true
        apply()
    end)
    UserInputService.InputBegan:Connect(function(input,processed)
        if not active then return end
        if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.F or input.KeyCode==Enum.KeyCode.ButtonB then
            restore()
        elseif not processed and input.KeyCode==Enum.KeyCode.Left then
            angle=math.clamp(angle-15,-125,125);apply()
        elseif not processed and input.KeyCode==Enum.KeyCode.Right then
            angle=math.clamp(angle+15,-125,125);apply()
        end
    end)
    player.CharacterAdded:Connect(restore)
end
return Vista

]])
source(client,"WorkshopHud","ModuleScript",[[
--!strict
-- V14 · Panneau des expériences à trois étapes; compatible tactile et clavier.
-- Affiche un état local de session, sans note, score ou accès réseau.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local WorkshopHud={}
local BG=Color3.fromRGB(28,55,64)
local GOLD=Color3.fromRGB(234,195,123)
local FG=Color3.fromRGB(243,240,220)
local function corner(parent,r)
    local obj=Instance.new("UICorner")
    obj.CornerRadius=UDim.new(0,r);obj.Parent=parent
end
local function label(parent,txt,y,size,bold)
    local line=Instance.new("TextLabel")
    line.Position=UDim2.fromOffset(13,y)
    line.Size=UDim2.new(1,-26,0,size+10)
    line.BackgroundTransparency=1
    line.TextColor3=FG
    line.Text=txt;line.TextWrapped=true
    line.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    line.TextSize=size
    line.TextXAlignment=Enum.TextXAlignment.Left
    line.Parent=parent
    return line
end
function WorkshopHud.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityWorkshopHud";gui.ResetOnSpawn=false;gui.DisplayOrder=9
    gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local button=Instance.new("TextButton")
    button.Text="ATELIERS [K]";button.Font=Enum.Font.GothamBold;button.TextSize=12
    button.TextColor3=FG;button.BackgroundColor3=BG
    button.Position=UDim2.new(1,-141,0,82)
    button.Size=UDim2.fromOffset(126,35);button.Parent=gui;corner(button,9)
    local panel=Instance.new("Frame")
    panel.Name="Progression";panel.Visible=false
    panel.Position=UDim2.new(1,-15,0,125);panel.AnchorPoint=Vector2.new(1,0)
    panel.Size=UDim2.fromOffset(286,184)
    panel.BackgroundColor3=BG;panel.Parent=gui;corner(panel,11)
    local title=label(panel,"ATELIERS PUBLICS",12,16,true)
    title.TextColor3=GOLD
    local detail=label(panel,"Approche une machine d'agora et active les étapes 1, 2, puis 3.",48,12,false)
    detail.Size=UDim2.new(1,-26,0,51)
    local marks=Instance.new("Frame")
    marks.Position=UDim2.fromOffset(16,109)
    marks.Size=UDim2.fromOffset(256,22)
    marks.BackgroundTransparency=1;marks.Parent=panel
    local cells={}
    for i=1,3 do
        local dot=Instance.new("TextLabel")
        dot.Size=UDim2.fromOffset(78,23)
        dot.Position=UDim2.fromOffset((i-1)*89,0)
        dot.Text="ÉTAPE "..i;dot.TextSize=11;dot.Font=Enum.Font.GothamBold
        dot.TextColor3=FG;dot.BackgroundColor3=Color3.fromRGB(67,92,96)
        dot.Parent=marks;corner(dot,7);cells[i]=dot
    end
    local foot=label(panel,"Jusqu'à 48 secondes entre les étapes. Aucun compte requis.",141,11,false)
    foot.Size=UDim2.new(1,-26,0,34)
    local function flip()panel.Visible=not panel.Visible end
    button.Activated:Connect(flip)
    UIS.InputBegan:Connect(function(input,handled)
        if not handled and input.KeyCode==Enum.KeyCode.K then flip() end
    end)
    local sequence=0
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="workshop.progress.v1" then return end
        sequence+=1
        local current=sequence
        title.Text=payload.title or "ATELIER PUBLIC"
        local step=math.clamp(tonumber(payload.step) or 1,1,4)
        for i,dot in ipairs(cells) do
            dot.BackgroundColor3=if i<step then Color3.fromRGB(64,157,114) else Color3.fromRGB(67,92,96)
        end
        detail.Text=if step==4 then "Expérience complétée ! Observe l'animation physique." else string.format("Étape %d / 3 · %s",step,if step==1 then "Assembler" elseif step==2 then "Calibrer" else "Animer")
        panel.Visible=true
        task.delay(12,function()
            if current==sequence and panel.Parent then panel.Visible=false end
        end)
    end)
end
return WorkshopHud

]])
server.Source=[[
--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local WorldBuilder=require(script.WorldBuilder)
local PlayerTravel=require(script.PlayerTravel)
local PromptRouter=require(script.PromptRouter)
local Citizens=require(script.Citizens)
local NativeR15Citizens=require(script.NativeR15Citizens)
local Wildlife=require(script.Wildlife)
local WorldAmbience=require(script.WorldAmbience)
local OutdoorAtmosphere=require(script.OutdoorAtmosphere)
local Soundscape=require(script.Soundscape)
local Tramways=require(script.Tramways)
local IslandFerries=require(script.IslandFerries)
local IslandExperiences=require(script.IslandExperiences)
local HarborAndTrailsRuntime=require(script.HarborAndTrailsRuntime)
local ResidentialLife=require(script.ResidentialLife)
local ResidentialResidents=require(script.ResidentialResidents)
local CommunityActivities=require(script.CommunityActivities)
local BoulevardBuses=require(script.BoulevardBuses)
local IntermodalTransfers=require(script.IntermodalTransfers)
local CivicStageRuntime=require(script.CivicStageRuntime)
local LocalMechanisms=require(script.LocalMechanisms)
local ScienceExperiments=require(script.ScienceExperiments)
local DiscoveryLedger=require(script.DiscoveryLedger)
local PromenadeCraftRuntime=require(script.PromenadeCraftRuntime)
local CooperativeRuntime=require(script.CooperativeRuntime)
local UrbanV14Runtime=require(script.UrbanV14Runtime)
local SkyPavilionRuntime=require(script.SkyPavilionRuntime)
local InstitutionDiscoveryRuntime=require(script.InstitutionDiscoveryRuntime)
local LivingExhibitsV23=require(script.LivingExhibitsV23)

local reply=ReplicatedStorage:FindFirstChild("KinCityReply")
if not reply then
    reply=Instance.new("RemoteEvent")
    reply.Name="KinCityReply"
    reply.Parent=ReplicatedStorage
end
-- Le petit installateur autonome peut déjà fournir le personnage.
if not game:GetService("ServerScriptService"):FindFirstChild("KinCityKingKlownAvatar") then
    local avatarConfig=table.clone(require(ReplicatedStorage.KinCityShared.KingKlownConfig))
    local preservedOwner=script:GetAttribute("KingKlownOwnerUserId")
    if avatarConfig.ownerUserId==0 and type(preservedOwner)=="number" and preservedOwner>0 then
        avatarConfig.ownerUserId=preservedOwner
    end
    require(script.KingKlownAvatar).start(avatarConfig)
end
local state=WorldBuilder.build(true)
PlayerTravel.setup(state,reply)
PromptRouter.start(state,reply)
-- Les services spécialisés ne démarrent pas sur des Places où leur contenu
-- n'existe pas. Les intérieurs ne répliquent donc ni flotte ni population urbaine.
LocalMechanisms.start(state.world,reply)
ScienceExperiments.start(state.world,reply)
DiscoveryLedger.start(state.world,reply)
SkyPavilionRuntime.start(state.world,reply)
InstitutionDiscoveryRuntime.start(state.world,reply)
LivingExhibitsV23.start(state.world)
if state.mode=="LOCAL_UNIVERSE" or state.currentPlace=="city" then
    Citizens.start(state.world)
    NativeR15Citizens.start(state.world)
    Wildlife.start(state.world)
    WorldAmbience.start(state.world)
    OutdoorAtmosphere.start(state.world)
    Soundscape.start(state.world)
    Tramways.start(state.world,reply)
    IslandFerries.start(state.world,reply)
    IslandExperiences.start(state.world,reply)
    HarborAndTrailsRuntime.start(state.world,reply)
    ResidentialLife.start(state.world,reply)
    ResidentialResidents.start(state.world)
    CommunityActivities.start(state.world,reply)
    BoulevardBuses.start(state.world,reply)
    IntermodalTransfers.start(state.world,reply)
    CivicStageRuntime.start(state.world,reply)
    PromenadeCraftRuntime.start(state.world,reply)
    CooperativeRuntime.start(state.world,reply)
    UrbanV14Runtime.start(state.world,reply)
end
print("KIN CITY WORLD_STUB prêt",state.mode,state.currentPlace)

]]
client.Source=[[
--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Mode=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("RuntimeConfig"))
local Routing=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("PlaceRouting"))
local isCity=Mode.mode=="LOCAL_UNIVERSE" or Mode.target_place_key=="city" or Routing.city==game.PlaceId
local remote=ReplicatedStorage:WaitForChild("KinCityReply")
require(script.Hud).start(remote)
require(script.TravelTransition).start(remote)
require(script.KingKlownAura).start()
if isCity then
    require(script.MapHud).start()
    require(script.RouteGuide).start()
    require(script.ExplorationJournal).start()
    require(script.VistaCamera).start(remote)
    require(script.TrailHud).start()
    require(script.TramRideHud).start(remote)
    require(script.IslandPassportHud).start()
    require(script.ArchipelagoProgressHud).start()
    require(script.FerryGroupHud).start(remote)
    require(script.BoulevardBusHud).start(remote)
    require(script.IntermodalPanel).start()
    require(script.CooperativeHud).start(remote)
    require(script.WorkshopHud).start(remote)
    require(script.SkyTourHud).start(remote)
    require(script.CitizenAnimationV21).start()
end
require(script.CrystalDetailLOD).start()
require(script.LocalVisualDirectorV22).start()
require(script.GalleryJournalV22).start()
require(script.PlaceIdentityHudV26).start()

]]
-- Instancier aussi les bâtiments en mode édition : la scène ne reste pas vide.
local buildOk, buildErr=pcall(function()
    require(server:WaitForChild("WorldBuilder")).build()
end)
if not buildOk then
    error("Kin City : erreur de génération Studio : "..tostring(buildErr))
end
pcall(function()
    local camera=workspace.CurrentCamera
    if camera then camera.CFrame=CFrame.lookAt(Vector3.new(230,230,270),Vector3.new(0,0,0)) end
end)
server.Enabled = true
client.Enabled = true
-- StreamingEnabled se configure dans les propriétés de Workspace dans Studio.
local streamingOk, streamingValue=pcall(function() return workspace.StreamingEnabled end)
if streamingOk then
    print("KIN CITY : Workspace.StreamingEnabled = "..tostring(streamingValue).." (paramètre Studio)")
end
print("KIN CITY v27 : Place installée séparément, ville allégée et institutions indépendantes; identité sarcelle-cristal, WORLD_STUB.")
