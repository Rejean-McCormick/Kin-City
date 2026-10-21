"""Contrats statiques et numériques hors moteur, pas des preuves de rendu Roblox."""
import math
import re
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
SERVER=ROOT/'src/server'

class NPCAndLightingV3003(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.procedural=(SERVER/'Citizens.luau').read_text(encoding='utf8')
        cls.native=(SERVER/'NativeR15Citizens.luau').read_text(encoding='utf8')
        cls.residents=(SERVER/'ResidentialResidents.luau').read_text(encoding='utf8')
        cls.props=(SERVER/'CitizenPropsV21.luau').read_text(encoding='utf8')
        cls.light=(SERVER/'InteriorLightingV30.luau').read_text(encoding='utf8')
        cls.builder=(SERVER/'WorldBuilder.luau').read_text(encoding='utf8')

    def test_citizens_no_longer_use_center_orbits(self):
        self.assertNotIn('local function orbit(index)',self.procedural)
        self.assertIn('Nav.quarter(i)',self.procedural)
        self.assertIn('Nav.plan(quarter,',self.procedural)
        self.assertIn('Nav.blockedAhead(',self.procedural)
        self.assertIn('face(nextPosition,direction)',self.procedural)
        self.assertNotIn('TweenService:Create',self.procedural)

    def test_procedural_walk_keeps_shoes_and_limbs_in_sync(self):
        for item in ['Bras gauche','Bras droit','Jambe gauche','Jambe droite',
                     'Manche gauche','Manche droite','Chaussure gauche','Chaussure droite',
                     'model:PivotTo(frame)','animate(model,frame,phase,true)',
                     'Presence.near','pauseUntil']:
            self.assertIn(item,self.procedural)
        self.assertIn('hip*CFrame.new(0,-2.10,-0.15)',self.procedural)
        self.assertIn('math.clamp(now-last,0,0.15)',self.procedural)

    def test_slightly_higher_r15_share_with_staggered_creation(self):
        self.assertIn('for i=1,14 do',self.native)
        self.assertIn('Nav.quarter(index)',self.native)
        self.assertIn('task.wait(0.35)',self.native)

    def test_humanoids_autorotate_and_use_shared_pathfinding(self):
        for src,var in [(self.native,'humanoid'),(self.residents,'hum')]:
            self.assertIn(var+'.AutoRotate=true',src)
            self.assertIn('Nav.walkHumanoid(',src)
            self.assertIn('if not reached then',src)
            self.assertIn('"KinNPCMotion","idle"',src)
            self.assertIn('CollectionService:AddTag(model,"KinCityAnimatedNPC")',src)

    def test_visuals_stay_native_and_do_not_change_npc_ids(self):
        for text in ['Coiffure sculptée','Col opalin','Chaussure de ville','WeldConstraint',
                     'Massless=true','CanCollide=false','Color3.fromRGB(30,104,100)']:
            self.assertIn(text,self.props)
        self.assertNotIn('rbxassetid://',self.props)
        self.assertNotIn('InsertService',self.props)
        self.assertIn('"citizen.%03d.dialogue"',self.procedural)
        self.assertIn('"city.r15.%02d.dialogue"',self.native)
        self.assertIn('"kin.resident.%02d.future"',self.residents)

    def test_interior_lights_at_65_percent_not_world_lighting(self):
        factor=float(re.search(r'local FACTOR=([0-9.]+)',self.light).group(1))
        self.assertEqual(factor,.65)
        self.assertAlmostEqual(1.7*factor,1.105)
        self.assertAlmostEqual(1.1*factor,.715)
        for typ in ('PointLight','SpotLight','SurfaceLight'):
            self.assertIn(f'IsA("{typ}")',self.light)
        self.assertIn('item.Brightness=original*FACTOR',self.light)
        self.assertIn('"KinInteriorOriginalBrightness"',self.light)
        self.assertNotIn('game:GetService("Lighting")',self.light)
        self.assertNotIn('workspace.Lighting',self.light)

    def test_lighting_runs_after_fallback_and_remains_reusable(self):
        code=self.builder
        self.assertIn('local InteriorLighting=require(script.Parent.InteriorLightingV30)',code)
        self.assertLess(code.index('legacy.make(inside,place,style)'),code.index('InteriorLighting.apply(model)'))
        self.assertLess(code.index('InteriorGenerator.make(inside,place,style)'),code.index('InteriorLighting.apply(model)'))
        self.assertIn('KinInteriorLightingFactor',self.light)
        self.assertIn('typeof(original)~="number"',self.light)
        editor=(SERVER/'WorldEditor.luau').read_text(encoding='utf8')
        self.assertIn('InteriorLighting.apply(model)',editor)

if __name__=='__main__': unittest.main()
