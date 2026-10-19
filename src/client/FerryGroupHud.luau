--!strict
-- Panneau compact de ferry collectif, accessible au clavier et au tactile.
-- L'état provient uniquement du serveur. Aucun compteur ou promesse kOA.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Player=Players.LocalPlayer
local FerryHud={}
function FerryHud.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityFerryGroupHud"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=22
    gui.Parent=Player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.AnchorPoint=Vector2.new(0.5,0)
    panel.Position=UDim2.new(0.5,0,0,75)
    panel.Size=UDim2.fromOffset(322,82)
    panel.BackgroundColor3=Color3.fromRGB(24,59,72)
    panel.BackgroundTransparency=0.06
    panel.Visible=false
    panel.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,12)
    corner.Parent=panel
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-20,0,29)
    title.Position=UDim2.fromOffset(10,5)
    title.BackgroundTransparency=1
    title.Font=Enum.Font.GothamBold
    title.TextColor3=Color3.fromRGB(246,238,205)
    title.TextSize=15
    title.Text="FERRY COLLECTIF"
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.Parent=panel
    local state=Instance.new("TextLabel")
    state.Size=UDim2.new(1,-20,0,38)
    state.Position=UDim2.fromOffset(10,36)
    state.BackgroundTransparency=1
    state.Font=Enum.Font.Gotham
    state.TextColor3=Color3.fromRGB(214,235,234)
    state.TextSize=13
    state.TextWrapped=true
    state.TextXAlignment=Enum.TextXAlignment.Left
    state.Parent=panel
    local remaining=0
    local active=false
    local mode="boarding"
    local count=0
    local capacity=6
    local destination=""
    local function redraw()
        if not active then return end
        if mode=="boarding" then
            state.Text=string.format("%s · %d/%d personnes · départ dans %ds",destination,count,capacity,math.max(0,math.ceil(remaining)))
        else
            state.Text=string.format("Traversée vers %s · arrivée dans %ds",destination,math.max(0,math.ceil(remaining)))
        end
    end
    remote.OnClientEvent:Connect(function(payload)
        if type(payload)~="table" or payload.kind~="ferry.group.v2" then return end
        destination=tostring(payload.destination or "l'archipel")
        count=tonumber(payload.passengers) or 1
        capacity=tonumber(payload.capacity) or 6
        mode=tostring(payload.state or "boarding")
        if mode=="arrive" or mode=="cancel" then
            active=false
            panel.Visible=false
            return
        end
        remaining=tonumber(payload.duration) or 0
        active=true
        panel.Visible=true
        redraw()
    end)
    RunService.RenderStepped:Connect(function(dt)
        if active then
            remaining=math.max(0,remaining-dt)
            redraw()
        end
    end)
end
return FerryHud
