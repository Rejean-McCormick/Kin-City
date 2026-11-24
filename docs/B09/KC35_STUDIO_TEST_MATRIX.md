# Matrice de qualification KC35 — À exécuter dans Roblox

## Conditions préalables

- [ ] Sauvegarder `.rbxl`/version privée des neuf Places
- [ ] Vérifier les 121 sources importées et leurs droits
- [ ] Vérifier les vrais PlaceIds staging, tous appartenant au **même** univers
- [ ] Désactiver toute publication production ; installer uniquement sur copies et staging
- [ ] Vérifier `StreamingEnabled` et `KinArtDecoTestPlace=true` dans staging

## Mode local — inspection de neuf contributions

| Branche | Place | Vérifier | État |
|---|---|---|---|
| B01 | city_hall | Six salles, entrées/sorties, corniches | NON TESTÉ |
| B02 | ekoh_tower | Six panneaux, ascenseurs, sorties | NON TESTÉ |
| B03 | library | Six salles, vitrine et librairie | NON TESTÉ |
| B04 | campus | Six salles, UCKK, portes | NON TESTÉ |
| B05 | justice_palace | Six salles, rosaces et médiation | NON TESTÉ |
| B06 | innovation_lab | Six salles, ornements, aucun obstacle | NON TESTÉ |
| B07 | museum | **Entrée barrée**, 6 salles en accès direct, écran bien visible | NON TESTÉ |
| B08 | orgo_center | **24 ornements KC33** par profil, passages préservés | NON TESTÉ |
| B10 | city | Six accents, 18 pavillons, 8 façades, panneaux musée | NON TESTÉ |

## Critères client publié

- [ ] 7 portes d'entrée ville→institutions **accessibles** (musée volontairement barré)
- [ ] 8 sorties institutions→ville (incluant sortie musée lors d'un accès direct en staging)
- [ ] 1 entrée musée intentionnellement **fermée** et texte clair
- [ ] Tous les points de retour conformes (49 ancres conservées)
- [ ] États TeleportInitFailed, reconnexion, respawn et doubles prompts
- [ ] Répéter à 2 et 8 joueurs ; mobile d'entrée de gamme et PC
- [ ] Mesurer FPS médian/p5, RAM, temps initial, temps p95 de téléportation et échecs
- [ ] Valider l'actif vidéo Roblox autorisé, ou afficher le message « vidéo à configurer »

**Aucun élément n'est coché sur cette livraison : aucun accès Roblox Studio/client n'est disponible depuis l'environnement qui a créé KC35.**
