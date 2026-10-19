# Navigation, portes et continuité des déplacements

## Itinéraire attendu

`ville → seuil → interaction de porte → transition valide → intérieur → exploration → porte de sortie → ville`. Le bâtiment doit être identifiable sans jargon technique. Une porte ouverte peut être animée avant la téléportation, mais cela ne fait pas disparaître le chargement réseau.

## Deux niveaux de navigation

- **Graphique / spatial** : chemin marchable avec collisions, escaliers ou rampes, repères et issues.
- **Logique / technique** : `door_id → destination_place_symbol → place_id publié → spawn_anchor`. Le routeur n'accepte jamais une destination inventée par le client.

## Spécification des portes

Le routage et les états sont définis dans [le contrat de porte](../03-contrats/portes.md). Le retour est une route explicite; la porte de sortie ne dépend pas d'un index calculé sur l'ordre de l'arbre Roblox.

## Cas de panne

Si une téléportation échoue, afficher un retour neutre, réactiver l'interaction et conserver la capacité de marcher dans la scène source. Si le joueur réapparaît à destination sans ancrage reconnu, un spawn de secours contrôlé côté serveur le replace en sécurité. N'accepter aucune valeur de position arbitraire transmise par `TeleportData`.

## Tests particuliers

Double activation rapide, joueur se déconnectant pendant la traversée, serveur plein, absence du `PlaceId`, retour après reconnexion, parcours en groupe, déplacement en cliquant sur une invite mobile, permissions de destination revalidées.

Les téléportations **ne fonctionnent pas en test Studio local** : publier dans un univers Roblox privé de test et ouvrir le client Roblox pour valider les vrais allers-retours. Source officielle : https://create.roblox.com/docs/projects/teleport.
