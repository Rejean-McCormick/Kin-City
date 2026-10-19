# Interaction et navigation : protocoles runtime

## Interaction stub (`WORLD_STUB`)
1. Générateur place l'asset et définit `KinInteractionId`, `KinCapabilityId`, `KinAnchorId` comme **Attributes** stables.
2. `InteractionBinder` vérifie `interaction_id`, charge le registre strict, installe `ProximityPrompt` sur l'objet physique correspondant.
3. Le serveur reçoit `Triggered(player)`, **revalide** identité du prompt, proximité, avatar vivant, cooldown, mode et capacité autorisée.
4. Le serveur retourne seulement `status="COMING_SOON"`, `title_key`, `message_key`, `correlation_id` sans valeur métier.
5. Le client localise et affiche « Fonctionnalité à venir », fermeture par touche/écran/manette, une seule fenêtre ouverte par joueur.
6. Aucun appel externe, DataStore de vote, crédit EkoH ou vraie décision n'est accessible.

## Contrat d'événements (normatif)
```json
{"kind":"interaction.reply.v1","interaction_id":"konnected.library.bookshelf_01","status":"COMING_SOON","message_key":"ui.coming_soon","correlation_id":"ephemeral-server-token"}
```
Le `correlation_id` ne contient aucune information personnelle et n'est pas traité comme une preuve de vote.

## Porte
- `DoorBinder` prend `door_id` depuis registre serveur, jamais un PlaceId fourni par le client.
- Pour `local`, placement CFrame sûr et contrôle d'arrivée collision-free.
- Pour `teleport`, `TeleportService:TeleportAsync()` côté **serveur**; destination publiée obligatoire.
- Les paramètres de téléportation ne constituent pas une preuve d'identité ni d'autorisation; l'arrivée vérifie le contexte et résout une ancre autorisée, avec fallback sûr.
- `TeleportInitFailed` / erreur pcall → message local compréhensible, aucune perte d'accès, bouton réessayer sous cooldown.
- Retour toujours vers la bonne porte extérieure selon le `door_id` source, pas vers une entrée globale arbitraire.

## Menaces et échecs à tester
ProximityPrompt déclenché à distance, ID inexistant, répétition rapide, ancre absente, joueur sans personnage, double téléport, place non publiée, refus d'accès, échec de reprise, démarrage à l'intérieur après invitation, téléphone sans clavier et arrière-plan mobile.

**Documentation Roblox officielle :** https://create.roblox.com/docs/scripting/security/client-server-boundary ; https://create.roblox.com/docs/projects/teleport
