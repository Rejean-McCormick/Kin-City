# Kin City — Construction v21 : ville habitée et ambiance localisée

**Statut : code Luau livré ; aucun test dans Roblox Studio n'a été réalisé.** Reprise cumulative de la v20 ; projet conservé en `LOCAL_UNIVERSE / WORLD_STUB`, sans passerelle kOA ni IA payante.

## Construction réalisée

1. **CitizenAnimationV21** : animations de proximité des habitants R15 (marche, repos, lecture, jardinage, accueil et observation), calculées sur le client. Les types `Motor6D` et `AnimationConstraint` sont pris en compte. Un seul ordonnanceur `PreSimulation` contrôle les modèles tagués `KinCityAnimatedNPC` ; la distance utile est de 155 studs et la cadence maximale visée de 24 mises à jour par seconde. Le rendu est mis en pause hors zone. Aucun asset d'animation externe requis.
2. **CitizenPropsV21** : livres, carnets, outils et prismes miniatures fixés aux mains des habitants avec `WeldConstraint`, sans collision, sans masse ni ressources Marketplace. Couleurs compatibles avec le sarcelle `#1E6864` et le cristal opalin.
3. **ViewerPresenceV21** : les routines serveur des 10 PNJ R15 centraux, 12 PNJ R15 résidentiels, 36 citoyens stylisés et 14 oiseaux se mettent en veille décorative lorsqu'aucun joueur n'est proche. Les modèles et leurs interactions restent présents. Les routines reprennent lorsque des joueurs visitent ces zones.
4. **Routines des PNJ** : les déplacements et les activités sont décidés côté serveur et transmis par attributs `KinNPCMotion`, `KinNPCActivity` et `KinNPCPhase`. Le client ne décide pas des destinations.
5. **Soundscape** : la localisation sonore s'étend aux huit institutions et aux six quartiers résidentiels, en réutilisant les trois WAV originaux déjà fournis. L'audio est **désactivé par défaut** : il faut importer les WAV dans Creator Hub, puis renseigner les IDs dans `config/audio.json`, définir `enabled=true` et relancer `python tools/build_release.py`.
6. **Installateur v21** : génération de la ville dans la Command Bar de Studio, intégrant les nouveaux modules. Le manifeste de build et la révision de scène reflètent le nouveau code.

## Contrôles et usage

- `python -m pip install -r requirements-dev.txt`
- `python tools/build_release.py`
- `python -m unittest discover -s tests -v`
- Installation : copier `KinCity_Installation_Directe_v21.luau` en mode Édition, exécuter et lancer Play.

Les 31 tests Python passent. Ils portent sur les fichiers et contrats hors moteur ; ils ne valident **pas** le comportement des animations, le rendu des rigs, les collisions, l'acoustique ou la fluidité dans Roblox.

## Ce qui reste

- Essayer les habitants sur un rig R15 Roblox actuel et vérifier l'application des `AnimationConstraint`/`Motor6D`.
- Tester les performances sur appareils cibles avec une population active ; ajuster les distances de veille et la cadence.
- Importer les trois WAV, configurer leurs identifiants Roblox et vérifier leurs permissions audio.
- Raffiner les modèles/meshes de mobilier et d'architecture, personnaliser davantage les scènes intérieures et l'ambiance des quartiers.
- Qualifier la publication et les transports dans Roblox Studio / client publié.

**Fidélité produit :** les futurs services kOA conservent le message « Fonctionnalité à venir ». Les portes et les activités physiques conservent leurs comportements propres. L'installation reste directe, sans mécanisme de retour arrière.
