--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- v30 : outils exclusifs, recherche locale, défilement mobile et focus manette.
-- Les dialogues narratifs et les confirmations ne sont pas des outils.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local GuiService=game:GetService("GuiService")
local Menu={}
local entries={}
local player=Players.LocalPlayer
local gui,menuPanel,items,list,searchBox,emptyLabel
local expanded=false
local function refreshResults()
    if not list then return end
    local query=if searchBox then string.lower(searchBox.Text) else ""
    local found=0
    for _,e in ipairs(entries) do
        local matches=query=="" or string.find(string.lower(e.label),query,1,true)~=nil
        if e.button then e.button.Visible=matches end
        if matches then found+=1 end
    end
    if emptyLabel then emptyLabel.Visible=found==0 end
    -- UIListLayout donne la hauteur effective après les filtres et le reflow mobile.
    local layout=list:FindFirstChildOfClass("UIListLayout")
    if layout then
        list.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+12)
    end
end
local function focusMenu()
    if not UIS.GamepadEnabled or not menuPanel or not menuPanel.Visible then return end
    for _,e in ipairs(entries) do
        if e.button and e.button.Visible then GuiService.SelectedObject=e.button;return end
    end
    if searchBox then GuiService.SelectedObject=searchBox end
end
local function corner(parent,r)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r);c.Parent=parent
end
local function makeButton(parent,label,height)
    local b=Instance.new("TextButton");b.Size=UDim2.new(1,-16,0,height or 40)
    b.BackgroundColor3=Color3.fromRGB(30,104,100);b.TextColor3=Color3.fromRGB(197,244,240)
    b.Text=label;b.Font=Typography.body();b.TextSize=13;b.TextWrapped=true;b.Parent=parent
    corner(b,8)
    return b
end
local function showOnly(key)
    for _,e in ipairs(entries) do
        if e.key~=key and e.window then e.window.Visible=false end
    end
    if menuPanel then menuPanel.Visible=false end
    if UIS.GamepadEnabled then
        for _,entry in ipairs(entries) do
            if entry.key==key and entry.window then
                local close=entry.window:FindFirstChild("Fermer l'outil")
                if close and close:IsA("GuiButton") then GuiService.SelectedObject=close end
                break
            end
        end
    end
end
function Menu.closeTools()
    for _,e in ipairs(entries) do if e.window then e.window.Visible=false end end
    if menuPanel then menuPanel.Visible=false end
    local selected=GuiService.SelectedObject
    if selected then
        local belongs=gui and selected:IsDescendantOf(gui)
        for _,entry in ipairs(entries) do
            if entry.window and selected:IsDescendantOf(entry.window) then belongs=true;break end
        end
        if belongs then GuiService.SelectedObject=nil end
    end
end
function Menu.open(key)
    for _,e in ipairs(entries) do
        if e.key==key then
            if e.action then e.action()
            elseif e.window then e.window.Visible=not e.window.Visible end
            if not e.window or e.window.Visible then showOnly(key) end
            return
        end
    end
end
function Menu.register(key,label,toggle,window,action)
    assert(gui,"KinCityMenu.start must run first")
    assert(typeof(window)=="Instance" and window:IsA("GuiObject"),
        "KinCityMenu.register : fenêtre absente pour "..tostring(key).." (créer la fenêtre avant register)")
    for _,e in ipairs(entries) do if e.key==key then error("duplicate Kin City tool "..key) end end
    local e={key=key,window=window,action=action,label=label}
    table.insert(entries,e)
    if toggle then toggle.Visible=false end
    -- Menus ouverts via les anciens raccourcis ou les messages serveur : exclusivité.
    window:GetPropertyChangedSignal("Visible"):Connect(function()
        if window.Visible then showOnly(key) end
    end)
    local close=Instance.new("TextButton");close.Name="Fermer l'outil"
    close.AnchorPoint=Vector2.new(1,0);close.Position=UDim2.new(1,-6,0,5)
    close.Size=UDim2.fromOffset(34,30);close.Text="✕";close.Font=Typography.body()
    close.TextSize=17;close.BackgroundColor3=Color3.fromRGB(30,104,100)
    close.TextColor3=Color3.fromRGB(245,251,249);close.ZIndex=25;close.Parent=window
    corner(close,7);close.Activated:Connect(function()window.Visible=false end)
    local viewport=workspace.CurrentCamera
    local normalWidth=math.max(window.Size.X.Offset,240)
    local normalHeight=math.max(window.Size.Y.Offset,135)
    -- L'ancien UISizeConstraint peut forcer une taille supérieure à l'écran mobile.
    -- Le dimensionnement commun borne déjà la fenêtre; son contenu défile.
    local constraint=window:FindFirstChildOfClass("UISizeConstraint")
    if constraint then constraint.MinSize=Vector2.zero end
    -- Les grandes fenêtres conservent leur contenu, avec scroll vertical sur mobile.
    local contents=Instance.new("ScrollingFrame");contents.Name="Contenu défilable v30"
    contents.Size=UDim2.fromScale(1,1);contents.BackgroundTransparency=1
    contents.BorderSizePixel=0;contents.ScrollBarThickness=5;contents.Selectable=true
    contents.CanvasSize=UDim2.fromOffset(0,normalHeight);contents.Parent=window
    for _,child in ipairs(window:GetChildren()) do
        if child~=contents and child~=close and (child:IsA("GuiObject")
            or child:IsA("UIListLayout") or child:IsA("UIGridLayout")
            or child:IsA("UIPageLayout") or child:IsA("UIPadding")) then
            child.Parent=contents
        end
    end
    local contentHeight=normalHeight
    for _,child in ipairs(contents:GetChildren()) do
        if child:IsA("GuiObject") then
            contentHeight=math.max(contentHeight,child.Position.Y.Offset+child.Size.Y.Offset)
        end
    end
    -- v31.7 : l'éditeur a davantage de commandes que la fenêtre visible sur téléphone.
    -- Ne pas limiter le CanvasSize à la hauteur de la fenêtre d'origine.
    -- La hauteur de la fenêtre et sa position se recalculent à chaque changement d'écran.
    local function resize()
        local c=workspace.CurrentCamera
        local v=c and c.ViewportSize or Vector2.new(900,650)
        local w=math.max(180,math.min(normalWidth,v.X-20))
        local h=math.max(125,math.min(normalHeight,v.Y-115))
        window.AnchorPoint=Vector2.new(0.5,0.5)
        window.Position=UDim2.fromScale(0.5,0.52)
        window.Size=UDim2.fromOffset(w,h)
        contents.CanvasSize=UDim2.fromOffset(0,contentHeight+18)
        -- L'interface de l'outil reste visible pendant que sa liste défile.
    end
    resize()
    if viewport then viewport:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    local b=makeButton(items,label,38)
    e.button=b
    b.LayoutOrder=#entries
    b.Activated:Connect(function()Menu.open(key) end)
    refreshResults()
end
-- Actions sans fenêtre (qualité visuelle, etc.) : même point d'accès.
function Menu.registerAction(key,label,toggle,action)
    assert(gui,"KinCityMenu.start must run first")
    for _,e in ipairs(entries) do if e.key==key then error("duplicate Kin City tool "..key) end end
    if toggle then toggle.Visible=false end
    local e={key=key,label=label,action=action}
    table.insert(entries,e)
    local b=makeButton(items,label,38);b.LayoutOrder=#entries;e.button=b
    b.Activated:Connect(function()Menu.open(key) end)
    refreshResults()
end

function Menu.start()
    if gui then return end
    gui=Instance.new("ScreenGui");gui.Name="KinCityMenuV30";gui.ResetOnSpawn=false
    gui.DisplayOrder=29;gui.Parent=player:WaitForChild("PlayerGui")
    local button=Instance.new("TextButton")
    button.Name="Menu Kin City";button.Size=UDim2.fromOffset(140,42)
    button.AnchorPoint=Vector2.new(1,0);button.Position=UDim2.new(1,-12,0,14)
    button.Text="☰ KIN CITY";button.Font=Typography.body();button.TextSize=15
    button.BackgroundColor3=Color3.fromRGB(30,104,100)
    button.TextColor3=Color3.fromRGB(197,244,240);button.Parent=gui;corner(button,10)
    menuPanel=Instance.new("Frame");menuPanel.Name="Outils"
    menuPanel.AnchorPoint=Vector2.new(1,0);menuPanel.Position=UDim2.new(1,-12,0,62)
    menuPanel.Size=UDim2.fromOffset(272,420);menuPanel.BackgroundColor3=Color3.fromRGB(18,45,53)
    menuPanel.Visible=false;menuPanel.Parent=gui;corner(menuPanel,10)
    local function resizeMenu()
        local cam=workspace.CurrentCamera
        local v=cam and cam.ViewportSize or Vector2.new(900,650)
        menuPanel.Size=UDim2.fromOffset(math.max(160,math.min(272,v.X-24)),math.max(150,math.min(510,v.Y-105)))
    end
    resizeMenu()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeMenu)
    end
    local title=Instance.new("TextLabel");title.Size=UDim2.new(1,-15,0,37)
    title.Position=UDim2.fromOffset(10,3);title.BackgroundTransparency=1
    title.Text="OUTILS · Échap / B pour fermer";title.TextColor3=Color3.fromRGB(197,244,240)
    title.Font=Typography.body();title.TextSize=12;title.Parent=menuPanel
    searchBox=Instance.new("TextBox")
    searchBox.Name="Rechercher un outil"
    searchBox.PlaceholderText="Rechercher un outil…"
    searchBox.ClearTextOnFocus=false;searchBox.Text=""
    searchBox.TextSize=13;searchBox.Font=Typography.body()
    searchBox.TextColor3=Color3.fromRGB(197,244,240)
    searchBox.PlaceholderColor3=Color3.fromRGB(167,203,199)
    searchBox.BackgroundColor3=Color3.fromRGB(38,72,79)
    searchBox.Size=UDim2.new(1,-16,0,33);searchBox.Position=UDim2.fromOffset(8,41)
    searchBox.Parent=menuPanel;corner(searchBox,7)
    list=Instance.new("ScrollingFrame");list.Size=UDim2.new(1,-10,1,-91)
    list.Position=UDim2.fromOffset(5,82);list.BackgroundTransparency=1
    list.BorderSizePixel=0;list.ScrollBarThickness=5;list.CanvasSize=UDim2.fromOffset(0,0)
    list.Parent=menuPanel;items=list
    local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,5)
    layout.SortOrder=Enum.SortOrder.LayoutOrder;layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.Parent=items
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshResults)
    searchBox:GetPropertyChangedSignal("Text"):Connect(refreshResults)
    emptyLabel=Instance.new("TextLabel")
    emptyLabel.Name="Aucun outil trouvé";emptyLabel.BackgroundTransparency=1
    emptyLabel.Size=UDim2.new(1,-16,0,58)
    emptyLabel.Text="Aucun outil chargé. Le démarrage du jeu est peut-être incomplet."
    emptyLabel.TextWrapped=true;emptyLabel.TextSize=15
    emptyLabel.TextColor3=Color3.fromRGB(242,231,198)
    emptyLabel.LayoutOrder=0
    emptyLabel.Visible=false;emptyLabel.Parent=items
    local gap=makeButton(items,"INDICATEURS · Ouvrir",38);gap.LayoutOrder=1000
    local counters=Instance.new("TextLabel");counters.Name="Statistiques locales"
    counters.Size=UDim2.new(1,-16,0,140);counters.LayoutOrder=1001
    counters.BackgroundTransparency=1;counters.TextWrapped=true
    counters.TextColor3=Color3.fromRGB(232,245,238);counters.TextSize=12
    counters.Font=Typography.body();counters.Visible=false;counters.Parent=items
    gap.Activated:Connect(function()
        expanded=not expanded;counters.Visible=expanded
        refreshResults()
    end)
    local secondary={"KinCityDiscoveryTracker","KinCityIslandPassport"}
    -- Ne jamais désactiver les GUI d'histoire, de dialogues, d'animation ou de transport.
    local holders={}
    local function hideCounter(child)
        for _,name in ipairs(secondary) do
            if child.Name==name and child:IsA("ScreenGui") then
                table.insert(holders,child);child.Enabled=false;break
            end
        end
    end
    player.PlayerGui.ChildAdded:Connect(hideCounter)
    task.defer(function()
    for _,name in ipairs(secondary) do
        local other=player.PlayerGui:FindFirstChild(name)
        if other and other:IsA("ScreenGui") then
            hideCounter(other)
        end
    end
    end)
    task.spawn(function()
        while gui and gui.Parent do
            if expanded then
                local lines={"Compteurs de la session (locaux)"}
                for _,other in ipairs(holders) do
                    for _,obj in ipairs(other:GetDescendants()) do
                        if obj:IsA("TextLabel") and #obj.Text>0 then
                            table.insert(lines,string.sub(obj.Text,1,95))
                            if #lines>=7 then break end
                        end
                    end
                end
                counters.Text=table.concat(lines,"\n")
            end
            task.wait(0.8)
        end
    end)
    local function toggleMenu()
        local open=not menuPanel.Visible
        if open then
            Menu.closeTools()
            menuPanel.Visible=true
            refreshResults()
            focusMenu()
        else
            Menu.closeTools()
        end
    end
    button.Activated:Connect(toggleMenu)
    UIS.InputBegan:Connect(function(input,used)
        if UIS:GetFocusedTextBox() then return end
        if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB then
            Menu.closeTools()
        elseif not used and input.KeyCode==Enum.KeyCode.ButtonSelect then
            toggleMenu()
        end
    end)
end
return Menu
