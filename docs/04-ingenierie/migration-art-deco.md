# Kin City / Koali — architecture Art Deco v2

## Base et choix retenus

Cette version part du snapshot fourni `znapshot_Kin-City_10250919.zip` (v31.9.7), commit local de base `05220a0`, et remplace l'assemblage expérimental du premier refactor. Branche locale : `refactor/art-deco-contextual`. Aucun HEAD GitHub n'a été vérifié ou modifié.

La dernière consigne autorise la recomposition des anciennes géométries générées. Les contraintes explicites conservées sont les six secteurs avec leur couleur de highlight, les pancartes et leur moteur d'ornements, et le lecteur MP3. Les huit institutions, le plan de circulation, les portes, la place Koali et le halo EkoH restent aussi présents ; cela permet de moderniser la ville sans refaire le routage.

La protection de la Place publiée `72097868581669` reste active. Aucun script de cette livraison ne publie une Place.

## Architecture réellement construite par le code

Les institutions ne sont plus constituées d'un socle, d'un étage et d'un couronnement empilés puis réduits. `ArtDecoLayout` compile des volumes architecturaux adaptés au gabarit, une ouverture publique et des emplacements d'habillage. Le plan de volumes existe intégralement même sans bibliothèque importée.

| Institution | Composition |
|---|---|
| Accueil | Corps civique large, pavillon central, portique et fenêtres en arc |
| Observatoire EkoH | Socle bas et silhouette verticale ; le sommet importé remplace le fût visible lorsque disponible et autorisé par son budget |
| Agora Korum | Composition horizontale, pavillon central plus large, motif architectural |
| Atelier Konstruct | Volume bas et pavillon supérieur allongé |
| Grande Bibliothèque | Corps large et pavillon longitudinal |
| Université King Klown | Corps central et deux pavillons latéraux |
| Galerie Konservation | Couronnement à trois gradins |
| Maison Orgo | Corps civique et pavillon central compact |

Le pack est utilisé comme bibliothèque de composants : colonnes, fenêtres, éléments de couronnement, éclairage, mobilier et environnement. Il ne fournit pas automatiquement huit intérieurs complets. Les modèles de façades historiques Blue/Red/Violet ne définissent pas la palette des secteurs.

Les volumes principaux sont des primitives sobres ; les composants importés ajoutent le vocabulaire Art déco. La toiture, les corniches et les ouvertures sont définies par la composition. Le grand `BuildingCore` invisible de la version précédente a été supprimé. Les collisions proviennent du sol, des murs avec ouverture et de la toiture, pas des enveloppes de meshes.

L'ouverture publique possède 10 studs de largeur dans les recettes actuelles. Les enseignes sont placées au-dessus de l'entrée et rendues par le `SignEngine` existant. Les fenêtres, colonnes et détails importés n'ont pas de collision.

## Six secteurs et pancartes

La division en six axes reste celle du plan Koali. Chaque avenue dispose maintenant d'une pancarte compacte portant explicitement son identité de secteur, en plus des repères existants.

| Secteur | Highlight |
|---|---|
| keenKonnect | `#D0BF86` |
| ethiKos | `#A97C4F` |
| Kreative | `#CB809D` |
| UCKK | `#758EA6` |
| Ekole | `#E5EAE7` |
| KonnectED | `#BC674C` |

La base architecturale commune utilise pierre, foncé, sarcelle et bronze. L'accent identifie les détails ; il ne transforme pas chaque façade en bloc monochrome.

Le code de `SignEngine.luau` et de `Typography.luau` est inchangé. Les doubles filets, angles, linteaux, cabochons et autres ornements restent produits par ce moteur. Le vote d'ambiance Kreative est limité à son installation artistique ; il ne recolore plus les avenues ni les pancartes d'identité.

## Intérieurs

Les salles, les portails et les ancres existants restent exploitables dans une seule Place. Les grandes institutions conservent leurs origines intérieures éloignées du centre de la ville.

Les anciennes couches purement décoratives appelées successivement par pièce ont été retirées du générateur actif. `ArtDecoRooms` prépare désormais des stations de travail, de détente ou d'exposition selon l'institution et la salle. Les propositions sont rejetées lorsqu'elles occupent le passage central, une ouverture ou le voisinage du mobilier canonique. Les tables de travail conservent une surface de travail ; elles ne sont plus remplacées globalement par une petite table ronde. Les bancs canoniques ne deviennent plus tous des canapés courbes.

Le renderer ajoute des assises utilisables, du mobilier sobre, une corniche et une seule canopée au hall de chaque institution. Les zones d'exposition utilisent les objets choisis par leur programme. Les repères du carnet de galeries sont conservés sans rétablir les anciennes piles de sculptures.

Les collections interactives des salles canoniques, l'Atlas vivant, les espaces spécialisés, les galeries/étages et les activités de découverte restent appelés. Cette version n'affirme donc pas avoir remplacé chaque ancien système de l'expérience ; elle remplace la composition des façades et simplifie les passes décoratives des salles.

## Budget préalloué et mobile

Les ressources sont réservées avant génération : huit comptes d'institution extérieure, huit comptes d'intérieur, six comptes de mobilier urbain et six comptes d'environnement. Une institution ou un secteur ne peut pas consommer le budget d'un autre.

`ArtDecoBudget` attribue des réservations et les rembourse une seule fois lors de la suppression d'un clone. Les recettes de mobilier choisissent des répétitions symétriques pour tous les secteurs, indépendamment de l'ordre de leurs boucles.

| Profil | Lampadaires importés prévus par secteur | Bancs importés prévus par secteur | Limite globale estimée de triangles importés |
|---|---:|---:|---:|
| LITE | 2 | 2 | 180 000 |
| STANDARD | 4 | 2 | 360 000 |
| SHOWCASE | 8 | 2 | 600 000 |

Les autres emplacements reçoivent le mobilier procédural commun. Une source absente produit un remplacement simple. Les benches importés reçoivent une assise fonctionnelle limitée à leur volume ; les grands colliders de meshes ne sont pas activés.

Les comptes vérifient aussi les BaseParts et les clones. Une marge d'une BasePart par clone couvre les hôtes de prompt et les assises. Les meshes restent statiques, sans collisions complexes, avec fidélité de rendu automatique et ombres de petits détails réservées au profil SHOWCASE.

Le manifeste complet est maintenant généré dans `src/server/ArtDecoData.luau`, plutôt que dans ReplicatedStorage. La bibliothèque privée reste dans ServerStorage. La réutilisation de la scène reconstitue les réservations ; les régénérations sélectives de façade ou d'intérieur les remboursent.

Ces plafonds concernent les éléments importés. Ils ne constituent pas une mesure de FPS, de mémoire totale ou de charge visible. Le décor procédural, les personnages, les lumières et la signalétique doivent aussi être mesurés sur mobile. Le choix du profil reste une configuration de build, pas un changement dynamique individuel de qualité par joueur.

## MP3

Les fichiers du lecteur, sa bibliothèque, ses AssetIds, ses catalogues et sa configuration audio sont inchangés et contrôlés par hash. L'amorce client qui démarre le lecteur est également conservée. Les tests existants des quatre albums, 49 titres et 48 AssetIds renseignés continuent de s'appliquer.

Une copie Roblox appartenant à un autre univers peut nécessiter les autorisations audio de cet univers. La livraison ne change ni les IDs ni la modération d'un audio. La lecture réelle reste à vérifier en Play sur la copie de test.

## Installation sur copie test

1. Ouvrir une nouvelle Place locale, ou une copie privée distincte. Ne pas ouvrir la production pour appliquer cette migration. La sauvegarde disque d'une Place de production peut encore porter son PlaceId ; le garde vérifie `game.PlaceId`.
2. Play arrêté, marquer la copie dans la Command Bar :

   ```lua
   workspace:SetAttribute("KinArtDecoTestPlace", true)
   ```

3. Pour une copie publiée possédant un PlaceId non nul, renseigner ce seul ID dans `config/art_deco.json`, champ `test_place_id`, puis reconstruire. Le PlaceId de production est toujours refusé.
4. Réutiliser les 121 sources privées de `ServerStorage/KC_ARTDECO_V32_SOURCES`, ou importer les 121 GLB normalisés dans `Workspace/KinCityArtDecoImports`. Garder les vertex colors et la séparation des rôles ; ne pas merger tout le modèle en une seule partie.
5. Exécuter `studio/PrepareArtDecoLibrary.luau`. Il vérifie les noms et doublons, prépare les 121 sources et conserve l'éventuelle bibliothèque précédente. Il ne crée pas de galerie. Retirer ensuite de Workspace le dossier d'import de transit pour ne pas afficher les originaux en plus de la ville.
6. Exécuter entièrement `installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau`. Le garde de cible précède toute suppression. ServerStorage et la bibliothèque privée sont conservés.
7. Exécuter `studio/RunArtDecoChecks.luau`. Le script qualifie les clones/pivots, les huit ouvertures dans le moteur, les six pancartes et leurs ornements. Il nettoie ses clones temporaires même après échec. Il n'a pas été exécuté dans cette session.
8. En Play, vérifier les six secteurs, les huit institutions, le lecteur MP3, les transitions, les activités conservées et les assises. Mesurer les parcours sur les appareils mobiles cibles.

Aucun import GLB ne peut être réalisé par une Command Bar ordinaire à partir d'un chemin disque. Les fichiers commerciaux ne sont pas inclus dans le ZIP de sources.

## Reconstruction et validation hors ligne

```bash
python -m pip install -r requirements-dev.txt
python tools/art_deco_catalog.py
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/build_release.py
python -m unittest discover -s tests -v
```

La release régénère les données serveur, le plan, la préparation de bibliothèque, l'installateur et le manifeste de hashes. Les tests exécutent le compilateur d'architecture, le planificateur de salles et l'allocateur de budget réellement utilisés par le renderer ; ils analysent également la syntaxe Luau et vérifient la reproductibilité.

## Migration et limites

L'installateur reconstruit les objets Kin City de la copie test. Cette opération reste destructive sur cette copie, sans rollback transactionnel global. Le contenu généré précédent peut être remplacé, conformément à la dernière consigne. Une sauvegarde de la copie test reste utile pour les essais.

Les sources manquantes produisent les volumes natifs et meubles simples de cette nouvelle architecture. Passer `enabled` à false désactive les habillages importés ; cela ne rétablit pas l'ancien empilement de tours.

Appliquer le patch cumulatif sur une branche du dépôt Windows après `git apply --check`. Si une première livraison a déjà été appliquée, utiliser le patch incrémental depuis `af7beca`. Ne pas remplacer le dossier `.git` de votre dépôt. Le bundle conserve l'historique de travail local.

Avant une fusion GitHub, comparer cette branche avec les changements intervenus dans votre dépôt depuis le snapshot. La publication de la vraie Kin City reste distincte et soumise à accord explicite. La licence Fab applicable doit être confirmée avec l'achat ; aucun pack autonome n'est redistribué.
