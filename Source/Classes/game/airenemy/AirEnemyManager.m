//
//  AirEnemyManager.m
//  hobobob
//
//  Created by spotco on 27/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AirEnemyManager.h"
#import "GameEngineScene.h"
#import "Resource.h"
#import "FileCache.h"
#import "PufferBasicAirEnemy.h"
#import "RotateFadeOutParticle.h" 

static long _playerhitparams_alloct = 1;

void PlayerHitParams_init(PlayerHitParams *params, PlayerHitType type, Vec3D dir) {
	params->_dir = dir;
	params->_pushback_force = 1;
	params->_type = type;
	params->_id = PlayerHitParams_idalloc();
}
long PlayerHitParams_idalloc() {
	return _playerhitparams_alloct++;
}

@implementation BaseAirEnemy
-(void)i_update:(GameEngineScene*)game{
	[self setZOrder:self.position.y<0?GameAnchorZ_Enemies_Underwater:GameAnchorZ_Enemies_Air];
}
-(BOOL)should_remove{ return YES; }
-(void)do_remove:(GameEngineScene *)g{ }
-(HitRect)get_hit_rect{ return hitrect_cons_xy_widhei(self.position.x, self.position.y, 0, 0); }
-(void)get_sat_poly:(SATPoly *)in_poly { }
-(void)hit:(GameEngineScene*)g params:(PlayerHitParams*)params{}
-(BOOL)is_alive{ return YES; }
-(BOOL)is_stunned { return NO; }
-(BOOL)arrow_will_stick{ return YES; }
-(BOOL)arrow_drop_all{ return NO; }

-(CGPoint)get_healthbar_offset { return CGPointZero; }
-(float)get_health_pct { return 0.5; }
-(BOOL)should_show_health_bar { return YES; }

+(void)particle_blood_effect:(GameEngineScene *)g pos:(CGPoint)pos ct:(int)ct {
	DO_FOR(ct,
		RotateFadeOutParticle *particle = [RotateFadeOutParticle cons_tex:[Resource get_tex:TEX_GAMEPLAY_ELEMENTS] rect:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_blood.png"]];
		[particle set_pos:CGPointAdd(pos, ccp(float_random(-10, 10),float_random(-10, 10)))];
		[particle set_ctmax:15];
		[particle set_render_ord:GameAnchorZ_PlayerAirEffects];
		float scale = float_random(0.2, 0.3);
		[particle set_scale_min:scale max:scale];
		[particle set_alpha_start:0.6 end:0.0];
		[particle set_vr:float_random(-30, 30)];
		[particle set_vel:ccp(float_random(-3, 3),float_random(-3, 3))];
		[particle set_gravity:0.5];
		[g add_particle:particle];
	);
}
@end

@implementation BaseAirEnemyFutureSpawn {
	float _time, _time_max;
	CGPoint _screen;
	BaseAirEnemy *_enemy;
}
+(BaseAirEnemyFutureSpawn*)cons_time:(float)time screen:(CGPoint)screen enemy:(BaseAirEnemy*)enemy {
	return [[[BaseAirEnemyFutureSpawn alloc] init] cons_time:time screen:screen enemy:enemy];
}
-(BaseAirEnemyFutureSpawn*)cons_time:(float)time screen:(CGPoint)screen enemy:(BaseAirEnemy*)enemy {
	_time = _time_max = time;
	_enemy = enemy;
	_screen = screen;
	return self;
}
-(void)i_update:(GameEngineScene*)g {
	_time -= dt_scale_get();
}
-(BOOL)should_remove {
	return _time <= 0;
}
-(void)do_remove:(GameEngineScene*)g {
	[g.get_air_enemy_manager add_enemy:_enemy game:g];
}
-(float)get_ct {
	return _time;
}
-(float)get_ctmax {
	return _time_max;
}
-(CGPoint)get_screen_pos {
	return _screen;
}
@end

@implementation AirEnemyManager {
	NSMutableArray *_enemies;
	NSMutableArray *_enemies_future_spawns;
}
+(AirEnemyManager*)cons:(GameEngineScene*)g {
	return [[[AirEnemyManager alloc] init] cons:g];
}
-(AirEnemyManager*)cons:(GameEngineScene*)game {
	_enemies = [NSMutableArray array];
	_enemies_future_spawns = [NSMutableArray array];
	return self;
}

-(void)test_spawn_enemies:(GameEngineScene*)game {
	if ([game get_player_state] == PlayerState_InAir) {
		if ( (_enemies.count == 0 && _enemies_future_spawns.count == 0) || float_random(0, 50) < 1) {
			CGPoint start_pos = game_screen_pct(float_random(0.15, 0.85), 0);
			start_pos.y -= 50;
			
			CGPoint end_pos;
			if (float_random(0, 2) < 1) {
				end_pos = game_screen_pct(0, float_random(0.15, 0.85));
				end_pos.x -= 50;
			} else {
				end_pos = game_screen_pct(1, float_random(0.15, 0.85));
				end_pos.x += 50;
			}
			
			[self add_enemy_future_spawn:[BaseAirEnemyFutureSpawn cons_time:50 screen:ccp(start_pos.x,20) enemy:[PufferBasicAirEnemy cons_g:game relstart:start_pos relend:end_pos]]];
		}
	}
}

static NSMutableArray *do_remove;

-(void)i_update:(GameEngineScene*)game {
	[self test_spawn_enemies:game];
	
	if (do_remove == NULL) do_remove = [NSMutableArray array];
	for (long i = _enemies_future_spawns.count-1; i >= 0; i--) {
		BaseAirEnemyFutureSpawn *itr = [_enemies_future_spawns objectAtIndex:i];
		[itr i_update:game];
		if ([itr should_remove]) {
			[itr do_remove:game];
			[do_remove addObject:itr];
		}
	}
	[_enemies_future_spawns removeObjectsInArray:do_remove];
	[do_remove removeAllObjects];
	
	for (long i = _enemies.count-1; i >= 0; i--) {
		BaseAirEnemy *itr = [_enemies objectAtIndex:i];
		[itr i_update:game];
		if ([itr should_remove]) {
			[itr do_remove:game];
			[[game get_anchor] removeChild:itr];
			[do_remove addObject:itr];
		}
	}
	[_enemies removeObjectsInArray:do_remove];
	[do_remove removeAllObjects];
}
-(void)add_enemy_future_spawn:(BaseAirEnemyFutureSpawn*)spawn {
	[_enemies_future_spawns addObject:spawn];
}
-(NSArray*)get_enemies_future_spawn { return _enemies_future_spawns; }

-(void)add_enemy:(BaseAirEnemy*)enemy game:(GameEngineScene*)game {
	[[game get_anchor] addChild:enemy z:GameAnchorZ_Enemies_Air];
	[_enemies addObject:enemy];
}

-(NSArray*)get_enemies {
	return _enemies;
}
-(void)remove_all_enemies:(GameEngineScene*)g {
	for (BaseAirEnemy *itr in _enemies) {
		[itr do_remove:g];
		[[g get_anchor] removeChild:itr];
	}
	[_enemies removeAllObjects];
}
@end
