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

@implementation ChargedArrow {
	CCSprite *_sprite;
	Vec3D _dir;
	float _ct;
	
	long _id;
}

+(ChargedArrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	return [[ChargedArrow node] cons_pos:pos dir:dir];
}

-(ChargedArrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	[self setPosition:pos];
	[self setRotation:vec_ang_deg_lim180(dir, 0) + 180];
	_sprite = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_PARTICLES_SPRITESHEET]
									texrect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"mega_arrow.png"]
									   size:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"mega_arrow.png"].size
								anchorPoint:ccp(0.5, 0.5)
									  color:[CCColor whiteColor]
									 alphaX:CGRangeMake(0, 1)
									 alphaY:CGRangeMake(1, 1)];
	
	
	[self addChild:_sprite];
	[_sprite setScale:0.7];
	_dir = dir;
	vec_norm_m(&_dir);
	vec_scale_m(&_dir, 10);
	_ct = 100;
	_id = PlayerHitParams_idalloc();
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
