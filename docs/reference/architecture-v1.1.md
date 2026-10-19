# KIN CITY — Architecture cible intégrale

**Écosystème kOA · Interface immersive Roblox et interface Web · Spécification de référence**  
**Édition révisée : 18 octobre 2026 | Révision 1.1 (ville d’abord / stub) | Statut : conception cible, non preuve d’implémentation**  
**Mode de livraison visé : ville explorable d’abord, en mode stub; connexion réelle à kOA ensuite, sans reconstruction de l’univers**

> **Règle fondamentale.** Kin City est une représentation spatiale, interactive, éducative et communautaire des capacités de kOA. Elle ne devient ni la source de vérité des données métier, ni une copie des moteurs existants, ni un outil de décision autonome. Les concepts et besoins documentés par kOA sont distingués ci-dessous des décisions architecturales proposées et des capacités démontrées des logiciels.

## 0. Mode d'emploi, hiérarchie des autorités et traçabilité

### 0.1 Classification de chaque affirmation

- **[S] Source kOA** : présente dans les documents remis ou les README de dépôts identifiés. Les noms, principes, contrats et propriétaires des systèmes sont conservés.
- **[R] Règle Roblox** : fondée sur la documentation officielle vérifiée le 18 octobre 2026; peut évoluer et doit être revérifiée lors de la publication.
- **[D] Décision cible** : arbitrage proposé dans ce document; ne doit pas être présenté comme déjà implémenté.
- **[A] À confirmer** : dépend d'un contrat effectif, d'une vérification de code, d'une politique ou d'une décision de gouvernance non démontrée par les fichiers reçus.

**Priorité en cas de conflit :** propriétaire réel et code exécutable qualifié > contrat versionné officiel > statut daté propriétaire > inventaire transversal kOA > texte visionnaire Kin City > nouvelle proposition de ce document. Les documents visionnaires décrivent l'intention; ils ne prouvent pas la disponibilité opérationnelle. Un résultat de tests locaux, un badge CI ou une architecture complète ne prouvent pas un déploiement réel en production.

### 0.2 Périmètre du livrable

Le présent texte spécifie le résultat cible : topologie, responsabilités, interfaces, patrimoine urbain, gabarits, identité, votes, apprentissage, synchronisation, sûreté, exploitation, coûts, observabilité, qualifications, tests et conditions d'acceptation. Il **ne** contient pas le code source complet d'un jeu publiable ni ne certifie l'état des applications kOA. Il constitue la base contractuelle de développement du système intégral.

### 0.3 Source primaire et références

- `Kin City_ A Visionary Virtual Interface for the Mouvement Koa.docx (1)(1).md` : vision urbaine, quartiers, EkoH, Ethikos, parcours, accessibilité, transparence et versions Web/3D.
- `To create KinCity ...docx(1).md` : première exploration d'outils, non documentation normative.
- `znapshot_kOA_Digital_Ecosystem_10181459(1).zip` : instantané transversal de la documentation et de l'inventaire kOA. Notamment `docs/2-Technical-Reference/10-system/authority-map.md`, `trust-boundaries.md`, `docs/status/current.md`, `docs/2-Technical-Reference/90-reference/adr/adr-0007-konnaxion-ethikos-decision-authority.md`, `docs/2-Technical-Reference/40-integration/identity-oidc/`, `docs/inventory/README.md`.
- `kOA_Digital_Ecosystem.wiki(1).zip` : wiki complémentaire, dont certaines pages recoupent des documents plus récents.
- Dépôts publics consultés : `Rejean-McCormick/Konnaxion`, `Rejean-McCormick/Orgo`, `Rejean-McCormick/Koali-Spaces` (README et inventaire de routes Orgo).
- Documentation Roblox officielle : HTTP, téléportation, streaming, Secrets Store, filtrage de texte, normes communautaires; URL en annexe.

## 0.4 Décision d'exécution KC-ADR-012 — Ville d'abord, intégrations en stub

**Statut : décision utilisateur applicable.** Cette section prime les formulations antérieures suggérant que le Gateway, l'identité kOA ou les intégrations métier sont requis pour la première livraison. La vision du **système final** reste complète; son **ordre de réalisation** comporte désormais une première phase autonome de construction de l'univers. Cette livraison n'est pas un prototype jetable : les espaces, les objets et les points d'extension appartiennent directement au produit cible.

### 0.4.1 Périmètre obligatoire de la première phase : Kin City explorable

- **Ville Roblox réelle et parcourable** : plan urbain concentrique, quartiers identifiables, rues, places, repères, signalétique, points de départ, orientation et circulation des avatars. Les dimensions et le nombre exact de bâtiments restent des paramètres de design à décider dans le catalogue urbain; aucun inventaire imaginaire ne tient lieu de contenu construit.
- **Bâtiments visitables et intérieurs visuellement riches** : façades, entrées, portes, halls, pièces, mobilier, lumières et objets interactifs. La frontière extérieure/intérieure doit suivre le contrat de porte du §4; les grands bâtiments utilisent des Places séparés quand cela est utile. Les téléportations doivent être testées dans un client Roblox publié, et non présumées fonctionnelles sur le seul test Studio.
- **Interactions réelles, fonctions métier en attente** : l'utilisateur approche une bibliothèque, un écran, une borne, une œuvre, un guichet ou un pupitre, interagit et reçoit une fenêtre standard « Fonctionnalité à venir ». L'ouverture, la fermeture, la navigation et la réponse à l'entrée doivent fonctionner réellement, sans réponse métier inventée.
- **Aucune connexion à kOA pour cette livraison** : ni Gateway déployé, ni service HTTP kOA, ni OIDC kOA, ni données Konnaxion synchronisées, ni vote ou crédit officiel, ni dépendance à un serveur externe de calcul. Les services existants ne sont ni copiés ni simulés comme actifs.
- **Système génératif conservé** : routes, terrains, bâtiments, intérieurs, décorations, signalétiques, portes et points d'interaction sont décrits par des manifestes et produits par des générateurs reproductibles. Le monde créé n'est pas abandonné lors des futures intégrations.

### 0.4.2 Architecture d'interaction « branchement différé »

```text
Objet 3D stable (bibliothèque / ordinateur / borne)
  -> ProximityPrompt (clavier / clic / tactile / manette)
  -> InteractionRouter (identifiant d'objet, validation, ouverture UI)
  -> CapabilityRegistry (identifiant de fonctionnalité stable)
  -> ProviderRouter
       phase 1 : StubProvider -> fenêtre « Fonctionnalité à venir »
       ultérieurement : GatewayProvider -> API kOA autorisée
  -> UIRenderer commun (états, accessibilité, fermeture, erreurs)
```

**[D]** Chaque point d'interaction a un `interaction_id` permanent, une `capability_id` prévue, un `building_id`, un ancrage spatial et une étiquette. Il peut conserver un `owner_ref` documentaire kOA, **sans appeler ce propriétaire**. La décision `provider_mode=stub` est centralisée, auditable et remplaçable **par capacité**, non dispersée dans les scripts de chaque meuble. `coming_soon` est un état de produit, **pas** une erreur du réseau et **pas** une transaction réussie.

**Exemple de manifeste proposé, non contrat kOA existant :**

```json
{
  "schema_version": "kincity.interaction/1.0",
  "interaction_id": "ethikos.justice_palace.computer.001",
  "building_id": "ethikos.justice_palace",
  "anchor_id": "hall.computer.001",
  "interaction_kind": "capability",
  "capability_id": "ethikos.consultation.list",
  "owner_ref": "konnaxion.ethikos",
  "provider_mode": "stub",
  "fallback_state": "coming_soon",
  "prompt_label_key": "interactions.consultations",
  "display_message_key": "ui.functionality_coming_soon"
}
```

Ce schéma n'expose aucune URL, aucun token ni secret kOA. Quand une capacité sera activée plus tard, le même objet et le même `interaction_id` demeureront; le registre aiguillera sa `capability_id` vers un fournisseur autorisé. Tout ce qui touche à l'identité, aux votes, aux données et aux règles de diffusion restera sous la responsabilité du Gateway et des services propriétaires futurs.

### 0.4.3 Catalogue initial de points de connexion

| Lieu / bâtiment | Élément physique | Capacité future désignée (symbolique) | Phase 1 |
|---|---|---|---|
| Bibliothèque KonnectED | Bibliothèque / rayon | `konnected.catalog.browse` | Fenêtre « Fonctionnalité à venir » |
| Université / Univers-Cité | Pupitre / tableau de cours | `uckk.courses.browse` | Même fenêtre |
| Palais de justice / espace eThikos | Ordinateur / terminal | `ethikos.consultation.list` | Même fenêtre |
| Hôtel de ville | Borne de consultation | `smartvote.ballots.browse` | Même fenêtre, aucun vote enregistré |
| Place centrale | Tableau citoyen | `ekoh.profile.view` | Même fenêtre, aucun score fabriqué |
| Atelier keenKonnect | Bureau / terminal de projet | `keenkonnect.projects.browse` | Même fenêtre |
| Musée Kreative | Œuvre / borne de salle | `kreative.exhibits.read` | Même fenêtre |
| Administration Orgo | Guichet / ordinateur | `orgo.tasks.browse` | Même fenêtre |

Ces identifiants sont **des noms internes Kin City proposés**. Ils ne préjugent ni d'un endpoint existant ni d'un contrat déjà publié par kOA. D'autres éléments seront déclarés dans le catalogue à mesure que les bâtiments sont définis, mais **chaque élément installé doit avoir un comportement visible et vérifié**.

### 0.4.4 Comportements de l'interface et des portes

L'interaction suit le mécanisme officiel Roblox `ProximityPrompt` (dont la présentation couvre clavier, manette et tactile) ou un équivalent accessible, avec un événement central `ProximityPromptService.PromptTriggered`. L'interface affiche le nom de la ressource (p. ex. « Catalogue de la bibliothèque »), le texte **« Fonctionnalité à venir »**, une commande Fermer et, si nécessaire, une courte mention indiquant qu'aucune opération n'a été effectuée. Pas de fausse progression, de simulation trompeuse de vote ni de contenu présenté comme issu de kOA.

Les **portes sont de vraies interactions de navigation**, pas des stubs : destination enregistrée, porte de retour, orientation conservée lorsque possible, écran de transition, traitement des échecs. La téléportation inter-Places relève de Roblox et n'a aucune dépendance à kOA. Dans Studio on peut tester les composants et le trajet logique; le passage effectif entre Places exige un test de l'expérience publiée dans le client Roblox.

### 0.4.5 Critères d'acceptation propres à la première phase

| ID | Condition vérifiable pour considérer l'univers livré |
|---|---|
| KC-WORLD-01 | Le joueur apparaît et circule librement dans la ville sans blocage de navigation significatif. |
| KC-WORLD-02 | Les districts et les bâtiments prévus dans le catalogue sont identifiables, visitables et pourvus d'intérieurs réels. |
| KC-WORLD-03 | Chaque porte prévue ouvre la bonne destination et permet un retour; échecs gérés. |
| KC-WORLD-04 | Chaque objet interactif catalogué affiche sa bonne étiquette et le même état standard « Fonctionnalité à venir ». |
| KC-WORLD-05 | Aucune action stub ne crée de crédit, vote, certification, tâche ou donnée kOA fictive. |
| KC-WORLD-06 | L'univers fonctionne sans Gateway kOA, sans identifiants kOA et sans requêtes HTTP métier. |
| KC-WORLD-07 | Un validateur détecte les identifiants dupliqués, les capacités sans registre, les portes sans destination et les objets sans interaction. |
| KC-WORLD-08 | Le contenu urbain et les registres sont versionnés, reproductibles, et les accès clavier / tactile / manette sont testés. |
| KC-WORLD-09 | Une simulation technique du passage `stub` à `live` au niveau du routeur démontre qu'aucun changement de géométrie, ancrage ou `interaction_id` n'est requis; **aucune connexion kOA réelle n'est exigée**. |
| KC-WORLD-10 | Les performances et chargements sont qualifiés sur des appareils cibles définis; les seuils chiffrés restent à fixer selon la cible. |

### 0.4.6 Activation ultérieure des services

Le branchement de kOA est une **étape postérieure**, sans conditionner la fin de la première phase. L'intégration introduira le Gateway, les contrats réellement disponibles, la politique de contenu, l'identité reliée, les calculs EkoH, les votes eThikos/Smart Vote et les audits correspondants. Les tests d'intégration du §18 demeurent applicables **uniquement au produit connecté**. Un statut `live` n'est autorisé que si le propriétaire métier est qualifié, l'authentification en place et les tests de bout en bout réussis. Sinon le point d'entrée demeure honnêtement en `stub` ou devient `restricted`.

**Principe de non-régression :** connecter une fonctionnalité n'altère pas la navigation, le bâtiment, l'interface d'interaction de base, l'identité des objets ou les générateurs de scènes.

## 1. Définition du produit final

### 1.1 Mission

**[S]** Kin City est l'interface urbaine de l'initiative kOA/Konnaxion. Le centre concentrique inspiré de René-Levasseur et de la logique du mandala rend visibles les relations entre connaissance, éthique, collaboration, culture, innovation et organisation. L'environnement propose une pédagogie de la découverte spatiale et de la participation consciente, plutôt qu'une boucle de combat ou de consommation.

**[D]** Le produit final propose deux accès complémentaires aux mêmes domaines métier : une ville immersive Roblox et un accès Web kOA. Le joueur peut flâner, visiter, interagir, suivre un apprentissage, participer à une consultation communautaire admissible, contribuer à un projet et retrouver ses activités dans le canal Web selon les autorisations propres à chaque système. La parité fonctionnelle signifie cohérence des états métier, **pas** reproduction à l'identique de toutes les interfaces et contenus sur chaque plateforme.

### 1.2 Invariants

1. La ville n'invente ni résultat, ni crédits, ni décision, ni certification, ni savoir canonique.
2. Lorsqu’une capacité métier sera activée, son opération passera par le propriétaire autorisé; durant la première phase, les interactions n’effectuent aucune opération kOA. Aucun script Roblox ne modifie directement les bases kOA.
3. Toutes les actions critiques sont authentifiées, autorisées, versionnées, tracées et idempotentes lorsqu'elles mutent un état durable.
4. Le brut et le pondéré sont séparés : une lecture EkoH/Smart Vote n'est pas un `DecisionRecord` eThikos finalisé.
5. Les utilisateurs non reliés à un compte kOA bénéficient d'un mode invité explicite, sans usurpation de compte ni création implicite de droits.
6. Les portes matérialisent une frontière de lieu et de responsabilité visuelle; la politique et l'accès sont revalidés à destination.
7. Les contenus éducatifs, créations et conversations sont filtrés et admissibles selon la politique du canal Roblox; le canal Web reste un chemin indépendant.
8. La puissance externe réalise les traitements complexes; Roblox conserve les limites de calcul, mémoire, rendu, physique et réseau de ses serveurs et clients.
9. Génération déterministe et reproductible des environnements : même manifeste + même version + même graine = même structure, dans les limites documentées des ressources et dépendances.
10. Pas de dépendance à une API IA facturée à l'usage pour exécuter le jeu ou reconstruire les scènes.
11. S'il manque une dépendance critique, le système échoue explicitement sans simuler une opération réussie.
12. Les fonctions de gouvernance du monde réel ne sont pas automatiquement exposées dans Roblox; la politique de contenu du canal décide.

### 1.3 Exclusions explicites

- Pas de clone de PostgreSQL, EkoH, Smart Vote, Ethikos, UCKK, Orgo ou Kristal dans Roblox.
- Pas de portail Web arbitraire intégré à l'interface Roblox : les expériences Roblox ne sont pas un navigateur Web généraliste.
- Pas d'exécution de Python/Node directement dans les scripts Luau : ces moteurs tournent sur des serveurs externes et répondent via HTTPS.
- Pas de redistribution présumée libre des objets gratuits du Creator Store; licences et autorisations d'usage doivent être vérifiées.
- Pas d'importation automatique des données identifiables d'enfants ou des profils externes dans Roblox.
- Pas de promesse de transition entre lieux sans chargement, ni d'un même serveur physique pour l'ensemble de la ville.
- Pas de dépendance à des algorithmes d'IA opaques pour le calcul des votes, la décision de gouvernance ou les validations épistémiques.

## 2. Concordance de la ville avec l'écosystème kOA

| Lieu Kin City | Domaine kOA / propriétaire | Capacités visibles proposées | Ce que la ville ne possède pas |
|---|---|---|---|
| Noyau, Hôtel de Ville, place centrale | Konnaxion, EkoH, eThikos, Smart Vote | Profil civique, consultations admissibles, lectures pondérées, traçabilité des décisions | Base de votes, score canonique, décision finale |
| Quartier du Savoir / université / bibliothèque | KonnectED; UCKK / Univers-Cité pour ses propres parcours et projections | Parcours, bibliothèques, épreuves, certificats admissibles, contexte pédagogique | Certification, Moodle, assertion canonique |
| Place de l'Éthique / agora | eThikos et Konnaxion | Consultations communautaires, discussion structurée filtrée, lectures comparatives | Autorité de décision ou droit de publication libre |
| Parc de l'Innovation | keenKonnect; Orgo lorsque du travail opérationnel est autorisé | Projets, objets interactifs, équipes, activités documentées | Cases/Tasks, permissions, orchestration métier |
| Quartier Créatif | Kreative; services patrimoniaux concernés | Galeries, expositions, ateliers, représentations admissibles | Archives et droits d'auteur sources |
| Réseau, transports, services municipaux | Orgo + contrats d'intégration; Koali Spaces pour le Web | Notifications admises, guichets, accès à services, état d'opérations autorisées | Flux de travail, routage propriétaire, identité |
| Centre de la connaissance | EncyKlopedia → Da’at → Kristal, avec projections autorisées | Catalogues, fiches sourcées, démonstrations, parcours de provenance | Canon épistémique, validation, publication |

**[S]** L'architecture kOA attribue explicitement à chaque produit ses états et décisions. `Interaction Kernel` est un protocole sélectivement adopté, pas une base commune ni un service central obligatoire. `Koali Spaces` compose l'expérience Web sans acquérir les domaines métier. **[D]** L'adaptateur Kin City respecte cette architecture : il ne fait qu'agréger et traduire des capacités autorisées.

### 2.1 Nomenclature à ne pas confondre

`Roblox Universe` : conteneur Roblox regroupant les `Places` d'une expérience. `Konnaxion Universe/World` : unité canonique propriétaire du moteur `Konnaxion_Worlds`. Aucun alignement 1:1 implicite. La correspondance est configurée explicitement (`city_id`, `roblox_universe_id`, `roblox_place_id`, `konnaxion_world_ref`) et ne devient jamais une preuve d'autorisation. Les `Worlds` kOA peuvent représenter des contextes métier plutôt que des scènes tridimensionnelles.

## 3. Architecture logique et physique de référence

```text
                           UTILISATEURS
                  ┌────────────┴────────────┐
             navigateur Web            client Roblox
             Koali / modules           expériences / Places
                  │                          │
             HTTPS / OIDC             RemoteEvents internes
                  │                          │
                  │                   serveur Roblox Luau
                  │                          │
                  │                   HttpService HTTPS JSON
                  │                          │
                  └───────────┬──────────────┘
                              ▼
                   KIN CITY GATEWAY / BFF
             façade orientée capacités, non-bases
            validation, contrat, sessions, cache,
           politiques, rate limits, audit, télémétrie
                              │
              ┌───────────────┼───────────────────┐
              ▼               ▼                   ▼
       Konnaxion/eThikos   UCKK/KonnectED   autres propriétaires
         Smart Vote/EkoH   Kristal-projection   Orgo/Kreative/etc.
              │               │                   │
        états et contrats propres à chaque propriétaire
```

**[D] Gateway Kin City** : composant recommandé entre Roblox et kOA. Il ne remplace pas les services existants. Rôle : exposer des DTO minimisés, contrôler le débit, vérifier les identités, fédérer des lectures autorisées, rejeter les mutations non conformes, mettre en cache des projections non sensibles, fournir des traces, absorber les évolutions des APIs propriétaires. Peut être réalisé dans l'environnement Python/Django existant ou comme service séparé; le choix exact doit suivre les contraintes de déploiement de kOA plutôt qu'une préférence arbitraire.

### 3.1 Frontières de confiance

- **Client Roblox** : non fiable; peut demander, afficher et transmettre une intention. Aucun score, droit, poids de vote ni résultat provenant du client ne fait autorité.
- **Serveur Roblox** : autorité sur simulation et présence locale, mais pas sur les décisions métier kOA; il authentifie le canal avec une clé de service.
- **Gateway** : authentifie le serveur Roblox et l'identité utilisateur mappée; applique les règles de canal et des limites supplémentaires; n'augmente jamais les droits d'un propriétaire.
- **Service propriétaire** : seule autorité sur sa donnée, ses rôles, ses transactions et son audit.
- **Caches / projections** : jetables et reconstruisibles; portent source, version, date et TTL.
- **Web** : accès avec les sessions et politiques de chaque application; ne reprend jamais à son compte un privilège accordé dans Roblox.

### 3.2 Flux de communication

1. Le client sollicite une action (dialogue, consultation, lecture, vote, porte).
2. Le script serveur Roblox valide proximité, état de session, anti-spam et autorisation de lieu avant d'appeler l'API.
3. Le Gateway valide la signature logique et le secret du serveur, la session, la version de contrat, le budget d'appel et le contexte de public visé.
4. Il appelle le propriétaire métier requis avec une identité déléguée bornée ou une capacité de service dédiée; il n'envoie jamais une demande générale « agir comme administrateur ».
5. Il transforme la réponse en projection Roblox minimale, avec `source`, `policy_version`, `revision` et `correlation_id`.
6. L'interface affiche le résultat confirmé ou un état d'erreur explicite. Aucune réussite optimiste pour un vote ou une certification.

### 3.3 Déploiement et résilience

Topologie logique recommandée : Gateway répliquable sans état de session critique en mémoire, magasin partagé pour déduplication et quotas lorsque nécessaire, cache avec invalidation/version des données, accès privé aux propriétaires kOA, TLS côté public, réseau restrictif côté interne, clés rotatives et observabilité commune. La base canonique reste chez chaque propriétaire. Des workers asynchrones prennent en charge les agrégations lourdes; le Gateway répond par statut de tâche et référence de résultat plutôt que de maintenir une requête réseau ouverte.

## 4. Architecture spatiale de la ville et des bâtiments

### 4.1 Ville concentrique, graphe de navigation et portes

**[S]** Le noyau du mandala et les quartiers périphériques structurent la carte Kin City. **[D]** La géométrie exacte, la taille et le nombre de bâtiments deviennent des données descriptives. Le graphe topologique est séparé de la position 3D. Le visiteur peut marcher ou naviguer par carte, accessibilité ou commande de destination, selon ses droits.

**Contrat `BuildingManifest` proposé :**

```json
{
  "schema_version": "kincity.building/1.0",
  "building_id": "ethikos.agora.main",
  "district_id": "ethikos",
  "name_key": "kin.agora.title",
  "exterior_template": "civic.agora.frontage.v3",
  "interior_mode": "separate_place",
  "roblox_place_id": "CONFIGURED_NUMERIC_ID",
  "return_anchor_id": "city.ethikos.agora.door.main",
  "entry_policy_ref": "city.public.civic",
  "content_policy_ref": "roblox.community_civic.v1",
  "service_capabilities": ["consultation.list", "consultation.read", "vote.submit"],
  "visual_seed": 384012,
  "asset_bundle_revision": "sha256:REPLACE_WITH_BUILD_DIGEST"
}
```

Ce schéma est **nouveau et proposé**, et n'est pas un schéma officiellement approuvé de Konnaxion ou de Roblox. `roblox_place_id` est fourni après publication du Place. Le manifeste ne contient aucun secret ni URL arbitrable par l'utilisateur.

### 4.2 Types d'intérieurs

- `inline_streamed` : même Place que l'extérieur; adapté aux halls et fonctions à faible coût mémoire; modèles distants soumis au streaming.
- `separate_place` : Place indépendant, avec chargement à l'entrée; adapté aux bâtiments riches; logique serveur et budget de mémoire propres au Place.
- `instanced_place` : Place réutilisable paramétré par une destination contrôlée côté serveur; salle d'étude, atelier, classe ou instance réservée; jamais autorisé seulement par des données de téléportation côté client.
- `event_place` : lieu d'assemblée ou événement collectif dont la capacité de serveur, les permissions et le mode de discussion sont précisément gouvernés.

**Arbitrage cible :** conserver les façades et rues permanentes dans la ville, mais réserver les intérieurs coûteux à des Places distincts. Éviter un Place par petite pièce si cela multiplie inutilement les chargements. Plusieurs bâtiments peuvent partager un *même gabarit et même Place d'intérieur* avec des données/instances séparées, mais cela exige une isolation vérifiable des occupants et des droits.

### 4.3 Protocole de porte

`Approach → Inspect → Authorized → Preparing → Teleporting → Arrived → Ready` ; branches `Denied`, `TimedOut`, `TeleportFailed`, `ReturnAvailable`. L'entrée peut vérifier : bâtiment, scène, âge/canal si connu et autorisé, compte lié si nécessaire, droits de consultation, capacité et maintenance. À la destination, tous les droits sensibles sont **revalidés**. Les données transmises par `TeleportOptions:SetTeleportData()` ne transportent que des indices non sensibles (`destination`, `trace_ref`, `return_anchor`), jamais des jetons, crédits ou décisions. Les transferts inter-Places effacent l'état local du joueur et nécessitent une restauration explicite. Téléportation et retours sont testés dans le client Roblox publié, pas uniquement dans Studio.

### 4.4 Continuité sans fausse promesse

Le même citoyen peut demeurer dans le même univers fonctionnel sans rester dans le même serveur Roblox. La conversation, l'avancement, la mission, le vote et les documents passent par leurs sources persistantes. Une animation de porte et un écran de chargement personnalisé donnent une continuité narrative, mais le chargement réseau reste réel. Présence de groupe, invitation et réservation de serveurs sont facultatives, soumises aux APIs et règles sociales Roblox.

### 4.5 Optimisation du monde 3D

- `StreamingEnabled` pour la ville, modèles optimisés et niveaux de détail.
- Maillages réutilisables, répétition de matériaux, collision simplifiée, effets et lumières mesurés; ne pas générer des milliers de `Parts` non nécessaires.
- Géométrie décorative distincte de la géométrie interactive; scripts par mécanisme et non par chaque objet.
- PNJ proches simulés localement selon budget; PNJ de fond représentés simplement; interactions métier médiées côté serveur.
- Budget de performance par Place et par appareil, non budget global hypothétique.
- Les ressources importées respectent les licences, la modération des assets et la propriété intellectuelle.

## 5. Protocole HTTP et contrats de façade

### 5.1 Capacité réelle de Roblox

**[R]** `HttpService:RequestAsync`, `GetAsync` et `PostAsync` permettent de joindre des services tiers **depuis le serveur Roblox**. Les requêtes externes utilisent HTTPS; elles nécessitent l'activation explicite des requêtes HTTP. Selon la documentation officielle actuelle, les en-têtes personnalisés utilisables sont restreints à `x-api-key` et `content-type`, et `x-api-key` doit reposer sur un objet `Secret` du Secrets Store. **Limite externe ordinaire : 500 requêtes par minute et par serveur de jeu**; les API Open Cloud ont des quotas distincts. Les erreurs, ralentissements et quotas du serveur externe continuent aussi de s'appliquer.

**Conséquence importante :** un appel Roblox ne doit pas supposer qu'il pourra fournir les en-têtes `Authorization`, `Idempotency-Key`, `traceparent` ou les cookies utilisés par les applications internes. Le **Gateway** reçoit une enveloppe JSON à champs explicites, puis peut ajouter les en-têtes propriétaires requis dans sa communication interne. Il n'en découle aucune modification à apporter aux API métier existantes.

### 5.2 Enveloppe de requête normative proposée

```json
{
  "protocol": "kincity.gateway/1.0",
  "command_id": "uuid-v4-cote-serveur",
  "correlation_id": "uuid-v4-cote-serveur",
  "request_type": "consultation.vote.submit",
  "roblox_context": {
    "universe_id": "CONFIGURED",
    "place_id": "CONFIGURED",
    "server_job_id": "CONFIGURED",
    "user_id": 12345678
  },
  "session_ref": "opaque_short_lived_reference",
  "payload": {"consultation_id": "example-387", "option_id": "agree"},
  "client_schema_version": "1.0"
}
```

Champs de l'enveloppe fournis par un **script serveur** de confiance relative; ne pas recopier tels quels des champs transmis par le client. `command_id` porte la déduplication et est préservé à travers les reprises. `session_ref` désigne un état côté Gateway, révocable, borné à l'utilisateur et au serveur; il n'est pas un mot de passe ni un OIDC token affiché dans le jeu.

Réponse standard :

```json
{
  "protocol": "kincity.gateway/1.0",
  "correlation_id": "same-correlation-id",
  "status": "ok",
  "result": {"record_ref": "owner:opaque-record-id", "revision": "42"},
  "owner": "konnaxion",
  "view_policy": "roblox.civic.filtered/1.0",
  "cache_ttl_seconds": 0,
  "server_time": "2026-10-18T18:39:00Z"
}
```

### 5.3 Catalogue de capacités externes

| Famille | Opération façade | Propriétaire réel | Classe de risque |
|---|---|---|---|
| Découverte | `city.catalog.read`, `building.describe` | Catalogue Kin City en lecture | Faible |
| Identité | `citizen.context.read`, `citizen.link.status` | IdP + chaque produit local | Élevée |
| Apprentissage | `learning.catalog.read`, `learning.progress.read`, `learning.activity.submit` | KonnectED / UCKK | Modérée à élevée |
| Connaissances | `knowledge.document.read`, `knowledge.provenance.read` | Projection Kristal / UCKK | Selon contenu |
| Consultation | `consultation.list`, `consultation.read` | Konnaxion / eThikos | Modérée |
| Participation | `consultation.vote.submit`, `consultation.vote.revoke` si permis | Konnaxion / Smart Vote | Élevée |
| Décision | `decision.read` (statut, trace et lecture autorisée) | Konnaxion / eThikos | Élevée |
| Projets | `project.list`, `project.read`, `contribution.submit` | keenKonnect / Orgo selon opération | Variable |
| Culture | `exhibition.list`, `exhibition.read` | Kreative / archive propriétaire | Variable |
| Opérations | `case.read`, `task.read` uniquement si autorisé | Orgo | Élevée |

Il s'agit de **noms de façade proposés**, non d'une affirmation que les routes existent dans les sources aujourd'hui. Toute capacité exposée exige un adaptateur effectif, un contrat versionné du propriétaire et un test d'intégration portant sur un vrai service.

### 5.4 Calculs lourds sans bloquer Roblox

Le Gateway distingue les lectures synchrones courtes et les commandes asynchrones. Pour une analyse lourde de 1 000 questions ou de milliers de votes, une commande interne enregistre le travail et renvoie `accepted` + `operation_ref`. Le système propriétaire, ou un worker explicitement mandaté, calcule. Roblox interroge ensuite un `operation.status` avec mise en cache/budget; `accepted` ne signifie jamais `completed`. Les résultats portent une version de modèle, des filtres, un instantané des contributions et l'heure d'agrégation.

### 5.5 Gestion du quota et dimensionnement

Budget conservateur de conception par serveur : conserver une marge sous le plafond Roblox. Exemple de **dimensionnement hypothétique**, non mesure réelle : 30 joueurs, une consultation de catalogue toutes les 60 s par joueur et 3 interactions par minute par joueur produiraient environ `30 × (1 + 3) = 120` appels/min si aucun cache n'était appliqué, hors reprises. Une mise à jour de panneau public doit être mutualisée au niveau serveur plutôt que répétée par joueur. L'API peut renvoyer un paquet d'informations (`bootstrap` / `view_bundle`) pour réduire les allers-retours. Ne pas faire de polling à chaque image ou mouvement de PNJ.

Mécanismes imposés : budget token-bucket côté Roblox, cache serveur à TTL, limite par joueur, coalescence des demandes identiques, invalidation par `revision`, fenêtre d'erreurs/circuit breaker, délai maximum et une politique de reprise bornée avec délai exponentiel et gigue. Les mutations utilisent l'**exact même `command_id`** lors d'une reprise; un nouveau `command_id` pourrait créer une seconde transaction.

### 5.6 Codes de réponse applicatifs

`OK`, `ACCEPTED`, `AUTH_REQUIRED`, `LINK_REQUIRED`, `POLICY_DENIED`, `CONTENT_RESTRICTED`, `CONFLICT`, `ALREADY_APPLIED`, `RATE_LIMITED`, `OWNER_UNAVAILABLE`, `CONTRACT_MISMATCH`, `TIMEOUT`, `NOT_FOUND`, `NOT_IMPLEMENTED`. Chaque erreur conserve `correlation_id` et `retryable` et ne révèle aucun token, compte externe privé, document confidentiel ou détail de système interne.

## 6. Identité, association de comptes et données personnelles

### 6.1 Respect du modèle fédéré kOA

**[S]** kOA documente un profil OIDC fédéré, des identités sous `(issuer, subject)` et une autorisation conservée localement dans chaque application. Le fait d'être authentifié auprès d'un fournisseur d'identité ne donne pas des rôles globaux. Deux comptes possédant le même courriel ne doivent pas être fusionnés automatiquement. Les applications et la connexion locale doivent conserver leurs stratégies de récupération indépendantes.

**[D]** Roblox fournit une identité Roblox (`UserId`) liée à une session d'expérience, pas une identité kOA préexistante. L'association entre identité Roblox et identité kOA doit être **explicite, vérifiable, révocable et historisée**. Le Gateway conserve une référence de liaison, avec des autorisations strictement limitées; les systèmes propriétaires continuent d'autoriser chaque opération.

### 6.2 Modes d'accès

- `guest` : exploration publique, démonstrations et activités sans données personnelles; pas de vote officiel lié à un compte kOA.
- `roblox_native` : progression propre à l'expérience uniquement si conçue et autorisée, séparée des droits kOA.
- `koa_linked` : session reliée à un compte kOA selon un mécanisme officiellement compatible avec les politiques Roblox, OIDC et le profil de protection des mineurs.
- `restricted` : lecture seulement, fermeture de capacités non admissibles, ou accès interdit au lieu lorsque le canal ou la catégorie d'âge l'exige.

### 6.3 Liaison sécurisée : exigences, pas promesse de mécanisme

Aucune connexion par formulaire demandant les mots de passe kOA dans Roblox. Aucune confiance accordée au simple nom d'utilisateur Roblox saisi sur un site. Le processus doit confirmer séparément la possession de la session Roblox et celle du compte kOA, par un flux de liaison autorisé, avec un défi court, non réutilisable, anti-rejeu et anti-usurpation. **[A]** Il faut faire valider le mécanisme précis de liaison pour la politique Roblox applicable à l'audience ciblée. L'impossibilité de communiquer librement des URL externes dans une expérience constitue un véritable obstacle UX/réglementaire, pas un détail technique à contourner. Si une association conforme ne peut être établie, l'accès Roblox reste `guest` ou `roblox_native`, tandis que le Web conserve toutes les capacités kOA.

Liaison interne minimale : `(issuer, subject)` opaque, `roblox_user_id`, statut, preuve d'autorisation, création, expiration, révocation, version de politique; journal d'accès et minimisation des données. Ne jamais répliquer date de naissance, adresse courriel, données d'identité sensibles ou historique exhaustif dans les DataStores Roblox.

### 6.4 Autorisation

Contrôles simultanés : droit propriétaire, droit du module, droit de destination, admissibilité du canal Roblox, politique d'âge/contenu, confidentialité, consentement approprié et état de session. Une consultation visible ne signifie pas que le vote est permis. Les administrateurs de Kin City ne deviennent pas automatiquement administrateurs d'Orgo, d'UCKK ou de Konnaxion.

### 6.5 Vie privée et mineurs

Données externes exposées en projection strictement minimisée. Définir `legal_basis`, finalité, catégorie, rétention, région et mécanismes de suppression applicables avant de synchroniser des identités. Pour les enfants, privilégier des expériences pédagogiques sans liaison externe, classements publics ni profilage. Les segments analytiques sensibles ou démographiques ne sont pas accessibles par une API publique de jeu. Un bouton d'effacement côté client ne supprime pas automatiquement les données des propriétaires : il produit une demande routée et suivie selon leurs propres règles.

## 7. EkoH, Smart Vote, eThikos : modèle de participation et de décision

### 7.1 Séparer cinq notions

**[S]** EkoH produit des signaux de mérite/expertise/éthique propres à des domaines. Smart Vote propose des lectures des participations; eThikos conserve la légitimité et finalise les décisions. Le modèle kOA permet de consulter le signal brut parallèlement aux vues pondérées.

**[D]** Kin City affichera distinctement :

1. `participation` : une personne a pris position sur une consultation.
2. `credit` : crédit d'apprentissage ou de contribution, s'il existe sous ce nom dans le système propriétaire; **ne doit pas être automatiquement assimilé au score EkoH**.
3. `expertise` : signal par domaine et version de méthode.
4. `weighted_reading` : résultat calculé selon une méthode de lecture explicitement publiée.
5. `decision_record` : acte finalisé par l'autorité eThikos; distinct de la consultation et de ses statistiques.

### 7.2 Consultations de 1 000 questions ou plus

Le volume de 1 000 questions n'est pas une limite fondamentale pour l'architecture. Le catalogue est stocké par le propriétaire de contenu et servi par pages, sujets, sous-sujets, règles d'accès et versions; la ville ne réplique pas les 1 000 objets en objets 3D permanents. Les terminaux/tribunes chargent seulement une fenêtre paginée de questions et les vues de résultats autorisées. Toutes les questions possèdent `question_id`, `revision`, `locale`, `topic_ids`, `audience`, `content_policy`, `start_at`, `close_at`, `status`, `choices`, `source`, `moderation_status`. Les thèmes et leur indexation ne doivent pas être encodés dans les scripts Roblox.

### 7.3 Soumission d'un vote

```text
Utilisateur choisit une réponse dans Roblox
  → serveur Roblox vérifie présence / cadence et transmet une intention
  → Gateway vérifie canal, session, droits, cohérence et doublons
  → API du propriétaire Konnaxion/eThikos valide consultation et règle
  → état du vote enregistré transactionnellement par le propriétaire
  → Smart Vote/EkoH prépare une ou plusieurs lectures bornées
  → Gateway retourne reçu durable + révision ou opération acceptée
  → Roblox affiche « enregistré » uniquement sur reçu de succès
```

La pondération est recalculée par le propriétaire à partir de sa version d'EkoH et du domaine; **jamais** à partir d'un nombre envoyé par Roblox. La formule exacte est un contrat du propriétaire, pas un algorithme arbitraire de Kin City. Le poids peut être figé au moment du vote ou recalculé lors de la lecture : cette décision doit être explicitement fixée par le contrat Smart Vote. Pour la reproductibilité, journaliser `policy_ref`, `formula_version`, `eligibility_snapshot_ref` et `reading_version` en fonction de ce contrat.

### 7.4 Intégrité des votes

Exigences : une identité admissible par consultation selon la politique définie, idempotence sur soumissions identiques, procédure de changement de vote si autorisée, version de question pour éviter le vote sur un texte modifié, fermeture à l'heure du serveur, preuve de l'authentification, traçabilité non falsifiable par le client, comptages bruts indépendants, lectures pondérées séparées. Protection contre scripts client modifiés, plusieurs serveurs Roblox concurrents, réseaux instables et tentatives de relecture d'anciennes commandes. Les propriétés de vérifiabilité publique et d'anonymat doivent être arbitrées explicitement : ne pas promettre à la fois journal public nominatif et anonymat absolu.

### 7.5 Décision et exécution

**[S]** La décision canonique suit : `eThikos → lectures Smart Vote/EkoH → étape de décision → DecisionRecord finalisé → transfert direct Konnaxion → Orgo → Signal/Workflow/Case/Task`. La frontière `governance.decision.execute/1.0.0` et le retour durable `accountability.impact.publish/1.0.0` disposent d'une qualification intégrée locale documentée dans l'instantané d'octobre 2026, **pas** d'une garantie de déploiement global. UCKK peut publier la décision mais n'est pas son relais obligatoire.

**[D]** Kin City expose des tableaux `consultation`, `reading`, `decision`, `execution_status` distincts. Un vote citoyen n'exécute jamais directement une tâche Orgo; seule la décision finalisée franchit ce seuil. Pour l'utilisateur, un résultat peut être « avis enregistrés », « analyse disponible », « décision prise », « transmission en cours », « action confirmée » : pas de statut générique « réussi ».

### 7.6 Équité et explicabilité

La pondération par expérience est sensible et peut concentrer l'influence. Afficher séparément le résultat non pondéré, le pondéré, les règles de calcul, les domaines concernés, le nombre de votants, les règles d'admissibilité et les incertitudes statistiques pertinentes. Tester les effets de seuil, les contributions artificielles et la capture par des comptes à forte réputation. La décision eThikos ne peut se réduire automatiquement au résultat du calcul.

## 8. Cadre d'éducation, progression et bibliothèque de connaissances

### 8.1 Modèle pédagogique

La ville sert de carte cognitive : la bibliothèque rassemble les ressources de connaissance, l'université les parcours, les laboratoires l'expérimentation, l'agora la discussion structurée et la galerie les représentations culturelles. La circulation entre ces domaines doit donner du sens : apprendre → mettre à l'épreuve → argumenter → contribuer → comprendre l'impact; sans créer une obligation d'engagement permanent.

### 8.2 Séparer contenu et présentation

Une ressource pédagogique appartient au système qui la publie. Roblox reçoit une fiche adaptée au canal : titre, courte description, sections de texte en quantité limitée, objectifs, provenance, éléments interactifs compatibles Roblox et référence externe non nécessairement cliquable. L'expérience Roblox ne sait pas afficher librement des pages Next.js, des documents Office, un navigateur HTML arbitraire ou une vidéo hébergée n'importe où. Les médias demandent un circuit de préparation/import et de modération compatible avec la plateforme. Le Web reste l'accès naturel aux contenus très riches, longues lectures, applications et documents originaux.

### 8.3 Parcours éducatif

`Curriculum → Module → LearningUnit → Activity → Evidence → Assessment → Progression`. Ces noms sont proposés comme modèle d'affichage, **sans renommer** les entités canoniques UCKK/KonnectED. Chaque activité conserve provenance, source, version, langue, conditions d'accès, règle de réussite et auteur. Une progression locale Roblox ne se transforme en certificat officiel que si le propriétaire autorisé reçoit, valide et enregistre l'évidence sous son contrat existant. Aucun certificat ne doit être attribué sur une simple animation de réussite côté client.

### 8.4 Publications et provenance

L'écosystème source distingue : acquisition EncyKlopedia, mapping Da'at, canon/valeurs Kristal, projections UCKK. Kin City affiche les métadonnées et résumés autorisés, sans confondre un document découvert, un document vérifié, un savoir canonique et une représentation pédagogique dérivée. Afficher références et date de version lorsque les contrats les exposent. Prévoir un statut `content_unavailable` plutôt que générer une réponse IA fictive si la source fait défaut.

## 9. Monde social, personnages et interaction

### 9.1 Avatars

Roblox gère l'avatar et la présence en fonction des fonctionnalités offertes par sa plateforme; Kin City peut ajouter uniformes, badges purement visuels et éléments de personnalisation adaptés aux règles Roblox. Les apparences ne confèrent aucune autorité métier. Les avatars ne doivent pas publier des données personnelles ou scores sensibles par défaut.

### 9.2 PNJ

**[D]** Définir un générateur `NPCArchetype` : identité narrative fictive, rig réutilisable, famille d'animations, zone de navigation, comportement prédéfini, script d'interaction, rôle de service, contenu localisé. Le comportement ordinaire est déterministe (arbre d'états ou tâches simples); aucune inférence IA facturée en direct. Les personnages guides doivent distinguer clairement fiction narrative et information attestée kOA.

### 9.3 Vie sociale

L'interaction sociale utilise les canaux et restrictions d'âge pris en charge par Roblox. Éviter de développer un « chat miroir » non filtré vers les services externes. Tout texte proposé par des utilisateurs puis affiché à d'autres dans Roblox suit les règles de filtrage et de modération, et les contenus amenés de l'écosystème externe passent un contrôle de compatibilité du canal. Les mécanismes communautaires de signalement, de blocage, de limitation et d'escalade sont explicites.

### 9.4 Présence inter-Places

Le noyau conserve une indication agrégée et non sensible de fréquentation par lieu, si admissible. Une carte des amis ou des réunions demande un contrat de présence conforme aux politiques de confidentialité. La présence Roblox n'est pas systématiquement synchronisée avec celle des comptes Web; aucune présence « en ligne » fictive n'est inventée pour remplir des bâtiments.

## 10. Conformité du canal Roblox et séparation des contenus

### 10.1 Risque structurant : contenus civiques et politiques

**[R]** Les normes communautaires Roblox actuelles interdisent notamment le contenu concernant des figures politiques actuelles/récentes, des partis et des courses électorales déterminées. Elles autorisent un certain débat social, mais l'exposition des idées, acteurs et messages est encadrée. Elles prohibent aussi la création d'expériences uniquement destinées à rediriger les utilisateurs hors Roblox et limitent les liens externes partagés dans l'expérience. **[D]** Une ville de gouvernance réelle ne peut pas supposer que *toutes* les consultations eThikos pourront être affichées dans Roblox.

### 10.2 Politique de diffusion par canal

Chaque ressource/proposition reçoit des métadonnées spécifiques au canal :

```json
{
  "resource_ref": "owner:consultation:opaque-id",
  "source_owner": "konnaxion",
  "moderation_state": "approved",
  "channel_exposure": {
    "web": "allowed_by_owner_policy",
    "roblox": "community_learning_only"
  },
  "reviewed_policy_version": "roblox-policy-2026-10-18",
  "locale": "fr-CA",
  "rights": "user_visible_minimum",
  "revision": "8"
}
```

Valeurs proposées Roblox : `approved_public`, `education_only`, `restricted`, `blocked`, `requires_review`. L'absence de qualification = **non publié** dans Roblox. Les politiques peuvent dépendre de l'audience; le filtrage automatique seul ne suffit pas à certifier la conformité des débats complexes. Réviser les normes et faire vérifier les contenus sensibles avant publication. La politique propriétaire Web est indépendante : une ressource bloquée dans Roblox peut rester licitement accessible dans le Web, si autorisée par ses propres règles.

### 10.3 Filtrage des textes

**[R]** Roblox exige que les développeurs filtrent correctement les textes qu'ils affichent et sur lesquels ils n'exercent pas de contrôle explicite. **[D]** Les textes issus de commentaires, réponses libres et créations participatives passent un pipeline : origine → typage → modération propriétaire → politique du canal → filtrage Roblox lorsque requis → rendu. Les contenus non adaptés ne doivent pas être injectés automatiquement dans les panneaux 3D. La traduction ne supprime pas l'obligation de filtrage.

### 10.4 Liens, incitation à sortir et authentification

Les utilisateurs doivent pouvoir utiliser Kin City Roblox comme une vraie expérience, et pas seulement comme publicité pour un site. Ne pas afficher d'URL externe ou de code de redirection dans des interfaces Roblox sans base réglementaire claire. L'identité couplée et les ponts Web exigent une vérification spécifique de la politique du produit pour les groupes d'âge concernés. Les liens sociaux autorisés sur les pages publiques Roblox ne rendent pas les URL arbitraires admissibles dans le jeu.

### 10.5 Catégories sensibles et public mineur

Ne pas proposer comme « exercice pédagogique » une simulation qui délivre réellement un diagnostic médical, un conseil financier réglementé, une consultation juridique ou un profilage de caractéristiques protégées. Les contenus doivent rester dans les catégories et maturités permises; appliquer les exigences de signalement, confidentialité, modération, conservation et traitement des incidents appropriées. La ville peut proposer des expériences pédagogiques fictives étiquetées comme telles, sans les présenter comme des avis professionnels.

## 11. Fabrication industrielle : générateurs réutilisables et absence d'IA à l'usage

### 11.1 Principe de compilation de la ville

**[D]** La ville ne doit pas être construite bâtiment par bâtiment à coups de copier-coller non contrôlés. Elle doit être **compilée à partir de manifests et de catalogues versionnés**. L'intelligence artificielle n'intervient que pendant l'élaboration du code, des règles et des assets éventuels; la compilation de la ville, des intérieurs, des PNJ et des affichages est du logiciel déterministe. Pour les sorties créatives, une bibliothèque de motifs et des graines contrôlées produisent des variations reproductibles.

```text
Catalogue de quartier + schéma validé + ressources licenciées
                           │
                 Validateur de manifestes
                           │
            Générateurs (Luau / scripts hors Studio)
            ├── terrain et voirie
            ├── façades et parcelles
            ├── intérieurs / assemblage modulaire
            ├── mobilier, éclairage et signalétique
            ├── personnages et comportements
            ├── activités et terminaux interactifs
            ├── portes et graphe de navigation
            └── paquet d'assets et localisations
                           │
             scènes Roblox / artefacts publiables
                           │
            validations automatiques + jeu publié
```

### 11.2 Générateurs et propriétés attendues

| Générateur | Entrée déterministe | Sortie | Contrôles automatiques |
|---|---|---|---|
| Ville | anneaux, rayons, rues, quartiers, parcelles | routes, places, accès | chemins connectés, absence d'obstacles majeurs |
| Façade | archétype, dimensions, thème, graine | enveloppe bâtie | empreinte, collisions, façade lisible |
| Intérieur | bâtiment, fonction, capacité, accessibilité | salles, mobiliers, points d'intérêt | issues, parcours, visibilité, débit |
| Université | catalogue d'activités, salles et contrats | laboratoire, amphithéâtre, cours | activités atteignables, état métier externe |
| PNJ | archétype, scénario, comportements | modèles et interactions | nombre, navigation, absence de boucles |
| UX | capacités, messages, langues | panneaux, guichets et terminal | localisation, lisibilité, états vides |
| Porte | source, destination, droits, retour | portail / chargement | refus, retour, coupure réseau |
| Conformité | contenus + politique de canal | catalogue publiable | interdictions, droits, révisions |

### 11.3 Écosystème d'outils

- **Roblox Studio + Luau** pour moteur, assets, interfaces et exécution; logiciel propriétaire, gratuit à utiliser selon conditions.
- **Rojo** pour synchroniser un projet textuel avec Studio et conserver un dépôt Git lisible.
- **Wally** pour dépendances Luau; chaque dépendance est évaluée selon sa licence, sa maintenance et sa compatibilité.
- **Blender** pour modèles 3D exportables; licence GPL pour Blender lui-même, sans assimiler automatiquement les fichiers produits à du GPL.
- **Tests Luau, linters, validation JSON et diagnostics** à définir et verrouiller par versions. Aucun dépôt open source tiers n'est recopié dans un système sans audit de licence et de sécurité.
- **MCP et assistants facultatifs** pour accélérer l'édition, sans en faire un prérequis de compilation, de runtime ou de déploiement. L'autonomie doit être possible par un simple flux de fichiers et de copier-coller.

### 11.4 Organisation des ressources

Chaque `asset_ref` pointe vers une ressource admise, une version, une licence, une provenance, des empreintes de contenu et des contraintes d'usage. Les URL dynamiques et imports arbitraires générés par des utilisateurs sont interdits. Les profils de qualité (mobile, ordinateur, consoles compatibles) sont des paramètres de rendu séparés des règles de gouvernance. Les scènes publiées sont identifiables par `build_id` et `manifest_digest`.

### 11.5 Reproductibilité

Un compilateur de ville doit produire un rapport `build_record` documentant version des générateurs, hash des manifests, versions des assets, IDs des Places cibles, résultats des contrôles, limite mémoire mesurée et empreinte du paquet publié. La source de vérité des Places publiés reste Roblox. Le `build_record` Kin City est une preuve de construction, pas un `ReleaseRecord` kOA ni un état d'activation Kristal.

## 12. Modèle de données logique Kin City (non canonique)

### 12.1 Principes

Le système introduit **le minimum de données réellement propres à Kin City**. Il n'a pas de miroir complet des utilisateurs, consultations, votes, notes, tâches, programmes ou documents. Les clés sont stables, opaques et versionnées; les références propriétaires peuvent évoluer par contrat de résolution.

### 12.2 Entités proposées

| Entité | Champs principaux | Responsabilité |
|---|---|---|
| `CityDefinition` | `city_id`, `revision`, `layout_ref`, `policy_set` | Identité urbaine, version d'ensemble |
| `DistrictDefinition` | `district_id`, `theme`, `map_region`, `owner_capability_refs` | Quartier et navigation |
| `BuildingDefinition` | `building_id`, `district_id`, `place_binding`, `template`, `entry_policy` | Bâtiment et porte |
| `PlaceBinding` | `roblox_universe_id`, `place_id`, `role`, `build_id` | Routage Roblox explicite |
| `SceneManifest` | `asset_bundle_ref`, `generator_revision`, `seed`, `interactions` | Construction réutilisable |
| `InteractionBinding` | `interaction_id`, `capability_ref`, `ui_profile`, `policy_ref` | Pont interaction-API |
| `CitizenLink` | `roblox_user_id`, `subject_ref`, `status`, `revoked_at` | Association de compte bornée |
| `GatewayOperation` | `command_id`, `owner_ref`, `state`, `receipt_ref`, `expires_at` | Déduplication et reprise |
| `PresentationSnapshot` | `owner`, `revision`, `ttl`, `projection_data` | Cache jetable |
| `ContentAdmission` | `resource_ref`, `channel`, `review`, `policy_version` | Admissibilité de contenu |
| `PortalTrace` | `request_ref`, `source_place`, `target_place`, `result` | Diagnostic de franchissement |

**À ne pas créer** : `KinCityVotes`, `KinCityOfficialCredits`, `KinCityCanonicalKnowledge`, `KinCityOrgoTasks`, `KinCityEkoHScoreAuthority`. Les tables du Gateway éventuelles ne doivent jamais devenir des sources de vérité de ces domaines.

### 12.3 Versionnement

Sémantique suggérée : versions majeures incompatibles pour les schémas de contrats, numéros de révision pour les entités, hashes d'artefact pour les assets et `policy_version` pour les règles de diffusion. Un consommateur refuse les versions majeures inconnues; jamais « interpréter au mieux » une mutation critique.

## 13. Interfaces et états de rendu

### 13.1 Conception de l'interface Roblox

Les terminaux, panneaux, guichets, livres et scènes utilisent les widgets natifs de Roblox. Une interface peut être à l'écran ou attachée à un objet 3D, selon lisibilité et accessibilité. Conserver une navigation directe (menu des destinations, raccourcis, recherche) pour éviter de contraindre quelqu'un à parcourir plusieurs centaines de mètres virtuels avant d'accéder à une ressource éducative. L'immersion est un **mode d'accès**, pas un obstacle à l'accès.

### 13.2 États minimums de chaque activité

`idle`, `loading`, `available`, `empty`, `restricted`, `needs_auth`, `validation_error`, `submitting`, `submitted`, `pending_owner_confirmation`, `confirmed`, `conflict`, `offline`, `unavailable`, `recovered`. Le widget ne doit pas afficher « voté » lorsque le service a seulement répondu `accepted`. Les résultats de consultation portent le nombre de votes bruts et la méthode de pondération lorsque publiables.

### 13.3 Accessibilité

- Localisation au minimum FR et EN prévue dans la source, autres langues selon catalogues réels; séparer messages et géométrie.
- Contraste, taille de texte, navigation au clavier/manette/tactile selon appareil, sous-titres et alternative aux gestes complexes.
- Mode de déplacement rapide vers les bâtiments disponibles et options de réduction des effets visuels.
- Parcours Web équivalent pour les fonctionnalités qui ne peuvent pas être rendues de façon accessible dans Roblox.
- Ne pas inférer un handicap, un âge exact ou une caractéristique protégée à partir du comportement de l'avatar.

### 13.4 Expérience cohérente d'un citoyen

Arrivée sur la place → découverte de la carte → entrée par porte → activité KonnectED → progression conservée par l'autorité pédagogique → invitation vers une consultation admissible → lecture Smart Vote autorisée → consultation d'un projet → retour. Le parcours reste viable avec contenu minimal si un service est temporairement indisponible, sans injecter de faux contenus « pour remplir l'expérience ».

## 14. Sécurité : modèle de menaces et défenses

| Menace | Impact | Défense cible | Évidence de contrôle |
|---|---|---|---|
| Client falsifie ses crédits EkoH | Vote manipulé | Pondération exclusivement chez Konnaxion/EkoH | Test client truqué rejeté |
| Double vote par reprise ou deux serveurs | Compte multiple | Idempotence au propriétaire, contrainte transactionnelle | Test simultané multi-serveurs |
| Usurpation serveur Roblox | Appels non autorisés | Secrets Store, authentification service, rotation, restriction de capacités | Test clé révoquée / inconnue |
| Fausse liaison de comptes | Exposition de données | preuve bilatérale, lien révocable, identité OIDC non basée sur courriel | Tests de confusion identité |
| Passage dans un Place sans droits | Accès illégitime | téléportation côté serveur et revalidation à l'arrivée | Test entrée directe interdite |
| Texte problématique venu de kOA | Retrait de l'expérience | admission par canal + filtrage/contrôle | Tests modération multilingue |
| Panne API externe | Échec des activités | circuit breaker, cache autorisé, états dégradés | Tests coupure réseau |
| Cache obsolète d'une décision | Mauvais état affiché | TTL court + révisions + invalidation | Test changement en amont |
| Divulgation d'URL ou secret | Compromission | aucun secret client, logs épurés | Scan de dépôts et assets |
| Dérive des contrats métier | Affichage trompeur | schémas versionnés, refus si incompatible | Contract tests CI |
| Assets malicieux non contrôlés | Scripts indésirables | whitelist, inspection, licences, revue manuelle | Rapport SBOM/assets |
| Déni de service par appels répétés | Quota HTTP épuisé | rate limiting par joueur, coalescence, cache | Test de charge contrôlé |
| Profilage social indésirable | Préjudice vie privée | minimisation, accès granulaire, pas de PII miroir | Revue confidentialité |

### 14.1 Secrets et identité de service

Le serveur Roblox charge un secret depuis Roblox Secrets Store (`HttpService:GetSecret`) et l'utilise pour le champ `x-api-key` autorisé. Le Gateway valide cette clé, son canal, son audience et sa révocation. Toute liaison à une identité utilisateur se fait **en plus** de cette authentification de service. Un secret de serveur ne doit jamais accorder à tous les utilisateurs les mêmes droits métier. Rotation avec chevauchement temporel limité, journalisation des rotations, aucune clé dans un asset, un fichier source partagé ou les logs.

### 14.2 Autorisations propriétaires et anti-confusion

Les IDs externes sont toujours typés et validés; `1234` côté Roblox n'est pas un identifiant interne kOA. Les politiques du Gateway peuvent réduire des droits, jamais les élargir. Une autorisation sur un projet ne donne pas l'autorisation sur un vote; une authentification OIDC n'autorise pas une tâche Orgo. Une preuve de réussite dans l'interface ne vaut pas reçu opérationnel.

## 15. Exploitation, télémétrie et comportement en panne

### 15.1 Journalisation corrélée

Chaque transaction porte `correlation_id`, `command_id`, `roblox_universe_id`, `place_id`, `server_job_id`, propriétaire, version de contrat, statut, durée, taille de réponse, classe d'erreur et identifiant pseudonymisé de session. Aucune collecte massive des messages ou données personnelles pour simples métriques de trafic. Les systèmes propriétaires conservent leurs traces selon leurs politiques.

### 15.2 Indicateurs d'expérience et d'intégrité

Taux d'entrée réussie dans chaque bâtiment, échecs de téléportation, latence p50/p95/p99 des lectures, débit HTTP/min/serveur, 429, erreurs de liaison, rejet d'accès, validations de réponse, succès des soumissions confirmé par reçu propriétaire, absence de doubles votes, temps de chargement et mémoire par profil d'appareil, proportion de contenu admissible/refusé. Compter séparément les votes soumis, acceptés, confirmés, modifiés et annulés.

### 15.3 Dégradation sans corruption

- Si le Gateway est indisponible : signaler clairement l'indisponibilité des actions externes; laisser naviguer si possible; pas de vote local prétendument officiel.
- Si Konnaxion est indisponible : consulter des fiches publiques fraîches seulement si leur TTL l'autorise; pas d'enregistrement fictif.
- Si Orgo est indisponible : ne pas afficher une exécution de décision non confirmée.
- Si la connexion utilisateur expire : réduire les capacités et demander une restauration conforme, pas utiliser un vieux token.
- Si un Place téléporte mal : retour ou procédure de récupération cohérente, pas perte silencieuse des actions validées.
- Si le contenu échoue à la modération : bloquer sa publication Roblox sans altérer la donnée source.

### 15.4 Sauvegarde et reprise

Les sauvegardes métier sont propriétaires. Le catalogue Kin City, les manifests et les artefacts publiés doivent être sous contrôle de version et reconstructibles. Tester le retour à une version antérieure des scènes et du Gateway **sans faire revenir en arrière** les décisions et votes du propriétaire. Les références incompatibles deviennent des messages de maintenance, jamais des accès directs à des tables locales.

## 16. Performance, capacité et coût

### 16.1 Sources des limites

Roblox impose toujours les contraintes de machines des joueurs, clients mobiles, mémoire, rendu, physique, bande passante et taille des sessions. Déporter le calcul des classements, du vote ou des analyses sur un serveur externe ne supprime pas les contraintes de streaming et de réplication. Le nombre de questions en base externe ne détermine pas directement la capacité de la ville; ce sont les objets 3D chargés, les interfaces ouvertes et la fréquence d'échanges qui comptent.

### 16.2 Budgets à définir et à mesurer

| Budget | Unité | Critère d'acceptation |
|---|---|---|
| Temps d'entrée dans la ville | secondes, p50/p95, appareil | cible chiffrée et mesurée selon marché/appareil |
| Temps d'entrée dans un bâtiment | secondes, p50/p95 | y compris écran de transition |
| Images/seconde | FPS sur profils matériels réels | stabilité selon scènes et pics |
| Mémoire | Mo par client et Place | pas de dépassement sur cible minimale |
| HTTP externe | appels/minute/serveur | marge sous 500 et réponse correcte aux 429 |
| Latence API | p50/p95/p99 par capacité | UX compatible avec opération |
| Activité concurrents | joueurs/Place/serveur | capacité mesurée, non supposée |
| Cache | taux hit, fraicheur par classe | pas d'exposition de données obsolètes critiques |
| Qualité des votes | doublons, pertes, reçus | zéro mutation double dans les tests de collision |
| Accessibilité | parcours couverts | navigation alternative testée |

Aucune valeur p95, FPS, coût serveur ou cible de simultanéité n'est fournie par les sources. **[A]** On ne peut donc pas promettre « ville illimitée » ou « 10 000 personnes ensemble au même endroit »; dimensionner et qualifier sur des scénarios réels avant annonce publique.

### 16.3 Coûts

Le runtime de Kin City ne nécessite **aucune API IA** pour ses opérations déterministes. Néanmoins, les coûts non IA restent : hébergement externe, bases et caches selon infrastructure existante, bande passante, stockage des assets et médias, tests de charge, surveillance, modération, licences d'assets éventuelles, temps de développement et exigences de conformité. Roblox Studio peut être utilisé gratuitement, mais publication et exploitation restent soumises aux conditions/éligibilités en vigueur. Un cache externe, un compte de stockage ou un serveur commercial n'est pas automatiquement gratuit.

## 17. Organisation du code et contrats de construction

### 17.1 Référentiel de projet proposé

```text
KinCity/
├── README.md
├── LICENSES.md
├── docs/
│   ├── architecture.md
│   ├── owner-contracts.md
│   ├── security-policy.md
│   ├── content-admission.md
│   ├── operational-runbook.md
│   └── acceptance-matrix.md
├── schemas/
│   ├── city-manifest.schema.json
│   ├── building-manifest.schema.json
│   ├── scene-manifest.schema.json
│   ├── capability-envelope.schema.json
│   └── content-admission.schema.json
├── catalog/
│   ├── city.json
│   ├── districts/
│   ├── buildings/
│   ├── npc-archetypes/
│   ├── interactions/
│   └── translations/
├── assets/
│   ├── LICENSES.md
│   ├── meshes/
│   ├── textures/
│   ├── animations/
│   └── provenance/
├── generators/
│   ├── city/
│   ├── architecture/
│   ├── interiors/
│   ├── npc/
│   ├── ui/
│   └── validation/
├── roblox/
│   ├── default.project.json
│   ├── src/
│   │   ├── ReplicatedStorage/
│   │   ├── ServerScriptService/
│   │   │   ├── ApiGatewayClient/
│   │   │   ├── DoorRouting/
│   │   │   ├── Interactions/
│   │   │   └── PolicyGuards/
│   │   ├── StarterPlayer/
│   │   └── StarterGui/
│   └── places/
│       ├── city/
│       ├── agora/
│       ├── library/
│       ├── campus/
│       └── reusable-interiors/
├── gateway/
│   ├── contracts/
│   ├── handlers/
│   ├── owner_adapters/
│   ├── policy/
│   ├── auth/
│   └── tests/
├── tests/
│   ├── manifests/
│   ├── security/
│   ├── contract/
│   ├── gameplay/
│   ├── load/
│   └── e2e/
└── build/
    └── manifests/
```

Il s'agit d'une **organisation recommandée**, non d'un dépôt déjà créé. `gateway` peut être extrait en paquet réutilisable selon les normes de kOA. L'emplacement canonique des `Konnaxion_Worlds` ne doit pas être recopié dans `KinCity/`, conformément à sa propriété propre. Les lieux Roblox n'ont pas besoin d'un dossier identique pour chaque bâtiment si des gabarits partagés sont utilisés.

### 17.2 Contrats avec les propriétaires

Avant toute capacité en écriture, disposer de : référence du propriétaire, version d'API, schéma requête/réponse, procédure d'authentification de service, politique d'utilisateur final, état de qualification documenté, codes d'erreur, règle de rétention, exigences d'audit, idempotence, timeout, méthode de rollback/reconciliation et politique de confidentialité. Les GET publics doivent également exposer des limites et règles de visibilité.

**[A] Inventaire à rapprocher du code réel :** endpoints Konnaxion pour eThikos/Smart Vote/EkoH, références UCKK et projection Kristal, mécanisme de compte fédéré autorisé, flux d'événements admissibles, capacités de recherche et de contrôle d'accès. Les noms donnés à la section 5 sont des propositions de façade et non une description de routes déjà prêtes.

### 17.3 Définition d'une modification maîtrisée

Toute modification d'un bâtiment, gabarit, contrat ou donnée publique porte diff et preuve : modification de manifeste, justification, validation de schéma, compilation, test de porte, contrôle politique, test de performance, revue de licence, signature de publication adaptée à l'environnement. L'outil de vibe coding produit un changement contrôlable dans les fichiers; l'application de ce changement ne contourne jamais les tests.

## 18. Qualifications et matrice d'acceptation du résultat final

Il y a **un seul système cible durable**, mais une **première livraison exploitable de l’univers sans kOA**, acceptée selon KC-WORLD-01 à KC-WORLD-10 (§0.4). Les critères AC ci-dessous s'appliquent au produit final **une fois connecté**; ils ne bloquent pas la livraison de la ville en mode stub. Cette première livraison n'est pas un prototype jetable.

| ID | Comportement terminal attendu | Preuve requise |
|---|---|---|
| AC-01 | La ville entière se génère depuis des catalogues contrôlés | Build reproductible et comparaison de manifests |
| AC-02 | Le centre et chaque quartier sont accessibles | Tests de graphe, déplacements, raccourcis et signalétique |
| AC-03 | Les portes des bâtiments riches ouvrent le bon Place | Client Roblox publié, tests téléportation, retour et échec |
| AC-04 | Un intérieur complexe charge dans son budget cible | Mesures mémoire/FPS/temps sur appareils désignés |
| AC-05 | Les activités éducatives reflètent la vérité du propriétaire | Tests contrats, tests de progression et de panne |
| AC-06 | 1 000 questions sont filtrables par sujet/locale | Tests catalogue, pagination et mises à jour |
| AC-07 | Un vote ne peut être confirmé deux fois par duplication | Test de concurrence, clés d'idempotence et reçus |
| AC-08 | Le poids du vote n'est jamais fourni par le client | Test de falsification client et audit propriétaire |
| AC-09 | Résultats bruts, lectures pondérées et décisions distincts | Test d'écrans et API avec vrais états intermédiaires |
| AC-10 | Seule une décision eThikos finalisée peut déclencher le transfert Orgo | Test frontière gouvernance→opérations |
| AC-11 | Les capacités Web/Roblox restent cohérentes sur état commun | Parcours E2E avec une même identité admissible |
| AC-12 | Une identité Roblox ne prend pas les droits d'un autre compte | Confusion OIDC, liaison/révocation et test 2 comptes |
| AC-13 | Aucune donnée privée non nécessaire n'est publiée | Revue DTO et scans des DataStores/remote events |
| AC-14 | Les contenus interdits Roblox ne traversent pas | Tests d'admission et revue de modération |
| AC-15 | Aucune clé API n'est visible côté client/asset/source | Scan statique et test d'exploitation |
| AC-16 | L'expérience fonctionne sous les quotas HTTP | Tests 429, budget, coalescence et cache |
| AC-17 | Une panne du Gateway n'enregistre pas un faux vote | Tests `OWNER_UNAVAILABLE`, reprise et réconciliation |
| AC-18 | Chaque capacité critique a des journaux corrélés | Requête traçable de Roblox au propriétaire |
| AC-19 | Jeu et Gateway peuvent revenir à une build antérieure sans perdre les données métier | Simulation de rollback par version |
| AC-20 | Les joueurs peuvent apprendre sans payer d'IA à chaque action | Test runtime sans aucune API IA |
| AC-21 | Les droits d'auteurs et licences d'assets sont vérifiés | Registre des assets et attestations de permission |
| AC-22 | Le système est réellement documenté comme exploitable | Runbooks, alertes, contacts, inventaire des dépendances |
| AC-23 | Les utilisateurs peuvent naviguer sans mobilité précise de l'avatar | Parcours alternatif clavier/manette/tactile |
| AC-24 | L'état de maturité indiqué ne dépasse pas la preuve | Registre des qualifications datées, liens vers artefacts |

### 18.1 Essais de robustesse obligatoires

Test de vote simultané depuis Web et deux serveurs Roblox; test d'une fermeture de consultation entre affichage et soumission; test de révision de question; test de changement de poids EkoH entre participation et lecture; test d'une décision finalisée suivie d'un Orgo indisponible et de replay; test d'entrée dans un Place par un chemin détourné; test de liaison de comptes concurrents; test de expiration de session; test de mauvais schéma de réponse; test de surcharge du quota HTTP; test d'interruption pendant chargement; test de suppression de ressource de connaissance; test de modération multilingue; test d'utilisation sur mobile de faible mémoire; test de redéploiement et rollback.

### 18.2 Seuils de livraison

Toutes les propriétés **obligatoires** doivent être satisfaites, avec un procès-verbal de qualification. Les cibles de FPS, latence, charge simultanée, audience et temps de chargement doivent être fixées quantitativement d'après les appareils et exigences retenus avant acceptation; **aucun seuil numérique n'est inventé** dans ce document. Une contrainte externe empêchant la liaison d'identité ou la diffusion d'un type de consultation n'est pas « compensée » par une fausse interface; elle est matérialisée en restriction du canal et documented comme telle.

## 19. Décisions d'architecture (ADR) proposées

| ADR | Décision | Motivation et effet |
|---|---|---|
| KC-ADR-001 | Roblox et Web sont deux clients du même écosystème | préserver la cohérence métier et l'autonomie |
| KC-ADR-002 | Gateway propriétaire de la traduction, non des données | isoler les contrats Roblox et les secrets |
| KC-ADR-003 | Une porte peut correspondre à un `Place`, jamais à une simple image | isoler rendu et chargement des intérieurs riches |
| KC-ADR-004 | Revalidation des droits à chaque destination | éviter usurpation par téléportation |
| KC-ADR-005 | Scores, crédits, votes, lectures et décisions séparés | intégrité EkoH/Smart Vote/eThikos |
| KC-ADR-006 | Idempotence exprimée en JSON public, traduite en en-têtes internes | restriction d'en-têtes HttpService |
| KC-ADR-007 | Contenu admis explicitement par canal | règles politiques, mineurs, confidentialité |
| KC-ADR-008 | Générateurs déterministes, pas d'IA runtime requise | reproductibilité et coût nul par appel IA |
| KC-ADR-009 | Catalogues et gabarits versionnés au lieu de scripts copiés | maintenabilité et construction massive |
| KC-ADR-010 | Erreurs et indisponibilités visibles, aucun faux succès | respecter l'intégrité des propriétaires |
| KC-ADR-011 | Koali reste le compositeur de présentation Web | éviter une reprise d'autorité par Kin City |
| KC-ADR-012 | Secrets et droits exclusivement côté serveur | sécurité, défense en profondeur |

Ces ADR devront recevoir une validation interne des propriétaires concernés; l'état « proposé » n'est pas « accepté ».

## 20. Paramètres et preuves encore indisponibles

Cette liste n'est **pas** une demande de redéfinir le produit par étapes. Elle empêche une documentation cible de se déguiser en preuve d'implémentation.

1. **Inventaire exact des endpoints métier Konnaxion** permettant `consultation.list/read/vote`, `EkoH reading`, `DecisionRecord`, ainsi que leurs versions et qualifications.
2. **Contrat formel des crédits** : origine, signification, durée, domaine, droits acquis, articulation ou non avec EkoH. Ne pas inventer une formule de pondération.
3. **Capacités éducatives en écriture** disponibles sur UCKK/KonnectED et contrat de certification réel.
4. **Politique d'association Roblox↔kOA** et admissibilité par âge, selon les règles Roblox applicables à la destination et au public.
5. **Taxonomie de modération du contenu eThikos** et propriétaire de l'arbitrage humain en cas de refus.
6. **Inventaire réel des assets 3D** : contenu, licences, taux de réutilisation, gabarits, identité visuelle.
7. **Topologie d'hébergement kOA** : réseau, identité de services, disponibilité, sauvegardes et politique de secret; la documentation transversale n'est pas une topologie de déploiement.
8. **Nombre cible de bâtiments, joueurs simultanés et appareils**, indispensables pour chiffrer les tests de performance sans promesse gratuite.
9. **Publication Roblox** : IDs d'univers/Places, propriétaire de groupe, droits de publication, classification de l'expérience, plan de maintenance.
10. **Statut des intégrations Kristal récentes** : l'instantané contient des références v6 historiques et des travaux d'harmonisation v10; utiliser la version admise du propriétaire, pas fusionner les deux.
11. **État de production du système kOA** : certains travaux sont qualifiés localement, mais les sources interdisent d'en déduire une disponibilité générale en production.
12. **Légalité de certaines activités communautaires** et conservation de données selon les régions et audiences effectivement visées.

## 21. Recommandation architecturale optimisée

### 21.1 Choix principal

**Construire d’abord la ville Roblox définitive, avec interactions réelles et fournisseurs `stub`, puis activer les fournisseurs kOA via le Gateway seulement quand leurs contrats seront qualifiés.** Maintenir la compilation déterministe, les intérieurs riches séparés aux portes, les catalogues versionnés, l’identité bornée et la politique stricte de diffusion par canal. Ce choix maximise la réutilisation de l'écosystème, minimise l'effort de construction scène par scène et évite de multiplier des systèmes de vérité concurrents.

### 21.2 Compromis assumés

- Un Place par grand bâtiment isole bien la complexité, mais ajoute des chargements et complique la co-présence; la réutilisation de gabarits et la définition de seuils de coût éviteront une fragmentation excessive.
- Déporter les calculs protège l'intégrité et augmente les capacités métier, mais la latence et le quota HTTPS rendent indispensable l'architecture de cache et de reprise.
- Le contenu civique complet accessible par Web ne peut pas nécessairement être visible dans Roblox : cette limitation protège la conformité mais crée une asymétrie de présentation assumée.
- Une ville très détaillée est possible comme ensemble de lieux optimisés, pas comme promesse de décor illimité chargé en mémoire simultanément.
- Des centaines de générateurs facilitent l'échelle seulement si leurs contrats, bibliothèques et tests sont partagés; une accumulation de programmes indépendants sans schéma commun recréerait les problèmes d'intégration.

### 21.3 Pourquoi cette architecture est meilleure qu'une adaptation simple du jeu Roblox

Une adaptation simple répéterait les règles et données dans Luau, multiplierait les requêtes par interaction, dépendrait des assets manuels et risquerait d'être incompatible avec les autorités kOA. La proposition optimise simultanément **qualité métier**, **rendu**, **coûts d'IA**, **possibilité de maintenir le système**, **conformité** et **capacité de grandir en bâtiments**. Elle transforme la ville en produit de génération et d'intégration plutôt qu'en collection d'objets insérés manuellement dans une scène.

## 22. Bibliographie et provenance opérationnelle

### 22.1 Documents remis — références internes vérifiables

- Kin City, *Kin City : une interface virtuelle visionnaire pour l'initiative kOA* (document utilisateur). Vision de ville, plan concentrique, quartiers, modules, parcours, gouvernance et accessibilité.
- *To create KinCity as a functional and symbolic representation ...* (document utilisateur). Exploration non normative des médiums.
- ZIP `znapshot_kOA_Digital_Ecosystem_10181459(1).zip` : `docs/2-Technical-Reference/10-system/authority-map.md`, `trust-boundaries.md`, `docs/status/current.md`, `docs/2-Technical-Reference/40-integration/contract-map.md`, `docs/2-Technical-Reference/90-reference/adr/adr-0007-konnaxion-ethikos-decision-authority.md`, `docs/2-Technical-Reference/40-integration/identity-oidc/`, `docs/inventory/README.md`, `docs/1-Overview/Non-goals.md`.
- ZIP `kOA_Digital_Ecosystem.wiki(1).zip` : wiki conceptuel secondaire, à départager des documents plus récents.
- Dépôts publics : `https://github.com/Rejean-McCormick/Konnaxion`, `https://github.com/Rejean-McCormick/Orgo`, `https://github.com/Rejean-McCormick/Koali-Spaces`. Le contenu des README et des routes documentées a été examiné; pas d'audit complet du code source de tous les dépôts.

### 22.2 Sources officielles Roblox consultées le 18 octobre 2026

- HTTP et limitations : https://create.roblox.com/docs/cloud-services/http-service
- API HttpService : https://create.roblox.com/docs/reference/engine/classes/HttpService
- Téléportation : https://create.roblox.com/docs/projects/teleport
- `TeleportOptions` : https://create.roblox.com/docs/reference/engine/classes/TeleportOptions
- Streaming des instances : https://create.roblox.com/docs/workspace/streaming
- Performance et Places : https://create.roblox.com/docs/performance-optimization/design
- Secrets Store : https://create.roblox.com/docs/cloud-services/secrets
- Filtrage de texte : https://create.roblox.com/docs/ui/text-filtering
- Liens sociaux : https://create.roblox.com/docs/production/promotion/social-media-links
- Normes communautaires : https://about.roblox.com/community-standards

### 22.3 Convention des preuves

Une référence aux documents ci-dessus prouve l'existence d'une **description**, pas nécessairement celle d'un serveur actif. Pour chaque capacité effectivement branchée, publier : version du contrat, état de qualification, code propriétaire ou artefact de preuve, environnements concernés et date du test. Pour les politiques Roblox, conserver la date de consultation et revérifier à chaque publication majeure.

---

**Conclusion de référence.** Kin City peut être construite comme une ville Roblox ambitieuse, éducative et reliée au Web sans recréer les systèmes kOA ni payer des inférences d'IA à chaque action. Le résultat final n'est pas une très grosse scène : c'est **une ville compilée, une constellation d'intérieurs riches, une façade de capacités sécurisée et un lien fidèle avec les systèmes propriétaires**. Les limites réelles — moteur Roblox, politiques de contenu, quota HTTP et preuve de disponibilité des API — sont explicitées dans les contrats et critères d'acceptation plutôt que masquées par une promesse de complexité illimitée.
