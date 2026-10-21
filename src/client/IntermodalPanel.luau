--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Panneau de lignes: information purement locale, ne vend ni ne réserve rien.
-- Un bouton tactile permet de consulter les lignes sans clavier.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local Network=require(RS:WaitForChild("KinCityShared"):WaitForChild("IntermodalNetwork"))
local Panel={}
local player=Players.LocalPlayer
local BG=Color3.fromRGB(24,48,55)
local FG=Color3.fromRGB(235,236,219)
local ACCENT=Color3.fromRGB(205,178,113)
local function round(parent,r)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r);c.Parent=parent
end
local function text(parent,value,y,height,size,bold)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1;l.Position=UDim2.fromOffset(16,y)
    l.Size=UDim2.new(1,-30,0,height)
    l.Text=value;l.TextWrapped=true
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.TextColor3=FG;l.Font=if bold then Typography.body() else Typography.body()
    l.TextSize=size;l.Parent=parent
    return l
end
function Panel.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityIntermodal"
    gui.IgnoreGuiInset=false;gui.ResetOnSpawn=false;gui.DisplayOrder=7
    gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton")
    toggle.Name="GareButton";toggle.Text="GARE [H]";toggle.Font=Typography.body();toggle.TextSize=12
    toggle.TextColor3=FG;toggle.BackgroundColor3=BG
    toggle.Size=UDim2.fromOffset(78,36)
    toggle.Position=UDim2.new(1,-94,1,-58)
    toggle.Parent=gui;round(toggle,9)
    local window=Instance.new("Frame")
    window.Name="Lignes";window.Visible=false
    window.Size=UDim2.fromOffset(310,410)
    local constraint=Instance.new("UISizeConstraint")
    constraint.MaxSize=Vector2.new(310,410)
    constraint.MinSize=Vector2.new(245,290)
    constraint.Parent=window
    window.AnchorPoint=Vector2.new(1,1)
    window.Position=UDim2.new(1,-14,1,-104)
    window.BackgroundColor3=BG
    window.Parent=gui;round(window,11)
    local uiScale=Instance.new("UIScale")
    uiScale.Parent=window
    local function resize()
        local camera=workspace.CurrentCamera
        local vp=camera and camera.ViewportSize or Vector2.new(900,650)
        uiScale.Scale=math.clamp(math.min((vp.X-24)/340,(vp.Y-126)/420),0.60,1)
    end
    resize()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    end
    text(window,"GARE DES CONNEXIONS",12,30,16,true)
    text(window,"Correspondances rapides vers les stations. Pour prendre le bus, montez à la station.",44,46,12,false)
    local destination=text(window,"",93,34,12,true)
    destination.TextColor3=ACCENT
    for i,gate in ipairs(Network.gates) do
        local row=Instance.new("Frame")
        row.BackgroundColor3=Color3.fromRGB(40,68,74)
        row.Position=UDim2.fromOffset(14,134+(i-1)*40)
        row.Size=UDim2.fromOffset(282,35)
        row.Parent=window;round(row,6)
        local stripe=Instance.new("Frame")
        stripe.Size=UDim2.fromOffset(5,35)
        stripe.BackgroundColor3=Color3.fromRGB(gate.color[1],gate.color[2],gate.color[3]);stripe.Parent=row
        local label=Instance.new("TextLabel")
        label.BackgroundTransparency=1;label.Position=UDim2.fromOffset(13,3)
        label.Size=UDim2.new(1,-20,1,-6)
        label.Text=string.format("%d  %s",i,gate.title)
        label.TextWrapped=true;label.TextSize=12;label.Font=Typography.body()
        label.TextXAlignment=Enum.TextXAlignment.Left;label.TextColor3=FG
        label.Parent=row
    end
    local function flip()window.Visible=not window.Visible end
    toggle.Activated:Connect(flip)
    require(script.Parent.KinCityMenu).register("station","Gare [H]",toggle,window,flip)
    UIS.InputBegan:Connect(function(input,handled)
        if not handled and input.KeyCode==Enum.KeyCode.H then flip() end
    end)
    local elapsed=0
    RunService.RenderStepped:Connect(function(dt)
        if not window.Visible then return end
        elapsed+=dt;if elapsed<0.6 then return end;elapsed=0
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then destination.Text="Explorez la gare pour trouver les guichets.";return end
        local hub=Vector3.new(Network.hub.center_studs[1],root.Position.Y,Network.hub.center_studs[3])
        local distance=(root.Position-hub).Magnitude
        if player:GetAttribute("KinZone")~="city" then
            destination.Text="Retournez à la ville pour rejoindre la gare."
        elseif distance<65 then
            destination.Text="Vous êtes à la gare · accès par les guichets physiques."
        else
            destination.Text=string.format("Gare centrale à environ %d studs",math.floor(distance))
        end
    end)
end
return Panel
