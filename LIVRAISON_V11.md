# Kin City — Construction v0.11.0 : marchés, maisons communautaires et minibus

**Livraison de code généré, pas encore exécuté dans Roblox Studio.** Cette version poursuit directement les 24 maisons, six quartiers, institutions, îles, marinas et ferries collectifs de la v10. Aucun appel HTTP, aucune intégration active kOA, aucune IA payante à l'exécution. Les services métiers demeurent en **« Fonctionnalité à venir »**.

## Construits dans les sources Luau

### Six marchés couverts accessibles

Un marché couvert dans chacun des six quartiers v10, implanté dans l'axe de la place commune. Les marchés comprennent des fondations, façades, entrées ouvertes, toiture avec lanterneaux, **12 étals meublés par halle** (72 au total), collections physiques thématiques, mobilier, luminaires et une commande réelle d'allumage/extinction. Deux étals par halle disposent d'un point d'interaction réservé aux fonctions métier futures, qui répond `COMING_SOON`.

Les variantes par quartier : récoltes, livres, artisanat, promenade, coopération, inventions.

### Six maisons communautaires à deux espaces verticaux

Chaque quartier reçoit une maison commune avec hall traversable, tables, sièges Roblox, escalier réel à **14 marches**, mezzanine, terrasse de lecture et cinq installations spécialisées selon son thème (serre, rayonnages, peinture, mobiles, tables collectives ou réfracteurs). Le mobile cinétique au centre peut tourner réellement via un prompt `E` — animation purement locale et côté serveur. Les écrans destinés aux futurs services restent en stub.

Au total : **12 nouveaux édifices fermés mais physiquement accessibles**, plus **72 étals** et six installations cinétiques réelles. Les bâtiments sont faits de pièces Roblox natives et possèdent des identifiants permanents `kin.habitat.*.market` / `.community`.

### Six lignes de minibus électriques collectifs

Six lignes reliant l'entrée de chaque boulevard au quartier habité, selon le registre géographique partagé de la v10. Chaque ligne possède :

- Deux stations physiques (donc **12 stations**) avec bancs, auvent, borne `E`, signalétique et dalle de quai.
- Une chaussée matérialisée longeant le boulevard existant.
- Minibus électrique généré à la demande avec roues, fenêtres, éclairage, banquettes et capacité de **huit joueurs par véhicule**.
- Fenêtre d'embarquement de **six secondes**, départ anticipé au remplissage, trajet programmé côté serveur, débarquement individualisé, état du personnage restauré.
- HUD tactile/manette/clavier indiquant passagers et temps restant.

**Type de transport :** véhicule ancré animé et personnages déplacés synchroniquement, pas un simulateur de conduite physique libre. Les voyages sont locaux à un même serveur Roblox.

### Carte et orientation

Les 12 nouveaux bâtiments et les 12 stations apparaissent sur la carte `M` et les marchés et maisons communautaires sont sélectionnables dans le guide `N`. Le registre `CommunityDestinations` dérive exactement des coordonnées v10 `ResidentialDestinations`. Les bâtiments sont exclus des placements aléatoires d'arbres.

## Fichiers ajoutés

| Fichier | Rôle |
| --- | --- |
| `src/shared/CommunityDestinations.luau` | Registre d'implantation des 12 nouveaux édifices |
| `src/shared/BoulevardRoutes.luau` | Registre des 6 routes et 12 arrêts |
| `src/server/CommunityBuildings.luau` | Générateur des marchés et maisons communautaires |
| `src/server/CommunityActivities.luau` | Éclairage et installations cinétiques locales |
| `src/server/BoulevardBuses.luau` | Stations, véhicules et transport collectif |
| `src/client/BoulevardBusHud.luau` | Interface de trajet du minibus |

## Fichiers modifiés

`CityGenerator.luau` instancie les édifices et réserve leurs parcelles; `ResidentialQuarters.luau` élargit les marges de végétation sur les boulevards; `WorldBuilder.luau` installe les 12 stations et porte la révision `construction-v11.0.0`; `init.server.luau` active la logique locale; `init.client.luau` affiche le HUD; `MapHud.luau` et `RouteGuide.luau` présentent les nouvelles destinations; `tools/make_studio_installer.py` assemble l'installateur actuel.

## Lancer la construction

1. Créer ou dupliquer une expérience **Baseplate** dans Roblox Studio.
2. Ouvrir `KinCity_Installer_CommandBar.luau` à la racine de l'archive.
3. Copier l'intégralité dans **Command Bar, en mode Édition**. Exécuter : la géométrie et les stations doivent apparaître dans le Workspace.
4. Lancer **Play**, rejoindre un quartier résidentiel ou l'entrée de son boulevard; utiliser `E` à une borne de minibus, de marché ou à une sculpture.
5. Carte `M`, guide `N`. Aucun accès réseau kOA requis.

Reconstruction depuis le code modulaire :

```bash
python tools/make_studio_installer.py
python -m unittest discover -s tests -v
```

Le script réinstalle les dossiers générés de Kin City. Ne conserver aucun décor manuel important dans ces dossiers. Le même code peut être utilisé avec Rojo via `default.project.json`.

## Statut et limites

- Les 13 tests Python hérités passent et l'installateur contient les nouveaux modules. Ces tests ne jouent pas le jeu dans Roblox.
- **Pas d'exécution Roblox Studio dans cet environnement** : visibilité des panneaux, collisions des escaliers, rendu des minibus et logique de groupe restent à essayer dans un vrai client Roblox.
- Les bâtiments ont un style procédural en Parts Roblox. Les meshes haut de gamme, textures PBR et animations humanoïdes avancées ne sont pas encore construits.
- Les minibus sont programmés sur une ligne courte, et non pilotables à volonté; aucun trafic routier autonome, feux de circulation ou système complet d'évitement d'obstacles.
- Aucune intégration métier à kOA, aucun achat ni véritable service administratif n'est activé.

## Continuation constructive souhaitée v12

Renforcer la qualité artistique des façades et intérieurs, construire une véritable gare centrale et des correspondances interquartiers, développer des activités coopératives locales et une vie urbaine plus crédible, avec animations de personnages améliorées. Conserver le stub-first, les IDs et les versions précédentes.
