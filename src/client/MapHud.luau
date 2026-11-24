--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Guide et carte client; exploite le plan partagé, sans RemoteEvent ni réseau externe.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local PublicDestinations=require(Shared:WaitForChild("PublicDestinations"))
local IslandDestinations=require(Shared:WaitForChild("IslandDestinations"))
local MarinaDestinations=require(Shared:WaitForChild("MarinaDestinations"))
local ResidentialDestinations=require(Shared:WaitForChild("ResidentialDestinations"))
local CommunityDestinations=require(Shared:WaitForChild("CommunityDestinations"))
local BoulevardRoutes=require(Shared:WaitForChild("BoulevardRoutes"))
local IntermodalNetwork=require(Shared:WaitForChild("IntermodalNetwork"))
local CivicDestinations=require(Shared:WaitForChild("CivicDestinations"))
local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))
local UrbanV14Destinations=require(Shared:WaitForChild("UrbanV14Destinations"))
local player=Players.LocalPlayer
local MapHud={}
local function label(parent,text,pos,size,bold)
    local t=Instance.new("TextLabel")
    t.BackgroundTransparency=1;t.Text=text;t.Size=size;t.Position=pos
    t.Font=bold and Typography.body() or Typography.body()
    t.TextSize=bold and 16 or 12;t.TextColor3=Color3.fromRGB(238,240,231)
    t.TextWrapped=true;t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=parent
    return t
end
local names={city="Kin City",campus="Université King Klown",city_hall="Accueil",ekoh_tower="Observatoire EkoH",innovation_lab="Atelier Konstruct",justice_palace="Agora Korum",library="Grande Bibliothèque",museum="Galerie Konservation",orgo_center="Maison Orgo"}
local function round(parent,radius)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,radius);c.Parent=parent
end
local scale=1050
local markers={}
local function point(parent,x,z,clr)
    local dot=Instance.new("Frame")
    dot.AnchorPoint=Vector2.new(0.5,0.5)
    dot.Size=UDim2.fromOffset(7,7)
    dot.Position=UDim2.fromScale(0.5+x/scale,0.5+z/scale)
    dot.BackgroundColor3=clr;dot.BorderSizePixel=0;dot.Parent=parent
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(1,0);corner.Parent=dot
    table.insert(markers,{dot=dot,x=x,z=z})
    return dot
end
function MapHud.start()
    local gui=Instance.new("ScreenGui");gui.Name="KinCityNavigation";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=false;gui.DisplayOrder=7;gui.Parent=player:WaitForChild("PlayerGui")
    local head=Instance.new("Frame");head.Name="Bannière";head.Size=UDim2.fromOffset(280,59);head.Position=UDim2.fromOffset(15,15);head.BackgroundColor3=Color3.fromRGB(30,54,63);head.BackgroundTransparency=0.10;head.Parent=gui
    round(head,10)
    label(head,"KOALI • KIN CITY",UDim2.fromOffset(12,3),UDim2.fromOffset(235,25),true)
    local area=label(head,"Explore la ville • M pour la carte",UDim2.fromOffset(12,29),UDim2.fromOffset(258,22),false)
    local toggle=Instance.new("TextButton");toggle.Name="Carte";toggle.Text="CARTE  [M]";toggle.Font=Typography.body();toggle.TextSize=13;toggle.TextColor3=Color3.fromRGB(245,245,241)
    toggle.Size=UDim2.fromOffset(114,38);toggle.Position=UDim2.new(1,-128,0,82);toggle.BackgroundColor3=Color3.fromRGB(40,94,99);toggle.Parent=gui;round(toggle,10)
    local window=Instance.new("Frame");window.Name="Carte";window.Size=UDim2.fromOffset(308,388);window.AnchorPoint=Vector2.new(1,0);window.Position=UDim2.new(1,-14,0,130);window.BackgroundColor3=Color3.fromRGB(23,43,50);window.BackgroundTransparency=0.03;window.Visible=false;window.Parent=gui;round(window,14)
    label(window,"PLAN • 6 AVENUES KOALI",UDim2.fromOffset(15,10),UDim2.fromOffset(275,26),true)
    local square=Instance.new("Frame");square.Name="Mini-map";square.Size=UDim2.fromOffset(274,274);square.Position=UDim2.fromOffset(17,45);square.BackgroundColor3=Color3.fromRGB(72,108,90);square.BorderSizePixel=0;square.Parent=window;round(square,136)
    local outline=Instance.new("UIStroke");outline.Color=Color3.fromRGB(180,169,127);outline.Thickness=2;outline.Parent=square
    local center=point(square,0,0,Color3.fromRGB(30,104,100));center.Size=UDim2.fromOffset(12,12)
    center.BackgroundTransparency=1
    -- Une miniature hexagonale du logo central, dessinée sans asset externe.
    for i=0,5 do
        local a=-math.pi/2+i*math.pi/3
        local b=a+math.pi/3
        local ax,ay=137+math.cos(a)*11,137+math.sin(a)*11
        local bx,by=137+math.cos(b)*11,137+math.sin(b)*11
        local line=Instance.new("Frame")
        line.Name="Arête du logo hexagonal"
        line.AnchorPoint=Vector2.new(0.5,0.5)
        line.Position=UDim2.fromOffset((ax+bx)/2,(ay+by)/2)
        line.Size=UDim2.fromOffset(math.sqrt((bx-ax)^2+(by-ay)^2),2.5)
        line.Rotation=math.deg(math.atan2(by-ay,bx-ax))
        line.BackgroundColor3=Districts.base
        line.BorderSizePixel=0
        line.Parent=square
    end
    -- Halo EkoH en sarcelle et 6 accents aux axes du nouvel hexagone.
    local halo=Instance.new("Frame")
    halo.Name="EkoH • halo de liaison"
    halo.AnchorPoint=Vector2.new(0.5,0.5)
    halo.Position=UDim2.fromScale(0.5,0.5)
    halo.Size=UDim2.fromOffset(110,110)
    halo.BackgroundTransparency=1
    halo.Parent=square
    local haloRound=Instance.new("UICorner")
    haloRound.CornerRadius=UDim.new(1,0)
    haloRound.Parent=halo
    local haloStroke=Instance.new("UIStroke")
    haloStroke.Color=Districts.base
    haloStroke.Thickness=2.4
    haloStroke.Parent=halo
    for _,section in ipairs(Districts.sections) do
        local marker=point(square,section.x*150,section.z*150,section.color)
        marker.Name="Secteur "..section.name
        marker.Size=UDim2.fromOffset(9,9)
    end
    for _,structure in ipairs(Plan.structures) do
        local dot=point(square,structure.center_studs[1],structure.center_studs[3],Color3.fromRGB(225,230,212))
        dot.Size=UDim2.fromOffset(10,10)
    end
    -- La carte ne montre plus les marchés, gares ou ateliers historiques
    -- désactivés. Seuls les six axes et les huit institutions demeurent.
    local playerDot=point(square,0,0,Color3.fromRGB(47,211,234))
    playerDot.Size=UDim2.fromOffset(11,11)
    local zoom=Instance.new("TextButton")
    zoom.Name="Échelle de carte";zoom.Size=UDim2.fromOffset(282,27)
    zoom.Position=UDim2.fromOffset(13,324)
    zoom.BackgroundColor3=Color3.fromRGB(53,107,109)
    zoom.TextColor3=Color3.fromRGB(241,238,216)
    zoom.Font=Typography.body();zoom.TextSize=12;zoom.Text="VILLE  ·  Voir l'archipel"
    zoom.Parent=window;round(zoom,7)
    zoom.Activated:Connect(function()
        scale=if scale==1050 then 1850 else 1050
        local diameter=274*2*211/scale
        halo.Size=UDim2.fromOffset(diameter,diameter)
        zoom.Text=if scale==1050 then "VILLE  ·  Voir l'archipel" else "ARCHIPEL  ·  Revenir à la ville"
        for _,item in ipairs(markers) do
            item.dot.Position=UDim2.fromScale(0.5+item.x/scale,0.5+item.z/scale)
        end
    end)
    label(window,"Menu Kin City  ·  M : carte  ·  N : lieux  ·  H : gare",UDim2.fromOffset(15,356),UDim2.fromOffset(286,21),false)
    local function flip()window.Visible=not window.Visible end
    toggle.Activated:Connect(flip)
    require(script.Parent.KinCityMenu).register("map","Carte [M]",toggle,window,flip)
    UIS.InputBegan:Connect(function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.M then flip() end
    end)
    local elapsed=0
    RunService.RenderStepped:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.25 then return end
        elapsed=0
        local key=player:GetAttribute("KinZone") or "city"
        area.Text=names[key] or "En exploration"
        local character=player.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if root and key=="city" then
            local position=root.Position
            playerDot.Visible=true
            playerDot.Position=UDim2.fromScale(math.clamp(0.5+position.X/scale,0,1),math.clamp(0.5+position.Z/scale,0,1))
        else
            playerDot.Visible=false
        end
    end)
end
return MapHud
