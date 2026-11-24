# Outil d'audit du plan KC35

L'outil indépendant **ne modifie aucune Place et aucun asset**. Il calcule seulement les intersections entre les 8 enveloppes institutionnelles et les bandes d'avenues actuelles, à partir de `build/world-plan.json`.

```powershell
py -m pip install shapely
py .\audit_voirie.py "C:\mycode\Kin_City\KinCityV35\KC35_SOURCE\KinCity_ArtDeco_V3\source\Kin-City\build\world-plan.json" --json .\audit_latest.json
```

Le chemin ci-dessus est **un exemple** : le ZIP téléchargé peut être extrait ailleurs. Le script renvoie le **code de sortie 1 en présence de collisions** (comportement intentionnel pour CI). Les six intersections du rapport sont des **contrôles 2D**, pas des collisions Roblox prouvées.
