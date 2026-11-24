# Kin City / KOALI — KC33 : mise à niveau Art déco et préparation multi-Place

**État réel : sources modifiées et installateur local reconstruit. Déploiement Roblox non exécuté.**

## 1. Ce qui a changé

- **8 façades** : diversification des modules extérieurs du pack, avec dimensions sources équivalentes. Les portes et couloirs de circulation ne changent pas.
- **18 pavillons** : trois variantes du pack par secteur, sélectionnées selon leur index ; enseignes adaptées à la hauteur mesurée de chaque variante. Les colliders natifs/fallback demeurent.
- **6 avenues** : insertion de vrais pavés/croisements Art déco au-dessus des dalles Roblox marchables. Les meshes importés restent sans collision. La circulation piétonne et le routage des portes demeurent fonctionnels selon le plan.
- **Quotas** : pool `paving` distinct du pool de lampadaires/bancs pour éviter l'éviction des décors par des éléments concurrents. Cadence progressive LITE/STANDARD/SHOWCASE.
- **6 couleurs** : positions verticales des tracés et repères corrigées pour réduire leur occultation par le dallage. Palette officielle inchangée.
- **8 intérieurs / 48 salles** : ajout d'habillages du pack sur les premiers escaliers, sans remplacer les vraies marches ni les ascenseurs, et d'un miroir décoratif par hall.
- **Sécurité multi-Place** : le runtime accepte une liste explicite de PlaceIds de *staging*, tout en bloquant la Place de production. Nouveau générateur de neuf installateurs individuels sous `tools/build_staging_places.py`.
- **Références du pack configurées** : 41/121, contre 32/121. Les 80 autres restent volontairement disponibles en bibliothèque, pas instanciés automatiquement.

## 2. Deux chemins d'installation

### A. Test immédiat sur la copie locale (fonctionnement à Place unique)

1. Sauvegarder la copie locale Studio ou exporter un `.rbxl` avant toute installation.
2. Ouvrir une Place **locale** (PlaceId 0) contenant déjà les **121 imports autorisés**.
3. Arrêter Play, activer `Workspace.StreamingEnabled`.
4. Coller intégralement `INSTALLER_KINCITY_KC33_LOCAL.luau` dans la Command Bar Roblox Studio.
5. Vérifier les huit façades, 18 pavillons, 48 salles, portes, escaliers, repères des six sections, musique et fonctionnement en Play.

**Attention :** l'installateur reconstruit les objets Kin City existants. Il ne modifie pas la Place de production et ne contient pas les meshes commerciaux. Dans ce mode de test, les huit intérieurs restent dans *la même Place*, à leurs coordonnées locales d'origine.

### B. Préparation pour neuf Places Roblox séparées (non réalisée sans identifiants réels)

1. Dans une **nouvelle expérience privée de staging**, créer **neuf Places publiées dans cette même expérience** (ville et huit intérieurs). Les PlaceIds sont propres à Roblox et ne doivent pas désigner la production.
2. Copier les modèles du pack sous licence dans chacune des Places, et activer StreamingEnabled.
3. Copier `config/place_ids_staging.TEMPLATE.json` en `place_ids_staging.json` puis remplacer les neuf `null` par les **PlaceIds réels de staging**, sans doublon.
4. Depuis `source/Kin-City`, lancer :

   ```bash
   python tools/build_staging_places.py --ids config/place_ids_staging.json --out build/staging-installers
   ```

5. Dans chaque Place de staging, sauvegarder une version privée, arrêter Play et activer **manuellement** le marqueur `workspace:SetAttribute("KinArtDecoTestPlace",true)` depuis la Command Bar.
6. Exécuter l'installateur `INSTALLER_STAGING_<NOM>.luau` correspondant à cette Place. Le garde anti-production et la vérification du PlaceId s'effectuent **avant la suppression** de la génération précédente.
7. Vérifier les neuf mondes et **tester les transitions dans le client Roblox publié**, et non simplement Play dans Studio.

**Important :** le générateur crée des scripts d'installation. Il ne crée pas les Places, n'effectue aucune publication, ne transfère pas les 121 modèles et ne remplit pas les identifiants automatiquement.

## 3. Tests et limites de cette livraison

- Exécutés ici : validation JSON, plan spatial, invariants de destinations, dix régressions statiques KC33, génération de neuf installateurs avec PlaceIds *synthétiques*, analyse lexicale des Luau et contrôles des quotas par manifestes.
- Non exécutés ici : les 89 tests complets historiques utilisant `lupa`/`tree-sitter-luau`, la compilation complète de Roblox Studio, les tests multijoueurs, TeleportService, le rendu visuel, l'expérience mobile et les mesures FPS/mémoire.
- Les estimations dans `build/art-deco-zone-audit.json` sont les **deltas de manifestes** appliqués au rapport V3, **pas** un audit Roblox ni la réexécution du planificateur Luau. La référence originale est sauvegardée en `build/art-deco-zone-audit-V3-REFERENCE.json`.

## 4. Ce qu'il reste à faire pour parler d'une vraie « mise à niveau totale »

1. Créer/publier les neuf Places de staging dans une même expérience et obtenir leurs PlaceIds, puis installer le bon script dans chacune.
2. Vérifier le placement réel des 121 meshes sur les copies Studio : entrées, escalier, alignement des pavillons et pavés, ombres, éclairage, lisibilité de chaque secteur, effets audio.
3. Exécuter la batterie complète de tests avec les dépendances requises, et corriger les éventuels échecs Studio/Luau.
4. Valider les **16 portes** aller/retour dans le client Roblox publié avec plusieurs joueurs, y compris les échecs/réessais, l'arrivée et le retour bibliothèque.
5. Comparer les performances *à Place unique avec StreamingEnabled* aux *neuf Places* sur mobile d'entrée de gamme et PC ; choisir le déploiement selon les mesures réelles.
6. Décider de l'architecture des voies **véhiculaires et du transport** : les croisements/pavés sont décoratifs, les anciens tramways/bus restent désactivés et les véhicules du pack ne roulent pas.
7. Curater et intégrer les **80 modèles encore en bibliothèque** uniquement si utiles au projet et compatibles avec les budgets ; ne pas les insérer tous sans plan de scène/LOD.
8. Documenter procédure de reprise, rollback, inventaire des assets par Place et mécanisme de publication contrôlé après qualification.

## 5. Garantie de conservation

`catalog/places.json`, `catalog/doors.json`, `catalog/spatial.json`, `config/interior_origins.json` et `config/runtime.json` n'ont pas été altérés : aucun vrai PlaceId, lien externe, service KOALI et destination métier n'a été inventé. Le comportement KOALI simulé reste simulé.
