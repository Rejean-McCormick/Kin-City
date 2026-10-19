# Qualification industrielle — deux barrières distinctes

## Barrière A — plan statique, automatisable hors Roblox
**Commandes réelles fournies** : `python tools/validate_catalog.py`, `python tools/validate_spatial.py`, `python tools/compile_plan.py --out build/world-plan.json`, `python -m unittest discover -s tests -v`.

Le pipeline valide : schémas, existence réelle des templates dans le registre (pas seulement chaîne de caractères), styles, dimensions, collisions conservatrices, graphe de circulation entre pièces, coordonnées d'ancres, référentiels de messages, IDs uniques, retours symétriques et invariants `WORLD_STUB`. Les tests négatifs mutent délibérément une référence d'asset et une ancre pour vérifier que le validateur **échoue**.

Un `0 erreur` de cette barrière signifie **uniquement : les sources de plan sont cohérentes et le compilateur de référence a produit un IR déterministe**.

## Barrière B — moteur, application publiée, performance
**Non exécutée par ce dépôt documentaire** : génération `.rbxl`, mode serveur-client, simulation de téléphones/manettes, inspection visuelle, performances matérielles, qualité des collisions, navigation avatar, deux joueurs concurrents, portes retour, publications privées, téléportations dans le client réel.

La livraison exige un compte-rendu daté par Place avec : UniverseId, PlaceIds, version Roblox Studio, révision du jeu, appareil/OS, résultats d'entrée et de sortie, UI stub, mémoire, FPS, erreurs de scripts et captures d'écran validées. Aucun nombre cible de FPS ou de mémoire ne sera présenté comme mesuré sans profil matériel et mesure réelle. Définir les budgets après la première mesure et les approuver avant la publication finale.

## Matrice d'acceptation — minimum
| ID | Preuve attendue | Barrière |
|---|---|---|
| A01 | JSON et JSON Schema valides | A |
| A02 | Tout template/fourniture connu et provenance/licence explicite | A |
| A03 | Toutes les ancres localisées et dans leur géométrie | A |
| A04 | Aucun bâtiment ne chevauche une autre enveloppe conservatrice | A |
| A05 | Plan canonique reproductible SHA-256 | A |
| A06 | Test négatif asset inexistant refusé | A |
| A07 | Mode STUB refuse réseau kOA et mutations métier | A+B |
| B01 | Ville parcourable, orientation, rues, signalétique, accès | B |
| B02 | Chaque intérieur riche accessible par sa porte | B |
| B03 | Chaque sortie retourne au bon bâtiment | B |
| B04 | Chaque objet affiche « Fonctionnalité à venir » | B |
| B05 | Fréquence d'images/mémoire conformes aux budgets mesurés | B |
| B06 | Aucun prompt déclenché à distance ni spam serveur | B |
| B07 | Interruption réseau ou échec de téléport sans blocage | B |
| B08 | Compatibilité mobile, clavier et manette | B |

Toute qualification B exige **des preuves du client Roblox réel**; un simulateur ou le code ne remplacent pas le test de téléportation publié.

## Limites de publication
L'API Place Publishing peut mettre à jour des Places publiés mais ne met pas à jour certains types comme `EditableMesh`, `EditableImage`, `PartOperation`, `SurfaceAppearance`, `BaseWrap`. Pour ces éléments, il faut prévoir publication depuis Studio selon la documentation actuelle. https://create.roblox.com/docs/cloud/guides/usage-place-publishing
