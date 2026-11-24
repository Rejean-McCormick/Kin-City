--!strict
-- Écran extérieur Koali : une vidéo Roblox autorisée, déclenchée sur la dalle.
-- Vidéo désactivée tant que le propriétaire n'a pas renseigné l'AssetId réel.
local Players=game:GetService("Players")
local Cinema={}
local MODEL_NAME="KinCityOutdoorCinema"
local DEFAULT_VIDEO_ID=0
local DEFAULT_POSITION=Vector3.new(105,0,-75)
local started=false

local function part(parent:Instance,name:string,size:Vector3,cf:CFrame,color:Color3,material:Enum.Material,collide:boolean)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Color=color
    p.Material=material
    p.Anchored=true
    p.CanCollide=collide
    p.CanTouch=false
    p.CanQuery=collide
    p.Parent=parent
    return p
end

local function label(parent:Instance,name:string,text:string,size:UDim2,position:UDim2,color:Color3,px:number)
    local t=Instance.new("TextLabel")
    t.Name=name
    t.BackgroundTransparency=1
    t.Size=size
    t.Position=position
    t.Text=text
    t.TextColor3=color
    t.Font=Enum.Font.Garamond
    t.TextScaled=true
    t.TextWrapped=true
    t.Parent=parent
    local limit=Instance.new("UITextSizeConstraint")
    limit.MaxTextSize=px
    limit.MinTextSize=12
    limit.Parent=t
    return t
end

local function setVideo(model:Model)
    local screen=model:FindFirstChild("Écran",true)
    if not screen or not screen:IsA("BasePart") then return end
    local surface=screen:FindFirstChild("Projection")
    if not surface then return end
    local video=surface:FindFirstChild("Film")
    if not video or not video:IsA("VideoFrame") then return end
    local id=tonumber(model:GetAttribute("KinVideoAssetId")) or DEFAULT_VIDEO_ID
    local usable=id>0 and id==math.floor(id)
    video.Video=if usable then "rbxassetid://"..tostring(id) else ""
    local text=surface:FindFirstChild("Message")
    if text and text:IsA("TextLabel") then
        text.Text=if usable then "MONTEZ SUR LA DALLE POUR LANCER LE FILM" else "VIDÉO NON CONFIGURÉE\nAjoutez KinVideoAssetId dans Propriétés"
        text.Visible=true
    end
end

function Cinema.ensure():Model
    local existing=workspace:FindFirstChild(MODEL_NAME)
    if existing and existing:IsA("Model") then
        if existing:GetAttribute("KinVideoAssetId")==nil then existing:SetAttribute("KinVideoAssetId",DEFAULT_VIDEO_ID) end
        setVideo(existing)
        return existing
    end
    local model=Instance.new("Model")
    model.Name=MODEL_NAME
    model:SetAttribute("KinVideoAssetId",DEFAULT_VIDEO_ID)
    model:SetAttribute("KinVideoPlaybackStart",0)
    model:SetAttribute("KinVideoLocation","Extérieur — déplaçable dans Studio")
    model:SetAttribute("KinVideoTriggerEnabled",true)
    model.Parent=workspace
    local base=CFrame.new(DEFAULT_POSITION)
    local deep=Color3.fromRGB(18,62,60)
    local teal=Color3.fromRGB(30,104,100)
    local opal=Color3.fromRGB(197,244,240)
    local screen=part(model,"Écran",Vector3.new(24,13.5,0.55),base*CFrame.new(0,13,0),Color3.fromRGB(8,18,20),Enum.Material.SmoothPlastic,false)
    screen.CanQuery=true
    model.PrimaryPart=screen
    part(model,"Cadre supérieur",Vector3.new(25,0.6,1),base*CFrame.new(0,20.05,0),teal,Enum.Material.Metal,false)
    part(model,"Cadre inférieur",Vector3.new(25,0.6,1),base*CFrame.new(0,5.95,0),teal,Enum.Material.Metal,false)
    for _,side in ipairs({-1,1}) do
        part(model,"Montant latéral",Vector3.new(0.8,14.5,0.9),base*CFrame.new(side*12.3,13,0),opal,Enum.Material.Metal,false)
        part(model,"Pied de structure",Vector3.new(1,6.2,1.2),base*CFrame.new(side*10.4,3.1,0.5),deep,Enum.Material.Metal,true)
    end
    local trigger=part(model,"Déclencheur vidéo",Vector3.new(10,0.32,8),base*CFrame.new(0,0.16,-15),opal,Enum.Material.Neon,true)
    trigger.CanQuery=true
    trigger.Transparency=0.28
    trigger:SetAttribute("KinVideoTrigger",true)
    local strip=part(model,"Repère de projection",Vector3.new(10.6,0.15,0.8),base*CFrame.new(0,0.32,-19.2),teal,Enum.Material.Metal,false)
    strip.CanQuery=false
    local surface=Instance.new("SurfaceGui")
    surface.Name="Projection"
    surface.Face=Enum.NormalId.Front
    surface.CanvasSize=Vector2.new(1280,720)
    surface.LightInfluence=0
    surface.AlwaysOnTop=false
    surface.Parent=screen
    local video=Instance.new("VideoFrame")
    video.Name="Film"
    video.Size=UDim2.fromScale(1,1)
    video.BackgroundColor3=Color3.fromRGB(7,16,19)
    video.BorderSizePixel=0
    video.Video=""
    video.Volume=0.65
    video.Looped=false
    video.Playing=false
    video.Parent=surface
    local message=label(surface,"Message","VIDÉO NON CONFIGURÉE",UDim2.fromScale(0.90,0.37),UDim2.fromScale(0.05,0.315),opal,68)
    message.ZIndex=3
    local heading=label(surface,"En-tête","KOALI • PROJECTION",UDim2.fromScale(0.8,0.1),UDim2.fromScale(0.1,0.04),opal,32)
    heading.ZIndex=4
    setVideo(model)
    return model
end

function Cinema.start()
    if started then return end
    started=true
    local model=Cinema.ensure()
    model:GetAttributeChangedSignal("KinVideoAssetId"):Connect(function() setVideo(model) end)
    local trigger=model:FindFirstChild("Déclencheur vidéo")
    if not trigger or not trigger:IsA("BasePart") then return end
    local inside:{[number]:boolean}={}
    local lastPlay=-math.huge
    task.spawn(function()
        while model.Parent and trigger.Parent do
            for _,player in ipairs(Players:GetPlayers()) do
                local character=player.Character
                local humanoid=character and character:FindFirstChildOfClass("Humanoid")
                local root=character and character:FindFirstChild("HumanoidRootPart")
                local entered=false
                if humanoid and humanoid.Health>0 and root and root:IsA("BasePart") then
                    local rel=trigger.CFrame:PointToObjectSpace(root.Position)
                    entered=math.abs(rel.X)<trigger.Size.X*0.5 and math.abs(rel.Z)<trigger.Size.Z*0.5 and math.abs(rel.Y)<6
                end
                local id=player.UserId
                if entered and not inside[id] then
                    if model:GetAttribute("KinVideoTriggerEnabled")~=false and os.clock()-lastPlay>2.5 then
                        lastPlay=os.clock()
                        model:SetAttribute("KinVideoPlaybackStart",workspace:GetServerTimeNow())
                    end
                end
                inside[id]=entered
            end
            task.wait(0.35)
        end
    end)
    print("KIN CITY CINÉMA : écran extérieur prêt, vidéo Roblox à configurer dans KinVideoAssetId")
end
return Cinema
