from pathlib import Path
root=Path(__file__).resolve().parents[1]
p=root/'src/server/ResidentialResidents.luau'
s=p.read_text(encoding='utf8')
start=s.index('local function wander(model,hum,world,quarter,index)')
stop=s.index('function Residents.start(world)',start)
new='''-- Les habitants n'errent plus au hasard : ils suivent une petite routine publique.
-- Points contrôlés dans la cour dégagée, sans navigation vers les maisons closes.
-- Les rôles et les activités visibles sont purement narratifs et locaux.
local tasks={"Promenade", "Jardin partagé", "Lecture", "Rencontre", "Observation", "Repos"}
local function activityBadge(model,role)
    local head=model:FindFirstChild("Head")
    if not head then return nil end
    local gui=Instance.new("BillboardGui")
    gui.Name="Routine quotidienne"
    gui.Size=UDim2.fromOffset(176,43)
    gui.StudsOffset=Vector3.new(0,2.8,0)
    gui.AlwaysOnTop=false;gui.MaxDistance=55;gui.Adornee=head;gui.Parent=head
    local text=Instance.new("TextLabel")
    text.Size=UDim2.fromScale(1,1);text.TextWrapped=true
    text.BackgroundColor3=Color3.fromRGB(34,66,65)
    text.BackgroundTransparency=0.24
    text.TextColor3=Color3.fromRGB(245,236,204)
    text.Font=Enum.Font.GothamMedium;text.TextSize=12
    text.Text=role; text.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,7);corner.Parent=text
    return text
end
local function wander(model,hum,world,quarter,index)
    local center=Vector3.new(quarter.center_studs[1],2.8,quarter.center_studs[3])
    local radius=13.3
    local phase=index*1.87
    local role=model.Name
    local badge=activityBadge(model,role)
    model:PivotTo(CFrame.new(center+Vector3.new(math.cos(phase)*radius,0,math.sin(phase)*radius)))
    task.spawn(function()
        local round=0
        while model.Parent and world.Parent and hum.Health>0 do
            round+=1
            phase+=math.pi/3
            local goal=center+Vector3.new(math.cos(phase)*radius,0,math.sin(phase)*radius)
            local clock=game:GetService("Lighting").ClockTime
            local work=if clock<8 then "Ouverture de quartier" elseif clock>=19 then "Promenade du soir" else tasks[((index+round-2)%#tasks)+1]
            model:SetAttribute("KinResidentActivity",work)
            if badge then badge.Text=work.." · "..role end
            hum:MoveTo(goal)
            local finished=false
            local connection=hum.MoveToFinished:Connect(function() finished=true end)
            local deadline=os.clock()+9
            while not finished and os.clock()<deadline and model.Parent and world.Parent and hum.Health>0 do
                task.wait(0.25)
            end
            connection:Disconnect()
            if model.Parent then
                -- Pause devant une place ou un jardin : le lieu n'est pas traversé au pas de course.
                local pause=if round%4==0 then 6.0 else 1.8+(index%3)
                task.wait(pause)
            end
        end
    end)
end
'''
p.write_text(s[:start]+new+s[stop:],encoding='utf8')
print('Enhanced 12 R15 inhabitants with timed activities, signboards and pauses')
