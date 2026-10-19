--!strict
-- Carnet des stations de quatrième niveau; progression locale à la session.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local SkyHud={}
local TOTAL=16

local function rounded(parent,rad)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,rad)
    c.Parent=parent
end
local function title(parent,text,y,size)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1
    l.Position=UDim2.fromOffset(14,y)
    l.Size=UDim2.new(1,-28,0,size)
    l.Font=Enum.Font.GothamSemibold
    l.TextSize=if size>=32 then 19 else 14
    l.TextColor3=Color3.fromRGB(242,234,211)
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextWrapped=true
    l.Text=text
    l.Parent=parent
    return l
end
function SkyHud.start(remote)
    local player=Players.LocalPlayer
    local pg=player:WaitForChild("PlayerGui")
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCitySkyTour"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.Parent=pg
    local button=Instance.new("TextButton")
    button.Name="Pavillons"
    button.AnchorPoint=Vector2.new(1,0)
    button.Position=UDim2.new(1,-15,0,360)
    button.Size=UDim2.fromOffset(121,38)
    button.Text="Ciel · P"
    button.Font=Enum.Font.GothamBold
    button.TextSize=14
    button.TextColor3=Color3.fromRGB(252,248,229)
    button.BackgroundColor3=Color3.fromRGB(39,82,106)
    button.Parent=gui
    rounded(button,10)
    local panel=Instance.new("Frame")
    panel.Name="Carnet des observatoires"
    panel.AnchorPoint=Vector2.new(1,0)
    panel.Position=UDim2.new(1,-14,0,403)
    panel.Size=UDim2.fromOffset(305,174)
    panel.BackgroundColor3=Color3.fromRGB(25,46,62)
    panel.BorderSizePixel=0
    panel.Visible=false
    panel.Parent=gui
    rounded(panel,12)
    title(panel,"PAVILLONS DU CIEL",12,34)
    local counter=title(panel,"0 / 16 mécanismes découverts",50,30)
    local recent=title(panel,"Visite le toit d'une institution, puis monte d'un niveau.",83,54)
    recent.TextSize=12
    local progress=Instance.new("Frame")
    progress.Position=UDim2.new(0,14,1,-24)
    progress.Size=UDim2.new(1,-28,0,8)
    progress.BackgroundColor3=Color3.fromRGB(65,90,105)
    progress.BorderSizePixel=0
    progress.Parent=panel
    rounded(progress,4)
    local fill=Instance.new("Frame")
    fill.Size=UDim2.fromScale(0,1)
    fill.BackgroundColor3=Color3.fromRGB(116,215,182)
    fill.BorderSizePixel=0
    fill.Parent=progress
    rounded(fill,4)
    local toggle=function()panel.Visible=not panel.Visible end
    button.Activated:Connect(toggle)
    UIS.InputBegan:Connect(function(input,handled)
        if not handled and input.KeyCode==Enum.KeyCode.P then toggle() end
    end)
    local seen={}
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="sky.discovery.v1" then return end
        if type(payload.station_id)~="string" then return end
        seen[payload.station_id]=true
        local count=0
        for _ in pairs(seen) do count+=1 end
        counter.Text=string.format("%d / %d mécanismes découverts",count,TOTAL)
        recent.Text=tostring(payload.title or "Station explorée").."\n"..tostring(payload.place_key or "Kin City")
        fill.Size=UDim2.fromScale(math.clamp(count/TOTAL,0,1),1)
        panel.Visible=true
    end)
end
return SkyHud
