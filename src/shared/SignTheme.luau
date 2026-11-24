--!strict
-- Kin City v31.8 : moteur procédural du kit SVG/P​NG sans logo.
-- Aucun AssetId requis : les quatre ornements sont reconstruits en UI natives.
local Districts=require(script.Parent.HexagonalDistricts)
local SignTheme={}
SignTheme.version="31.9.6"
SignTheme.layout={
    pixelsPerStud=38,
    maxDistance=190,
    minWidth=5,
    maxWidth=42,
    minHeight=1.6,
    maxHeight=7.2,
}
SignTheme.palettes={
    neutral={background=Color3.fromRGB(14,55,52),accent=Color3.fromRGB(30,104,100),border=Color3.fromRGB(196,226,216),text=Color3.fromRGB(244,250,245)},
    keenkonnect={background=Color3.fromRGB(30,62,62),accent=Color3.fromRGB(30,104,100),border=Color3.fromRGB(188,204,202),text=Color3.fromRGB(244,250,245)},
    ethikos={background=Color3.fromRGB(62,43,30),accent=Color3.fromRGB(30,104,100),border=Color3.fromRGB(216,178,128),text=Color3.fromRGB(249,242,222)},
    kreative={background=Color3.fromRGB(67,38,56),accent=Color3.fromRGB(203,128,157),border=Color3.fromRGB(236,197,205),text=Color3.fromRGB(255,245,240)},
    uckk={background=Color3.fromRGB(32,47,63),accent=Color3.fromRGB(137,158,181),border=Color3.fromRGB(222,216,190),text=Color3.fromRGB(252,249,236)},
    ekole={background=Color3.fromRGB(25,29,30),accent=Color3.fromRGB(30,104,100),border=Color3.fromRGB(234,238,235),text=Color3.fromRGB(247,248,246)},
    konnected={background=Color3.fromRGB(20,24,27),accent=Color3.fromRGB(30,104,100),border=Color3.fromRGB(206,168,102),text=Color3.fromRGB(251,242,218)},
}
-- Les accents et orientations proviennent de la même autorité que la ville.
for _,section in ipairs(Districts.sections) do
    SignTheme.palettes[section.key].accent=section.color
    SignTheme.palettes[section.key].border=section.color
end
local AXES=Districts.sections
function SignTheme.infer(parent:Instance,position:Vector3?,forced:string?):string
    if forced and SignTheme.palettes[forced] then return forced end
    local node:Instance?=parent
    -- Halo EkoH : ne jamais réutiliser la palette du secteur traversé.
    while node do
        if node:GetAttribute("KinHaloOwner")~=nil then return "neutral" end
        node=node.Parent
    end
    node=parent
    while node do
        local key=node:GetAttribute("KinSection") or node:GetAttribute("KinSector")
        if type(key)=="string" and SignTheme.palettes[key] then return key end
        node=node.Parent
    end
    if position then
        local r=math.sqrt(position.X*position.X+position.Z*position.Z)
        if r>90 and r<595 then
            -- Directions du plan approuvé : ce sont des coordonnées internes,
            -- jamais des « heures » à afficher sur une enseigne.
            local best="neutral"
            local maxDot=-1
            for _,s in ipairs(AXES) do
                local dot=(position.X*s.x+position.Z*s.z)/r
                if dot>maxDot then maxDot=dot;best=s.key end
            end
            return best
        end
    end
    return "neutral"
end
function SignTheme.palette(section:string)
    return SignTheme.palettes[section] or SignTheme.palettes.neutral
end
return SignTheme
