--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Guide et carte client; exploite le plan partagé, sans RemoteEvent ni réseau externe.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
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
local names={city="Kin City",campus="Université KonnectED",city_hall="Hôtel de ville",ekoh_tower="Tour EkoH",innovation_lab="Parc de l'Innovation",justice_palace="Palais de justice",library="Grande Bibliothèque",museum="Musée Kreative",orgo_center="Centre Orgo"}
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
    label(head,"KIN CITY",UDim2.fromOffset(12,3),UDim2.fromOffset(235,25),true)
    local area=label(head,"Explore la ville • M pour la carte",UDim2.fromOffset(12,29),UDim2.fromOffset(258,22),false)
    local toggle=Instance.new("TextButton");toggle.Name="Carte";toggle.Text="CARTE  [M]";toggle.Font=Typography.body();toggle.TextSize=13;toggle.TextColor3=Color3.fromRGB(245,245,241)
    toggle.Size=UDim2.fromOffset(114,38);toggle.Position=UDim2.new(1,-128,0,82);toggle.BackgroundColor3=Color3.fromRGB(40,94,99);toggle.Parent=gui;round(toggle,10)
    local window=Instance.new("Frame");window.Name="Carte";window.Size=UDim2.fromOffset(308,388);window.AnchorPoint=Vector2.new(1,0);window.Position=UDim2.new(1,-14,0,130);window.BackgroundColor3=Color3.fromRGB(23,43,50);window.BackgroundTransparency=0.03;window.Visible=false;window.Parent=gui;round(window,14)
    label(window,"PLAN DE KIN CITY",UDim2.fromOffset(15,10),UDim2.fromOffset(275,26),true)
    local square=Instance.new("Frame");square.Name="Mini-map";square.Size=UDim2.fromOffset(274,274);square.Position=UDim2.fromOffset(17,45);square.BackgroundColor3=Color3.fromRGB(72,108,90);square.BorderSizePixel=0;square.Parent=window;round(square,136)
    local outline=Instance.new("UIStroke");outline.Color=Color3.fromRGB(180,169,127);outline.Thickness=2;outline.Parent=square
    local center=point(square,0,0,Color3.fromRGB(225,201,137));center.Size=UDim2.fromOffset(13,13)
    for _,structure in ipairs(Plan.structures) do
        local dot=point(square,structure.center_studs[1],structure.center_studs[3],Color3.fromRGB(225,230,212))
        dot.Size=UDim2.fromOffset(10,10)
    end
    -- Huit belvédères côtiers et leurs longues-vues réellement utilisables.
    for n=1,8 do
        local a=n*math.pi/4
        local marker=point(square,math.cos(a)*467,math.sin(a)*467,Color3.fromRGB(239,183,103))
        marker.Size=UDim2.fromOffset(8,8)
    end
    -- Les nouveaux quais, ateliers et jardins existent physiquement dans la scène.
    -- Les marqueurs représentent des zones, pas la promesse qu'un kiosque précis a été placé.
    for i=1,12 do
        local a=(i-1)*2*math.pi/12+math.pi/24
        local marker=point(square,math.cos(a)*490,math.sin(a)*490,Color3.fromRGB(127,210,224))
        marker.Size=UDim2.fromOffset(6,6)
    end
    -- Pavillons scientifiques du circuit : même registre partagé que le générateur.
    for _,p in ipairs(PublicDestinations) do
        local marker=point(square,p.center_studs[1],p.center_studs[3],Color3.fromRGB(182,225,157))
        marker.Size=UDim2.fromOffset(8,8)
    end
    for _,item in ipairs(IslandDestinations) do
        local marker=point(square,item.center_studs[1],item.center_studs[3],Color3.fromRGB(246,207,133))
        marker.Size=UDim2.fromOffset(10,10)
    end
    for _,quarter in ipairs(ResidentialDestinations) do
        local dot=point(square,quarter.center_studs[1],quarter.center_studs[3],Color3.fromRGB(245,203,163))
        dot.Size=UDim2.fromOffset(9,9)
    end
    for _,public in ipairs(CommunityDestinations) do
        local dot=point(square,public.center_studs[1],public.center_studs[3],if public.kind=="market" then Color3.fromRGB(248,171,99) else Color3.fromRGB(165,220,195))
        dot.Size=UDim2.fromOffset(8,8)
    end
    for _,line in ipairs(BoulevardRoutes) do
        local a=point(square,line.start_studs[1],line.start_studs[3],Color3.fromRGB(247,229,167))
        a.Size=UDim2.fromOffset(6,6)
        local b=point(square,line.finish_studs[1],line.finish_studs[3],Color3.fromRGB(247,229,167))
        b.Size=UDim2.fromOffset(6,6)
    end
    for _,marina in ipairs(MarinaDestinations) do
        local dot=point(square,marina.center_studs[1],marina.center_studs[3],Color3.fromRGB(118,243,236))
        dot.Size=UDim2.fromOffset(11,11)
    end
    -- Nouveaux lieux physiquement générés en v12.
    local station=IntermodalNetwork.hub.center_studs
    local stationDot=point(square,station[1],station[3],Color3.fromRGB(238,220,134))
    stationDot.Size=UDim2.fromOffset(14,14)
    for _,stage in ipairs(CivicDestinations) do
        local venue=point(square,stage.center_studs[1],stage.center_studs[3],Color3.fromRGB(223,140,179))
        venue.Size=UDim2.fromOffset(9,9)
    end
    for _,shop in ipairs(PromenadeCommerce) do
        local dot=point(square,shop.center_studs[1],shop.center_studs[3],Color3.fromRGB(237,193,131))
        dot.Size=UDim2.fromOffset(5,5)
    end
    for _,shop in ipairs(UrbanV14Destinations.arcades) do
        local dot=point(square,shop.center_studs[1],shop.center_studs[3],Color3.fromRGB(248,212,139))
        dot.Size=UDim2.fromOffset(7,7)
    end
    for _,workshop in ipairs(UrbanV14Destinations.workshops) do
        local dot=point(square,workshop.center_studs[1],workshop.center_studs[3],Color3.fromRGB(141,235,206))
        dot.Size=UDim2.fromOffset(8,8)
    end
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
