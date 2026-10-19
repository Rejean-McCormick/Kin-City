# Kin City — Livraison v0.7.0

## Construction

| Fichier | Contenu concret |
|---|---|
| `src/server/Tramways.luau` | Huit lignes piétonnes transformées en tramways à la demande; 16 kiosques physiques, cabine 3D et trajet animé; blocage anti-double embarquement, débarquement latéral et restauration du personnage |
| `src/client/TramRideHud.luau` | Affichage de progression non bloquant pendant le trajet |
| `src/server/LearningConservatories.luau` | Huit serres ouvertes au public, vitrages, accès à pied, mobilier et huit installations scientifiques |
| `src/server/ScienceExperiments.luau` | Éclairage et mouvement activés côté serveur; explications courtes sans backend |
| `src/server/DiscoveryPromenade.luau` | 24 bornes physiques réparties sur l'anneau urbain |
| `src/server/DiscoveryLedger.luau` | Découverte unique par joueur et par halte durant la session, sans serveur externe |
| `src/client/TrailHud.luau` | Suivi des 24 haltes à l'écran |
| `src/shared/PublicDestinations.luau` | Référentiel commun des positions des serres utilisé par la génération, la carte et le guide |

## Architecture d'intégration

- `WorldBuilder` construit les stations au moment de générer la scène. `init.server.luau` active le service tramway, les expériences et le registre des haltes en mode Play.
- `CityGenerator` construit les huit pavillons et 24 haltes, et exclut leurs emprises de la plantation d'arbres. `Neighborhoods` évite les parcelles des serres.
- `MapHud` affiche les pavillons scientifiques et `RouteGuide` ajoute leurs huit destinations.
- Le HUD classique continue de répondre « Fonctionnalité à venir » pour les services métier stubbés.
- Toutes les nouvelles interactions locales passent par les `ProximityPrompt` et un contrôle de proximité coté serveur.

## Limitations de livraison

Les scripts sont générés et les tests statiques et Python hors Roblox passent. **Roblox Studio n'a pas été exécuté** dans cet environnement et aucun résultat en client n'est certifié. Les trajets en cabine ancrée nécessitent un contrôle visuel des collisions et de l'ergonomie dans Studio. Les animations 3D de qualité commerciale et la publication des places restent à faire.

## Installation

Utiliser l'installateur autonome `KinCity_Installer_CommandBar.luau` (en mode Édition). Pour modifier les sources, éditer `src/` puis exécuter `python tools/make_studio_installer.py` pour régénérer l'installateur.
