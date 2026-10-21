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

local function estimateLines(text:string, width:number): number
    local length=#text
    if string.find(text,"\n",1,true) then
        local _,count=string.gsub(text,"\n","")
        return math.clamp(count+1,1,4)
    end
    local capacity=math.max(8, math.floor(width*1.45))
    return math.clamp(math.ceil(length/capacity),1,4)
end

function Factory.sign(parent, name, position, yaw, text, width, height)
    local signText = tostring(text or "")
    local boardWidth = width or 15
    local requestedHeight = height or 3.4
    local lines = estimateLines(signText, boardWidth)
    local boardHeight = math.max(requestedHeight + 0.85, requestedHeight + math.max(0, lines-1)*0.7, math.min(boardWidth * 0.27, requestedHeight + 1.55))
    local rotation = CFrame.Angles(0, math.rad(yaw or 0), 0)
    local forward = rotation.LookVector
    local frontOffset = 0.46
    local board = Factory.part(parent, name, Vector3.new(boardWidth, boardHeight, 0.34), CFrame.new(position + forward * frontOffset) * rotation, Color3.fromRGB(16, 58, 56), Enum.Material.Metal)
    board.CanCollide = false
    board.CanTouch = false
    board.CanQuery = false
    board:SetAttribute("KinSignTypography", "garamond-with-bodoni-fallback")
    board:SetAttribute("KinSignRequestedHeight", requestedHeight)
    board:SetAttribute("KinSignEstimatedLines", lines)

    local trim = Factory.part(parent, name.."Frame", Vector3.new(boardWidth + 0.48, boardHeight + 0.46, 0.10), CFrame.new(position + forward * 0.09) * rotation, Color3.fromRGB(232, 240, 232), Enum.Material.SmoothPlastic)
    trim.CanCollide = false
    trim.CanTouch = false
    trim.CanQuery = false
    trim.CastShadow = false
    trim.Transparency = 0.06

    local sg = Instance.new("SurfaceGui")
    sg.Name = "ReadableSign"
    sg.Face = Enum.NormalId.Front
    sg.CanvasSize = Vector2.new(math.max(1024, math.floor(boardWidth * 64)), math.max(360, math.floor(boardHeight * 118)))
    sg.PixelsPerStud = 60
    sg.LightInfluence = 0
    sg.ClipsDescendants = true
    sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    sg.Parent = board

    local txt = Instance.new("TextLabel")
    txt.Name = "Text"
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.fromScale(1, 1)
    txt.Position = UDim2.fromOffset(0,0)
    txt.Text = signText
    txt.TextScaled = true
    txt.TextWrapped = true
    txt.Font = Typography.display()
    txt.TextColor3 = Color3.fromRGB(239, 253, 252)
    txt.TextStrokeColor3 = Color3.fromRGB(8, 32, 34)
    txt.TextStrokeTransparency = 0.84
    txt.TextXAlignment = Enum.TextXAlignment.Center
    txt.TextYAlignment = Enum.TextYAlignment.Center
    txt.RichText = false
    txt.LineHeight = 1.0
    txt.Parent = sg

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 26)
    padding.PaddingRight = UDim.new(0, 26)
    padding.PaddingTop = UDim.new(0, if lines>=3 then 20 else 16)
    padding.PaddingBottom = UDim.new(0, if lines>=3 then 20 else 16)
    padding.Parent = txt

    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MinTextSize = 18
    constraint.MaxTextSize = 94
    constraint.Parent = txt

    local shadow = Instance.new("UIStroke")
    shadow.Thickness = 1.35
    shadow.Color = Color3.fromRGB(12, 40, 40)
    shadow.Transparency = 0.74
    shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    shadow.Parent = txt
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
