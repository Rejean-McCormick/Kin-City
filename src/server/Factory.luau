--!strict
-- Primitives natives. Aucune ressource Toolbox et aucun asset payant.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KinCityShared")
local Typography=require(Shared:WaitForChild("Typography"))
local Factory = {}

function Factory.part(parent, name, size, frame, color, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = frame
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = true
    part.CastShadow = true
    part.Parent = parent
    return part
end

function Factory.folder(parent, name)
    local f = Instance.new("Folder")
    f.Name = name
    f.Parent = parent
    return f
end

-- Une seule implantation de la signalétique : SignEngine, partagé par toutes les façades.
local SignEngine=require(script.Parent.SignEngine)
function Factory.sign(parent,name,position,yaw,text,width,height,options)
    return SignEngine.create(parent,name,position,yaw,text,width,height,options)
end

function Factory.light(parent, pos, brightness, range)
    local bulb = Factory.part(parent, "LightBulb", Vector3.new(0.6, 0.3, 0.6), CFrame.new(pos), Color3.fromRGB(255, 242, 199), Enum.Material.Neon)
    bulb.CanCollide = false
    local light = Instance.new("PointLight")
    light.Brightness = brightness or 1.3
    light.Range = range or 30
    light.Shadows = false
    light.Parent = bulb
    return bulb
end

function Factory.prompt(part, verb, subject)
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "KinCityPrompt"
    prompt.ActionText = verb
    prompt.ObjectText = subject
    prompt.MaxActivationDistance = 11
    prompt.RequiresLineOfSight = false
    prompt.HoldDuration = 0.1
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    prompt.Parent = part
    return prompt
end

function Factory.hex(colorHex)
    local clean = string.gsub(colorHex, "#", "")
    return Color3.fromRGB(tonumber(string.sub(clean,1,2),16) or 128,tonumber(string.sub(clean,3,4),16) or 128,tonumber(string.sub(clean,5,6),16) or 128)
end

return Factory
