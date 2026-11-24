--!strict
local Barrier={}
local TARGET_DOOR_ID="city.kreative.museum.entry"
local SCREEN_NAME="KinCityOutdoorCinema"
local MODEL_NAME="KinCityMuseumLockdown"
local started=false

local function makePart(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material, collide: boolean): BasePart
    local part=Instance.new("Part")
    part.Name=name
    part.Size=size
    part.CFrame=cf
    part.Color=color
    part.Material=material
    part.Anchored=true
    part.CanCollide=collide
    part.CanTouch=collide
    part.CanQuery=collide
    part.Parent=parent
    return part
end

local function textLabel(parent: Instance, name: string, text: string, size: UDim2, position: UDim2, color: Color3, maxSize: number)
    local label=Instance.new("TextLabel")
    label.Name=name
    label.BackgroundTransparency=1
    label.Size=size
    label.Position=position
    label.Text=text
    label.TextColor3=color
    label.Font=Enum.Font.GothamBold
    label.TextScaled=true
    label.TextWrapped=true
    label.Parent=parent
    local limit=Instance.new("UITextSizeConstraint")
    limit.MaxTextSize=maxSize
    limit.MinTextSize=12
    limit.Parent=label
    return label
end

local function findDoorPart(): BasePart?
    local generated=workspace:FindFirstChild("KinCityGenerated")
    if not generated then return nil end
    for _,item in ipairs(generated:GetDescendants()) do
        if item:IsA("BasePart") and item:GetAttribute("KinDoorId")==TARGET_DOOR_ID then
            return item
        end
    end
    return nil
end

local function disableDoorPrompt(door: BasePart)
    for _,child in ipairs(door:GetChildren()) do
        if child:IsA("ProximityPrompt") then
            child.Enabled=false
            child.ActionText="Fermé"
            child.ObjectText="Musée Kreative"
        end
    end
    door:SetAttribute("KinMuseumDoorBlocked",true)
end

local function buildBarrier(door: BasePart)
    local existing=workspace:FindFirstChild(MODEL_NAME)
    if existing and existing:IsA("Model") then existing:Destroy() end
    local model=Instance.new("Model")
    model.Name=MODEL_NAME
    model.Parent=workspace
    -- Anchor is at avatar height Y≈3. We need the actual ground plane Y=0.
    local ground=CFrame.new(door.Position.X,0,door.Position.Z)*door.CFrame.Rotation
    local base=ground*CFrame.new(0,0,0.8)
    local coral=Color3.fromRGB(203,128,157)
    local dark=Color3.fromRGB(45,24,34)
    for _,side in ipairs({-1,1}) do
        makePart(model,"Poteau",Vector3.new(0.55,4.2,0.55),base*CFrame.new(side*2.45,2.1,0),dark,Enum.Material.Metal,true)
    end
    makePart(model,"Barre",Vector3.new(5.8,0.45,0.55),base*CFrame.new(0,2.3,0),coral,Enum.Material.Metal,true)
    makePart(model,"Barre basse",Vector3.new(5.8,0.35,0.4),base*CFrame.new(0,1.2,0),dark,Enum.Material.Metal,true)
    local sign=makePart(model,"Panneau info",Vector3.new(5.6,3.1,0.3),base*CFrame.new(-6.4,2.8,-0.6),Color3.fromRGB(22,16,24),Enum.Material.SmoothPlastic,false)
    local gui=Instance.new("SurfaceGui")
    gui.Name="Info"
    gui.Face=Enum.NormalId.Front
    gui.CanvasSize=Vector2.new(900,500)
    gui.LightInfluence=0
    gui.Parent=sign
    textLabel(gui,"Heading","PORTE BARRÉE",UDim2.fromScale(0.88,0.28),UDim2.fromScale(0.06,0.08),coral,44)
    textLabel(gui,"Body","BROADCAST YOUTUBE\nJUSTE À CÔTÉ",UDim2.fromScale(0.88,0.48),UDim2.fromScale(0.06,0.42),Color3.fromRGB(242,239,244),40)
end

local function repositionCinema(door: BasePart)
    local cinema=workspace:FindFirstChild(SCREEN_NAME)
    if not cinema or not cinema:IsA("Model") then return end
    local sideOffset=-14
    local frontOffset=10
    local basePosition=door.Position + door.CFrame.RightVector*sideOffset + door.CFrame.LookVector*frontOffset
    local look=basePosition-door.CFrame.LookVector*24
    cinema:PivotTo(CFrame.lookAt(Vector3.new(basePosition.X,13,basePosition.Z),Vector3.new(look.X,13,look.Z)))
    cinema:SetAttribute("KinVideoLocation","Place Kreative — près du musée")
    -- Brand marker only: a VideoFrame needs an authorized Roblox video asset,
    -- and cannot consume a YouTube streaming URL directly.
    cinema:SetAttribute("KinVideoChannel","YouTube - contenu via asset Roblox autorise")
    local screen=cinema:FindFirstChild("Écran",true)
    if screen then
        local gui=screen:FindFirstChild("Projection")
        if gui and gui:IsA("SurfaceGui") then
            local heading=gui:FindFirstChild("En-tête")
            if heading and heading:IsA("TextLabel") then heading.Text="BROADCAST YOUTUBE" end
            local message=gui:FindFirstChild("Message")
            if message and message:IsA("TextLabel") then
                local id=tonumber(cinema:GetAttribute("KinVideoAssetId")) or 0
                message.Text=if id>0 then "PROJECTION • BROADCAST YOUTUBE" else "BROADCAST YOUTUBE\nVIDÉO À CONFIGURER"
            end
        end
    end
end

function Barrier.start()
    if started then return end
    started=true
    local door=findDoorPart()
    if not door then
        warn("KIN CITY B07 : porte du musée introuvable, verrouillage non appliqué")
        return
    end
    disableDoorPrompt(door)
    buildBarrier(door)
    repositionCinema(door)
    print("KIN CITY B07 : porte du musée barrée et écran YouTube placé à proximité")
end

return Barrier
