# Kin City v31.9.7 — réinstallation totale

## Étape 1 : nettoyer le dépôt local

La racine de ce ZIP contient `Kin-City`. Comme tu veux **effacer ton ancien repo**, renomme ou supprime son dossier, puis utilise ce dossier `Kin-City` comme nouveau dépôt de travail. **Ne copie pas par-dessus** : Windows laisserait les anciens fichiers devenus orphelins. Si tu veux garder l'historique Git, réinstalle le contenu en conservant uniquement l'ancien `.git` (si tu maîtrises Git).

## Étape 2 : WIPER et réinstaller la Place dans Roblox Studio

1. Ouvre la **bonne Place** dans Roblox Studio; vérifie PlaceId `72097868581669` et UniverseId `10772014442`. Si tu utilises une autre Place, le script opère sur celle qui est ouverte.
2. **Arrête Play** (très important).
3. Ouvre **Affichage → Command Bar / Barre de commande**.
4. Ouvre `installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau` avec VS Code ou un éditeur texte, copie **TOUT**, colle dans Command Bar et appuie sur Entrée.
5. Le script détruit **les objets Kin City connus** en Workspace, ReplicatedStorage, ServerScriptService, StarterPlayerScripts, Lighting et les anciens RemoteEvents; puis réinstalle les modules et reconstruit six secteurs et huit institutions en Édition. Il ne supprime ni Terrain ni les objets étrangers au projet.
6. Dans **Sortie / Output**, cherche `KOALI v31.9.7 : MONDE PRÊT`. Une commande dépassant 100000 caractères peut ne pas être sauvée dans l'historique Studio : cela ne signifie pas un échec.
7. Lance **Play**, vérifie la ville et le bouton **♫ MUSIQUE**, puis arrête Play.

**Attention** : cette reconstruction supprime les modifications manuelles apportées aux objets Kin City de la Place. Le stockage DataStore est distinct et n'est pas effacé par ce script.

## Étape 3 : publier la nouvelle cité

Utilise **Fichier → Publier** (`Alt+P`) lorsque la bonne Place est ouverte, ou **Publier sous** pour choisir explicitement l'expérience et sa Place de départ existantes. Ne crée pas une Place supplémentaire. Une copie locale visible ne prouve pas qu'elle est en ligne. Vérifie dans le Creator Dashboard la version publiée et joins un nouveau serveur.

Si publication échoue (`HTTP 403` ou `Erreur interne du serveur`), **réinstaller ne règle pas les permissions ni la panne Roblox**. Utilise **Fichier → Télécharger une copie** comme sauvegarde locale avant de résoudre la publication. Le repo propose l'installation complète mais ne remplace pas une publication Roblox.

## État du lecteur MP3

4 albums / 49 titres / **48 AssetIds** présents dans `src/shared/MusicAssetIds.luau`. 1 piste non importée : *Univers-City* (7:19). Les trois titres supprimés/modérés par Roblox doivent rester en attente des appels. Les audios privés doivent être autorisés pour l'**Universe ID `10772014442`**. Les références audio non autorisées rendent `HTTP 403` et ne seront pas jouées par le lecteur.

## Mode Création

L'accès DataStore n'est pas garanti dans un test Studio non publié. Pour le tester avec l'API Studio, utiliser une **copie de test** de l'expérience et activer l'accès aux API Services seulement après en avoir compris les conséquences sur les données.

## Recompiler l'installateur à partir des sources

Depuis la racine du dépôt : `python tools/make_universe_recovery_installer.py`.
Le générateur lit les sources de ce repo et produit à nouveau `installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau`.

## Option publication allégée (uniquement si erreur de publication répétée)

Après avoir installé la cité et vérifié Play, exécute **`installer/KinCity_PREPARER_PUBLICATION_LEGERE_OPTIONNEL.luau`** (Play arrêté). Ce script **supprime seulement le décor préconstruit** `Workspace.KinCityGenerated` et laisse les scripts et le cinéma en place. La ville sera alors **vide en mode Édition** : le serveur devra la reconstruire au prochain démarrage (plus long). Teste Play **avant** de publier. Si tu veux retrouver le décor en Édition, exécute `installer/KinCity_RESTAURER_DECOR_OPTIONNEL.luau`.

Ce mode est une optimisation facultative de la taille de la Place; il **ne contourne aucune erreur HTTP 403**.
