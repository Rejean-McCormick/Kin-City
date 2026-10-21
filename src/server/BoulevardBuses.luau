--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
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
    label.Font=Typography.body();label.TextScaled=true;label.TextWrapped=true
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
