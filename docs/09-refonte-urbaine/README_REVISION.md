# Note d'intégration de la documentation KC36

Ce paquet préserve la structure et les contenus du ZIP utilisateur `doc(1).zip`, en ajoutant une nouvelle couche **`09-refonte-urbaine/`**. Les documents historiques restent inchangés, sauf un encart de navigation ajouté au `README.md` racine.

**Règle d'autorité temporelle :** le plan actuel KC35 est la source de preuve de ce qui existe dans le code, non un nouveau plan approuvé. Les anciennes coordonnées v3 ont valeur d'illustration. Les décisions du commanditaire sur la ville et la signalétique prévalent pour les exigences de la refonte. Les spécifications de modules proposées n'ont pas de code exécutable certifié.

## Assurance qualité du paquet

- Comparaison du nombre de fichiers du ZIP initial avant et après enrichissement.
- Schéma d'exemple JSON vérifié contre son JSON Schema.
- Chiffres d'intersection régénérés depuis KC35.
- Vérification des liens relatifs, tableaux et contraintes des branches.
- Rapport de compilation documentaire reproduit dans `09-refonte-urbaine/preuves/`.
