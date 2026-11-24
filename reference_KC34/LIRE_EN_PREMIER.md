# Kin City · Référentiel maître IA KC34-DOC-1.0

Ce dossier est le **paquet d'alignement** à fournir à dix conversations/branches de développement travaillant **à partir du ZIP KC33**. Ce n'est pas une release Roblox ni un remplacement du projet.

## Démarrage
1. Lire `BIBLE_KINCITY_REFERENCE_IA_KC34.md` (contrats, inventaire, limites, architecture et règles).
2. Ouvrir `protocoles/PROTOCOL_INTEGRATION.md` et démarrer **B09** (intégration) en premier.
3. Démarrer les huit branches B01…B08 avec leur prompt `branches/Bxx_*.md` et la baseline KC33.
4. Démarrer la branche B10 avec `branches/B10_city.md`; elle détient la Place centrale.
5. À chaque livraison, envoyer le diff, les preuves et le JSON `handoff` à B09; ne jamais supposer que les conversations se synchronisent.

## Pourquoi dix branches pour neuf Places ?
B01…B08 = huit intérieurs. B09 = intégration/contrats **sans Place**. B10 = ville centrale (neuvième Place Roblox). Ajouter une dixième Place réelle nécessiterait une décision du propriétaire, de nouveaux manifestes et une migration de portes.

## Contenu
- `BIBLE_KINCITY_REFERENCE_IA_KC34.md` — guide détaillé, architecture, inventaire de chaque intérieur, gouvernance et sécurité.
- `branches/` — dix prompts personnalisés prêts à servir de premier message aux agents.
- `contrats/index_machine.json` — structure comptable lisible par machine.
- `contrats/empreintes_kc33.json` — empreintes des fichiers de référence KC33.
- `contrats/matrice_portes.csv` — 16 transitions et branche de chaque extrémité.
- `protocoles/PROTOCOL_INTEGRATION.md` — règles de remise et de fusion.
- `protocoles/handoff_modele.json` — exemple à remplir, jamais une preuve de test.
- `protocoles/valider_handoff.py` — validation minimale de remise.

## Autorité et prudence
- Les clés canoniques doivent être lues dans le ZIP KC33. Le projet KC33 utilise `LOCAL_UNIVERSE` et a neuf PlaceIds nuls dans ses sources.
- Les 48 salles correspondent à 24 canoniques dans le `world-plan` et 24 supplémentaires créées par `InteriorWings` (si le générateur est appelé).
- Aucune téléportation inter-Place, rendu Studio, mesure FPS ou autorisation de publication n'a été exécutée pour produire ce paquet documentaire.
- Les fichiers de ce paquet ne contiennent pas les meshes du pack commercial.

## Version
- Document : KC34-DOC-1.0
- Sources observées : livraison KC33 datée du 26 octobre 2026
- Toute déviation commune donne lieu à une version des contrats et à une revue B09.
