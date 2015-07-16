//
//  ChargedArrow.m
//  hanokam
//
//  Created by spotco on 08/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ChargedArrow.h"
#import "GameEngineScene.h"
#import "Resource.h"
#import "AirEnemyManager.h"
#import "RotateFadeOutParticle.h"
#import "AlphaGradientSprite.h"
#import "SPCCSpriteAnimator.h"
#import "RotateFadeOutParticle.h"
#import "SPCCTimedSpriteAnimator.h"
#import "FlashEvery.h"

@implementation ChargedArrow {
	CCSprite *_sprite;
	Vec3D _dir;
	float _ct;
	
	long _id;
	FlashEvery *_trail_spawn_ct;
}

+(ChargedArrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	return [[ChargedArrow node] cons_pos:pos dir:dir];
}

-(ChargedArrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	[self setPosition:pos];
	[self setRotation:vec_ang_deg_lim180(dir, 0)+180];
	_sprite = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:CGRectZero];
	SPCCSpriteAnimator *animator = [SPCCSpriteAnimator cons_target:_sprite speed:3];
	[animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"arrow_charge_shot_000.png"]];
	[animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"arrow_charge_shot_001.png"]];
	[animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"arrow_charge_shot_002.png"]];
	[animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"arrow_charge_shot_003.png"]];
	[_sprite addChild:animator];
	[_sprite setScale:0.3];
	[self addChild:_sprite];
	
	_dir = dir;
	vec_norm_m(&_dir);
	vec_scale_m(&_dir, 10);
	_ct = 100;
	_id = PlayerHitParams_idalloc();
	
	_trail_spawn_ct = [FlashEvery cons_time:2.2];
	
	return self;
}

-(void)i_update:(id)g {
	if ([[g class] isSubclassOfClass:[GameEngineScene class]]) {
		GameEngineScene *game = (GameEngineScene*)g;
		for (BaseAirEnemy *itr in game.get_air_enemy_manager.get_enemies) {
			if (itr.is_alive && SAT_polyowners_intersect(self, itr)) {
				PlayerHitParams hit_params;
				PlayerHitParams_init(&hit_params, PlayerHitType_ChargedProjectile, vec_norm(_dir));
				hit_params._id = _id;
				hit_params._pushback_force = 0.5;
				[itr hit:g params:&hit_params];
				
				[g shake_for:5 distance:2];
				
				[BaseAirEnemy particle_blood_effect:game pos:itr.position ct:3];
			}
		}
		
		[_trail_spawn_ct i_update:dt_scale_get()];
		if ([_trail_spawn_ct do_flash]) {
			RotateFadeOutParticle *neu_particle = [RotateFadeOutParticle cons_tex:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:CGRectZero];
			[neu_particle set_scale_min:1.0 max:0.0];
			[neu_particle set_ctmax:15];
			[neu_particle set_alpha_start:0.8 end:0.0];
			[neu_particle set_pos:self.position];
			[neu_particle set_rotation:self.rotation];
			SPCCTimedSpriteAnimator *neu_particle_animator = [SPCCTimedSpriteAnimator cons_target:neu_particle];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"Arrow-_fire-trail-1.png"] at_time:0.0];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"Arrow-_fire-trail-2.png"] at_time:0.2];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"Arrow-_fire-trail-3.png"] at_time:0.4];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"Arrow-_fire-trail-4.png"] at_time:0.6];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"Arrow-_fire-trail-5.png"] at_time:0.7];
			[neu_particle set_timed_sprite_animator:neu_particle_animator];
			[game add_particle:neu_particle];
		}
	}

	[self setPosition:CGPointAdd(self.position, ccp(_dir.x*dt_scale_get(),_dir.y*dt_scale_get()))];
	_ct -= dt_scale_get();
	if (self.position.x < -50 || self.position.x > game_screen().width + 50) {
		_ct = 0;
	}
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerProjectiles;
}

-(BOOL)should_remove {
	return _ct <= 0;
}

-(HitRect)get_hit_rect {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"mega_arrow.png"];
	return satpolyowner_cons_hit_rect(self.position, rect.size.width, rect.size.height,_sprite.scale);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	CGRect rect = [FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"mega_arrow.png"];
	return satpolyowner_cons_sat_poly(in_poly, self.position, self.rotation, rect.size.width-30, rect.size.height-40, ccp(1,1),_sprite.scale);
}

@end
