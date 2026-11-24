# Annexe : preuves d'origine et limites des observations

Ce document relie les conclusions KC36 à des fichiers précis. Il ne remplace pas les sources originales.

| Observation | Fichier de preuve | Niveau de confiance |
|---|---|---|
| Les façades sont bâties avant les avenues | `src/server/CityGenerator.luau` (`FacadeGenerator.make` puis `KoaliUrbanism.make`) | confirmé dans le code |
| Les avenues ont 19 dalles de 20 studs, largeur 19 | `src/server/KoaliUrbanism.luau` (`avenue`) | confirmé |
| Six avenues principales / axes | `src/shared/HexagonalDistricts.luau` | confirmé |
| 8 empreintes institutionnelles et 16 IDs portes | `build/world-plan.json` | confirmé |
| 6 intersections en vue de dessus avec la route | `preuves/KC35_CHEVAUCHEMENTS_VOIRIE.json` | calcul statique reproductible, sous hypothèses |
| Le B10 original génère des panneaux `BillboardGui` et des heures | `contrib/places/city/Wayfinding.luau` | confirmé dans le code historique KC35 fourni |
| La ville produit un disque de gazon | `src/server/CityGenerator.luau` (`Île circulaire`) | confirmé |
| `GroundCompatibility` archive certaines `Baseplate` | `src/server/GroundCompatibility.luau` | confirmé |
| Surfaces potentiellement proches : dalle, chemin, pavage GLB | `CityGenerator` et `KoaliUrbanism` | confirmé en architecture, pas comme cause de bug |
| La pelouse clignote en Play | capture + déclaration du propriétaire | symptôme réel rapporté ; cause inconnue |
| V30 jugée meilleure sur plusieurs aspects | déclaration propriétaire | décision esthétique, écarts précis non mesurés |
| Library centrale de 121 modèles / 463 meshes / PackageLink | Output Studio du propriétaire | confirmé pour la Place locale inspectée, pas pour toutes Places |

## Contradiction documentaire à résoudre

Le document historique `07-construction/specification-spatiale.md` donne des centres d'édifices **illustratifs** qui ne sont plus ceux du KC35 exécuté. La nouvelle spécification trace **l'état actuel depuis le plan KC35** et refuse de présenter les anciennes coordonnées comme une cible. La nouvelle topologie, et notamment le sens des trois anneaux, sera décidée ensuite.

## Limites de l'audit des six collisions

L'intersection utilise des rectangles orientés (`center_studs`, `footprint_studs`, `yaw_degrees`) et des bandes de 19 studs sur les axes radiaux r=62..442. Le calcul est en 2D, sans colliders effectifs du décor, sans intersection verticale, sans retouche locale de chaussée ni allowance pour pont. C'est un **précontrôle de planification bloquant pour le design**, pas un diagnostic de collision moteur. Les valeurs citées sont **studs²** d'emprises analytiques.

## Antécédent important — correctif v28.0.1

L'archive source fournie `KinCity_Koali_v31_9_REPO_COMPLET(1).zip`, document `CORRECTIF_SOL_ARRIVEE_v28.0.1.md`, consigne une cause **historique suspectée** de scintillement : une `Baseplate` coïncidant avec le gazon `Y=0`. Cette hypothèse a conduit à l'archivage sélectif par `GroundCompatibility`. Le document v28 disait explicitement que le scintillement n'avait **pas été certifié résolu en Studio**. L'incident KC35 peut être nouveau ou résiduel ; ne pas traiter l'ancien fix comme une preuve de résolution.

## Documentation API officielle consultée (27 octobre 2026)

- Roblox [Packages](https://create.roblox.com/docs/projects/assets/packages) : versions, mises à jour, PackageLink, modèle de master/copies.
- Roblox [PackageLink](https://create.roblox.com/docs/reference/engine/classes/PackageLink) : état AutoUpdate et limitation de création en script.
- Roblox [Model Streaming](https://create.roblox.com/docs/parts/models) et [Performance](https://create.roblox.com/docs/performance-optimization/improve) : limites de streaming, implémentation à qualifier en Play.
- Roblox [OverlapParams](https://create.roblox.com/docs/reference/engine/datatypes/OverlapParams) : vérification d'instances physiques par requêtes spatiales.
- Roblox [Terrain Editor](https://create.roblox.com/docs/studio/terrain-editor) : les modifications du terrain doivent être étudiées séparément des surfaces Parts de KC35.
