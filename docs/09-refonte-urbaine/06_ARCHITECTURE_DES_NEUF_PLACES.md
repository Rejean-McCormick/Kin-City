# 06 — Neuf Places, dix branches, une bibliothèque d'assets

## 1. Modèle de publication et identité

Le mode `LOCAL_UNIVERSE` de `KinCity_35.rbxl` démontre la scène unique en Studio, **pas une publication multi-Place validée**. La cible KC34/KC35 comporte **neuf Places logiques** : une ville, huit institutions. La branche d'intégration **B09 n'a pas de Place Roblox**. Le nombre de Places ne préjuge pas de l'architecture finale : `separate_place` reste une hypothèse à qualifier côté client mobile et TeleportService.

| Branch | `place_key` | Rôle du runtime | Accès |
|---|---|---|---|
| B10 | `city` | routes, secteurs, façades, accès et broadcast extérieur | ville de départ |
| B01 | `city_hall` | Hôtel de ville | porte ville ↔ intérieur |
| B02 | `ekoh_tower` | Observatoire EkoH | porte ville ↔ intérieur |
| B03 | `library` | Grande Bibliothèque | porte ville ↔ intérieur |
| B04 | `campus` | Université UCKK | porte ville ↔ intérieur |
| B05 | `justice_palace` | Agora Korum | porte ville ↔ intérieur |
| B06 | `innovation_lab` | Atelier Konstruct | porte ville ↔ intérieur |
| B07 | `museum` | Galerie Konservation | **entrée barrée**, diffusion à proximité |
| B08 | `orgo_center` | Maison Orgo | porte ville ↔ intérieur |
| B09 | `integration` | plan, contrats, orchestration, QA, releases | pas de Place dédiée |

## 2. Conserver le contrat des 16 portes et des 49 ancres

L'état source KC35 comprend **16 `door_id`**, soit huit aller/retour, et **49 ancres** ; ce sont des identifiants immuables entre les migrations d'implantation. Le musée peut avoir une politique `locked` **sans supprimer l'entrée canonique de la matrice**, de manière à permettre une ouverture future contrôlée. Le `PlayerTravel` doit appliquer l'état serveur `locked`, et la scène afficher un panneau physique correspondant.

## 3. Les 48 salles et le problème des bounds

Le plan contient **3 salles canoniques par institution (24)** et `InteriorWings` ajoute **3 salles par institution**, d'où **48 espaces prévus**. Les `bounds` historiques (`110×100`) décrivent seulement le bloc initial : les ailes étendent réellement l'enveloppe. **Ne pas continuer à utiliser ces bounds réduits** pour un packing d'intérieurs multi-Place sans calculer l'AABB 3D finale. Le périmètre doit être recomputé depuis les six salles et marges de circulation.

## 4. Package Art déco central : séparation des responsabilités

La copie actuellement validée par le propriétaire dans `KinCity_35.rbxl` est `ServerStorage.KinCityArtDecoLibrary` : **121 modèles, 463 MeshParts, `PackageLink=true`, `StreamingEnabled=true`, Place locale**. Ce constat vient de l'Output Studio transmis. Il ne constitue pas une mesure de FPS ni une preuve d'import répété dans neuf Places.

- **Master** : `KinCity_AssetsMaster.rbxl`, Package versionné ; garder le fichier local et son propriétaire Roblox.
- **Consumers** : chaque Place référence une **copie de package**, pas une copie artisanale de 121 imports GLB.
- **Mise à jour** : choisir version cible, inspecter les changements, mettre à jour les copies, tester et publier les Places. `AutoUpdate` dans Studio est un **mécanisme de synchronisation à l'ouverture**, pas un service de téléchargement d'assets modifiables en permanence dans les clients déjà publiés.
- **Protection** : `PackageLink` non créé par script, jamais effacé/transformé par installateur ; appeler `AssetResolver` sur un clone pour éviter les changements du Package.

## 5. Droits et médias

Les Assets Roblox ont des permissions, et chaque nouveau consommateur doit avoir accès aux meshes, textures et éventuels médias. Un `VideoFrame` ne lit pas un URL YouTube en direct : l'écran B07 reste un **support de broadcast signalé**, le contenu vidéo effectif dépend d'un asset vidéo Roblox autorisé et d'une politique de diffusion compatible. L'absence de média ne doit pas créer une fausse émission « LIVE ».

## 6. Règle de reconstruction

Chaque Place consomme le même `ApprovedPlan` de parcelles et les mêmes IDs. **Dans `city`, les façades et les abords sont produits ; dans les Places intérieures, seules les salles utiles le sont.** Le local-universe sert au QA d'ensemble et peut placer des intérieurs à des origines temporaires éloignées ; ce n'est pas la configuration d'expérience publique définitive.

## 7. Conditions d'activation multi-Place

Ne renseigner que les PlaceIds véritables contrôlés par le propriétaire, tester dans un client Roblox publié en staging et vérifier chaque aller/retour, la reprise en erreur, les permissions des Assets et la performance mobile. Interdire toute auto-publication depuis le pipeline documentaire.
