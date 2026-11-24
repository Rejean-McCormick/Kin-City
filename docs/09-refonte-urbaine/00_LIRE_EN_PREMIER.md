> **MISE À JOUR 27/10/2026** — La passe [`09_KC36_IMPLEMENTATION_ALIGNEMENT_1.md`](09_KC36_IMPLEMENTATION_ALIGNEMENT_1.md) code désormais certaines corrections ciblées (fondation Y=0.32, panneaux EkoH, B10 physique, dallage d'avenue). Le reste de cette bible décrit un **plan cible**, non un système déjà entièrement implémenté. Les six intersections route/bâtiment ne sont pas levées.

# KC36 — Dossier d'architecture et d'urbanisme (priorité à la conception)

**Version documentaire :** KC36-DESIGN-1.0 — 27 octobre 2026. **Statut :** exigences produit décidées + proposition de refonte à valider. **AUCUNE MODIFICATION DU RUNTIME ROBLOX.**

## À lire dans cet ordre

1. [`01_VISION_ET_PLAN_DIRECTEUR.md`](01_VISION_ET_PLAN_DIRECTEUR.md) : **où se trouve chaque secteur, chaque voie, chaque édifice** ; plan réel KC35 contre plan cible.
2. [`02_CONTRAT_PARCELLAIRE_ET_VOIRIE.md`](02_CONTRAT_PARCELLAIRE_ET_VOIRIE.md) : **aucun édifice sur une route** ; emprises, voirie, accès et dégagements.
3. [`03_STRATES_DU_SOL_ET_Z_FIGHTING.md`](03_STRATES_DU_SOL_ET_Z_FIGHTING.md) : qui possède la pelouse, le terrain et les sols ; protocole du « clignotement blanc ».
4. [`04_ORCHESTRATION_ET_DEPENDANCES.md`](04_ORCHESTRATION_ET_DEPENDANCES.md) : ordre de génération et de vérification, propriétaires et dépendances.
5. [`05_LANGAGE_VISUEL_V30_ET_SIGNALÉTIQUE.md`](05_LANGAGE_VISUEL_V30_ET_SIGNALETIQUE.md) : récupérer la qualité artistique V30 sans perdre le moteur KC35.
6. [`06_ARCHITECTURE_DES_NEUF_PLACES.md`](06_ARCHITECTURE_DES_NEUF_PLACES.md) : branches, intérieurs, portes, bibliothèque centrale.
7. [`07_QUALIFICATION_ET_MIGRATION.md`](07_QUALIFICATION_ET_MIGRATION.md) : tests, preuves, migrations et phasage.
8. [`08_REGISTRE_DECISIONS_ET_QUESTIONS.md`](08_REGISTRE_DECISIONS_ET_QUESTIONS.md) : décisions déjà exprimées et arbitrages encore ouverts.

## Lecture honnête des preuves

- **Source doc de référence :** `doc(1).zip`, soit la documentation du dépôt v3/v31.7 conservée intacte dans ce pack (dossiers `00-` à `08-`, `reference/`, `ARCHITECTURE_PANCARTES_V31_7.md`).
- **Source d'implémentation KC35 :** `KinCity_KC35_INTEGRATION_9_BRANCHES_COMPLET.zip`, notamment `build/world-plan.json`, `catalog/spatial.json`, `src/server/CityGenerator.luau`, `src/server/KoaliUrbanism.luau`, `contrib/places/city/Wayfinding.luau`, `src/server/GroundCompatibility.luau`.
- **Preuve analytique créée :** [`preuves/KC35_CHEVAUCHEMENTS_VOIRIE.json`](preuves/KC35_CHEVAUCHEMENTS_VOIRIE.json) : **6 intersections** entre les empreintes orientées des bâtiments et les bandes des six avenues, pour leur portion radiale actuellement codée. Voir limites de méthode.
- **Preuve visuelle utilisateur :** une capture en Play signale un triangle blanc et une pelouse clignotante ; le fichier visuel ne permet pas d'attribuer une instance Roblox certaine à ce phénomène. Pas de faux diagnostic « résolu ».
- **Plan schématique** : [`preuves/PLAN_URBAIN_KC35_AUDIT.png`](preuves/PLAN_URBAIN_KC35_AUDIT.png), dérivé du plan logique (pas une photographie ni un relevé de terrain).

## Priorités adoptées

**P0 :** arrêt des panneaux flottants dynamiques et des étiquettes horaires ; propriété exclusive des surfaces au sol ; séparation explicite route/parcelle ; aucun téléport, `PackageLink` ou contrat commun modifié à l'aveugle.

**P1 :** refaire le plan de rue et les implantations à partir d'un graphe public commun ; audit par scène puis passage Studio avec capture en mouvement ; comparaison V30 du même point de vue.

**P2 :** affiner l'éclairage, les matériaux et le langage monumental après les P0/P1.

## Ce que cette livraison n'est pas

Ce n'est **ni un hotfix Luau, ni un nouveau `.rbxl`, ni une publication Roblox, ni un plan spatial KC36 approuvé**. Les coordonnées KC35 restent descriptives de l'état courant. Toute relocalisation des édifices, chemins, seuils, façades ou portes doit produire une nouvelle révision des contrats et des preuves.
