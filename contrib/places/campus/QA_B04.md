# B04 — Référentiel QA du campus UCKK

## Barrière A (code/contrats) — vérification Python

Depuis la racine du projet qui possède `catalog/`, `src/` et `build/world-plan.json` :

```bash
python -m unittest discover -s contrib/places/campus/tests -p 'test_b04.py' -v
```

Les 12 tests vérifient les identifiants et portes, le graphe des six salles, la palette, le mode stub de l'interaction, l'absence de réseau, les protections de la prévisualisation, les profils et l'idempotence. **Ils ne compilent pas Luau et ne prouvent pas les collisions en jeu.**

## Prévisualisation strictement locale

1. Dans Roblox Studio, ouvrir une **copie locale PlaceId 0** contenant déjà `KinCityGenerated` prêt et l'intérieur `Intérieur — campus`.
2. Sauvegarder la copie `.rbxl`. Arrêter Play.
3. Exécuter le contenu de `INSTALLER_B04_PREVIEW_LOCAL.luau` dans la Command Bar en mode Édition.
4. Observer le nouveau dossier `B04_CampusDecor_KC34` sous le modèle de l'intérieur. L'injection ne retire ni ne déplace aucune partie existante.
5. Contrôler la lisibilité des textes, l'orientation des panneaux et des faces SurfaceGui. Le profil de prévisualisation est `STANDARD`.
6. Pour revenir à l'état initial, supprimer **uniquement** `Intérieur — campus/B04_CampusDecor_KC34`, ou restaurer le `.rbxl` sauvegardé.

## Matrice de tests à effectuer dans Studio/Client (NON TESTÉ)

| Épreuve | Attendu | Réel | État |
|---|---|---|---|
| Hall / arrivée `campus.lobby.spawn` | Apparition dégagée, panneau de gauche et droite | — | NON TESTÉ |
| Sortie `campus.exit.door` | Porte et prompt inchangés, passage libre | — | NON TESTÉ |
| Panneau `hall.board_01` | Capacité `uckk.courses.browse` en `stub` | — | NON TESTÉ |
| Salle de cours | Panneau lisible, déplacement vers aile ouest | — | NON TESTÉ |
| Laboratoire pédagogique | Panneau lisible, vers aile est | — | NON TESTÉ |
| Laboratoire de l'aile ouest | Pas de collision ni panneau dans portail | — | NON TESTÉ |
| Aile est | Aucun blocage / pas de faux service connecté | — | NON TESTÉ |
| Atrium universitaire | Sciences existantes conservées, sortie accessible | — | NON TESTÉ |
| Profil LITE | Moins de moulures, mêmes salles/portes | — | NON TESTÉ |
| Profil SHOWCASE | Plus de moulures, fluidité sur appareils cibles | — | NON TESTÉ |
| Téléport publié ville→campus→ville | 2 directions, arrivée correcte | — | NON TESTÉ |
| Rebuild WorldBuilder | Intégration du module à conserver après génération | — | NON INTÉGRÉ |

## Points de vigilance B09

- Préserver `city.konnected.university.entry` malgré le rattachement actuel à UCKK.
- L'enveloppe réelle de salles avec ailes déborde le bounds initial 110 × 100 : décider via ADR-001 B09, pas dans ce patch.
- Tester la scène existante chargée à l'origine `(1800,0,1800)` dans le mode local ; ne **pas** réutiliser ce décalage dans une Place séparée sans `Spatial.origin`.
- Un rendu de décors n'est pas une validation de cours, crédits, inscription ou progression kOA.
