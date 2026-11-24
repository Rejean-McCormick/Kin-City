# Kin City — moteur de signalétique, architecture v31.7

**Objet.** Créer un langage de pancartes élégant, cohérent, extensible et léger pour l'interface spatiale Koali. Ce document est la source de décision du moteur : il décrit les limites, les invariants, la composition, les budgets et les modalités de déploiement. La ville n'est pas un catalogue technique. Une pancarte nomme un lieu; une borne interactive porte éventuellement une action.

## 1. Principe et hiérarchie urbaine

- **Une seule enseigne principale par institution.** Les enseignes de façade portent le nom officiel du lieu, et non des diagnostics internes. Aucun panneau massif devant une avenue.
- **Repères de secteur** : à la place centrale, courtes étiquettes d'orientation intégrées à l'architecture; ne pas dupliquer le titre du bâtiment devant ses portes.
- **Bornes EkoH** : repères de découverte dans le halo transversal, sarcelle `#1E6864`. Les données EkoH privées et les détails techniques ne sont pas sur les pancartes.
- **Pavillons d'allée** : un titre court; lorsque la façade porte déjà ce titre, pas de seconde pancarte autonome.
- **Portes** : ProximityPrompt séparé; pas d'enseigne « ENTRÉE • » qui répète celle de façade.
- **Aucune mention** de « Moodle externe », « synchronisation simulée », `WORLD_STUB`, numéros de position horaire, « Koali » en préfixe systématique ou jargon d'intégration.

## 2. Architecture des composants

```text
src/shared/SignTheme.luau           [données : 6 palettes, échelle, IDs d'assets, règles]
                 |
src/server/SignEngine.luau          [composition : tailles, face A/B, 9-slice, teinte]
                 |
src/server/Factory.luau             [API historique Factory.sign(...) conservée]
                 |
   bâtisses / pavillons / bornes / parcours
```

**Séparation essentielle :** le moteur ne possède ni routes, ni traduction, ni vote. `Factory.sign(parent, name, position, yaw, text, width, height[, options])` reste le point d'entrée. La septième valeur est un objet `options` facultatif : `section`, `role`, `emblem`, `backText`, `doubleSided`. Les appels hérités restent valides. La convention `name.."Frame"` est préservée pour les scripts historiques, dont les routines d'édition et le carnet de Kreative.

### Un panneau = trois couches

1. **Support 3D** : une fine plaque avant opaque + une contre-plaque arrière, pas de grandes boîtes flottantes, couleurs issues du secteur.
2. **Décor 2D** : fond procédural (Frame) + éventuelle bordure `ImageLabel` neuf tranches (`ScaleType = Slice` et `SliceCenter`) + `UIStroke` si l'asset n'est pas configuré. Une **seule image PNG blanche/transparente** est utilisée dans toutes les sections; seul `ImageColor3` varie.
3. **Information** : un `TextLabel` hiérarchisé, une marque optionnelle **sur le recto seulement**. Le verso conserve le même texte par défaut, mais jamais l'emblème si `emblem="front"`.

**Important :** réutiliser une image ne signifie pas partager un même objet `ImageLabel` entre plusieurs pancartes. Les objets sont propres à chaque UI, mais pointent vers le même *ContentId* de texture; le contenu peut être mis en cache par le moteur Roblox. On évite six variantes de PNG identiques.

## 3. Motif réutilisable et ornements de coin

- Fournir **un atlas de cadre à transparence** (`assets/signage/kin_frame_9slice.png`) monochrome blanc de 256×256. À importer une fois dans Roblox et renseigner son ID dans `SignTheme.assets.frame`.
- `SliceCenter = Rect.new(48,48,208,208)`; les quatre coins gardent leurs proportions. Le centre transparent laisse voir la couleur de la plaque. `ImageColor3` teinte le trait. **Pas de PNG étiré en plein cadre.**
- Deuxième asset facultatif : `SignTheme.assets.emblem`, une silhouette neutre ou le logo officiel. Un emblème s'affiche au recto, côté gauche, uniquement si explicitement autorisé pour la pancarte.
- Économie supplémentaire : si un modèle demande des coins asymétriques, utiliser un **seul asset de coin** quatre fois avec `Rotation=0/90/180/270`. Ce mode doit rester **optionnel** car il ajoute quatre éléments UI par face; le mode de base privilégie le 9-slice unique.
- **Sans asset importé**, le moteur reste opérationnel : plaque couleur + contour `UIStroke` + marque de coin procédurale très discrète. Pas de dépendance réseau à l'exécution.

## 4. Palettes par secteur (la couleur commune ne disparaît pas)

| Secteur | Fond | Accent | Trait et ornement | Matière prévue |
|---|---|---|---|---|
| keenKonnect | sarcelle minéral | `#1E6864` | acier clair | métal satiné |
| ethiKos | brun bois profond | `#1E6864` | ambre doux | bois + teal |
| Kreative | prune sombre | corail modulable | ivoire | identité vivante |
| Université King Klown | bleu ardoise | bleu/gris doux | ivoire / laiton | rétrofuturisme civique |
| Ekole | encre noire | `#1E6864` | blanc cassé | monochrome |
| KonnectED | noir marbré | doré doux | filet teal | marbre noir / or |
| centre / EkoH | sarcelle profond | `#1E6864` | blanc opalin | unificateur |

`SignTheme.resolve(section, position)` privilégie l'attribut `KinSection`/`KinSector` sur les ancêtres; sinon utilise les six axes **seulement pour les panneaux réellement dans la ville**, avec un plafond de rayon. Les intérieurs éloignés héritent du thème neutre. Ce classement a lieu à la création, **pas à chaque frame**.

## 5. Adaptabilité aux dimensions

- Formats : `compact`, `standard`, `monumental` (monumental reste plafonné par l'urbanisme à 24 studs pour les institutions). L'API existante fournit largeur/hauteur; le moteur limite la densité de pixels et le nombre de lignes.
- Marges proportionnelles, texte tronçonnable en 1–3 lignes; jamais de police agrandie simplement pour remplir un panneau.
- À très faible hauteur : masquer automatiquement l'emblème, ne garder que le contour et le titre.
- Le `SliceCenter` de l'image ne varie **jamais** selon l'aspect ratio. Les zones centrale et latérales absorbent les changements de largeur.
- Recto et verso : deux `SurfaceGui` sur deux pièces physiques distinctes afin d'éviter la plaque arrière qui masque une face (bug v31.2). Les surfaces utilisent la face `Front` et la face `Back` respectivement.

## 6. Répartition du travail et performance

**Éviter les tâches par pancarte.** Aucun `Heartbeat`, `RenderStepped`, boucle d'animation, Tween permanent, `PointLight` ou `RunService` dans le moteur. Les panneaux sont statiques : les seuls changements sont événementiels (création, remplacement d'un titre, changement de thème Kreative).

**Budget cible (à mesurer en Studio, non une garantie) :**

- 2 pièces 3D par enseigne existante (compatibilité avant/arrière).
- 2 `SurfaceGui` par enseigne recto-verso, chacun avec 1 fond, 1 cadre optionnel, 1 texte, 1 `UIStroke` et au plus 1 emblème au recto.
- Maximum **un asset de bordure commun** + **un asset de symbole commun** pour toutes les sections (nombre de textures uniques = 0, 1 ou 2, selon les importations).
- `PixelsPerStud` réglé à 32–44 selon le format au lieu de 60 universellement; `MaxDistance` borné; aucune `AlwaysOnTop` (évite de dessiner à travers les murs).
- Éviter les `UIGradient` animés : Roblox indique que des reconstructions fréquentes de ColorSequence sont coûteuses.
- Éviter des `ImageLabel` de décoration sur les pancartes d'orientation mineures; les réserver aux enseignes de façade.

Le moteur fournit un audit `SignEngine.stats(root)` afin de compter les panneaux, les surfaces, les images et les assets uniques. Il ne fabrique pas de scores de performance FPS : seules les mesures du MicroProfiler ou de Studio peuvent confirmer les gains.

## 7. Teinte / *hue* et vote Kreative

- La méthode la plus économique est `ImageColor3` sur **un masque source blanc avec alpha**, plutôt que calculer des nouvelles images ou textures. Le terme « changement de hue » désigne une **teinte Color3**, pas un traitement par pixel.
- Le thème d'une enseigne se met à jour **sur événement**, en changeant le fond, l'UIStroke et l'ImageColor3 existants. Pas de destruction/recréation du `SurfaceGui`.
- Pour Kreative, le vote visuel peut recolorer les enseignes du quartier **une fois par changement du choix gagnant**, comme il le fait pour les lanternes; jamais les bornes ni le halo EkoH.
- Les libellés restent lisibles même après recoloration : l'ivoire est stable, seule l'accentuation change.

## 8. Déploiement, assets et repli

1. Générer le dépôt et les sources, puis configurer l'ID Roblox de la bordure **après upload via Creator Hub**, dans `src/shared/SignTheme.luau`.
2. Si l'ID est absent, le **cadre procédural est le résultat officiel de repli** : aucune erreur, pas d'image vide.
3. Exécuter l'installateur complet en mode **Edit**, sur une copie de Place. Un installateur complet reconstruit les objets générés et peut remplacer les retouches manuelles.
4. Pour une Place déjà construite, un correctif distinct est préférable; ne pas demander au client Roblox de modifier la propriété protégée `Source`.
5. Contrôler en jeu : front/back à 2 angles, contraste jour/nuit, vues rapprochées, façade UCKK, Ekole, EkoH, et plusieurs joueurs pour le vote Kreative.

## 9. Risques et limites explicites

- Les PNG locaux ne s'affichent pas automatiquement dans un jeu Roblox : ils doivent être téléversés, et les permissions de l'asset doivent autoriser l'expérience.
- `SliceCenter` doit correspondre **à la taille réelle du PNG importé**, ici 256×256, pas à la taille de la pancarte 3D.
- Trop d'éléments UI ou une forte densité de pixels augmente le coût de rendu; limiter le nombre de faces visibles.
- L'élément `SurfaceGui` se recalcule quand ses descendants changent : ne changer les couleurs qu'en réaction à un événement.
- Les façades ne sont pas des connexions aux logiciels réels de Koali; les noms restent des lieux, pas des états techniques.

## 10. Contrats de test

1. Compatibilité `Factory.sign` historique et retour d'une `BasePart`.
2. Une paire recto/verso lisible, même style, sans emblème au verso.
3. 9-slice uniquement si l'asset existe; `ScaleType.Slice`, `Rect.new(48,48,208,208)`.
4. 6 thèmes + neutre, résolution stable, jamais de positions horaires dans le texte affiché.
5. Toutes les pancartes conservent leurs noms attendus (`ReadableSign`, `ReadableSignBack`, `Text`, `name.."Frame"`).
6. Dynamique Kreative événementielle, halo protégé.
7. Aucun nouveau service en boucle, aucune lumière par enseigne; audit de comptage disponible.
8. Les 8 institutions, portes, emplacements et interactions restent inchangés.

## Références API

- [Roblox — conception 9-slice](https://create.roblox.com/docs/fr-fr/ui/9-slice)
- [Roblox — ImageLabel](https://create.roblox.com/docs/reference/engine/classes/ImageLabel)
- [Roblox — SurfaceGui](https://create.roblox.com/docs/reference/engine/classes/SurfaceGui)
- [Roblox — UIGradient](https://create.roblox.com/docs/reference/engine/classes/UIGradient)
