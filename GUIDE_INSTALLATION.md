# Installation Art Deco v3 — Place locale existante

Les 121 modèles sont déjà importés et archivés dans la Place de test. Ne pas
créer une nouvelle Place et ne pas refaire l'import. Utiliser le script assemblé
`INSTALLER_KINCITY_ARTDECO_V3.luau` fourni à la racine du ZIP. Hors Play, copier
son contenu entier dans la barre de commande. Il prépare la bibliothèque, reconstruit
la ville et ses huit intérieurs séparés, puis lance les contrôles d'architecture.

Reproduction depuis le dépôt :

```sh
python tools/build_imported_test_installer.py INSTALLER_KINCITY_ARTDECO_V3.luau
```

Le script complet exige une Place locale (PlaceId 0) avec streaming activé. Il
refuse toute Place publiée, ne publie rien et ne demande aucun téléchargement
réseau. Les imports originaux sont conservés dans ServerStorage, hors de la scène.
Les objets Kin City générés et leurs scripts sont reconstruits.

Voir [la migration et les contrôles v3](docs/04-ingenierie/art-deco-ville-et-interieurs-v3.md).

---

# Installation Art Deco — copie de test uniquement

Cette branche part du snapshot v31.9.7 fourni. Elle ne doit pas être installée dans la Place publiée `72097868581669` ; le script officiel la refuse avant toute suppression.

Suivre [la procédure de migration](docs/04-ingenierie/migration-art-deco.md) : copie locale ou privée distincte, marqueur de test, préparation de la bibliothèque privée, installateur officiel, qualification Studio puis tests mobiles.

Les modèles commerciaux ne sont pas inclus dans les sources. Réutiliser la bibliothèque privée du test précédent ou importer les 121 GLB dans Studio. Aucun script ne publie automatiquement la ville.

Pour régénérer les données, les outils Studio et l'installateur depuis les sources :

```bash
python -m pip install -r requirements-dev.txt
python tools/build_release.py
python -m unittest discover -s tests -v
```

Ne pas supprimer le dépôt Windows ou son historique Git. Appliquer le patch sur une branche sauvegardée après `git apply --check`, puis recompiler. La publication de la vraie Kin City reste soumise à l'accord explicite du propriétaire après qualification.
