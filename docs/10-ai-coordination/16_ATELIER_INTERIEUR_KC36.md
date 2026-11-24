# KC36 — Atelier intérieur d'objets entiers

## État livré : code et installateur ; non encore validé en Play chez le propriétaire

Responsabilité : B09 (API/persistance/sécurité), B01–B08 (mobilier non interactif des institutions). B10 ne possède pas les intérieurs. Aucun changement à la bibliothèque Art déco centrale (121 sources).

## Expérience

Depuis un intérieur de Kin City, le propriétaire ouvre **ATELIER • Modifier l'intérieur** dans le menu. Activer **SÉLECTION**, cliquer/toucher un meuble, puis **DÉPLACER**, **ROTATION**, **DUPLIQUER** ou **EFFACER**. La suppression nécessite deux clics. **ANNULER** et **RÉTABLIR** portent sur l'historique de la Place. Téléphone et manette : sélection tactile ou R2 ; les commandes disposent de boutons.

Cette première passe adopte le principe d'un éditeur de construction LEGO Worlds, sans prétendre reproduire toutes ses fonctions : manipulation par grille **0,5 stud**, duplication et effacement d'objets entiers. La gomme de terrain, le pinceau libre, le redimensionnement des modèles et le placement à la souris avec silhouette fantôme ne sont pas implémentés.

## Frontière de sécurité

- L'éditeur est réservé au propriétaire défini par `KinCityRuntime.KinCityBuildOwnerUserId`, sinon le créateur de l'expérience si elle appartient à une personne (expériences de groupe : définir explicitement l'attribut).
- Le joueur doit être **physiquement proche** de l'objet (65 studs) et dans le bon `KinZone`. Un client ne transmet jamais une position absolue acceptée sans validation.
- **Uniquement des meubles non interactifs canoniques** marqués `KinFurnishingId`/`KinAssetId` (`prop.bench`, `prop.planter`, `prop.table`, `prop.bookshelf`, `prop.lamp`, `prop.board`, `prop.panel`, `prop.display`), situés à l'intérieur des huit modèles d'institution. Si un meuble comporte une ancre, un ProximityPrompt, un script, un siège, un Humanoid ou un attribut protégé, il est **exclu**.
- Modèle complet = sélection, transformation, copie et suppression **du Model**, et non des pièces individuelles.
- Les éléments sont maintenus dans leur salle selon la géométrie de `WorldPlan.places[*].rooms`, avec marge. Les volumes des autres meubles éditables ne doivent pas se chevaucher. L'éditeur ne supprime ni les murs/planchers, ni les portes, ni les points de retour, ni les interactions, ni les PNJ. L'éditeur ancien `PlayerBuildServer` exclut maintenant complètement `Bâtiments visitables` afin de ne pas contourner cette protection.
- Les duplications se font à une des quatre positions candidates autour du meuble, sans superposition de meubles éditables. Maximum 100 copies et 400 opérations par Place. Ces limites exigent une opération future de compactage/export si atteintes.

## Persistance

DataStore indépendant `KinCity_InteriorEditorV36_v1`, clé `place_<PlaceId>`, valeur `{version=1,cursor,actions}`. Rejoue chronologiquement déplacements, rotations, duplications et effacements après chaque reconstruction du monde. Opérations réversibles et limitées, autosauvegarde 10 secondes après une commande et sauvegarde dans `BindToClose`. Si DataStore est inaccessible (Studio API disabled), les changements ne persistent pas et l'interface affiche un avertissement. Les anciennes données de `KinCity_Koali_PlayerBuild_v1` ne sont pas écrasées.

### Déploiement

1. Sauvegarder la Place principale dans Studio. Arrêter Play.
2. Installer `tools/studio/KC36_INSTALL_ATELIER_INTERIEUR_RS.luau` depuis la Command Bar (Place principale uniquement).
3. Vérifier `PASS KC36 ATELIER INTERIEUR INSTALLE`, sauvegarder, Play, ouvrir une institution non fermée, choisir un meuble simple.
4. Vérifier sélectionner → déplacer → annuler → refaire → dupliquer → effacer → annuler. Tester ensuite une porte, un plancher ou un terminal : refus attendu.
5. Rejoindre la Place après publication, puis vérifier restauration via DataStore en production, avec le propriétaire ; ne pas interpréter les échecs DataStore de Studio comme un échec en production.
6. Publier la même Place existante après validation. Ne pas réinstaller la ville.

### Compatibilité / risques

Le client `KinCityUI` lance `InteriorEditorClientV36` après le client historique. Le serveur lance `InteriorEditorV36` après l'éditeur historique, sans modifier `WorldBuilder`, les portes, les PNJ, la musique ou les assets. Le propriétaire doit voir les **deux menus**, l'ancien reste réservé au décor extérieur. Si aucun meuble ne s'affiche dans une institution, vérifier le nombre de modèles admis annoncé dans Output (les ancres/prompts sont exclus intentionnellement).

Le replay DataStore est un journal d'opérations ; les repositionnements majeurs des mobiliers ou les changements de `furnishing_id` nécessitent une migration B09. Les contrôles hors Studio ne prouvent pas la jouabilité dans la Place publiée.

### Retour arrière

La commande sauvegarde trois sources (`KinCityRuntime`, `KinCityUI`, `PlayerBuildServer`) dans `ServerStorage.KC36InteriorEditorBackup_v1`. Les nouveaux modules peuvent être retirés et ces sources restaurées en mode Édition. Les données de l'atelier restent dans son DataStore indépendant (aucune destruction de données lors d'un retour arrière de scripts).
