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
local WORLD_BUILD_REVISION="construction-v26.0.0-"..VisualConfig.profile.."-"..BuildIdentity.sha256

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
