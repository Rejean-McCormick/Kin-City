# Démarrage de Kin City v24

## Sans import — le plus simple

Ouvrir Roblox Studio (mode Édition), coller tout `KinCity_Installation_Directe_v24.luau` dans View > Command Bar, l'exécuter. Puis cliquer **Play**. Toute la ville est produite avec des primitives Roblox lorsque les assets externes ne sont pas disponibles.

## Pour obtenir les véritables modèles 3D

1. Importer un `.obj` de `assets/meshes-v23` ou de `assets/meshes-v24` dans Roblox Studio.
2. Sélectionner le MeshPart dans Explorer ou en scène.
3. Régler `KIN_KEY` au nom correspondant dans `KinCity_Enregistrer_Mesh_Studio_v24.luau`.
4. Exécuter ce second script dans la Command Bar en mode Édition.
5. Répéter pour les modèles désirés; relancer l'installateur principal v24 afin de reconstruire les ornements avec les meshes importés.

Les matériaux PBR `.png` et pistes `.wav` restent facultatifs. L'importation n'est jamais nécessaire pour les portes, les stubs et les activités locales.

## Limites

La v24 n'a pas été exécutée ici dans Roblox Studio. Tester le rendu, les escaliers et la fluidité avant toute publication. Aucun kOA, OIDC, HTTP ou IA payante n'est utilisé à l'exécution.
