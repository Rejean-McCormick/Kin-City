# Périmètre contractuel : univers autonome d'abord

**Décision utilisateur : ferme.** On construit la véritable Kin City explorable avant de brancher kOA. Les points de connexion sont déjà incorporés dans les objets, mais répondent en mode stub.

## Exigences `WORLD_STUB`

| Domaine | Obligatoire dans la livraison autonome | Inacceptable |
|---|---|---|
| Ville | quartiers, rues, signalétique, orientation, circulation, scène réelle | scène vide, simple image de ville |
| Bâtiments | façades, entrées accessibles, intérieurs riches, mobilier | portes visuellement présentes mais inutilisables |
| Portes | transition effective, destination correspondante, retour | « fonctionnalité à venir » sur une porte de navigation |
| Interactions | objets cliquables/activables, UI standard fermable | objet muet, script spécial par objet, vote simulé |
| Identifiants | IDs documentés et stables des lieux, portes et interactions | références par nom d'Instance fragile ou index mutable |
| Générateurs | données versionnées, compilation reproductible, provenance d'assets | création manuelle incontrôlable de tout l'univers |
| Réseau | aucun appel kOA ; zéro secret kOA | appels de test cachés ou trafic de télémétrie non déclaré |
| Accessibilité | clavier, tactile, manette, retours lisibles et navigation simple | dépendance exclusive au clic précis ou à la souris |
| Qualification | mesures et parcours réels, client Roblox publié pour téléports | conclusion fondée sur une simple capture d'écran Studio |

## État futur `KOA_CONNECTED` (réservé)

Remplacer les fournisseurs stubs par des fournisseurs autorisés, sans migrer les scènes ni renommer les IDs. Les profils, votes, crédits, cours et artefacts demeurent chez leurs propriétaires kOA. Toute fonctionnalité susceptible de contrevenir aux normes Roblox ne sera pas diffusée par ce canal. Le périmètre futur est détaillé dans [la frontière kOA](../03-contrats/koa-futur.md).

## Ce qui ne fait PAS partie du mode autonome

Pas d'OIDC, pas de synchronisation de comptes, pas d'API HTTP kOA, pas de base métier, pas de vote, de récompense civique ou de certification. Le profil Roblox standard reste utilisable pour afficher l'avatar et naviguer, sans prétendre correspondre à un compte kOA.

## Une livraison durable, pas un prototype

La ville et les intérieurs appartiennent à la version finale. Les objets doivent rester stables, les gabarits doivent supporter l'enrichissement, et le client 3D ne doit pas être refait à la connexion future. `WORLD_STUB` est une configuration d'exécution qualifiable du même produit, pas un code jetable.
