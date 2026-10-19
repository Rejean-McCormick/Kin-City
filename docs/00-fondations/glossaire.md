# Glossaire et nomenclature

| Terme | Sens normatif Kin City |
|---|---|
| Universe Roblox | Conteneur d'une expérience Roblox comprenant plusieurs `Places` ; ne pas confondre avec les `Universes/Worlds` du moteur Konnaxion_Worlds. |
| Place Roblox | Niveau/lieu publiable et exploitable sous une expérience Roblox. |
| Ville extérieure | Place central regroupant l'espace public, les rues et façades. |
| Bâtiment | Entité logique stable, façades, entrées, destinations et capacité de rattachement. |
| Intérieur | Scène dans un Place séparé ou partie chargée dans le Place de la ville. |
| Porte | Route locale navigable, avec ID, provenance, destination, retour et état. |
| Interaction | Activation d'un objet, avec ID unique et `capability_id`. |
| Capacité | Fonction sémantique attendue, indépendante de son emplacement et de sa mise en œuvre. |
| StubProvider | Fournisseur local sans effet externe ; retourne `coming_soon`. |
| GatewayProvider | Fournisseur futur, non présent dans le build autonome ; communication serveur avec un adaptateur kOA. |
| Scene compiler | Outil proposé qui transforme manifestes et assets en scènes Roblox. |
| Seed | Paramètre d'aléa déterministe, versionné, nécessaire pour reconstruire une scène. |
| EkoH | Signal d'expertise/éthique pour des lectures contextualisées ; non synonyme de points de jeu. |
| Smart Vote | Mécanisme de vues de participation, dont pondérations éventuelles ; non décision finale par lui-même. |
| eThikos / Ethikos | Domaine de délibération et consultation Konnaxion ; nomenclature en cours d'harmonisation selon propriétaire. |
| kOA / Konnaxion | Écosystème et application hôte liés mais non interchangeables. |
| Evidence | Preuve datée et reproductible d'un test, non impression de fonctionnement. |

**IDs canoniques (nouveaux, proposés)** : segment ASCII minuscules `[a-z0-9_-]+` avec séparation `.` ; pas d'espaces ni de caractères accentués. Exemple `ethikos.justice_palace.terminal_01`. L'orthographe des marques en UI peut être différente.
