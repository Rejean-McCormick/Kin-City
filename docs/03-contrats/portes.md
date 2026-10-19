# Contrat DoorRouter / TeleportService

## Porte comme capacité locale opérationnelle

La porte n'est jamais un stub. Dans le lieu extérieur, elle ouvre l'intérieur correspondant. Dans l'intérieur, une porte de sortie ramène à la ville. Le seuil peut présenter animation et transition visuelle, mais doit porter un **résultat réel**.

## Représentation canonique

```json
{
  "schema_version": "kincity.door/1.0",
  "door_id": "city.ethikos.justice_palace.entry",
  "building_id": "ethikos.justice_palace",
  "source_place_key": "city",
  "source_anchor_id": "ethikos.justice_palace.entry",
  "destination_place_key": "justice_palace",
  "destination_anchor_id": "justice_palace.lobby.spawn",
  "return_door_id": "justice_palace.exit",
  "transition_kind": "teleport"
}
```

`destination_place_key` est résolu vers un `place_id` numérique autorisé dans un registre serveur de déploiement. Un ID nul dans les exemples signifie *non encore publié* et doit faire échouer la qualification de publication.

## États

`idle → prompt → validating → preparing → teleporting → arrived → ready`; erreurs : `denied`, `timeout`, `teleport_failed`, `spawn_fallback`, `return_available`. Chaque état a un message d'interface et un comportement de restauration.

## Sécurité

Le serveur valide joueur, porte, source, destination et présence de l'ancrage. Un signal client ne choisit ni `PlaceId`, ni coordonnées libres. Les indices non sensibles de `TeleportData` ne remplacent pas la validation de destination.

## Cas particuliers

- Entrée en intérieur local (`inline_streamed`) : transition physique/porte dans le même Place, pas de TeleportService.
- Intérieur séparé : `TeleportAsync()` serveur ; gestion d'échec et reprise.
- Destination partagée : sélectionner instance/espace autorisé, ne pas mélanger les sessions.
- Place supprimé ou non publié : blocage à la publication ; en exécution, message d'indisponibilité sans coincer le citoyen.
- Retour impossible : route de secours vers la place centrale avec spawn préconfiguré.

## Vérification obligatoire

Publier une expérience Roblox privée contenant les Places réels ; parcourir toutes les paires de portes aller/retour dans le client Roblox. Tester l'échec et la reconnexion. **Studio seul ne peut pas valider TeleportService.** Source : https://create.roblox.com/docs/projects/teleport.
