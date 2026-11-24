--!strict
-- Vote esthétique serveur, par session et par joueur, en aucun cas un Smart Vote.
local PromptService=game:GetService("ProximityPromptService")
local R=require(script.Parent.DistrictLandmarks)
local ThemeRuntime={}
local function resultText(id,votes)
    local total=0
    for _,n in pairs(votes) do total+=n end
    local labels={cuivre="Cuivre & corail",nuit="Nuit opaline",prune="Prune & ivoire"}
    return "AMBIANCE : "..labels[id].."\n".."Cuivre "..votes.cuivre.." • Nuit "..votes.nuit.." • Prune "..votes.prune.."\n"..tostring(total).." votes visuels (session)"
end
function ThemeRuntime.start(world)
    if not world or world:GetAttribute("KinKreativeVotingStarted") then return end
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local sectors=city:FindFirstChild("Six secteurs • identités matérielles")
    local kreative=sectors and sectors:FindFirstChild("Kreative")
    if not kreative then return end
    world:SetAttribute("KinKreativeVotingStarted",true)
    local options={}
    local votes={}
    local voters={}
    for _,option in ipairs(R.themeOptions) do
        options[option.id]=option
        votes[option.id]=0
    end
    local active="cuivre"
    local function redraw()
        kreative:SetAttribute("KinKreativeActiveTheme",active)
        kreative:SetAttribute("KinKreativeVoteCount",votes.cuivre+votes.nuit+votes.prune)
        -- Votes affect the installation only. Sector highlights and ornamented signs keep their identity.
        local roots={kreative}
        for _,root in ipairs(roots) do
            for _,obj in ipairs(root:GetDescendants()) do
                if obj:IsA("BasePart") and obj:GetAttribute("KinKreativeCanvas")==true then
                    obj.Color=options[active].color
                elseif obj:IsA("PointLight") and obj:GetAttribute("KinKreativeLight")==true then
                    obj.Color=options[active].color
                elseif obj:IsA("BasePart") and obj:GetAttribute("KinKreativeResults")==true then
                    for _,face in ipairs(obj:GetChildren()) do
                        if face:IsA("SurfaceGui") then
                            local label=face:FindFirstChild("Text")
                            if label and label:IsA("TextLabel") then label.Text=resultText(active,votes) end
                        end
                    end
                    local trim=obj.Parent and obj.Parent:FindFirstChild(obj.Name.."Frame")
                    if trim then
                        for _,face in ipairs(trim:GetChildren()) do
                            if face:IsA("SurfaceGui") then
                                local label=face:FindFirstChild("Text")
                                if label and label:IsA("TextLabel") then label.Text=resultText(active,votes) end
                            end
                        end
                    end
                end
            end
        end
    end
    redraw()
    -- Le serveur fait autorité; une invite peut être activée au clavier, tactile ou manette.
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt:IsDescendantOf(kreative) or not player or not player:IsA("Player") then return end
        local base=prompt.Parent
        if not base or not base:IsA("BasePart") then return end
        local id=base:GetAttribute("KinKreativeThemeId")
        if not id or not options[id] or not prompt.Enabled then return end
        local character=player.Character
        local hum=character and character:FindFirstChildOfClass("Humanoid")
        local hrp=character and character:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not hrp or (hrp.Position-base.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if voters[player.UserId] then return end
        voters[player.UserId]=id
        votes[id]+=1
        if votes[id]>votes[active] then active=id end
        redraw()
    end)
end
return ThemeRuntime
