--!strict
-- Diagnostic factuel de construction pour la console Roblox Studio.
-- Aucun benchmark externe et aucun objectif FPS inventé.
local Diagnostics={}
function Diagnostics.capture(world,startClock,profile)
    local stats={parts=0,meshes=0,lights=0,prompts=0,materialFinishes=0,optionalDetails=0,seats=0}
    for _,instance in ipairs(world:GetDescendants()) do
        if instance:IsA("BasePart") then
            stats.parts+=1
            if instance:IsA("MeshPart") then stats.meshes+=1 end
            if instance:IsA("Seat") then stats.seats+=1 end
            if instance:GetAttribute("KinOptionalDetail")==true then stats.optionalDetails+=1 end
        elseif instance:IsA("PointLight") or instance:IsA("SpotLight") or instance:IsA("SurfaceLight") then
            stats.lights+=1
        elseif instance:IsA("ProximityPrompt") then
            stats.prompts+=1
        elseif instance:IsA("SurfaceAppearance") then
            stats.materialFinishes+=1
        end
    end
    local seconds=math.max(0,os.clock()-startClock)
    world:SetAttribute("KinBuildSeconds",math.floor(seconds*1000+0.5)/1000)
    world:SetAttribute("KinGeneratedParts",stats.parts)
    world:SetAttribute("KinGeneratedMeshes",stats.meshes)
    world:SetAttribute("KinGeneratedLights",stats.lights)
    world:SetAttribute("KinGeneratedPrompts",stats.prompts)
    world:SetAttribute("KinGeneratedMaterials",stats.materialFinishes)
    world:SetAttribute("KinGeneratedSeats",stats.seats)
    world:SetAttribute("KinGeneratedOptionalDetails",stats.optionalDetails)
    world:SetAttribute("KinBuildVisualProfile",profile)
    print(string.format("KIN CITY v25 build : %.2fs / %d parts / %d meshes / %d lumières / %d prompts / %d finitions PBR / %d détails facultatifs / profil %s",
        seconds,stats.parts,stats.meshes,stats.lights,stats.prompts,stats.materialFinishes,
        stats.optionalDetails,profile))
    return stats
end
return Diagnostics
