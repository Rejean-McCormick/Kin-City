--!strict
-- V5 : points de vue panoramiques locaux. Aucun kOA, HTTP ni asset externe.
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local Vista={}
local active=false
local savedType=nil
local savedFieldOfView=70
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
        camera.CameraType=savedType or Enum.CameraType.Custom
        camera.FieldOfView=savedFieldOfView
        local character=player.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
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
    button.Font=Enum.Font.GothamBold
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
    bar.Position=UDim2.new(0.5,-190,1,-148)
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
    header.Font=Enum.Font.GothamBold
    header.Parent=bar
    heading=header
    local hint=Instance.new("TextLabel")
    hint.BackgroundTransparency=1
    hint.Position=UDim2.fromOffset(12,34)
    hint.Size=UDim2.fromOffset(356,26)
    hint.Text="Regarder autour · Zoomer · F pour revenir"
    hint.TextColor3=Color3.fromRGB(196,220,219)
    hint.TextSize=12
    hint.Font=Enum.Font.Gotham
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
        savedType=camera.CameraType
        savedFieldOfView=camera.FieldOfView
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
        if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.F or input.KeyCode==Enum.KeyCode.ButtonB then
            restore()
        elseif not processed and input.KeyCode==Enum.KeyCode.Left then
            angle=math.clamp(angle-15,-125,125);apply()
        elseif not processed and input.KeyCode==Enum.KeyCode.Right then
            angle=math.clamp(angle+15,-125,125);apply()
        end
    end)
    player.CharacterAdded:Connect(restore)
end
return Vista
