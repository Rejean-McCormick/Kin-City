> **Mise à jour v3 :** pour les spécifications spatiales, les assets et les critères de construction normatifs, voir [`docs/07-construction/README.md`](../07-construction/README.md).

# Compilateur de monde et générateurs déterministes

## Finalité

Une ville massive ne doit pas être saisie bâtiment par bâtiment avec des scripts uniques. Les programmes produisent des scènes Roblox à partir de manifestes, gabarits et bibliothèques d'assets. L'IA peut aider à écrire les outils, **mais l'exécution du compilateur n'appelle pas une IA facturée à l'usage**.

## Pipeline cible (outils à implémenter)

```text
catalog/*.json + schemas + assets/provenance
  → validate (format, IDs, références, licences)
  → normalize (ordre, valeurs par défaut, versions)
  → plan (topologie, places, collision, budgets)
  → generate (terrain, façades, routes, intérieurs, meubles)
  → bind (ancrages, portes, prompts, attributs, tags)
  → package (rbxm/rbxmx/rbxl, configuration Rojo)
  → inspect & test (diffs, sorties reproductibles, parcours)
  → publish (autorisation humaine et preuves)
```

## Sous-générateurs

- `TerrainGenerator` : hauteur/anneaux/eau/pentes, collisions et limites.
- `RoadGenerator` : axes, anneaux, croisements, voies et signalisations.
- `BuildingGenerator` : façade depuis type/style/gabarit/dimensions.
- `InteriorGenerator` : pièces, mobilier, éclairage, occupation et circulation.
- `InteractionBinder` : ancre `interaction_id` sur objet, prompt et UI.
- `DoorBinder` : source, destination, spawn/retour, vérification.
- `NPCDecorator` : apparences et animations légères ; pas de comportements IA distants.
- `QualityAnalyzer` : graphes, collisions, chemins, références, budgets et licences.

## Reproductibilité

Même révision de compilateur + même seed + mêmes assets versionnés + mêmes manifestes → même plan normalisé et les mêmes positions. En sortie, un **rapport de build** contient empreintes SHA-256, compte d'objets, warnings, rejet et graphe de portes. Ne pas promettre identité binaire de fichiers Roblox lorsque le sérialiseur officiel introduit des métadonnées variables; comparer un modèle logique canonique.

## Modification artistique

Toute personnalisation manuelle importante doit être décrite par des overrides/patchs versionnés ou un asset stable. La régénération ne doit pas écraser silencieusement la décoration validée. Produire un diff de scène et obliger une approbation humaine pour modifications massives.

## CLI future illustrative (non implémentée)

```text
kincity validate --catalog catalog/
kincity plan --world city --seed 20261018
kincity build --place city --profile mobile
kincity diff --against build/previous.manifest.json
```

Ces commandes spécifient une ergonomie désirée, **elles n'existent pas dans ce paquet**. Le seul exécutable fourni est `python tools/validate_catalog.py`.
