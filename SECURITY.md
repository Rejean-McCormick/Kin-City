# Sécurité et divulgation responsable

Aucun secret, identifiant de compte, jeton Roblox ou clé de service ne doit être commité. Les exemples de données sont fictifs et publics. Toute clé, si un jour nécessaire, résidera côté serveur dans le mécanisme officiel approprié.

En mode `WORLD_STUB`, **tout transport de données vers kOA est désactivé** : l'absence de trafic externe est une propriété à tester, pas une convention informelle.

Le serveur valide les interactions, même lorsque l'issue est un simple message : le client ne choisit jamais l'identifiant d'une capacité sensible hors du registre admissible. ProximityPrompt et RemoteEvent peuvent être abusés ; validation du joueur, de la cible, de la distance et du rythme indispensable.

Pour signaler une faille, utiliser un canal privé vers les mainteneurs du dépôt une fois celui-ci officiellement créé. Ne pas publier d'exploit applicable à une expérience ouverte.

Détails : [modèle de menaces](docs/04-ingenierie/securite.md).
