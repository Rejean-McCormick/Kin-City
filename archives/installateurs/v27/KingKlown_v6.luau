-- King Klown v6 — coller en ÉDITION dans la barre Commande.
-- Costume seul : aucun bâtiment reconstruit. R15 / R6, aura purement visuelle.
-- Groupe Roblox : renseigner votre vrai UserId ci-dessous avant installation.
local OWNER_USER_ID = 0
assert(not game:GetService("RunService"):IsRunning(),"Arrêtez Play avant l'installation.")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local old=SS:FindFirstChild("KinCityKingKlownAvatar")
if OWNER_USER_ID==0 and old then OWNER_USER_ID=old:GetAttribute("OwnerUserId") or 0 end
if old then old:Destroy() end
local oldClient=SP:FindFirstChild("KinCityKingKlownAura")
if oldClient then oldClient:Destroy() end
local runtime=Instance.new("Script")
runtime.Name="KinCityKingKlownAvatar";runtime.Enabled=false
runtime:SetAttribute("OwnerUserId",OWNER_USER_ID)
local avatar=Instance.new("ModuleScript")
avatar.Name="Avatar"
avatar.Source=[[
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

]]
avatar.Parent=runtime
runtime.Source='require(script.Avatar).start({ownerUserId=script:GetAttribute("OwnerUserId") or 0,studioPreview=true})'
runtime.Parent=SS
local client=Instance.new("LocalScript")
client.Name="KinCityKingKlownAura";client.Enabled=false
local aura=Instance.new("ModuleScript")
aura.Name="Aura";aura.Source=[[
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

]];aura.Parent=client
client.Source='require(script.Aura).start()'
client.Parent=SP
runtime.Enabled=true;client.Enabled=true
print("King Klown v6 installé. Lancez Play : tête ronde, sourire détendu et aura locale.")
