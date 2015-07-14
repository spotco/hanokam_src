//
//  EnemyBulletProjectile.m
//  hanokam
//
//  Created by spotco on 25/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyBulletProjectile.h"
#import "GameEngineScene.h"
#import "PolyLib.h"
#import "Common.h"
#import "Player.h"
#import "GameUI.h"
#import "AirEnemyManager.h"
#import "GEventDispatcher.h"
#import "BasePlayerStateStack.h"
#import "RotateFadeOutParticle.h"
#import "PlayerProjectile.h"

@implementation EnemyBulletProjectile {
	Vec3D _vel;
	CCSprite *_img;
	
	BOOL _active;
}

+(EnemyBulletProjectile*)cons_pos:(CGPoint)pos vel:(Vec3D)vel g:(GameEngineScene *)g {
	return [[EnemyBulletProjectile node] cons_pos:pos vel:vel g:g];
}

-(EnemyBulletProjectile*)cons_pos:(CGPoint)pos vel:(Vec3D)vel g:(GameEngineScene*)g {
	_img = [CCSprite node];
	[_img runAction:animaction_cons(@[@"enemy_bullet_normal_000.png",@"enemy_bullet_normal_001.png",@"enemy_bullet_normal_002.png",@"enemy_bullet_normal_003.png"], 0.075, TEX_EFFECTS_ENEMY)];
	[self addChild:_img];
	[_img setScale:0.25];
	
	_img.rotation = vec_ang_deg_lim180(vel, 0)-90;
	
	_vel = vel;
	[self setPosition:pos];
	_active = YES;
	
	return self;
}

-(void)i_update:(id)ig {
	GameEngineScene *g = (GameEngineScene*)ig;
	
	[self setPosition:CGPointAdd(self.position, ccp(_vel.x*dt_scale_get(),_vel.y*dt_scale_get()))];
	
	PlayerAirCombatParams *air_params = g.player.get_top_state.cond_get_inair_combat_params;
	if (air_params._current_mode == PlayerAirCombatMode_Combat && _active && SAT_polyowners_intersect(self, g.player)) {
		if (!air_params._sword_out && !air_params._dashing && [air_params is_hittable]) {
			[g.get_event_dispatcher push_event:[GEvent cons_context:g type:GEventType_BulletHitPlayer]];
		} else {
			[g.get_event_dispatcher push_event:[[GEvent cons_context:g type:GEventType_PlayerHitEnemyDash] set_target:self]];
		}
		[self hit_effect:g];
		_active = NO;
	}
	
	for (PlayerProjectile *itr in g.get_player_projectiles) {
		if (SAT_polyowners_intersect(self, itr)) {
			_active = NO;
			[self hit_effect:g];
			break;
		}
	}
	
	if (!hitrect_contains_point([g get_viewbox],self.position)) {
		_active = NO;
	}
}

-(void)hit_effect:(GameEngineScene*)g {
	RotateFadeOutParticle *particle = [RotateFadeOutParticle cons_tex:[Resource get_tex:TEX_PARTICLES_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"grey_particle"]];
	[particle set_pos:self.position];
	[particle set_ctmax:15];
	[particle set_render_ord:GameAnchorZ_PlayerAirEffects];
	[particle set_scale_min:2 max:3];
	[particle set_alpha_start:1.0 end:0.0];
	[g add_particle:particle];
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerProjectiles;
}

-(BOOL)should_remove {
	return !_active;
}

-(HitRect)get_hit_rect {
	CGRect rect = scale_rect([FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy_bullet_normal_000.png"],_img.scale);
	return satpolyowner_cons_hit_rect(self.position, rect.size.width, rect.size.height,1.5);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	CGRect rect = scale_rect([FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy_bullet_normal_000.png"],_img.scale);
	return satpolyowner_cons_sat_poly(in_poly, self.position, 0, rect.size.width, rect.size.height, ccp(1,1),0.85);
}


@end
