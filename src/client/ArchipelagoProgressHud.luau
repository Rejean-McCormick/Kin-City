--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Écran discret de progression locale; compatible souris et tactile.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local Hud={}
function Hud.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityProgressV9";gui.ResetOnSpawn=false;gui.DisplayOrder=4
    gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton")
    toggle.Name="CarnetArchipel"
    toggle.Size=UDim2.fromOffset(152,36)
    toggle.Position=UDim2.new(0,16,1,-65)
    toggle.BackgroundColor3=Color3.fromRGB(29,67,77)
    toggle.TextColor3=Color3.fromRGB(238,229,197)
    toggle.Font=Typography.body();toggle.TextSize=12
    toggle.Text="CARNET DES VOYAGES"
    toggle.Parent=gui
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,8);round.Parent=toggle
    local panel=Instance.new("Frame")
    panel.Name="Carnet de voyage"
    panel.Size=UDim2.fromOffset(254,135)
    panel.Position=UDim2.new(0,16,1,-210)
    panel.BackgroundColor3=Color3.fromRGB(21,45,55)
    panel.Visible=false;panel.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,11);corner.Parent=panel
    local heading=Instance.new("TextLabel")
    heading.BackgroundTransparency=1;heading.Position=UDim2.fromOffset(12,7)
    heading.Size=UDim2.fromOffset(233,24);heading.Text="EXPLORATION LOCALE"
    heading.TextColor3=Color3.fromRGB(242,225,169);heading.TextSize=15
    heading.Font=Typography.body();heading.Parent=panel
    local stats=Instance.new("TextLabel")
    stats.Name="Progression";stats.BackgroundTransparency=1
    stats.Size=UDim2.fromOffset(228,88);stats.Position=UDim2.fromOffset(13,34)
    stats.TextColor3=Color3.fromRGB(230,239,232)
    stats.Font=Typography.body();stats.TextSize=14
    stats.TextXAlignment=Enum.TextXAlignment.Left;stats.TextYAlignment=Enum.TextYAlignment.Top
    stats.TextWrapped=true;stats.Parent=panel
    local function update()
        stats.Text=string.format("Marinas : %d / 2\nSalles des îles : %d / 12\nHaltes : %d / 24\nProgression de cette session seulement",
            player:GetAttribute("KinMarinaDiscoveries") or 0,
            player:GetAttribute("KinAnnexRoomsVisited") or 0,
            player:GetAttribute("KinIslandTrailVisits") or 0)
    end
    toggle.Activated:Connect(function()panel.Visible=not panel.Visible end)
    require(script.Parent.KinCityMenu).register("archipelago","Voyages",toggle,panel)
    for _,k in ipairs({"KinMarinaDiscoveries","KinAnnexRoomsVisited","KinIslandTrailVisits"}) do
        player:GetAttributeChangedSignal(k):Connect(update)
    end
    update()
end
return Hud
