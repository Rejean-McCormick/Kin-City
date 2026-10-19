# Kin City — Livraison de construction v0.5.0

**Périmètre :** enrichissement de la ville autonome, sans connexion kOA. Les portes, les navettes, les ascenseurs et le parcours touristique sont des fonctionnalités locales ; les consultations métier restent des stubs « Fonctionnalité à venir ».

## Code ajouté

| Module | Rôle | Livrable visible |
|---|---|---|
| `InstitutionForecourts.luau` | Générateur des huit cours d'institutions, avec réserve géométrique | Parvis, colonnades, bancs, parterres, œuvres spécifiques, bornes |
| `InteriorScenography.luau` | Scénographie générée dans les salles | Rosaces au sol, mosaïques, emblèmes, frises, suspensions |
| `ScenicCoast.luau` | Observatoires côtiers | Huit longues-vues aux belvédères de la ville |
| `VistaCamera.luau` | Visite panoramique côté client | Caméra panoramique contrôlable, zoom, retour PC/mobile/manette |
| `PedestrianWayfinding.luau` | Signalisation des chemins compilés | Repères dorés au sol et panneaux directionnels |

Modifications de `CityGenerator`, `InteriorGenerator`, `WorldBuilder`, `PromptRouter`, `RouteGuide`, `MapHud` et du client de démarrage pour intégrer ces systèmes. L'installateur `KinCity_Installer_CommandBar.luau` contient tous les nouveaux modules.

## Ce que l'on peut faire dans le monde

- Parcourir les huit parvis institutionnels, voir une œuvre propre à chaque bâtiment, consulter la borne en stub.
- Marcher dans les intérieurs décorés : tapis/rosaces, emblèmes, galeries de lumière et frises.
- Approcher les longues-vues des cours et du littoral ; appuyer sur **E** pour ouvrir la vue panoramique.
- Dans la vue panoramique : **◀/▶** pour pivoter, **+/−** pour zoomer et **Retour**, **F**, **Échap** ou **B** sur manette pour revenir à son avatar.
- Suivre les repères dorés et les indications du guide `N` vers les institutions.
- Voir les sites panoramiques sur la carte `M`.

## Exécution

1. Sauvegarder une copie du projet Baseplate dans Roblox Studio.
2. Ouvrir `KinCity_Installer_CommandBar.luau`, copier **tout** et exécuter dans **View > Command Bar** (mode édition).
3. Vérifier que `Workspace/KinCityGenerated` apparaît ; appuyer sur **Play**.
4. Utiliser `WASD`, **E**, **M**, **N** et **J** ; aucun compte kOA ou crédit API requis.

> L'installateur remplace `KinCityGenerated`, `KinCityShared`, `KinCityRuntime` et `KinCityUI`. Ne pas conserver de créations manuelles uniquement dans ces conteneurs.

## Architecture

Le serveur reste autoritaire pour les invitations de proximité. Pour les panoramas, il transmet exclusivement une position caméra et un point à observer pré-définis dans les objets créés par le générateur. Le client n'effectue qu'une animation de caméra locale. Les `KinVistaId` et `KinPublicSpaceId` sont stables ; les `KinStubInteractionId` des parvis restent préparés pour l'intégration future.

Un numéro de révision du moteur (`KinWorldBuilderRevision`) empêche de considérer une ancienne scène générée comme étant la dernière construction après modification du code, même si le manifeste spatial demeure identique.

## État et limites

Code, générateurs et installateur livrés; tests Python hors Roblox exécutés. **Le jeu n'a pas été lancé dans Roblox Studio depuis cet environnement.** Collisions, performances et qualité visuelle finale restent à constater dans Studio. Les enrichissements sont faits avec des Parts et matériaux Roblox ; les meshes et textures haute-fidélité ne sont pas fournis. Les 8 institutions existantes et les 60 pavillons préexistants restent dans le projet. Les parvis sont placés selon les gabarits de la ville et sont prévus pour être praticables, sans preuve de test in-game.

## Hors périmètre volontaire

Aucune API, aucun partage de crédits, aucun compte kOA, aucun vrai vote, aucune persistance métier.
