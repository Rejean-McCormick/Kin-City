--!strict
-- Citoyens procéduraux : coiffures, teintes, vêtements, marche articulée et interactions.
-- Aucun avatar externe, aucune identité kOA et aucun ID asset obligatoire.
local TweenService=game:GetService("TweenService")
local F=require(script.Parent.Factory)
local Presence=require(script.Parent.ViewerPresenceV21)
local Citizens={}
local outfits={
    {"Bibliothécaire","Savoirs"},{"Guide du savoir","Accueil"},{"Étudiante","Université"},
    {"Chercheur","Innovation"},{"Artisane","Création"},{"Médiateur","Éthique"},
    {"Curatrice","Musée"},{"Citoyen","Place publique"},{"Architecte","Urbanisme"},
    {"Conseillère","Hôtel de ville"},{"Historien","Archives"},{"Technicienne","Orgo"},
}
local tones={Color3.fromRGB(239,196,155),Color3.fromRGB(194,137,97),Color3.fromRGB(105,69,55),Color3.fromRGB(158,106,77),Color3.fromRGB(224,173,136),Color3.fromRGB(85,56,49)}
local coats={Color3.fromRGB(53,127,130),Color3.fromRGB(115,82,142),Color3.fromRGB(173,99,72),Color3.fromRGB(76,132,103),Color3.fromRGB(182,140,75),Color3.fromRGB(69,104,153),Color3.fromRGB(175,105,116)}
local hairs={Color3.fromRGB(56,44,39),Color3.fromRGB(149,108,66),Color3.fromRGB(203,164,108),Color3.fromRGB(81,63,56),Color3.fromRGB(42,42,57)}
local dark=Color3.fromRGB(43,58,75)
local function makeCitizen(parent,index)
    local named=outfits[(index-1)%#outfits+1]
    local name=string.format("%s %02d",named[1],index)
    local model=Instance.new("Model")
    model.Name=name
    model:SetAttribute("KinCitizen",true)
    model:SetAttribute("CitizenIndex",index)
    model.Parent=parent
    local skin=tones[(index*7-1)%#tones+1]
    local coat=coats[(index*5-1)%#coats+1]
    local hair=hairs[(index*3-1)%#hairs+1]
    local root=F.part(model,"Root",Vector3.new(0.7,0.7,0.7),CFrame.new(),Color3.new(1,1,1))
    root.Transparency=1;root.CanCollide=false;root.CanTouch=false
    model.PrimaryPart=root
    local function make(name,size,offset,color,mat)
        local p=F.part(model,name,size,CFrame.new(offset),color,mat or Enum.Material.SmoothPlastic)
        p.CanCollide=false;p.CanTouch=false
        return p
    end
    make("Chemise",Vector3.new(2.35,2.9,1.3),Vector3.new(0,3.4,0),coat)
    make("Col",Vector3.new(1,0.5,1.4),Vector3.new(0,4.9,0),Color3.fromRGB(233,229,211))
    make("Cou",Vector3.new(0.75,0.5,0.72),Vector3.new(0,5.25,0),skin)
    local head=make("Visage",Vector3.new(1.65,1.85,1.56),Vector3.new(0,6.1,0),skin)
    head.Shape=Enum.PartType.Ball
    for _,s in ipairs({-1,1}) do
        local eye=make("Oeil",Vector3.new(0.19,0.16,0.09),Vector3.new(s*0.34,6.23,-0.77),dark)
        eye.Shape=Enum.PartType.Ball
    end
    if index%4==0 then
        make("Chapeau",Vector3.new(2.1,0.35,2.1),Vector3.new(0,7.18,0),hair)
        make("Calotte",Vector3.new(1.55,0.7,1.5),Vector3.new(0,7.6,0),hair)
    elseif index%3==0 then
        local cap=make("Coiffure longue",Vector3.new(1.8,1.2,1.6),Vector3.new(0,6.78,0.18),hair)
        cap.CanCollide=false
    else
        make("Coiffure",Vector3.new(1.75,0.65,1.63),Vector3.new(0,6.96,0),hair)
    end
    local arms={}
    local legs={}
    for _,s in ipairs({-1,1}) do
        local a=make(s<0 and "Bras gauche" or "Bras droit",Vector3.new(0.72,2.5,0.85),Vector3.new(s*1.58,3.43,0),skin)
        table.insert(arms,a)
        local b=make(s<0 and "Jambe gauche" or "Jambe droite",Vector3.new(0.95,2.5,1),Vector3.new(s*0.6,1.2,0),dark)
        table.insert(legs,b)
        make("Chaussure",Vector3.new(0.96,0.45,1.3),Vector3.new(s*0.6,0.25,-0.15),Color3.fromRGB(50,50,52))
    end
    if index%5==1 then
        make("Sac",Vector3.new(2.1,2,0.8),Vector3.new(0,3.1,1),Color3.fromRGB(123,84,62))
    elseif index%5==3 then
        make("Badge",Vector3.new(0.55,0.65,0.12),Vector3.new(-0.65,4,-0.75),Color3.fromRGB(246,204,116))
    end
    local marker=Instance.new("BillboardGui")
    marker.Name="Nom"
    marker.Size=UDim2.fromOffset(170,40)
    marker.StudsOffset=Vector3.new(0,2.0,0)
    marker.MaxDistance=70
    marker.AlwaysOnTop=false
    marker.Adornee=head
    marker.Parent=head
    local txt=Instance.new("TextLabel")
    txt.Size=UDim2.fromScale(1,1)
    txt.BackgroundColor3=Color3.fromRGB(26,48,56)
    txt.BackgroundTransparency=0.23
    txt.TextColor3=Color3.fromRGB(249,248,233)
    txt.TextSize=13
    txt.Font=Enum.Font.GothamMedium
    txt.Text=name
    txt.Parent=marker
    local rounded=Instance.new("UICorner");rounded.CornerRadius=UDim.new(0,9);rounded.Parent=txt
    head:SetAttribute("KinStubInteractionId",string.format("citizen.%03d.dialogue",index))
    head:SetAttribute("KinStubCapabilityId","future.citizen.dialogue")
    head:SetAttribute("KinStubTitle",named[1].." — "..named[2])
    F.prompt(head,"Parler",named[1])
    return model,arms,legs
end
local function orbit(index)
    -- Anneaux publics dégagés : les personnages ne traversent pas les façades.
    local radii={34,46,58,70}
    local r=radii[(index-1)%#radii+1]
    local angle=index*2.399963
    return r,angle
end
function Citizens.make(parent)
    local folder=F.folder(parent,"Citoyens")
    for i=1,36 do
        local model=makeCitizen(folder,i)
        local r,theta=orbit(i)
        model:PivotTo(CFrame.new(r*math.cos(theta),0.15,r*math.sin(theta)))
    end
    return folder
end
function Citizens.start(world)
    local city=world:FindFirstChild("Ville")
    local folder=city and city:FindFirstChild("Citoyens")
    if not folder then return end
    for _,m in ipairs(folder:GetChildren()) do
        local index=m:GetAttribute("CitizenIndex")
        if index and m:IsA("Model") then
            task.spawn(function()
                local radius,angle=orbit(index)
                local root=m.PrimaryPart
                local current=0
                local arms={m:FindFirstChild("Bras gauche"),m:FindFirstChild("Bras droit")}
                local legs={m:FindFirstChild("Jambe gauche"),m:FindFirstChild("Jambe droite")}
                while root and root.Parent and world.Parent do
                    if not Presence.near(m:GetPivot().Position,200) then
                        task.wait(3)
                        continue
                    end
                    local nextAngle=angle+0.28
                    local speed=7.2+(index%5)*0.65
                    local destination=CFrame.new(radius*math.cos(nextAngle),0.15,radius*math.sin(nextAngle))*CFrame.Angles(0,-nextAngle+math.pi/2,0)
                    local proxy=Instance.new("CFrameValue")
                    proxy.Value=m:GetPivot()
                    local last=0
                    local conn=proxy.Changed:Connect(function(cf)
                        if not m.Parent then return end
                        local now=os.clock()
                        if now-last<0.085 then return end
                        last=now
                        current+=0.37
                        m:PivotTo(cf)
                        local wave=math.sin(current)
                        for j,arm in ipairs(arms) do
                            if arm then arm.CFrame=cf*CFrame.new((j==1 and -1 or 1)*1.58,3.43,0)*CFrame.Angles(wave*(j==1 and 0.27 or -0.27),0,0) end
                        end
                        for j,leg in ipairs(legs) do
                            if leg then leg.CFrame=cf*CFrame.new((j==1 and -1 or 1)*0.6,1.2,0)*CFrame.Angles(wave*(j==1 and -0.22 or 0.22),0,0) end
                        end
                    end)
                    local tween=TweenService:Create(proxy,TweenInfo.new(speed,Enum.EasingStyle.Linear),{Value=destination})
                    tween:Play();tween.Completed:Wait()
                    conn:Disconnect()
                    if m.Parent then m:PivotTo(destination) end
                    proxy:Destroy()
                    angle=nextAngle
                    task.wait(index%3==0 and 0.8 or 0.1)
                end
            end)
        end
    end
end
return Citizens
