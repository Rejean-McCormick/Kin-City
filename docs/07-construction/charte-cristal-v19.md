# Charte de construction v19 — Le minéral habité

La ville est une **architecture habitée**, pas un empilement de cristaux. La signature de Kin City est construite avec le sarcelle **`#1E6864`**, le sarcelle profond **`#123E3C`**, le cristal opalin **`#C5F4F0`** et le champagne minéral **`#E5D7AF`**. Les quartiers peuvent avoir des couleurs secondaires, mais l'architecture partagée demeure identifiable.

## Trois échelles de langage architectural

**Monuments :** portiques, frontons, emblèmes, rosaces, colonnes et grands cristaux héroïques; huit formes uniques selon l'institution.

**Vie quotidienne :** portes et vitrines encadrées, liserés, clefs opalines discrètes; répétition contrôlée sur les habitations, marchés et ateliers. La masse bâtie reste chaleureuse et habitable.

**Promenades :** filets de guidage incrustés au sol, lisibles de jour et de nuit sans constituer des obstacles.

## Budget de complexité

Les nouveaux ornements sont `Anchored`, `CanCollide=false`, `CanTouch=false`, `CanQuery=false`, `CastShadow=false`. Les détails mineurs sont étiquetés `KinOptionalDetail` pour le niveau de détail client. Pas de nouvelles lumières en continu, pas de verre multicouche ajouté par la v19, aucune logique physique par image.

La qualité artistique n'est pas une excuse pour casser la circulation : dans les intérieurs, conserver les panneaux des salles et les franchissements physiques; à l'extérieur, conserver les portes, les allées et les bornes, quelles que soient les variantes visuelles.

Les constructions v19 sont procédurales, basées sur des primitives Roblox. Elles ne sont **pas** des meshes finaux de production ni des captures Roblox vérifiées. Les matériaux complexes et les textures artisanales viendront sans remplacer les identifiants de gameplay.
