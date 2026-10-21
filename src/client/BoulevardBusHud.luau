--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Interface des minibus collectifs. Tactile, manette et clavier (sans raccourci requis).
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Hud={}
function Hud.start(remote)
    local player=Players.LocalPlayer
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityBoulevardHud";gui.ResetOnSpawn=false;gui.DisplayOrder=23
    gui.Parent=player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.Size=UDim2.fromOffset(320,86)
    panel.AnchorPoint=Vector2.new(0.5,0)
    panel.Position=UDim2.new(0.5,0,0,168)
    panel.BackgroundColor3=Color3.fromRGB(33,73,79)
    panel.BackgroundTransparency=0.06;panel.Visible=false;panel.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,11);corner.Parent=panel
    local label=Instance.new("TextLabel")
    label.BackgroundTransparency=1;label.Size=UDim2.new(1,-20,0,30)
    label.Position=UDim2.fromOffset(10,4)
    label.Font=Typography.body();label.TextSize=15;label.TextXAlignment=Enum.TextXAlignment.Left
    label.TextColor3=Color3.fromRGB(241,224,175);label.Text="NAVETTE ÉLECTRIQUE";label.Parent=panel
    local detail=Instance.new("TextLabel")
    detail.BackgroundTransparency=1;detail.Position=UDim2.fromOffset(10,34)
    detail.Size=UDim2.new(1,-20,0,45);detail.Font=Typography.body()
    detail.TextSize=13;detail.TextWrapped=true;detail.TextXAlignment=Enum.TextXAlignment.Left
    detail.TextColor3=Color3.fromRGB(231,243,238);detail.Parent=panel
    local current="";local active=false;local state="boarding";local remaining=0;local total=0;local count=0
    local function show()
        if not active then return end
        if state=="boarding" then
            detail.Text=string.format("%s · %d/%d passagers · départ dans %ds",current,count,total,math.ceil(remaining))
        else
            detail.Text=string.format("En route vers %s · %ds avant l'arrivée",current,math.ceil(remaining))
        end
    end
    remote.OnClientEvent:Connect(function(event)
        if type(event)~="table" or event.kind~="boulevard.bus.v11" then return end
        state=tostring(event.state or "boarding")
        if state=="arrive" or state=="cancel" then
            active=false;panel.Visible=false;return
        end
        current=tostring(event.destination or "le quartier")
        remaining=tonumber(event.duration) or 0
        count=tonumber(event.count) or 1;total=tonumber(event.capacity) or 8
        active=true;panel.Visible=true;show()
    end)
    RunService.RenderStepped:Connect(function(dt)
        if active then remaining=math.max(0,remaining-dt);show() end
    end)
end
return Hud
