--!strict
-- Kin City / B02 / EkoH. Décor additif, sans assets réseau ni action métier.
-- La scène est générée par tools/build_b02.py à partir de scene.json.
-- Intégration B09 EXPLICITE nécessaire après InteriorGenerator.make.
local Builder={}
local SPEC={["contract"]={["building_id"]="central.ekoh_tower",["entry_anchor_id"]="ekoh_tower.lobby.spawn",["entry_door_id"]="city.central.ekoh_tower.entry",["exit_anchor_id"]="ekoh_tower.exit.door",["exit_door_id"]="ekoh_tower.exit",["interaction_anchor_id"]="tower.panel_01",["interaction_id"]="central.ekoh_tower.display_01",["interaction_mode"]="stub",["return_anchor_id"]="city.central.ekoh_tower.return_spawn"},["integration_note"]="B09 doit générer/charger le ModuleScript B02EkohInterior et appeler Build après InteriorGenerator.make, avec le modèle intérieur déjà créé, origin de Spatial.origin, profil graphique; aucun chemin ni ancre n'est modifié.",["owner_branch"]="B02",["panels"]={{["id"]="ekoh_tower.b02.atlas_accueil",["pos"]={0,10.7,-13.0},["room_id"]="ekoh_tower.lobby",["size"]={22,4.6,0.28},["story"]="Un parcours public pour découvrir les espaces EkoH.",["subtitle"]="Observer · comprendre · partager",["title"]="ATLAS DU SAVOIR",["yaw_degrees"]=0},{["id"]="ekoh_tower.b02.contributions",["pos"]={-47.1,10.8,33},["room_id"]="ekoh_tower.gallery",["size"]={15,4.8,0.28},["story"]="Les données des membres ne sont pas connectées.",["subtitle"]="Des idées mises en lumière",["title"]="CONTRIBUTIONS",["yaw_degrees"]=-90},{["id"]="ekoh_tower.b02.observation",["pos"]={47.1,10.8,33},["room_id"]="ekoh_tower.chamber",["size"]={15,4.8,0.28},["story"]="Constellation artistique, non scientifique.",["subtitle"]="Lire les liens entre les savoirs",["title"]="OBSERVATION",["yaw_degrees"]=90},{["id"]="ekoh_tower.b02.observatoire",["pos"]={-79,10.8,30.1},["room_id"]="ekoh_tower.west_wing",["size"]={20,4.8,0.28},["story"]="Exposition illustrative, sans données réelles.",["subtitle"]="Explorer la curiosité collective",["title"]="OBSERVATOIRE EKOH",["yaw_degrees"]=0},{["id"]="ekoh_tower.b02.merite",["pos"]={79,10.8,30.1},["room_id"]="ekoh_tower.east_wing",["size"]={20,4.8,0.28},["story"]="Aucun titre ni distinction n'est attribué ici.",["subtitle"]="L'effort est une aventure",["title"]="GALERIE DU MÉRITE",["yaw_degrees"]=0},{["id"]="ekoh_tower.b02.forum",["pos"]={-48.2,11.3,91.5},["room_id"]="ekoh_tower.rear_atrium",["size"]={17,4.8,0.28},["story"]="Espace de visite, services à venir.",["subtitle"]="De la réflexion au partage",["title"]="FORUM DES SAVOIRS",["yaw_degrees"]=-90}},["place_key"]="ekoh_tower",["profiles"]={["LITE"]={["max_panels"]=6,["max_parts_estimated"]=30,["max_surfaceguis"]=6,["ornament_level"]=0},["SHOWCASE"]={["max_panels"]=6,["max_parts_estimated"]=102,["max_surfaceguis"]=6,["ornament_level"]=2},["STANDARD"]={["max_panels"]=6,["max_parts_estimated"]=66,["max_surfaceguis"]=6,["ornament_level"]=1}},["protected_anchors"]={{["clearance_xz"]={12,6},["id"]="ekoh_tower.exit.door",["pos"]={0,-45}},{["clearance_xz"]={12,9},["id"]="ekoh_tower.lobby.spawn",["pos"]={0,-32}},{["clearance_xz"]={8,8},["id"]="tower.panel_01",["pos"]={-27,18}}},["protected_portals"]={{["clearance_xz"]={8,8},["id"]="ekoh_tower.portal.lobby.chamber",["pos"]={27,-10.5}},{["clearance_xz"]={8,8},["id"]="ekoh_tower.portal.lobby.gallery",["pos"]={-27,-10.5}},{["clearance_xz"]={6,8},["id"]="ekoh_tower.gallery_to_west",["pos"]={-51,16}},{["clearance_xz"]={6,8},["id"]="ekoh_tower.chamber_to_east",["pos"]={51,16}},{["clearance_xz"]={8,7},["id"]="ekoh_tower.gallery_to_rear",["pos"]={-27,45.5}},{["clearance_xz"]={8,7},["id"]="ekoh_tower.chamber_to_rear",["pos"]={27,45.5}}},["revision"]="b02-ekoh-atlas-1.0.0",["rooms"]={{["canonical"]=true,["center"]={0,0,-29},["display_name"]="Accueil",["purpose"]="Orientation des visites et annonce du partage du savoir",["room_id"]="ekoh_tower.lobby",["size"]={100,16,34}},{["canonical"]=true,["center"]={-27,0,17},["display_name"]="Galerie des contributions",["purpose"]="Réalisations présentées sans faux palmarès ni données de comptes",["room_id"]="ekoh_tower.gallery",["size"]={44,16,52}},{["canonical"]=true,["center"]={27,0,17},["display_name"]="Salle d’observation",["purpose"]="Observation pédagogique, constellation visuelle simulée",["room_id"]="ekoh_tower.chamber",["size"]={44,16,52}},{["canonical"]=false,["center"]={-79,0,7},["display_name"]="Observatoire EkoH",["purpose"]="Concepts et trajectoires de découverte",["room_id"]="ekoh_tower.west_wing",["size"]={52,16,50}},{["canonical"]=false,["center"]={79,0,7},["display_name"]="Galerie du mérite",["purpose"]="Encouragement de l'effort sans récompenses inventées",["room_id"]="ekoh_tower.east_wing",["size"]={52,16,50}},{["canonical"]=false,["center"]={0,0,76},["display_name"]="Forum de la connaissance",["purpose"]="Vue panoramique et convivialité, respect des escaliers et ascenseur",["room_id"]="ekoh_tower.rear_atrium",["size"]={100,16,56}}},["schema_version"]="kincity.b02-ekoh-scene/1.0",["visual_language"]={["bronze_hex"]="#CCA667",["identity"]="Art déco savant : opale, bronze, sarcelle structurelle, constellations géométriques",["ink_hex"]="#243946",["name"]="Atlas du savoir",["note"]="EkoH se trouve dans le secteur central : aucune septième couleur de district n'est créée.",["primary_hex"]="#1E6864",["stone_hex"]="#E5EAE7"}}

local MIN_RANK={LITE=1,STANDARD=2,SHOWCASE=3}
local COLORS={
    teal=Color3.fromRGB(30,104,100),
    bronze=Color3.fromRGB(204,166,103),
    opal=Color3.fromRGB(229,234,231),
    ink=Color3.fromRGB(36,57,70),
}

local function noCollision(part: BasePart)
    part.Anchored=true
    part.CanCollide=false
    part.CanTouch=false
    part.CanQuery=false
    part.CastShadow=false
end

local function part(parent: Instance,name: string,size: Vector3,frame: CFrame,color: Color3,material: Enum.Material)
    local item=Instance.new("Part")
    item.Name=name
    item.Size=size
    item.CFrame=frame
    item.Color=color
    item.Material=material
    noCollision(item)
    item.Parent=parent
    return item
end

local function text(gui: SurfaceGui, name: string, words: string, y: number, height: number, fontSize: number,color: Color3)
    local item=Instance.new("TextLabel")
    item.Name=name
    item.Size=UDim2.fromScale(0.92,height)
    item.Position=UDim2.fromScale(0.04,y)
    item.BackgroundTransparency=1
    item.Font=Enum.Font.GothamBold
    item.Text=words
    item.TextColor3=color
    item.TextSize=fontSize
    item.TextScaled=false
    item.TextWrapped=true
    item.TextXAlignment=Enum.TextXAlignment.Center
    item.TextYAlignment=Enum.TextYAlignment.Center
    item.Parent=gui
    return item
end

local function panel(parent: Instance,origin: Vector3,slot: any, profile: string)
    local r=slot.pos
    local s=slot.size
    local frame=CFrame.new(origin+Vector3.new(r[1],r[2],r[3]))*CFrame.Angles(0,math.rad(slot.yaw_degrees),0)
    local face=part(parent,slot.id..".fond",Vector3.new(s[1],s[2],s[3]),frame,COLORS.ink,Enum.Material.Metal)
    face:SetAttribute("KinB02DecorId",slot.id)
    face:SetAttribute("KinB02RoomId",slot.room_id)
    face:SetAttribute("KinB02NonFunctional",true)
    local board=Instance.new("SurfaceGui")
    board.Name="Lecture EkoH"
    board.Face=Enum.NormalId.Front
    board.SizingMode=Enum.SurfaceGuiSizingMode.FixedSize
    board.CanvasSize=Vector2.new(640,180)
    board.LightInfluence=0.45
    board.Brightness=1
    board.AlwaysOnTop=false
    board.Parent=face
    text(board,"Titre",slot.title,0.11,0.42,34,COLORS.opal)
    text(board,"Sous-titre",slot.subtitle,0.55,0.28,22,COLORS.bronze)
    local count=1
    if MIN_RANK[profile]>=2 then
        local left=frame*CFrame.new(-s[1]/2+0.08,0,-0.23)
        local right=frame*CFrame.new(s[1]/2-0.08,0,-0.23)
        part(parent,slot.id..".filet-g",Vector3.new(0.15,s[2]+0.12,0.13),left,COLORS.bronze,Enum.Material.Metal)
        part(parent,slot.id..".filet-d",Vector3.new(0.15,s[2]+0.12,0.13),right,COLORS.bronze,Enum.Material.Metal)
        part(parent,slot.id..".filet-bas",Vector3.new(s[1],0.15,0.13),frame*CFrame.new(0,-s[2]/2+0.09,-0.23),COLORS.teal,Enum.Material.Metal)
        count+=3
    end
    if MIN_RANK[profile]>=3 then
        -- Frise haute : motifs neutres, non lumineux et sans collisions.
        for index=-1,1 do
            local stripe=part(parent,slot.id..".frise."..index,
                Vector3.new(math.min(1.3,s[1]/7),0.14,0.12),
                frame*CFrame.new(index*math.min(2.2,s[1]/5),s[2]/2-0.2,-0.23),
                COLORS.opal,Enum.Material.Metal)
            stripe.Transparency=0.05
            count+=1
        end
    end
    return count
end

function Builder.Build(context: any)
    assert(type(context)=="table","B02: context table requis")
    assert(context.place_key=="ekoh_tower","B02: Place incorrecte")
    local model=context.model
    assert(typeof(model)=="Instance" and model:IsA("Model"),"B02: modèle intérieur requis")
    assert(model:GetAttribute("KinPlaceKey")=="ekoh_tower","B02: mauvais KinPlaceKey")
    local origin=context.origin
    assert(typeof(origin)=="Vector3","B02: origin Vector3 requis (Spatial.origin)")
    local profile=context.profile or "STANDARD"
    assert(MIN_RANK[profile]~=nil,"B02: profil graphique inconnu")
    -- Pré-vérifier la présence des six salles AVANT de créer quoi que ce soit.
    for _,room in ipairs(SPEC.rooms) do
        local existing=model:FindFirstChild(room.room_id)
        assert(existing~=nil and existing:IsA("Folder"),"B02: salle absente: "..room.room_id)
    end
    local existing=model:FindFirstChild("KinB02_EkoH_Atlas")
    if existing~=nil then
        assert(existing:GetAttribute("KinB02Revision")==SPEC.revision,"B02: version de décor incompatible")
        assert(existing:GetAttribute("KinB02Profile")==profile,"B02: profil changé; requiert reconstruction explicite du monde")
        return existing,{status="ALREADY_BUILT",panels=6,parts=existing:GetAttribute("KinB02Parts") or 0}
    end
    local root=Instance.new("Folder")
    root.Name="KinB02_EkoH_Atlas"
    root:SetAttribute("KinB02Revision",SPEC.revision)
    root:SetAttribute("KinB02PlaceKey",SPEC.place_key)
    root:SetAttribute("KinB02Profile",profile)
    root:SetAttribute("KinB02NonFunctional",true)
    -- Un seul parent; en cas d'erreur durant le build, nettoyage du dossier dédié.
    local success,total=xpcall(function()
        local parts=0
        for _,slot in ipairs(SPEC.panels) do
            parts+=panel(root,origin,slot,profile)
        end
        return parts
    end,debug.traceback)
    if not success then
        root:Destroy()
        error("B02: génération annulée: "..tostring(total))
    end
    root:SetAttribute("KinB02Parts",total)
    root:SetAttribute("KinB02PanelCount",#SPEC.panels)
    root.Parent=model
    return root,{status="BUILT",panels=#SPEC.panels,parts=total}
end

return Builder
