--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- V30 : sortie anticipée des panoramas, restauration native sans flash entre zones.
-- Aucun kOA, HTTP ni asset externe.
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local Vista={}
local active=false
local savedType=nil
local savedFieldOfView=70
local savedFrame=CFrame.new()
local savedZone="city"
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
        local character=player.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local root=character and character:FindFirstChild("HumanoidRootPart")
        camera.CameraType=if savedType==Enum.CameraType.Scriptable then Enum.CameraType.Custom else (savedType or Enum.CameraType.Custom)
        camera.FieldOfView=savedFieldOfView
        -- Sur téléportation ou respawn, ne pas réafficher une image de l'ancien lieu.
        local returnFrame=savedFrame
        if root and (root.Position-savedFrame.Position).Magnitude>75 then
            local lookAt=root.Position+Vector3.new(0,2,0)
            returnFrame=CFrame.lookAt(lookAt+Vector3.new(0,6,14),lookAt)
        end
        camera.CFrame=returnFrame
        camera.Focus=CFrame.new(returnFrame.Position+returnFrame.LookVector*14)
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
    button.Font=Typography.body()
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
    bar.AnchorPoint=Vector2.new(0.5,1)
    bar.Position=UDim2.new(0.5,0,1,-22)
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
    header.Font=Typography.body()
    header.Parent=bar
    heading=header
    local hint=Instance.new("TextLabel")
    hint.BackgroundTransparency=1
    hint.Position=UDim2.fromOffset(12,34)
    hint.Size=UDim2.fromOffset(356,26)
    hint.Text="Regarder autour · Zoomer · F pour revenir"
    hint.TextColor3=Color3.fromRGB(196,220,219)
    hint.TextSize=12
    hint.Font=Typography.body()
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
        -- Ne pas prendre le contrôle d'une cinématique déjà en mode Scriptable.
        if camera.CameraType==Enum.CameraType.Scriptable then return end
        savedType=camera.CameraType
        savedFieldOfView=camera.FieldOfView
        savedFrame=camera.CFrame
        savedZone=player:GetAttribute("KinZone") or "city"
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
        if UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.F or input.KeyCode==Enum.KeyCode.ButtonB then
            restore()
        elseif not processed and input.KeyCode==Enum.KeyCode.Left then
            angle=math.clamp(angle-15,-125,125);apply()
        elseif not processed and input.KeyCode==Enum.KeyCode.Right then
            angle=math.clamp(angle+15,-125,125);apply()
        end
    end)
    player.CharacterRemoving:Connect(restore)
    player.CharacterAdded:Connect(restore)
    player:GetAttributeChangedSignal("KinZone"):Connect(function()
        if active and (player:GetAttribute("KinZone") or "city")~=savedZone then restore() end
    end)
    local function fit()
        local cam=Workspace.CurrentCamera
        local viewport=cam and cam.ViewportSize or Vector2.new(800,600)
        local scale=bar:FindFirstChild("MobileScale")
        if not scale then scale=Instance.new("UIScale");scale.Name="MobileScale";scale.Parent=bar end
        scale.Scale=math.clamp((viewport.X-24)/380,0.58,1)
    end
    fit()
    if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end
end
return Vista
