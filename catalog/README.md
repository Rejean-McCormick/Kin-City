# Exemple de catalogue de Kin City

Ces fichiers constituent un **jeu de données documentaire cohérent**, pas une ville construite. Les huit bâtiments listés illustrent un registre d'identifiants et la relation entre places, portes et objets. Ils ne sont pas un inventaire exhaustif imposé par la vision et les coordonnées/semences sont des valeurs d'exemple.

**Tous les `place_id` sont `null` et les états `unpublished`**, volontairement. Ils ne permettent donc pas un test de téléportation réel. Le script de validation du catalogue accepte cet état **documentaire**, mais le contrôle de publication doit le refuser.

Les catalogues n'incluent aucun secret, jeton, URL métier ni donnée kOA. Les capacités sont toutes en `provider_mode=stub`. Aucune interaction ne consigne un vote ou n'attribue des crédits.

Pour valider : `python tools/validate_catalog.py`. Pour les schémas : `../schemas/`. Pour les critères de déploiement : `../docs/05-qualification/acceptation.md`.
