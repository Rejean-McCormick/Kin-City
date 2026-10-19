> **Mise à jour v3 :** pour les spécifications spatiales, les assets et les critères de construction normatifs, voir [`docs/07-construction/README.md`](../07-construction/README.md).

# Bâtiments, intérieurs riches et gabarits réutilisables

## Principe

**La façade est dans la ville ; le seuil de porte définit l'entrée logique.** Chaque bâtiment possède un identifiant permanent, un district, un gabarit extérieur, un plan d'intérieur, une ou plusieurs portes, des points d'intérêt et un ensemble de ressources. Les grands intérieurs peuvent résider dans des `Places` Roblox distincts ; les petites boutiques peuvent être locales sous contrôle du budget de performance.

## Catalogues de bâtiment

- `BuildingManifest` : identité, quartier, références de scènes, politique d'entrée, gabarits, destination, semence, ressources.
- `RoomManifest` (futur schéma à stabiliser) : géométrie de pièce, surfaces, lumière, meuble, cheminement et points d'interaction.
- `AssetRegistry` : mesh, texture, matériau, version, titulaire de droits, source, digest si disponible.
- `DoorManifest` : direction, entrée, destination, porte de retour et points de spawn.

Les objets de décoration n'exposent pas implicitement une action. Chaque objet interactif est instancié à partir d'un `InteractionManifest` avec ancrage physique connu.

## Classification

| Mode intérieur | Quand l'utiliser | Risques |
|---|---|---|
| `inline_streamed` | Hall léger ou petit commerce, même Place | coût de géométrie globale, streaming client |
| `separate_place` | Bibliothèque, musée, palais de justice, campus | chargement, changement de serveur, reprise de contexte |
| `shared_template_place` | Ensembles de salles similaires | isolement de sessions, mapping des portes et de retour |
| `event_place` | Amphithéâtre / rassemblement spécial | capacité de serveur et synchronisation sociale |

**Aucun `PlaceId` ne doit être inventé.** L'exemple utilise `null`. Le build de publication devra injecter des IDs officiels et prouver que chaque route peut être franchie.

## Exigences de richesse

Les intérieurs doivent être plus que des salles vides : caractère architectural, circulation intelligible, éclairage, mobilier plausible, plusieurs points d'intérêt identifiables, panneaux, zones de pause et mise en scène pédagogique. La richesse visuelle ne doit pas dépendre des fonctions kOA, qui sont stubbées.

## Familles de gabarits proposées

`civic_hall`, `library_stack`, `lecture_theatre`, `justice_chamber`, `lab_space`, `museum_gallery`, `office_lobby`. Réutiliser structure, éclairage et meubles sans rendre tous les édifices identiques : palettes, proportions, niveaux, éléments emblématiques et décorations paramètres.

## Contrôle qualité

Aucune porte ne s'ouvre sur le vide, les sorties sont signalées, les avatars ne tombent pas hors carte, les points d'interaction demeurent accessibles quelle que soit la distance de streaming, le joueur peut retourner au dehors même après un échec de téléportation.
