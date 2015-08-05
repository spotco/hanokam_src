//
//  SplashParticle.m
//  hanokam
//
//  Created by spotco on 05/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SplashParticle.h"
#import "GameEngineScene.h"

@implementation SplashParticle {
	CCSprite *_primary;
	CCSprite *_bubbles;

	float _anim_primary_t;
	float _anim_bubbles_t;
}

+(void)create_splash_effect:(GameEngineScene *)g at_pos:(CGPoint)pos angle:(float)angle {
	//[g add_particle:[SplashParticleBubbles cons_pos:CGPointAdd(pos,ccp(0,30)) angle:angle]];
	//[g add_particle:[SplashParticle cons_pos:pos angle:angle]];
}

+(SplashParticle*)cons_pos:(CGPoint)pos angle:(float)angle {
	return [[SplashParticle node] cons_pos:pos angle:angle];
}

-(SplashParticle*)cons_pos:(CGPoint)pos angle:(float)angle {

	[self setPosition:pos];
	[self setRotation:angle];

	_primary = [CCSprite spriteWithTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET]
										rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"fx_splash_primary.png"]];
	
	[self addChild:_primary z:1];
	
	_bubbles = [CCSprite spriteWithTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"fx_splash_bubbles.png"]];
	[_bubbles setAnchorPoint:ccp(0.5,0.15)];
	[_bubbles setPosition:ccp(0,30)];
	[self addChild:_bubbles z:0];

	_anim_primary_t = 0;
	_anim_bubbles_t = 0;
	return self;
}

-(void)i_update:(id)g {
	if (_anim_primary_t >= 1) {
		[_primary setVisible:NO];
	} else {
		[_primary setVisible:YES];
		_primary.opacity = bezier_point_for_t(ccp(0,0), ccp(0,1.0), ccp(0.3,1.5), ccp(1,0), _anim_primary_t).y;
		_primary.scaleX = bezier_point_for_t(ccp(0,0.75), ccp(0,1.5), ccp(0.6,2.5), ccp(1,0.65), _anim_primary_t).y;
		_primary.scaleY = bezier_point_for_t(ccp(0,0.75), ccp(0,1.2), ccp(0.75,1.25), ccp(1,0.75), _anim_primary_t).y;
		_anim_primary_t += 0.05 * dt_scale_get();
	}

	if (_anim_bubbles_t >= 1) {
		[_bubbles setVisible:NO];
	} else {
		[_bubbles setVisible:YES];
		_bubbles.opacity = bezier_point_for_t(ccp(0,0), ccp(0,1.0), ccp(0.3,1.5), ccp(1,0), _anim_bubbles_t).y;
		_bubbles.scaleX = bezier_point_for_t(ccp(0,0.75), ccp(0,1.5), ccp(0.6,2.5), ccp(1,0.65), _anim_bubbles_t).y * 0.9;
		_bubbles.scaleY = bezier_point_for_t(ccp(0,0.75), ccp(0,1.2), ccp(0.75,1.25), ccp(1,0.75), _anim_bubbles_t).y * 0.9;
		_anim_bubbles_t += 0.04 * dt_scale_get();
	}

}

-(BOOL)should_remove {
	return _anim_primary_t >= 1 && _anim_bubbles_t >= 1;
}

-(int)get_render_ord {
	return GameAnchorZ_BGWater_SplashBaseEffect;
}

@end