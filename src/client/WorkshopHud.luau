--!strict
-- V14 · Panneau des expériences à trois étapes; compatible tactile et clavier.
-- Affiche un état local de session, sans note, score ou accès réseau.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local WorkshopHud={}
local BG=Color3.fromRGB(28,55,64)
local GOLD=Color3.fromRGB(234,195,123)
local FG=Color3.fromRGB(243,240,220)
local function corner(parent,r)
    local obj=Instance.new("UICorner")
    obj.CornerRadius=UDim.new(0,r);obj.Parent=parent
end
local function label(parent,txt,y,size,bold)
    local line=Instance.new("TextLabel")
    line.Position=UDim2.fromOffset(13,y)
    line.Size=UDim2.new(1,-26,0,size+10)
    line.BackgroundTransparency=1
    line.TextColor3=FG
    line.Text=txt;line.TextWrapped=true
    line.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    line.TextSize=size
    line.TextXAlignment=Enum.TextXAlignment.Left
    line.Parent=parent
    return line
end
function WorkshopHud.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityWorkshopHud";gui.ResetOnSpawn=false;gui.DisplayOrder=9
    gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local button=Instance.new("TextButton")
    button.Text="ATELIERS [K]";button.Font=Enum.Font.GothamBold;button.TextSize=12
    button.TextColor3=FG;button.BackgroundColor3=BG
    button.Position=UDim2.new(1,-141,0,82)
    button.Size=UDim2.fromOffset(126,35);button.Parent=gui;corner(button,9)
    local panel=Instance.new("Frame")
    panel.Name="Progression";panel.Visible=false
    panel.Position=UDim2.new(1,-15,0,125);panel.AnchorPoint=Vector2.new(1,0)
    panel.Size=UDim2.fromOffset(286,184)
    panel.BackgroundColor3=BG;panel.Parent=gui;corner(panel,11)
    local title=label(panel,"ATELIERS PUBLICS",12,16,true)
    title.TextColor3=GOLD
    local detail=label(panel,"Approche une machine d'agora et active les étapes 1, 2, puis 3.",48,12,false)
    detail.Size=UDim2.new(1,-26,0,51)
    local marks=Instance.new("Frame")
    marks.Position=UDim2.fromOffset(16,109)
    marks.Size=UDim2.fromOffset(256,22)
    marks.BackgroundTransparency=1;marks.Parent=panel
    local cells={}
    for i=1,3 do
        local dot=Instance.new("TextLabel")
        dot.Size=UDim2.fromOffset(78,23)
        dot.Position=UDim2.fromOffset((i-1)*89,0)
        dot.Text="ÉTAPE "..i;dot.TextSize=11;dot.Font=Enum.Font.GothamBold
        dot.TextColor3=FG;dot.BackgroundColor3=Color3.fromRGB(67,92,96)
        dot.Parent=marks;corner(dot,7);cells[i]=dot
    end
    local foot=label(panel,"Jusqu'à 48 secondes entre les étapes. Aucun compte requis.",141,11,false)
    foot.Size=UDim2.new(1,-26,0,34)
    local function flip()panel.Visible=not panel.Visible end
    button.Activated:Connect(flip)
    UIS.InputBegan:Connect(function(input,handled)
        if not handled and input.KeyCode==Enum.KeyCode.K then flip() end
    end)
    local sequence=0
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="workshop.progress.v1" then return end
        sequence+=1
        local current=sequence
        title.Text=payload.title or "ATELIER PUBLIC"
        local step=math.clamp(tonumber(payload.step) or 1,1,4)
        for i,dot in ipairs(cells) do
            dot.BackgroundColor3=if i<step then Color3.fromRGB(64,157,114) else Color3.fromRGB(67,92,96)
        end
        detail.Text=if step==4 then "Expérience complétée ! Observe l'animation physique." else string.format("Étape %d / 3 · %s",step,if step==1 then "Assembler" elseif step==2 then "Calibrer" else "Animer")
        panel.Visible=true
        task.delay(12,function()
            if current==sequence and panel.Parent then panel.Visible=false end
        end)
    end)
end
return WorkshopHud
