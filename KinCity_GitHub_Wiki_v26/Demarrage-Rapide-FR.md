# Démarrage rapide — Français

**Kin City v26** distingue maintenant **la ville extérieure** de **huit grandes institutions visitables**. Le code permet de construire les neuf scènes séparément, mais les téléportations publiées exigent les vrais PlaceIds Roblox.

## Essayer la ville, sans publication

1. Ouvre une nouvelle Place de test dans **Roblox Studio**.
2. En **mode Édition**, ouvre **View → Command Bar**.
3. Ouvre le fichier `KinCity_Installation_Directe_v26.luau`, copie son contenu complet et exécute-le dans la Command Bar.
4. Vérifie `Workspace.KinCityGenerated`, regarde **Output** pour les erreurs, puis lance **Play**.
5. Tu verras la ville, les façades et les huit entrées. Les portes affichent que les Places doivent être publiées : **c'est normal** en aperçu séparé.

## Essayer un grand bâtiment

Ouvre une **deuxième Place de test**, puis installe seulement `KinCity_Installation_Place_library_v26.luau` (pour la bibliothèque), ou un autre installateur `KinCity_Installation_Place_<key>_v26.luau`.

**Ne colle pas les neuf installateurs successivement dans une seule Place : ils remplacent le monde généré.** Conserve une sauvegarde, car il n'y a pas de mécanisme de retour arrière.

## Faire les vrais passages plus tard

Il faudra créer et publier neuf Places dans **la même expérience Roblox**, remplir `config/place_ids.json`, choisir `MULTI_PLACE` dans `config/runtime.json`, exécuter `python tools/build_release.py`, puis réinstaller et publier les neuf scènes. Il faut ensuite tester l'aller-retour **dans le client Roblox publié**.

## Raccourcis utiles

`M` carte, `N` itinéraire, `J` carnet d'exploration, `G` gare, `K` ateliers, `P` visite panoramique, `T` carnet de galeries, `V` détails visuels, `E` interactions à proximité. Tous les menus ne sont pas présents dans chaque Place.

## Important

- Le style officiel est **#1E6864 + cristal opalin**.
- Les meshes, matériaux PBR et sons importés sont **facultatifs** au premier chargement.
- Aucune connexion active à kOA : les services futurs indiquent **« Fonctionnalité à venir »**.
- Les tests Python ne remplacent pas les tests dans Roblox Studio.

[Quick Start (English)](Quick-Start) · [Architecture](Architecture) · [Dépannage / Troubleshooting](Troubleshooting)
