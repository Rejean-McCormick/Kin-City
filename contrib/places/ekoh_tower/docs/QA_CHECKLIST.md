# B02 — matrice de qualification, à remplir par B09 / opérateur Studio

| Contrôle | Statut au moment de cette livraison | Validation future |
|---|---|---|
| Salle Accueil dans le plan V3 | PASS statique | Spawn et texte visibles en Play Studio |
| Salle Galerie dans le plan V3 | PASS statique | Interaction `tower.panel_01` encore accessible |
| Salle Observation dans le plan V3 | PASS statique | Vues et portes dégagées |
| Salle Observatoire dans InteriorWings V3 | PASS statique | Traversée par passage `gallery_to_west` |
| Salle Mérite dans InteriorWings V3 | PASS statique | Traversée par passage `chamber_to_east` |
| Salle Forum dans InteriorWings V3 | PASS statique | 2 passages, escaliers, ascenseur et mezzanines |
| Profil LITE | PASS compteur / NOT TESTED en jeu | 6 panneaux, 6 Parts, 6 SurfaceGui |
| Profil STANDARD | PASS compteur / NOT TESTED en jeu | 6 panneaux, 24 Parts, 6 SurfaceGui |
| Profil SHOWCASE | PASS compteur / NOT TESTED en jeu | 6 panneaux, 42 Parts, 6 SurfaceGui |
| Collision native | Analyse statique PASS | Marche et retour sans blocage dans Studio |
| Entrée `city.central.ekoh_tower.entry` | ID conservé | Essai en client publié staging |
| Sortie `ekoh_tower.exit` | ID conservé | Essai en client publié staging |
| Emprise / profondeur des panneaux | PASS statique | Risque de chevauchement de décor d'autres modules |
| Compatibilité KC33 + B09 | NON TESTÉ | Rebase et tests du handoff B09 |
| Performance mobile | NON MESURÉ | FPS et mémoire sur appareil de référence |
| Couleurs 6 secteurs | NON MODIFIÉ | Coordination B10 ; aucune palette ajoutée |

Aucun statut PASS statique ne représente une validation runtime. Les captures attendues sont six salles, un plan d'ensemble et une vérification des deux portes.
