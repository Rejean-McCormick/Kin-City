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
