--!strict
-- Repère d'identité accessible : texte + couleur + matériau, jamais couleur seule.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Typography=require(Shared:WaitForChild("Typography"))
local Palette=require(Shared:WaitForChild("HexagonalDistricts"))
local SectorHud={}
function SectorHud.start()
    local player=Players.LocalPlayer
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCitySectorHud"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=7
    gui.IgnoreGuiInset=false
    gui.Parent=player:WaitForChild("PlayerGui")
    local card=Instance.new("Frame")
    card.Name="Secteur actuel"
    card.Size=UDim2.fromOffset(280,54)
    card.Position=UDim2.fromOffset(15,79)
    card.BackgroundColor3=Color3.fromRGB(21,58,55)
    card.BackgroundTransparency=0.06
    card.BorderSizePixel=0
    card.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,9)
    corner.Parent=card
    local border=Instance.new("UIStroke")
    border.Thickness=1
    border.Color=Palette.base
    border.Parent=card
    local swatch=Instance.new("Frame")
    swatch.Name="Accent chromatique"
    swatch.Size=UDim2.fromOffset(8,43)
    swatch.Position=UDim2.fromOffset(7,5)
    swatch.BackgroundColor3=Palette.opal
    swatch.BorderSizePixel=0
    swatch.Parent=card
    local title=Instance.new("TextLabel")
    title.BackgroundTransparency=1
    title.Position=UDim2.fromOffset(24,4)
    title.Size=UDim2.fromOffset(248,26)
    title.Font=Typography.display()
    title.TextSize=18
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.TextColor3=Color3.fromRGB(243,253,252)
    title.Text="PLACE HEXAGONALE"
    title.Parent=card
    local subtitle=Instance.new("TextLabel")
    subtitle.BackgroundTransparency=1
    subtitle.Position=UDim2.fromOffset(24,30)
    subtitle.Size=UDim2.fromOffset(247,19)
    subtitle.Font=Typography.body()
    subtitle.TextSize=12
    subtitle.TextXAlignment=Enum.TextXAlignment.Left
    subtitle.TextColor3=Color3.fromRGB(196,243,238)
    subtitle.Text="6 directions • EkoH relie les secteurs"
    subtitle.Parent=card
    local prev=""
    local elapsed=0
    RunService.Heartbeat:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.3 then return end
        elapsed=0
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then card.Visible=false;return end
        local p=root.Position
        local radius=Vector2.new(p.X,p.Z).Magnitude
        -- Les intérieurs LOCAL_UNIVERSE sont à des milliers de studs.
        -- Ne pas leur attribuer un secteur de la ville sur la base de l'azimut.
        if radius>480 then card.Visible=false;return end
        card.Visible=true
        local s=if radius<60 then nil else Palette.nearestAxis(p.X,p.Z)
        local key=if s then s.key else "central"
        if key==prev then return end
        prev=key
        if s then
            title.Text=s.name
            subtitle.Text=s.system.."  ·  "..s.material
            swatch.BackgroundColor3=s.color
            border.Color=s.color
        else
            title.Text="PLACE HEXAGONALE"
            subtitle.Text="6 directions • EkoH relie les secteurs"
            swatch.BackgroundColor3=Palette.opal
            border.Color=Palette.base
        end
    end)
end
return SectorHud
