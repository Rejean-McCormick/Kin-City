--!strict
-- Kin City v31.9.6 : signaletique native renforcee sans AssetId. Une implantation pour toutes les pancartes.
-- Les SVG / PNG d'assets/signage sont les sources de design ; Roblox les dessine en Frames.
-- Aucun faux logo : la zone logo est reservee UNIQUEMENT pour les enseignes principales.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Typography=require(Shared:WaitForChild("Typography"))
local Themes=require(Shared:WaitForChild("SignTheme"))
local SignEngine={}

local function block(parent:Instance,name:string,size:UDim2,position:UDim2,color:Color3,alpha:number?,radius:number?)
    local b=Instance.new("Frame")
    b.Name=name
    b.Size=size
    b.Position=position
    b.BackgroundColor3=color
    b.BackgroundTransparency=alpha or 0
    b.BorderSizePixel=0
    b.ZIndex=2
    b:SetAttribute("KinSignColorRole","border")
    b.Parent=parent
    if radius then
        local c=Instance.new("UICorner")
        c.CornerRadius=UDim.new(0,radius)
        c.Parent=b
    end
    return b
end
local function ink(parent:Instance,name:string,color:Color3,thickness:number,transparency:number)
    local s=Instance.new("UIStroke")
    s.Name=name
    s.Color=color
    s.Thickness=thickness
    s.Transparency=transparency
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    s:SetAttribute("KinSignColorRole","border")
    s.Parent=parent
    return s
end
local function newPart(parent:Instance,name:string,size:Vector3,cf:CFrame,color:Color3)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    p.Color=color
    p.Material=Enum.Material.Metal
    p.Anchored=true
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    p.Parent=parent
    return p
end
local function countLines(label:string,width:number)
    local n=select(2,string.gsub(label,"\n",""))
    local chars=math.ceil(#label/math.max(12,math.floor(width*2.2)))
    return math.clamp(math.max(n+1,chars),1,3)
end
local function findText(owner:BasePart,guiName:string)
    local gui=owner:FindFirstChild(guiName)
    if gui and gui:IsA("SurfaceGui") then
        local txt=gui:FindFirstChild("Text")
        if txt and txt:IsA("TextLabel") then return txt.Text end
    end
    return nil
end
local function styleFace(owner:BasePart,side:Enum.NormalId,message:string,style,section:string,frontLogoSpace:boolean)
    local guiName=if side==Enum.NormalId.Back then "ReadableSignBack" else "ReadableSign"
    local old=owner:FindFirstChild(guiName)
    if old and old:IsA("SurfaceGui") then old:Destroy() end
    local gui=Instance.new("SurfaceGui")
    gui.Name=guiName
    gui.Face=side
    gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud=Themes.layout.pixelsPerStud
    gui.MaxDistance=Themes.layout.maxDistance
    gui.LightInfluence=0.12
    gui.ClipsDescendants=true
    gui.AlwaysOnTop=false
    gui:SetAttribute("KinSignTheme",section)
    gui.Parent=owner

    -- 1 : couche de fond et double filet du SVG kin_sign_frame_9slice.
    local background=block(gui,"SignBackground",UDim2.fromScale(1,1),UDim2.fromScale(0,0),style.background,0)
    background.ZIndex=1
    background:SetAttribute("KinSignColorRole","background")
    ink(background,"OuterRule",style.border,1.8,0.04)
    local inset=block(gui,"InsetBorder",UDim2.new(1,-18,1,-18),UDim2.fromOffset(9,9),style.background,1)
    inset.ZIndex=2
    ink(inset,"InnerRule",style.border,0.8,0.48)

    -- 2 : UN motif d'equerre, compose quatre fois sans fichier ni duplication de texture.
    local cornerSize=math.clamp(math.floor(owner.Size.Y*Themes.layout.pixelsPerStud*0.13),11,23)
    local margin=13
    for _,right in ipairs({false,true}) do
        for _,bottom in ipairs({false,true}) do
            local baseX=if right then UDim2.new(1,-margin-cornerSize,0,0) else UDim2.fromOffset(margin,0)
            local baseY=if bottom then UDim2.new(0,0,1,-margin-cornerSize) else UDim2.fromOffset(margin,0)
            local x=baseX.X
            local y=baseY.Y
            local id=(if right then "R" else "L")..(if bottom then "B" else "T")
            local hpos=UDim2.new(x.Scale,x.Offset,y.Scale,y.Offset+(if bottom then cornerSize-2 else 0))
            local vpos=UDim2.new(x.Scale,x.Offset+(if right then cornerSize-2 else 0),y.Scale,y.Offset)
            local h=block(gui,"CornerRailH_"..id,UDim2.fromOffset(cornerSize,2),hpos,style.accent)
            local v=block(gui,"CornerRailV_"..id,UDim2.fromOffset(2,cornerSize),vpos,style.accent)
            h:SetAttribute("KinSignColorRole","accent")
            v:SetAttribute("KinSignColorRole","accent")
            local dot=block(gui,"CornerDot_"..id,UDim2.fromOffset(3,3),
                UDim2.new(x.Scale,x.Offset+(if right then cornerSize-4 else 3),y.Scale,y.Offset+(if bottom then cornerSize-4 else 3)),style.border,0,2)
            dot:SetAttribute("KinSignColorRole","border")
        end
    end

    -- 2b : ornements de linteau et de soubassement, mieux perceptibles depuis la rue.
    -- Ils ne couvrent jamais la zone de lecture. Palette propre au quartier.
    local high=block(gui,"LinteauOrnemental",UDim2.new(1,-92,0,4),UDim2.fromOffset(46,5),style.border,0.02)
    high.ZIndex=3
    high:SetAttribute("KinSignColorRole","border")
    local low=block(gui,"FiletSoubassement",UDim2.new(1,-92,0,3),UDim2.new(0,46,1,-9),style.accent,0.02)
    low.ZIndex=3
    low:SetAttribute("KinSignColorRole","accent")
    local center=block(gui,"CabochonCentral",UDim2.fromOffset(13,13),UDim2.new(0.5,-6,0,0),style.border,0,6)
    center.ZIndex=3
    center:SetAttribute("KinSignColorRole","border")
    local gem=block(gui,"EclatSarcelle",UDim2.fromOffset(5,5),UDim2.new(0.5,-2,0,4),style.accent,0,2)
    gem.ZIndex=4
    gem:SetAttribute("KinSignColorRole","accent")

    -- 3 : separateur vertical seulement si un VRAI logo est fourni a gauche, jamais un ersatz.
    local separate=frontLogoSpace and side==Enum.NormalId.Front and owner.Size.X>=12
    if separate then
        local rule=block(gui,"LogoSeparator",UDim2.new(0,2,0.66,0),UDim2.fromScale(0.235,0.17),style.accent)
        rule:SetAttribute("KinSignColorRole","accent")
        for _,y in ipairs({0.155,0.835}) do
            local dot=block(gui,"LogoSeparatorDot",UDim2.fromOffset(4,4),UDim2.new(0.235,-1,y,0),style.border,0,2)
            dot:SetAttribute("KinSignColorRole","border")
        end
    end

    -- 4 : filet discret pour panneaux a deux lignes, sans chevron ni sigle.
    local multiline=string.find(message,"\n",1,true)~=nil and owner.Size.Y>=3.2
    if multiline then
        local dividerWidth=if separate then 0.56 else 0.72
        local rule=block(gui,"DividerRule",UDim2.new(dividerWidth,0,0,2),
            UDim2.fromScale(if separate then 0.31 else 0.14,0.86),style.border,0.38)
        rule:SetAttribute("KinSignColorRole","border")
    end

    -- Le TextLabel reste un enfant direct de SurfaceGui (compatibilite anciens scripts).
    local t=Instance.new("TextLabel")
    t.Name="Text"
    t.Text=message
    t.BackgroundTransparency=1
    t.Size=if separate then UDim2.new(0.68,0,0.77,0) else UDim2.new(0.88,0,0.77,0)
    t.Position=if separate then UDim2.fromScale(0.28,0.11) else UDim2.fromScale(0.06,0.11)
    t.Font=Typography.display()
    t.TextColor3=style.text
    t.TextStrokeColor3=Color3.fromRGB(0,15,18)
    t.TextStrokeTransparency=0.78
    t.TextXAlignment=Enum.TextXAlignment.Center
    t.TextYAlignment=Enum.TextYAlignment.Center
    t.TextScaled=true
    t.TextWrapped=true
    t.RichText=false
    t.ZIndex=4
    t.Parent=gui
    local limit=Instance.new("UITextSizeConstraint")
    limit.Name="TextLimit"
    limit.MinTextSize=11
    limit.MaxTextSize=if owner.Size.X<12 then 32 else 54
    limit.Parent=t
    return gui
end

function SignEngine.decorateExisting(board:BasePart,options:any?)
    local opts=options or {}
    local back=board.Parent and board.Parent:FindFirstChild(board.Name.."Frame")
    if back and not back:IsA("BasePart") then back=nil end
    local frontMessage=opts.text or findText(board,"ReadableSign")
    if not frontMessage then return false end
    local backMessage=opts.backText or (back and findText(back,"ReadableSignBack")) or frontMessage
    local section=Themes.infer(board.Parent or board,board.Position,opts.section or board:GetAttribute("KinSignTheme"))
    local style=Themes.palette(section)
    local hasLogo=opts.logoAtLeft==true or board:GetAttribute("KinSignRole")=="building-primary"
    board.Color=style.background
    styleFace(board,Enum.NormalId.Front,frontMessage,style,section,hasLogo)
    if back then
        back.Color=style.background
        styleFace(back,Enum.NormalId.Back,backMessage,style,section,false)
        back:SetAttribute("KinSignReversePanel",true)
    end
    board:SetAttribute("KinSignEngineVersion",Themes.version)
    board:SetAttribute("KinSignTheme",section)
    board:SetAttribute("KinSignLogoReserved",hasLogo)
    board:SetAttribute("KinSignReadableBothSides",back~=nil)
    return true
end

function SignEngine.create(parent:Instance,name:string,position:Vector3,yaw:number?,message:any,width:number?,requestedHeight:number?,options:any?)
    local opts=options or {}
    local label=tostring(message or "")
    local w=math.clamp(width or 15,Themes.layout.minWidth,Themes.layout.maxWidth)
    local requested=math.clamp(requestedHeight or 3.4,Themes.layout.minHeight,Themes.layout.maxHeight)
    local lines=countLines(label,w)
    local h=math.clamp(math.max(requested+0.5,requested+math.max(0,lines-1)*0.55),Themes.layout.minHeight,Themes.layout.maxHeight)
    local rotation=CFrame.Angles(0,math.rad(yaw or 0),0)
    local forward=rotation.LookVector
    local section=Themes.infer(parent,position,opts.section)
    local color=Themes.palette(section).background
    local front=newPart(parent,name,Vector3.new(w,h,0.26),CFrame.new(position+forward*0.4)*rotation,color)
    local back=nil
    if opts.doubleSided~=false then
        back=newPart(parent,name.."Frame",Vector3.new(w+0.28,h+0.26,0.1),CFrame.new(position+forward*0.07)*rotation,color)
    end
    front:SetAttribute("KinSignRole",opts.role)
    front:SetAttribute("KinSignRequestedHeight",requested)
    front:SetAttribute("KinSignEstimatedLines",lines)
    front:SetAttribute("KinSignTypography","garamond-with-bodoni-fallback")
    SignEngine.decorateExisting(front,{text=label,backText=opts.backText or label,section=section,
        logoAtLeft=(opts.logoAtLeft==true or opts.emblem==true or opts.emblem=="front")})
    return front
end

-- Mutation EVENEMENTIELLE pour le vote Kreative. Aucun loop par frame.
function SignEngine.recolor(board:BasePart,accent:Color3)
    local owners={board}
    local back=board.Parent and board.Parent:FindFirstChild(board.Name.."Frame")
    if back and back:IsA("BasePart") then table.insert(owners,back) end
    for _,owner in ipairs(owners) do
        for _,obj in ipairs(owner:GetDescendants()) do
            local role=obj:GetAttribute("KinSignColorRole")
            if role=="accent" then
                if obj:IsA("Frame") then obj.BackgroundColor3=accent end
            elseif role=="border" then
                if obj:IsA("Frame") then obj.BackgroundColor3=accent end
                if obj:IsA("UIStroke") then obj.Color=accent end
            end
        end
    end
end
function SignEngine.stats(root:Instance)
    local result={signs=0,faces=0,images=0,uniqueAssets=0}
    local unique={}
    for _,obj in ipairs(root:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("KinSignEngineVersion")~=nil then result.signs+=1 end
        if obj:IsA("SurfaceGui") and (obj.Name=="ReadableSign" or obj.Name=="ReadableSignBack") then result.faces+=1 end
        if obj:IsA("ImageLabel") then
            result.images+=1
            if obj.Image~="" then unique[obj.Image]=true end
        end
    end
    for _ in pairs(unique) do result.uniqueAssets+=1 end
    return result
end
return SignEngine
