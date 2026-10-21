"""Contract checks for new story placements and guide references."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def validate(root=ROOT):
    errors=[]
    config=json.loads((root/'config/library_journey.json').read_text())
    spatial=json.loads((root/'catalog/spatial.json').read_text())
    library=next(p for p in spatial['places'] if p['place_key']=='library')
    rooms={x['room_id']:x for x in library['rooms']}
    furniture={x['furnishing_id']:x for x in library['furnishings']}
    assets={x['asset_id'] for x in json.loads((root/'catalog/assets.json').read_text())['assets']}
    if config['placement']['asset_id'] not in assets:errors.append('Missing story book asset')
    if {s['id'] for s in config['stations']}!={'welcome','memory','connection','imagination'}:errors.append('Invalid story stations')
    if len(config['stations'])!=4:errors.append('Duplicate station')
    for station in config['stations']:
        f=furniture.get(station['furnishing_id'])
        if not f:errors.append('Unknown furnishing '+station['furnishing_id']);continue
        room=rooms[f['room_id']]
        for axis in (0,2):
            half=config['placement']['size_studs'][axis]/2
            if abs(f['position_studs'][axis]-room['center_studs'][axis])+half>room['size_studs'][axis]/2:
                errors.append('Outside room envelope: '+station['id'])
        if room['size_studs'][1]<7.5:errors.append('Insufficient height for '+station['id'])
    doors={d['door_id']:d for d in json.loads((root/'catalog/doors.json').read_text())['doors']}
    for key,source,destination in [('entry_door_id','city','library'),('exit_door_id','library','city')]:
        d=doors.get(config[key])
        if not d or d['source_place_key']!=source or d['destination_place_key']!=destination:errors.append('Invalid '+key)
    return errors
if __name__=='__main__':
    errors=validate();print('Journey v28:',errors or 'OK — furniture, envelopes, doors, asset')
    raise SystemExit(bool(errors))
