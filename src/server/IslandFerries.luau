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
