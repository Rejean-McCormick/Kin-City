# Bible artistique — Kin City

## Intention
Un paysage de **cité du savoir** : lisible, accueillant, civique, chaleureux, exploratoire. Éviter un jeu de tir, un centre commercial générique ou huit boîtes identiques avec des écrans. Le centre concentrique rappelle symboliquement l'île René-Levasseur, le mandala et une géographie de coopération, sans prétendre reproduire physiquement l'île.

## Contraste des quartiers
- Centre / EkoH : monumental sans domination, couronne de places piétonnes, pierre claire et vitrages verticaux.
- KonnectED / Univers-Cité : brique chaude, bois, rayonnages, lumière diffuse ; exploration et calme.
- eThikos : pierre civique, transparence des halls, espaces de discussion, aucune symbolique politique réelle imposée.
- keenKonnect : ateliers visibles, verrières, signalétique d'expérimentation, salles polyvalentes.
- Kreative : parcours de galeries, matériaux patinés, vitrines culturelles, contraste d'expositions.
- Orgo : circulation efficace, repères sobres, guichets et surfaces organisées.

Les couleurs hexadécimales de référence sont contenues dans `catalog/style_guide.json`. Elles ne prouvent pas un rendu correct sur les appareils.

## Silhouettes et détails obligatoires
Chaque bâtiment reçoit (a) silhouette reconnaissable vue à 100 studs, (b) façade active avec portail visible, (c) enseigne, (d) volume intérieur clairement différent du suivant, (e) au moins trois espaces visuellement différenciés dans les huit intérieurs de référence, (f) un objet interactif de type pertinent, ancré et accessible.

## Techniques de génération
- Variantes contrôlées par `visual_seed`, jamais randomness globale dépendante de l'ordre d'exécution.
- Matériaux et props modulaires avec provenance; aucune texture ou mesh copié d'un tiers sans droits.
- Niveau de détail adapté à la distance; silhouettes lisibles sur téléphone.
- Lumière de jour et d'intérieur documentée; vérifier textes, contraste et curseur/UI dans le simulateur d'appareils.

## Critères de revue visuelle
Captures du même lieu sur vue extérieure, hall, objet interactif et chemin de retour, pour chaque bâtiment. Comparer les captures aux références approuvées, documenter les exceptions, tester sur appareil faible capacité. « Riche » exige diversité spatiale et circulation, pas un nombre arbitraire de pièces.

**Asset Registry :** `catalog/assets.json` ne référence actuellement que des assets procéduraux *proposés*. Il doit être lié à du code de générateur réellement présent avant de prétendre qu'il est exécutable.
