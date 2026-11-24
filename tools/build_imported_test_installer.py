"""Bundle the real imported-library adapter and city installer for a local test Place."""
import argparse
from pathlib import Path
from build_release import build
ROOT = Path(__file__).resolve().parents[1]

HEADER = '''-- KIN CITY : VRAIS IMPORTS ART DECO, PLACE LOCALE DE TEST UNIQUEMENT.
-- Reconnaissance automatique des 121 conteneurs AD_Assets importes.
-- Ne publie aucun asset ni aucune Place. Conserve les originaux dans ServerStorage.
assert(not game:GetService("RunService"):IsRunning(),"Arrete Play puis relance")
assert(game.PlaceId~=72097868581669,"La Place publiee est interdite")
assert(game.PlaceId==0,"Ouvre la Place locale de test qui contient tes 121 imports")
assert(workspace.StreamingEnabled,"Le streaming doit etre active dans Workspace avant installation")
workspace:SetAttribute("KinArtDecoTestPlace",true)
'''
CHECK = '''
do
    local library=assert(game:GetService("ServerStorage"):FindFirstChild("KinCityArtDecoLibrary"))
    assert(library:GetAttribute("KinSourceCount")==121,"Bibliotheque incomplete")
    local world=assert(workspace:FindFirstChild("KinCityGenerated"),"Ville non construite")
    local meshes=0
    for _,node in ipairs(world:GetDescendants()) do
        if node:IsA("MeshPart") then meshes+=1 end
    end
    assert(meshes>0,"ECHEC : aucun vrai mesh dans la ville")
    assert(world:GetAttribute("KinBranchRuntimeState")=="Ready", "KC35 : branche incomplète dans l'installateur")
    assert(world:GetAttribute("KinBranchReadyCount")==9, "KC35 : 9 contributions attendues")
    local blocked=false
    for _,p in ipairs(world:GetDescendants()) do
        if p:IsA("BasePart") and p:GetAttribute("KinDoorId")=="city.kreative.museum.entry" then
            blocked=p:GetAttribute("KinMuseumDoorBlocked")==true
            for _,ch in ipairs(p:GetChildren()) do
                if ch:IsA("ProximityPrompt") then assert(not ch.Enabled, "KC35 : musée doit rester fermé") end
            end
            break
        end
    end
    assert(blocked,"KC35 : verrou musée absent")
    assert(workspace:FindFirstChild("KinCityOutdoorCinema"),"KC35 : écran broadcast manquant")
    print("KIN CITY : 121 sources reconnues ; "..meshes.." vrais MeshParts places dans la ville.")
end
'''

def generate(output, root=ROOT):
    build(root)
    parts = [HEADER]
    for source in ['studio/PrepareArtDecoLibrary.luau',
                   'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau']:
        parts.append('\ndo\n' + (root/source).read_text() + '\nend\n')
    parts.append(CHECK)
    parts.append('\ndo\n' + (root/'studio/RunArtDecoChecks.luau').read_text() + '\nend\n')
    parts.append('print("KIN CITY : installation et controles termines. Lance Play pour verifier la ville et MUSIQUE.")\n')
    output.write_text(''.join(parts))
    return output

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('output', type=Path)
    print(generate(parser.parse_args().output))
