# Kin City — Livraison v20 : nature sculptée et mobilier cristallin

**Statut : code de construction livré ; rendu et jouabilité non testés dans Roblox Studio.** La v20 s'appuie sur la v19. Les huit institutions, les interactions, les portes, le routage des transports, les origines stables et les identifiants restent inchangés. Aucun appel à kOA n'est activé.

## Construction ajoutée

### 1. Végétation procédurale diversifiée

`src/server/BotanicalKitV20.luau` remplace la recette des arbres génériques dans `CityGenerator`, **sur les emplacements existants**, sans modifier le filtrage qui protège bâtiments et sentiers.

- Trois silhouettes végétales (`seed % 3`) : conifère stylisé, feuillage étalé et couronne ovale.
- Couleurs dérivées de la palette verte/sarcelle du monde, variation reproductible par graine.
- Tronc porteur conservé ; feuillage sans collision, toucher, requête ni ombre, sans lumières supplémentaires.
- Profil `LITE` : peu de volumes ; `STANDARD` : branches occasionnelles ; `SHOWCASE` : rares fruits opalins sans lumière dynamique.
- Aucun tirage aléatoire à l'exécution : une reconstruction identique donne les mêmes variations.

Il ne faut **pas** interpréter le nombre de candidats au placement comme le nombre d'arbres réellement générés : les masques d'emplacements du générateur peuvent en écarter.

### 2. Ébénisterie cristalline dans les institutions

`InstitutionCraftV20.luau` crée des meubles vitrines/archives en ardoise, métal champagne et opale aux côtés de chaque pièce générée dans `InteriorGenerator`. Les motifs diffèrent selon les huit thèmes (archives, savoirs, orbites, justice, arts, réseaux, invention, cité).

- Les meubles sont placés dans les coins arrière à l'écart de l'axe central.
- Aucun objet canonique n'est remplacé ni déplacé ; aucune nouvelle interaction ne prétend offrir un service métier.
- Les ornements ont leurs collisions et requêtes désactivées ; seul le profil et l'identité institutionnelle font varier la densité.
- La version `LITE` fabrique une seule vitrine par pièce ; les autres profils deux lorsque les dimensions sont suffisantes.

### 3. Traitement des fenêtres en opale minérale

Les fenêtres du générateur des huit grandes façades utilisent désormais un émail opalin **opaque**, `SmoothPlastic` légèrement réfléchissant, plutôt que des couches `Glass`. Elles ne participent pas aux collisions/queries et ne portent pas d'ombre. Les autres types de vitrage déjà présents dans Kin City sont conservés : ce n'est **pas** une réduction générale des transparences de toute la ville.

Ce choix préserve l'identité `#1E6864` + `#C5F4F0` tout en réduisant le risque de coût dû à la transparence **pour ces fenêtres uniquement**. Les gains FPS réels ne sont pas mesurés.

## Moteur et livraison

- Nouvelle révision : `construction-v20.0.0`, signature de build dépendant du code et de la configuration.
- Installateur cumulatif `KinCity_Installation_Directe_v20.luau`, indépendant des v1–v19.
- Une commande : `python tools/build_release.py`, puis tests Python hors moteur.
- Toujours `LOCAL_UNIVERSE`, `WORLD_STUB`, aucun HTTPS kOA, aucun appel IA payant.

## À poursuivre

Mise en qualité des textures et modèles 3D réutilisables, animation des habitants R15, variation de l'ambiance sonore, réduction des couches anciennes de décor, et essai du jeu **dans Roblox Studio**. Les tests Python ne constituent pas une vérification d'exécution Luau ni une mesure de performance.
