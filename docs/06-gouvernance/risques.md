# Registre initial des risques

| ID | Risque | Sévérité conceptuelle | Mesure | Preuve pour fermer |
|---|---|---|---|---|
| R-01 | Monde visuellement vide malgré beaucoup de scripts | élevée | compilateur, catalogue urbain et critères de richesse | traversée vidéo et inspection Place |
| R-02 | Téléportation non fonctionnelle après livraison | critique | tests privés publiés et registre de PlaceIds | journal client Roblox aller/retour |
| R-03 | Objets sans interaction | élevée | registre et audit de tags/ancres | couverture complète des interactions |
| R-04 | Assets copiés sans autorisation | élevée | registre de licence, revue imports | dossier de provenance |
| R-05 | Trop d'Instances / lenteur mobile | élevée | budget par Place, streaming, maillages | campagne performances mesurées |
| R-06 | Périmètre dérive vers une fausse API kOA | critique | mode WORLD_STUB et zéro réseau externe | revue de code/config et test réseau |
| R-07 | Collision d'IDs ou mauvais branchement futur | élevée | schémas et invariants IDs | validateur, tests migration |
| R-08 | UI de vote fictif trompeuse | élevée | message coming_soon unique | test d'absence de mutation |
| R-09 | Contenu politique incompatible avec Roblox | élevée | classification et admission de canal | revue politique avant publication |
| R-10 | Dépendance au copier-coller de longues générations | moyenne | fichiers modulaires, outil de build, CI | build reproductible par autre poste |
| R-11 | Enfermement joueur après échec Place | élevée | route secours et retour | test de panne et reconnexion |
| R-12 | Mélange identité Roblox et kOA | critique (futur) | pas de liaison en stub, fédération bornée ensuite | examen architecture identité |
| R-13 | Doc complète mais pas de code fonctionnel | élevée | statut honnête, preuves par critères | revue des artefacts exécutables |

Les sévérités ci-dessus sont des appréciations de conception, non des statistiques mesurées. Chaque risque sera attribué à un responsable lorsqu'un projet logiciel réel sera ouvert.
