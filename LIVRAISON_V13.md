# Kin City — Construction v13.0 : promenade des métiers et coopération

Cette livraison **continue directement la v12**, sans remplacer les plans canoniques, sans appels HTTP à kOA et sans IA payante au runtime.

## Réalisations codées

**1. Promenade des métiers : 9 commerces supplémentaires** dans les emplacements libres de la couronne extérieure, suivant un registre déterministe de 48 emplacements candidats. Les autres candidats sont exclus pour préserver les six agoras, les serres pédagogiques, les huit panoramas, les douze quais, les deux marinas, les six ponts insulaires et les grandes institutions. Les neuf commerces sont localisés aux emplacements 07, 15, 16, 22, 23, 31, 39, 40 et 46; leur nombre est un résultat attendu du registre, non une observation Roblox.

Chaque atelier est un vrai volume visitable à entrée libre : sol, façade avec vitres, linteau, toiture, auvent, comptoirs, collections physiques, rayonnages, siège utilisable, plantations, enseigne et chemin d'accès. Six thèmes alternent : reliure, botanique, céramique, textile, lumière et musique. Chaque présentoir est activable avec `E`, et tourne localement côté serveur. Un terminal distinct présente « Fonctionnalité à venir » sans simuler d'achat ni de données kOA.

**2. Six rues secondaires** entre les quartiers résidentiels et les agoras. Pavés physiques, allées végétalisées, banquettes fonctionnelles, panneaux et 36 lanternes avec lumière. Les arbres procéduraux évitent les nouvelles parcelles et corridors.

**3. Six installations de coopération** à deux consoles distinctes, attenantes aux agoras. Deux joueurs différents doivent activer les deux postes à moins de 14 secondes d'intervalle; l'orbe prend vie et s'anime durant 14 secondes. Les états transitoires restent sur le serveur, sans crédit, identité kOA, vote ou inscription. Notifications non bloquantes, avec indicateur de délai et possibilité de réessayer.

**4. Carte et guide** : les neuf commerces sont ajoutés via `PromenadeCommerce` partagé; aucune duplication manuelle des positions entre interface et scène.

## Sources ajoutées

- `src/shared/PromenadeCommerce.luau` : adresses, styles et zones de réserve.
- `src/server/PromenadeCommerce.luau` : façades et contenus visitables.
- `src/server/PromenadeCraftRuntime.luau` : animation locale des présentoirs.
- `src/server/SecondaryStreets.luau` : six rues pavées éclairées.
- `src/server/CooperativeInstallations.luau` : six œuvres à deux consoles.
- `src/server/CooperativeRuntime.luau` : coordination serveur avec délais.
- `src/client/CooperativeHud.luau` : messages non bloquants pour la coopération.

Les intégrateurs `CityGenerator`, `WorldBuilder`, `init.server`, `init.client`, `MapHud` et `RouteGuide` ont été mis à jour. Le build a une nouvelle révision `construction-v13.0.0` : une scène v12 réutilisée sera reconstruite.

## Installation dans Roblox Studio

1. Ouvrir **une copie** d'un projet Roblox Studio ou un nouveau Baseplate.
2. En mode Édition, copier entièrement `KinCity_Installer_CommandBar.luau` dans **View > Command Bar** et l'exécuter.
3. La géométrie apparaît sous `Workspace/KinCityGenerated`. Appuyer sur **Play**.
4. Sur la promenade extérieure, entrer dans un atelier et appuyer sur **E** à la console du présentoir.
5. Près des six agoras, deux visiteurs utilisent chacun une console « Activer en équipe ». `M` et `N` montrent les nouveaux commerces; les autres interfaces demeurent.

Alternative développement : `default.project.json` pour Rojo; `python tools/make_studio_installer.py` pour réassembler l'installateur après modification.

## État honnête

Sources Luau et installateur générés. Les 13 tests Python préexistants réussissent; ils n'exécutent pas les modules dans Roblox Studio. **Le comportement et le rendu réels ne sont pas vérifiés dans Roblox.** Le chiffre de 9 boutiques correspond à la sélection géométrique statique prévue, pas à une inspection du Workspace. Tous les assets sont des primitives natives Roblox, pas des maillages 3D artistiques finaux.

## Suite encore à construire

- Développer les animations, les horaires locaux et les itinéraires des habitants R15.
- Étendre les intérieurs et varier les façades; ajouter une galerie commerciale aménagée à l'étage de la gare.
- Enrichir les activités coopératives (plusieurs rôles, machines complexes, mini-exploration locale), en restant sans logique kOA.
- Créer/importer des modèles 3D et textures de qualité supérieure et les sons avec IDs Roblox autorisés.
- Ajuster le streaming et les budgets mobiles à partir d'une exécution réelle Roblox Studio puis d'un client publié.
- Garder **tous les services kOA en WORLD_STUB** tant que l'univers autonome n'est pas terminé.
