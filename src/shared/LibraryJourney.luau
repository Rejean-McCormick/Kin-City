--!strict
-- Généré automatiquement : parcours de lecture v28
-- NE PAS MODIFIER. Modifier les JSON dans catalog/ ou config/ puis exporter.
return {
  ["building_id"] = "konnected.library",
  ["ending"] = "Observer. Relier. Imaginer. La dernière page était blanche pour une raison : la suite se construit avec les autres. Le livre vous rend à la ville.",
  ["entry_door_id"] = "city.konnected.library.entry",
  ["exit_door_id"] = "library.exit",
  ["placement"] = {
    ["asset_id"] = "v28.library.story_book",
    ["clearance"] = "above existing furnishing top; noncolliding; no floor footprint",
    ["door_anchor_id"] = "library.exit.door",
    ["host_local_offset_studs"] = {
      0,
      0.34,
      0,
    },
    ["size_studs"] = {
      2.4,
      0.5,
      1.6,
    },
    ["yaw_degrees"] = 0,
  },
  ["start_anchor_id"] = "city.central.spawn",
  ["stations"] = {
    {
      ["furnishing_id"] = "library.prop.01",
      ["id"] = "welcome",
      ["text"] = "La dernière page a disparu. Trois fragments sont cachés parmi les lecteurs : observer, relier, imaginer. Retrouvez-les, puis revenez ici.",
      ["title"] = "Le livre sans dernière page",
      ["verb"] = "Ouvrir le livre",
    },
    {
      ["furnishing_id"] = "library.prop.05",
      ["id"] = "memory",
      ["text"] = "Une ville garde les traces de ceux qui l'habitent. Regardez ce qui existe avant de décider ce qui manque. Premier mot : OBSERVER.",
      ["title"] = "Observer — la mémoire",
      ["verb"] = "Lire le fragment",
    },
    {
      ["furnishing_id"] = "library.prop.06",
      ["id"] = "connection",
      ["text"] = "Deux lecteurs ouvrent le même livre et n'y trouvent pas la même histoire. Une rencontre donne un autre sens aux mots. Deuxième mot : RELIER.",
      ["title"] = "Relier — la rencontre",
      ["verb"] = "Lire le fragment",
    },
    {
      ["furnishing_id"] = "library.prop.03",
      ["id"] = "imagination",
      ["text"] = "Une page blanche n'est pas une erreur. C'est une invitation à essayer une idée qui n'existe pas encore. Troisième mot : IMAGINER.",
      ["title"] = "Imaginer — la possibilité",
      ["verb"] = "Lire le fragment",
    },
  },
  ["title"] = "Le livre sans dernière page",
  ["version"] = 1,
}
