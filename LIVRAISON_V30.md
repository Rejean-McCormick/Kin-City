# Livraison cumulative Kin City v30.0.0

## Base et conservation

Le travail part **uniquement** de l'archive v29 transmise dans cette conversation. Les 9 Places, 8 institutions, portes et interactions existantes, King Klown v7, le récit et les générateurs de pavage/collisions v29 sont conservés. Aucune nouvelle construction, PlaceId, AssetId ni connexion kOA. Direction artistique sarcelle `#1E6864` / opalin `#C5F4F0` inchangée.

## Modifications effectives

| Source | Modification |
|---|---|
| `src/client/KinCityMenu.luau` | Recherche instantanée des outils; hauteur Canvas déterminée par `UIListLayout`; menu borné par le viewport; retrait de la taille minimum forcée d'une ancienne fenêtre; focus `GuiService.SelectedObject` à la manette; fermeture sans capturer une saisie dans un TextBox. |
| `src/client/RouteGuide.luau` | Huit institutions prioritaires et recherche des destinations; remise à zéro visible; distance restante par projection sur le tracé des huit itinéraires publics, prise en compte de l'écart au sentier; distinction « distance directe indicative » pour lieux sans parcours; orientation vers projection lorsqu'on est loin du chemin. |
| `src/client/LibraryJourneyGuide.luau` | Respect de la fermeture volontaire en session, bascule cohérente entre guide de destination et visite du récit, défense contre cible narrative inconnue. |
| `src/client/VistaCamera.luau` | Sortie sur `CharacterRemoving` et `CharacterAdded`; restauration sur lieu courant si déplacement important; refus de prendre possession d'une autre caméra Scriptable; touches ignorées lorsqu'on écrit. |
| `src/client/LocalPerformanceProbeV29.luau` | Échantillonnage local 20 s avec `time()`, possibilité d'annuler, nettoyage des connexions, affichage actualisé à 0,4 s et interruption sur fermeture. Le nom de fichier historique est conservé pour compatibilité. |
| `tools/build_release.py`, `tools/make_studio_installer.py` | Génération des scripts `*_v30.luau` + manifest `30.0.0`, neuf installations indépendantes + tout-en-un. |
| `tests/test_v30_accessibility.py` | Tests hors moteur des contrats des guides, filtres, caméra, accès outils, absence de réseau et 11 scripts d'installation v30. |

## Vérifications et limites

À exécuter depuis la racine :

```sh
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/validate_v28_journey.py
python tools/build_release.py
python -m unittest discover -s tests -p 'test_v30_accessibility.py' -v
python tools/check_luau_structure_v29.py
python -m unittest discover -s tests -v
python tools/check_luau_syntax.py
```

Les validateurs de catalogue, d'espace et de bibliothèque restent les validateurs du dépôt. Les tests hors moteur n'exécutent aucune caméra Roblox, aucune collision ni téléportation publiée. `check_luau_structure_v29.py` est un contrôle **lexical**, pas un compilateur. `lupa` et `tree_sitter_luau` ne sont pas présents dans l'environnement actuel. **Résultat hors moteur :** validateurs catalogue/spatial/bibliothèque réussis; 7 nouveaux tests v30 réussis; suite Python complète : **94 tests découverts, 91 passés, 3 modules bloqués par l'absence de `lupa`** (`test_ground_arrival`, `test_v27_reliability`, `test_v28_journey`), sans échec d'assertion. Vérification lexicale/structurelle sur 180 fichiers Luau : 0 anomalie détectée. Le parseur `tree_sitter`/`tree_sitter_luau` n'est pas installé et la vérification grammaticale complète n'a pas abouti. Voir les journaux `build/v30-*.log` pour les commandes effectivement exécutées. L'utilisateur n'a pas demandé de validation dans Studio pour cette itération.

## Retour arrière

Le ZIP v29 joint est conservé comme source d'origine. Ne lancer qu'un seul installateur dans une Place copiée : la reconstruction supprime/recrée `KinCityGenerated`, et les retouches manuelles dans cet espace doivent être exportées avant génération. L'installateur v29 archivé ne contient pas les changements v30.
