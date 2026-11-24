"""Build a private, deterministic source ZIP for the already imported test Place."""
import argparse
import io
import subprocess
import unittest
import zipfile
from pathlib import Path
from build_imported_test_installer import generate
from art_deco_scene_audit import audit
import json
import re
ROOT=Path(__file__).resolve().parents[1]
README='''KIN CITY / KOALI — ART DECO V3

UTILISER LA PLACE LOCALE QUI CONTIENT DEJA LES 121 IMPORTS.
Aucun nouvel import, aucun dossier à créer dans Studio.

1. Dézipper ce dossier où vous voulez.
2. Arrêter Play dans votre Place locale de test.
3. Ouvrir INSTALLER_KINCITY_ARTDECO_V3.luau avec un éditeur de texte.
4. Copier TOUT son contenu dans la barre de commande Studio et exécuter.
5. Attendre les contrôles : 8 façades, 18 pavillons, 48 salles.
6. Lancer Play ; essayer les portes aller/retour, les ascenseurs et MUSIQUE.

Le script contient tout le code : il ne lit pas votre disque et ne télécharge
rien depuis GitHub. Les 121 modèles déjà présents dans la Place servent de sources.
Le script retrouve aussi les imports archivés par l'installation précédente.
Il conserve les originaux hors de la scène et reconstruit les objets Kin City.
Il exige une Place locale avec streaming activé et refuse toute Place publiée.
Aucune publication de Place ni nouvel upload d'asset.

CONTENU
- INSTALLER_KINCITY_ARTDECO_V3.luau : seul fichier à exécuter dans Studio.
- source/Kin-City : dépôt complet refactorisé, manifeste, tests, outils et documents.
- TESTS.txt : résultat des tests hors Studio de cette livraison.
- VERSION.txt : révision locale et origine du travail.

L'architecture des huit intérieurs séparés vient du snapshot initial. Les portes,
origines et parcours restent en place. Les éléments du pack habillent la ville
et les espaces intérieurs dans leurs contextes, avec les six couleurs de secteur.
Les modèles commerciaux ne sont pas redistribués dans ce ZIP : ils sont déjà dans
votre Place et soumis à la licence du pack acheté.

Le rendu, les parcours, le son effectif et les performances mobiles de CETTE version
restent à vérifier dans Roblox Studio. Aucun test Studio de cette livraison n'est
présenté comme déjà exécuté par l'auteur.
'''
def package(output,root=ROOT):
    import tempfile
    with tempfile.TemporaryDirectory(dir=output.parent) as temp:
        installer=generate(Path(temp)/'INSTALLER_KINCITY_ARTDECO_V3.luau',root)
        (root/'build/art-deco-zone-audit.json').write_text(json.dumps(audit(root),indent=2)+'\n')
        stream=io.StringIO()
        suite=unittest.defaultTestLoader.discover(str(root/'tests'))
        result=unittest.TextTestRunner(stream=stream,verbosity=1).run(suite)
        if not result.wasSuccessful():raise RuntimeError(stream.getvalue())
        version=subprocess.check_output(['git','-C',str(root),'rev-parse','HEAD'],text=True).strip()
        content={'LIRE_EN_PREMIER.txt':README.encode(),installer.name:installer.read_bytes(),
                 'TESTS.txt':re.sub(r'Ran (\d+) tests in [0-9.]+s',r'Ran \1 tests (duration omitted)',stream.getvalue()).encode(),
                 'VERSION.txt':('Branche locale : refactor/art-deco-contextual\nCommit local : '+version+
                     '\nBase : snapshot utilisateur ; HEAD GitHub distant non verifie.\nProduction non modifiee.\n').encode()}
        for path in sorted(root.rglob('*')):
            relative=path.relative_to(root)
            if not path.is_file() or any(part in {'.git','__pycache__','.pytest_cache'} for part in relative.parts):continue
            if path.suffix in {'.pyc','.glb','.gltf','.rbxm','.rbxl'}:continue
            content['source/Kin-City/'+relative.as_posix()]=path.read_bytes()
        with zipfile.ZipFile(output,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as archive:
            for name,body in sorted(content.items()):
                info=zipfile.ZipInfo('KinCity_ArtDeco_V3/'+name,date_time=(2026,10,25,0,0,0))
                info.compress_type=zipfile.ZIP_DEFLATED
                info.external_attr=0o100644<<16
                archive.writestr(info,body)
    return output
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('output',type=Path)
    print(package(parser.parse_args().output.resolve()))
