# ADR-001 — Écart entre bounds du catalogue et ailes intérieures KC33
**Date :** 2026-10-26  
**État :** PROPOSÉE — collecte d'avis B01–B08, aucune migration de contrat appliquée.  
**Catégorie :** Géométrie partagée / collision / compatibilité.

## Constat reproductible
Chaque Place intérieure a `bounds.size_studs=[110,100]` dans `catalog/spatial.json`. Dans `InteriorWings.luau`, les centres et dimensions des trois extensions non présentes au plan compilé étendent les salles à `x∈[-105,+105]` et `z∈[-46,+104]` : taille d'enveloppe 210×150, centre (0,29). Les rectangles initiaux se limitent à x=±55 et z=±50.

## Options
1. **Garder le catalogue canonique inchangé et documenter une enveloppe effective calculée**, sans modification de hash (décision provisoire KC34-B09).
2. Modifier globalement les huit bounds à 230×228 studs autour de l'origine, plus marges utiles, **après RFC, revue B01–B08 et recompilation des plans**.
3. Séparer formellement `logical_bounds` et `runtime_bounds` ou générer une enveloppe à partir de toutes les salles et dispositifs spécialisés, puis faire migrer le schéma, les outils et la validation.

## Impacts à contrôler
- Spawn et 16 transitions inchangés ; aucune renumérotation d'ancre.
- Tests des quatre portails ajoutés par chaque `InteriorWings` et de la traversée salle-aile.
- Collisions, streaming, bounds des autres modules ajoutés par `InteriorGenerator`.
- Place unique vs multi-Place et mesures performance.

**Choix provisoire :** option 1. Le solveur de bounds B09 est statique et refuse une évolution des constantes qu'il ne sait plus analyser. Les huit branches donnent leurs dimensions projetées avant adoption de l'option 2 ou 3. En conséquence, les limites de 110×100 ne doivent pas guider les nouvelles constructions.
