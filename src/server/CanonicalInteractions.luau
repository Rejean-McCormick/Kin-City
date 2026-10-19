--!strict
-- Liaison canonique : le prompt est attaché à l'objet physique existant.
-- Utilisée après génération complète et après régénération de chaque intérieur.
local Factory=require(script.Parent.Factory)
local Binder={}

function Binder.bindPlace(interior, placeKey, interactions, records)
    assert(interior and interior:IsA("Model"),"Intérieur physique manquant: "..tostring(placeKey))
    local byAnchor={}
    for _,model in ipairs(interior:GetDescendants()) do
        if model:IsA("Model") and model:GetAttribute("KinFurnishingId")
            and model:GetAttribute("KinPlaceKey")==placeKey then
            local anchor=model:GetAttribute("KinAnchorId")
            if anchor and model.PrimaryPart then
                assert(not byAnchor[anchor],"Mobilier d'ancre en double: "..placeKey.."/"..anchor)
                byAnchor[anchor]=model.PrimaryPart
            end
        end
    end
    local count=0
    for _,interaction in ipairs(interactions) do
        if interaction.place_key==placeKey then
            local prop=byAnchor[interaction.anchor_id]
            assert(prop,"Mobilier interactif introuvable: "..interaction.interaction_id)
            prop:SetAttribute("KinInteractionId",interaction.interaction_id)
            prop:SetAttribute("KinCapabilityId",interaction.capability_id)
            prop:SetAttribute("KinAnchorId",interaction.anchor_id)
            local prompt=prop:FindFirstChild("KinCityPrompt")
            if not prompt or not prompt:IsA("ProximityPrompt") then
                prompt=Factory.prompt(prop,"Consulter","Kin City")
            end
            if records then records[prompt]={kind="interaction",data=interaction} end
            count+=1
        end
    end
    return count
end
return Binder
