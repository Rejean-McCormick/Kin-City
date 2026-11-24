--!strict
-- Six orientations approuvées : 12 / 2 / 4 / 6 / 8 / 10 heures.
-- Vue du dessus : -Z = 12 h et +X = 3 h. #1E6864 unit les quartiers.
-- Ces labels sont des espaces dans KinCity et NON six autorités métier.
local Districts={}
Districts.base=Color3.fromRGB(30,104,100) -- #1E6864
Districts.light=Color3.fromRGB(137,233,217)
Districts.opal=Color3.fromRGB(197,244,240)
Districts.gold=Color3.fromRGB(205,164,101)
Districts.sections={
    {key="keenkonnect",name="keenKonnect",hour=12,x=0,z=-1,
        color=Color3.fromRGB(208,191,134),lightColor=Color3.fromRGB(30,104,100),pale=Color3.fromRGB(207,228,222),
        dark=Color3.fromRGB(41,67,69),secondary=Color3.fromRGB(154,170,173),
        material="metal",theme="Concevoir • partager",
        system="Konnaxion"},
    {key="ethikos",name="ethiKos",hour=2,x=0.866025403784,z=-0.5,
        color=Color3.fromRGB(169,124,79),lightColor=Color3.fromRGB(222,169,103),pale=Color3.fromRGB(223,194,150),
        dark=Color3.fromRGB(70,52,35),secondary=Color3.fromRGB(139,96,59),
        material="wood",theme="Débattre • consulter",
        system="Konnaxion"},
    {key="kreative",name="Kreative",hour=4,x=0.866025403784,z=0.5,
        color=Color3.fromRGB(203,128,157),lightColor=Color3.fromRGB(203,128,157),pale=Color3.fromRGB(237,198,212),
        dark=Color3.fromRGB(76,48,64),secondary=Color3.fromRGB(200,150,119),
        material="creative",theme="Imaginer • exposer",
        system="Konnaxion"},
    {key="uckk",name="Université King Klown",hour=6,x=0,z=1,
        color=Color3.fromRGB(117,142,166),lightColor=Color3.fromRGB(159,183,211),pale=Color3.fromRGB(211,224,231),
        dark=Color3.fromRGB(35,51,66),secondary=Color3.fromRGB(153,170,182),
        material="academy",theme="Apprendre • transmettre",
        system="UCKK"},
    {key="ekole",name="Ekole",hour=8,x=-0.866025403784,z=0.5,
        color=Color3.fromRGB(229,234,231),lightColor=Color3.fromRGB(231,238,235),pale=Color3.fromRGB(250,251,249),
        dark=Color3.fromRGB(26,31,32),secondary=Color3.fromRGB(94,104,104),
        material="monochrome",theme="Lire • relier",
        system="Ekole"},
    {key="konnected",name="KonnectED",hour=10,x=-0.866025403784,z=-0.5,
        color=Color3.fromRGB(188,103,76),lightColor=Color3.fromRGB(215,172,109),pale=Color3.fromRGB(230,211,172),
        dark=Color3.fromRGB(18,23,26),secondary=Color3.fromRGB(166,134,82),
        material="black_marble",theme="Comprendre • progresser",
        system="Konnaxion"},
}
-- Same approved accent for identifying light details; no second sector palette.
for _,section in ipairs(Districts.sections) do section.lightColor=section.color end
function Districts.nearestAxis(x:number,z:number)
    local length=math.sqrt(x*x+z*z)
    if length<0.01 then return nil end
    local best=nil
    local score=-2
    for _,section in ipairs(Districts.sections) do
        local dot=(section.x*x+section.z*z)/length
        if dot>score then best=section;score=dot end
    end
    return best
end
function Districts.byKey(key:string)
    for _,section in ipairs(Districts.sections) do
        if section.key==key then return section end
    end
    return nil
end
return Districts
