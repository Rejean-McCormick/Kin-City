"""Safety checks: renamed audio catalogue + 48 real IDs + complete city source."""
import csv
import json
import re
import unittest
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


class MusicRepositoryV3195(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.inv=json.loads((ROOT/'catalog/music_inventory_current.json').read_text(encoding='utf-8'))
        cls.ids=(ROOT/'src/shared/MusicAssetIds.luau').read_text(encoding='utf-8')
        cls.library=(ROOT/'src/shared/MusicLibrary.luau').read_text(encoding='utf-8')
        cls.installer=(ROOT/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau').read_text(encoding='utf-8')
        cls.entries=dict((k,int(n)) for k,n in re.findall(r'\["(kin_track_[a-f0-9]+)"\]\s*=\s*(\d+)', cls.ids))

    def test_four_albums_49_tracks(self):
        self.assertEqual([len(a['tracks']) for a in self.inv['albums']], [11,14,12,12])
        self.assertEqual(len(self.entries),49)

    def test_asset_ids_and_missing_track(self):
        imported=[n for n in self.entries.values() if n>0]
        self.assertEqual(len(imported),48)
        self.assertEqual(len(set(imported)),48)
        missing=[t for a in self.inv['albums'] for t in a['tracks'] if self.entries[t['id']]==0]
        self.assertEqual([(t['title'],round(t['duration_seconds'])) for t in missing],[('Univers-City',439)])

    def test_new_track_ids_in_library(self):
        for a in self.inv['albums']:
            self.assertIn(a['title'],self.library)
            self.assertIn(a['folder_rel'],self.library)
            for t in a['tracks']:
                self.assertIn(t['id'],self.library)
                self.assertIn(t['path_rel'],self.library)
                self.assertIn(t['title'],self.library)
                self.assertEqual(t['roblox_asset_id'] or 0,self.entries[t['id']])

    def test_csv_match(self):
        with (ROOT/'catalog/music_import_48_ids.csv').open(encoding='utf-8-sig', newline='') as f:
            rows=list(csv.DictReader(f,delimiter=';'))
        self.assertEqual(len(rows),49)
        self.assertEqual(sum(bool(row['roblox_asset_id']) for row in rows),48)
        for row in rows:
            self.assertEqual(int(row['roblox_asset_id'] or 0),self.entries[row['track_id']])

    def test_full_installer_embeds_latest_modules(self):
        self.assertIn('MusicLibrary',self.installer)
        self.assertIn('MusicAssetIds',self.installer)
        self.assertIn('KinCityMusicPlayer',self.installer)
        self.assertIn('OutdoorCinema',self.installer)
        self.assertIn('PlayerBuildClient',self.installer)
        self.assertIn('128763700452308',self.installer)
        self.assertIn('113300141047037',self.installer)
        self.assertIn('kin_track_62578cd34416',self.installer)
        self.assertIn('KOALI v31.9.7',self.installer)

    def test_generator_uses_clean_wipe_without_old_asset_ids(self):
        script=(ROOT/'tools/make_universe_recovery_installer.py').read_text('utf-8')
        self.assertIn('wipe(workspace',script)
        self.assertNotIn('preservedMusicSource',script)
        self.assertNotIn('Source=preservedMusicSource end',script)

    def test_snapshot_and_project_included(self):
        for path in ('default.project.json','src/server/OutdoorCinema.luau',
                     'src/client/OutdoorCinemaClient.luau','src/client/PlayerBuildClient.luau',
                     'src/shared/SignTheme.luau','GUIDE_INSTALLATION.md'):
            self.assertTrue((ROOT/path).is_file(),path)

    def test_correctif_no_regeneration(self):
        s=(ROOT/'installer/KinCity_INSTALLATION_TOTALE_v31_9_7.luau').read_text('utf-8')
        self.assertIn('MusicAssetIds',s)
        self.assertIn('MusicLibrary',s)
        self.assertIn('WorldBuilder',s)


if __name__=='__main__': unittest.main()
