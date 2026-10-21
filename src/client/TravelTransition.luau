--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
local Players=game:GetService("Players")
local Transition={}
function Transition.start(remote)
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityTravelStatus";gui.ResetOnSpawn=false;gui.DisplayOrder=12
    gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local label=Instance.new("TextLabel")
    label.AnchorPoint=Vector2.new(0.5,1)
    label.Position=UDim2.new(0.5,0,1,-75)
    label.Size=UDim2.new(0.85,0,0,56)
    label.BackgroundColor3=Color3.fromRGB(30,104,100)
    label.TextColor3=Color3.fromRGB(197,244,240)
    label.Font=Typography.body();label.TextSize=17;label.TextWrapped=true
    label.Visible=false;label.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=label
    local constraint=Instance.new("UISizeConstraint");constraint.MaxSize=Vector2.new(500,56);constraint.Parent=label
    remote.OnClientEvent:Connect(function(payload)
        if type(payload)~="table" then return end
        if payload.kind=="travel.pending.v1" then
            label.Text="Passage vers "..tostring(payload.destination or "votre destination").."…"
            label.Visible=true
        elseif payload.kind=="travel.failure.v1" or payload.kind=="travel.complete.v1" then
            label.Visible=false
        end
    end)
    Players.LocalPlayer.CharacterAdded:Connect(function() label.Visible=false end)
end
return Transition
