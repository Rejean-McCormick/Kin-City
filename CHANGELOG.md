# Changelog

## v30.0.7
- correction des portes encombrées : surface interactive quasi invisible au lieu d'un bloc apparent
- dégagement central sur les façades `civic_stone` et `warm_academic` pour éviter les piliers devant les portails
- signalétique de seuil remontée et affinée pour garder l'ouverture lisible
- nouvel installateur univers complet régénéré

## v30.0.7 — finalisation typographique
- même mécanisme Garamond → Bodoni pour toutes les interfaces et pancartes
- résolution des polices natives sans évaluer de police potentiellement absente avant le repli
- univers complet et installateurs séparés reconstruits

## v30.0.7 — lisibilité des pancartes
- typographie serif pour les enseignes (`Garamond` si disponible, sinon `Bodoni`) avec liseré de lecture
- panneaux extérieurs agrandis et moins aplatis verticalement
- enseignes principales avancées et relevées pour éviter les marquises, corniches et éléments décoratifs devant le texte

## v30.0.7 — déplacement local des PNJ

- Parcours PNJ à plusieurs haltes par quartier, attribués aux 36 citoyens procéduraux, 14 R15 urbains et 12 résidents.
- Trajets calculés par PathfindingService et restreints aux six quartiers existants; blocage si obstacle ou destination inaccessible (pas de téléportation à travers le mobilier).
- Détection de collision additionnelle Blockcast pour les figurines ancrées.
- Aucun changement aux huit intérieurs et à l'éclairage réduit à 65 %.

## v30.0.0 — navigation lisible et interface accessible

- Recherche d’outils et de lieux, huit institutions en priorité, destination effaçable.
- Distance suivant le chemin public quand il existe, indication directe sinon.
- Guides mutuellement exclusifs et masquage volontaire du parcours bibliothèque.
- Meilleure gestion des focus manette, du défilement et des tailles mobiles.
- Sortie de panorama plus sûre, mesure FPS locale interruptible et actualisée moins souvent.
- Installateurs régénérés ville + huit Places + local tout-en-un; sans nouveau PlaceId.

# Version 25.0 — finition des quartiers, matériaux PBR, diagnostic de construction

- 57 bâtiments secondaires ciblés par `SecondaryArchitectureV25`.
- Trois OBJ originaux supplémentaires; 11 familles réutilisables avec fallback natif.
- Bibliothèque Studio de 4 matériaux PBR facultatifs.
- Harmonisation opaline des vitrages de halls, commerces et ateliers maritimes.
- Métadonnées de build et commande de diagnostic dans Studio.
- Génération déterministe et 61 tests hors Roblox (pas de test en moteur).

---

# Historique de Kin City

## v24.0.0 — Bibliothèque 3D Studio, scènes institutionnelles et parterres
- Enregistrement facultatif de `MeshPart` Studio dans une bibliothèque persistante, utilisée par tous les générateurs concernés.
- Rendu hybride import local > AssetId configuré > génération native.
- Huit groupes de façades artistiques, nouvelles alcôves sur les salles intérieures, huit parterres autour des institutions.
- Trois meshes OBJ originaux supplémentaires et mise à jour de la release et des tests.
- Aucune connexion kOA, ni publication automatique, ni mécanisme de rollback.

## v23.0.0 et avant
Voir `LIVRAISON_V23.md` et les rapports `LIVRAISON_V*.md` conservés.

## v26.0.0 — Rupture entre le monde extérieur et les huit grandes institutions

- Neuf packages Studio autonomes : une Place pour la ville et huit Places de grands intérieurs. Aperçus indépendants sans PlaceIds fictifs.
- Mode `MULTI_PLACE` publifiable avec les neuf véritables PlaceIds, validation de l'identité de Place, des ancrages et des portes aller/retour.
- Déclenchement sélectif des services : PNJ, transports et ambiance urbaine absents des serveurs intérieurs.
- UI adaptée au contexte et portails sarcelle-cristal sans collision, avec message clair en attente de publication.
- Manifeste des neuf packages, diagnostic Studio de leur isolation, ancien univers local disponible comme secours explicitement séparé.
- Aucun réseau kOA activé; aucun mécanisme de rollback ajouté.
