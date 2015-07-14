#import "RotateFadeOutParticle.h"
#import "SPCCTimedSpriteAnimator.h"

@implementation RotateFadeOutParticle {
	float _ct, _ctmax;
	float _vr;
	float _scmin, _scmax;
	float _render_ord;
	CGRange _alpha;
	CGPoint _velocity;
	float _gravity;
	SPCCTimedSpriteAnimator *_animator;
}

+(RotateFadeOutParticle*)cons_tex:(CCTexture*)tex rect:(CGRect)rect {
	return [[RotateFadeOutParticle spriteWithTexture:tex rect:rect] cons];
}

-(RotateFadeOutParticle*)cons {
	_scmin = 1;
	_scmax = 1;
	_render_ord = 999;
	_velocity = CGPointZero;
	_gravity = 0;
	_alpha = CGRangeMake(1.0, 0.0);
	[self set_ctmax:50];
	return self;
}
-(RotateFadeOutParticle*)set_alpha_start:(float)start end:(float)end {
	_alpha = CGRangeMake(start, end);
	return self;
}
-(RotateFadeOutParticle*)set_vel:(CGPoint)vel {
	_velocity = vel;
	return self;
}
-(RotateFadeOutParticle*)set_gravity:(float)gravity {
	_gravity = gravity;
	return self;
}
-(RotateFadeOutParticle*)set_ctmax:(float)ctmax {
	_ctmax = ctmax;
	_ct = _ctmax;
	return self;
}
-(RotateFadeOutParticle*)set_vr:(float)vr {
	_vr = vr;
	return self;
}
-(RotateFadeOutParticle*)set_render_ord:(int)tar {
	_render_ord = tar;
	return self;
}
-(RotateFadeOutParticle*)set_scale_min:(float)scmin max:(float)scmax {
	_scmin = scmin;
	_scmax = scmax;
	return self;
}
-(RotateFadeOutParticle*)set_timed_sprite_animator:(SPCCTimedSpriteAnimator*)animator {
	_animator = animator;
	return self;
}
-(void)i_update:(id)g {
	float pct = _ct/_ctmax;
	_ct -= dt_scale_get();
	[self setOpacity:lerp(_alpha.min, _alpha.max, 1-pct)];
	[self setRotation:self.rotation + _vr * dt_scale_get()];
	[self setScale:lerp(_scmin, _scmax, pct)];
	_velocity.y -= _gravity * dt_scale_get();
	[self setPosition:ccp(self.position.x+_velocity.x*dt_scale_get(),self.position.y+_velocity.y*dt_scale_get())];
	if (_animator != NULL) {
		[_animator show_frame_for_time:1-pct];
	}
}

-(BOOL)should_remove {
	return _ct <= 0;
}

-(int)get_render_ord {
	return _render_ord;
}



@end
