# Performance, budgets et échelle de la ville

## Limites structurelles

Les calculs externes futurs n'augmentent pas la mémoire GPU d'un appareil Roblox. Une ville très vaste exige streaming, réduction des éléments répliqués, séparation en Places, modèles réutilisables et tests ciblés. La taille du monde, les joueurs simultanés, la densité des PNJ et la qualité des assets doivent être des paramètres mesurés, non des nombres promis.

## Budget par Place

| Métrique | Objectif / décision |
|---|---|
| Temps d'entrée dans Place | seuil à fixer après appareil cible et tests |
| FPS P50/P95 | mesures par classe d'appareil, seuil à approuver |
| Mémoire | plafonds par appareil, mesures avec contenu riche |
| Nombre d'Instances actives | rapport génération + Studio réel |
| Triangles/texture VRAM | prévision asset + analyse dans client |
| Scripts / frame time | profil CPU pour portes, PNJ, UI |
| Téléportation aller/retour | mesures P50/P95 + échecs + reprises |
| Requêtes HTTP kOA | **0** en `WORLD_STUB` |

## Optimisations par défaut

Ne pas rendre visibles les intérieurs riches depuis la place extérieure. Utiliser des variantes de géométrie et distance de vue, culling / streaming, matériaux partagés, pathfinding limité, collision simple, chargement progressif d'UI et scripts centralisés.

## Tests de montée en charge

Mesurer scènes vides/de référence puis ville complète avec joueurs et PNJ. Tester sur plusieurs classes d'appareils, connexions lentes, mouvements rapides, franchissement de nombreuses portes et sessions longues. Garder les traces de build et conditions de mesure.

## Frontières réseau futures

`HttpService` Roblox prend en charge les requêtes HTTPS côté serveur et impose des limites de débit; voir https://create.roblox.com/docs/cloud-services/http-service (500 requêtes HTTP génériques/minute/serveur documentées au 18 octobre 2026). Le futur Gateway doit agréger/cache/reprendre ; ce budget ne concerne pas la livraison autonome qui ne fait aucun appel kOA.
