"""Tests offline: plan->Luau, compatibilité des catalogues et barrières de configuration.
Ne vérifie PAS Roblox Studio, la physique ou le client Roblox publié.
"""
import json
import tempfile
import unittest
import shutil
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from export_roblox import export
from compile_plan import compile_plan

class TestRuntimeGeneration(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan=compile_plan(ROOT)
        cls.buildings=json.loads((ROOT/'catalog/buildings.json').read_text(encoding='utf8'))['buildings']

    def test_all_doors_reversible_and_resolved(self):
        doors={d['door_id']:d for d in self.plan['doors']}
        places={p['place_key']:p for p in self.plan['places']}
        for door in doors.values():
            back=doors[door['return_door_id']]
            self.assertEqual(back['return_door_id'],door['door_id'])
            self.assertEqual(back['source_place_key'],door['destination_place_key'])
            self.assertIn(door['destination_anchor_id'],{a['anchor_id'] for a in places[door['destination_place_key']]['anchors']})
            self.assertIn(door['source_anchor_id'],{a['anchor_id'] for a in places[door['source_place_key']]['anchors']})

    def test_all_interactions_have_real_furniture(self):
        places={p['place_key']:p for p in self.plan['places']}
        for interaction in self.plan['interactions']:
            place=places[interaction['place_key']]
            matching=[f for f in place['furnishings'] if f.get('anchor_id')==interaction['anchor_id']]
            self.assertEqual(len(matching),1,interaction['interaction_id'])
            self.assertEqual(interaction['provider_mode'],'stub')

    def test_all_interiors_have_connected_layout_and_threshold(self):
        from collections import defaultdict,deque
        places={p['place_key']:p for p in self.plan['places']}
        for key,p in places.items():
            if key=='city': continue
            nodes={r['room_id'] for r in p['rooms']}
            graph=defaultdict(list)
            for portal in p['portals']:
                graph[portal['from_room']].append(portal['to_room'])
                graph[portal['to_room']].append(portal['from_room'])
                self.assertGreaterEqual(portal['clear_width_studs'],8)
            start=next(a['room_id'] for a in p['anchors'] if a['role']=='spawn')
            q=deque([start]);seen={start}
            while q:
                for dst in graph[q.popleft()]:
                    if dst not in seen:seen.add(dst);q.append(dst)
            self.assertEqual(nodes,seen,key)
        interior_src=(ROOT/'src/server/InteriorGenerator.luau').read_text(encoding='utf8')
        self.assertIn('PortalThreshold',interior_src)

    def test_export_deterministic_and_contains_real_plan(self):
        export(ROOT)
        first=(ROOT/'src/shared/WorldPlan.luau').read_bytes()
        export(ROOT)
        self.assertEqual(first,(ROOT/'src/shared/WorldPlan.luau').read_bytes())
        self.assertIn(self.plan['canonical_sha256'].encode(),first)

    def test_multi_place_requires_public_ids(self):
        with tempfile.TemporaryDirectory() as temp:
            tmp=Path(temp)
            for d in ('catalog','schemas','config','tools'):
                shutil.copytree(ROOT/d,tmp/d)
            cfg=json.loads((tmp/'config/runtime.json').read_text(encoding='utf8'))
            cfg['mode']='MULTI_PLACE'
            (tmp/'config/runtime.json').write_text(json.dumps(cfg))
            with self.assertRaisesRegex(ValueError,'MULTI_PLACE exige'):
                export(tmp)

    def test_built_runtime_is_network_free(self):
        files=list((ROOT/'src/server').rglob('*.luau'))+list((ROOT/'src/client').rglob('*.luau'))
        text='\n'.join(f.read_text(encoding='utf8') for f in files)
        for forbidden in ('HttpService','DataStoreService','RequestAsync','GetAsync(','PostAsync(','api.openai.com'):
            self.assertNotIn(forbidden,text)
        self.assertIn('ProximityPromptService.PromptTriggered',text)
        self.assertIn('TeleportService:TeleportAsync',text)
        self.assertIn('CanCollide=false',text)

if __name__=='__main__': unittest.main()
