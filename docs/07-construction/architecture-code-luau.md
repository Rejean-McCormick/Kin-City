# Architecture de code Luau et contrats de modules

**Statut : cible d'implémentation, non code Roblox déjà exécuté.** Ce document fixe les frontières des composants pour éviter les scripts dupliqués sur chaque bâtiment ou meuble.

## Arborescence du dépôt exécutable cible

```text
src/
  shared/
    KinIds.luau             -- identifiants immuables et types
    WorldManifest.luau      -- lecture du plan normalisé
    InteractionProtocol.luau-- enveloppes request/response
    PlaceRegistry.luau      -- destinations logiques; ID numériques injectés au build
  server/
    CityBootstrap.server.luau
    DoorService.luau        -- validation + transitions
    SpawnResolver.luau      -- arrivée sûre / retour d'entrée
    InteractionService.luau -- ProximityPrompt, autorisations et cooldown
    StubProvider.luau       -- réponse COMING_SOON uniquement
    RateLimiter.luau
    TeleportRecovery.luau
  client/
    KinHud.client.luau
    InteractionView.luau
    LoadingAndFailureView.luau
  editor/
    WorldBuilder.plugin.luau -- compilation/instanciation en mode édition
    SceneInspector.luau
  generated/
    WorldPlan.luau          -- projection immuable depuis build/world-plan.json
    PlaceRouting.luau       -- PlaceIds enregistrés par publication
```

Les modules sous `editor/` n'exécutent pas le code métier du jeu. Le compilateur Python actuel ne fournit **aucun** de ces modules : ce sont des responsabilités futures explicites.

## Contrat DoorService

```text
register(doorId: string, prompt: ProximityPrompt) -> Result<void, BuildError>
onTriggered(player: Player, doorId: string) -> Result<TransitAttempt, RuntimeError>
resolveTarget(doorId: string, placeRegistry: Registry) -> {placeKey, placeId?, anchorId}
onTeleportFailure(player: Player, attempt: TransitAttempt, reason: string) -> void
```

Obligations : vérification de `doorId`, du parent et de sa Place, du personnage et de sa distance, cooldown serveur, destination publiée. `TeleportAsync` n'est appelé qu'en script serveur et encapsulé par `pcall`. `TeleportInitFailed` doit offrir une récupération, sans envoyer le joueur vers une ancre générique choisie par un client.

## Contrat InteractionService

```text
register(interactionId: string, object: BasePart | Model) -> Result<void, BuildError>
onTriggered(player: Player, interactionId: string) -> void
provider(mode: WORLD_STUB | KOA_CONNECTED, capabilityId: string) -> Provider
```

En `WORLD_STUB`, tout fournisseur retourne uniquement :

```json
{"status":"COMING_SOON","message_key":"ui.coming_soon","title_key":"title.catalog"}
```

Le client ne peut pas déclencher une capacité arbitraire en soumettant un `capabilityId` choisi librement. Le serveur résout une référence admise depuis son registre. Pour le navigateur UI, interdire l'interpolation non filtrée dans le texte et contrôler les dimensions et la fermeture à la manette / au tactile.

## Frontière de génération

- Le Python du dépôt documentaire est une implémentation d'**IR de plan**.
- Le générateur Roblox devra mapper `structures`, `rooms`, `furnishings`, `anchors` en `Instance`s réels et poser leurs `Attributes`.
- L'ordre d'insertion des instances ne doit pas modifier IDs, seeds, ancrages ou positions.
- Une relance du compilateur doit produire un diff contrôlé, ne jamais supprimer manuellement une zone personnalisée sans override.
- Les `PlaceId` réels sont des paramètres injectés par pipeline sécurisé. Ils ne doivent pas figurer comme nombres inventés dans les catalogues.

## Scénarios d'erreur non négociables

`UNKNOWN_DOOR`, `DESTINATION_NOT_PUBLISHED`, `TELEPORT_INIT_FAILED`, `RETURN_ANCHOR_NOT_FOUND`, `PLAYER_NOT_READY`, `PROMPT_OUT_OF_RANGE`, `UNKNOWN_INTERACTION`, `RATE_LIMITED`, `MODE_FORBIDDEN`, `ASSET_NOT_RESOLVED`, `SCENE_VALIDATION_FAILED`.

Chaque erreur comporte une action de repli visible et un identifiant de corrélation technique éphémère. Les exceptions serveur restent internes; aucun jeton ni accès kOA n'est disponible dans la première livraison.
