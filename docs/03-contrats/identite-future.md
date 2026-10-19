# Identité, liaison Roblox–kOA (future)

## Aucune liaison dans la première livraison

En `WORLD_STUB`, une personne utilise son compte Roblox pour rejoindre l'expérience et son avatar pour naviguer. Aucun rapprochement automatique avec un compte Konnaxion, Orgo ou Univers-Cité n'est effectué. Aucun compte externe ni mot de passe ne sont demandés dans Roblox.

## Invariants kOA [source]

`authentication != authorization`, `federated identity != local account`, `same person != same role`, `same email != same identity`, absence de base de credentials partagée ; les applications autorisent localement leurs actions.

## Conception réservée

Un mécanisme futur de liaison entre Roblox et l'identité kOA ne doit utiliser que des parcours autorisés par Roblox et par les propriétaires d'identité. Le `UserId` Roblox seul ne prouve pas la détention d'un compte kOA. Une liaison devra être explicite, revocable, journalisée et limitée aux droits minimaux.

## Consentement et modération

Ne pas contourner les restrictions Roblox applicables aux liens externes ou à l'âge. Les données éducatives, scores et consultations sont sensibles et ne doivent pas être projetés publiquement par défaut. Chaque système propriétaire peut imposer ses autorisations et méthodes de recouvrement local.

## État documentaire

Aucun flux d'association complet n'a été démontré dans les matériaux fournis. Il reste une question **à qualifier**, pas une dépendance cachée du mode autonome.
