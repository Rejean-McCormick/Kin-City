# Avatars, personnages non joueurs et présence sociale

## Avatars

Utiliser d'abord les avatars et contrôles standards Roblox dans les expériences publiques : marche, saut, caméra, assise et collisions fiables. Toute variante esthétique respecte les contraintes de rig/animation et droits d'utilisation. Il n'existe aucun besoin de fabriquer un personnage 3D par utilisateur.

## PNJ

Les personnages non joueurs enrichissent les rues et intérieurs sans prétendre à de vraies identités kOA. Registre d'archétypes (`guide`, `bibliothecaire`, `passant`, `agent_accueil`), modèle visuel, animations, zone autorisée, comportement déterministe et plafond de calcul.

États de base : `idle`, `wander`, `greet`, `return_home`, `disabled`. Priorité aux comportements locaux autonomes, sans IA inférentielle à l'exécution. Les PNJ qui promettent un cours, un débat ou une procédure doivent répondre honnêtement que cette fonctionnalité arrive plus tard.

## Charge et visibilité

Limiter le pathfinding simultané ; dégrader vers animation immobile lorsqu'un PNJ est loin ; séparer présence humaine réelle et décor généré. Aucun NPC n'est compté comme participant réel à une consultation. Prévoir une limite configurable de PNJ par Place testée sur appareil cible.

## Social

La présence des joueurs n'est pas une vérité globale entre Places : traverser une porte peut changer de serveur. Les discussions visibles dans Roblox doivent employer ses mécanismes de communication/modération applicables. N'implémenter aucune synchronisation de messages vers kOA en mode autonome.

## Vérifications

Tests à un et plusieurs joueurs, proximité PNJ/portes, entrée-sortie des bâtiments avec plusieurs avatars, immobilité d'un PNJ en streaming, collision et absence d'interactions superposées.
