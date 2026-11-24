# KC36 — Atelier intérieur, correction définitive de lisibilité (UI V2)

## Origine du défaut

Le menu général `KinCityMenu.register` calcule `normalWidth` et `normalHeight` à partir **des offsets seuls** de `window.Size`. L'atelier avait une taille relative (`UDim2.new(0.92,0,0.76,0)`) donc ses offsets étaient nuls : le menu l'imposait à **240 × 135** pixels (minimums internes), recentré dans l'écran. Il enfermait en outre le propre `ScrollingFrame` de l'atelier dans un second conteneur défilant, rendant ses actions presque invisibles.

## Conception définitive

- Opt-in `KinUseNativeWindowLayout = true` pris en charge dans `KinCityMenu.register` : garde la fermeture, l'exclusivité des outils et l'entrée de menu, mais ne touche **ni** à la position et aux dimensions **ni** aux enfants de cette fenêtre. Les autres outils suivent le traitement v30 d'origine.
- Atelier de largeur maximale 448 px, ancré au bord droit sous le bouton Kin City, hauteur max 770 px et bornée selon `CurrentCamera.ViewportSize`. Un seul `ScrollingFrame` pour les commandes, pas de scroll imbriqué.
- En-tête et bandeau d'état toujours visibles ; sélecteur explicite ON/OFF ; commandes X, Z, Y, rotation, Dupliquer, Effacer, Annuler et Rétablir en paires de boutons lisibles à `TextSize=15` (jamais de `TextScaled` qui s'emballe).
- Clic/touche hors panneau uniquement pour sélectionner ; surlignage de l'objet conservé ; confirmation double d'effacement, permissions du serveur et sauvegarde d'opérations inchangées.

## Installation

Ouvrir **Place principale 72097868581669**, Play arrêté, sauvegarder une copie, copier le contenu de `installer/KC36_CORRIGER_INTERFACE_ATELIER_RS.luau` dans **Command Bar**. Attendre `PASS KC36 ATELIER UI V2`, puis Ctrl+S et Play. Tester dans un intérieur, ensuite republier la même Place après validation.

La commande modifie uniquement `StarterPlayerScripts > KinCityUI > KinCityMenu` et `InteriorEditorClientV36`. Les anciennes sources sont sauvegardées dans `ServerStorage > KC36AtelierUILayoutBackup_v2`. Aucune reconstruction, aucun changement aux mécanismes ou au DataStore.

## Validation d'acceptation Studio

1. À écran ~1500×1000, l'atelier apparaît à droite, avec toutes les actions visibles ; le nom du meuble sélectionné reste en haut.
2. Faire `SÉLECTION : ACTIVER` > sélectionner une table autorisée > déplacer en X et Z > dupliquer > effacer la copie avec double confirmation > Annuler > Rétablir.
3. Redimensionner Studio, vérifier que le panneau tient dans la fenêtre ; si hauteur insuffisante, **un seul** défilement vertical est présent.
4. Vérifier que le menu Musique et le menu ancien de construction gardent leur propre mise en page.
5. Tester la mise en ligne après publication : cette livraison a été validée par tests de source, pas visuellement dans ta session Roblox Studio.

## Limites conservées

L'atelier reste réservé au propriétaire et aux meubles autorisés dans les huit intérieurs ; il ne déplace pas toute l'architecture. L'historique DataStore n'est effectif que lorsque l'API est disponible en production. Le curseur sélectionne les objets grâce à la validation du serveur. Le glisser-déposer en temps réel n'est pas encore livré.
