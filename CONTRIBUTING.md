# Contribution et conventions

## Convention des contributions

Chaque modification doit référencer un besoin `KC-REQ-*`, une décision `KC-ADR-*` si elle est structurante, et le ou les tests qui prouvent son résultat. Un objet est ajouté par manifeste, pas par une copie manuelle de code.

## Qualité documentaire

- Langue principale : français. Noms techniques et IDs ASCII en `snake_case` ou segments pointés.
- Chaque contrat porte une version; un champ obligatoire ne peut pas être retiré sans évolution majeure.
- Écrire les états d'erreur et les cas hors-ligne en même temps que le chemin de réussite.
- Chaque capture utilisée plus tard doit indiquer la version de la scène et le droit d'utilisation de l'asset.
- Actualiser `docs/05-qualification/traçabilite.md` si une exigence change.

## Validation

Exécuter `python tools/validate_catalog.py`, inspecter les diffs des manifestes, vérifier les références et la provenance d'assets, enregistrer les résultats Studio et Roblox client lorsqu'ils existent. Une validation du catalogue n'est pas un test de gameplay.

## Pull request

Fournir : intention, périmètre, fichiers, avant/après, schémas impactés, tests, risques, performance, modération, compatibilité avec `WORLD_STUB`, preuve de non-régression des IDs, plan de restauration.
