# Dépannage et diagnostic

## L'objet n'affiche aucune interaction

Vérifier tag `KinCityInteractive`, attribut `KinCityInteractionId`, présence du `ProximityPrompt`, distance/ligne de vue, `interaction_id` dans le catalogue, état de streaming et connexion du routeur serveur. Vérifier le journal d'IDs manquants ; ne pas créer un script spécial non versionné sur l'objet.

## La fenêtre affiche une clé brute ou ne se ferme pas

Vérifier `message_key`, dictionnaire `catalog/messages.fr.json`, gestion de focus du client, fermeture sur destruction de l'objet streamé et synchronisation de l'état modal. L'UI doit fonctionner sans API kOA.

## Une porte ne mène nulle part

Distinguer : destination absente du catalogue, Place non publié (ID nul), Place privé non accessible, téléportation échouée, `spawn_anchor` absent. Le test Studio ne prouve pas la traversée : vérifier avec le client Roblox et les Place IDs réels.

## Deux portes mènent au mauvais bâtiment

Comparer source/destination/return IDs et versions des manifests, détecter collisions d'ID, vérifier la résolution du registre serveur plutôt que les noms d'Instances visibles.

## Le monde ralentit

Regarder nombre de Parts, maillages, textures, scripts, PNJ en pathfinding, modèles persistants, streaming, nombre d'Instances chargées et temps de frame. Comparer rapport générateur avec profils appareils cibles. Ne pas « résoudre » un budget 3D en ajoutant un serveur de calcul externe.

## Le validateur des catalogues échoue

Lire la première erreur structurée, corriger ID/référence/clé/message, relancer. Le validateur ne télécharge rien, ne publie pas et ne modifie aucune place Roblox.

## Une fonctionnalité kOA semble déjà disponible

En `WORLD_STUB`, c'est un défaut de configuration si l'interface montre un vrai résultat métier ou fait des requêtes kOA. Désactiver le fournisseur, auditer le changement, restaurer le stub et tester zéro réseau externe.
