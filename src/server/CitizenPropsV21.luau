--!strict
-- Objets narratifs légers, soudés au rig natif R15 : aucune texture / API externe.
-- Ils n'affectent ni la navigation ni les collisions des habitants.
local Props={}
local teal=Color3.fromRGB(30,104,100)
local opal=Color3.fromRGB(197,244,240)
local gold=Color3.fromRGB(229,215,175)

local function accessory(parent:Model,hand:BasePart,label:string,size:Vector3,offset:CFrame,color:Color3,material:Enum.Material)
    local p=Instance.new("Part")
    p.Name=label
    p.Size=size
    p.CFrame=hand.CFrame*offset
    p.Anchored=false
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.Massless=true
    p.CastShadow=false
    p.Material=material
    p.Color=color
    p.Parent=parent
    local weld=Instance.new("WeldConstraint")
    weld.Part0=hand
    weld.Part1=p
    weld.Parent=p
    return p
end

function Props.attach(model:Model,role:string,index:number)
    local hand=model:FindFirstChild("RightHand")
    if not hand or not hand:IsA("BasePart") then return end
    -- Mini livre, carnet, outil ou prisme selon le métier.
    local kind=index%4
    if string.find(role,"Biblioth") or string.find(role,"Archiv") or kind==0 then
        accessory(model,hand,"Livre de voyage",Vector3.new(0.65,0.82,0.16),CFrame.new(0,-0.38,-0.28)*CFrame.Angles(0.22,0,0),teal,Enum.Material.SmoothPlastic)
        accessory(model,hand,"Tranche opaline",Vector3.new(0.53,0.72,0.05),CFrame.new(0,-0.38,-0.39)*CFrame.Angles(0.22,0,0),opal,Enum.Material.SmoothPlastic)
    elseif string.find(role,"Jardin") or kind==1 then
        accessory(model,hand,"Outil botanique",Vector3.new(0.13,1.05,0.13),CFrame.new(0,-0.45,-0.15),gold,Enum.Material.Metal)
    elseif string.find(role,"Guide") or kind==2 then
        accessory(model,hand,"Carnet sarcelle",Vector3.new(0.54,0.75,0.12),CFrame.new(0,-0.36,-0.2),teal,Enum.Material.SmoothPlastic)
    else
        local prism=accessory(model,hand,"Prisme de recherche",Vector3.new(0.43,0.65,0.43),CFrame.new(0,-0.42,-0.2),opal,Enum.Material.SmoothPlastic)
        prism.Shape=Enum.PartType.Ball
    end
end
return Props
