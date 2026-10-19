# Configuration, profils et commutateurs

## Profils

| Profil | Destinataire | Règles |
|---|---|---|
| `WORLD_STUB` | build autonome et publication initiale | fournisseurs métier stubs, transport kOA désactivé, portail d'identité absent |
| `KOA_CONNECTED` | connexion ultérieure uniquement | activation serveur par capacité admise et contrats qualifiés |
| `LOCAL_STUDIO` | outil de création | simulation de scènes, pas de preuve de TeleportService |
| `PRIVATE_ROBLOX_TEST` | build publié privé | vrais IDs de Places et tests de téléportation |
| `PUBLIC_ROBLOX` | expérience publiée | mêmes invariants + modération + seuils de qualité mesurés |

## Exemple d'intention de configuration

```json
{
  "runtime_mode": "WORLD_STUB",
  "external_koa_enabled": false,
  "default_provider": "stub",
  "ui_language": "fr",
  "catalog_revision": "kincity.catalog/1.0"
}
```

Cette configuration exprime une **règle cible**, pas une capacité déjà codée.

## Paramètres critiques

`runtime_mode` et permissions restent côté serveur ; tout build autonome doit refuser une `capability` portant `provider_mode=koa_gateway`. `PlaceId` sont configurés à la publication et référencés dans un registre approuvé. Aucun client ne fournit une URL, un secret ou une politique d'autorisation.

## Gestion des environnements

Un Place ne doit jamais être enregistré comme *testé* tant qu'il ne possède pas d'identifiant Roblox réel, une source publiée, un point d'entrée confirmé et une route de retour fonctionnelle. Les environnements public/privé ne doivent pas partager des secrets ou des données de production kOA.
