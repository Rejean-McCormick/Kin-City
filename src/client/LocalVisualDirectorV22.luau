--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Ambiance locale par visiteur : jamais de RemoteEvent ni d'altération du gameplay.
-- Trois qualités CHOISIES par le joueur; le mode standard reste la valeur initiale.
local Lighting=game:GetService("Lighting")
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local RS=game:GetService("ReplicatedStorage")
local Visual=require(RS:WaitForChild("KinCityShared"):WaitForChild("VisualConfig"))
local player=Players.LocalPlayer
local Director={}
local presets={
    LITE={bloom=0,saturation=-0.015,contrast=0.02},
    STANDARD={bloom=0.07,saturation=0.01,contrast=0.035},
    SHOWCASE={bloom=0.16,saturation=0.045,contrast=0.065},
}
local order={"LITE","STANDARD","SHOWCASE"}
local zones={
    city_hall=Color3.fromRGB(219,242,236),ekoh_tower=Color3.fromRGB(211,248,241),
    library=Color3.fromRGB(230,238,245),campus=Color3.fromRGB(223,229,251),
    justice_palace=Color3.fromRGB(242,236,221),innovation_lab=Color3.fromRGB(205,243,249),
    museum=Color3.fromRGB(247,227,246),orgo_center=Color3.fromRGB(216,239,244),
}
local quality=Visual.profile
local currentZone=""
local cfx:ColorCorrectionEffect
local bloom:BloomEffect
local button:TextButton
local busy:Tween?=nil
local function apply(zone,animate)
    local conf=presets[quality]
    if busy then busy:Cancel();busy=nil end
    local tint=zones[zone] or Color3.fromRGB(242,252,249)
    local goal={TintColor=tint,Saturation=conf.saturation,Contrast=conf.contrast,Brightness=0}
    if animate then
        busy=TweenService:Create(cfx,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),goal)
        busy:Play()
    else
        for key,val in pairs(goal) do (cfx :: any)[key]=val end
    end
    bloom.Intensity=conf.bloom
    bloom.Enabled=conf.bloom>0
    player:SetAttribute("KinCityLocalQuality",quality)
    if button then
        local label=if quality=="LITE" then "LÉGER" elseif quality=="STANDARD" then "NORMAL" else "DÉTAIL"
        button.Text="✦ VILLE : "..label
    end
end
local function cycle()
    local i=table.find(order,quality) or 2
    quality=order[(i%#order)+1]
    apply(currentZone,false)
end
function Director.start()
    local existing=Lighting:FindFirstChild("KinCityLocalColorV22")
    if existing then existing:Destroy() end
    local oldBloom=Lighting:FindFirstChild("KinCityLocalBloomV22")
    if oldBloom then oldBloom:Destroy() end
    cfx=Instance.new("ColorCorrectionEffect")
    cfx.Name="KinCityLocalColorV22"
    cfx.Parent=Lighting
    bloom=Instance.new("BloomEffect")
    bloom.Name="KinCityLocalBloomV22"
    bloom.Size=12
    bloom.Threshold=1.7
    bloom.Parent=Lighting
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityQualitéLocale"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.DisplayOrder=2
    gui.Parent=player:WaitForChild("PlayerGui")
    button=Instance.new("TextButton")
    button.Name="Changer la qualité (V)"
    button.AnchorPoint=Vector2.new(0.5,0)
    button.Position=UDim2.new(0.5,0,0,45)
    button.Size=UDim2.fromOffset(156,32)
    button.BackgroundColor3=Color3.fromRGB(18,62,60)
    button.BackgroundTransparency=0.13
    button.TextColor3=Color3.fromRGB(226,249,245)
    button.TextSize=12
    button.Font=Typography.body()
    button.AutoButtonColor=true
    button.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,9)
    corner.Parent=button
    local stroke=Instance.new("UIStroke")
    stroke.Color=Color3.fromRGB(229,215,175)
    stroke.Transparency=0.35
    stroke.Parent=button
    button.Activated:Connect(cycle)
    UserInputService.InputBegan:Connect(function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.V then cycle() end
    end)
    require(script.Parent.KinCityMenu).registerAction("quality","Qualité visuelle [V]",button,cycle)
    currentZone=player:GetAttribute("KinZone") or ""
    apply(currentZone,false)
    player:GetAttributeChangedSignal("KinZone"):Connect(function()
        local zone=player:GetAttribute("KinZone") or ""
        if currentZone~=zone then currentZone=zone;apply(zone,true) end
    end)
end
return Director
