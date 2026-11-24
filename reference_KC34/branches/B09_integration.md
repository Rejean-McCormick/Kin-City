# B09 — INTÉGRATION, CONTRATS ET RELEASE (PAS UNE PLACE)

**Branche recommandée :** `kc34/B09-integration`  
**Responsabilité :** baseline, conventions, migrations, APIs serveur, compilation, outillage, tests, sécurité et publication *staging* contrôlée; coordination de B01–B08 + B10. Aucune dixième Place Roblox n'existe pour cette branche.

## Contexte non négociable
Tu es un agent travaillant dans un programme **parallèle** de dix branches sur la baseline Kin City KC33. Lis intégralement `BIBLE_KINCITY_REFERENCE_IA_KC34.md`, le ZIP KC33, `contrats/index_machine.json`, `contrats/empreintes_kc33.json` et la présente fiche. Ne déduis aucun contenu d’un autre chat non joint. Tu n’as pas le droit de renommer une clé canonique ni de supposer que les autres IA partagent ton état. Zéro modification de production, aucun PlaceId inventé, aucune API KOALI prétendument fonctionnelle, aucune mesure fictive.

## Règles de livraison
Fournis un patch/ZIP de sources réelles, les chemins modifiés, une raison par modification, des tests positifs et négatifs réellement exécutés, les limites, les captures si tu as accès à Roblox Studio, une liste de régressions et un `handoff` conforme à `protocoles/handoff_modele.json`. Remets à B09 tout changement `SHARED` ou `BREAKING` avant de l’appliquer au tronc commun. Si tu ne peux pas tester Roblox, marque explicitement `NON_TESTÉ`. Évite les modifications ornementales qui augmentent le budget sans améliorer l’expérience.

## Mission prioritaire
1. Établir le dépôt de référence KC33, un hash du ZIP, `CONTRACTS_VERSION=KC34-DOC-1.0`, l'inventaire et un tableau unique des handoffs.
2. Vérifier les neuf clés de Places, seize portes symétriques, quarante-neuf ancres, vingt-quatre salles du plan + vingt-quatre de `InteriorWings`, six couleurs, dix-huit pavillons et quarante-et-un modèles configurés sur cent vingt-et-un. Recompiler le plan dans un fichier temporaire, comparer le hash logique et distinguer les versions de code générées.
3. Examiner le conflit entre **bounds rectangulaires initiaux** des Places intérieures (`110×100`) et les ailes latérales/arrière calculées au runtime; documenter/corriger sans briser passages et coordonnées. Demander l'avis des huit branches avant toute extension globale du catalogue.
4. Définir les API des recettes de Place (`place_key`, contexte, seed, profile, inventory, return metrics), tests de compatibilité et zone de contribution `contrib/places/<key>/` utilisable par les huit équipes; intégrer les contributions sans cloner les générateurs transversaux.
5. Recevoir, valider et fusionner les handoffs; refuser les changements unilatéraux des identifiants, ancres, palettes, sémantiques kOA et routage. Toute rupture exige RFC et ADR avant merge.
6. Auditer `tools/build_staging_places.py`, ses gardes et son refus de la production. **Ne pas fabriquer de PlaceIds**. Préparer staging en neuf Places sous un seul univers Roblox privé, scripts appropriés et processus d'export/rollback.
7. Créer une matrice d'intégration automatisée et réelle : contrats, portes, spawns, collisions, 48 salles, 6 secteurs, 8 façades, profils LITE/STANDARD/SHOWCASE, interactions stub. Collecter preuves Roblox client publié pour les vrais téléports.
8. Mesurer la performance `LOCAL_UNIVERSE` contre `MULTI_PLACE` sur appareils réels; conseiller un mode seulement après résultats.
9. Tenir un journal de décisions d'architecture (ADR), risques, versions, tests et artefacts; publier une **nouvelle baseline unique** après une campagne d'intégration entièrement documentée.

## Contrats à posséder
`catalog/`, `config/`, `src/shared`, `Spatial`, `PlayerTravel`, `WorldBuilder`, mécanismes réseau et de session, générateurs d'assets partagés, politiques de sécurité, compilateur, installateurs, schémas de handoff et CI. B10 garde l'autorité créative sur la ville et les façades; B09 ne remplace pas arbitrairement son travail.

## Attendus première livraison
- Tableau `ACCEPTED / CHANGES_REQUESTED / BLOCKED` pour dix branches, avec hashes de base et hashes de résultats.
- CI/validation cross-branch réelle, reproductible; preuve que les tests négatifs échouent correctement.
- Protocoles pour remises `LOCAL/SHARED/BREAKING` et documentation des décisions.
- Version staging générable **sans** PlaceIds réels, mais non marquée publiée ni testée.
- Liste des permissions humaines et informations indispensables à l'essai publié, et politique de secrets/IDs.

## Stop conditions
Production jamais modifiée. Pas de mutation destructive si PlaceId, univers, autorisation, backup ou origine des assets n'est pas confirmé. Pas de revendication de réussite TeleportService sans test client publié. Ne pas faire passer un échec de test en supprimant l'assertion.
