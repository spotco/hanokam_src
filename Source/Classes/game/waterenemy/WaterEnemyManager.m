#import "WaterEnemyManager.h"
#import "GameEngineScene.h"
#import "PufferBasicWaterEnemy.h"
#import "RotateFadeOutParticle.h"

@implementation BaseWaterEnemy
-(void)i_update:(GameEngineScene*)game{}
-(BOOL)should_remove{return NO;}
-(void)do_remove:(GameEngineScene*)g{}
-(HitRect)get_hit_rect{ return hitrect_cons_xy_widhei(0, 0, 0, 0); }
-(void)get_sat_poly:(SATPoly *)in_poly { }

+(void)particle_blood_effect:(GameEngineScene *)g pos:(CGPoint)pos ct:(int)ct {
	DO_FOR(ct,
		RotateFadeOutParticle *particle = [RotateFadeOutParticle cons_tex:[Resource get_tex:TEX_GAMEPLAY_ELEMENTS] rect:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_blood.png"]];
		[particle set_pos:CGPointAdd(pos, ccp(float_random(-10, 10),float_random(-10, 10)))];
		[particle set_ctmax:20];
		[particle set_render_ord:GameAnchorZ_PlayerAirEffects];
		float scale = float_random(0.2, 0.3);
		[particle set_scale_min:scale max:scale];
		[particle set_alpha_start:0.6 end:0.0];
		[particle set_vr:float_random(-30, 30)];
		[particle set_vel:ccp(float_random(-1, 1),float_random(-1, 1))];
		[particle set_gravity:-0.025];
		[g add_particle:particle];
	);
}

@end

@implementation WaterEnemyManager {
	NSMutableArray *_enemies;
}

+(WaterEnemyManager*)cons:(GameEngineScene*)g {
	return [[[WaterEnemyManager alloc] init] cons:g];
}
-(WaterEnemyManager*)cons:(GameEngineScene*)g {
	_enemies = [NSMutableArray array];
	[g.get_event_dispatcher add_listener:self];
	return self;
}

-(void)dispatch_event:(GEvent *)e {
	switch (e.type) {
	case GEventType_ModeDiveStart: {
		__last_viewbox_y = 0;
		__dist_to_next_spawn = 0;
	} break;
	default: break;
	}
}

static float __last_viewbox_y;
static float __dist_to_next_spawn;
-(void)test_spawn_enemies:(GameEngineScene*)g {
	float viewbox_min = g.get_viewbox.y1;
	if (viewbox_min > -500) return;
	
	__dist_to_next_spawn += (viewbox_min-__last_viewbox_y);
	if (__dist_to_next_spawn <= 0) {
		
		DO_FOR(int_random(1, 4),
			float spawn_y = viewbox_min - 300 + float_random(-40, 40);
			[g.get_water_enemy_manager add_enemy:[PufferBasicWaterEnemy cons_g:g pt1:ccp(game_screen().width*0,spawn_y) pt2:ccp(game_screen().width*1.0,spawn_y)] game:g];
		);
		
		__dist_to_next_spawn = float_random(60, 200);
	}
	
	__last_viewbox_y = viewbox_min;
}

static NSMutableArray *do_remove;
-(void)i_update:(GameEngineScene*)g {
	if (do_remove == NULL) do_remove = [NSMutableArray array];
	
	if ([g get_player_state] == PlayerState_Dive) [self test_spawn_enemies:g];
	
	for (long i = _enemies.count-1; i >= 0; i--) {
		BaseWaterEnemy *itr = [_enemies objectAtIndex:i];
		[itr i_update:g];
		if ([itr should_remove]) {
			[itr do_remove:g];
			[[g get_anchor] removeChild:itr];
			[do_remove addObject:itr];
		}
	}
	[_enemies removeObjectsInArray:do_remove];
	[do_remove removeAllObjects];
}

-(NSArray*)get_enemies {
	return _enemies;
}

-(void)add_enemy:(BaseWaterEnemy*)enemy game:(GameEngineScene*)g {
	[[g get_anchor] addChild:enemy z:GameAnchorZ_Enemies_Air];
	[_enemies addObject:enemy];
}

-(void)remove_all_enemies:(GameEngineScene*)g {
	for (BaseWaterEnemy *itr in _enemies) {
		[itr do_remove:g];
		[[g get_anchor] removeChild:itr];
	}
	[_enemies removeAllObjects];
}

@end
