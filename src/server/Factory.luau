--!strict
-- Primitives natives. Aucune ressource Toolbox et aucun asset payant.
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

function Factory.sign(parent, name, position, yaw, text, width, height)
    local rotation = CFrame.Angles(0, math.rad(yaw or 0), 0)
    local board = Factory.part(parent, name, Vector3.new(width or 15, height or 3.4, 0.35), CFrame.new(position) * rotation, Color3.fromRGB(18, 62, 60), Enum.Material.Metal)
    board.CanCollide = false
    local sg = Instance.new("SurfaceGui")
    sg.Name = "ReadableSign"
    sg.Face = Enum.NormalId.Front
    sg.CanvasSize = Vector2.new(900, 200)
    sg.PixelsPerStud = 42
    sg.LightInfluence = 0
    sg.Parent = board
    local txt = Instance.new("TextLabel")
    txt.Name = "Text"
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.fromScale(1, 1)
    txt.Text = text
    txt.TextScaled = true
    txt.TextWrapped = true
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = Color3.fromRGB(237, 253, 252)
    txt.Parent = sg
    return board
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
