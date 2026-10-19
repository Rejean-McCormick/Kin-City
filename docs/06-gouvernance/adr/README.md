# Registre des décisions d'architecture

**Important :** le document historique v1.1 utilise le numéro `KC-ADR-012` pour « ville d'abord » et, dans un tableau antérieur, pour une autre décision relative aux secrets. Le présent registre **réserve exclusivement ADR-012 à la décision utilisateur** et réattribue la politique de secrets à ADR-013. Ce correctif évite deux autorités sous un même identifiant.

| ADR | Intitulé | État |
|---|---|---|
| [001](001-clients-et-autonomie.md) | Un produit Kin City, plusieurs interfaces | CIBLE |
| [002](002-generation-deterministe.md) | Générateurs déterministes et catalogues | CIBLE |
| [003](003-portes-frontieres.md) | Portes comme frontières de Places riches | DÉCIDÉ (principe), modalités CIBLE |
| [004](004-interactions-stub.md) | Interactions centrales et fournisseurs stubs | DÉCIDÉ |
| [005](005-ids-permanents.md) | Identifiants permanents et source de vérité du catalogue | CIBLE |
| [006](006-aucun-faux-succes.md) | Aucun faux résultat métier | DÉCIDÉ |
| [007](007-futur-gateway.md) | Connexions kOA par Gateway futur, non directement du client | CIBLE/FUTUR |
| [008](008-autorites-koa.md) | Préserver autorités kOA | SOURCE + CIBLE |
| [009](009-politique-canal.md) | Admission de contenus par canal | CIBLE |
| [010](010-test-reel-teleport.md) | Test client Roblox obligatoire des portes entre Places | EXTERNE_VÉRIFIÉ |
| [011](011-outillage-open.md) | Outillage de développement sans inférence IA payante | DÉCIDÉ |
| [012](012-ville-avant-koa.md) | Ville définitive, intégrations en stub | DÉCIDÉ |
| [013](013-secrets-et-autorisation.md) | Secrets et droits côté serveur | CIBLE |

DÉCIDÉ ne veut pas dire implémenté. Toute ADR peut porter preuves ou réserves lorsqu'un contrat propriétaire manque.

## ADR v3

- [014 Géométrie canonique](014-geometrie-canonique.md)
- [015 Hébergement hybride](015-hebergement-hybride.md)
- [016 Qualification en deux barrières](016-qualification-deux-barrieres.md)
- [017 Résolution stricte des assets](017-assets-resolution.md)
