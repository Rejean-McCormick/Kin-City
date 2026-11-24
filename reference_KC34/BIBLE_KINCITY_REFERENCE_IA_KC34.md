> **KIN CITY / KOALI · RÉFÉRENTIEL DE DÉVELOPPEMENT PARALLÈLE · KC34-DOC-1.0**

> Établi sur la livraison KC33 du 26 octobre 2026. Statut : documentation de gouvernance et de conception; ce n’est ni une validation Roblox Studio, ni une publication de Places.

> **Langue de travail : français.** Les IDs de code, de manifestes et de routes restent inchangés.

# 0. MODE D’EMPLOI — COMMENT UNE IA DOIT UTILISER CETTE BIBLE

Le présent document est la référence commune des dix branches de **travail** sur Kin City. La baseline logicielle reste le ZIP **KC33**. Ce document ne remplace pas les fichiers sources réels : toute proposition doit être vérifiée contre les JSON et Luau livrés, et les changements doivent être implémentés dans le dépôt. Il sert à éviter qu’une IA de branche invente ses propres règles, déplace une porte, renomme un identifiant, réinterprète le style ou modifie des composants partagés sans coordination.

**Instructions obligatoires pour chaque conversation/agent :**

1. Lire ce référentiel, les empreintes `contrats/empreintes_kc33.json`, son prompt `branches/Bxx_*.md` et le ZIP KC33. Identifier son `place_key` et ses frontières.
2. Produire un plan et un diff limité à son territoire; annoncer les fichiers affectés, les dépendances, les risques et les contrats potentiellement modifiés.
3. **Ne jamais** prétendre qu’une Place existe, qu’une téléportation marche ou qu’une performance a été mesurée sans la preuve d’un test réel.
4. Toute divergence entre documents et sources est une **question d’arbitrage B09**. Ne jamais corriger une divergence en renommant les IDs à l’aveugle.
5. Livrer les fichiers modifiés, les tests réellement exécutés, les preuves et un manifeste de remise. Une simple réponse de conversation n’est pas un patch intégrable.

**Hiérarchie d’autorité** (du plus fort au plus faible, sauf décision versionnée contraire) : (1) décisions explicites du propriétaire et interdiction de toucher à la production; (2) identifiants et contrats canoniques `catalog/*.json` + `config/*.json`; (3) plan régénéré et modules Luau qui correspondent à la même révision; (4) ADR et normes du présent référentiel; (5) fiches de branches; (6) anciennes notes historiques, captures, propositions et préférences locales des IA. Une clé présente dans les manifestes prime sur un nom d’affichage jugé plus naturel.

# 1. VISION, PÉRIMÈTRE ET NIVEAU DE RÉALITÉ

**Kin City est l’interface spatiale ludique de Koali/kOA** : une ville Art déco navigable, communautaire, éducative et culturelle; six secteurs identifiables reliés à un centre commun. Elle doit exister d’abord comme expérience autonome robuste. Elle ne doit pas donner l’illusion que des modules métiers externes (vote, pédagogie, gestion de dossiers) sont déjà connectés. Les futures intégrations conservent leurs autorités sources et nécessitent une passerelle dédiée, une authentification, une politique de canal et des tests de sécurité.

**État avéré KC33 :** sources et installateur local disponibles; mode `LOCAL_UNIVERSE` actif; ville + huit intérieurs dans une Place de travail; portes logiques et scripts de routage existants; neuf `place_key` dont les vrais PlaceIds sont `null`; 121 entrées du pack Art déco documentées, dont 41 configurées et 80 en bibliothèque; six secteurs colorés, huit façades, dix-huit pavillons, huit chemins piétons et vingt-quatre salles canoniques complétées par vingt-quatre salles d’extension en runtime. Le déploiement Roblox multi-Place, le rendu Studio et les chiffres de performance n’ont **pas** été confirmés ici.

**Architecture cible, non état publié :** une même expérience Roblox de staging contient neuf Places — `city` + huit intérieurs. Les portes transportent le joueur via une téléportation serveur inter-Place fiable et symétrique. À terme, la ville publique suit la même structure **uniquement si** une comparaison de performances et d’expérience utilisateur l’approuve.

# 2. NEUF PLACES ROBLOX, DIX BRANCHES DE DÉVELOPPEMENT

Il existe une différence cruciale entre une **branche de conversation/Git** et une **Place Roblox**. Le projet possède neuf Places canoniques et dix branches de travail. **B09** est la branche intégratrice transversale, **pas une dixième Place**; **B10** correspond à la Place centrale, comme souhaité.


| Branche | Place / mandat | Bâtiment ou service | Dépendances de validation |
|---|---|---|---|
| **B01** | `city_hall` | Accueil | B09 (contrats) + B10 (façade et porte extérieure) |
| **B02** | `ekoh_tower` | Observatoire EkoH | B09 (contrats) + B10 (façade et porte extérieure) |
| **B03** | `library` | Grande Bibliothèque | B09 (contrats) + B10 (façade et porte extérieure) |
| **B04** | `campus` | Université King Klown | B09 (contrats) + B10 (façade et porte extérieure) |
| **B05** | `justice_palace` | Agora Korum | B09 (contrats) + B10 (façade et porte extérieure) |
| **B06** | `innovation_lab` | Atelier Konstruct | B09 (contrats) + B10 (façade et porte extérieure) |
| **B07** | `museum` | Galerie Konservation | B09 (contrats) + B10 (façade et porte extérieure) |
| **B08** | `orgo_center` | Maison Orgo | B09 (contrats) + B10 (façade et porte extérieure) |
| **B09** | `integration` | Contrats, QA, intégration, release, sécurité | Tous les chantiers |
| **B10** | `city` | Ville centrale, six secteurs, voirie, façades | B09 et B01…B08 |


**Règle impérative :** chaque branche d’intérieur travaille sur son intérieur uniquement; B10 possède les façades, les avenues, les voies, les pavillons et l’espace public; B09 possède les contrats transversaux, la résolution de conflits, le build multi-Place, les tests inter-Places et la qualification finale. Une façade ne change pas sans accord B10; une ancre ne change pas sans accord B09 + branches aux deux extrémités.

# 3. SOURCES DE VÉRITÉ, CHAÎNE DE BUILD ET VERSIONNEMENT

**Fichiers canoniques à préserver :** `catalog/city.json` (ville/seed/topologie), `catalog/districts.json` (secteurs), `catalog/buildings.json` (institutions et liens), `catalog/places.json` (Places et ancres logiques), `catalog/doors.json` (graphe de portes), `catalog/spatial.json` (coordonnées/empreintes/volumes), `catalog/interactions.json` (interactions), `catalog/assets.json`, `catalog/style_guide.json`, `catalog/art_deco_assets.json`, `catalog/art_deco_contexts.json`, `catalog/art_deco_placements.json` (assets/recettes), `config/runtime.json` (mode), `config/place_ids.json` (routage), `config/interior_origins.json` (poches locales) et `config/art_deco.json` (budgets/garde).

**Chaîne logique réelle :** `catalog/*.json` et `config/*.json` → `tools/validate_catalog.py` et `tools/validate_spatial.py` → `tools/compile_plan.py` produisant `build/world-plan.json` → `tools/export_roblox.py` et scripts d’assemblage → modules `src/shared` générés + scènes créées côté serveur par `WorldBuilder`. Pour le mode staging, `tools/build_staging_places.py` produit des installateurs ciblés avec neuf identifiants distincts fournis par Roblox. Le script n’enregistre aucun PlaceId fictif et ne publie rien. **Il faut contrôler l’ordre exact des étapes du build sur une copie**, car le dépôt contient des outils historiques de plusieurs générations.

**Ne pas modifier directement** `src/shared/Buildings.luau`, `src/shared/WorldPlan.luau`, `src/shared/PlaceRouting.luau` ou les autres modules générés pour traiter un problème de catalogue. Modifier la source de vérité, recompiler/exporter, comparer les empreintes et exécuter les tests. Une génération doit déclarer la baseline, les hash de sources et son propre identifiant de build. Les scripts v27–v33 coexistent : un module historique n’est pas nécessairement appelé par `WorldBuilder` v33.

**Convention de proposition de branche** (à créer et faire approuver par B09; ces chemins ne sont pas tous présents dans KC33) : `contrib/places/<place_key>/` pour les nouveaux modules, plans de décor et preuves; `docs/decisions/` pour ADR; `handoffs/Bxx/<date>/` pour états de remise. En attendant l’intégration au générateur, ne pas réécrire les composants partagés dans huit forks différents.

**Protection de version :** les empreintes SHA-256 de fichiers sensibles sont dans `contrats/empreintes_kc33.json`. Une modification de l’un de ces fichiers est une **proposition de changement de contrat** si sa sémantique évolue; B09 doit accepter la version suivante et annoncer l’impact aux branches. Le changement d’un hash n’est pas une preuve de régression, mais aucun agent ne doit le passer sous silence.

# 4. CONTRATS FONDAMENTAUX INCHANGEABLES SANS ADR

**Identité :** `place_key`, `building_id`, `room_id`, `portal_id`, `anchor_id`, `door_id`, `interaction_id`, `capability_id`, `asset_key` identifient durablement des objets différents. Ils ne doivent pas être dérivés des textes visibles, de la position dans une liste ou du nom d’un Model dans Workspace. Déprécier une clé au lieu de la recycler. Tout renommage est une migration explicite avec ancienne→nouvelle valeur, compatibilité et tests.

**Géométrie :** unité en studs Roblox; X/Z pour le plan; Y pour la hauteur; rotation yaw autour de +Y; avant local = -Z. Une ancre d’arrivée est un contrat fonctionnel, pas une suggestion décorative. Elle doit garantir un sol marchable, un dégagement avatar, un chemin vers le hall et un retour accessible. Les intérieurs en `LOCAL_UNIVERSE` sont décalés par `config/interior_origins.json` : ne pas copier ces translations dans une Place intérieure séparée, où l’origine locale doit être conforme au mode `MULTI_PLACE`.

**Portes :** il existe exactement 16 portes opérationnelles dans KC33 : huit entrées ville→intérieur et huit sorties intérieur→ville. Une porte déclenche un vrai déplacement ou une erreur explicite; le simple message « bientôt » ne constitue jamais une porte fonctionnelle. Les `return_door_id` sont réciproques. Le client transmet une intention; le serveur valide la porte, la zone source, le cooldown, le droit d’accès, le PlaceId cible et l’ancre. Les données `TeleportData` sont indicatives, jamais une autorité sur des droits ou un solde.

**État fonctionnel KOALI :** `WORLD_STUB` = aucune intégration métier externe. Valeurs honnêtes : `coming_soon` (non connecté), `unavailable` (service opérationnel indisponible), `denied` (refus), `error` (erreur technique), `success` (action réellement achevée). Ne jamais fabriquer des votes, des crédits, des cours validés, des dossiers administratifs ou des données d’identité. L’UI doit rester bilingue-ready et accessible, même lorsqu’une capacité reste simulée.

**Sécurité production :** `config/art_deco.json` contient un PlaceId de production interdit pour cette chaîne d’installateurs. Ne pas exposer cet identifiant comme cible de test, ne pas permettre une opération destructrice par simple alias et ne pas appeler des scripts de publication sans autorisation humaine documentée. En staging, chaque script vérifie **avant nettoyage** le PlaceId, la liste approuvée, le marqueur manuel, le mode Studio et StreamingEnabled. Les PlaceIds réels ne sont pas dans KC33 : les neuf champs sont `null`.

# 5. ORGANISATION SPATIALE ET URBAINE

Le catalogue fixe `kin_city` (seed `20261018`), une topologie déclarée concentrique (`3` anneaux, rayon nominal `450`), et `catalog/spatial.json` décrit une limite circulaire de **495 studs**. Il faut distinguer rayon de génération, rayon de bounds et rayon réel de chaque bâtiment : ne pas les remplacer par une seule constante inventée.

**Six secteurs périphériques + centre partagé :** le centre `central` n’est pas une septième palette périphérique. Les directions 12/2/4/6/8/10 heures viennent de `src/shared/HexagonalDistricts.luau`. En vue du dessus, `-Z` correspond à 12 heures et `+X` à 3 heures. Le code `catalog/districts.json` documente également les angles mathématiques de chaque hub : une conversion entre système d’heures et `angle_degrees` doit être explicite avant de modifier la géométrie.


| Heure | district_id | Nom | Accent autorisé | Orientation X,Z | Caractère / usage |
|---:|---|---|---|---|---|
| 12 | keenkonnect | keenKonnect | #D0BF86 | (0,-1) | Métal, innovation, coopération |
| 2 | ethikos | ethiKos | #A97C4F | (+0.866,-0.5) | Bois et bronze, débat |
| 4 | kreative | Kreative | #CB809D | (+0.866,+0.5) | Galeries, culture, création |
| 6 | uckk | UCKK | #758EA6 | (0,+1) | Académique, apprentissage |
| 8 | ekole | Ekole | #E5EAE7 | (-0.866,+0.5) | Monochrome opalin, lecture |
| 10 | konnected | KonnectED | #BC674C | (-0.866,-0.5) | Marbre sombre, savoir |


**Palette structurante transverse :** sarcelle `#1E6864`. Les rôles `KC32_CORPS`, `KC32_BRONZE`, `KC32_VITRAGE`, `KC32_LUMIERE` restent cohérents globalement. Seul le rôle `KC32_ACCENT` porte l’identité forte du secteur; la variable `lightColor` a été alignée à `color` pour chaque secteur dans `HexagonalDistricts`. Un accent ne doit pas repeindre tout le bâtiment ni diminuer les contrastes des sorties. Pour le blanc Ekole, tester obligatoirement le contraste sur sols clairs; si nécessaire, ajouter un filet de bordure sombre tout en conservant l’hexadécimal officiel.

**Cohérence d’un secteur :** (i) filet d’avenue et repères au sol, (ii) signalétique et kiosques, (iii) touches de mobilier, (iv) éclairage d’accent, (v) décorations de façade s’y rapportant, (vi) repère UI/carte. Chaque branche décrit l’usage primaire et secondaire de l’accent. Garder le matériau et la typographie Art déco communs; différencier par quelques indices reconnaissables même en désaturation et pour les personnes daltoniennes.

**Voirie existante :** la génération active prévoit **six avenues radiales**, des chemins piétons canoniques (huit trajets dans `build/world-plan.json`) et des voies menant aux dix-huit pavillons. KC33 ajoute des pavages/croisements Art déco décoratifs, par-dessus le substrat praticable. Les pavés importés sont sans collision; la navigation se fait toujours sur les sols de gameplay. Les tramways, bus et véhicules du catalogue ne doivent pas être déclarés actifs en circulation tant que la génération actuelle, les lignes et les contrôles n’ont pas été démontrés.

**Doctrine future de mobilité :** cœur piéton prioritaire; chaussée réellement distincte seulement si le fonctionnement le justifie; traversées clairement délimitées; stations placées hors des couloirs d’accès; véhicules décoratifs d’abord puis parcours contrôlés, pas de simulation traffic coûteuse imposée par défaut. Les bornes d’accessibilité et les retours de porte dominent l’ornementation. Toute proposition de boulevard par B10 passe par un audit de conflits avec les 8 chemins et 19 obstacles inscrits au plan.

# 6. ASSETS ART DÉCO, DROITS ET PARAMÉTRAGE

**Inventaire KC33 :** 121 sources répertoriées dans `catalog/art_deco_contexts.json`, **41 configurées**, **80 disponibles en bibliothèque sans recette obligatoire**. La documentation V3 mentionne 463 MeshParts distincts importés selon un relevé utilisateur. Ce chiffre est un inventaire historique de Studio, non une mesure récente de la scène en jeu. Les sources ont été importées dans Studio par le propriétaire; les meshes du pack commercial ne sont pas inclus dans les fichiers redistribuables et les permissions doivent être respectées.

**Acteurs :** `ArtDecoData` fournit les références; `ArtDecoAssets` résout et clone des imports; `ArtDecoBudget` arbitre les quotas; `ArtDecoBuildings`, `ArtDecoProps`, `ArtDecoSurfaces` et `ArtDecoInteriors` réalisent les placements; `ArtDecoLightLOD` choisit une partie des lumières localement. Ne pas remplacer un vrai sol, escalier, ascenseur ou collider de gameplay par une copie décorative : le mesh peut rester sans collision et ne sert que d’habillage. Les rôles d’assets, tailles sources, pivots, sens de façade et ombres doivent être testés dans Studio.

**Profils disponibles :** `LITE`, `STANDARD`, `SHOWCASE`, avec quotas par propriétés et *pools* (`building`, `street`, `interior`, `environment`, `pavilion`, `architecture`, `paving`). KC33 ajoute un pool `paving` afin de ne pas évincer lampadaires et bancs. Ne pas additionner des triangles issus de sources hétérogènes comme des draw calls ou des FPS. Le budget de `config/art_deco.json` est **une limite logique de réservation**, pas une mesure matériel. Un agent doit publier consommation, rejets de placement et fallback par Place et par profil.

**Règles d’intégration d’un nouvel asset :** (1) identifier `asset_key` valide et sa provenance; (2) décrire rôle et destination; (3) vérifier pivot/échelle/orientation/normalisation; (4) réserver le pool approprié; (5) conserver colliders séparés; (6) établir distance d’affichage/LOD; (7) renseigner `configuration_references` dans le manifeste; (8) tester absence d’asset et fallback natif; (9) vérifier l’alignement en Studio; (10) faire approuver la consommation mémoire/draw/triangles par B09. « Intégrer les 80 assets restants » n’est pas un objectif : **seuls les assets utiles** doivent être placés.

**Ambiance visuelle :** Art déco géométrique, volumes hiérarchisés, arches, métal bronze et opale, verticalité proportionnée, motifs rythmés, détails lisibles de loin, vitrages mesurés, matériaux partagés. Chaque intérieur possède une signature spatiale sans perdre l’ADN commun : orientation, portes, escalier, scène principale, parcours, couronnements, lumière et accent. La répétition identique d’un pavillon est déconseillée; KC33 exploite trois silhouettes sur les dix-huit pavillons.

# 7. ARCHITECTURE LOGICIELLE ET CONVENTIONS LUAU

**Frontières recommandées :** `src/shared/` = tables statiques/client-safe et interfaces, sans données privées; `src/server/` = autorité de déplacement, génération des mondes, interactions et budgets; `src/client/` = caméra, menus, journal, affichage, sons locaux, transitions et optimisation visuelle; `catalog/` et `config/` = définition déclarative; `tools/` = validation, compilation, export, packaging; `tests/` = tests automatisés; `studio/` = préparation/inspection dans Roblox Studio. Les fichiers générés sont le résultat, non la source.

**Modules sensibles et propriétaire :** `WorldBuilder` / `Spatial` / `PlayerTravel` / `PromptRouter` / `RuntimeConfig` / `PlaceRouting` / `WorldPlan` → B09. `CityGenerator` / `KoaliUrbanism` / `DistrictChromatics` / routes / espaces civiques → B10. `InteriorGenerator` / `InteriorWings` / `ArtDecoInteriors` / `ArtDecoRooms` → modules transversaux sous B09; les branches B01–B08 ne les modifient pas directement pour un seul intérieur, elles soumettent des recettes séparées paramétrées par `place_key`. Le runtime `init.server.luau` est transverse.

**Principes d’implémentation :** `--!strict` quand compatible; pas de logique métier sensible dans un LocalScript; validation de tous les inputs distants côté serveur; pas de boucles infinies non amorties par objet; éviter références client persistantes vers des objets Workspace pouvant être streamés; événements et connexions déconnectables; seeds fixes pour génération déterministe; pas d’effet secondaire à l’import d’un manifeste; idempotence de la régénération; diagnostic lisible avec `place_key`, build SHA, profil et propriétaire.

**Le monde reconstruit** : `WorldBuilder` tente de réutiliser un `KinCityGenerated` existant seulement si l’état, la révision, l’empreinte du plan, le mode, le `KinActivePlace` et la bibliothèque d’assets correspondent. Un patch qui change la géométrie doit invalider le cache via une nouvelle révision du builder. Un échec de résolution d’asset et un fallback ne doivent pas être cachés par un message de réussite globale. L’installateur peut supprimer puis reconstruire `KinCityGenerated` dans la Place de test : faire une sauvegarde préalable.

# 8. TÉLÉPORTATION, ARRIVÉE ET CONTINUITÉ MULTI-PLACE

Le mode `LOCAL_UNIVERSE` déplace localement le Character vers les coordonnées de l’autre intérieur, éventuellement avec `RequestStreamAroundAsync`. Le mode `MULTI_PLACE` utilise `TeleportService:TeleportAsync()` depuis le **serveur**, avec PlaceId résolu dans une liste autorisée. `SPLIT_PREVIEW` peut prévisualiser une Place sans la connecter au réseau publié. Le mode d’installation courant dans KC33 reste `LOCAL_UNIVERSE`, tandis que le générateur de staging remplace les modules de routage pour chaque cible.

**Contrat de transaction d’une porte :** vérifier la position/proximité du joueur et sa zone attendue; respecter le limiteur (`RateLimiter`) et le verrou (`TravelSession`); vérifier `destination_place_key`, `destination_anchor_id` et PlaceId de la même expérience; afficher une transition non mensongère; passer au moteur de téléportation; confirmer à l’arrivée l’ID source et l’ancre attendue via `Player:GetJoinData()`; choisir un spawn de repli si l’information a expiré ou est invalide; revenir à un état contrôlable après erreur, timeout ou respawn. La donnée `TeleportData` peut contenir l’ID source et l’ancre non sensibles mais **aucune donnée sensible ni droit de privilège**, puisqu’elle est visible/manipulable côté client.

**Risques à tester réellement :** appel qui échoue avant le départ, `TeleportInitFailed`, reconnexion, suppression du personnage pendant la transition, requête en double, retour vers la mauvaise façade, ancre masquée sous le sol, boucle de téléportation, statut client trompeur, deux joueurs arrivant simultanément, changements de `PlaceId`, Place non publiée, zone extérieure non répliquée, erreurs en file d’attente. Une réussite `TeleportAsync` du serveur ne prouve pas à elle seule que le joueur voit et parcourt la destination.

**État approuvé** : `idle → prompt → validating → preparing → teleporting → arrived → ready` ou `denied` / `teleport_failed` / `timeout` / `spawn_fallback`. Les opérations de réservation doivent être idempotentes et dédoublonnées. Réutiliser `TravelSession` et `PendingTravel` plutôt que créer une seconde pile de transit dans chaque branche. Ne pas modifier la sémantique du retour `KinLibraryReturn` sans tests bibliothèques.

**Sources officielles Roblox** : https://create.roblox.com/docs/projects/teleport ; https://create.roblox.com/docs/reference/engine/classes/TeleportService . Les téléportations ne sont pas validables en Play Studio : il faut des Places publiées dans une expérience **privée** et tester dans le client Roblox. Les DataStores sont communs aux Places d’une même expérience : https://create.roblox.com/docs/cloud-services/data-stores ; ne pas activer l’accès Studio aux données d’une production vivante.

# 9. FICHES CANONIQUES DES HUIT INTÉRIEURS

La liste ci-dessous est générée à partir du plan compilé KC33 et du programme déterministe `InteriorWings`; ce sont des **constats sur le code**, non des screenshots Studio. Chaque intérieur possède les trois salles du plan canonique (`lobby`, `gallery`, `chamber`) et trois salles d’extension (`west_wing`, `east_wing`, `rear_atrium`). Les extensions ont les mêmes centres locaux dans les huit bâtiments : ouest `(-79,0,7)`, est `(79,0,7)`, atrium arrière `(0,0,76)`; elles sont reliées par quatre passages dont les centres et largeurs sont définis dans `InteriorWings.luau`. Le grand gabarit d’extension dépasse le rectangle de bounds initial des intérieurs (`110×100`), ce qui constitue un **risque de cohérence documentaire/spatiale à mesurer** : le générateur local étend la géométrie, alors que le plan canonique encode des bounds de référence plus petits. Ne pas réduire les ailes sans auditer les salles et les accès.

## 9.1 — Accueil · `city_hall` · B01

**Identifiants immuables :** `building_id=central.city_hall`, `district_id=central`, `place_key=city_hall`; façade `civic.hall.frontage`, intérieur `civic.hall.interior`, seed visuel `2200`. Lieu extérieur : centre `[100, 0, 86]` studs, emprise `[70, 56]` studs, hauteur `29` studs, yaw `49.304` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `city_hall.chamber` | Salle du conseil | `[27, 0, 17]` |
| `city_hall.gallery` | Galerie des services | `[-27, 0, 17]` |
| `city_hall.lobby` | Accueil public | `[0, 0, -29]` |


**Ailes additionnelles générées :** `city_hall.west_wing` — Salle des projets, `city_hall.east_wing` — Salle des assemblées, `city_hall.rear_atrium` — Atrium civique. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.central.city_hall.entry` : `city/city.central.city_hall.front_door` → `city_hall/city_hall.lobby.spawn`; retour `city_hall.exit`.

- **Sortie** `city_hall.exit` : `city_hall/city_hall.exit.door` → `city/city.central.city_hall.return_spawn`; retour `city.central.city_hall.entry`.

- **Interaction métier** `central.city_hall.vote_01` à `hall.kiosk_01` → capacité `smartvote.ballots.browse`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B01 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B01 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.2 — Observatoire EkoH · `ekoh_tower` · B02

**Identifiants immuables :** `building_id=central.ekoh_tower`, `district_id=central`, `place_key=ekoh_tower`; façade `civic.tower.frontage`, intérieur `civic.tower.interior`, seed visuel `2217`. Lieu extérieur : centre `[-110, 0, -16]` studs, emprise `[42, 42]` studs, hauteur `73` studs, yaw `-98.276` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `ekoh_tower.chamber` | Salle d’observation | `[27, 0, 17]` |
| `ekoh_tower.gallery` | Galerie des contributions | `[-27, 0, 17]` |
| `ekoh_tower.lobby` | Accueil | `[0, 0, -29]` |


**Ailes additionnelles générées :** `ekoh_tower.west_wing` — Observatoire EkoH, `ekoh_tower.east_wing` — Galerie du mérite, `ekoh_tower.rear_atrium` — Forum de la connaissance. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.central.ekoh_tower.entry` : `city/city.central.ekoh_tower.front_door` → `ekoh_tower/ekoh_tower.lobby.spawn`; retour `ekoh_tower.exit`.

- **Sortie** `ekoh_tower.exit` : `ekoh_tower/ekoh_tower.exit.door` → `city/city.central.ekoh_tower.return_spawn`; retour `city.central.ekoh_tower.entry`.

- **Interaction métier** `central.ekoh_tower.display_01` à `tower.panel_01` → capacité `ekoh.profile.view`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B02 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B02 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.3 — Grande Bibliothèque · `library` · B03

**Identifiants immuables :** `building_id=konnected.library`, `district_id=konnected`, `place_key=library`; façade `education.library.frontage`, intérieur `education.library.interior`, seed visuel `2234`. Lieu extérieur : centre `[-231, 0, -158]` studs, emprise `[78, 62]` studs, hauteur `24` studs, yaw `-124.371` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `library.chamber` | Salle de lecture | `[27, 0, 17]` |
| `library.gallery` | Galerie des rayonnages | `[-27, 0, 17]` |
| `library.lobby` | Hall des lecteurs | `[0, 0, -29]` |


**Ailes additionnelles générées :** `library.west_wing` — Archives ouvertes, `library.east_wing` — Salle de lecture libre, `library.rear_atrium` — Jardin des connaissances. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.konnected.library.entry` : `city/city.konnected.library.front_door` → `library/library.lobby.spawn`; retour `library.exit`.

- **Sortie** `library.exit` : `library/library.exit.door` → `city/city.konnected.library.return_spawn`; retour `city.konnected.library.entry`.

- **Interaction métier** `konnected.library.bookshelf_01` à `hall.bookshelf_01` → capacité `konnected.catalog.browse`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B03 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B03 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.4 — Université King Klown · `campus` · B04

**Identifiants immuables :** `building_id=konnected.university`, `district_id=uckk`, `place_key=campus`; façade `education.campus.frontage`, intérieur `education.campus.interior`, seed visuel `2251`. Lieu extérieur : centre `[-51, 0, 292]` studs, emprise `[82, 64]` studs, hauteur `31` studs, yaw `-9.907` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `campus.chamber` | Laboratoire pédagogique | `[27, 0, 17]` |
| `campus.gallery` | Salle de cours | `[-27, 0, 17]` |
| `campus.lobby` | Hall du campus | `[0, 0, -29]` |


**Ailes additionnelles générées :** `campus.west_wing` — Laboratoire pédagogique, `campus.east_wing` — Salle d’exploration, `campus.rear_atrium` — Atrium universitaire. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.konnected.university.entry` : `city/city.konnected.university.front_door` → `campus/campus.lobby.spawn`; retour `campus.exit`.

- **Sortie** `campus.exit` : `campus/campus.exit.door` → `city/city.konnected.university.return_spawn`; retour `city.konnected.university.entry`.

- **Interaction métier** `konnected.university.board_01` à `hall.board_01` → capacité `uckk.courses.browse`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B04 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B04 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.5 — Agora Korum · `justice_palace` · B05

**Identifiants immuables :** `building_id=ethikos.justice_palace`, `district_id=ethikos`, `place_key=justice_palace`; façade `civic.justice.frontage`, intérieur `civic.justice.interior`, seed visuel `2268`. Lieu extérieur : centre `[224, 0, -191]` studs, emprise `[76, 56]` studs, hauteur `28` studs, yaw `130.454` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `justice_palace.chamber` | Salle de délibération | `[27, 0, 17]` |
| `justice_palace.gallery` | Salle de consultation | `[-27, 0, 17]` |
| `justice_palace.lobby` | Hall civique | `[0, 0, -29]` |


**Ailes additionnelles générées :** `justice_palace.west_wing` — Salle des témoignages, `justice_palace.east_wing` — Salle de médiation, `justice_palace.rear_atrium` — Atrium de la justice. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.ethikos.justice_palace.entry` : `city/city.ethikos.justice_palace.front_door` → `justice_palace/justice_palace.lobby.spawn`; retour `justice_palace.exit`.

- **Sortie** `justice_palace.exit` : `justice_palace/justice_palace.exit.door` → `city/city.ethikos.justice_palace.return_spawn`; retour `city.ethikos.justice_palace.entry`.

- **Interaction métier** `ethikos.justice_palace.terminal_01` à `hall.terminal_01` → capacité `ethikos.consultation.list`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B05 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B05 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.6 — Atelier Konstruct · `innovation_lab` · B06

**Identifiants immuables :** `building_id=keenkonnect.innovation_lab`, `district_id=keenkonnect`, `place_key=innovation_lab`; façade `innovation.lab.frontage`, intérieur `innovation.lab.interior`, seed visuel `2285`. Lieu extérieur : centre `[-51, 0, -292]` studs, emprise `[76, 60]` studs, hauteur `24` studs, yaw `-170.093` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `innovation_lab.chamber` | Salle de démonstration | `[27, 0, 17]` |
| `innovation_lab.gallery` | Atelier de fabrication | `[-27, 0, 17]` |
| `innovation_lab.lobby` | Accueil projets | `[0, 0, -29]` |


**Ailes additionnelles générées :** `innovation_lab.west_wing` — Atelier de prototypage, `innovation_lab.east_wing` — Galerie des inventions, `innovation_lab.rear_atrium` — Hall de l’innovation. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.keenkonnect.innovation_lab.entry` : `city/city.keenkonnect.innovation_lab.front_door` → `innovation_lab/innovation_lab.lobby.spawn`; retour `innovation_lab.exit`.

- **Sortie** `innovation_lab.exit` : `innovation_lab/innovation_lab.exit.door` → `city/city.keenkonnect.innovation_lab.return_spawn`; retour `city.keenkonnect.innovation_lab.entry`.

- **Interaction métier** `keenkonnect.innovation_lab.desk_01` à `hall.desk_01` → capacité `keenkonnect.projects.browse`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B06 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B06 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.7 — Galerie Konservation · `museum` · B07

**Identifiants immuables :** `building_id=kreative.museum`, `district_id=kreative`, `place_key=museum`; façade `culture.museum.frontage`, intérieur `culture.museum.interior`, seed visuel `2302`. Lieu extérieur : centre `[240, 0, 182]` studs, emprise `[82, 62]` studs, hauteur `24` studs, yaw `52.826` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `museum.chamber` | Galerie temporaire | `[27, 0, 17]` |
| `museum.gallery` | Galerie permanente | `[-27, 0, 17]` |
| `museum.lobby` | Accueil expositions | `[0, 0, -29]` |


**Ailes additionnelles générées :** `museum.west_wing` — Archives du patrimoine, `museum.east_wing` — Galerie des créations, `museum.rear_atrium` — Atrium artistique. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.kreative.museum.entry` : `city/city.kreative.museum.front_door` → `museum/museum.lobby.spawn`; retour `museum.exit`.

- **Sortie** `museum.exit` : `museum/museum.exit.door` → `city/city.kreative.museum.return_spawn`; retour `city.kreative.museum.entry`.

- **Interaction métier** `kreative.museum.panel_01` à `hall.panel_01` → capacité `kreative.exhibits.read`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B07 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B07 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

## 9.8 — Maison Orgo · `orgo_center` · B08

**Identifiants immuables :** `building_id=orgo.admin_center`, `district_id=central`, `place_key=orgo_center`; façade `services.admin.frontage`, intérieur `services.admin.interior`, seed visuel `2319`. Lieu extérieur : centre `[117, 0, -122]` studs, emprise `[72, 56]` studs, hauteur `26` studs, yaw `136.198` degrés. Ces positions ne doivent pas être réinterprétées depuis les noms des salles.


| Salle canonique du plan | Nom affiché | Centre local (studs) |
|---|---|---|
| `orgo_center.chamber` | Salle des opérations | `[27, 0, 17]` |
| `orgo_center.gallery` | Espace dossiers | `[-27, 0, 17]` |
| `orgo_center.lobby` | Accueil administratif | `[0, 0, -29]` |


**Ailes additionnelles générées :** `orgo_center.west_wing` — Salle des opérations, `orgo_center.east_wing` — Bureau communautaire, `orgo_center.rear_atrium` — Atrium des services. Elles restent générées en Luau et non dans les 3 `rooms` compilées du JSON; ne pas les perdre lors d’une séparation des Places.

- **Entrée** `city.orgo.admin_center.entry` : `city/city.orgo.admin_center.front_door` → `orgo_center/orgo_center.lobby.spawn`; retour `orgo_center.exit`.

- **Sortie** `orgo_center.exit` : `orgo_center/orgo_center.exit.door` → `city/city.orgo.admin_center.return_spawn`; retour `city.orgo.admin_center.entry`.

- **Interaction métier** `orgo.admin_center.terminal_01` à `hall.terminal_01` → capacité `orgo.tasks.browse`, fournisseur `stub`; affichage honnête `coming_soon`.


**Livrables B08 :** identité visuelle du lieu, circulation des six salles, vérification d’ascenseur/escaliers et sols, sécurité des passages, recette d’assets, liste de collisions, captures de chaque salle, entrée et sortie documentées, budget mobile et manifeste de branche. B08 **ne peut pas modifier** les ancres de la ville ni la façade extérieure sans proposition acceptée par B09/B10.

# 10. INTERFACES JOUEUR, ACCESSIBILITÉ, PERSONNAGES ET AMBIANCE

**Unification UI :** une seule terminologie pour `place_key` vs nom affiché, transitions, titre du lieu, action « Entrer / Sortir », statut de chargement, erreurs de téléportation, retour à la ville, contenu indisponible. Le changement de Place ne doit pas donner au joueur l’impression de perdre sa progression ou de devoir recommencer une visite. L’état client local est reconstitué depuis le serveur/manifestes après arrivée. Éviter deux HUD superposés lors des retours et des rechargements du personnage.

**Accessibilité :** trajet principal sans obstacle bloquant, prompts visibles hors collision, tailles de texte compatibles téléphone, contraste, alternative au code couleur, navigation clavier/manette, états sonores et visuels alternatifs, animations non éblouissantes. Les ailes latérales et mezzanines doivent posséder un accès réaliste ou un ascenseur fonctionnel; ne pas prétendre qu’un escalier purement décoratif est praticable. Les utilisateurs d’appareils modestes doivent pouvoir se désactiver des effets non essentiels.

**Audio :** préserver les ambiances du répertoire `assets/audio/` et les comportements `KinCityMusicPlayer`, sans importer automatiquement une musique dont l’asset ID n’est pas autorisé. Les fichiers d’inventaire musique mentionnent des IDs à renseigner : ne pas déclarer les 48 musiques fonctionnelles sur la seule base d’une liste CSV. Gérer `SoundService` et la transition entre deux Places pour éviter deux ambiances jouées simultanément. Les autorisations, niveaux, langues et crédits doivent être documentés.

**Personnages / activités :** PNJ de ville et interactions locales ne doivent pas se transformer en API kOA imaginaire. Les scripts historiques de bus/tram/ferry, récits et systèmes multimodaux peuvent rester dans le dépôt sans être invoqués : un agent ne doit pas annoncer leur fonctionnement sans preuve dans le monde actif. Documenter explicitement ce qui est visible, déclenchable, encore mocké ou expérimental.

# 11. BUDGETS, STREAMING ET CHOIX DE PERFORMANCE

**Décision multi-Place = hypothèse à mesurer.** Avantages attendus : limites de réplication, scripts et assets par destination; réduction du monde résident pour un joueur de la ville; isolation des lourds intérieurs. Coûts : nouveau chargement, téléportation sujet à échec, serveurs distincts, coordination de l’état joueur, présence des amis et reconnection UX. `StreamingEnabled` peut déjà réduire une partie de la mémoire du mode à Place unique; la seule distance des intérieurs ne garantit ni réduction GPU ni gain côté serveur. La décision finale doit être basée sur des essais **comparables**.

**Matrice de performances obligatoire :** profil `LITE` sur téléphone d’entrée de gamme, `STANDARD` sur téléphone récent, `SHOWCASE` sur PC adapté; scènes : arrivée ville, hub de chaque couleur, entrée de façade, chacune des six salles, retour, transition répétée, huit joueurs, session longue. Relever appareil, OS, client Studio/publié, réseau, date, build SHA, mode de routage, streaming, FPS médian et p5, mémoire maximale, temps de join, temps de porte aller/retour (p50/p95), crashs, stutters, nombres d’instances/draw et géométrie si disponible. **Ne fixer aucun seuil de conformité arbitraire sans appareil de référence approuvé.**

**Pratiques de réduction :** géométrie simple de collision distincte du décor; pas d’intérieur géant `Persistent` sans raison; angles/LODs cohérents; lumière architecturale locale amortie; sérialisation et réplication minimales; regroupement des instances; textures maîtrisées; streaming robustement pris en charge par le client; traces de performances reproductibles. Examiner le coût de chaque nouvelle recette (y compris modèles réutilisés), pas seulement les objets ajoutés. Documentation : https://create.roblox.com/docs/performance-optimization ; https://create.roblox.com/docs/performance-optimization/design ; https://create.roblox.com/docs/workspace/streaming .

# 12. CONTRATS DE CONTRÔLE QUALITÉ : BARRIÈRE A ET B

**Barrière A (hors moteur, automatiquement vérifiable)** : schémas JSON, IDs uniques, références existantes, symétrie de 16 portes, 49 ancres canoniques, quatre passages d’extension par intérieur, 8 chemins piétons dans le plan, compatibilité des seeds, budgets par profil, recette Art déco vérifiée, compilation déterministe, lint/syntaxe Luau lorsqu’outils disponibles, tests négatifs (ID inconnu, ancre absente, PlaceId absent, ordre inversé, version incompatible), production protégée.

**Barrière B (Studio et client publié)** : inspecter réellement les neuf Places, six couleurs, dix-huit pavillons, huit façades, tous les passages des 48 salles, collisions/portes/escaliers/ascenseurs, lumières/musiques, stabilité d’avatar/respawn, 16 téléportations, arrivée sans blocage, huit joueurs, reprise après erreur, rendus mobile/PC, performances. Test des téléportations **exclusivement dans un client Roblox d’une expérience de staging publiée**, jamais validé par simple Play Studio. Aucune publication en production n’est implicite.

**Gabarit de preuve B** : `{baseline_sha, branch, commit_sha, place_key, studio_version, universe_id_private, place_id_private, date_utc, device_model, platform, client_version, routing_mode, quality_profile, action, expected, observed, result, logs, screenshot_paths, video, reviewer, notes}`. Les IDs privés peuvent être consignés dans un coffre ou un manifeste local non public; ne pas les inclure dans un rapport redistribué si cela expose l’expérience avant sa sortie. Une affirmation sans `observed` et `result` est « NON TESTÉ », pas PASS.

**Tests présents KC33 :** `python tools/validate_catalog.py`, `python tools/validate_spatial.py`, `python tools/compile_plan.py --out <sortie>`, `python -m unittest discover -s tests -v`, plus les outils KC33 `tools/verify_kc33_upgrade.py` et `tools/build_staging_places.py`. La passation KC33 a revendiqué 10 contrôles statiques réussis et 51 tests historiques réussis; certains tests complets n’ont pas pu être exécutés en absence de `lupa`/outils Luau. Vérifier à nouveau les versions et dépendances; ne pas recopier le statut « PASS » comme si les tests avaient été relancés dans une autre session.

# 13. GOUVERNANCE CONCRÈTE DU TRAVAIL PARALLÈLE

**Nommage des dix branches Git/conversations** (suggestion, à confirmer selon l’outil Git réellement utilisé) : `kc34/B01-city-hall`, `kc34/B02-ekoh-tower`, `kc34/B03-library`, `kc34/B04-campus`, `kc34/B05-justice-palace`, `kc34/B06-innovation-lab`, `kc34/B07-museum`, `kc34/B08-orgo-center`, `kc34/B09-integration`, `kc34/B10-city`. Une branche Git et une conversation n’ont pas de synchronisation automatique : il faut explicitement partager les fichiers et changelogs, ou utiliser un dépôt commun et un protocole de pull request.

**B09 = intégrateur/architecte de contrats (source unique de vérité des décisions).** B09 ne doit pas devenir une équipe qui dessine toutes les Places; elle arbitre le référentiel, les builds, le routage, les contrôles, la gestion d’assets communs et les migrations. **B10 = propriétaire de la ville/expérience urbaine**, y compris les huit bâtiments extérieurs, les six secteurs, les routes et les cheminements d’approche. Chaque branche B01–B08 est propriétaire de son intérieur *visuel et spatial* et de ses tests locaux, mais pas de la topologie globale.

**Protocole d’alignement à chaque itération :** (A) B09 publie une baseline figée et un `CONTRACTS_VERSION`; (B) chaque branche accuse réception avec hashes et plan d’impact; (C) branches produisent des changements indépendants; (D) changements de contrats passent par RFC avant implémentation globale; (E) B09 intègre les patchs et exécute la barrière A; (F) tests B en staging, corrections ciblées; (G) B09 publie un nouvel index de release; (H) branches resynchronisent leur base. Une correction urgente de contrat déclenche une nouvelle baseline et une notification explicite à **toutes** les branches, même si une seule Place est touchée.

**Dépôt et chemins autorisés :** chaque branche peut créer ses propres `contrib/places/<place_key>/*`, fichiers de configuration locaux non canoniques, tests spécifiques et documentation. Les fichiers de construction globaux, `WorldBuilder`, `PlayerTravel`, `Spatial`, `src/shared/*`, `catalog/*.json`, `config/*.json`, le générateur de staging et tous les schémas sont des **zones à modification contrôlée par B09**. Les fichiers de façades/voies/secteurs (`CityGenerator`, `KoaliUrbanism`, `DistrictChromatics`, recettes de pavillons et routes) sont des **zones à modification contrôlée par B10**, sous supervision des contrats par B09. Un agent d’intérieur propose des modifications transversales sous forme de patch séparé; il ne les fusionne pas lui-même.

**Trois types de changements :** `LOCAL` (visuel, salles propres à un lieu, sans contrat changé; intégrable après tests), `SHARED` (générateur, palette, budget, UI commune; revue B09 et parties concernées), `BREAKING` (ID, ancre, destination, géométrie canonique, schema_version, sémantique d’état; ADR, migration, compatibilité, version majeure du contrat et approbation). Les changements unilatéraux de type BREAKING sont refusés même s’ils semblent esthétiquement meilleurs.

**Format minimal d’un handoff** : branche, baseline et commit, objet et besoin utilisateur, fichiers ajoutés/modifiés/supprimés, synthèse du diff, contrats touchés, assets ajoutés avec références/licences, comptes géométriques, commandes/tests exécutés avec sorties, captures et mesures, risques et blocages, plan d’annulation, décision B09 requise ou non. Un modèle JSON et un schéma simple sont livrés dans `protocoles/`. L’agent réceptionnaire doit lire le patch et ne pas s’appuyer uniquement sur le texte de conversation.

**Politique de synchronisation recommandée :** point de départ commun hebdomadaire ou à chaque jalon majeur; propositions RFC au fil de l’eau; synchronisation obligatoire après toute fusion SHARED; revue de contrat avant intégration; publication de versions staging seulement lors des fenêtres de qualification et après autorisation humaine. Aucun agent ne doit réinitialiser sa Place pour résoudre un simple conflit de fichiers.

**Arbitrage des conflits :** (1) préserver le contrat existant; (2) détecter le propriétaire logique; (3) documenter options, coût performance et effets transversaux; (4) B09 choisit ou escalade au propriétaire humain; (5) fournir patch de migration; (6) rejouer tests canoniques et de l’autre branche; (7) créer ADR. Interdit : forcer un merge qui « passe » en changeant des tests ou en renommant silencieusement un `anchor_id`.

# 14. STAGING, INSTALLATION, PUBLICATION ET ROLLBACK

**Avant toute action de construction :** conserver une copie de KC33, un snapshot `.rbxl` privé de la Place cible, le hash canonique, les sources des assets et la procédure de retour arrière. Le mode local demande PlaceId 0, Play arrêté et `Workspace.StreamingEnabled`; l’installateur local n’est pas un outil de publication. Il ne contient pas les modèles commerciaux; il exige les 121 imports autorisés.

**Préparation multi-Place :** créer une **nouvelle expérience privée staging** contenant neuf Places publiées dans la même expérience; obtenir leurs vrais PlaceIds via Roblox; remplir exactement `config/place_ids_staging.TEMPLATE.json` dans une copie de staging (jamais la config canonique de production); utiliser `tools/build_staging_places.py --ids <json> --out <dossier>`; déposer les 121 sources sous licence dans chaque Place selon le workflow; vérifier `KinArtDecoTestPlace=true` et `StreamingEnabled`; appliquer uniquement le script dédié à la Place cible. Ce générateur refuse explicitement l’ID de production fixé par KC33 et les doublons, mais il ne peut pas prouver seul que tous les identifiants appartiennent bien à la même expérience : cette vérification doit être effectuée humainement.

**Tests de sortie :** inspecter que B10 ne possède **aucun** intérieur dans son `Workspace`, et chaque B01–B08 un seul intérieur sans la ville extérieure; vérifier runtime actif et révision; tester les 16 portes dans le vrai client, tous les spawns, la conservation des interactions, la capacité à retourner en ville et la déconnexion. Ne pas exploiter la Place de production avant la barrière B et la décision de performance.

**Rollback sûr :** si un build échoue avant suppression, ne rien effacer; après échec d’installation, restaurer la sauvegarde de la Place de staging et la révision précédente de ses scripts/assets; restaurer le manifeste de routage associé aux mêmes PlaceIds; ne pas fusionner des modules de différentes générations. Pour une publication, garder les versions de Places et mécanisme de retour arrière connus. Il ne faut jamais « rollback » la production avec un ancien installateur sans évaluer sa compatibilité et obtenir autorisation.

# 15. DÉCISIONS ET RISQUES À SOUMETTRE AU PROPRIÉTAIRE


| ID | Décision ouverte / risque | Conséquence potentielle | Pilote |
|---|---|---|---|
| R01 | Seuil et bénéfice du mode MULTI_PLACE non mesurés | On pourrait échanger de la mémoire contre une UX de téléportation pénible | B09 |
| R02 | Neuf PlaceIds réels et univers staging non encore créés | Pas de test de transfert publié possible | Propriétaire+B09 |
| R03 | Écart entre 3 salles planifiées et 6 construites (InteriorWings) | Bounds/QA du plan incomplets; risque de suppression involontaire | B09+B01–B08 |
| R04 | IDs historiques `konnected.university` vs secteur UCKK | Renommage naïf casserait les portes/routages | B09+B04+B10 |
| R05 | Maison Orgo rattachée `central` + hub spatial Orgo non listé comme secteur | Confusion d’affichage / zonage si une IA invente un 7e secteur | B09+B08+B10 |
| R06 | 80 modèles Art déco non configurés | Qualité visuelle / poids inutile si intégration sans curation | B09+B10 |
| R07 | Voirie véhicules et transports historiques non activés | Risque de promesses fonctionnelles trompeuses | B10 |
| R08 | Couleurs parfois masquées par les surfaces; blanc faible contraste | Orientation difficile en vrai jeu | B10 |
| R09 | Droits/présence des 121 imports par Place non vérifiés | Manques, échec installateur ou non-conformité licence | B09 |
| R10 | Absence de qualification Luau/Studio/mobile complète | Régressions et crashs possibles | B09+tous |
| R11 | Propriétés partagées modifiées par plusieurs IA | Dérive et merges contradictoires | B09 |
| R12 | Modules historiques présents mais inactifs | Confusion entre prévu et réellement fonctionnel | B09+B10 |


**Clarification R06** : le chiffre exact est 80 modèles `library_only` sur 121 en KC33. Tout autre nombre doit être recalculé depuis le manifeste et non deviné.

# 16. ORDRE D’EXÉCUTION RECOMMANDÉ — QUATRE VAGUES

**Vague 0 — fondation commune, B09 prioritaire :** verrouiller baseline et hash, résoudre les incohérences d’inventaire sans renommer les clés, fixer schémas de handoff, créer le validateur interbranches, préparer univers staging privé si le propriétaire fournit les accès/IDs, fiabiliser tests complets hors Studio. B10 établit le guide de raccord façade-porte et repère des six secteurs.

**Vague 1 — huit intérieurs en parallèle :** B01–B08 construisent leur « vertical slice » — hall + passage + salle signature + porte sortie, puis complètent les six salles, les ornements, interactions et tests locaux. B10 travaille les voies, huit façades et palettes, sans toucher au routage canonique. B09 contrôle la dette transverse et centralise les demandes.

**Vague 2 — intégration neuf Places :** les neuf installateurs sont générés pour un vrai univers de staging, chaque Place reçoit sa révision, on joue les 16 portes, les 48 salles, les six secteurs et les échecs réseau. On compare performance LOCAL_UNIVERSE + streaming contre MULTI_PLACE selon protocole identique. On corrige seulement les faits observés.

**Vague 3 — finition et publication contrôlée :** tests mobile et multijoueur, audit UI/sons/licence, rapport PASS/FAIL par Place, manuel de rollback, décision humaine sur l’architecture retenue, publication après approbation expresse. Les 80 modèles supplémentaires ne sont ajoutés qu’en fonction des besoins démontrés.

# 17. CONDITIONS DE DÉFINITION DE « TERMINÉ »

Une branche est **développée** si son code et ses ressources sont dans une remise versionnée et que ses tests locaux sont documentés. Elle est **intégrée** si B09 a fusionné le patch avec la baseline commune, qu’aucun contrat n’a changé sans version et que la barrière A passe. Elle est **qualifiée** seulement lorsque ses parcours réels en Studio/client publié ont des preuves et satisfont les critères approuvés. Elle est **publiable** quand les neuf Places, les seize portes, les 48 salles, les six couleurs, les huit façades, les licences, le rollback et les budgets sont vérifiés et approuvés.

Chaque agent doit finir son rapport par quatre rubriques clairement séparées : **Réalisé**, **Tests réellement exécutés**, **Non testé / risques**, **Demandes B09 et prochaines étapes**. Si le travail est partiel, livrer les patchs réalisés sans faire croire que la Place est validée.

# 18. PREMIER PROTOCOLE DE DÉMARRAGE DES DIX CONVERSATIONS

1. Donner au responsable B09 le ZIP KC33 et ce pack documentaire; lui demander d’annoncer baseline et version de contrat, de créer un tableau unique de révisions et de recevoir les remises.
2. Créer les conversations B01 à B08 avec le ZIP KC33, ce référentiel et **leur** fiche `.md` de `branches/`; chacune ne travaille qu’à son `place_key`.
3. Créer la conversation B10 avec le ZIP KC33 et `branches/B10_city.md` pour la Place centrale.
4. Après chaque passe, déposer le diff/ZIP modifié, le handoff JSON et les résultats de tests dans B09. B09 répond avec état `ACCEPTED`, `CHANGES_REQUESTED` ou `BLOCKED`, une version de base et la liste des branches à resynchroniser.
5. Redémarrer une conversation avec la **nouvelle baseline intégrée**; ne jamais poursuivre pendant des semaines à partir d’un ZIP obsolète en supposant que les autres branches ont été synchronisées.

# ANNEXE A. SOURCES OFFICIELLES ET LOCALES

Sources du dépôt KC33 : `docs/00-fondations/invariants.md`, `docs/03-contrats/portes.md`, `docs/07-construction/{specification-spatiale,strategie-places,performance-et-budget,qualification-industrielle,architecture-code-luau,protocole-build-vibe-coding}.md`, `docs/04-ingenierie/art-deco-ville-et-interieurs-v3.md`, `RAPPORT_KC33.md` et les fichiers énumérés dans `contrats/empreintes_kc33.json`.

Documentation officielle Roblox : https://create.roblox.com/docs/projects/teleport ; https://create.roblox.com/docs/reference/engine/classes/TeleportService ; https://create.roblox.com/docs/workspace/streaming ; https://create.roblox.com/docs/performance-optimization ; https://create.roblox.com/docs/performance-optimization/design ; https://create.roblox.com/docs/cloud-services/data-stores . Ces règles peuvent évoluer : B09 revérifie les APIs et les conditions de test lors d’une publication.

**Fin du document normatif KC34-DOC-1.0.**

