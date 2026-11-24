# RFC-CONSOL-001 — Adaptateur commun pour les scènes B01…B10

**État : PROPOSÉE (non câblée, aucune édition des fichiers canoniques).**

## État actuel du code consolidé

La fusion des fichiers ne crée **aucune** instance Roblox : l'installateur KC33 ne charge pas `contrib/places/*`. Les signatures existantes divergent :

| Branche | Module / constructeur | Entrées principales | Décision nécessaire |
|---|---|---|---|
| B01 | `CityHallScene.build(context)` | `place_model`, `origin`, `profile` | Normaliser modèle et retour |
| B02 | `B02EkohInterior.Build(context)` | `interiorModel`, `origin`, `profile` | Adapter la casse et la signature |
| B03 | `LibraryScene.build(context)` | `interiorModel`, `origin`, `authorized` | Autorisation dans un contexte serveur |
| B04 | `CampusDecor.build(interior,origin,profile)` | arguments positionnels | Enveloppe wrapper obligatoire |
| B05 | `PreviewBuilder.build(ctx)` | `parent`, `origin`, `profile` | Parent, gestion d'échec et nettoyage |
| B06 | `KonstructScene.build(context)` | `parent`, `origin`, `profile` | Retour/rollback cohérents |
| B07 | **Aucun module reçu** | — | Livrer Musée, 6 salles et tests |
| B08 | JSON `scene_recipe` + script de preview Studio | pas de module serveur final | Rebase KC33 + convertisseur/loader |
| B10 | `Wayfinding.build(city,plan,districts,profile)` | modèle ville et plan | Adapter seulement après la génération de B10 |

## Interface cible à faire approuver (proposition, pas du code actif)

`SceneAdapter.apply({place_key, targetModel, origin, profile, cityPlan, districtCatalog, approvedAssets, budget, featureFlags}) → {status, created, failed, skipped, warnings, undo}`. B09 conserve l'autorité du runtime. Un wrapper unique convertit les arguments et vérifie l'identité de la Place avant de déclencher une scène. Aucun module de branche n'obtient une capacité de création de porte, de téléportation, de manipulation de contrat ou de mutation du Monde canonical.

Les modules devront : créer leur décoration hors Workspace, vérifier le nombre d'instances/meshes, ne pas masquer des anchors/portals, publier atomiquement et pouvoir retirer uniquement leur `Model` de branche. Les décorations doivent garder `CanCollide=false`, `CanTouch=false`, `CanQuery=false` et respecter le budget de profils.

**Feature flag :** `KinEnableBranchDecorations=false` par défaut. Activation seulement en copie locale de test avec vérification `KinActivePlace`; après passage des tests, préparation staging par neuf Places distinctes; pas de publication en production.

## Plan de qualification

1. B09 et B01 valident un premier adaptateur avec B01, dont la scène est idempotente; test négatif place_model absent, profil inconnu, anchor manquante, erreur de construction, rollback.
2. Les autres constructeurs sont adaptés un par un avec leurs identifiants/caps; B08 attend sa migration de baseline et B07 sa contribution.
3. Réviser les règles de package pour embarquer les ModuleScripts + `SceneData`, `CityHallSpec`, etc. sans dépendre de chemins Studio non résolus.
4. Exécuter validation Luau, puis dans Studio sur copie les 6 salles de chaque Place et la ville, sans toucher aux portes, aux huit façades ni aux repères.
5. Lancer les tests dans une expérience privée de staging avec neuf PlaceIds réels et mesurer le coût mobile avant une éventuelle publication.

**Interdiction :** ne pas activer un constructeur au simple constat que ses tests Python passent. Les tests Python ne prouvent pas le runtime Luau ou la compatibilité des copies Studio.
