--!strict
-- Définition commune de l'archipel : villes, bateau et guide lisent la même géographie.
-- Aucun compte, contenu métier ni lien extérieur.
local themes={
    {slug="gardens",title="Île des Jardins suspendus",subtitle="Promenade botanique et serre",color={110,187,141},symbol="botanical"},
    {slug="arts",title="Île des Arts vivants",subtitle="Scène ouverte et installations",color={219,146,154},symbol="arts"},
    {slug="energy",title="Île des Énergies",subtitle="Mouvement et phénomènes",color={236,190,103},symbol="energy"},
    {slug="stars",title="Île de l'Observatoire",subtitle="Ciel et mouvement des astres",color={133,177,219},symbol="stars"},
    {slug="archives",title="Île des Histoires",subtitle="Livres, mémoire et récits",color={184,163,214},symbol="archives"},
    {slug="commons",title="Île des Rencontres",subtitle="Place publique et hospitalité",color={129,208,199},symbol="commons"},
}
local result={}
for i,theme in ipairs(themes) do
    -- Alignement exact sur les quais publics impairs (1, 3, 5, 7, 9, 11).
    local angle=(i-1)*math.pi/3+math.pi/24
    table.insert(result,{
        id="kin.island."..theme.slug,
        kind=theme.slug,
        title=theme.title,
        caption=theme.subtitle,
        symbol=theme.symbol,
        color=theme.color,
        angle=angle,
        radius=700,
        center_studs={700*math.cos(angle),0,700*math.sin(angle)},
        -- Les bateaux suivent la rive droite des passerelles, hors des garde-corps.
        ferry_lane_offset=24,
        ferry_start_radius=540,
        ferry_end_radius=690,
    })
end
return result
