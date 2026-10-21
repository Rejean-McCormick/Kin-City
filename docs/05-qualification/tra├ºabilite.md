# Traçabilité exigences → conception → tests

| Besoin | Source | Contrat/architecture | Test/acceptation |
|---|---|---|---|
| KC-REQ-001 Ville concentrique exploratoire | Vision Kin City | `01-produit/ville.md`, `catalog/city.json` | T-001/002, WORLD-01/02 |
| KC-REQ-002 Intérieurs riches aux portes | décision utilisateur | bâtiments + DoorRouter | T-003/004, WORLD-03/04/05 |
| KC-REQ-003 Objets affichant « Fonctionnalité à venir » | décision utilisateur | InteractionRouter + StubProvider | T-006/007, WORLD-06/07 |
| KC-REQ-004 Zéro intégration kOA pour la livraison autonome | décision utilisateur | mode `WORLD_STUB` | T-009/015, WORLD-08 |
| KC-REQ-005 Capacité de connexion ultérieure sans refaire la ville | décision utilisateur | CapabilityRegistry, IDs stables | T-010/016, WORLD-09, KOA-07 futur |
| KC-REQ-006 Générateurs extensibles sans IA à l'usage | conversation utilisateur | compilation et asset registry | T-016, WORLD-09/15 |
| KC-REQ-007 Sécurité et modération compatibles Roblox | règles Roblox | sécurité, politique contenu | tests négatifs, WORLD-10/13 |
| KC-REQ-008 Source de vérité kOA préservée | documents kOA | Gateway futur + carte d'autorité | KOA-01/03/04 (futur) |
| KC-REQ-009 Accessibilité multi-support | vision Kin City | UI et navigation | T-012, WORLD-07/10 |
| KC-REQ-010 Publication et retour fiables | règles Roblox | porte, versionnement | T-003/004/014, WORLD-04/05/12 |

## Règle de changement

Aucune exigence supprimée sans justification et décision associée. Toute modification de contrat ou d'objet interactif doit réviser sa ligne de traçabilité et la preuve correspondante.
