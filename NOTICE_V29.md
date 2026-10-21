# Kin City v29 — notice courte

**Installation dans Roblox Studio, mode Édition (Play arrêté).** Ouvrir **View > Command Bar**, coller **le contenu complet** d'un seul fichier Luau, exécuter, puis lancer Play.

- **Ville seule** : `KinCity_Installation_Directe_v29.luau` (identique à `KinCity_Installation_Place_city_v29.luau`). **C'est l'installateur recommandé pour la Place extérieure.**
- **Huit institutions indépendantes** : ouvrir chacune dans sa propre Place Studio avec `KinCity_Installation_Place_<cle>_v29.luau` (`city_hall`, `ekoh_tower`, `campus`, `justice_palace`, `innovation_lab`, `library`, `museum`, `orgo_center`).
- **Secours / aperçu tout-en-un** : `KinCity_Installation_Univers_Local_v29.luau` pour ville + huit intérieurs dans **une seule Place**. **Ce mode n'est pas une simulation de neuf Places réellement publiées.**
- `KinCity_Installer_CommandBar.luau` : équivalent historique du mode tout-en-un.

**Important :** la régénération supprime et reconstruit `Workspace.KinCityGenerated`. Toute retouche manuelle de ce dossier sera remplacée : dupliquer la Place ou sauver ces retouches ailleurs avant l'installation. La Baseplate de démarrage éventuellement détectée comme coplanaire est déplacée sans destruction dans `ServerStorage.KinCityOriginalGround`. Les autres Terrains et constructions personnalisées sont conservés sauf incident non vérifié dans Studio.

**Commandes :** G = magie de King Klown (R3 manette / Magie tactile), H = gare, M = carte, N = destinations, J = carnet, T = galeries, K = ateliers, P = ciel, V = qualité locale. Les outils sont regroupés dans **☰ KIN CITY** ; fermeture ✕, Échap ou B. Ouvrir le menu avec le bouton ou **Select** sur manette. La bibliothèque est une **première visite facultative** depuis ce menu. Les guides se masquent séparément et une seule destination est active à la fois.

**FPS :** ☰ KIN CITY → « Mesurer les FPS (20 s) » déclenche seulement sur demande le prélèvement sur cet appareil. FPS moyen, temps/image médian, p95 et changement de zone/qualité sont affichés ; aucun appel réseau.

**Portes en aperçu :** les installateurs séparés sont des **aperçus non publiés**. La porte ne peut pas téléporter entre ces Places tant que les neuf PlaceIds réels n'ont pas été renseignés dans `config/place_ids.json`, que `config/runtime.json` n'est pas passé en `MULTI_PLACE`, que les installateurs n'ont pas été reconstruits, et que les neuf Places ne sont pas correctement publiées. Aucun PlaceId ni AssetId n'a été inventé.

**Contrôles Studio restant indispensables :** lancement, respawn, placement de l'avatar, collisions et gazon en tournant la caméra, bordures radiales et annulaires, passages de porte, huit panneaux et leurs vues, menu téléphone/manette, retour du panorama et récit de la bibliothèque. La compilation/exécution Roblox et les téléportations publiées n'ont **pas** été testées dans cet environnement.

Voir `LIVRAISON_V29.md` pour le détail des modifications et tests.
