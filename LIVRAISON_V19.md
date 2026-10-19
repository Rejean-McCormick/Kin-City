# Kin City — Construction v19 : architectures habitées en sarcelle et cristal

**Statut : code de construction livré, non exécuté dans Roblox Studio.** La v19 poursuit directement la v18, sans changer les identifiants des portes, des places, des capacités ou des objets métier. Aucun service kOA n'est connecté. Tous les futurs services continuent d'afficher **« Fonctionnalité à venir »**.

## La construction effectivement ajoutée

### 1. Huit portiques institutionnels expressifs

Le module `src/server/CrystalPorticosV19.luau` ajoute à chacune des huit façades : des pilastres sarcelle, un fronton en chevron, une clef cristalline, une frise de métal champagne et une héraldique à géométrie spécifique. Les huit symboles diffèrent : rayonnement civique, constellation, archives-feuilles, orbite pédagogique, balance symétrique, mécanisme d'invention, prisme culturel et réseau Orgo.

L'intégration a lieu dans `FacadeGenerator.make()`, après la façade de base et ses précédentes couches. Ces ornements n'ont aucune collision, requête ou toucher, et le passage central est préservé.

### 2. Compositions murales thématiques dans les intérieurs

`CrystalRoomStoriesV19.luau` ajoute une composition minérale **dans les trois premières salles canoniques** de chaque institution, soit 24 panneaux en tout d'après le plan compilé actuel. Les panneaux sont décalés par rapport au centre du mur pour ne pas remplacer la signalétique déjà présente. Motifs et couleurs dépendent de l'institution, sans nouvelles fonctionnalités métier.

### 3. Signalétique au sol des chemins existants

`OpalWayfindingV19.luau` souligne les sentiers du plan avec des incrustations fines en sarcelle et champagne. Les tracés proviennent de `plan.pedestrian_paths` : le module ne trace pas de routes contradictoires. En `LITE`, une seule bande; en `STANDARD` ou `SHOWCASE`, deux. Ces pièces décoratives ne gênent ni la marche ni les interactions.

### 4. Architecture quotidienne

`CrystalEverydayV19.luau` unifie les cadres de porte, ornements de toiture et clefs opalines sur les **24 maisons résidentielles**, les **8 ateliers de gare** et les **9 boutiques de la promenade**, soit **41 façades secondaires prévues** dans les registres de construction existants. La géométrie reste sans collision. Les véritables portes et les scripts existants ne sont ni déplacés ni remplacés.

## Profil visuel et performance

- Matière de base : `#1E6864`, pierre sarcelle et accents métalliques champagne.
- Cristal : une majorité de facettes opaques, quelques surfaces `Neon` et seulement le vitrage de héros déjà encadré par la v17.
- Aucun nouveau `PointLight`, `Heartbeat`, `RenderStepped`, raycast ou PNJ par ces quatre modules.
- Les petits ornements portent `KinOptionalDetail` et sont masqués **sur le client** à distance par `CrystalDetailLOD` (v18).
- Aucun contenu de la v18 n'est retiré pour masquer une régression; l'installateur reste direct et destructif, sans rollback, conformément au choix utilisateur.

## Structure et installation

- Modules neufs : `CrystalPorticosV19`, `CrystalRoomStoriesV19`, `OpalWayfindingV19`, `CrystalEverydayV19`.
- Générateurs modifiés : `FacadeGenerator`, `InteriorGenerator`, `CityGenerator`, `ResidentialQuarters`, `StationArcades`, `PromenadeCommerce`.
- Compilateur et installateur : révision `construction-v19.0.0`, génération `tools/build_release.py` et installateur unique.
- Le ZIP v19 ne comprend **pas** la copie imbriquée de la v17 qui se trouvait par erreur dans la distribution v18. Il conserve les sources actives et les historiques documentaires.

**Installation :** dans une copie du projet Roblox Studio, coller intégralement `KinCity_Installation_Directe_v19.luau` dans la Command Bar en mode Édition, l'exécuter, puis lancer Play. Les sources peuvent aussi être utilisées avec Rojo.

## Ce qu'il reste

La finition 3D par meshes/textures, l'animation naturelle des R15, le streaming adapté aux scènes denses, les effets sonores importés avec de véritables AssetIds et la correction des anomalies qui pourraient être observées dans Roblox Studio. **Aucun test d'exécution Roblox ni mesure FPS n'a été réalisé dans ce livrable.**
