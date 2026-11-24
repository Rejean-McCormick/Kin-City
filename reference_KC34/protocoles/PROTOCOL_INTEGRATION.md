# PROTOCOLE D’INTÉGRATION — 10 branches / 9 Places (KC34-DOC-1.0)

**Source de vérité :** `BIBLE_KINCITY_REFERENCE_IA_KC34.md` + `contrats/index_machine.json` + le ZIP KC33.  
**B09 tranche les conflits techniques; le propriétaire autorise les changements de produit et la production.**

## Sémantique des branches
- B01–B08 : intérieurs indépendants (un `place_key` et un bâtiment par branche).
- B09 : revue, versions des contrats, outils partagés, sécurité, tests, génération des neuf installateurs, releases. **Aucune Place Roblox propre à B09.**
- B10 : `city` et ses six secteurs, voirie, 18 pavillons, 8 façades, identité chromatique. C’est la **neuvième Place Roblox**.

## Garde-fou de version
Une PR déclare `baseline_sha`, `contracts_version`, `manifest_version` et `file_hashes`. Une PR qui modifie `catalog/`, `config/`, `src/shared/`, `WorldBuilder`, `PlayerTravel`, `Spatial`, `ArtDecoBudget`, `tools/build_staging_places.py` doit être traitée comme SHARED ou BREAKING jusqu’à démonstration contraire. Toutes les dépendances locales à des clés historiques restent inchangées sans ADR.

## Cadence
1. B09 annonce le jalon commun, le ZIP de référence et les hashes.
2. Chaque branche produit `plan-impact.md` puis le code et les tests.
3. Toute demande SHARED passe par `RFC-<num>.md` avec impact et partenaires (en particulier B10 pour les façades/portes).
4. B09 reçoit les handoffs, exécute tests A et vérifie compatibilité croisée.
5. B09 génère une release candidate **staging uniquement**; B01…B08 + B10 fournissent les preuves B.
6. Une release ne remplace la baseline qu’après revue + approbation humaine explicite pour publication éventuelle.

## RACI
| Sujet | Responsable construction | Décideur technique | Validation nécessaire |
|---|---|---|---|
| Une salle / mobilier d’une institution | B01…B08 correspondant | B09 si impact transverse | Branche + B09 |
| Une façade / rue / secteur | B10 | B10 + B09 sur contrats | B10 + B09 |
| Porte / ancre / PlaceId / téléport | B09 | B09 + propriétaire si rupture | B09 + deux branches |
| Générateur Luau commun / bibliothèque Art déco | B09 | B09 | Branches utilisatrices |
| Conformité artistique transverse | B10 avec B09 | Propriétaire pour changement identitaire | B09 + branches |
| Sécurité déploiement / release | B09 | Propriétaire | B09 + tests client publiés |

## Contrat de remise minimum
`branch_id`, `place_key`, `baseline`, `commit`, `contract_changes`, `changed_files`, `tests_executed`, `tests_not_executed`, `evidence`, `assets`, `performance`, `risk`, `rollback`, `needs_approval`. Voir `handoff_modele.json` et le script `valider_handoff.py`.

## Critères automatiques d’acceptation
- La branche a la bonne Place; aucune `place_key` inventée.
- `doors.json` conserve 16 portes symétriques, sauf RFC versionnée explicitement acceptée.
- Le graphe de destination est autorisé et aucune ID de porte canonique n’est remplacée sans migration.
- Le status de test reflète les preuves et ne marque jamais « PASS » lorsqu’il est `not_executed`.
- Les éléments manquants et le rollback sont présents, même pour un patch partiel.

## Déroulé d’une anomalie interbranche
Exemple : B04 veut aligner l'entrée UCKK et propose de changer `city.konnected.university.entry`. B04 **ne renomme pas l’ID**. Elle dépose RFC avec ancre avant/après, impact B10, migration et tests. B09 tranche. Les noms visibles peuvent être actualisés sans changer la clé stable.

## Règle de publication
Aucun agent ne possède l’autorité de publier la production. La création et la publication de neuf Places staging demandent des identifiants réels et l’intervention d’un opérateur habilité. Le succès d’un générateur d’installateurs n’est pas un test de TeleportService.
