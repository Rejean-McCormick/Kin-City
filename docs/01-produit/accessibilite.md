# Accessibilité, localisation et appareils

## Public

L'expérience se veut largement accessible à différents âges et capacités, sur PC, tablette, téléphone et éventuellement manette. L'accessibilité ne doit pas être confinée à la version Web future.

## Interactions

Les invites standard affichent les entrées adaptées aux périphériques. Les commandes doivent fonctionner sans viser précisément un petit bouton 3D. La fenêtre stub doit être lisible et fermable sur mobile ; les libellés d'action ne doivent pas dépendre uniquement d'une couleur ou d'un son.

## Mouvement

Prévoir des itinéraires lisibles, signalétique de retour, voies de circulation sans pièges, options de limitation d'effets visuels et caméra stable. Le mouvement via clavier/joystick est natif ; un menu de destination accessible est une capacité optionnelle à documenter si elle est ajoutée.

## Localisation

Le contenu initial visible est en français. Architecture de clés de message, versions et prise en charge ultérieure d'anglais/autres langues. **Les IDs demeurent ASCII et ne sont jamais des textes localisés.** Exemple `ui.coming_soon` → « Fonctionnalité à venir » et futur `en` → « Coming soon ».

## Qualification

Tester au minimum sur écran large, téléphone/tactile et manette, avec polices agrandies dans l'environnement si disponibles. Consigner capture, appareil, résolution, interaction testée, résultat, problème connu. Les critères chiffrés d'ergonomie devront être établis et mesurés dans la campagne de qualification.
