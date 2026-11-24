# ADR-018 — Une source d'autorité pour route, sol et parcelles

**Statut : PROPOSÉ (KC36)**

**Contexte :** dans KC35, la génération des façades puis des avenues, avec plusieurs modules indépendants de pavage, produit des interférences potentielles. L'audit 2D révèle six intersections positives entre emprises institutionnelles et avenues majeures ; le terrain clignote en Play sans diagnostic d'Instance achevé.

**Proposition :** `UrbanPlanCompiler` crée les réservations via `RoadNetwork`, `PlotInventory`, `ApprovedSiteAssignments` et `SurfaceOwnershipMap`. Les constructeurs ne placent pas d'élément majeur en dehors de leurs réservations approuvées. Collision = échec du prébuild. Le propriétaire décide des migrations d'ancres ; B09 arbitre les modifications partagées.

**Conséquences :** migrations substantielles du générateur, nouvelles validations CI et Studio, aucun hotfix arbitraire de la seule hauteur Y. Les assets centraux restent indépendants de la géométrie ; toutes les Places consomment le même plan de version.

**Alternatives rejetées à titre de proposition :** déplacer aléatoirement les façades après génération ; masquer les pavés problématiques sans preuve ; réinstaller intégralement V30 ; passer tous les objets en `CanCollide=false`.

**À approuver :** commanditaire + B09, après revue du plan et des coûts.
