# Environnement de développement et démarrage

## Pré-requis du futur développement

Compte créateur et Roblox Studio, dépôt Git, éditeur de texte, Python pour valider les manifestes, puis outillage Rojo/StyLua/Selene si retenu. Aucun abonnement d'API IA n'est requis pour exécuter les générateurs.

## Vérification du paquet documentaire

Depuis la racine du ZIP extrait :

```bash
python tools/validate_catalog.py
```

Ce contrôle doit valider les JSON et références croisées. Il ne charge pas Roblox Studio, ne construit pas de Place et ne prouve rien sur l'exécution réelle du jeu.

## Démarrage du futur code (spécification de workflow, non commande existante)

1. Installer l'outillage verrouillé par version.
2. Charger les catalogues/schémas ; afficher les erreurs avant modification de Studio.
3. Compiler la ville et les intérieurs avec graines définies et vérifier le diff.
4. Synchroniser/générer vers Studio et observer les scènes.
5. Tester un joueur, serveur+clients, tablette/manette et portails locaux.
6. Publier vers une expérience Roblox **privée** pour tester les véritables téléportations.
7. Conserver preuves et état de build par Place.

## Cycle vibe coding

Un changement à la fois : manifester besoin → écrire/ajuster contrat → coder générateur ou routeur → vérifier → inspecter visuellement → mesurer → consolider documentation. Un agent peut aider à produire le code, mais aucun code inséré sans test/inspection.

## Testabilité

Garder les fonctions de calcul de géométrie/IDs pures hors du moteur quand possible, isoler le binding Roblox et utiliser des mocks seulement pour tests unitaires. Les tests d'intégration impliquant TeleportService restent dans une expérience publiée.
