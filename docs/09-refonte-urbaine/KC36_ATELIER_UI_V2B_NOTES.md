# KC36 — Atelier UI V2B, compatibilité des menus

## Cause

La migration UI V2 s’arrêtait sur `Ancre initiale du menu differente` avant toute modification : une recherche littérale ne reconnaissait pas le `KinCityMenu` installé dans la Place publiée.

## Solution pérenne

`InteriorEditorClientV36` s’enregistre via `KinCityMenu.registerAction`, laissant le menu existant intact. Le panneau latéral (448 px maximum) gère sa propre disposition et son défilement, son bouton Fermer, et ferme automatiquement lorsque l’utilisateur ouvre un autre outil via `Menu.open`.

## Portée

Une seule source changée : `src/client/InteriorEditorClientV36.luau`. Aucune modification de `KinCityMenu`, de `ServerScriptService`, du DataStore, des portes ou de la bibliothèque des 121 assets.

## Vérification RS

Exécuter l’installateur en édition dans la Place publiée 72097868581669. Attendre `PASS KC36 ATELIER UI V2B`. Sauvegarder puis lancer Play; ouvrir l’atelier et tester sélection, déplacement, duplication, effacement, annulation. Ces interactions ne sont pas validées hors Studio.

## Repli

Le texte source précédent est conservé sous `ServerStorage.KC36AtelierUIBackupV2B`. Ne pas republier sans vérifier l’UI en Play.
