--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Indicateur de trajet non bloquant; le joueur peut admirer la ville pendant le trajet.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local UI={}
function UI.start(remote)
    local screen=Instance.new("ScreenGui")
    screen.Name="KinCityTramRide";screen.ResetOnSpawn=false;screen.DisplayOrder=9;screen.Enabled=false
    screen.Parent=player:WaitForChild("PlayerGui")
    local frame=Instance.new("Frame")
    frame.AnchorPoint=Vector2.new(0.5,1);frame.Position=UDim2.new(0.5,0,1,-85)
    frame.Size=UDim2.new(0.75,0,0,74);frame.BackgroundColor3=Color3.fromRGB(30,64,73)
    frame.Parent=screen
    local size=Instance.new("UISizeConstraint");size.MinSize=Vector2.new(240,64);size.MaxSize=Vector2.new(520,84);size.Parent=frame
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,13);round.Parent=frame
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-28,0,39);title.Position=UDim2.fromOffset(14,3)
    title.BackgroundTransparency=1;title.TextXAlignment=Enum.TextXAlignment.Left;title.Font=Typography.body()
    title.TextColor3=Color3.fromRGB(246,241,221);title.TextSize=16;title.Text="Tramway Kin City"
    title.Parent=frame
    local track=Instance.new("Frame")
    track.Size=UDim2.new(1,-28,0,8);track.Position=UDim2.new(0,14,1,-21)
    track.BackgroundColor3=Color3.fromRGB(86,113,119);track.BorderSizePixel=0;track.Parent=frame
    local progress=Instance.new("Frame");progress.Size=UDim2.fromScale(0,1)
    progress.BackgroundColor3=Color3.fromRGB(241,200,115);progress.BorderSizePixel=0;progress.Parent=track
    local serial=0
    remote.OnClientEvent:Connect(function(payload)
        if typeof(payload)~="table" or (payload.kind~="tram.ride.v1" and payload.kind~="ferry.ride.v1") then return end
        local transport=if payload.kind=="ferry.ride.v1" then "Ferry" else "Tramway"
        serial+=1
        local ticket=serial
        if payload.state=="depart" then
            title.Text=transport.." • "..tostring(payload.destination or "Votre destination")
            progress.Size=UDim2.fromScale(0,1)
            screen.Enabled=true
            local duration=math.clamp(tonumber(payload.duration) or 8,2,120)
            TweenService:Create(progress,TweenInfo.new(duration,Enum.EasingStyle.Linear),{Size=UDim2.fromScale(1,1)}):Play()
        elseif payload.state=="arrive" then
            progress.Size=UDim2.fromScale(1,1)
            title.Text=transport.." • Arrivée à destination"
            task.delay(2.5,function() if serial==ticket then screen.Enabled=false end end)
        elseif payload.state=="cancel" then
            screen.Enabled=false
        end
    end)
end
return UI
