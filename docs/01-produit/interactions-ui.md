# Expérience des objets interactifs et de la fenêtre stub

## Comportement visible

Quand le citoyen approche une étagère, un ordinateur, une borne ou un tableau, une invite contextualisée apparaît : nom lisible de l'objet et action « Consulter ». À l'activation, une seule fenêtre standard est ouverte, avec titre localisé de la capacité et texte **« Fonctionnalité à venir »**. Cette fenêtre possède une commande Fermer claire et un retour contrôleur/clavier approprié. Après fermeture, le déplacement redevient possible.

## Exemples

| Objet physique | `interaction_id` (illustration) | Titre stub |
|---|---|---|
| Rayon documentaire | `konnected.library.bookshelf_01` | Catalogue de la bibliothèque |
| Écran du palais | `ethikos.justice_palace.terminal_01` | Consultations eThikos |
| Borne citoyenne | `central.city_hall.vote_01` | Consultations Smart Vote |
| Tableau de cours | `konnected.university.board_01` | Cours Univers-Cité |
| Borne de musée | `kreative.museum.panel_01` | Collection Kreative |

**L'objet n'enregistre ni vote, ni inscription, ni crédit.** Aucun bouton final « Soumettre » ne doit laisser croire que l'opération est réalisée lorsque le fournisseur est un stub.

## UX

- Associer `ObjectText` au nom de l'objet et `ActionText` à une action compréhensible.
- Éviter plusieurs invites concurrentes au même endroit et prévoir une distance d'activation courte et testée.
- Un seul état modal à la fois ; fermeture possible via bouton et touche Esc/retour selon le contexte.
- Focus visuel, contraste, taille de caractères et lecture sur petit écran mesurés.
- En streaming, la disparition d'une Instance doit fermer son interaction proprement sans mémoire orpheline.

## Services Roblox pertinents

`ProximityPrompt` et `ProximityPromptService` permettent de centraliser le comportement ; `CollectionService` permet de taguer des objets stables, et les attributs associent les IDs. Les événements `Triggered` doivent être validés côté serveur avant l'ouverture d'une interaction de confiance. Ces APIs sont documentées par Roblox ; l'implémentation décrite reste cible.
