# Registre des sources et distinctions de preuve

## Fichiers fournis par le commanditaire

1. `Kin City_ A Visionary Virtual Interface for the Mouvement Koa.docx (1)(1).md` — intention symbolique, plan mandala/René-Levasseur, quartiers, parcours, accessibilité et gouvernance.
2. `To create KinCity as a functional ... .md` — options initiales d'outillage, non contrat technique.
3. `znapshot_kOA_Digital_Ecosystem_10181459(1).zip` — inventaire daté, carte d'autorité, frontières de confiance, identité, qualification.
4. `kOA_Digital_Ecosystem.wiki(1).zip` — wiki complémentaire, sections partiellement anciennes.
5. `Kin_City_Architecture_Cible_Complete_v1_1.md` — architecture cible antérieure, archivée en `docs/reference/architecture-v1.1.md`.

## Extraits d'autorité pertinents

- `docs/2-Technical-Reference/10-system/authority-map.md` (archive snapshot) : Konnaxion, Orgo, UCKK, Kristal, Koali ont des autorités non transférables.
- `docs/2-Technical-Reference/40-integration/identity-oidc/principles.md` : identité fédérée ≠ autorisation ; pas de base de comptes partagée.
- `docs/2-Technical-Reference/90-reference/adr/adr-0007-konnaxion-ethikos-decision-authority.md` : décision finale du domaine Konnaxion ; ne pas assimiler Smart Vote à l'exécution.
- `docs/status/current.md` : qualification spécifique et non preuve globale de production.

## Docs Roblox officielles consultées le 18 octobre 2026

- HTTP : https://create.roblox.com/docs/cloud-services/http-service
- Portes / téléportation : https://create.roblox.com/docs/projects/teleport
- Invite / prompt : https://create.roblox.com/docs/ui/proximity-prompts
- Streaming : https://create.roblox.com/docs/workspace/streaming
- Sécurité de frontière client/serveur : https://create.roblox.com/docs/scripting/security/client-server-boundary
- `CollectionService` : https://create.roblox.com/docs/reference/engine/classes/CollectionService
- Tests Studio : https://create.roblox.com/docs/studio/testing-modes
- Publication Places : https://create.roblox.com/docs/cloud/guides/usage-place-publishing
- Assets : https://create.roblox.com/docs/projects/assets
- Normes communautaires : https://about.roblox.com/community-standards
- Rojo : https://github.com/rojo-rbx/rojo

## Discipline de vérité

Les plans et contrats de Kin City sont des **propositions**, même si les APIs Roblox qui les rendent possibles existent. Les sources ne prouvent pas une expérience Kin City publiée, une topologie Roblox configurée, des Place IDs réels ou une API kOA autorisée pour Roblox. Une future mise à jour doit rattacher chaque affirmation d'implémentation à une preuve spécifique.


## Sources Roblox vérifiées le 18 octobre 2026 (v3)
- [Teleport entre Places](https://create.roblox.com/docs/projects/teleport) — `TeleportAsync` serveur, publication et test client requis, sécurité d’accès.
- [Performance, découpage des Places](https://create.roblox.com/docs/performance-optimization/design) — arbitrage mémoire vs temps de téléportation.
- [Streaming d'instances](https://create.roblox.com/docs/workspace/streaming) — chargement de Workspace, paramétrage StreamingEnabled dans Studio.
- [Frontière client/serveur](https://create.roblox.com/docs/scripting/security/client-server-boundary) — sécurisation des prompts/remotes et anti-spam.
- [Studio, simulations d’appareils et tests](https://create.roblox.com/docs/studio/testing-modes) — réseaux/appareils et tests multi-clients.
- [Place Publishing API](https://create.roblox.com/docs/cloud/guides/usage-place-publishing) — automatisation et types d’instances non pris en charge.
- [Généralités sur les meshes](https://create.roblox.com/docs/art/modeling/specifications) — limites sur les meshes importés.
