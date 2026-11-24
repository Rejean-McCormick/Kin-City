# Branche B10 — Place centrale Kin City

**Base ciblée** : KC33 + B09 `KC34-DOC-1.0`. **Base effectivement consultée pour cette passe** : archive `KinCity_ArtDeco_V3_Complet (1).zip` (V3 originale), seule disponible dans la session. Les identifiants de porte et le plan ont été comparés aux invariants partagés dans la conversation, mais la compatibilité du code avec la dernière livraison KC33/B09 reste à confirmer dans B09.

## Livré

- `Wayfinding.luau` : vrai module Luau de totems Art déco et signalétique pour les 6 secteurs et 8 destinations, non-collidable et sans nouvelle téléportation.
- `preview/B10_APERCU_LOCAL_COMMAND_BAR.luau` : script d'aperçu pour une Place locale **PlaceId = 0**, avec génération KinCity déjà prête, Studio arrêté. Il ajoute seulement `Ville/KinB10Orientation`; supprimer ce dossier pour annuler.
- `recipe.json`, `design.json`, 17 tests statiques, plan de B10, RFC-B10-001 pour raccordement sous autorité B09.

## Aperçu local dans Studio

1. **Sauvegarder la Place .rbxl**. Utiliser uniquement une Place locale non publiée avec la génération KinCity déjà effectuée.
2. Arrêter Play et vérifier `Workspace.KinCityGenerated.KinBuildState = Ready` et l'existence de `Workspace.KinCityGenerated.Ville`.
3. Copier **tout** `preview/B10_APERCU_LOCAL_COMMAND_BAR.luau` dans la Command Bar et l'exécuter.
4. Vérifier visuellement les repères : toutes les six sections, huit entrées, contraste Ekole, collisions, facilité d'approche et coût mobile.
5. Pour annuler : supprimer seulement `Workspace.KinCityGenerated.Ville.KinB10Orientation`. Ne pas exécuter le script sur une Place publiée, même privée.

L'aperçu a des gardes pour exiger le Studio, Play arrêté, PlaceId 0 et routage `LOCAL_UNIVERSE` et ne publie rien. **Il n'a pas été exécuté dans Roblox dans cette session.**

## Tests hors moteur

```bash
KINCITY_SOURCE_PATH=/chemin/vers/source/Kin-City \
  python -m unittest discover -s contrib/places/city/tests -p 'test_*.py' -v
```

`KINCITY_SOURCE_PATH` doit pointer vers une copie KC33/B09 intacte. Les tests actuels ont été exécutés contre l'archive V3 originale; B09 doit les rejouer et publier le résultat contre KC33.

## Réception B09

Ce dossier ne contient aucune modification à `src/server` et aux manifestes canoniques. Voir `docs/RFC-B10-001-INTEGRATION.md` pour le raccordement proposé, notamment l'invalidation du cache `WorldBuilder`. Un ajout à `CityGenerator` ou aux installateurs est **une demande SHARED** que B09 doit examiner.
