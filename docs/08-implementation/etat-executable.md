# Implémentation exécutable : état technique

Cette page remplace les déclarations « aucun Luau livré » conservées dans les anciennes spécifications v3. Ces documents restent normatifs pour l'architecture mais précèdent le code de la livraison 0.1.0.

Le package contient désormais un projet Rojo complet, un installateur Command Bar autonome et les scripts serveur/client de construction de monde.

**Éléments de conformité implémentés :** identifiants permanents, compilation déterministe du plan, scènes de rue et de bâtiment, placement géométrique des objets, ProximityPrompt, routage serveur, stubs visibles, transport local avec ancrage de retour, alternative multi-Place explicite (configurable uniquement avec vrais IDs).

**Différences avec la cible maximale :** les assets sont géométriques et stylisés (pas d'animations de PNJ complexes, ni de textures externes); les tests Roblox Studio ne sont pas exécutés automatiquement ici; le mode multi-Place doit être publié et vérifié; le moteur de détails artistiques est extensible.

Aucun code n'appelle kOA ni une IA. Un futur `KOA_CONNECTED` exigera de vrais contrats/adaptateurs distincts; le mode n'est volontairement pas proposé par l'implémentation actuelle.
