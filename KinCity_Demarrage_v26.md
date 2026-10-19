# Kin City v26 — Démarrage (vraies Places séparées)

## A. Prévisualisation immédiate des scènes sans publication

1. Ouvrir une copie du projet dans **Roblox Studio > Édition**.
2. Coller `KinCity_Installation_Directe_v26.luau` dans **View > Command Bar** : le script ne construit que **la ville extérieure**.
3. Appuyer sur **Play** pour parcourir la ville. Les façades des huit institutions et leurs portails sont présents, mais les portes de transfert affichent honnêtement « Place distincte — à publier ».
4. Pour explorer un grand intérieur dès maintenant, ouvrir **une Place Studio distincte** et y exécuter l'un des fichiers `KinCity_Installation_Place_<nom>_v26.luau`. Chacun construit **un seul grand bâtiment visitable**.
5. Coller `KinCity_Diagnostic_Places_v26.luau` en Command Bar pour confirmer le mode, le monde actif et la présence exacte d'un intérieur ou de la ville.

**Attention :** n'exécutez pas les neuf installateurs dans la même Place l'un après l'autre : ils remplacent le monde actif. Le but est bien **neuf Places différentes**.

## B. Passages réellement fonctionnels entre neuf Places publiées

1. Dans la même **expérience Roblox**, créer et publier une Place principale `city` et **huit Places institutionnelles** (voir `build/place-package-plan.json`).
2. Dans `config/place_ids.json`, remplacer chaque `null` par son **véritable PlaceId numérique**, obtenu auprès de Roblox. Ne jamais utiliser un identifiant inventé.
3. Dans `config/runtime.json`, passer `mode` de `LOCAL_UNIVERSE` à `MULTI_PLACE`.
4. Exécuter localement `python tools/build_release.py` pour régénérer les scripts qui embarquent le nouveau registre d'identifiants et les métadonnées de chaque Place.
5. Installer dans chaque Place Roblox **son propre** `KinCity_Installation_Place_<key>_v26.luau`, publier chacune des neuf Places et vérifier que la Place principale de l'expérience est la ville.
6. Tester depuis un **client Roblox publié**, en visitant une façade, son intérieur puis la porte de retour. Roblox Studio n'est pas une preuve suffisante pour les téléportations `TeleportAsync` entre Places publiées.

## C. Fichiers et comportements

- `KinCity_Installation_Directe_v26.luau` : extérieur uniquement (alias de `Place_city`).
- `KinCity_Installation_Place_*.luau` : huit intérieurs + ville, chacun ciblé individuellement.
- `KinCity_Installation_Univers_Local_v26.luau` : secours historique **tout-en-un** pour tester sans changer de Place.
- `KinCity_Diagnostic_Places_v26.luau` : lecture des propriétés de la Place et du compte de modèles.
- `KinCity_Enregistrer_Mesh_Studio_v25.luau`, `KinCity_Enregistrer_Materiau_Studio_v25.luau` : import artistique facultatif conservé.

**Pas de branchement kOA, pas de paiement ni de création de Place automatique.** Les commandes changent la scène de façon directe : travailler sur des copies sauvegardées.
