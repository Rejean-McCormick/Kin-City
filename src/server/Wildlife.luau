--!strict
-- Oiseaux procéduraux en vol, environnement vivant sans modèles tiers.
local TweenService=game:GetService("TweenService")
local F=require(script.Parent.Factory)
local Presence=require(script.Parent.ViewerPresenceV21)
local Wildlife={}
local sky={Color3.fromRGB(245,233,198),Color3.fromRGB(65,85,94),Color3.fromRGB(175,182,181)}
function Wildlife.make(city)
    local folder=F.folder(city,"Oiseaux et vie naturelle")
    for n=1,14 do
        local bird=Instance.new("Model")
        bird.Name="Oiseau "..n
        bird:SetAttribute("KinBirdIndex",n)
        bird.Parent=folder
        local root=F.part(bird,"Pivot",Vector3.new(.4,.4,.4),CFrame.new(),sky[(n-1)%#sky+1])
        root.Transparency=1;root.CanCollide=false
        bird.PrimaryPart=root
        local body=F.part(bird,"Corps",Vector3.new(1,0.45,2),CFrame.new(),sky[(n-1)%#sky+1])
        body.Shape=Enum.PartType.Ball;body.CanCollide=false
        for _,s in ipairs({-1,1}) do
            local wing=F.part(bird,s<0 and "Aile gauche" or "Aile droite",Vector3.new(2.6,0.18,0.9),CFrame.new(s*1.4,0,0),sky[(n-1)%#sky+1])
            wing.CanCollide=false
        end
        local a=n*2.399963
        local radius=100+(n%4)*25
        bird:PivotTo(CFrame.new(math.cos(a)*radius,36+(n%3)*12,math.sin(a)*radius))
    end
    return folder
end
function Wildlife.start(world)
    local city=world:FindFirstChild("Ville")
    local birds=city and city:FindFirstChild("Oiseaux et vie naturelle")
    if not birds then return end
    for _,m in ipairs(birds:GetChildren()) do
        local n=m:GetAttribute("KinBirdIndex")
        if n then
            task.spawn(function()
                local radius=100+(n%4)*25
                local angle=n*2.399963
                local altitude=36+(n%3)*12
                local wave=0
                while m.Parent and world.Parent do
                    if not Presence.near(m:GetPivot().Position,255) then
                        task.wait(3)
                        continue
                    end
                    local nextAngle=angle+0.43
                    local target=CFrame.new(math.cos(nextAngle)*radius,altitude,math.sin(nextAngle)*radius)*CFrame.Angles(0,-nextAngle+math.pi/2,0)
                    local current=Instance.new("CFrameValue")
                    current.Value=m:GetPivot()
                    local last=0
                    local connection=current.Changed:Connect(function(cf)
                        if not m.Parent then return end
                        if os.clock()-last<0.12 then return end
                        last=os.clock()
                        m:PivotTo(cf)
                        wave+=0.65
                        for _,s in ipairs({-1,1}) do
                            local wing=m:FindFirstChild(s<0 and "Aile gauche" or "Aile droite")
                            if wing then wing.CFrame=cf*CFrame.new(s*1.4,0,0)*CFrame.Angles(0,0,s*math.sin(wave)*0.45) end
                        end
                    end)
                    TweenService:Create(current,TweenInfo.new(6+n%4,Enum.EasingStyle.Linear),{Value=target}):Play()
                    task.wait(6+n%4)
                    connection:Disconnect()
                    if m.Parent then m:PivotTo(target) end
                    current:Destroy()
                    angle=nextAngle
                end
            end)
        end
    end
end
return Wildlife
