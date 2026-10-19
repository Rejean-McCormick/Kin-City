# Frontière future kOA : réservée, non connectée

**Statut : FUTUR.** Les interfaces décrites ici ne doivent pas être appelées dans `WORLD_STUB`. Elles n'attestent pas de routes HTTP opérationnelles disponibles aujourd'hui.

## Mapping d'autorité source kOA

| Capacité Kin City proposée | Propriétaire réel à solliciter | Restrictions |
|---|---|---|
| `konnected.catalog.browse` | Konnaxion / KonnectED selon contrat confirmé | lecture et visibilité contextuelles |
| `uckk.courses.browse` | UCKK / Univers-Cité | rôle local et projection pédagogique |
| `ethikos.consultation.list` | Konnaxion / Ethikos | modération, portée de diffusion Roblox |
| `smartvote.ballots.browse` | Konnaxion / Smart Vote | distinction participation brute et interprétation pondérée |
| `ekoh.profile.view` | Konnaxion / EkoH | expertise ≠ monnaie de jeu ; respect de la vie privée |
| `keenkonnect.projects.browse` | keenKonnect | visibilité des travaux et contrôles projets |
| `kreative.exhibits.read` | Kreative | provenance et droits d'affichage |
| `orgo.tasks.browse` | Orgo | ACL tenant et droits de l'application |

## Adaptateur futur

Roblox serveur → façade HTTPS dédiée Kin City → propriétaire autorisé. La façade fait traduction, contrôle politique de canal, corrélation, authentification service et filtrage minimal des réponses. Les applications kOA continuent à gérer leurs décisions, habilitations, politiques de rétention et stockage.

## HTTP et limites Roblox [règles vérifiées]

Selon la documentation officielle au 18 octobre 2026, les requêtes génériques doivent être HTTPS ; seuls les en-têtes `x-api-key` (à partir d'un secret Roblox) et `content-type` sont autorisés pour les appels concernés. Les appels HTTP génériques sont soumis à un quota global par serveur Roblox. Il faut **mettre l'idempotence dans le corps JSON public** et traduire plus tard en en-têtes internes si l'application propriétaire l'exige.

## Contrat enveloppe proposé (NON implémenté)

```json
{
  "contract": "kincity.gateway.request/1.0",
  "request_id": "some-server-generated-id",
  "capability_id": "ethikos.consultation.list",
  "actor_context_ref": "opaque-server-context",
  "payload": {}
}
```

Pour une mutation future, ajouter `idempotency_key` et `policy_context` validés côté Gateway; jamais laisser le client choisir un poids de vote ou une identité d'utilisateur kOA.

## Ce que l'intégration ne doit PAS faire

Pas de tables utilisateurs partagées, pas de reprise de l'état canonique de Konnaxion, pas de Task Orgo écrit directement depuis Roblox, pas de décideur EkoH local, pas d'avatar exposant les scores privés, pas de navigateur Web intégré arbitraire ou de collecte de mots de passe dans le jeu.

## Contrôles de future admission

Contrat versionné réel, schéma owner, tests contre environnement contrôlé, mécanisme d'identité/permissions autorisé, garde de contenu Roblox, traces et rollback, circuit breaker, secret serveur, protection anti-rejeu, qualification de charge et consentement pour données personnelles.
