# ADR-019 — Éteindre la signalétique flottante

**Statut : DÉCISION PRODUIT + contrat technique proposé (KC36)**

**Décidé :** ne pas afficher de panneaux de direction `BillboardGui` dynamiques, ne pas afficher les numéros horaires. Les heures internes peuvent rester un système mathématique de composition non visible. Les enseignes physiques de destination restent permises, à condition de ne pas obstruer les routes, portes ou vues.

**Implémentation cible :** `SignageSchedule` calculé à partir du plan et des décisions de cheminement, une enseigne principale intégrée par façade, supports physiques supplémentaires seulement aux intersections nécessitant un choix. `Factory.sign` et `SignEngine` sont les générateurs d'affichage permis ; position/orientation fixe en monde. `SurfaceGui` sur BasePart et non BillboardGui suivant la caméra.

**Audit :** 0 `BillboardGui` pour les rôles directionnels; 0 `TextLabel.Text` de destination contenant `SECTEUR • <heure> H`; supports avec identifiants stables ; échelles testées à pied. Les UI interactives locales ne sont pas incluses dans cette interdiction.
