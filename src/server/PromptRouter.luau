--!strict
local ProximityPromptService=game:GetService("ProximityPromptService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Messages=require(Shared:WaitForChild("Messages"))
local RateLimiter=require(script.Parent.RateLimiter)
local PlayerTravel=require(script.Parent.PlayerTravel)
local PromptRouter={}

function PromptRouter.start(state,reply)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local record=state.prompts[prompt]
        -- Les citoyens R15 arrivent après la construction : leurs prompts
        -- restent reconnus sans les copier dans le registre statique initial.
        if not record then
            local dynamicHost=prompt.Parent
            if dynamicHost and dynamicHost:IsA("BasePart") and dynamicHost:GetAttribute("KinStubInteractionId") then
                record={kind="ambient",data={
                    interaction_id=dynamicHost:GetAttribute("KinStubInteractionId"),
                    capability_id=dynamicHost:GetAttribute("KinStubCapabilityId") or "future.local",
                    title=dynamicHost:GetAttribute("KinStubTitle") or "Kin City"
                }}
            end
        end
        if not record or not prompt.Enabled or not prompt:IsDescendantOf(state.world) then return end
        if not player or not player:IsA("Player") then return end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp then return end
        local base=prompt.Parent
        if not base or not base:IsA("BasePart") then return end
        if (base.Position-hrp.Position).Magnitude > prompt.MaxActivationDistance+3 then return end
        if record.kind=="door" then
            PlayerTravel.tryDoor(player,record.data,state)
        elseif record.kind=="shuttle" then
            PlayerTravel.tryShuttle(player,record.data)
        elseif record.kind=="lift" then
            PlayerTravel.tryLift(player,record.data)
        elseif record.kind=="vista" then
            local data=record.data
            if typeof(data.camera_position)~="Vector3" or typeof(data.look_at)~="Vector3" then return end
            if not RateLimiter.allowed(player,"vista/"..tostring(data.vista_id),0.8) then return end
            reply:FireClient(player,{
                kind="scenic.view.v1",vista_id=data.vista_id,
                title=data.title or "Panorama de Kin City",
                camera_position=data.camera_position,look_at=data.look_at
            })
        elseif record.kind=="ambient" then
            local data=record.data
            if not RateLimiter.allowed(player,"ambient/"..data.interaction_id,0.8) then return end
            reply:FireClient(player,{
                kind="interaction.reply.v1",status="COMING_SOON",
                interaction_id=data.interaction_id,capability_id=data.capability_id,
                title=data.title,message="Fonctionnalité à venir",
                notice="Ce pavillon sera relié aux services de Kin City ultérieurement."
            })
        elseif record.kind=="interaction" then
            local data=record.data
            if not RateLimiter.allowed(player,"interaction/"..data.interaction_id,0.75) then return end
            if data.provider_mode~="stub" then return end
            reply:FireClient(player,{
                kind="interaction.reply.v1",
                status="COMING_SOON",
                interaction_id=data.interaction_id,
                capability_id=data.capability_id,
                title=Messages[data.display_title_key] or "Kin City",
                message=Messages[data.display_message_key] or "Fonctionnalité à venir",
                notice=Messages["ui.no_operation"] or "Aucune opération n’a été effectuée."
            })
        end
    end)
end
return PromptRouter
