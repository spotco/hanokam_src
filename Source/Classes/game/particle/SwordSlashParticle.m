//
//  SwordSlashParticle.m
//  hanokam
//
//  Created by spotco on 07/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SwordSlashParticle.h"
#import "GameEngineScene.h"
#import "Resource.h" 
#import "FileCache.h"

@implementation SwordSlashParticle {
	CCSprite *_img;
	float _anim_t;
}

+(SwordSlashParticle*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	return [[SwordSlashParticle node] cons_pos:pos dir:dir];
}

-(SwordSlashParticle*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	[self setPosition:pos];
	_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_GAMEPLAY_ELEMENTS] rect:[FileCache get_cgrect_from_plist:TEX_GAMEPLAY_ELEMENTS idname:@"vfx_sword_slash.png"]];
	[self addChild:_img];
	_img.rotation = vec_ang_deg_lim180(dir, 0)-90;
	_anim_t = 0;
	[self update_img];
	return self;
}

-(void)update_img {
	_img.opacity = bezier_point_for_t(ccp(0,0), ccp(0,1.75), ccp(0.75,0.75), ccp(1,0), _anim_t).y;
	_img.scaleX = bezier_point_for_t(ccp(0,0), ccp(0,1), ccp(1,0), ccp(1,1), _anim_t).y;
	_img.scaleY = bezier_point_for_t(ccp(0,0.5), ccp(0,1), ccp(1,0.5), ccp(1,1.5), _anim_t).y;
}

-(void)i_update:(id)g {
	_anim_t += 0.075 * dt_scale_get();
	[self update_img];
}

-(BOOL)should_remove {
	return _anim_t >= 1;
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerAirEffects;
}
@end
