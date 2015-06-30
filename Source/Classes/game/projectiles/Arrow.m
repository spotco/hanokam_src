#import "Arrow.h"
#import "GameEngineScene.h"
#import "Resource.h"
#import "AirEnemyManager.h"
#import "RotateFadeOutParticle.h"

typedef enum ArrowMode {
	ArrowMode_Flying,
	ArrowMode_Floating,
	ArrowMode_Stuck,
	ArrowMode_BounceOff,
	ArrowMode_Falling
} ArrowMode;

@implementation Arrow {
	CCSprite *_sprite;
	CCSprite *_trail;
	Vec3D _dir;
	float _ct;
	float _trail_tar_alpha;
	
	ArrowMode _current_mode;
	
	CGPoint _stuck_offset;
	CGPoint _falling_vel;
	BaseAirEnemy *_stuck_target;
}

+(Arrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	return [[Arrow node] cons_pos:pos dir:dir];
}

-(Arrow*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	_current_mode = ArrowMode_Flying;
	
	[self setPosition:pos];
	[self setRotation:vec_ang_deg_lim180(dir, 0) + 180];
	_sprite = [CCSprite spriteWithTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"arrow.png"]];
	[self addChild:_sprite];
	
	_trail = [CCSprite spriteWithTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"arrow_trail.png"]];
	[_trail setAnchorPoint:ccp(1,0.5)];
	[_trail setPosition:pct_of_obj(_sprite, 0, 0.5)];
	[_trail setOpacity:0];
	[_sprite addChild:_trail];
	
	[_sprite set_anchor_pt:ccp(0.5, 0.5)];
	[_sprite set_scale:0.2];
	_dir = dir;
	vec_norm_m(&_dir);
	vec_scale_m(&_dir, 10);
	_ct = 100;
	
	_trail_tar_alpha = 0;
	
	return self;
}

-(void)i_update:(id)g {
	switch (_current_mode) {
	case ArrowMode_Flying:;
		if ([[g class] isSubclassOfClass:[GameEngineScene class]]) {
			GameEngineScene *game = (GameEngineScene*)g;
			for (BaseAirEnemy *itr in game.get_air_enemy_manager.get_enemies) {
				if (itr.is_alive && SAT_polyowners_intersect(self, itr)) {
					PlayerHitParams hit_params;
					PlayerHitParams_init(&hit_params, PlayerHitType_Projectile, vec_norm(_dir));
					[itr hit:g params:&hit_params];
					
					[g shake_for:5 distance:2];
					
					DO_FOR(1, [self setPosition:CGPointAdd(self.position, ccp(_dir.x*0.5,_dir.y*0.5))];);
					
					_current_mode = ArrowMode_Stuck;
					_stuck_target = itr;
					_stuck_offset = CGPointSub(self.position,_stuck_target.position);
					_ct = 1;
					
					[BaseAirEnemy particle_blood_effect:game pos:self.position ct:3];
					
					return;
				}
			}
		}
	
		[self setPosition:CGPointAdd(self.position, ccp(_dir.x*dt_scale_get(),_dir.y*dt_scale_get()))];
		_ct -= dt_scale_get();
		if (_ct > 90) {
			_trail_tar_alpha = 0;
		} else {
			_trail_tar_alpha = 1;
		}
		[_trail setOpacity:drpt(_trail.opacity,_trail_tar_alpha,1/10.0)];
		if (self.position.x < -50 || self.position.x > game_screen().width + 50) {
			_ct = 0;
		} else if (self.position.y <= 0) {
			_current_mode = ArrowMode_Floating;
			if ([[g class] isSubclassOfClass:[GameEngineScene class]]) {
				GameEngineScene *game = (GameEngineScene*)g;
				[game add_ripple:self.position];
				_ct = 50;
			}
		}
	
	break;
	case ArrowMode_Stuck:;
		[_trail setOpacity:0];
		[self setPosition:CGPointAdd([_stuck_target position], _stuck_offset)];
		
		_ct -= dt_scale_get() * 0.0065;
		[self norm_ct_set_alpha];
		
		if ([_stuck_target should_remove] || [_stuck_target arrow_drop_all] || _stuck_target.parent == NULL) {
			_current_mode = ArrowMode_Falling;
			_stuck_target = NULL;
		}
	
	break;
	case ArrowMode_Floating:;
		[_trail setOpacity:0];
		if (_dir.x > 0) {
			[self setRotation:drpt(self.rotation, 0, 1/50.0)];
		} else {
			[self setRotation:drpt(self.rotation, 180, 1/50.0)];
		}
		[self setPosition:CGPointAdd(self.position, ccp(_dir.x*dt_scale_get()*0.1,-2*dt_scale_get()))];
		_ct-= dt_scale_get();
		[_sprite setOpacity:lerp(0, 1, _ct/50)];
	break;
	case ArrowMode_BounceOff:;
		//SPTODO
	break;
	case ArrowMode_Falling:;
		[_trail setOpacity:0];
		self.rotation += shortest_angle(self.rotation, 90) * powf(0.5, dt_scale_get());
		_falling_vel.y -= 0.2 * dt_scale_get();
		self.position = ccp(self.position.x+_falling_vel.x*dt_scale_get(),self.position.y+_falling_vel.y*dt_scale_get());
		_ct -= dt_scale_get() * 0.01;
		[self norm_ct_set_alpha];
		
	break;
	}
}

-(void)norm_ct_set_alpha {
	_sprite.opacity = bezier_point_for_t(ccp(0,1), ccp(0.5,1), ccp(1,1), ccp(1,0), 1-_ct).y;
}

-(BOOL)get_active {
	return _current_mode == ArrowMode_Flying;
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerProjectiles;
}

-(BOOL)should_remove {
	return _ct <= 0;
}

-(HitRect)get_hit_rect {
	return satpolyowner_cons_hit_rect(self.position, _sprite.textureRect.size.width, _sprite.textureRect.size.height,0.25);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	return satpolyowner_cons_sat_poly(in_poly, self.position, self.rotation, _sprite.textureRect.size.width-45, _sprite.textureRect.size.height, ccp(1,1),0.25);
}

@end