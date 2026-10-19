--!strict
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local GuiService=game:GetService("GuiService")
local player=Players.LocalPlayer
local Hud={}
local titleLabel,bodyLabel,detailLabel,panel,closeButton,frameGui
local messageSequence=0

local function createLabel(parent, text,size,weight,y)
    local label=Instance.new("TextLabel")
    label.BackgroundTransparency=1
    label.Size=UDim2.new(1,-44,0,size)
    label.Position=UDim2.fromOffset(22,y)
    label.Font=weight and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextColor3=Color3.fromRGB(241,243,241)
    label.TextWrapped=true
    label.TextXAlignment=Enum.TextXAlignment.Left
    label.TextYAlignment=Enum.TextYAlignment.Center
    label.TextScaled=false
    label.TextSize=if weight then 24 else 18
    label.Text=text
    label.Parent=parent
    return label
end

local function close()
    if frameGui then frameGui.Enabled=false end
    if closeButton and GuiService.SelectedObject==closeButton then GuiService.SelectedObject=nil end
end

function Hud.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityDialog"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true
    gui.DisplayOrder=15
    gui.Enabled=false
    gui.Parent=player:WaitForChild("PlayerGui")
    frameGui=gui
    local background=Instance.new("Frame")
    background.Name="Dim"
    background.BackgroundColor3=Color3.new(0,0,0)
    background.BackgroundTransparency=0.45
    background.Size=UDim2.fromScale(1,1)
    background.Parent=gui
    local card=Instance.new("Frame")
    card.Name="Message"
    card.AnchorPoint=Vector2.new(0.5,0.5)
    card.Position=UDim2.fromScale(0.5,0.5)
    card.Size=UDim2.new(0.85,0,0,264)
    card.BackgroundColor3=Color3.fromRGB(28,46,54)
    card.Parent=background
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,17);corner.Parent=card
    local outline=Instance.new("UIStroke");outline.Color=Color3.fromRGB(101,153,154);outline.Thickness=2;outline.Parent=card
    local constraint=Instance.new("UISizeConstraint");constraint.MaxSize=Vector2.new(530,300);constraint.MinSize=Vector2.new(280,240);constraint.Parent=card
    titleLabel=createLabel(card,"Kin City",44,true,18)
    bodyLabel=createLabel(card,"Fonctionnalité à venir",60,false,73)
    detailLabel=createLabel(card,"Aucune opération n'a été effectuée.",56,false,137)
    detailLabel.TextColor3=Color3.fromRGB(177,198,205)
    detailLabel.TextSize=14
    local closeBtn=Instance.new("TextButton")
    closeBtn.Name="Fermer"
    closeBtn.Text="Fermer"
    closeBtn.Font=Enum.Font.GothamBold
    closeBtn.TextSize=20
    closeBtn.TextColor3=Color3.new(1,1,1)
    closeBtn.BackgroundColor3=Color3.fromRGB(42,116,124)
    closeBtn.AnchorPoint=Vector2.new(0.5,1)
    closeBtn.Position=UDim2.new(0.5,0,1,-16)
    closeBtn.Size=UDim2.new(1,-44,0,48)
    closeBtn.Parent=card
    local closeCorner=Instance.new("UICorner");closeCorner.CornerRadius=UDim.new(0,10);closeCorner.Parent=closeBtn
    closeButton=closeBtn
    closeBtn.Activated:Connect(close)
    UserInputService.InputBegan:Connect(function(input,processed)
        if gui.Enabled and input.KeyCode==Enum.KeyCode.Escape then close() end
        if gui.Enabled and input.KeyCode==Enum.KeyCode.ButtonB then close() end
    end)
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" then return end
        local kind=payload.kind
        if kind~="interaction.reply.v1" and kind~="travel.failure.v1" then return end
        messageSequence+=1
        titleLabel.Text=if kind=="travel.failure.v1" then "Passage indisponible" else (payload.title or "Kin City")
        bodyLabel.Text=payload.message or "Fonctionnalité à venir"
        detailLabel.Text=payload.notice or "Vous pouvez continuer votre exploration."
        gui.Enabled=true
        GuiService.SelectedObject=closeButton
    end)
end
return Hud
