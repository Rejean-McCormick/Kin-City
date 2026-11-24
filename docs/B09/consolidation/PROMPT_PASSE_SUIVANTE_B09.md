# Mission de reprise B09 après consolidation des contributions KC34

Lis `docs/B09/consolidation/RAPPORT_CONSOLIDATION.md` et `consolidation_receipt.json`, ainsi que les handoffs originaux `original_handoffs/`. Le projet consolidé contient les contributions B01–B06, B08 et B10 en arborescence de travail mais **aucun loader Roblox activé**. B07 est absente. Les contrats KC33 restent verrouillés. Ne considère pas `BLOCKED` ou `READY_FOR_REVIEW` comme une décision d'acceptation.

**Travail prioritaire** : obtenir B07; résoudre B08 (handoff V3 vs KC33, état périmé d'au moins AD_Int_Mirror_Sunburst) et revalider B06 directement contre KC33; définir RFC d'interface commune de décor pour les modules de branches hétérogènes; intégrer/packer un loader conditionnel derrière un feature flag désactivé par défaut; tester scénarios sans modèle, LITE/STANDARD/SHOWCASE, idempotence, suppression, retournement des portes, placement des six salles et dégagements. Tout correctif de `WorldBuilder`, `tools/`, `catalog/`, `config/` demande une RFC/ADR et une nouvelle version des contrats.

**Règle** : ne jamais prétendre que les Places existent ou que les transitions marchent sans neuf Places staging et tests dans le client Roblox publié. N'invente aucun PlaceId, ne modifie jamais la Place de production. Livrer les patchs, sources, logs réels, registre mis à jour et récapitulatif des blocages.
