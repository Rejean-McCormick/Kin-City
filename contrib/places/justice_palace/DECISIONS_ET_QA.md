# B05 — Décisions architecturales et qualification

## Décisions créatives

**KORUM = une agora civique, pas un palais judiciaire intimidant.** Le visiteur arrive dans un hall dégagé, comprend immédiatement où aller, consulte librement des ressources et découvre des espaces de parole et de médiation.

Les bandes bronze rappellent l'identité ethiKos (`#A97C4F`), sans recolorer les surfaces structurantes existantes. Les rosettes géométriques et frises prennent leurs proportions de l'Art déco, mais restent volontairement sobres pour un service civique. La base sarcelle (`#1E6864`) maintient l'unité de Kin City. Les accents servent l'orientation sans que la couleur soit le seul repère.

### Parcours à préserver

- **Entrée** : ville → `justice_palace.lobby.spawn` → hall. Axe central sans nouveau mobilier collidable; sortie `justice_palace.exit.door` demeure accessible.
- **Consultation** : hall → galerie → `hall.terminal_01`; le terminal d'origine reste en place et ne doit pas prétendre connecter un service juridique externe.
- **Délibération** : hall → chambre de délibération, mobilier existant inchangé.
- **Témoignages** : galerie → passage `justice_palace.gallery_to_west` → aile ouest, intimité des murs sans obstruction.
- **Médiation** : chambre → passage `justice_palace.chamber_to_east` → aile est, équilibre des deux parcours.
- **Atrium** : deux passages arrière vers `justice_palace.rear_atrium`; les escaliers et l'ascenseur restent ceux du générateur commun, jamais remplacés par B05.

### Placement et couleurs

Les décorations de `scene_plan.json` sont situées à hauteur de mur pour ne pas créer de nouvelles barrières physiques. Les éléments natifs ont tous `CanCollide=false`, `CanTouch=false`, `CanQuery=false`, `CastShadow=false`, aucun son et aucune source PointLight. Le plan possède des zones protégées au voisinage des portes, du terminal, des six salles et de l'atrium.

**Attention aux corps existants :** les murs, enseignes, verrières, escaliers et luminaires du générateur peuvent recouvrir un ajout malgré une coordonnée valide. Ce n'est vérifiable que par Studio et QA visuelle. Les 24 ajouts **n'ont pas été rendus dans Roblox** dans cette passe.

## Budget de prévisualisation (Parts natifs)

| Profil | Features visibles | Parts estimés | MeshParts supplémentaires | Lumières dynamiques supplémentaires |
|---|---:|---:|---:|---:|
| LITE | 6 | 18 | 0 | 0 |
| STANDARD | 12 | 36 | 0 | 0 |
| SHOWCASE | 24 | 72 | 0 | 0 |

Toutes les variantes partagent la même liste de 24 features. LITE ne charge que les 6 features essentielles; STANDARD ajoute 6 détails; SHOWCASE ajoute 12 détails supplémentaires. La structure native déjà construite est exclue de ce budget.

## Checklist de test Studio (non exécutée)

- [ ] Copier les modules B05 dans une copie **locale** non publiée autorisée; appeler builder via B09.
- [ ] Profil LITE : exactement 6 modèles et 18 Parts; deuxième appel identique ne double pas le décor.
- [ ] STANDARD : 12 modèles et 36 Parts; SHOWCASE : 24 modèles et 72 Parts.
- [ ] Aucun impact sur `justice_palace.lobby.spawn` et `justice_palace.exit.door`.
- [ ] Prompts d'interaction `hall.terminal_01` intact; aucun nouveau Prompt B05.
- [ ] Tous les franchissements `lobby.gallery`, `lobby.chamber`, `gallery_to_west`, `chamber_to_east`, `gallery_to_rear`, `chamber_to_rear` disponibles.
- [ ] Marches, accès aux mezzanines et ascenseur libres; repérer les ornements partiellement masqués par murs/enseignes.
- [ ] Couleurs et contrastes visibles avec lumière jour/nuit, sur profil LITE, mobile et PC.
- [ ] Avant toute Place publiée : B09 vérifie PlaceId, version des contrats, backups, permissions des meshes et stratégie de retour.
- [ ] Aller-retour ville ↔ Agora Korum validé dans client Roblox publié (pas en simple Play Studio).

## Demande d'arbitrage B09

- **INT-05-001** : obtenir l'adaptateur qui consomme `SceneData.luau`/`PreviewBuilder.luau` et l'insère dans le bon modèle d'intérieur après sa construction, dans `LOCAL_UNIVERSE` ou `MULTI_PLACE` sans modifier les 16 portes.
- **INT-05-002** : déterminer si la contribution purement décorative relève du pool `interior`, `architecture` ou d'un budget distinct non-mesh; réserver le plafond réel mesuré.
- **INT-05-003** : résoudre la divergence entre les bounds initiaux 110 × 100 et l'emprise des extensions 210 × 150 avant de figer le collision audit.
- **INT-05-004** : confirmer le SHA de la baseline KC33 et les versions des interfaces B09 (archive précédente indisponible ici).

B05 ne soumet **aucun changement canonique**. Les corrections de `Spatial`, `Doors`, `WorldBuilder` et de façade sont des RFC distinctes à B09/B10.
