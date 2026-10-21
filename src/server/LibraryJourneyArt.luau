--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Réutilise les enveloppes du mobilier canonique; aucun obstacle au sol ajouté.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Journey=require(Shared.LibraryJourney)
local Art={}
local TEAL=Color3.fromRGB(30,104,100)
local OPAL=Color3.fromRGB(197,244,240)
function Art.make(model,placeKey)
    if placeKey~="library" then return end
    local stations={}
    for _,station in ipairs(Journey.stations) do stations[station.furnishing_id]=station end
    for _,furnishing in ipairs(model:GetChildren()) do
        local station=stations[furnishing:GetAttribute("KinFurnishingId")]
        if not station or not furnishing:IsA("Model") or not furnishing.PrimaryPart then continue end
        local host=furnishing.PrimaryPart
        if host:FindFirstChild("LibraryStoryPrompt") then continue end
        host:SetAttribute("KinLibraryStoryAction",station.id)
        local prompt=Instance.new("ProximityPrompt")
        prompt.Name="LibraryStoryPrompt";prompt.ActionText=station.verb;prompt.ObjectText=station.title
        prompt.HoldDuration=0.25;prompt.MaxActivationDistance=11;prompt.RequiresLineOfSight=false
        prompt.KeyboardKeyCode=Enum.KeyCode.E;prompt.GamepadKeyCode=Enum.KeyCode.ButtonX;prompt.Parent=host
        local base=host.CFrame*CFrame.new(0,host.Size.Y/2+0.34,0)
        local book=Instance.new("Model");book.Name="Livre de récit — "..station.id;book.Parent=furnishing
        book:SetAttribute("KinAssetId",Journey.placement.asset_id)
        for _,side in ipairs({-1,1}) do
            local page=Instance.new("Part");page.Name="Pages ouvertes"
            page.Size=Vector3.new(1.16,0.12,1.55)
            page.CFrame=base*CFrame.new(side*0.58,0,0)*CFrame.Angles(0,0,math.rad(side*9))
            page.Color=OPAL;page.Material=Enum.Material.SmoothPlastic;page.Anchored=true
            page.CanCollide=false;page.CanTouch=false;page.CanQuery=false;page.Parent=book
            local cover=page:Clone();cover.Name="Reliure sarcelle";cover.Size=Vector3.new(1.20,0.08,1.60)
            cover.CFrame=page.CFrame*CFrame.new(0,-0.1,0);cover.Color=TEAL;cover.Parent=book
        end
        local label=Instance.new("BillboardGui");label.Name="LibraryStoryLabel"
        label.Adornee=host;label.StudsOffsetWorldSpace=Vector3.new(0,host.Size.Y/2+1.8,0)
        label.Size=UDim2.fromOffset(220,42);label.MaxDistance=36;label.AlwaysOnTop=false;label.Parent=book
        local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1
        text.Text=station.title;text.TextColor3=OPAL;text.TextStrokeTransparency=0.35
        text.Font=Typography.body();text.TextSize=15;text.TextWrapped=true;text.Parent=label
    end
end
return Art
