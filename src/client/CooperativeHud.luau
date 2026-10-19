--!strict
-- Notification non bloquante : l'exploration continue pendant l'activité.
local Players=game:GetService("Players")
local CooperativeHud={}
function CooperativeHud.start(remote)
    local ui=Instance.new("ScreenGui")
    ui.Name="KinCityCooperativeActivity"
    ui.ResetOnSpawn=false
    ui.DisplayOrder=13
    ui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local box=Instance.new("Frame")
    box.Name="CoopNotice";box.Size=UDim2.new(0.75,0,0,85)
    box.AnchorPoint=Vector2.new(0.5,0)
    box.Position=UDim2.new(0.5,0,0,70)
    box.BackgroundColor3=Color3.fromRGB(32,66,73)
    box.Visible=false;box.Parent=ui
    local constraint=Instance.new("UISizeConstraint")
    constraint.MaxSize=Vector2.new(480,90)
    constraint.Parent=box
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,12);corner.Parent=box
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-24,0,25)
    title.Position=UDim2.fromOffset(12,7)
    title.BackgroundTransparency=1
    title.TextColor3=Color3.fromRGB(238,199,121)
    title.Font=Enum.Font.GothamBold
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.TextSize=16;title.Text="ACTIVITÉ COOPÉRATIVE";title.Parent=box
    local body=Instance.new("TextLabel")
    body.Size=UDim2.new(1,-24,0,43)
    body.Position=UDim2.fromOffset(12,33)
    body.BackgroundTransparency=1
    body.TextColor3=Color3.fromRGB(242,241,222)
    body.TextXAlignment=Enum.TextXAlignment.Left
    body.TextWrapped=true
    body.TextSize=15;body.Font=Enum.Font.Gotham
    body.Parent=box
    local sequence=0
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or payload.kind~="coop.update.v1" then return end
        sequence+=1
        local current=sequence
        body.Text=payload.text or "Deux explorateurs peuvent participer."
        box.Visible=true
        task.delay(5.5,function()
            if current==sequence and box.Parent then box.Visible=false end
        end)
    end)
end
return CooperativeHud
