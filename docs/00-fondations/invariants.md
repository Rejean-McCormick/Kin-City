# Invariants et hiérarchie des responsabilités

## Invariants du jeu

- `WORLD_STUB` implique **aucune connexion externe à kOA** ; une URL future peut figurer dans la documentation, pas dans une configuration exécutée.
- Une porte est un routeur de navigation avec destination autorisée ; un panneau « fonctionnalité à venir » n'est pas une porte valide.
- Chaque interaction documentée et placée retourne un état UI déterminé, jamais une réussite métier fictive.
- Un ID d'objet n'est jamais réutilisé pour un autre élément, même après suppression : déprécier avant de remplacer.
- Les scripts de mécanique sont mutualisés ; les meubles/monuments reçoivent tags et attributs validés.
- Les modèles et composants sont compatibles avec le streaming et les appareils réellement visés.
- Les composants générés sont régénérables à partir de manifestes immuables versionnés.
- Les requêtes déclenchées côté client ne peuvent pas modifier l'état global sans validation serveur.

## Invariants écosystémiques [source kOA]

- Intégration ≠ transfert de propriété.
- Projection ≠ source de vérité.
- Identité fédérée ≠ rôle local.
- Smart Vote pondéré ≠ décision finale eThikos.
- Orgo possède ses Tasks, Cases et Workflows ; Konnaxion ses consultations et DecisionRecords ; UCKK ses états pédagogiques ; Koali ses présentations.
- Les schémas métiers canonisés restent dans leurs dépôts propriétaires et ne doivent pas être vendus comme schémas Kin City.

## États honnêtes

`coming_soon` = fonctionnalité prévue mais absente, `unavailable` = fonction active en panne, `denied` = pas d'autorisation, `error` = échec technique, `success` = confirmation d'une opération réelle. En mode autonome, seul `coming_soon` s'applique aux capacités métier ; les interactions locales (portes, menus, orientation) produisent de vraies réussites.
