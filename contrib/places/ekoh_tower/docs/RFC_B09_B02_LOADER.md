# RFC-B09-B02-001 — Chargement du décor EkoH

**Auteur :** B02 · **Statut :** PROPOSÉ, non approuvé.  
**Classe :** SHARED pour l'adaptateur; LOCAL pour les sources actuellement livrées.  
**Contrat demandé :** `KC34-DOC-1.0`.

## Besoin
Le runtime KC33 construit les salles avec `InteriorGenerator.make`. B02 propose un `ModuleScript` additif spécifique à `ekoh_tower`. B02 n'a pas l'autorisation de modifier `InteriorGenerator`, `WorldBuilder` ou l'installateur Studio en son nom.

## API proposée
`B02EkohInterior.Build({place_key, model, origin, profile})` retourne `(Folder, {status,panels,parts})`. Modèle existant avec attribut `KinPlaceKey=ekoh_tower`, origine calculée par `Spatial.origin`, profil validé. Une absence de salle génère une erreur **avant** toute création. Aucun side-effect au chargement du module.

## Modification B09 requise
Ajouter `ModuleScript B02EkohInterior` au packaging serveur. Appeler `Build()` **après** `InteriorGenerator.make` seulement pour `place_key==ekoh_tower`. Protéger l'appel pour que l'absence du module en production ne casse pas le build, mais ne pas masquer un échec de décoration lorsque la fonctionnalité est activée. Reporter les budgets au système `ArtDecoBudget` et marquer la révision de scène. Tester les modes local et multi-Place en copie staging.

## Dépendances
La structure des six salles, la géométrie `InteriorWings`, l'attribut `KinPlaceKey` sur le Model. Aucun nouveau asset_id Roblox, aucune API d'identité, aucun accès aux données KOALI. Une revue B10 n'est pas requise pour le visuel intérieur, sauf si une cohérence de signalétique à l'entrée est souhaitée.

## Scénarios obligatoires
- 3 profils, 6 salles, 2 portes, 3 ancres + 4 passages d'extension.
- Deux appels au constructeur => aucun doublon.
- Salle manquante, mauvais `place_key`, profil invalide => refus sans mutation de monde.
- Même placement en `LOCAL_UNIVERSE` et en `MULTI_PLACE` avec origine correcte.
- Désactivation du décor => le monde canonique reste traversable.

**Ne pas fusionner sans tests Roblox Studio de l'adaptateur partagé.**
