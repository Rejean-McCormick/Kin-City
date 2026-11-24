# RFC-B10-001 — Ajouter un calque d'orientation urbaine sans modifier les contrats

**Auteur :** B10 (ville centrale) · **Destinataire :** B09 · **État :** PROPOSÉ, non fusionné.

## Problème

Les six couleurs existent dans `HexagonalDistricts`, mais l'orientation de chaque avenue et la reconnaissance des huit entrées dépendent de décors répartis entre plusieurs générateurs. Les avenants KC33 améliorent le style; une couche d'orientation indépendante permet une couverture visible, mesurée et réversible sans déplacer les portes.

## Contribution

`contrib/places/city/Wayfinding.luau` implémente `Wayfinding.build(city, worldPlan, districts, profile)`.

- **6 avenues** : jusqu'à 3 totems/secteur (r=112,242,354, déport latéral 35), avec repli sur l'autre accotement en cas de conflit bâtiment/porte.
- **8 entrées** : un totem par destination canonique, ancré au point de retour extérieur et placé latéralement, aucune modification aux prompts, portes ou spawns.
- **Couleurs** : les couleurs sont dérivées de `HexagonalDistricts` au runtime. Les lieux du centre emploient le sarcelle, pas une septième couleur inventée.
- **3 profils** : LITE=1, STANDARD=2, SHOWCASE=3 totems max. Pas de modèle importé, pas de PointLight, toutes les pièces `CanCollide=false`.
- **Reconstruction** : dossier exclusivement décoratif `Ville/KinB10Orientation`, réutilisé si même profil/révision; reconstruction ciblée si la version change.

## Modification transversale B09 demandée (non effectuée)

1. Examiner la version précise de `CityGenerator.luau` dans le ZIP KC33/B09 (non présent dans cette session). Ajouter le ModuleScript `B10CityWayfinding` à `KinCityRuntime` dans l'export et les installateurs, sans remplacer un générateur.
2. Si B09 choisit le raccord : dans `CityGenerator.make`, après la construction et les façades et avant le `return city` :

```luau
-- Proposition seulement : sous contrôle de B09
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Wayfinding=require(script.Parent:WaitForChild("B10CityWayfinding"))
local Visual=require(Shared:WaitForChild("VisualConfig"))
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local _,stats=Wayfinding.build(city,plan,Districts,Visual.profile)
city:SetAttribute("KinB10Markers",stats.avenue+stats.entrances)
```

3. Incrémenter explicitement la révision de construction dans `WorldBuilder` pour invalider la scène préexistante si le calque est raccordé à la génération. Régénérer l'installateur par le processus canonique et vérifier que le ModuleScript B10 est bien embarqué.
4. Exécuter tests de non-régression avant que B09 fusionne et teste dans une **Place locale copiée**. Pas de PlaceId réel, pas de publication automatisée.

## Contrats inchangés

`catalog/{doors,places,spatial,buildings}.json`, `config/runtime.json`, `PlaceRouting`, `PlayerTravel`, `WorldBuilder` et `KinCityGenerated` (hors dossier d'orientation en aperçu). Aucune requête distante, aucune interaction KOALI réelle simulée.

## Tests requis avant acceptation

- 6 accents distincts + sarcelle commun : vérifier de jour et de nuit, Ekole sur fond clair, taille et lisibilité mobile/manette.
- Aucune obstruction de porte/retour, aucune collision; retour de huit institutions.
- Vérifier que tous les six secteurs reçoivent ≥ 1 totem en LITE, et que les huit entrées sont visibles sans masquer une façade.
- Mesurer coût : parties, GUI, mémoire locale, rendu et temps d'apparition avec StreamingEnabled en LITE/STANDARD/SHOWCASE.
- Rejouer B09 tests des 16 portes, tests Studio et QA dans le client publié (les téléportations ne sont pas couvertes par le module).

## Retour arrière

Désactiver le seul appel `Wayfinding.build` et supprimer `Ville/KinB10Orientation` dans une copie locale. Aucune mutation de contrat ni migration de données nécessaire.

## Limite de version importante

Cette contribution a été développée à partir de **l'archive V3 originale disponible lors de ce tour**. Elle respecte les clés et signatures documentées dans KC33/B09, mais le ZIP exact KC33/B09 n'était pas monté dans cette session. B09 doit rejouer la compilation et les tests de raccord contre **sa** baseline réelle avant `ACCEPTED`.
