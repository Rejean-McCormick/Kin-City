# Kin City — Construction et redressement v18.0

**Code cumulatif v1–v18.** Cette continuation applique les suggestions utiles de l’audit v17, en respectant la nouvelle décision : **pas de système de rollback**, pas d’arrêt de la construction et aucune connexion à kOA.

## Construction et comportement réellement modifiés

1. **Scène cohérente en mode édition et en Play.** `WorldBuilder` marque la ville `Building` pendant la construction, puis `Ready` à la fin. La réhydratation refuse une scène incomplète, une porte canonique absente, un objet interactif manquant ou une ancre canonique disparue. En cas d’erreur, la reconstruction directe demeure la stratégie choisie : aucune promesse de restauration de l’ancienne scène.
2. **Intérieurs modifiables sans perdre leurs bornes.** `CanonicalInteractions.bindPlace()` associe les capacités aux meubles physiques, à la génération initiale et après `WorldEditor.regenerateInterior()`. Les identifiants permanents ne changent pas.
3. **Origines spatiales stables.** Les huit intérieurs disposent d’origines explicites et largement espacées dans `config/interior_origins.json` et `InteriorOrigins.luau`. L’ajout d’un lieu dans le catalogue ne déplace plus les autres par effet de tri.
4. **Déplacements coordonnés.** `TravelSession` réserve une session exclusive par joueur pour porte, ascenseur, navette, correspondance, tram, ferry et minibus. Les déplacements asynchrones revérifient le personnage après le préchargement. Un respawn annule la session précédente. Les véhicules libèrent leur réservation lors du débarquement ou de l’arrêt.
5. **Annulations de transports.** Les ferries et minibus émettent désormais un état d’annulation vers l’interface lorsqu’une traversée est interrompue; le tram ne signale plus une arrivée si la boucle s’est arrêtée prématurément.
6. **Cristaux plus légers sans sacrifier l’identité.** Les petites rayures du mandala et les rayons des rosaces sont désignés comme détails optionnels. `CrystalDetailLOD` les masque localement au-delà d’une distance selon le profil visuel. Les gros cristaux, les façades, les portes, les collisions et les interactions ne sont jamais masqués par ce mécanisme.
7. **Interface et guidage.** Le carnet des îles ne chevauche plus le bouton de gare dans les coordonnées précédentes. Le panneau de gare dispose d’une mise à l’échelle sur petit écran. Les distances du guide sont libellées en **studs**, pas en mètres fictifs.
8. **Build synchronisé.** `BuildIdentity` tient compte des catalogues, des paramètres et des scripts serveur/client. La modification du cristal ou du runtime impose une reconstruction réelle. `tools/build_release.py` régénère plan JSON, sources Luau partagées, installateur et manifeste des sommes SHA-256 avec une seule commande. Le workflow CI installe ses dépendances.

## Installer le code

1. Faire une copie de son projet Roblox Studio avant le remplacement de la scène si celle-ci contient des ajouts manuels hors des catalogues.
2. En **mode Édition**, ouvrir `KinCity_Installation_Directe_v18.luau`, copier tout le contenu dans la *Command Bar*, exécuter, puis regarder la ville générée.
3. Vérifier dans les propriétés de Workspace que `StreamingEnabled` est activé, puis lancer **Play**.
4. Explorer les institutions et tester une régénération individuelle seulement en mode Édition. Le fichier `KinCity_Exemples_edition.luau` illustre les commandes.

Pour reconstruire l’installateur après une modification de source, de palette ou de catalogues :

```bash
python -m pip install -r requirements-dev.txt
python tools/build_release.py
```

Le fichier `build/release-manifest.json` distingue l’empreinte canonique du plan et l’empreinte totale du build.

## Ce qui reste ouvert

- **Roblox Studio non exécuté ici.** La compilation Luau effective, les collisions, les UI sur téléphone et les déplacements multipassagers doivent être essayés dans Studio et en client publié.
- Le répartiteur des 18 catégories de prompts et la gestion de cycle de vie de tous les services sont encore distribués dans plusieurs modules. Rien n’oblige à les réécrire d’un bloc pour continuer la construction.
- Le manifeste spatial canonique ne couvre pas encore toutes les extensions procédurales. Un inventaire complet par zone pourra être ajouté progressivement.
- Le LOD client cible les nouveaux petits ornements cristallins; il **n’optimise pas globalement** la foule R15, les lumières héritées, les transparences ou toutes les façades.
- Il reste la finition artistique 3D haut de gamme, le contenu sonore importé, la qualification mobile et la publication officielle Roblox.

**Périmètre inchangé : `WORLD_STUB`, pas de kOA, pas d’IA payante, interactions métier « Fonctionnalité à venir ».**
