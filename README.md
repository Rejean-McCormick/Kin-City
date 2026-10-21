# Kin City v30.0.7 — Garamond partout, Bodoni en repli

**Installateur univers complet :** `KinCity_Installation_Univers_Complet_v30.0.7.luau` (ville + huit institutions, une seule Place). Voir [`NOTICE_V30.0.7.md`](NOTICE_V30.0.7.md).

Cette passe standardise la typographie visible sur **Garamond**, garde **Bodoni** en repli dans le module commun à toutes les interfaces et enseignes, et pousse plus loin la lisibilité des pancartes extérieures.

---


# Kin City v30.0.7 — parcours de quartier et contournement des objets

**Installateur univers complet :** `KinCity_Installation_Univers_Complet_v30.0.7.luau` (ville + huit institutions, une seule Place). Voir [`NOTICE_V30.0.7.md`](NOTICE_V30.0.7.md). Conserve les PNJ visuels et l'éclairage 65 % de la v30.0.3.

---

# Kin City v30.0.3 — PNJ + éclairage intérieur à 65 %

**Installation recommandée :** `KinCity_Installation_Univers_Complet_v30.0.3.luau` (ville + huit institutions, une seule Place). **Notice :** [`NOTICE_V30.0.3.md`](NOTICE_V30.0.3.md). Historique v30 et antérieur ci-dessous.

---

# Kin City v30.0.0 — navigation et confort d'accès (cumulative v29)

**Pour installer : [`NOTICE_V30.md`](NOTICE_V30.md).** Ville : `KinCity_Installation_Directe_v30.luau` ; huit institutions séparées : `KinCity_Installation_Place_*_v30.luau` ; vue tout-en-un locale : `KinCity_Installation_Univers_Local_v30.luau`.

Nouveautés : recherche dans le menu et les destinations, distance restante suivant les chemins publics, guide bibliothèque respectant le masquage, manette/mobile, panorama et mesure locale 20 s interruptible. Voir [`LIVRAISON_V30.md`](LIVRAISON_V30.md). La régénération remplace les retouches manuelles de `KinCityGenerated`. Aucun téléport inter-Places non publiées n'est simulé.

---

## Historique v29

# Kin City v29.0.0 — confort, pavage et navigation (cumulatif v28.0.1)

**Commencer par [`NOTICE_V29.md`](NOTICE_V29.md).** Ville : `KinCity_Installation_Directe_v29.luau` ; 8 institutions : `KinCity_Installation_Place_*_v29.luau` ; tout-en-un local : `KinCity_Installation_Univers_Local_v29.luau`.

Voir [`LIVRAISON_V29.md`](LIVRAISON_V29.md) pour les changements, commandes et limites Studio. La régénération remplace `KinCityGenerated`. Les passages entre Places non publiées ne fonctionnent pas.

---

## Référence historique : contenu README v28.0.1

> Correctif v28.0.1 : sol superposé et arrivée dégagée. Voir `CORRECTIF_SOL_ARRIVEE_v28.0.1.md`.

# Kin City v28 — King Klown v7 et Le livre sans dernière page

Une passe de personnage et de visite, cumulative à partir de la v27 fournie. La ville extérieure et les huit grandes institutions conservent leurs scènes indépendantes. Couleurs #1E6864 et cristal opalin, mode WORLD_STUB.

## Choisir son installateur

- **Personnage seul** : `KingKlown_v7.luau`. Ajoute le costume, les gestes et l'aura sans reconstruire la ville.
- **Ville actualisée** : `KinCity_Installation_Directe_v28.luau`. Inclut King Klown et le guide vers la bibliothèque.
- **Bibliothèque séparée** : `KinCity_Installation_Place_library_v28.luau`. Permet de tester immédiatement le récit dans une autre Place Studio.
- **Parcours complet sans publication** : `KinCity_Installation_Univers_Local_v28.luau`. Secours de test tout-en-un avec toutes les institutions; ne réalise pas la séparation serveur.
- Les sept autres institutions conservent leur installateur dédié. Les anciens installateurs sont archivés.

Coller le script entier dans la barre Commande en mode Édition puis Play. L'installateur complet reconstruit le décor KinCityGenerated : garder une copie de la Place si elle contient des modifications manuelles.

## King Klown

Chevelure asymétrique en mèches courbes, veste aux volumes adoucis, cape courte articulée, clignements et inclinaison discrète de tête. Appuyer sur **G**, cliquer sur le stick droit de la manette (**R3**) ou toucher **Magie**, à l'arrêt au sol, sans outil équipé. Le geste dure environ 2,4 s; recharge 6 s. Les autres clients calculent le même geste à partir du timestamp serveur. Aucun dégât ni protection.

La version native fonctionne sans import. Le modèle original `assets/kingklown-v7/kingklown-hair-v7.obj` peut remplacer la chevelure après import et enregistrement avec `KingKlown_Enregistrer_Cheveux_v7.luau`. Aucun import ni rendu Roblox de ce mesh n'est présumé.

## La visite

Le bouton **PARCOURS BIBLIOTHÈQUE** affiche des repères locaux sur les chemins existants. À l'intérieur, ouvrir le livre du hall, découvrir trois fragments sur le mobilier existant, puis revenir au livre d'accueil pour conclure. Le guide mène ensuite à la sortie et à la place centrale.

Le récit est individuel et conservé pendant la session serveur, y compris après respawn. Il ne donne aucun crédit, score, certification ou résultat kOA. Quitter la session réinitialise le récit. Les repères sont indicatifs, sans pathfinding dynamique autour des objets ou joueurs.

## Publication et vérification

Les neuf PlaceIds restent à renseigner dans `config/place_ids.json`; choisir MULTI_PLACE dans `config/runtime.json`, reconstruire puis publier chaque Place. Tant que les IDs ne sont pas renseignés, les aperçus séparés ne permettent pas de franchir les portes vers d'autres Places.

```bash
python -m pip install -r requirements-dev.txt
python tools/validate_catalog.py
python tools/validate_spatial.py
python tools/validate_v28_journey.py
python tools/build_release.py
python -m unittest discover -s tests -q
python tools/check_luau_syntax.py
```

Voir `KinCity_Demarrage_v28.md` et `LIVRAISON_V28.md`. Cette version est vérifiée hors moteur; le rendu, les collisions, les animations et les passages publiés doivent encore être vérifiés dans Roblox.