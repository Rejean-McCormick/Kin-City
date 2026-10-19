--!strict
-- Généré automatiquement : direction artistique sarcelle/cristal v17
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["brand"] = {
    ["champagne"] = "#E5D7AF",
    ["deep"] = "#123E3C",
    ["medium"] = "#327C78",
    ["opal"] = "#C5F4F0",
    ["pearl"] = "#EDFDFC",
    ["primary"] = "#1E6864",
    ["stone"] = "#CEE0DA",
    ["water"] = "#407E8E",
    ["wood"] = "#967858",
  },
  ["budgets"] = {
    ["hero_point_light_range"] = 18,
    ["hero_translucent_parts_per_spire"] = 1,
    ["max_crystal_spires_per_major_facade"] = 5,
    ["noncolliding_ornamentation"] = true,
  },
  ["crystal_renders"] = {
    ["glow"] = "petite inclusion Neon",
    ["hero"] = "verre translucide limité aux monuments",
    ["opaque"] = "Slate/SmoothPlastic avec facettes",
  },
  ["design_name"] = "Sarcelle minérale et cristal opalin",
  ["institution_accents"] = {
    ["campus"] = "#A7CFF3",
    ["city_hall"] = "#E5D7AF",
    ["ekoh_tower"] = "#A2EDD2",
    ["innovation_lab"] = "#83DDD8",
    ["justice_palace"] = "#E3CCB0",
    ["library"] = "#E6C99F",
    ["museum"] = "#F1BCCA",
    ["orgo_center"] = "#B8D2ED",
  },
  ["notes"] = {
    "La palette prime sur les anciennes couleurs globales mais conserve une accentuation unique par institution.",
    "Les objets interactifs conservent leurs IDs, CanCollide et capacités; seuls des ornements sont ajoutés.",
    "Ne pas transformer chaque part en verre transparent, le rendu mobile souffrirait de la surimpression.",
  },
  ["schema_version"] = "kincity.crystal/1.0",
}
