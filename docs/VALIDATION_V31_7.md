# Validation v31.7 (hors Roblox Studio)

- `python tools/validate_catalog.py` : **OK** (8 bâtiments, 9 Places, 16 portes). 9 avertissements normaux de PlaceIds non publiés.
- `python tools/validate_spatial.py` : **OK**, zéro erreur.
- `python -m unittest tests.test_v31_7_sign_engine tests.test_v31_6_signage_hierarchy tests.test_koali_double_sided_signs_v31_2 tests.test_v31_5_lighting_signage tests.test_gallery_menu_v31_1 -q` : **30 tests réussis**.
- `python -m unittest discover -s tests -q` : **169 tests, 22 échecs et 3 erreurs**, issus principalement d'anciennes contraintes d'urbanisme v20–v30; `lupa` absent pour trois tests.
- `python tools/check_luau_syntax.py` : non exécuté, dépendance `tree_sitter` non installée.
- Vérification visuelle et multijoueur : **à effectuer dans Roblox Studio**. Ce rapport ne prétend pas avoir compilé les scripts dans Roblox.
- Le cadre PNG local est un asset à **téléverser**, non un asset Roblox utilisable sans ID.
