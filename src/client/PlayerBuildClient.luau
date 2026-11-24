--!strict
-- Koali v31.7 : sélection dans le monde; le serveur effectue toutes les modifications.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local Menu=require(script.Parent.KinCityMenu)
local Typography=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("Typography"))
local Client={}
local player=Players.LocalPlayer
-- Ne jamais bloquer le chargement de tout le menu Kin City si le serveur
-- n'a pas encore créé l'interface distante de l'éditeur.
local rpc:RemoteFunction?=nil
local menuPanel:Frame
local selection:any=nil
local active=false
local tool="move"
local materialIndex=1
local mats={"Slate","Wood","WoodPlanks","Brick","Cobblestone","Concrete","Marble","Metal","Grass","Fabric","SmoothPlastic","Glass","Granite","Sandstone","Neon"}
local materialsLabel:TextLabel
local selectionLabel:TextLabel
local notice:TextLabel
local modeLabel:TextLabel
local highlight:Highlight
local dragging=false
local dragPrevious:Vector3?=nil
local dragTime=0
local HEX="1E6864"
local colorInput:TextBox
local activeCamera=Workspace.CurrentCamera

local function corner(gui:GuiObject,r:number)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=gui
end
local function label(parent:Instance,text:string,height:number):TextLabel
    local l=Instance.new("TextLabel")
    l.Size=UDim2.new(1,-16,0,height)
    l.BackgroundTransparency=1
    l.Text=text
    l.TextWrapped=true
    l.TextColor3=Color3.fromRGB(221,246,239)
    l.Font=Typography.body()
    l.TextSize=15
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.Parent=parent
    return l
end
local function btn(parent:Instance,text:string,fn:()->(),tint:Color3?):TextButton
    local button=Instance.new("TextButton")
    button.Text=text
    button.BackgroundColor3=tint or Color3.fromRGB(30,104,100)
    button.TextColor3=Color3.fromRGB(244,252,252)
    button.Font=Typography.body()
    button.TextSize=14
    button.TextWrapped=true
    button.Size=UDim2.fromOffset(100,40)
    button.Parent=parent
    corner(button,6)
    button.Activated:Connect(fn)
    return button
end
local function line(parent:Instance,buttons:{any},height:number)
    local bar=Instance.new("Frame")
    bar.Size=UDim2.new(1,-16,0,height)
    bar.BackgroundTransparency=1
    bar.Parent=parent
    local layout=Instance.new("UIListLayout")
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.VerticalAlignment=Enum.VerticalAlignment.Center
    layout.Padding=UDim.new(0,6)
    layout.Parent=bar
    for _,item in ipairs(buttons) do
        local b=btn(bar,item[1],item[2])
        b.Size=UDim2.new(1/#buttons,-7,0,36)
    end
end
local function request(verb:string,value:any?,extra:any?):any
    if not rpc or not rpc.Parent then
        local candidate=ReplicatedStorage:FindFirstChild("KinCityBuildRPC")
        if candidate and candidate:IsA("RemoteFunction") then rpc=candidate end
    end
    if not rpc then
        notice.Text="Éditeur visible, serveur en cours de chargement. Vérifie Sortie si cela persiste."
        return nil
    end
    local ok,reply=pcall(function() return rpc:InvokeServer(verb,value,extra) end)
    if not ok then
        notice.Text="Erreur de connexion à l’éditeur"
        return nil
    end
    if not reply or not reply.ok then
        notice.Text=reply and reply.message or "Modification refusée"
        return nil
    end
    if reply.message then notice.Text=reply.message end
    return reply
end
local function refresh()
    if not selection then
        selectionLabel.Text="Aucun objet sélectionné. Active la sélection, puis touche une pièce dans le décor."
        highlight.Adornee=nil
        return
    end
    local info=selection.info
    local p=info.pos
    selectionLabel.Text=string.format("%s%s\nX %.1f   Y %.1f   Z %.1f", selection.name, if selection.changed then " • modifié" else "", p[1], p[2], p[3])
end
local function selectedAction(verb:string,extra:any?)
    if not selection then notice.Text="Sélectionne d’abord une pièce";return end
    local result=request(verb,selection.id,extra)
    if result and result.selection then
        selection=result.selection
        highlight.Adornee=selection.part
        if verb=="material" then
            for index,name in ipairs(mats) do if name==selection.info.material then materialIndex=index end end
        end
        materialsLabel.Text="Matière : "..selection.info.material
        refresh()
    end
end
local function choose(p:Instance?)
    local result=request("select",p)
    if result and result.selection then
        selection=result.selection
        highlight.Adornee=selection.part
        for i,m in ipairs(mats) do if m==selection.info.material then materialIndex=i end end
        materialsLabel.Text="Matière : "..selection.info.material
        notice.Text="Objet sélectionné (sélection ≠ modification)"
        refresh()
    end
end
local function cameraRay(screenPosition:Vector2):Ray?
    local cam=Workspace.CurrentCamera
    if not cam then return nil end
    return cam:ViewportPointToRay(screenPosition.X,screenPosition.Y)
end
local function pick(screenPosition:Vector2):BasePart?
    local camRay=cameraRay(screenPosition)
    if not camRay then return nil end
    local world=Workspace:FindFirstChild("KinCityGenerated")
    if not world then return nil end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances={world}
    params.IgnoreWater=true
    local hit=Workspace:Raycast(camRay.Origin,camRay.Direction*600,params)
    if hit and hit.Instance:IsA("BasePart") then return hit.Instance end
    return nil
end
local function rayPlane(screenPosition:Vector2,atY:number):Vector3?
    local ray=cameraRay(screenPosition)
    if not ray then return nil end
    local dir=ray.Direction
    if math.abs(dir.Y)<0.05 then return nil end
    local t=(atY-ray.Origin.Y)/dir.Y
    if t<0 or t>1500 then return nil end
    return ray.Origin+dir*t
end
local function onPick(screenPosition:Vector2)
    if not active then return end
    local part=pick(screenPosition)
    if not part then return end
    if selection and highlight.Adornee==part and tool=="move" then
        dragging=true
        dragPrevious=rayPlane(screenPosition,selection.info.pos[2])
    else
        choose(part)
    end
end
local function onDrag(screenPosition:Vector2)
    if not dragging or not active or not selection or tool~="move" then return end
    if os.clock()-dragTime<0.16 then return end
    local nextPoint=rayPlane(screenPosition,selection.info.pos[2])
    if not nextPoint or not dragPrevious then return end
    local diff=nextPoint-dragPrevious
    local dx=math.round(diff.X*2)/2
    local dz=math.round(diff.Z*2)/2
    if math.abs(dx)<0.5 and math.abs(dz)<0.5 then return end
    dragTime=os.clock()
    dragPrevious=nextPoint
    selectedAction("move",{math.clamp(dx,-8,8),0,math.clamp(dz,-8,8)})
end
local function onMaterial(dir:number)
    materialIndex=(materialIndex-1+dir+#mats)%#mats+1
    selectedAction("material",mats[materialIndex])
end
local function applyHex()
    local v=string.upper(string.gsub(colorInput.Text,"#",""))
    if #v~=6 or string.find(v,"[^0-9A-F]") then notice.Text="Couleur : entrer 6 chiffres hexadécimaux";return end
    local r=tonumber(string.sub(v,1,2),16)
    local g=tonumber(string.sub(v,3,4),16)
    local b=tonumber(string.sub(v,5,6),16)
    selectedAction("color",{r,g,b})
end
function Client.start()
    local ui=Instance.new("ScreenGui")
    ui.Name="KinCityWorldEditorV31"
    ui.ResetOnSpawn=false
    ui.DisplayOrder=26
    ui.Parent=player:WaitForChild("PlayerGui")
    menuPanel=Instance.new("Frame")
    menuPanel.Name="Mode Création"
    menuPanel.AnchorPoint=Vector2.new(1,0)
    menuPanel.Position=UDim2.new(1,-14,0,76)
    menuPanel.Size=UDim2.new(0.92,0,1,-112)
    local panelLimit=Instance.new("UISizeConstraint")
    panelLimit.MaxSize=Vector2.new(385,740)
    panelLimit.MinSize=Vector2.new(255,320)
    panelLimit.Parent=menuPanel
    menuPanel.BackgroundColor3=Color3.fromRGB(16,46,50)
    menuPanel.BorderSizePixel=0
    menuPanel.Visible=false
    menuPanel.Parent=ui
    corner(menuPanel,10)
    local content=Instance.new("ScrollingFrame")
    content.Name="Commandes du constructeur"
    content.Size=UDim2.new(1,-14,1,-16)
    content.Position=UDim2.fromOffset(7,8)
    content.BackgroundTransparency=1
    content.BorderSizePixel=0
    content.CanvasSize=UDim2.fromOffset(0,0)
    content.AutomaticCanvasSize=Enum.AutomaticSize.Y
    content.ScrollingDirection=Enum.ScrollingDirection.Y
    content.ScrollBarThickness=6
    content.ScrollBarImageColor3=Color3.fromRGB(147,203,192)
    content.Parent=menuPanel
    local layout=Instance.new("UIListLayout")
    layout.Padding=UDim.new(0,7)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Parent=content
    label(content,"CRÉATION DE LA VILLE • propriétaire",36)
    notice=label(content,"Les portes, interactions et personnages sont protégés.",57)
    notice.TextColor3=Color3.fromRGB(197,244,240)
    selectionLabel=label(content,"Aucun objet sélectionné.",65)
    modeLabel=label(content,"Sélection désactivée",30)
    line(content,{{"SÉLECTION : ON/OFF",function()
        active=not active
        dragging=false
        modeLabel.Text=if active then "Sélection active • clic / toucher / R2" else "Sélection désactivée"
    end}},44)
    label(content,"Déplacer : glisse l’objet sélectionné ou utilise les flèches (0,5 stud)",48)
    line(content,{{"← X",function()selectedAction("move",{-0.5,0,0}) end},{"X →",function()selectedAction("move",{0.5,0,0}) end},{"↑ Z",function()selectedAction("move",{0,0,-0.5}) end},{"↓ Z",function()selectedAction("move",{0,0,0.5}) end}},42)
    line(content,{{"+ HAUT",function()selectedAction("move",{0,0.5,0}) end},{"− BAS",function()selectedAction("move",{0,-0.5,0}) end}},42)
    label(content,"Rotation (Y)",24)
    line(content,{{"↶ −15°",function()selectedAction("rotate",-15) end},{"+15° ↷",function()selectedAction("rotate",15) end}},42)
    label(content,"Taille (largeur / hauteur / profondeur)",26)
    line(content,{{"X−",function()selectedAction("resize",{-0.5,0,0}) end},{"X+",function()selectedAction("resize",{0.5,0,0}) end},{"Y−",function()selectedAction("resize",{0,-0.5,0}) end},{"Y+",function()selectedAction("resize",{0,0.5,0}) end}},42)
    line(content,{{"Z−",function()selectedAction("resize",{0,0,-0.5}) end},{"Z+",function()selectedAction("resize",{0,0,0.5}) end}},42)
    label(content,"Palette sarcelle • hexadécimal #RRGGBB",28)
    colorInput=Instance.new("TextBox")
    colorInput.Size=UDim2.new(1,-16,0,39)
    colorInput.BackgroundColor3=Color3.fromRGB(33,72,75)
    colorInput.TextColor3=Color3.fromRGB(241,250,246)
    colorInput.Font=Typography.body()
    colorInput.TextSize=15
    colorInput.ClearTextOnFocus=false
    colorInput.Text=HEX
    colorInput.Parent=content
    corner(colorInput,7)
    line(content,{{"APPLIQUER COULEUR",applyHex}},42)
    materialsLabel=label(content,"Matière : choisir une pièce",32)
    line(content,{{"◀ MATIÈRE",function()onMaterial(-1) end},{"MATIÈRE ▶",function()onMaterial(1) end}},42)
    label(content,"Effacer masque la pièce et retire ses collisions. Restaurer revient à l’état généré.",44)
    line(content,{{"EFFACER",function()selectedAction("delete") end},{"RESTAURER",function()selectedAction("restore") end}},42)
    line(content,{{"RETROUVER UNE PIÈCE MASQUÉE",function()
        local result=request("lastHidden")
        if result and result.selection then
            selection=result.selection
            highlight.Adornee=selection.part
            refresh()
        end
    end}},42)
    line(content,{{"ANNULER",function()selectedAction("undo") end},{"RÉTABLIR",function()selectedAction("redo") end}},42)
    label(content,"Sauvegarde automatique : DataStore dans une Place publiée avec API autorisée. Sinon, retouches temporaires.",66)
    highlight=Instance.new("Highlight")
    highlight.Name="Sélection de construction"
    highlight.FillColor=Color3.fromRGB(197,244,240)
    highlight.FillTransparency=0.78
    highlight.OutlineColor=Color3.fromRGB(30,104,100)
    highlight.OutlineTransparency=0
    highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent=Workspace.CurrentCamera or ui
    Menu.register("build","CRÉATION • Éditer la ville",nil,menuPanel)
    menuPanel:GetPropertyChangedSignal("Visible"):Connect(function()
        if not menuPanel.Visible then
            active=false;dragging=false
            modeLabel.Text="Sélection désactivée"
        else
            local status=request("status")
            if status then
                notice.Text=if status.persistent then "Sauvegarde persistante active • "..tostring(status.changed).." retouches" else (status.warning or "Modifications temporaires")
            end
        end
    end)
    UserInputService.InputBegan:Connect(function(input,processed)
        if not active or not menuPanel.Visible or processed then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            onPick(UserInputService:GetMouseLocation())
        elseif input.KeyCode==Enum.KeyCode.ButtonR2 then
            local cam=Workspace.CurrentCamera
            if cam then onPick(cam.ViewportSize/2) end
        elseif input.UserInputType==Enum.UserInputType.Touch then
            onPick(Vector2.new(input.Position.X,input.Position.Y))
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            onDrag(UserInputService:GetMouseLocation())
        elseif input.UserInputType==Enum.UserInputType.Touch then
            onDrag(Vector2.new(input.Position.X,input.Position.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false;dragPrevious=nil
        end
    end)
end
return Client
