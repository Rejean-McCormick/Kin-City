--!strict
-- Actions locales serveur pour les six places. Aucun point, vote ou service kOA.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
function Runtime.start(world,reply)
    local lamps={}
    local art={}
    local enabled={}
    local running={}
    for _,child in ipairs(world:GetDescendants()) do
        if child:IsA("BasePart") then
            local id=child:GetAttribute("KinCivicLamp")
            if type(id)=="string" then
                lamps[id]=lamps[id] or {}
                table.insert(lamps[id],child)
            end
        elseif child:IsA("Model") then
            local id=child:GetAttribute("KinCivicArt")
            if type(id)=="string" then art[id]=child end
        end
    end
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local kind=host:GetAttribute("KinCivicAction")
        local id=host:GetAttribute("KinCivicStageId")
        if (kind~="lights" and kind~="mobile") or type(id)~="string" then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp or (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"civic/"..id.."/"..kind,0.7) then return end
        local text=""
        if kind=="lights" then
            local on=enabled[id]==false
            enabled[id]=on
            for _,lamp in ipairs(lamps[id] or {}) do
                if lamp.Parent then
                    local light=lamp:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=on end
                    lamp.Transparency=if on then 0 else 0.72
                end
            end
            text=if on then "L'agora s'illumine." else "Les lumières de l'agora sont éteintes."
        else
            local model=art[id]
            if not model or not model.Parent or running[id] then return end
            running[id]=true
            local start=model:GetPivot()
            task.spawn(function()
                local ok,reason=pcall(function()
                    local begin=os.clock()
                    while model.Parent and world.Parent do
                        local t=math.clamp((os.clock()-begin)/2.1,0,1)
                        local eased=t*t*(3-2*t)
                        model:PivotTo(start*CFrame.Angles(0,eased*2*math.pi,0))
                        if t>=1 then break end
                        RunService.Heartbeat:Wait()
                    end
                end)
                if not ok then warn("Kin City sculpture de quartier",reason) end
                running[id]=nil
            end)
            text="Le mobile de la place s'anime."
        end
        if player.Parent==Players then
            reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",
                title="Agora de quartier",message=text,
                notice="Activité physique locale · aucune opération kOA"})
        end
    end)
end
return Runtime
