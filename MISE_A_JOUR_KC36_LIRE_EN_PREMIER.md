# KC36 — mise à jour expert, correction structurelle (27 octobre 2026)

Ce paquet est basé sur le snapshot du propriétaire `znapshot_KinCityV36_10271219.zip`. Il conserve les dix branches B01–B10 (B09 = intégration) et les 121 fichiers source GLB. Il ne contient **pas** de `.rbxl` modifié : seule la Command Bar dans Roblox Studio peut reconstruire votre Place locale.

## A. Actualiser le dépôt Windows (aucun VS Code)

Extraire **le ZIP de mise à jour** directement dans :

`C:\mycode\Kin_City\KinCityV36`

Autoriser Windows à remplacer les fichiers du même nom. Ne pas créer un sous-dossier supplémentaire. Vérifier la présence de :

- `src\server\B10WayfindingKC36.luau`
- `studio\KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau`
- `docs\09-refonte-urbaine\09_KC36_IMPLEMENTATION_ALIGNEMENT_1.md`

Si vous préférez une extraction propre, utiliser le **ZIP dépôt complet** pour remplir ce dossier dans un répertoire distinct d'abord.

## B. Appliquer dans Roblox Studio

1. Ouvrir `C:\mycode\Kin_City\KinCityV36\KinCity_36_DEV.rbxl`, **arrêter Play**.
2. Menu **Fichier > Enregistrer sous** : `KinCity_36_DEV_AVANT_ALIGNEMENT.rbxl`.
3. Ouvrir `studio\KC36_INSTALL_ALIGNEMENT_COMMAND_BAR.luau` dans le **Bloc-notes Windows** (clic droit > Ouvrir avec).
4. `Ctrl+A`, `Ctrl+C`, Roblox Studio > **Commande / Command Bar**, `Ctrl+V` et Entrée. **Ne pas le placer dans un Script de gameplay.** Taille ~53 000 caractères, sous la limite Studio de 100 000.
5. Attendre les lignes `KC36 VALIDÉ`, `KC36 OK` dans **Output**. En cas d'erreur, noter le message et ne rien réexécuter.
6. Exécuter de la même façon `studio\KC36_AUDIT_APRES_MIGRATION_RS.luau` (lecture seulement). Vérifier `PASS`.
7. `Ctrl+S`, puis Play ; observer **Maison Orgo**, **Agora Korum**, **Accueil/Kreative**, et les **six pancartes EkoH** des deux côtés. Vérifier également la pancarte « Avenue KonnectED » inchangée.

Sauvegarde d'exécution : `ServerStorage\KC36AlignmentBackup` (ancien monde + runtime). **Ne pas supprimer** avant acceptation visuelle.

## Limites et sécurité

- Les 121 modèles Art Deco du **Package lié** ne sont ni édités ni remplacés.
- Les historiques B01–B10 et les 23 sources KC33 verrouillées restent inchangés.
- Aucune migration des 8 portes, des contrats ou des 9 PlaceIds n'est faite.
- Les six conflits structurels **route/bâtiment** répertoriés en KC35 sont encore ouverts pour la prochaine phase de planification urbaine.
- Les 49 tests de régression et contrats ciblés passent hors Studio ; la nouvelle géométrie **n'a pas encore été exécutée sur ton poste**.

Source détaillée : `docs/09-refonte-urbaine/09_KC36_IMPLEMENTATION_ALIGNEMENT_1.md`.
