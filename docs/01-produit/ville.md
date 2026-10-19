# Urbanisme, plan directeur et expérience spatiale

## Topologie

La ville se décompose en **noyau central**, **anneau de quartiers** et **liaisons radiales**. Les bâtiments sont des nœuds et les chemins, passerelles, escaliers, rampes et portails sont des arêtes du graphe de navigation. L'emplacement 3D d'un objet ne devient jamais l'identité d'un itinéraire. Une mini-carte orientée vers le nord conceptuel et une signalétique physique complètent la navigation libre.

Le plan concentrique est documenté par la vision Kin City, mais aucune coordonnée, surface ou taille canonique n'a été fournie. Les rayons et positions du fichier `catalog/city.json` sont **des données d'exemple**, non une validation d'urbanisme.

## Composition cible

| Zone | Rôle spatial | Exemples de repères |
|---|---|---|
| Centre | Orientation, rassemblement | place, tour, hôtel de ville |
| KonnectED | Apprentissages | grande bibliothèque, université, amphithéâtre |
| eThikos | Délibération | palais de justice, agora, salle de débat |
| keenKonnect | Innovation | atelier, laboratoire, incubateur |
| Kreative | Arts et mémoire | musée, galerie, théâtre |
| Orgo | Gestion et services | centre administratif et guichets |

## Comportements obligatoires

Le joueur doit apparaître dans une zone dégagée, identifier au moins deux destinations sans aide textuelle complexe et se déplacer sans collisions accidentelles bloquantes. Les rues doivent être praticables au clavier, à la manette et au tactile. Tout chemin principal comporte des repères répétables, visibles à des distances variables. Les transports rapides sont optionnels; s'ils existent, ils ne remplacent pas la navigation à pied.

## Rendu et densité

Séparer : silhouette distante peu coûteuse, détails proches, interactions réelles. Les façades représentent l'intérieur sans en charger la totalité. Préférer maillages et modèles réutilisables plutôt que des milliers de pièces unitaires, textures/ambiances communes par quartier, colliders simples, et streaming mesuré.

## Génération

Un manifeste contient `district_id`, gabarit, empreinte, orientation, seed et ancrages. Le compilateur calcule les positions et refuse les chevauchements entre voies et façades si les règles de collision déclarées l'interdisent. Chaque graine doit reconstruire les mêmes coordonnées avec une version donnée du générateur et du catalogue d'assets.

## Preuves

Plan des routes, capture aérienne, preuve de sortie de chaque zone, essai de navigation sans téléportation, vérification des zones de collision, mesure de frame time côté mobile représentatif. Aucune métrique de performance n'est garantie par ce document.
