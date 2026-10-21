# Livraison v30.0.3

Base : `KinCity_Source_Construction_v30.0.2.zip`. Correctifs localisés à `src/server/{Citizens,NativeR15Citizens,ResidentialResidents,CitizenPropsV21,InteriorLightingV30,WorldBuilder,WorldEditor}.luau`, aux outils de génération (identité v30.0.3), tests et notice.

Installateur principal : `KinCity_Installation_Univers_Complet_v30.0.3.luau`, généré par `python tools/make_universe_recovery_installer.py`. Le générateur de secours v27 fourni par le propriétaire reste inclus. Une copie de la Place est conseillée avant remplacement de `KinCityGenerated`.

Le mouvement des 36 PNJ primitifs est encore procédural (sans rig humanoïde, ni navigation dynamique complexe). Les R15 et leurs animations s'appuient sur les mécanismes Roblox existants, avec budget de proximité v21. Ces améliorations ne constituent pas des mesures de FPS. Les matériaux très blancs ou émissifs peuvent rester visuellement éclatants malgré la réduction des lumières artificielles. Voir `NOTICE_V30.0.3.md` pour tester dans Studio.
