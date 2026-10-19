> **Mise à jour v3 :** pour les spécifications spatiales, les assets et les critères de construction normatifs, voir [`docs/07-construction/README.md`](../07-construction/README.md).

# Assets 3D, textures, audio et licences

## Politique de provenance

Tout asset qui se retrouve dans Kin City a : un `asset_id`, une origine, un titulaire/déclarant, une licence ou permission spécifique, les restrictions de redistribution, un statut de modération Roblox, une version et une preuve d'acquisition si disponible.

**Gratuit ≠ open source ; libre d'utilisation en expérience ≠ libre de redistribution du fichier.** Les ressources du Creator Store et les modèles tiers doivent être examinés avant copie dans un dépôt public.

## Organisation recommandée

```text
assets/
  source/         originaux et instructions d'export
  meshes/         modèles normalisés et référencés
  textures/       textures et variantes
  animations/     rigs et animations
  sound/          ambiance et effets
  manifests/      provenance et révisions
  README.md       conventions de licence
```

## Normes de géométrie

Gabarits à taille cohérente et orientation documentée, origine/pivot défini, volumes de collision simples, ancrages de porte/interaction explicités, budget triangle/mémoire mesuré par plateforme, nommage stable des parties requises, optimisation des matériaux réutilisés.

## Contrôles de publication

Tester : droits et licence, import approuvé, rendu sur appareils cibles, collisions, échelle des avatars, affichage correct dans les Places publiés, absence de scripts inattendus dans les modèles tiers.

Les assets ne sont pas fournis dans ce ZIP documentaire; les familles prévues apparaissent dans `catalog/`, et les éléments concrets devront être acquis, fabriqués et vérifiés.
