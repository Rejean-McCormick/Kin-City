--!strict
-- Animation locale des présentoirs de métiers. Le client n'écrit aucun état monde.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
function Runtime.start(world,reply)
    local displays={}
    local busy={}
    for _,thing in ipairs(world:GetDescendants()) do
        if thing:IsA("Model") then
            local id=thing:GetAttribute("KinCommerceDisplay")
            if type(id)=="string" and thing.PrimaryPart then displays[id]=thing end
        end
    end
    Prompts.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if host:GetAttribute("KinCommerceAction")~="display" then return end
        local id=host:GetAttribute("KinCommerceId")
        if type(id)~="string" or busy[id] then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp or (hrp.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"craft/"..id,0.8) then return end
        local model=displays[id]
        if not model or not model.Parent then return end
        busy[id]=true
        local initial=model:GetPivot()
        task.spawn(function()
            local ok,reason=pcall(function()
                local start=os.clock()
                while model.Parent and world.Parent do
                    local t=math.clamp((os.clock()-start)/3.0,0,1)
                    model:PivotTo(initial*CFrame.Angles(0,t*2*math.pi,0))
                    if t>=1 then break end
                    RunService.Heartbeat:Wait()
                end
                if model.Parent then model:PivotTo(initial) end
            end)
            if not ok then warn("Kin City présentoir",reason) end
            busy[id]=nil
        end)
        if player.Parent==Players then
            reply:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_SUCCESS",title="Atelier de la promenade",message="Le présentoir se met en mouvement.",notice="Animation locale · aucune opération kOA"})
        end
    end)
end
return Runtime
