# Kin City — Construction v23.0 : atelier de finition et atlas vivants

## Finalité

Une **grosse passe cumulative sur la ville existante**, pas de nouvelle expansion géographique : transformer des salles institutionnelles uniformes en espaces ayant un mobilier, une ambiance et une exposition visitable qui leur sont propres. Style officiel : **#1E6864 + cristal opalin #C5F4F0**, rehaussé de champagne minéral. Tous les services kOA restent en `WORLD_STUB`.

## Constructions ajoutées au jeu

| Système | Sources Luau | Comportement |
|---|---|---|
| Mobilier sculpté | `SculptedFurnitureV23.luau` | Compositions physiques d'archives, savoirs, sciences, justice, artisanat, arts, réseaux ou cité; nombre adapté au profil LITE/STANDARD/SHOWCASE; vraies banquettes Roblox dans la première salle. |
| Luminaires sur mesure | `CrystalLuminairesV23.luau` | Un luminaire de cristal et de métal par salle, remplaçant trois orbes de verre répétitifs; aucun PointLight supplémentaire. |
| Atlas d'exposition | `LivingExhibitsV23.luau` | **8 stations réelles × 4 chapitres**, avec lecture française, écran et sculpture qui change au toucher `E`. État partagé entre visiteurs de la même session; sans API et sans score. |
| Mesh hybride | `ReusableMeshesV23.luau`, `config/meshes.json` | Préparation du remplacement d'ornements par meshes originaux importés, uniquement avec un AssetId valide et fourni par l'auteur. Fallback natif immédiat sans aucun import. |
| Jardins nocturnes | `OutdoorAtmosphere.luau` | Un émetteur ponctuel par jardin de trois lanternes au lieu de trois. 24 jardins : **24 contre 72** lumières de jardin, sans enlever les lanternes. Les huit halos centraux ne changent pas. |
| Paysages sonores | `Soundscape.luau` | Sélection par institution de nouveaux lits sonores originaux. **Désactivé par défaut** tant que les identifiants Roblox ne sont pas fournis. |

### Contenus produits hors moteur

- **5 fichiers `.obj` originaux** étanches (colonnes, pointe, rosace, arche et lustre), avec fichier `.mtl`. Ils sont vérifiés comme maillages fermés hors Studio. À importer une seule fois par type dans Studio si on veut activer leurs AssetIds.
- **4 matériaux originaux**, chacun avec cartes couleur, normales et rugosité en 512 × 512 pixels (12 PNG), plus un aperçu. Une `MaterialVariant` doit être créée/importée dans Studio pour avoir le résultat PBR réel.
- **5 nouvelles pistes WAV**, en plus des 3 précédentes : archives, laboratoire, port, botanique et harmonie civique. Les sons sont produits localement sans échantillons tiers. Import Creator Hub requis avant lecture dans Roblox.
- Scripts de reproduction `tools/generate_v23_meshes.py`, `tools/generate_v23_materials.py`, `tools/generate_v23_soundbeds.py`.

## Interactions et frontière métier

Les huit atlas d'exposition sont une **activité locale authentique**, pas des terminaux kOA déguisés. Un `ProximityPrompt` serveur est associé à chaque atlas. Le serveur vérifie que l'objet appartient au monde courant, que le personnage est vivant, qu'il est à moins de 15 studs et qu'il respecte un court délai entre activations. Il fait défiler quatre chapitres déterministes en français. Les terminaux de bibliothèque, ordinateurs, votes et services conservent **« Fonctionnalité à venir »** avec leurs IDs d'origine.

## Limites et déploiement réel

- L'installateur v23 garde le comportement **copier-coller dans la Command Bar**, sans rollback ni accès réseau externe.
- Le profil de construction par défaut demeure `STANDARD`. Le LOD local v22 reste actif.
- Les OBJ/PBR/WAV sont de **véritables fichiers produits et livrés**, mais **ils ne sont pas encore enregistrés comme assets Roblox** et ne peuvent pas être revendiqués comme visibles/audibles en jeu sans import.
- On ne dispose pas ici de Roblox Studio : aucune visite, FPS, collision, test multipassager ou import graphique n'a pu être confirmé dans le moteur.
- Il reste une direction artistique sur captures réelles, un kit de meshes intégralement substitué dans les générateurs, et la qualification physique mobile/multijoueur.

## Commandes

```bash
python -m pip install -r requirements-dev.txt
python tools/build_release.py
python -m unittest discover -s tests -q
```

La v23 contient toutes les constructions v1–v22 et remplace leurs installateurs pour les nouvelles installations. Aucune connexion kOA, aucune API IA payante au runtime.
