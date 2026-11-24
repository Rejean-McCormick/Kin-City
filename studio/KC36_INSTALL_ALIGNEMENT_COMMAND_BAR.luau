-- KC36 : MIGRATION PERMANENTE B09/B10 + GEOMETRIE
-- Exécuter une seule fois, Command Bar, en mode Edition dans KinCity_36_DEV.rbxl.
-- Conserve le Package central lié. Reconstruit la scène depuis le runtime source.
local RunService=game:GetService("RunService")
local Store=game:GetService("ServerStorage")
local Server=game:GetService("ServerScriptService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Arrêter Play")
assert(game.PlaceId==0,"Uniquement la copie locale KinCity_36_DEV")
local library=assert(Store:FindFirstChild("KinCityArtDecoLibrary"),"Package 121 absent")
assert(library:FindFirstChildOfClass("PackageLink"),"PackageLink central absent")
assert(library:GetAttribute("KinSourceCount")==121,"Sources 121/121 requises")
local originals=0
for _,v in ipairs(library:GetChildren()) do
    if v:IsA("Model") and v.Name:match("^KC32__AD_") then originals+=1 end
end
assert(originals==121,"Les 121 modèles ne sont pas présents")
assert(workspace.StreamingEnabled,"Activer StreamingEnabled")
assert(workspace:GetAttribute("KinArtDecoTestPlace")==true,"Copie locale de test non déclarée")
local Replicated=game:GetService("ReplicatedStorage")
local oldShared=assert(Replicated:FindFirstChild("KinCityShared"),"KinCityShared absent")
local oldRuntime=assert(Server:FindFirstChild("KinCityRuntime"),"Runtime KC35 absent")
local oldWorld=assert(workspace:FindFirstChild("KinCityGenerated"),"Monde KC35 absent")
assert(oldWorld:GetAttribute("KinBuildState")=="Ready","Monde KC35 non prêt")
assert(not Store:FindFirstChild("KC36AlignmentBackup"),"Migration déjà lancée; inspecter le backup")
local proposed=oldRuntime:Clone()
assert(proposed,"Runtime non clonable")
proposed.Enabled=false
local proposedShared=oldShared:Clone()
assert(proposedShared,"KinCityShared non clonable")
do
    local identity=proposedShared:FindFirstChild("BuildIdentity")
    assert(identity and identity:IsA("ModuleScript"),"BuildIdentity absent")
    identity.Source=[[--!strict
-- Généré automatiquement : empreinte exacte du build v29
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["input_count"] = 219,
  ["plan_sha256"] = "5941cd6ecd89ea806cd5b815fcc128b1abef1cff77f77d670dbe01c7f487039a",
  ["sha256"] = "4a3f70f075eef5f21550b12670caa70ed60837be5ddbc3ac693eeacd00524c6d",
  ["version"] = "build-v29",
}

]]
end
do
    local code=[[--!strict
-- Pure architecture compiler: dimensions, entrance and silhouette exist without any imported mesh.
-- Plain Lua deliberately: the exact renderer input is exercised by offline behavioral tests.
local Layout={}
-- Autorité de surface : la pelouse de l'île est à Y=0 et les voies natives
-- culminent à Y=0.21. Une fondation à Y=0 engendrait un z-fighting certain.
Layout.SITE_FLOOR_TOP_STUDS=0.32
Layout.SITE_FLOOR_THICKNESS_STUDS=0.60
local function part(plan,name,size,center,role,solid)
    table.insert(plan.parts,{name=name,size=size,center=center,role=role,solid=solid==true})
end
function Layout.compile(width,depth,height,recipe)
    assert(width>20 and depth>20 and height>14,"Institution envelope too small")
    local body=height*recipe.body_height_ratio
    local opening=recipe.entry_width
    local doorHeight=math.min(recipe.entry_height,body-2)
    assert(opening>=8 and opening<width-8 and doorHeight>=8,"Invalid public entrance")
    local plan={parts={},slots={},primary_shells={},primary_parts={},width=width,depth=depth,height=height,
        entry={width=opening,height=doorHeight,z=-depth/2},body_height=body,shape=recipe.shape}
    local half=(width-opening)/2
    part(plan,"Floor",{width,Layout.SITE_FLOOR_THICKNESS_STUDS,depth},
        {0,Layout.SITE_FLOOR_TOP_STUDS-Layout.SITE_FLOOR_THICKNESS_STUDS/2,0},"stone",true)
    part(plan,"FrontLeft",{half,body,.65},{-(opening/2+half/2),body/2,-depth/2},"stone",true)
    part(plan,"FrontRight",{half,body,.65},{opening/2+half/2,body/2,-depth/2},"stone",true)
    part(plan,"FrontLintel",{opening,body-doorHeight,.65},{0,doorHeight+(body-doorHeight)/2,-depth/2},"stone",true)
    part(plan,"RearWall",{width,body,.65},{0,body/2,depth/2},"stone",true)
    for _,side in ipairs({-1,1}) do
        part(plan,"SideWall"..side,{.65,body,depth},{side*width/2,body/2,0},"stone",true)
        part(plan,"EntrancePier"..side,{1.2,doorHeight+1.5,1.2},{side*(opening/2+1.5),(doorHeight+1.5)/2,-depth/2-.8},"bronze",false)
        part(plan,"Window"..side,{width*.19,math.min(10,body-4),.2},{side*width*.29,body*.52,-depth/2-.45},"glazing",false)
        part(plan,"WindowCrown"..side,{width*.20,.35,.35},{side*width*.29,body*.52+math.min(10,body-4)/2,-depth/2-.6},"bronze",false)
        table.insert(plan.slots,{name="EntranceColumn"..side,asset=recipe.columns_asset,
            size={2,doorHeight+2,2},center={side*(opening/2+2),0,-depth/2-1},optional=true})
        table.insert(plan.slots,{name="ArchedWindow"..side,asset=recipe.window_asset,
            size={width*.19,math.min(10,body-4),1},center={side*width*.29,body*.52-math.min(10,body-4)/2,-depth/2-.65},optional=true})
    end
    part(plan,"Roof",{width,.6,depth},{0,body+.3,0},"dark",true)
    for _,side in ipairs({-1,1}) do
        part(plan,"RoofCorniceFront"..side,{width+.4,.4,.5},{0,body+.6,side*depth/2},"bronze",false)
        part(plan,"RoofCorniceSide"..side,{.5,.4,depth},{side*width/2,body+.6,0},"bronze",false)
    end
    part(plan,"UpperFrieze",{width,.35,.35},{0,body-1,-depth/2-.45},"teal",false)
    for _,side in ipairs({-1,1}) do
        part(plan,"FacadeFin"..side,{.55,body-1,.65},{side*width*.46,body/2,-depth/2-.5},"bronze",false)
        for _,bay in ipairs({-1,1}) do
            part(plan,"SideGlazing"..side..bay,{.2,math.min(8,body-5),depth*.22},
                {side*(width/2+.4),body*.52,bay*depth*.24},"glazing",false)
        end
    end
    part(plan,"EntranceHighlight",{opening+4,.35,.7},{0,doorHeight+.75,-depth/2-1},"accent",false)
    local top=height-body-.6
    if recipe.shape=="observatory" then
        part(plan,"ObservatoryShaft",{width*.42,top,depth*.42},{0,body+.6+top/2,0},"teal",false)
        for _,side in ipairs({-1,1}) do
            part(plan,"TowerFin"..side,{.6,top,.8},{side*width*.21,body+.6+top/2,-depth*.21-.4},"bronze",false)
        end
    elseif recipe.shape=="campus" then
        for _,side in ipairs({-1,1}) do
            part(plan,"AcademicWing"..side,{width*.23,top*.85,depth*.70},{side*width*.33,body+.6+top*.425,0},"stone",false)
        end
    elseif recipe.shape=="gallery" then
        for level=1,3 do
            local h=top/3
            part(plan,"GalleryStep"..level,{width*(.70-level*.12),h,depth*(.65-level*.10)},
                {0,body+.6+(level-.5)*h,0},"stone",false)
        end
    else
        local spans={civic=.45,court=.64,atelier=.76,library=.82,services=.50}
        local span=assert(spans[recipe.shape],"Unknown institution silhouette")
        part(plan,"RaisedPavilion",{width*span,top*.85,depth*.55},{0,body+.6+top*.425,0},"stone",false)
        part(plan,"UpperHighlight",{width*span,.4,.4},{0,body+.6+top*.70,-depth*.275-.3},"accent",false)
    end
    -- All features are anchored to an architectural location, never stacked into a generic tower.
    table.insert(plan.slots,{name="InstitutionFeature",asset=recipe.feature_asset,
        size={width*(recipe.shape=="observatory" and .42 or .36),math.max(1,top),depth*(recipe.shape=="observatory" and .42 or .36)},center={0,body+.6,recipe.shape=="observatory" and 0 or -depth*.32},optional=true})
    -- The streetscape is a pair of full-sized imported building wings. The
    -- destination interior is elsewhere; these volumes need no internal rooms.
    local source=recipe.shell_source_size
    local wingWidth=(width-opening-8)/2
    local scale=math.min(wingWidth/source[1],(depth-4)/source[3],body/source[2])
    local sx,sy,sz=source[1]*scale,source[2]*scale,source[3]*scale
    local canopyHeight=math.max(sy,doorHeight+3.5)
    plan.shell_height=sy
    for _,side in ipairs({-1,1}) do
        local center={side*(opening/2+4+sx/2),0,-depth/2+sz/2+.5}
        table.insert(plan.primary_shells,{name="PrimaryArtDecoWing"..side,asset=recipe.shell_asset,
            size={sx,sy,sz},center=center})
        table.insert(plan.primary_parts,{name="WingCollision"..side,size={sx,sy,sz},
            center={center[1],sy/2,center[3]},role="stone",solid=true,invisible=true})
    end
    table.insert(plan.primary_parts,{name="PortalLintel",size={opening+8,.6,2},
        center={0,doorHeight+.8,-depth/2},role="bronze",solid=false})
    table.insert(plan.primary_parts,{name="ConnectingCanopy",size={opening+8,.5,math.min(sz,12)},
        center={0,canopyHeight+.3,-depth/2+math.min(sz,12)/2+.5},role="teal",solid=false})
    table.insert(plan.primary_parts,{name="SectorFrieze",size={width,.4,.4},
        center={0,canopyHeight+.6,-depth/2+.2},role="accent",solid=false})
    plan.primary_feature={name="InstitutionFeature",asset=recipe.feature_asset,
        size={width*.42,math.max(1,height-canopyHeight-1),depth*.42},
        center={0,canopyHeight+.8,recipe.shape=="observatory" and 0 or -depth/2+sz*.65}}
    plan.sign={center={0,doorHeight+2.6,-depth/2-1.2},width=math.min(width-14,26),height=2.6}
    return plan
end
return Layout

]]
    local module=proposed:FindFirstChild("ArtDecoLayout")
    if not module then module=Instance.new("ModuleScript");module.Name="ArtDecoLayout";module.Parent=proposed end
    assert(module:IsA("ModuleScript"),"ArtDecoLayout: classe inattendue")
    module.Source=code
end
do
    local code=[[--!strict
-- Exterior shells only. Doors continue to lead to the original remote interiors.
local Data=require(script.Parent.ArtDecoData)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Districts=require(Shared.HexagonalDistricts)
local Theme=require(Shared.ArtDecoTheme)
local Factory=require(script.Parent.Factory)
local Assets=require(script.Parent.ArtDecoAssets)
local Layout=require(script.Parent.ArtDecoLayout)
local Buildings={}
function Buildings.make(parent,structure,building,frame)
    local recipe=assert(Data.placements.buildings[building.building_id],"Missing institution composition")
    local w,d=table.unpack(structure.footprint_studs)
    local plan=Layout.compile(w,d,structure.height_studs,recipe)
    local section=Districts.byKey(building.district_id)
    local colors=table.clone(Theme)
    colors.accent=if section then section.color else Districts.base
    local function imported(slot)
        local model=Assets.place(parent,slot.asset,building.district_id,Vector3.new(table.unpack(slot.size)),
            frame*CFrame.new(table.unpack(slot.center)),"building/"..building.building_id)
        if model then model.Name=slot.name end
        return model
    end
    local shells={}
    -- Reserve major masses first; ornaments cannot starve building architecture.
    for _,slot in ipairs(plan.primary_shells) do
        local model=imported(slot)
        if model then
            model:SetAttribute("KinExteriorShell",true)
            table.insert(shells,model)
        end
    end
    local complete=#shells==#plan.primary_shells
    if not complete then
        for _,model in ipairs(shells) do Assets.release(model) end
    end
    local feature=false
    if complete then
        feature=imported(plan.primary_feature)~=nil
        for _,slot in ipairs(plan.slots) do
            if string.sub(slot.name,1,14)=="EntranceColumn" then imported(slot) end
        end
    else
        -- Explicit fallback keeps the original procedural envelope usable.
        for _,slot in ipairs(plan.slots) do
            if imported(slot) and slot.name=="InstitutionFeature" then feature=true end
        end
    end
    local specs={}
    if complete then
        for _,spec in ipairs(plan.primary_parts) do table.insert(specs,spec) end
        table.insert(specs,plan.parts[1]) -- walkable site floor
    else
        for _,spec in ipairs(plan.parts) do
            local tower=spec.name=="ObservatoryShaft" or string.sub(spec.name,1,8)=="TowerFin"
            if not (tower and feature) then table.insert(specs,spec) end
        end
    end
    for _,spec in ipairs(specs) do
        local piece=Factory.part(parent,spec.name,Vector3.new(table.unpack(spec.size)),
            frame*CFrame.new(table.unpack(spec.center)),assert(colors[spec.role]),
            if spec.role=="bronze" or spec.role=="accent" then Enum.Material.Metal else Enum.Material.SmoothPlastic)
        piece.Transparency=if spec.invisible then 1 else 0
        piece.CanCollide=spec.solid;piece.CanTouch=false;piece.CanQuery=spec.solid
        piece.CastShadow=spec.solid and not spec.invisible
        piece:SetAttribute("KinArchitectureRole",spec.role)
        piece:SetAttribute("KinArchitecturePiece",spec.name)
        if spec.name=="Floor" then
            piece:SetAttribute("KinGroundAuthority","institution-foundation")
            piece:SetAttribute("KinGroundOwner",building.building_id)
            piece:SetAttribute("KinGroundTop",Layout.SITE_FLOOR_TOP_STUDS)
        end
    end
    parent:SetAttribute("KinExteriorShellCount",if complete then #shells else 0)
    parent:SetAttribute("KinInteriorLocation","separate_destination")
    parent:SetAttribute("KinEntranceClearWidth",plan.entry.width)
    parent:SetAttribute("KinArchitectureShape",recipe.shape)
    parent:SetAttribute("KinFootprintWidth",w)
    parent:SetAttribute("KinFootprintDepth",d)
    return plan
end
return Buildings

]]
    local module=proposed:FindFirstChild("ArtDecoBuildings")
    if not module then module=Instance.new("ModuleScript");module.Name="ArtDecoBuildings";module.Parent=proposed end
    assert(module:IsA("ModuleScript"),"ArtDecoBuildings: classe inattendue")
    module.Source=code
end
do
    local code=[[--!strict
-- Koali v31 : ville-interface avec axes piétons, allées alignées et lots repérables.
-- Les pavillons sont des aperçus, pas des façades qui prétendent ouvrir des APIs.
-- Les huit vrais intérieurs et leurs portes restent gérés par WorldPlan.
local Factory=require(script.Parent.Factory)
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local ArtDecoProps=require(script.Parent.ArtDecoProps)
local Urbanism={}
local ArtDecoTheme=require(Shared.ArtDecoTheme)
local TEAL=Districts.base
local STONE=ArtDecoTheme.stone
local INK=Color3.fromRGB(30,45,48)
local GOLD=Color3.fromRGB(181,149,94)
local preview={
    keenkonnect={
        {title="Konstruct",subtitle="Atelier des projets",owner="Konnaxion / keenKonnect"},
        {title="Stockage",subtitle="Plans et ressources versionnés",owner="Konnaxion / keenKonnect"},
        {title="Co-création",subtitle="Atelier des équipes",owner="Konnaxion / keenKonnect"},
    },
    ethikos={
        {title="Korum",subtitle="Arguments et délibération",owner="Konnaxion / ethiKos"},
        {title="Konsultations",subtitle="Consultation et propositions",owner="Konnaxion / ethiKos"},
        {title="Smart Vote",subtitle="Lectures distinctes des votes",owner="Konnaxion / Smart Vote"},
    },
    kreative={
        {title="Konservation",subtitle="Mémoire et patrimoine",owner="Konnaxion / Kreative"},
        {title="Kontact",subtitle="Réseaux et occasions",owner="Konnaxion / Kreative"},
        {title="Scène Kreative",subtitle="Créations collectives",owner="Konnaxion / Kreative"},
    },
    uckk={
        {title="Médiathèque",subtitle="Ressources et lectures",owner="Université King Klown"},
        {title="Activités",subtitle="Cours et ateliers",owner="Université King Klown"},
        {title="Agora du campus",subtitle="Rencontres et échanges",owner="Université King Klown"},
    },
    ekole={
        {title="Ekole",subtitle="Notions et activités",owner="Ekole"},
        {title="Kristal",subtitle="Artéfacts de savoir portables",owner="Kristal"},
        {title="Konstellation",subtitle="Lecteurs et perspectives",owner="Konstellation / lecture"},
    },
    konnected={
        {title="Knowledge",subtitle="Bibliothèque d'apprentissage",owner="Konnaxion / KonnectED"},
        {title="CertifiKation",subtitle="Évaluation et portfolios",owner="Konnaxion / KonnectED"},
        {title="KonnectED",subtitle="Parcours et mentorat",owner="Konnaxion / KonnectED"},
    },
}
local function piece(parent,name,size,cf,color,material,solid)
    local p=Factory.part(parent,name,size,cf,color,material)
    p.CanCollide=(solid==true)
    p.CanTouch=false
    p.CastShadow=solid==true
    return p
end
local function beam(parent,name,a,b,width,height,color,material)
    local d=b-a
    return piece(parent,name,Vector3.new(d.Magnitude,height,width),
        CFrame.new((a+b)*0.5)*CFrame.Angles(0,-math.atan2(d.Z,d.X),0),color,material,false)
end
local function occupied(x,z,structures,margin)
    for _,b in ipairs(structures) do
        local dx,dz=x-b.center_studs[1],z-b.center_studs[3]
        local theta=math.rad(b.yaw_degrees)
        local bx=math.cos(theta)*dx-math.sin(theta)*dz
        local bz=math.sin(theta)*dx+math.cos(theta)*dz
        if math.abs(bx)<b.footprint_studs[1]/2+margin and math.abs(bz)<b.footprint_studs[2]/2+margin then
            return true
        end
    end
    return false
end
local function directions(s)
    local axis=Vector3.new(s.x,0,s.z)
    local side=Vector3.new(-s.z,0,s.x)
    return axis,side
end
local function site(s,i,structures,chosen)
    local axis,side=directions(s)
    local radii={164,278,365}
    local r=radii[i]
    local polarity=if i==2 then -1 else 1
    -- Emplacements en façade d'allée : les fonctions occupent des parcelles
    -- régulières de 30×23 et ne bloquent jamais le boulevard de 20 studs.
    for _,rr in ipairs({r,r+24,r-24,r+42,r-42}) do
        for _,shift in ipairs({78,91,64,103,-78,-91,-64,-103}) do
            local v=axis*rr+side*shift*polarity
            if v.Magnitude<445 and math.abs(shift)>=64 and not occupied(v.X,v.Z,structures,27) then
                local safe=true
                for _,old in ipairs(chosen) do
                    if (old-v).Magnitude<49 then safe=false;break end
                end
                if safe then return v end
            end
        end
    end
    return nil
end
local function makeSites(structures)
    local chosen={}
    local result={}
    for _,s in ipairs(Districts.sections) do
        for i,info in ipairs(preview[s.key]) do
            local p=site(s,i,structures,chosen)
            if p then
                table.insert(chosen,p)
                table.insert(result,{section=s,info=info,index=i,position=p})
            else
                warn("Koali: parcelle ignorée, pas de dégagement pour "..s.key.." / "..info.title)
            end
        end
    end
    return result
end
local reserved={}
function Urbanism.isReserved(x,z)
    for _,v in ipairs(reserved) do
        if math.abs(x-v.X)<24 and math.abs(z-v.Z)<24 then return true end
    end
    local r=math.sqrt(x*x+z*z)
    if r>=58 and r<432 then
        local s=Districts.nearestAxis(x,z)
        if s then
            local side=Vector3.new(-s.z,0,s.x)
            local lateral=x*side.X+z*side.Z
            if math.abs(lateral)<32 then return true end
        end
    end
    return false
end
local function decorativeBench(parent,base,side,accent,sector,step)
    if ArtDecoProps.selected("bench",step) and ArtDecoProps.street(parent,"bench",base*CFrame.new(side*30,0,0),sector) then return end
    piece(parent,"Banc – assise",Vector3.new(6,0.75,2.5),base*CFrame.new(side*30,1.6,0),STONE,Enum.Material.WoodPlanks,true)
    piece(parent,"Banc – dossier",Vector3.new(6,2,0.5),base*CFrame.new(side*30,2.45,1),accent,Enum.Material.Metal,true)
end
local function avenue(parent,s)
    local road=Factory.folder(parent,"Avenue "..s.name)
    road:SetAttribute("KinSection",s.key)
    road:SetAttribute("KinAvenueName","Avenue "..s.name)
    road:SetAttribute("KinInterfaceOf","Koali")
    local axis,side=directions(s)
    for i=1,19 do
        local r=62+(i-0.5)*20
        local location=axis*r
        local cf=CFrame.new(location+Vector3.new(0,0.36,0))*CFrame.Angles(0,math.atan2(s.x,s.z),0)
        piece(road,"Dalle piétonne",Vector3.new(19,0.35,20.03),cf,STONE,Enum.Material.Slate,true)
        for _,polarity in ipairs({-1,1}) do
            piece(road,"Bordure",Vector3.new(1,0.50,20.01),cf*CFrame.new(polarity*10.2,-0.01,0),TEAL,Enum.Material.Metal,false)
            local line=piece(road,"Filet identitaire",Vector3.new(0.30,0.22,19.9),cf*CFrame.new(polarity*8.65,0.27,0),s.lightColor,Enum.Material.Neon,false)
            if s.key=="kreative" then line:SetAttribute("KinKreativeCanvas",true) end
        end
    end
    -- KC36 : surface viaire à propriétaire unique. Ne pas superposer les
    -- deux meshes GLB de paving à ces dalles natives déjà visibles et solides.
    -- Les assets restent disponibles dans le Package, sans être instanciés ici.
    road:SetAttribute("KinGroundAuthority","native-avenue-slabs")
    road:SetAttribute("KinPavingMeshOverlay",false)
    -- Deux alignements lisibles de mobilier à intervalles réguliers.
    for n=1,8 do
        local r=99+n*37
        local centre=axis*r
        local base=CFrame.new(centre)*CFrame.Angles(0,math.atan2(s.x,s.z),0)
        for _,direction in ipairs({-1,1}) do
            local c=base*CFrame.new(direction*24,0,0)
            local importedLamp=if ArtDecoProps.selected("lamp",n) then ArtDecoProps.street(road,"lamp",c,s.key) else nil
            if importedLamp then
                local host=ArtDecoProps.lightHost(importedLamp)
                if host then
                    host:SetAttribute("KinLightingSector",s.key)
                    host:SetAttribute("KinLightingColor",s.lightColor:ToHex())
                    if n%2==0 then
                        local light=Instance.new("PointLight")
                        light.Name="Lueur du quartier";light.Brightness=0.42;light.Range=18
                        light.Color=s.lightColor;light.Shadows=false;light:SetAttribute("KinStaticLightLOD",true);light.Parent=host
                        if s.key=="kreative" then light:SetAttribute("KinKreativeLight",true) end
                    end
                end
            end
            if not importedLamp then
                piece(road,"Mât de quartier",Vector3.new(0.75,8.4,0.75),c*CFrame.new(0,4.4,0),TEAL,Enum.Material.Metal,true)
                local collar=piece(road,"Bague du lampadaire",Vector3.new(1.1,0.34,1.1),c*CFrame.new(0,8.5,0),s.lightColor,Enum.Material.Neon,false)
                local lamp=piece(road,"Lanterne de quartier",Vector3.new(1.75,1.75,1.75),c*CFrame.new(0,9.05,0),s.lightColor,Enum.Material.Neon,false)
                lamp:SetAttribute("KinLightingSector",s.key)
                lamp:SetAttribute("KinLightingColor",s.lightColor:ToHex())
                if s.key=="kreative" then
                    collar:SetAttribute("KinKreativeCanvas",true)
                    lamp:SetAttribute("KinKreativeCanvas",true)
                end
                if n%2==0 then
                    local light=Instance.new("PointLight")
                    light.Name="Lueur du quartier"
                    light.Brightness=0.42;light.Range=18;light.Color=s.lightColor;light.Shadows=false;light:SetAttribute("KinStaticLightLOD",true);light.Parent=lamp
                    if s.key=="kreative" then light:SetAttribute("KinKreativeLight",true) end
                end
            end
        end
        if n==2 or n==5 then
            decorativeBench(road,base,-1,s.color,s.key,n)
            decorativeBench(road,base,1,s.color,s.key,n)
        end
    end
    -- Six compact, ornamented avenue signs: one visible identity per sector.
    local entry=axis*84+side*14
    piece(road,"Support de pancarte",Vector3.new(.6,4,.6),CFrame.new(entry+Vector3.new(0,2,0)),TEAL,Enum.Material.Metal,false)
    local sectorSign=Factory.sign(road,"Pancarte du secteur",entry+Vector3.new(0,4.8,0),
        math.deg(math.atan2(s.x,s.z)),"Avenue "..s.name,18,2.8,{section=s.key})
    sectorSign:SetAttribute("KinSectorIdentity",s.key)
    return road
end
local function pavilion(parent,siteRecord)
    local s=siteRecord.section
    local info=siteRecord.info
    local at=siteRecord.position
    local base=CFrame.new(at)*CFrame.Angles(0,math.atan2(s.x,s.z),0)
    local lot=Factory.folder(parent,"Allée "..info.title)
    lot:SetAttribute("KinKoaliPlace",info.title)
    lot:SetAttribute("KinSection",s.key)
    lot:SetAttribute("KinOwner",info.owner)
    lot:SetAttribute("KinBackendConnected",false)
    lot:SetAttribute("KinFunctionality","apercu_public_world_stub")
    local material=Enum.Material.Slate
    if s.material=="metal" then material=Enum.Material.Metal
    elseif s.material=="wood" then material=Enum.Material.WoodPlanks
    elseif s.material=="black_marble" then material=Enum.Material.Marble
    end
    piece(lot,"Esplanade de l'allée",Vector3.new(43,0.50,34),base*CFrame.new(0,0.30,0),STONE,Enum.Material.Slate,true)
    local axis=Vector3.new(s.x,0,s.z)
    local longitudinal=siteRecord.position:Dot(axis)
    local path=beam(lot,"Allée piétonne — "..info.title,
        axis*(longitudinal-18)+Vector3.new(0,0.54,0),
        at-axis*18+Vector3.new(0,0.54,0),7.5,0.25,STONE,Enum.Material.Slate)
    path.CanCollide=true
    local importedPavilion=ArtDecoProps.pavilion(lot,base*CFrame.new(0,.5,7),s.key,siteRecord.index)
    if not importedPavilion then
    piece(lot,"Façade réemployée",Vector3.new(30,12,15),base*CFrame.new(0,6.5,7),STONE,Enum.Material.Concrete,true)
    local roof=piece(lot,"Toiture de quartier",Vector3.new(34,1.25,18),base*CFrame.new(0,12.8,7),ArtDecoTheme.dark,Enum.Material.Metal,true)
    if s.key=="kreative" then roof:SetAttribute("KinKreativeCanvas",true) end
    local frieze=piece(lot,"Frise lumineuse de quartier",Vector3.new(31,0.6,1),base*CFrame.new(0,10.7,-1),s.lightColor,Enum.Material.Neon,false)
    if s.key=="kreative" then frieze:SetAttribute("KinKreativeCanvas",true) end
    for n=-2,2 do
        piece(lot,"Colonnade alignée",Vector3.new(1.25,8.5,1.25),base*CFrame.new(n*5.2,5,-1),
            ArtDecoTheme.bronze,Enum.Material.Metal,true)
    end
    if s.material=="black_marble" then
        for n=-2,2 do
            piece(lot,"Veines dorées",Vector3.new(0.14,9,0.22),base*CFrame.new(n*5.2+1.1,6.3,-1.56)*CFrame.Angles(0,0,0.3),GOLD,Enum.Material.Metal,false)
        end
    end
    end
    local entrance=piece(lot,"Totem de découverte",Vector3.new(5.5,4,2),base*CFrame.new(0,2.3,-13),TEAL,Enum.Material.Metal,true)
    entrance:SetAttribute("KinStubInteractionId","koali.preview."..s.key.."."..siteRecord.index)
    entrance:SetAttribute("KinStubCapabilityId","koali.preview.information")
    entrance:SetAttribute("KinStubTitle",info.title)
    Factory.prompt(entrance,"Découvrir",info.title)
    local signHeight=16.3
    if importedPavilion then
        local _,pavilionSize=importedPavilion:GetBoundingBox()
        signHeight=math.max(12,math.min(23,pavilionSize.Y+2.2))
    end
    local panel=Factory.sign(lot,"Enseigne de l'allée",(base*CFrame.new(0,signHeight,-3)).Position,
        math.deg(math.atan2(s.x,s.z)),info.title,24,3.2)
    panel.CanCollide=false
    -- Un marqueur ne simule pas le branchement à Orgo, Moodle, Konstellation ou Konnaxion.
    return lot
end
function Urbanism.make(city,plan)
    local root=Factory.folder(city,"KOALI • urbanisme d'allées brandées")
    root:SetAttribute("KinCityPurpose","interface spatiale pour Koali")
    root:SetAttribute("KinWorldStub",true)
    root:SetAttribute("KinLayoutVersion","koali-hex-urban-v31")
    root:SetAttribute("KinColor","#1E6864")
    for _,s in ipairs(Districts.sections) do avenue(root,s) end
    reserved={}
    local sites=makeSites(plan.structures)
    local gallery=Factory.folder(root,"18 lieux thématiques • vues d'ensemble")
    for _,lot in ipairs(sites) do
        table.insert(reserved,lot.position)
        pavilion(gallery,lot)
    end
    root:SetAttribute("KinPreviewPavilions",#sites)
    local guide=Factory.folder(root,"Orientation de Koali")
    local stand=piece(guide,"Borne Ariane — accueil",Vector3.new(4.5,5.7,3.6),
        CFrame.new(12,3,14),TEAL,Enum.Material.Metal,true)
    stand:SetAttribute("KinStubInteractionId","koali.ariane.introduction")
    stand:SetAttribute("KinStubCapabilityId","koali.preview.navigation")
    stand:SetAttribute("KinStubTitle","Ariane — navigation sémantique")
    Factory.prompt(stand,"Explorer","Ariane")
    -- Place centrale volontairement libre des panneaux KIN CITY géants.
    return root
end
return Urbanism

]]
    local module=proposed:FindFirstChild("KoaliUrbanism")
    if not module then module=Instance.new("ModuleScript");module.Name="KoaliUrbanism";module.Parent=proposed end
    assert(module:IsA("ModuleScript"),"KoaliUrbanism: classe inattendue")
    module.Source=code
end
do
    local code=[[--!strict
-- EkoH relie les six quartiers par un halo sarcelle illuminé à mi-parcours.
-- Cette promenade EXPLIQUE EkoH et les ponts entre produits : aucun score,
-- vote civique, identité, ou donnée de service externe n'est exposé par les bornes.
local F=require(script.Parent.Factory)
local Palette=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("HexagonalDistricts"))
local Halo={}
local RADIUS=211
local HEIGHT=17
local SEGMENTS=96
local ANGLES=math.pi*2
local function deco(parent,name,size,cf,color,material)
    local p=F.part(parent,name,size,cf,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    return p
end
local function beam(parent,name,a,b,width,height,color,material)
    local d=b-a
    return deco(parent,name,Vector3.new(d.Magnitude,height,width),
        CFrame.new((a+b)*0.5)*CFrame.Angles(0,-math.atan2(d.Z,d.X),0),color,material)
end
local function buildingNearby(x,z,structures,pad)
    for _,b in ipairs(structures) do
        local dx,dz=x-b.center_studs[1],z-b.center_studs[3]
        local yaw=math.rad(b.yaw_degrees)
        local lx=math.cos(yaw)*dx-math.sin(yaw)*dz
        local lz=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+pad and math.abs(lz)<b.footprint_studs[2]/2+pad then return true end
    end
    return false
end
local function kioskPlace(direction,structures)
    local side=Vector3.new(-direction.Z,0,direction.X)
    for _,r in ipairs({RADIUS,RADIUS-10,RADIUS+10,RADIUS-20,RADIUS+20}) do
        for _,offset in ipairs({0,12,-12,23,-23}) do
            local p=direction*r+side*offset
            if not buildingNearby(p.X,p.Z,structures,9) then return p end
        end
    end
    return direction*RADIUS
end
local topics={
    keenkonnect={"Collaboration", "Konstruct • TeamBuilder", "Konnaxion"},
    ethikos={"Éthique & expertise", "Contexte EkoH • accès privé", "Konnaxion"},
    kreative={"Création & mémoire", "Konservation • œuvres", "Konnaxion"},
    uckk={"Parcours", "Cours • activités • communauté", "Université King Klown"},
    ekole={"Connaissance", "Kristals • perspectives", "Ekole / Konstellation"},
    konnected={"Apprendre & valider", "Knowledge • CertifiKation", "Konnaxion"},
}
function Halo.make(city,plan)
    local root=F.folder(city,"EkoH • halo transversal lumineux")
    root:SetAttribute("KinHaloOwner","Konnaxion/EkoH")
    root:SetAttribute("KinColor","#1E6864")
    root:SetAttribute("KinRadiusStuds",RADIUS)
    root:SetAttribute("KinHeightStuds",HEIGHT)
    root:SetAttribute("KinScope","interpretation_and_wayfinding_only")
    root:SetAttribute("KinRingSegments",SEGMENTS)
    -- Anneau continu en altitude : son étage n'est PAS une surface praticable.
    -- Les bornes sont au sol, accessibles sans téléportation ni plateforme flottante.
    for i=0,SEGMENTS-1 do
        local a=i*ANGLES/SEGMENTS
        local b=(i+1)*ANGLES/SEGMENTS
        local p=Vector3.new(math.cos(a)*RADIUS,HEIGHT,math.sin(a)*RADIUS)
        local q=Vector3.new(math.cos(b)*RADIUS,HEIGHT,math.sin(b)*RADIUS)
        beam(root,"Structure du halo EkoH",p,q,1.8,1.0,Palette.base,Enum.Material.Metal)
        beam(root,"Lumière EkoH",p+Vector3.new(0,0.58,0),
            q+Vector3.new(0,0.58,0),0.7,0.3,Palette.light,Enum.Material.Neon)
        if i%8==0 then
            local point=deco(root,"Source de lumière",Vector3.new(1.3,1.3,1.3),
                CFrame.new(p+Vector3.new(0,0.8,0)),Palette.light,Enum.Material.Neon)
            local light=Instance.new("PointLight")
            light.Color=Palette.light
            light.Brightness=0.8
            light.Range=31
            light.Shadows=false
            light.Parent=point
        end
    end
    local posts=F.folder(root,"Bornes EkoH aux six axes")
    for _,section in ipairs(Palette.sections) do
        local direction=Vector3.new(section.x,0,section.z)
        local p=kioskPlace(direction,plan.structures)
        local group=F.folder(posts,"Borne "..section.name)
        group:SetAttribute("KinSector",section.key)
        group:SetAttribute("KinTheme",section.material)
        -- KC36 : supports latéraux, jamais d'axe opaque devant le texte.
        -- Le portique entier est orienté comme l'avenue du secteur.
        local yaw=math.atan2(section.x,section.z)
        local frame=CFrame.new(p)*CFrame.Angles(0,yaw,0)
        local boardWidth=25
        local signY=10.3
        local supportHeight=13.0
        local supportDistance=boardWidth/2+1.1
        for _,side in ipairs({-1,1}) do
            local foot=(frame*CFrame.new(side*supportDistance,supportHeight/2,0)).Position
            local post=deco(group,"Colonne latérale du portique",Vector3.new(supportHeight,0.78,0.78),
                CFrame.new(foot)*CFrame.Angles(0,0,math.pi/2),Palette.base,Enum.Material.Metal)
            post.Shape=Enum.PartType.Cylinder
            post:SetAttribute("KinSignStructuralSupport",true)
            local link=deco(group,"Fixation latérale du panneau",Vector3.new(1.4,0.22,0.38),
                frame*CFrame.new(side*(boardWidth/2+0.4),signY,0),Palette.light,Enum.Material.Metal)
            link:SetAttribute("KinSignStructuralSupport",true)
        end
        group:SetAttribute("KinSignSupportRevision","KC36-twin-post-clear-center")
        local terminal=deco(group,"Borne d'exploration",Vector3.new(5.4,5.3,3.5),
            frame*CFrame.new(0,3.5,0),Palette.base,Enum.Material.Metal)
        deco(group,"Façade éclairée",Vector3.new(4.6,3.0,0.32),
            frame*CFrame.new(0,4.2,-1.94),Palette.light,Enum.Material.Neon).Transparency=0.3
        deco(group,"Sommet coloré",Vector3.new(5.7,0.5,3.6),
            frame*CFrame.new(0,6.35,0),section.color,Enum.Material.Neon)
        local meta=topics[section.key]
        local sign=F.sign(group,"EkoH • "..section.name,p+Vector3.new(0,signY,0),math.deg(yaw),
            "EkoH • "..meta[1].."\n"..meta[2],boardWidth,3.7,
            {section=section.key,doubleSided=true})
        sign:SetAttribute("KinDisclosure","Découverte publique, aucune donnée personnelle")
        sign:SetAttribute("KinSignMount","twin-post")
        terminal:SetAttribute("KinStubInteractionId","ekoh.terminal."..section.key)
        terminal:SetAttribute("KinStubCapabilityId","ekoh.public.exploration")
        terminal:SetAttribute("KinStubTitle","EkoH • "..section.name)
        F.prompt(terminal,"Découvrir",meta[3].." / EkoH")
    end
    -- Orgo et Konstellation traversent la ville, mais ne deviennent pas des quartiers.
    local links=F.folder(root,"Systèmes transversaux")
    local cross={
        {angle=-math.pi/3,title="ORGO",detail="Coordonner • transmettre"},
        {angle=2*math.pi/3,title="KONSTELLATION",detail="Explorer • relier"},
    }
    for _,item in ipairs(cross) do
        local p=kioskPlace(Vector3.new(math.cos(item.angle),0,math.sin(item.angle)),plan.structures)
        local terminal=deco(links,"Kiosque "..item.title,Vector3.new(4.5,5,2.8),
            CFrame.new(p+Vector3.new(0,3.1,0)),Palette.base,Enum.Material.Metal)
        terminal:SetAttribute("KinStubInteractionId","ekoh.cross."..item.title)
        terminal:SetAttribute("KinStubCapabilityId","ecosystem.public.discover")
        terminal:SetAttribute("KinStubTitle",item.title)
        F.prompt(terminal,"Explorer",item.title)
        F.sign(links,"Passerelle "..item.title,p+Vector3.new(0,8.8,0),0,
            item.title.."\n"..item.detail,28,3.4)
    end
    return root
end
return Halo

]]
    local module=proposed:FindFirstChild("EkohHalo")
    if not module then module=Instance.new("ModuleScript");module.Name="EkohHalo";module.Parent=proposed end
    assert(module:IsA("ModuleScript"),"EkohHalo: classe inattendue")
    module.Source=code
end
do
    local code=[[--!strict
-- KC35 B09: reviewed branch overlays, deterministic and idempotent.
-- Applied after WorldBuilder.build, in Studio Edition and at server Play start.
-- Never modifies portals, PlaceIds, canonical plan, transport or remote bindings.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local Visual=require(Shared:WaitForChild("VisualConfig"))
local Runtime={}
local REVISION="KC35-BRANCH-RUNTIME-1"
local ORDER={"city_hall","ekoh_tower","library","campus","justice_palace","innovation_lab","museum","orgo_center","city"}
local EXPECTED={
    city_hall="B01",ekoh_tower="B02",library="B03",campus="B04",justice_palace="B05",
    innovation_lab="B06",museum="B07",orgo_center="B08",city="B10",
}

local function invoke(key:string,model:Instance?,origin:Vector3,profile:string,world:Instance):any
    assert(model,"KC35: modèle absent : "..key)
    local context={place_key=key,placeKey=key,contracts_version="KC34-DOC-1.0",
        place_model=model,placeModel=model,interiorModel=model,model=model,
        parent=model,origin=origin,profile=profile,authorized=true,replace_decoration=false}
    if key=="city_hall" then
        return require(script.Parent.B01CityHallScene).build(context)
    elseif key=="ekoh_tower" then
        return require(script.Parent.B02EkohInterior).Build(context)
    elseif key=="library" then
        return require(script.Parent.B03LibraryScene).build(context)
    elseif key=="campus" then
        return require(script.Parent.B04CampusDecor).build(model,origin,profile)
    elseif key=="justice_palace" then
        return require(script.Parent.B05KorumPreview).build(context)
    elseif key=="innovation_lab" then
        return require(script.Parent.B06KonstructScene).build(context)
    elseif key=="museum" then
        return require(script.Parent.B07MuseumScene).build(context)
    elseif key=="orgo_center" then
        return require(script.Parent.B08OrgoScene).build(context)
    elseif key=="city" then
        return require(script.Parent.B10WayfindingKC36).build(model,Plan,Districts,profile)
    end
    error("KC35: clé inconnue "..key)
end

function Runtime.apply(state:any):any
    assert(state and state.world,"KC35: world attendu")
    local world=state.world
    assert(world:GetAttribute("KinBuildState")=="Ready","KC35: monde non prêt")
    local mode=state.mode or world:GetAttribute("KinRoutingMode")
    local active=state.currentPlace or world:GetAttribute("KinActivePlace")
    local profile=Visual.profile
    assert(profile=="LITE" or profile=="STANDARD" or profile=="SHOWCASE","KC35: profil inconnu")
    local candidates={}
    for _,key in ipairs(ORDER) do
        if mode=="LOCAL_UNIVERSE" or key==active then table.insert(candidates,key) end
    end
    -- Validate all destinations BEFORE decorating anything; no silent omission.
    local interiorRoot=world:FindFirstChild("Bâtiments visitables")
    local interiors={}
    for _,key in ipairs(candidates) do
        if key=="city" then
            assert(world:FindFirstChild("Ville"),"KC35: Ville absente")
        else
            local m=interiorRoot and interiorRoot:FindFirstChild("Intérieur — "..key)
            assert(m and m:IsA("Model"),"KC35: intérieur manquant : "..key)
            assert(m:GetAttribute("KinPlaceKey")==key,"KC35: attribut Place invalide : "..key)
            assert(typeof(m:GetAttribute("KinInteriorOrigin"))=="Vector3","KC35: origine manquante : "..key)
            interiors[key]=m
        end
    end
    local completed=0
    local failed={}
    for _,key in ipairs(candidates) do
        local model=if key=="city" then world:FindFirstChild("Ville") else interiors[key]
        local origin=if key=="city" then Vector3.zero else (model::Instance):GetAttribute("KinInteriorOrigin")
        local ok,res=pcall(function() return invoke(key,model,origin,profile,world) end)
        if ok then
            completed+=1
            world:SetAttribute("KinBranch"..EXPECTED[key].."Status","Ready")
        else
            table.insert(failed,key..": "..tostring(res))
            world:SetAttribute("KinBranch"..EXPECTED[key].."Status","Error")
            warn("KC35 BRANCH ERROR "..key..": "..tostring(res))
        end
    end
    world:SetAttribute("KinBranchRuntimeRevision",REVISION)
    world:SetAttribute("KinBranchExpected",#candidates)
    world:SetAttribute("KinBranchReadyCount",completed)
    world:SetAttribute("KinBranchRuntimeState",if #failed==0 then "Ready" else "Partial")
    world:SetAttribute("KinBranchRuntimeErrors",table.concat(failed," | "))
    if #failed==0 then
        print("KC35 B09 : "..completed.." sur "..#candidates.." branches installées, profil "..profile)
    end
    return {expected=#candidates,created=completed,failed=failed,profile=profile,ready=#failed==0}
end

return Runtime

]]
    local module=proposed:FindFirstChild("BranchRuntime")
    if not module then module=Instance.new("ModuleScript");module.Name="BranchRuntime";module.Parent=proposed end
    assert(module:IsA("ModuleScript"),"BranchRuntime: classe inattendue")
    module.Source=code
end
do
    local code=[[--!strict
-- B10 KC36 : wayfinding physique. Les enseignes d'avenue sont la propriété de
-- KoaliUrbanism. Aucun BillboardGui / aucune appellation d'horloge.
-- Les huit repères de portes sont des plaques non bloquantes et statiques.
local Wayfinding={}
local REVISION="b10-kc36-physical-signs-1"
local ROOT_NAME="KinB10Orientation"
local TEAL=Color3.fromRGB(30,104,100)
local BRASS=Color3.fromRGB(186,149,94)
local IVORY=Color3.fromRGB(241,232,202)
local INK=Color3.fromRGB(19,33,34)

local function part(parent:Instance,name:string,size:Vector3,frame:CFrame,color:Color3):BasePart
    local p=Instance.new("Part")
    p.Name=name;p.Size=size;p.CFrame=frame;p.Color=color
    p.Material=Enum.Material.Metal;p.Anchored=true;p.CanCollide=false
    p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Parent=parent
    return p
end
local function paint(board:BasePart,face:Enum.NormalId,heading:string,detail:string)
    local gui=Instance.new("SurfaceGui")
    gui.Name=if face==Enum.NormalId.Front then "ReadableSign" else "ReadableSignBack"
    gui.Face=face;gui.AlwaysOnTop=false;gui.LightInfluence=0.14
    gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud=36;gui.MaxDistance=85;gui.Parent=board
    local bg=Instance.new("Frame")
    bg.Name="Background";bg.Size=UDim2.fromScale(1,1);bg.BorderSizePixel=0
    bg.BackgroundColor3=INK;bg.Parent=gui
    local trim=Instance.new("UIStroke")
    trim.Thickness=2;trim.Color=BRASS;trim.Parent=bg
    local text=Instance.new("TextLabel")
    text.Name="Text";text.Size=UDim2.new(0.92,0,0.56,0)
    text.Position=UDim2.fromScale(0.04,0.05)
    text.BackgroundTransparency=1;text.Font=Enum.Font.Garamond
    text.TextScaled=true;text.TextWrapped=true
    text.TextColor3=IVORY;text.Text=heading;text.Parent=bg
    local subtitle=Instance.new("TextLabel")
    subtitle.Name="Description";subtitle.Size=UDim2.new(0.92,0,0.25,0)
    subtitle.Position=UDim2.fromScale(0.04,0.69)
    subtitle.BackgroundTransparency=1;subtitle.Font=Enum.Font.Gotham
    subtitle.TextScaled=true;subtitle.TextWrapped=true
    subtitle.TextColor3=BRASS;subtitle.Text=detail;subtitle.Parent=bg
end
local function plaque(parent:Instance,position:Vector3,yaw:number,title:string,detail:string,id:string)
    local m=Instance.new("Model")
    m.Name="Repère "..id;m:SetAttribute("KinB10DecorationId","city.wayfinding."..id)
    m:SetAttribute("KinB10StaticPhysical",true)
    m.Parent=parent
    local frame=CFrame.new(position.X,0,position.Z)*CFrame.Angles(0,yaw,0)
    local width=10.8
    for _,side in ipairs({-1,1}) do
        part(m,"Colonne latérale",Vector3.new(.42,4.7,.42),frame*CFrame.new(side*(width/2+.35),2.35,0),TEAL)
    end
    local board=part(m,"Plaque physique",Vector3.new(width,2.5,.22),frame*CFrame.new(0,4.55,0),INK)
    board:SetAttribute("KinSignMount","twin-post")
    paint(board,Enum.NormalId.Front,title,detail)
    paint(board,Enum.NormalId.Back,title,detail)
    return m
end
local function nearestSector(position:Vector3,districts:any):any
    local n=Vector2.new(position.X,position.Z)
    if n.Magnitude<0.01 then return districts.sections[1] end
    local best=nil
    local score=-2
    for _,section in ipairs(districts.sections) do
        local dot=(position.X*section.x+position.Z*section.z)/n.Magnitude
        if dot>score then best=section;score=dot end
    end
    return best
end
local function arrivals(plan:any):{any}
    local city=nil
    for _,place in ipairs(plan.places) do
        if place.place_key=="city" then city=place;break end
    end
    assert(city,"B10 : Place city absente")
    local anchors={}
    for _,a in ipairs(city.anchors) do anchors[a.anchor_id]=a end
    local result={}
    local seen={}
    for _,door in ipairs(plan.doors) do
        if door.source_place_key=="city" then
            assert(not seen[door.door_id],"B10 : porte répétée "..door.door_id)
            seen[door.door_id]=true
            local a=assert(anchors[door.source_anchor_id],"B10 : ancre absente "..door.door_id)
            local b=assert(anchors["city."..door.building_id..".return_spawn"],"B10 : retour absent "..door.door_id)
            table.insert(result,{door=door,doorAnchor=Vector3.new(table.unpack(a.position_studs)),
                returnAnchor=Vector3.new(table.unpack(b.position_studs))})
        end
    end
    assert(#result==8,"B10 : huit entrées attendues")
    table.sort(result,function(a,b) return a.door.door_id<b.door.door_id end)
    return result
end
local titles={
    city_hall="Accueil civique",ekoh_tower="Observatoire EkoH",library="Bibliothèque",
    campus="Université King Klown",justice_palace="Agora Korum",
    innovation_lab="Atelier Konstruct",museum="Musée Kreative",orgo_center="Maison Orgo",
}
function Wayfinding.build(city:Instance,plan:any,districts:any,profile:string?):(Instance,{[string]:number})
    assert(city and city.Name=="Ville","B10 : Ville attendue")
    assert(type(plan)=="table" and type(plan.structures)=="table","B10 : plan absent")
    assert(type(districts)=="table" and #districts.sections==6,"B10 : six sections nécessaires")
    local quality=profile or "STANDARD"
    assert(quality=="LITE" or quality=="STANDARD" or quality=="SHOWCASE","B10 : profil inconnu")
    local doors=arrivals(plan)
    local old=city:FindFirstChild(ROOT_NAME)
    if old and old:GetAttribute("KinB10Revision")==REVISION and old:GetAttribute("KinB10Profile")==quality then
        return old,{avenue=0,entrances=old:GetAttribute("KinB10EntranceMarkers") or 0,skipped=0}
    end
    local stage=Instance.new("Folder")
    stage.Name=ROOT_NAME.."_PREPARE"
    stage:SetAttribute("KinB10Revision",REVISION)
    stage:SetAttribute("KinB10Profile",quality)
    for _,record in ipairs(doors) do
        local sector=assert(nearestSector(record.doorAnchor,districts))
        local approach=record.doorAnchor-record.returnAnchor
        local flat=Vector3.new(approach.X,0,approach.Z)
        local normal=if flat.Magnitude>.5 then flat.Unit else Vector3.new(0,0,-1)
        local lateral=Vector3.new(-normal.Z,0,normal.X)
        local position=record.returnAnchor-normal*3+lateral*9
        if (position-record.doorAnchor).Magnitude<6 then
            position=record.returnAnchor-normal*3-lateral*9
        end
        local yaw=math.atan2(normal.X,normal.Z)
        local key=record.door.destination_place_key
        if key=="museum" then
            plaque(stage,position,yaw,"MUSÉE — FERMÉ","Écran de diffusion à proximité",key)
        else
            plaque(stage,position,yaw,titles[key] or key,"ACCÈS AU BÂTIMENT",key)
        end
        -- Secteur de référence : attribut seulement, jamais une heure affichée.
        local marker=stage:FindFirstChild("Repère "..key)
        if marker then marker:SetAttribute("KinB10Sector",sector.key) end
    end
    stage:SetAttribute("KinB10AvenueMarkers",0)
    stage:SetAttribute("KinB10EntranceMarkers",#doors)
    stage:SetAttribute("KinB10Skipped",0)
    if old then old:Destroy() end
    stage.Name=ROOT_NAME;stage.Parent=city
    return stage,{avenue=0,entrances=#doors,skipped=0}
end
return Wayfinding

]]
    local module=proposed:FindFirstChild("B10WayfindingKC36")
    if not module then module=Instance.new("ModuleScript");module.Name="B10WayfindingKC36";module.Parent=proposed end
    assert(module:IsA("ModuleScript"),"B10WayfindingKC36: classe inattendue")
    module.Source=code
end
-- La source du monde antérieur est déplacée, pas supprimée.
-- Le builder source KC35 (verrouillé) crée alors un nouveau monde depuis zéro.
local backup=Instance.new("Folder")
backup.Name="KC36AlignmentBackup"
backup:SetAttribute("KinRevision","KC36-ALIGNMENT-1")
backup:SetAttribute("KinPurpose","rollback source preserving all old world parts")
backup.Parent=Store
local previousEnabled=oldRuntime.Enabled
oldRuntime.Enabled=false
oldWorld.Parent=backup
oldRuntime.Parent=backup
oldShared.Parent=backup
proposedShared.Name="KinCityShared"
proposedShared.Parent=Replicated
proposed.Name="KinCityRuntime"
proposed.Parent=Server
local ok,err=pcall(function()
    local state=require(proposed:WaitForChild("WorldBuilder")).build(false)
    local result=require(proposed:WaitForChild("BranchRuntime")).apply(state)
    assert(result.ready and result.created==9,"B09 n'a pas validé les 9 branches")
    local world=assert(workspace:FindFirstChild("KinCityGenerated"))
    local city=assert(world:FindFirstChild("Ville"))
    assert(world:GetAttribute("KinBuildState")=="Ready","Monde incomplet")
    local facades=assert(city:FindFirstChild("Bâtiments"))
    local floors=0
    for _,model in ipairs(facades:GetChildren()) do
        if model:IsA("Model") then
            local floor=model:FindFirstChild("Floor")
            assert(floor and floor:IsA("BasePart"),"Fondation absente : "..model.Name)
            local expected=floor:GetAttribute("KinGroundTop")
            assert(typeof(expected)=="number" and expected>0.25,"Fondation non rehaussée : "..model.Name)
            floors+=1
        end
    end
    assert(floors==8,"Huit fondations extérieures requises; obtenu "..floors)
    local halo=assert(city:FindFirstChild("EkoH • halo transversal lumineux"))
    local kiosks=assert(halo:FindFirstChild("Bornes EkoH aux six axes"))
    local count=0
    for _,borne in ipairs(kiosks:GetChildren()) do
        assert(borne:GetAttribute("KinSignSupportRevision")=="KC36-twin-post-clear-center",
            "Portique EkoH non corrigé : "..borne.Name)
        assert(not borne:FindFirstChild("Fil vertical du halo"),"Barre EkoH centrale restante")
        count+=1
    end
    assert(count==6,"Six kiosques EkoH attendus")
    local b10=assert(city:FindFirstChild("KinB10Orientation"))
    assert(b10:GetAttribute("KinB10EntranceMarkers")==8,"8 repères d'accès B10 manquants")
    assert(b10:GetAttribute("KinB10AvenueMarkers")==0,"Enseignes d'avenue B10 redondantes")
    for _,v in ipairs(b10:GetDescendants()) do
        assert(not v:IsA("BillboardGui"),"B10 contient une pancarte flottante")
    end
    for _,v in ipairs(world:GetDescendants()) do
        assert(not (v:IsA("BasePart") and v:GetAttribute("KC36FloorPatch")==true),
            "Une ancienne dalle de secours subsiste")
    end
    world:SetAttribute("KinKC36GeometryRevision","KC36-ALIGNMENT-1")
    print("KC36 VALIDÉ : 8 fondations surélevées; 6 portiques EkoH; B10 physique; 9 branches")
end)
if not ok then
    local wrong=workspace:FindFirstChild("KinCityGenerated")
    if wrong then wrong:Destroy() end
    proposed:Destroy()
    proposedShared:Destroy()
    oldShared.Name="KinCityShared"
    oldShared.Parent=Replicated
    oldWorld.Name="KinCityGenerated"
    oldWorld.Parent=workspace
    oldRuntime.Name="KinCityRuntime"
    oldRuntime.Parent=Server
    oldRuntime.Enabled=previousEnabled
    backup:Destroy()
    error("KC36 ANNULÉE, monde et runtime restaurés : "..tostring(err))
end
proposed.Enabled=previousEnabled
print("KC36 OK : Package central intact, 121/121")
print("Backup réversible : ServerStorage.KC36AlignmentBackup")
print("Ctrl+S puis Play. Auditer l'exécution avant de valider visuellement.")
