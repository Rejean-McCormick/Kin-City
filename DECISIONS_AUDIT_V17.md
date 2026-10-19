# Audit v17 — décisions de construction v18

L'audit fourni est conservé dans `docs/reference/audit-optimisation-v17-2026-10-19.md`.

## Accepté et implémenté dans la v18

- **F02** : état `Building` puis `Ready` et contrôle avant réutilisation.
- **F03** : nouvelle liaison des bornes après régénération partielle.
- **F04** : empreinte totale du build, incluant les visuels et les sources.
- **F05** : état streaming réel affiché; activation laissée à Studio.
- **F06** : session commune à portes, ascenseurs, navettes et correspondances, partagée avec transports.
- **F07** : libération commune des réservations et états d'annulation bus/ferry, résultat terminal tram vérifié; le cycle de vie de tous les services reste à consolider.
- **F09 / F10** : CI avec dépendances et sortie de build unifiée.
- **F11 / F28** : collision du bouton GARE/carnet corrigée, fenêtre gare réduite sur petits écrans, unités en studs.
- **F14** : origines intérieures stables en coordonnées explicites.
- **F22** : début de LOD client pour les détails cristallins; ce n'est pas une optimisation complète de la ville.

## Volontairement non retenu

- **F01 — mécanisme de retour arrière.** Suivant le choix de l'utilisateur, l'installation est destructive et directe. Aucune transaction ni copie de secours gérée par le logiciel n'est ajoutée.

## À poursuivre sans bloquer la construction

- **F08 / F15 / F17 / F19** : manifeste spatial exhaustif, déduplication artistique, centralisation des 18 catégories de prompts et nettoyage des services.
- **F18 / F20 / F21 / F23–27** : registres par zone, animation des PNJ et mécanismes côté client, budgets de rendu et streaming.
- **F29 / F30** : interface mobile consolidée et finition artistique 3D, toujours en sarcelle `#1E6864` et cristal opalin.
- Qualification en Roblox Studio et sur appareils réels non effectuée, faute de moteur dans cet environnement.

**Interdits maintenus** : aucune connexion kOA, aucun vote/score simulé, aucune IA payante en runtime, aucun PlaceId inventé.
