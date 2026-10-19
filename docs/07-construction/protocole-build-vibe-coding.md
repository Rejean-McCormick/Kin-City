# Protocole de développement avec ChatGPT et copier-coller

## Objectif
Minimiser les changements ambigus. Une requête à l'agent doit tenir sur un composant et s'appuyer sur un contrat exact, sur un jeu de données vérifiable et sur des résultats de tests. **Ne pas confondre « document existant » et « fonctionnalité développée ».**

## Séquence de travail reproductible (sans prototype jetable)
1. Charger les invariants, la spécification de l'entité et le registre des assets.
2. L'agent rend un patch limité à un module/contrat, avec préconditions et rollback.
3. Exécuter validateurs et tests négatifs localement et conserver les sorties.
4. Générer la scène cible à partir du plan canonique, avec IDs stables.
5. Observer le rendu dans Studio et prendre des captures comparables.
6. Effectuer les parcours en client publié pour téléportations; ne jamais les déclarer couverts par le test local.
7. Mettre à jour le manifeste de preuve, sans inventer les étapes non réalisées.

## Modèle de demande à l'agent
> Implémente uniquement `<generator_id>` selon `<doc/contrat>`. N'introduis aucun appel kOA. Préserve tous les `*_id`. Livrer patch complet, nouvelles ressources, cas positifs/négatifs, commandes exécutables, preuves et limitations. L'exécution de code Roblox doit être testée dans Studio et en client publié lorsque nécessaire.

## Politique d'acceptation de patch
Un résultat fondé sur une capture d'écran ou du code « semble bon » est une observation, pas une qualification. Tout écart artistique doit être versionné (override), tout asset tiers doit avoir licence et provenance, toute migration d'ID exige ADR et plan de compatibilité.
