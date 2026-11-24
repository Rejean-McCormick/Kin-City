--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Carnet LOCAL des galeries. Les marqueurs physiques sont créés par InstitutionStoriesV22.
-- Aucun RemoteEvent, aucun DataStore ni point EkoH ; le carnet repart de zéro par session.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local Journal={}
local TAG="KinCityGalleryV22"
local TOTAL=48 -- huit institutions x six salles aménagées
local seen={}
local markers={}
local labels={}
local gui:ScreenGui
local toggle:TextButton
local window:Frame
local summary:TextLabel
local listing:TextLabel
local function count()
    local n=0
    for _ in pairs(seen) do n+=1 end
    return n
end
local function refresh()
    local n=count()
    if toggle then toggle.Text="GALERIES "..n.."/"..TOTAL end
    if summary then summary.Text=tostring(n).." galeries découvertes pendant cette session" end
    if listing then
        local entries={}
        for id,title in pairs(seen) do table.insert(entries,{id=id,title=title}) end
        table.sort(entries,function(a,b) return a.id<b.id end)
        local lines={}
        for _,entry in ipairs(entries) do table.insert(lines,"✦ "..entry.title) end
        listing.Text=if #lines==0 then "Visite les salles des grandes institutions pour compléter ton carnet." else table.concat(lines,"\n")
    end
end
local function add(instance)
    if instance:IsA("BasePart") then markers[instance]=true end
end
local function remove(instance) markers[instance]=nil end
local function openClose()
    if window then window.Visible=not window.Visible end
end
function Journal.start()
    gui=Instance.new("ScreenGui")
    gui.Name="KinCityCarnetGaleriesV22"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.DisplayOrder=5
    gui.Parent=player:WaitForChild("PlayerGui")
    toggle=Instance.new("TextButton")
    toggle.Name="Galeries (T)"
    toggle.AnchorPoint=Vector2.new(0.5,0)
    toggle.Position=UDim2.new(0.5,167,0,45)
    toggle.Size=UDim2.fromOffset(137,32)
    toggle.BackgroundColor3=Color3.fromRGB(30,104,100)
    toggle.TextColor3=Color3.fromRGB(241,252,247)
    toggle.Font=Typography.body()
    toggle.TextSize=12
    toggle.Parent=gui
    local buttonCorner=Instance.new("UICorner")
    buttonCorner.CornerRadius=UDim.new(0,9)
    buttonCorner.Parent=toggle
    toggle.Activated:Connect(openClose)
    window=Instance.new("Frame")
    window.Name="Carnet des galeries"
    window.AnchorPoint=Vector2.new(0.5,0.5)
    window.Position=UDim2.fromScale(0.5,0.52)
    window.Size=UDim2.new(0.88,0,0.76,0)
    window.BackgroundColor3=Color3.fromRGB(18,62,60)
    window.Visible=false
    window.Parent=gui
    local constraint=Instance.new("UISizeConstraint")
    constraint.MaxSize=Vector2.new(520,530)
    constraint.MinSize=Vector2.new(260,190)
    constraint.Parent=window
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,15)
    corner.Parent=window
    local stroke=Instance.new("UIStroke")
    stroke.Color=Color3.fromRGB(229,215,175)
    stroke.Parent=window
    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-65,0,35)
    title.Position=UDim2.fromOffset(17,11)
    title.BackgroundTransparency=1
    title.Font=Typography.body()
    title.TextColor3=Color3.fromRGB(229,245,241)
    title.TextSize=20
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.Text="Carnet des galeries"
    title.Parent=window
    local close=Instance.new("TextButton")
    close.Name="Fermer"
    close.Size=UDim2.fromOffset(36,33)
    close.Position=UDim2.new(1,-49,0,11)
    close.Text="✕"
    close.TextSize=18
    close.Font=Typography.body()
    close.TextColor3=Color3.fromRGB(239,254,248)
    close.BackgroundColor3=Color3.fromRGB(42,96,92)
    close.Parent=window
    close.Activated:Connect(openClose)
    summary=Instance.new("TextLabel")
    summary.Name="Progression"
    summary.Size=UDim2.new(1,-35,0,42)
    summary.Position=UDim2.fromOffset(17,52)
    summary.BackgroundTransparency=1
    summary.Font=Typography.body()
    summary.TextColor3=Color3.fromRGB(209,227,221)
    summary.TextSize=14
    summary.TextWrapped=true
    summary.TextXAlignment=Enum.TextXAlignment.Left
    summary.Parent=window
    local scroll=Instance.new("ScrollingFrame")
    scroll.Name="Galeries explorées"
    scroll.Position=UDim2.fromOffset(16,101)
    scroll.Size=UDim2.new(1,-32,1,-118)
    scroll.ScrollBarThickness=6
    scroll.BackgroundColor3=Color3.fromRGB(24,75,71)
    scroll.BorderSizePixel=0
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.fromOffset(0,0)
    scroll.Parent=window
    listing=Instance.new("TextLabel")
    listing.BackgroundTransparency=1
    listing.Position=UDim2.fromOffset(12,8)
    listing.Size=UDim2.new(1,-28,0,0)
    listing.AutomaticSize=Enum.AutomaticSize.Y
    listing.TextXAlignment=Enum.TextXAlignment.Left
    listing.TextYAlignment=Enum.TextYAlignment.Top
    listing.TextWrapped=true
    listing.Font=Typography.body()
    listing.TextColor3=Color3.fromRGB(223,248,241)
    listing.TextSize=14
    listing.LineHeight=1.65
    listing.Parent=scroll
    -- Enregistrer seulement après la construction complète de la fenêtre.
    require(script.Parent.KinCityMenu).register("gallery","Galeries [T]",toggle,window,openClose)
    UserInputService.InputBegan:Connect(function(input,used)
        if not used and input.KeyCode==Enum.KeyCode.T then openClose() end
    end)
    for _,inst in ipairs(CollectionService:GetTagged(TAG)) do add(inst) end
    CollectionService:GetInstanceAddedSignal(TAG):Connect(add)
    CollectionService:GetInstanceRemovedSignal(TAG):Connect(remove)
    refresh()
    task.spawn(function()
        while gui.Parent do
            local ch=player.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            if root and root:IsA("BasePart") then
                local update=false
                for marker in pairs(markers) do
                    if marker.Parent and (marker.Position-root.Position).Magnitude<12 then
                        local id=marker:GetAttribute("KinGalleryId")
                        if typeof(id)=="string" and not seen[id] then
                            local title=marker:GetAttribute("KinGalleryTitle")
                            seen[id]=if typeof(title)=="string" then title else id
                            update=true
                        end
                    elseif not marker.Parent then markers[marker]=nil end
                end
                if update then refresh() end
            end
            task.wait(1.4)
        end
    end)
end
return Journal
