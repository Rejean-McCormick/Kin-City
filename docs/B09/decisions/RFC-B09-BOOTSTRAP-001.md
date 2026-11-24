# RFC-B09-BOOTSTRAP-001 — Démarrage du contrôle interbranches

**Statut :** PROPOSÉ À L'APPROBATION DU PROPRIÉTAIRE POUR ADOPTION ORGANISATIONNELLE.  
**Auteur :** B09.  
**Version de référence :** `KC34-DOC-1.0`.

## Proposition
Ajouter uniquement les outils Python B09, les manifestes de contribution, les tests, la CI et la documentation. Les 23 sources contractuelles du moteur KC33 restent byte-à-byte identiques, notamment `WorldBuilder`, `PlayerTravel`, `Spatial`, les catalogues et la compilation du plan.

## Compatibilité
Pas de changement de PlaceId, route, ancre, porte, couleur ou expérience publiée. Le format déclaratif de recette est **non raccordé** à l'exécution Roblox. Aucune nouvelle création d'Instance par les modules B09.

## Preuves
Voir `docs/B09/reports/` : hashes, recompile, 20 tests B09, génération provisoire de neuf installateurs. Tous les tests runtime Roblox et la publication sont non réalisés. L'ancien jeu de tests dépendant de `lupa` ne s'importe pas dans l'environnement de livraison.

## Évolution proposée
Après réception d'un premier handoff réel d'une branche, rédiger une RFC séparée pour le loader Luau de recette, l'export dans les installateurs, l'API du budget et le protocole de rollback. Aucun branchement automatique dans KC34-B09 initial.

## Décision
B09 autorise l'usage du référentiel comme outil de coordination **hors moteur**, sous réserve de l'approbation du propriétaire avant changement de runtime ou publication staging.
