--!strict
-- Carnet de l'archipel, progression locale par session seulement.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local Passport={}
function Passport.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityIslandPassport"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=5
    gui.Parent=player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.Name="Carnet des îles"
    panel.Size=UDim2.fromOffset(184,41)
    panel.Position=UDim2.new(1,-201,1,-160)
    panel.BackgroundColor3=Color3.fromRGB(29,64,79)
    panel.BackgroundTransparency=0.1
    panel.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,11)
    corner.Parent=panel
    local text=Instance.new("TextLabel")
    text.BackgroundTransparency=1
    text.Size=UDim2.new(1,-10,1,0)
    text.Position=UDim2.fromOffset(5,0)
    text.TextColor3=Color3.fromRGB(243,233,194)
    text.Font=Enum.Font.GothamBold
    text.TextSize=13
    text.Parent=panel
    local function refresh()
        text.Text=string.format("ARCHIPEL  %d / %d îles",player:GetAttribute("KinIslandsVisited") or 0,player:GetAttribute("KinIslandsTotal") or 6)
    end
    player:GetAttributeChangedSignal("KinIslandsVisited"):Connect(refresh)
    player:GetAttributeChangedSignal("KinIslandsTotal"):Connect(refresh)
    refresh()
end
return Passport
