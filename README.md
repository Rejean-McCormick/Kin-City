# KIN CITY / KOALI — v31.9.7 (dépôt propre)

**Version intégrale avec 6 secteurs et 8 institutions dans UNE Place Roblox.**

## Installation

Voir **[GUIDE_INSTALLATION.md](GUIDE_INSTALLATION.md)**. L'installateur unique et destructif :

`installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau`

Il réinitialise exclusivement les composants **Kin City** connus de la Place ouverte, installe la version courante de tous les modules, puis construit la ville en mode Édition. À utiliser **Play arrêté** dans la *Command Bar* Roblox Studio. Sauvegarder la Place avant utilisation si nécessaire.

## Dépôt nettoyé

- `src/shared`, `src/server`, `src/client` : sources Luau réelles.
- `catalog`, `config`, `schemas` : données du projet.
- `assets` : textures, sons facultatifs, géométries et signalétique source.
- `installer` : le SEUL installateur complet.
- `tools` : scripts de génération et validation.
- `tests` : tests de régression statiques.
- `docs` : documentation de référence (l'historique détaillé reste dans Git, pas au root).
- `build` : données compilées nécessaires, sans logs historiques.

**Ne pas importer les MP3 locaux dans le repo.** Le lecteur utilise les 48 AssetIds Roblox connus; la 49e piste *Univers-City* dépasse la limite de durée et reste non liée. Plusieurs fichiers Roblox sont en modération ou ont été refusés : le script ne peut pas rendre jouables des audios bloqués.

**La publication n'est pas automatique.** Un installateur Command Bar ne peut pas surmonter un HTTP 403 ou une erreur du service Roblox. Vérifier la publication via l'historique de la Place et un nouveau serveur. L'expérience existante est PlaceId `72097868581669`, UniverseId `10772014442`, propriétaire UserId `10039817530` si vous l'ouvrez dans l'expérience déjà configurée.
