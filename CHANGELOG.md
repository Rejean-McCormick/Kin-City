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
