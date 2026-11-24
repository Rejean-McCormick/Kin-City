# Correspondance des imports Studio — 25 octobre 2026

Le relevé fourni par l'utilisateur contient 121 conteneurs Workspace.AD_Assets.
Chaque conteneur possède un modèle enfant portant le nom original avec suffixe
`.001`. Les 121 clés correspondent exactement au manifeste, sans doublon ni manque.
Le relevé contient 463 MeshParts et 463 MeshId distincts au format rbxassetid.
Il ne prouve pas les droits d'accès depuis un autre compte, le rendu des couleurs,
les performances mobiles ni le résultat d'une exécution de notre installateur.

PrepareArtDecoLibrary analyse désormais Workspace avant les archives privées.
Un dossier KinCityArtDecoImports vide ne masque plus les imports dispersés.
Toute sélection partielle ou ambiguë est rejetée avant le remplacement de la
bibliothèque. Les clones gardent leur hiérarchie et leurs couleurs. Après création
complète de la bibliothèque, les conteneurs d'import sont conservés dans
ServerStorage.KC_ARTDECO_V32_SOURCES, hors de la scène de jeu.

Reproduction depuis le dépôt :

```sh
python tools/build_imported_test_installer.py KinCity_Installer_Imports_Reconnus.luau
```

Le fichier produit contient l'adaptateur d'import, l'installateur complet, un
contrôle de présence de vrais MeshParts dans la ville et les contrôles Studio.
Il s'exécute uniquement hors Play dans une Place locale (PlaceId 0). Aucune
publication ni import réseau. Les 121 modèles doivent déjà être présents.
Tous sont disponibles dans la bibliothèque ; seuls les objets retenus par les
recettes et les budgets sont placés dans la ville.

Validation hors Studio : 78 tests passent, dont six tests de correspondance
exécutant le résolveur généré contre le relevé réel. Syntaxe Luau du fichier
assemblé validée. Exécution et inspection visuelle dans Studio à effectuer.
