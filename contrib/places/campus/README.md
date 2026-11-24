# B04 · Université King Klown — Campus UCKK

**Place :** `campus` · **Building ID historique :** `konnected.university` · **Palette :** UCKK `#758EA6`, sarcelle commun `#1E6864`.

Cette contribution se limite au périmètre B04. Aucune source canonique de KC33 ou B09 n'est modifiée. Elle propose une **couche Art déco universitaire construite à partir de pièces natives Roblox** : panneaux de salles lisibles, filets de laiton, repères de secteur et motifs géométriques. Aucun nouveau MeshId, aucun achat supplémentaire, aucune API kOA inventée.

## Architecture et conditions d'utilisation

- `CampusDecor.luau` expose `CampusDecor.build(interiorModel, origin, profile)`. Les paramètres sont le modèle `Intérieur — campus`, `Spatial.origin('campus')` et un profil graphique parmi `LITE`, `STANDARD`, `SHOWCASE`.
- Le module refuse un modèle dont `KinPlaceKey` n'est pas exactement `campus`. Il ne crée rien hors de son dossier `B04_CampusDecor_KC34` dans le modèle campus. Une seconde exécution avec la même révision est idempotente.
- Tous les `Part` ajoutés sont `Anchored`, `CanCollide=false`, `CanQuery=false`, `CanTouch=false`, `CastShadow=false` ; aucun nouveau `ProximityPrompt` ni téléportation.
- La porte `campus.exit`, l'ancre `campus.exit.door`, le spawn `campus.lobby.spawn`, les six salles et l'interaction `hall.board_01` ne sont pas déplacés ni recréés.
- Les panneaux n'indiquent aucun cours validé ; les capacités pédagogiques externes demeurent `stub`.
- Les profils limitent le décor optionnel ; ils ne démontrent pas de gain FPS sans mesure Studio/mobile.

## Périmètre visuel

| Salle | Intention | Zone de décoration | Déplacement |
|---|---|---|---|
| `campus.lobby` | Accueil et identification UCKK | Mur d'entrée, latéralement à ±31 X | Couloir de sortie x≈0 préservé |
| `campus.gallery` | Salle de cours | Haut du mur arrière, x≈-39.5 | `hall.board_01` à (-27,18) préservé |
| `campus.chamber` | Laboratoire pédagogique | Mur arrière, x≈27 | Traversée chambre↔hall/atrium préservée |
| `campus.west_wing` | Recherche / atelier | Mur du fond à z≈31 | Aile ouest et portail intérieur libres |
| `campus.east_wing` | Exploration / hypothèses | Mur du fond à z≈31 | Aile est et portail intérieur libres |
| `campus.rear_atrium` | Exposition universitaire | Mur du fond à z≈103 | Sculpture planétaire et activités au milieu inchangées |

### Mesures à confirmer dans Roblox Studio

- Faces des panneaux selon les murs réellement construits, lisibilité des SurfaceGuis, éclairage et contrastes.
- Collision réelle du personnage, accès aux quatre passages `InteriorWings`, escaliers/ascenseurs et interactions présentes avant l'injection.
- Débit rendu mobile et mémoire aux trois profils ; rendre les nouveaux panneaux optionnels si coûteux.

## Important : aucun raccordement au runtime partagé

Les `recipe.json` de B09 ne sont pas encore lus par `WorldBuilder`; ce module B04 **n'est pas exécuté automatiquement**. Seule B09 pourra intégrer et empaqueter ce constructeur dans une version commune après RFC, puis vérifier la compatibilité des Places. Le script de prévisualisation fourni sert uniquement sur une copie locale Studio existante, sans publication.
