--!strict
-- KC36 ATELIER INTERIEUR V2B: interface autonome, adaptee a l'ecran, sans double scroll.
-- Le serveur conserve l'autorite sur selection, permissions et mutations de meubles.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local Menu=require(script.Parent.KinCityMenu)
local Client={}
local player=Players.LocalPlayer
local rpc:RemoteFunction?=nil
local selected:any=nil
local panel:Frame
local selectionLabel:TextLabel
local feedback:TextLabel
local selectButton:TextButton
local active=false
local selectionScope="model"
local mark:Highlight
local confirming=false

local BG=Color3.fromRGB(18,43,46)
local SURFACE=Color3.fromRGB(28,75,75)
local PRIMARY=Color3.fromRGB(32,112,106)
local BRASS=Color3.fromRGB(211,170,104)
local IVORY=Color3.fromRGB(247,243,224)
local MUTED=Color3.fromRGB(194,220,215)
local WARNING=Color3.fromRGB(242,188,127)

local function corner(parent:Instance,r:number)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=parent
end
local function border(parent:Instance,color:Color3,thickness:number)
    local line=Instance.new("UIStroke")
    line.Color=color;line.Thickness=thickness;line.Transparency=0.18
    line.Parent=parent
end
local function label(parent:Instance,message:string,height:number,fontSize:number,color:Color3,bold:boolean?):TextLabel
    local l=Instance.new("TextLabel")
    l.Name="Texte"
    l.Size=UDim2.new(1,-4,0,height)
    l.BackgroundTransparency=1
    l.Text=message;l.TextWrapped=true
    l.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    l.TextSize=fontSize;l.TextColor3=color
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.Parent=parent
    return l
end
local function button(parent:Instance,message:string,callback:()->(),tone:string?):TextButton
    local b=Instance.new("TextButton")
    b.Name=message
    b.Text=message;b.TextSize=15;b.TextScaled=false;b.TextWrapped=true
    b.BackgroundColor3=if tone=="danger" then Color3.fromRGB(124,61,53) else PRIMARY
    b.TextColor3=IVORY;b.Font=Enum.Font.GothamBold
    b.AutoButtonColor=true
    b.Size=UDim2.new(1,0,1,0);b.Parent=parent
    corner(b,7)
    b.Activated:Connect(callback)
    return b
end
local function commandRow(parent:Instance,items:{any}):Frame
    local r=Instance.new("Frame")
    r.Name="Ligne de commandes"
    r.Size=UDim2.new(1,-5,0,46)
    r.BackgroundTransparency=1
    r.Parent=parent
    local layout=Instance.new("UIListLayout")
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.Padding=UDim.new(0,9)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Parent=r
    for i,item in ipairs(items) do
        local b=button(r,item[1],item[2],item[3])
        b.LayoutOrder=i
        b.Size=UDim2.new(1/#items,-9,1,0)
    end
    return r
end
local function call(verb:string,key:any?,detail:any?):any
    if not rpc or not rpc.Parent then
        local candidate=RS:FindFirstChild("KinCityInteriorEditV36")
        if candidate and candidate:IsA("RemoteFunction") then rpc=candidate end
    end
    if not rpc then
        feedback.Text="Serveur Atelier indisponible : regarde Output."
        feedback.TextColor3=WARNING
        return nil
    end
    local ok,result=pcall(function() return rpc:InvokeServer(verb,key,detail) end)
    if not ok then
        feedback.Text="Connexion indisponible. Réessaie."
        feedback.TextColor3=WARNING
        return nil
    end
    if not result or not result.ok then
        feedback.Text=(result and result.message) or "Action refusée"
        feedback.TextColor3=WARNING
        return nil
    end
    feedback.Text=result.message or "Action réussie"
    feedback.TextColor3=MUTED
    return result
end
local function repaint()
    if not selected then
        selectionLabel.Text="Aucun objet sélectionné. Active SÉLECTION puis clique sur le décor."
        mark.Adornee=nil
        return
    end
    selectionLabel.Text=string.format("%s  •  X %.1f   Y %.1f   Z %.1f",
        selected.name,selected.pos[1],selected.pos[2],selected.pos[3])
    mark.Adornee=selected.model
end
local function update(result:any)
    if not result then return end
    selected=result.selection
    confirming=false
    repaint()
end
local function action(verb:string,detail:any?)
    if not selected then
        feedback.Text="Sélectionne d'abord un objet dans Kin City."
        feedback.TextColor3=WARNING
        return
    end
    update(call(verb,selected.id,detail))
end
local function pick(screen:Vector2):BasePart?
    local camera=Workspace.CurrentCamera
    local generated=Workspace:FindFirstChild("KinCityGenerated")
    if not camera or not generated then return nil end
    local ray=camera:ViewportPointToRay(screen.X,screen.Y)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances={generated}
    local hit=Workspace:Raycast(ray.Origin,ray.Direction*280,params)
    return hit and hit.Instance or nil
end
local function insidePanel(point:Vector2):boolean
    local pos=panel.AbsolutePosition
    local size=panel.AbsoluteSize
    return point.X>=pos.X and point.X<=pos.X+size.X
        and point.Y>=pos.Y and point.Y<=pos.Y+size.Y
end
local function toggleSelection()
    active=not active
    confirming=false
    selectButton.Text=if active then "SÉLECTION : ACTIVE ✓" else "SÉLECTION : ACTIVER"
    selectButton.BackgroundColor3=if active then Color3.fromRGB(135,89,48) else PRIMARY
    feedback.Text=if active then "Clique sur un objet du décor, en ville ou dans un bâtiment." else "Sélection désactivée."
    feedback.TextColor3=MUTED
end

function Client.start()
    local playerGui=player:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("KC36AtelierInterieur") then return end

    local ui=Instance.new("ScreenGui")
    ui.Name="KC36AtelierInterieur"
    ui.ResetOnSpawn=false
    ui.DisplayOrder=28
    ui.Parent=playerGui

    panel=Instance.new("Frame")
    panel.Name="ATELIER INTERIEUR"
    panel:SetAttribute("KinAtelierIndependentLayout",true)
    panel.AnchorPoint=Vector2.new(1,0)
    panel.Position=UDim2.new(1,-16,0,88)
    panel.Size=UDim2.fromOffset(448,750)
    panel.BackgroundColor3=BG
    panel.BorderSizePixel=0
    panel.Visible=false
    panel.Parent=ui
    corner(panel,12)
    border(panel,BRASS,1.6)

    local heading=Instance.new("Frame")
    heading.Name="En-tete fixe"
    heading.Position=UDim2.fromOffset(15,8)
    heading.Size=UDim2.new(1,-70,0,55)
    heading.BackgroundTransparency=1
    heading.Parent=panel
    local hTitle=label(heading,"ATELIER • MONDE ENTIER",28,20,IVORY,true)
    hTitle.Position=UDim2.fromOffset(0,0)
    local hDetail=label(heading,"Objets, bâtiments et décors · KC36",20,12,MUTED)
    hDetail.Position=UDim2.fromOffset(0,30)

    local statusFrame=Instance.new("Frame")
    statusFrame.Name="Statut fixe"
    statusFrame.Position=UDim2.fromOffset(12,68)
    statusFrame.Size=UDim2.new(1,-24,0,88)
    statusFrame.BackgroundColor3=SURFACE
    statusFrame.Parent=panel
    corner(statusFrame,8)
    feedback=label(statusFrame,"Ville et intérieurs : sélectionne un objet du décor.",40,14,MUTED)
    feedback.Position=UDim2.fromOffset(10,3)
    feedback.Size=UDim2.new(1,-20,0,40)
    selectionLabel=label(statusFrame,"Aucun objet sélectionné.",39,13,IVORY,true)
    selectionLabel.Position=UDim2.fromOffset(10,45)
    selectionLabel.Size=UDim2.new(1,-20,0,40)

    local scroll=Instance.new("ScrollingFrame")
    scroll.Name="Commandes lisibles"
    scroll.Position=UDim2.fromOffset(15,164)
    scroll.Size=UDim2.new(1,-30,1,-177)
    scroll.BackgroundTransparency=1
    scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=7
    scroll.ScrollBarImageColor3=BRASS
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.fromOffset(0,0)
    scroll.ScrollingDirection=Enum.ScrollingDirection.Y
    scroll.Parent=panel

    local stack=Instance.new("UIListLayout")
    stack.SortOrder=Enum.SortOrder.LayoutOrder
    stack.Padding=UDim.new(0,8)
    stack.Parent=scroll
    local order=0
    local function nextOrder(object:GuiObject)
        order+=1
        object.LayoutOrder=order
        return object
    end
    local function headingSmall(message:string)
        local header=nextOrder(label(scroll,message,25,14,BRASS,true))
        header.Name=message
    end
    local selectionRow=nextOrder(commandRow(scroll,{{"SÉLECTION : ACTIVER",toggleSelection}}))
    selectButton=selectionRow:FindFirstChildWhichIsA("TextButton") :: TextButton
    local modeButton:TextButton?=nil
    local modeRow=nextOrder(commandRow(scroll,{{"MODE : OBJET ENTIER",function()
        selectionScope=if selectionScope=="model" then "part" else "model"
        if modeButton then
            modeButton.Text=if selectionScope=="model" then "MODE : OBJET ENTIER" else "MODE : PIECE PRECISE"
        end
        selected=nil
        repaint()
        feedback.Text="Mode change : clique sur l'element a modifier"
        feedback.TextColor3=MUTED
    end}}))
    modeButton=modeRow:FindFirstChildWhichIsA("TextButton") :: TextButton
    headingSmall("DÉPLACER · pas de 0,5 stud")
    nextOrder(commandRow(scroll,{{"←  X −0,5",function() action("move",{-0.5,0,0}) end},
        {"X +0,5  →",function() action("move",{0.5,0,0}) end}}))
    nextOrder(commandRow(scroll,{{"↑  Z −0,5",function() action("move",{0,0,-0.5}) end},
        {"Z +0,5  ↓",function() action("move",{0,0,0.5}) end}}))
    nextOrder(commandRow(scroll,{{"MONTER  +0,5",function() action("move",{0,0.5,0}) end},
        {"DESCENDRE  −0,5",function() action("move",{0,-0.5,0}) end}}))
    nextOrder(commandRow(scroll,{{"↶  −15°",function() action("rotate",-15) end},
        {"+15°  ↷",function() action("rotate",15) end}}))
    headingSmall("OBJETS · modifications complètes")
    nextOrder(commandRow(scroll,{{"DUPLIQUER",function() action("duplicate") end},
        {"EFFACER",function()
            if not selected then
                feedback.Text="Sélectionne d'abord un objet."
                feedback.TextColor3=WARNING
                return
            end
            if not confirming then
                confirming=true
                feedback.Text="Confirmer : appuie encore sur EFFACER"
                feedback.TextColor3=WARNING
                return
            end
            action("delete")
        end,"danger"}}))
    nextOrder(commandRow(scroll,{{"ANNULER",function() update(call("undo")) end},
        {"RÉTABLIR",function() update(call("redo")) end}}))
    nextOrder(label(scroll,"Décors et structures visuelles modifiables. Scripts, portails, points de spawn, PNJ et terrain Roblox protégés.",49,13,MUTED))

    mark=Instance.new("Highlight")
    mark.Name="KC36MeubleSelectionne"
    mark.FillColor=Color3.fromRGB(197,244,240)
    mark.FillTransparency=0.80
    mark.OutlineColor=BRASS
    mark.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    mark.Parent=Workspace.CurrentCamera or ui

    -- KC36 UI V2B : inscription comme ACTION du menu, non comme fenetre geree.
    -- Ainsi le menu historique ne peut pas redimensionner ou encapsuler le panneau.
    -- Aucun changement de Source sur KinCityMenu, peu importe sa version.
    local close=Instance.new("TextButton")
    close.Name="Fermer l'atelier"
    close.AnchorPoint=Vector2.new(1,0)
    close.Position=UDim2.new(1,-12,0,14)
    close.Size=UDim2.fromOffset(38,36)
    close.Text="✕"
    close.Font=Enum.Font.GothamBold
    close.TextSize=19
    close.BackgroundColor3=PRIMARY
    close.TextColor3=IVORY
    close.ZIndex=10
    close.Parent=panel
    corner(close,7)
    close.Activated:Connect(function() panel.Visible=false end)

    assert(type(Menu.registerAction)=="function", "KinCityMenu.registerAction est requis")
    Menu.registerAction("interior_editor","ATELIER • Modifier toute Kin City",nil,
        function() panel.Visible=not panel.Visible end)
    -- Garder l'exclusivite du menu lorsque l'utilisateur ouvre un autre outil.
    local originalOpen=Menu.open
    Menu.open=function(key)
        if key~="interior_editor" then panel.Visible=false end
        return originalOpen(key)
    end
    local originalCloseTools=Menu.closeTools
    Menu.closeTools=function(...)
        panel.Visible=false
        return originalCloseTools(...)
    end
    local function resize()
        local camera=Workspace.CurrentCamera
        local v=if camera then camera.ViewportSize else Vector2.new(1280,720)
        local top=if v.Y<620 then 48 else 88
        local w=math.max(180,math.min(448,v.X-18))
        local h=math.max(190,math.min(770,v.Y-top-14))
        panel.Size=UDim2.fromOffset(w,h)
        panel.Position=UDim2.new(1,-9,0,top)
    end
    resize()
    local camera=Workspace.CurrentCamera
    if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    panel:GetPropertyChangedSignal("Visible"):Connect(function()
        if panel.Visible then
            local result=call("status")
            if result then
                feedback.Text=(result.message or "").." · "..(
                    if result.persistent then "Sauvegarde en ligne" else result.warning or "Session temporaire")
                feedback.TextColor3=MUTED
            end
        else
            active=false;confirming=false
            selectButton.Text="SÉLECTION : ACTIVER"
            selectButton.BackgroundColor3=PRIMARY
            mark.Adornee=nil
        end
    end)
    UIS.InputBegan:Connect(function(input,processed)
        if not active or not panel.Visible or processed then return end
        local screen:Vector2?=nil
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            screen=UIS:GetMouseLocation()
        elseif input.UserInputType==Enum.UserInputType.Touch then
            screen=Vector2.new(input.Position.X,input.Position.Y)
        elseif input.KeyCode==Enum.KeyCode.ButtonR2 then
            local current=Workspace.CurrentCamera
            if current then screen=current.ViewportSize/2 end
        end
        if not screen or insidePanel(screen) then return end
        update(call("select",pick(screen),selectionScope))
    end)
    print("KC36 WORLD EDIT UI : ville et interieurs, modes objet/piece")
end
return Client
