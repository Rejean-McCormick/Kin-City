--!strict
-- Compteur de promenade local, lisible au clavier / tactile / manette.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local Tracker={}
function Tracker.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityDiscoveryTracker";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=false;gui.DisplayOrder=4
    gui.Parent=player:WaitForChild("PlayerGui")
    local chip=Instance.new("Frame")
    chip.Name="Parcours de découverte";chip.AnchorPoint=Vector2.new(1,0)
    chip.Position=UDim2.new(1,-18,0,16);chip.Size=UDim2.fromOffset(216,48)
    chip.BackgroundColor3=Color3.fromRGB(34,70,77);chip.BackgroundTransparency=0.12;chip.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=chip
    local label=Instance.new("TextLabel")
    label.Size=UDim2.new(1,-18,1,-8);label.Position=UDim2.fromOffset(9,4)
    label.BackgroundTransparency=1;label.TextColor3=Color3.fromRGB(249,242,218)
    label.TextSize=16;label.Font=Enum.Font.GothamBold;label.TextXAlignment=Enum.TextXAlignment.Left
    label.Parent=chip
    local function render()
        local count=player:GetAttribute("KinTrailCount") or 0
        local total=player:GetAttribute("KinTrailTotal") or 24
        label.Text=string.format("Découvertes  %d / %d",count,total)
    end
    player:GetAttributeChangedSignal("KinTrailCount"):Connect(render)
    player:GetAttributeChangedSignal("KinTrailTotal"):Connect(render)
    render()
end
return Tracker
