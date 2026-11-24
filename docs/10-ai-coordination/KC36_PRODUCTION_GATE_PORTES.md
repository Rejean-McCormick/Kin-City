# KC36 — Démarrage en production et portes (correctif de source)

## Diagnostic confirmé par le journal Studio

- `game.PlaceId = 72097868581669` (Place principale publiée).
- `ArtDecoAssets.checkTarget()` échoue sur `production interdite` avant que `PlayerTravel.setup` et `PromptRouter.start` soient appelés.
- La scène publiée préconstruite reste visible (`KinBuildState=Ready`, 8 intérieurs) mais le runtime **n'a pas initialisé les portes**. `KinZone=nil` en découle.
- Le prompt EkoH est valide, l'ancre `ekoh_tower.lobby.spawn` est valide, mais aucun déplacement ne se produit.

## Correction durable

- `ArtDecoPolicy.isTestTarget` reste **strictement inchangé** et interdit toujours le PlaceId de production aux installateurs de test.
- `ArtDecoPolicy.isRuntimeTarget` autorise le seul `config.production_place_id`, sans dépendre du marqueur `KinArtDecoTestPlace`, ou bien une Place de test déjà autorisée et explicitement marquée.
- `ArtDecoAssets.allowed` et `checkTarget` s'appuient sur cette autorisation de runtime. En production, `checkTarget` vérifie le Package central et l'attribut 121/121.
- Aucun changement aux entrées, ancrages, bâtiments, structures, 121 GLB, lecteurs musique, PNJ ou contrats B01–B10.

## Application dans Roblox Studio

1. Ouvrir **la Place principale publiée** dans Roblox Studio (PlaceId `72097868581669`), et **arrêter Play**.
2. `Fichier > Enregistrer sous` pour une copie de sécurité. L'installateur n'est pas destiné à une Place locale `PlaceId=0`.
3. Copier intégralement `tools/studio/KC36_CORRIGER_PRODUCTION_PORTES_RS.luau` depuis le Bloc-notes, le coller dans la **Command Bar**.
4. Vérifier `PASS KC36 PRODUCTION GATE`. Les sources précédentes sont conservées dans `ServerStorage/KC36ProductionGateBackup_v1`.
5. Faire `Ctrl+S`, démarrer **Play** et vérifier : aucun message `production interdite`, `KIN CITY WORLD_STUB prêt LOCAL_UNIVERSE city`, `KinZone=city`, puis entrée à EkoH (`KinZone=ekoh_tower`) et retour.
6. Une fois validé : arrêter Play, retirer seulement `ServerScriptService/KC36DoorDiagnostic` (instrumentation temporaire de diagnostic), puis `Fichier > Publier sur Roblox` pour mettre à jour **la même Place existante**.
7. Tester la vraie expérience en ligne. Conserver le backup jusqu'à la validation.

**Limite :** ce correctif traite le blocage confirmé dans l'Output. D'autres erreurs, s'il y en a après ce premier verrou, devront être lues dans Output ; il ne constitue pas une preuve que toutes les portes ont déjà été testées en ligne.

## Dépôt

Extraire l'archive de mise à jour à la racine `C:\mycode\Kin_City\KinCityV36`. Elle modifie seulement 2 sources runtime et ajoute cette documentation, les tests et l'installateur. Ce correctif dépend du dépôt KC36 déjà aligné, avec la mise à jour Population appliquée séparément. `ArtDecoData`/`config/art_deco.json` conservent le registre de la Place canonique déjà présent.
