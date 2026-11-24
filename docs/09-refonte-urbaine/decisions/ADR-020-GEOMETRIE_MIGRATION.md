# ADR-020 — Migration des transformes sans changement des IDs

**Statut : PROPOSÉ (KC36)**

Les positions KC35 font partie du contrat existant mais ne sont pas une vérité esthétique. Une refonte doit permettre les **nouveaux** transforms approuvés tout en conservant `building_id`, `place_key`, `door_id`, `anchor_id` et `interaction_id`.

Processus : `ApprovedSitePlan(KC36)` + plan avant/après + mises à jour de l'ensemble dépendant (façade, trottoir, parvis, portails, arrivée de porte, chemin piéton, éclairage/enseignes) + migration explicite + revue B09/B10 + QA Studio. Aucun fichier canonique ancien n'est réécrit silencieusement : la nouvelle révision remplacera le plan courant uniquement après approbation.
