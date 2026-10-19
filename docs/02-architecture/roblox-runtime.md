# Runtime Roblox : réplication et serveurs

## Organisation des scripts

- `ServerScriptService` : routeur d'interactions, vérifications, catalogues serveur, gestion des portes, fournisseurs.
- `ReplicatedStorage` : types, événements strictement bornés, ressources UI partageables, aucune donnée sensible.
- `StarterPlayerScripts` / `StarterGui` : réception d'événements autorisés, UI stub, focus et contrôles.
- `Workspace` : scènes, portes, prompts, personnages, tags et attributs.
- `ServerStorage` : ressources serveur non visibles du client, lorsque nécessaire.

## Interaction sécurisée

ProximityPrompt déclenche côté serveur une action contrôlée. Le serveur récupère l'objet depuis une table d'ancrages/Instance validée, vérifie distance, présence et disponibilité. Le client ne peut demander directement le routage d'une capacité arbitraire ou fabriquer un `interaction_id` existant ailleurs.

## Streaming

`StreamingEnabled` est disponible pour optimiser le chargement du Workspace. Les instances peuvent sortir de la zone chargée puis revenir : enregistrer/désenregistrer correctement prompts et UI. Éviter de marquer tous les bâtiments `Persistent`; préférer mode `Atomic` lorsque des regroupements proches doivent se charger ensemble.

## Téléportation

`TeleportService:TeleportAsync()` doit être déclenché sur le serveur pour les destinations externes; chaque intérieur séparé appartient à un Place de l'expérience. Les données de téléportation servent d'indices, pas de preuve de droits. Les tests réels doivent être effectués dans un client Roblox après publication.

## Co-présence

Une salle séparée héberge potentiellement d'autres joueurs qu'à l'extérieur. Toute promesse « les mêmes citoyens restent ensemble » nécessite une politique explicite de réservation/choix de serveurs, des cas de capacité épuisée et des tests. Ne pas prétendre au partage d'un seul serveur universel.

## Traces autorisées en mode autonome

Journalisation Roblox locale d'erreurs techniques et métriques agrégées seulement, sans appel kOA et sans collecte de données personnelles facultative. Respecter les mécanismes de télémétrie et politiques Roblox réellement applicables.
