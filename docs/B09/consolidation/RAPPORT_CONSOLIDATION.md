# KC34 — Consolidation B09 de KinCity_BXX.zip
**Statut : consolidation du code source, NON intégrée dans la génération Roblox, NON publiée.**

Archive utilisateur SHA-256 : `4ca330d20fac04c72cb6e66352b133b5bc271bfefb468327b18ebe28e65bae69`. Baseline B09 : `KC33`, contrats `KC34-DOC-1.0`.

| Branche | Place | Fichiers | Tests Python hors moteur | État initial | État B09 actuel |
|---|---|---:|---|---|---|
| B01 | `city_hall` | 14 | Ran 18 tests in 0.007s | READY_FOR_REVIEW | BLOCKED_FOR_RUNTIME_AND_B09_REVIEW |
| B02 | `ekoh_tower` | 14 | Ran 20 tests in 0.007s | BLOCKED | BLOCKED_AS_DECLARED_BY_AUTHOR_AND_RUNTIME |
| B03 | `library` | 7 | Ran 19 tests in 0.010s | BLOCKED | BLOCKED_AS_DECLARED_BY_AUTHOR_AND_RUNTIME |
| B04 | `campus` | 8 | Ran 12 tests in 0.003s | READY_FOR_REVIEW | BLOCKED_FOR_RUNTIME_AND_B09_REVIEW |
| B05 | `justice_palace` | 9 | Ran 12 tests in 0.004s | READY_FOR_REVIEW | BLOCKED_FOR_RUNTIME_AND_B09_REVIEW |
| B06 | `innovation_lab` | 7 | Ran 10 tests in 0.012s | READY_FOR_REVIEW | BLOCKED_FOR_RUNTIME_AND_B09_REVIEW |
| B07 | `museum` | 0 | NOT_AVAILABLE | MISSING_SUBMISSION | EN ATTENTE |
| B08 | `orgo_center` | 8 | Ran 16 tests in 0.014s | BLOCKED | BLOCKED_FOR_KC33_REBASE_AND_RUNTIME |
| B09 | `integration` | 0 | 20 PASS | INTEGRATION_CONTROLLER | Contrôle B09 |
| B10 | `city` | 10 | Ran 17 tests in 0.003s | READY_FOR_REVIEW | BLOCKED_FOR_RUNTIME_AND_B09_REVIEW |

## Constat et décisions d’intégration
1. **Huit contributions reçues (B01–B06, B08, B10)** : leurs SHA-256 de fichiers concordent tous avec leurs handoffs; chaque fichier est dans le namespace attendu. Aucun conflit entre deux branches sur un fichier source; seuls certains `README.md`/`recipe.json` remplacent les placeholders B09.
2. **B07 absente** : conserver `contrib/places/museum/recipe.json` placeholder. Aucun musée réalisé ou intégré par cette passe.
3. **B08 baseline V3 originale** : fichiers conservés dans `contrib/places/orgo_center/` à titre de **candidate de rebase B09**. Son handoff original demeure inchangé et **non conforme KC33**. Tests locaux hors moteur passent lorsqu’ils pointent le contenu KC33. Le plan `asset_plan.json` désigne `AD_Int_Mirror_Sunburst` comme `library_only`, mais ce modèle est `configured` dans KC33 : métadonnée historique à actualiser par B08/B09 après RFC. Aucun loader n’est activé.
4. **B06 dépendance V3** : ses tests se sont exécutés sur son fichier `BASE_KINCITY_V3_ORIGINAL.zip` embarqué, et non sur KC33. Une vérification de la recette sur les fichiers KC33 est encore requise malgré la conformité du handoff.
5. **B02 et B03** se déclarent BLOCKED : leurs fichiers sont visibles dans l’arborescence de travail pour revue, mais aucune décision B09 ne les promeut en runtime.
6. **Les neuf `recipe.json`** sont valides sur schéma B09 après consolidation. Elles ne sont **pas** chargées par `WorldBuilder` : seule une RFC d’API de loader + tests Roblox permettra leur activation.
7. **Le noyau KC33 est intact** : aucun fichier verrouillé (`catalog/`, `config/`, modules Luau canoniques) modifié ; les 16 portes/49 ancres/24+24 salles du contrat restent inchangées.

## Contrôle et limitations
Le rapport de compilation et les sorties des tests se trouvent dans `docs/B09/consolidation/` et `docs/B09/reports/`. Les tests Python valident les manifestes, IDs, positions attendues, générateurs hors moteur et invariants. **Ils ne constituent ni compilation Luau par Roblox Studio, ni mesure de FPS, ni preuve de téléportation ni approbation de publication.**

## Suite requise
- Faire livrer B07 et son handoff KC33.
- Régulariser officiellement le handoff B08 sur baseline KC33, rapprocher les valeurs d’assets historiques et revalider les collisions/ancres.
- Faire exécuter les tests B06 directement sur le projet KC33 plutôt que sur l’archive V3 embarquée.
- Faire approuver les RFC de loader par B09 ; définir un adaptateur commun pour les signatures Luau hétérogènes, le budget d’assets, les profiles et les remontées d’erreur.
- Faire une vérification Studio sur une Place locale de test, puis une campagne multi-Place avec neuf vrais PlaceIds d’un seul univers staging privé ; mesurer performances mobile/PC et transitions.
- N’activer aucun installateur en production et maintenir les placeholders comme retour arrière possible.


## Résultats finaux des tests après consolidation

**8 suites de branches redémarrées contre les fichiers livrés : 124 tests exécutés, tous OK.** B05 a été relancée avec la variable de chemin source correcte, et les deux tests initialement ignorés ont été exécutés dans la reprise finale. **B06 utilise encore son archive V3 d'origine pour ses tests**, ce qui n'est pas une preuve de compatibilité KC33.

**B09 + tests de consolidation : 30/30 OK.** L'analyse des 23 fichiers verrouillés et de l'empreinte du monde recompilé est cohérente. Suite historique globale `unittest` : 85 tests comptés, quatre modules refusés à l'import faute de `lupa`; voir les logs bruts pour les résultats exacts. **Tests Roblox Studio et téléports : non exécutés.**

L'archive de consolidation contient les huit ZIP de branche originaux sous `inputs/branch_archives/` afin de rendre la reprise des tests autoportante. Le ZIP de base B09 est représenté par son arborescence complète extraite; l'empreinte de l'archive source est consignée dans les reçus.
