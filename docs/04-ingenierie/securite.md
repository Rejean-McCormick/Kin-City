# Modèle de menaces et contrôles de sécurité

## Menaces à considérer

| Scénario | Conséquence | Contrôle |
|---|---|---|
| RemoteEvent forgé avec un ID d'interaction | accès à une capacité non prévue | résolution serveur depuis l'Instance, whitelist et distance |
| ProximityPrompt déclenché abusivement | ouverture en boucle, détournement | throttling serveur et état par joueur |
| PlaceId transmis par le client | téléportation arbitraire | registre de destination serveur, aucun URL/place de source client |
| TéléportData falsifiée | spawn interdit, confusion de destination | donnée traitée comme indice, validation destination |
| Asset tiers avec script malveillant | exécution incontrôlée | revue scripts et provenance à l'import |
| Introduction de clé API dans client | exfiltration | aucune clé en `ReplicatedStorage` ou source publique |
| Stub active silencieusement un fournisseur réseau | fuite de données, coût, politique | build `WORLD_STUB` fail-closed, assertion zéro HTTP kOA |
| Contenu civique non admissible Roblox | suspension/modération | admission par canal et audit avant publication |
| Reprise future de votes/rôles côté client | résultats falsifiés | propriétaire métier et Gateway serveur uniquement |

## Frontières

Client Roblox non fiable → serveur Roblox ; serveur Roblox → futur Gateway ; Gateway → propriétaire. Le client ne détient jamais de secret ni d'autorité canonique. Même un appel « ouvrir panneau stub » ne doit pas donner carte blanche à un script du client.

## Présent vs futur

Présent : aucune API kOA, donc pas de stockage d'identité externe ni token. Futur : mécanisme de secret approuvé Roblox, HTTPS, clés à privilèges minimaux, contrôles anti-rejeu, audibilité, limitation et rotation ; les détails seront validés avec les contrats propriétaires avant admission.

## Tests de menace

Injecter événements non conformes, IDs inexistants, distance excessive, valeur vide, fréquence rapide, entrée dans Place de destination sans passer par la porte, Place supprimé, UI falsifiée, asset à script caché, configuration réseau interdite.

Source externe : https://create.roblox.com/docs/scripting/security/client-server-boundary.
