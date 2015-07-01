//
//  UIEnemyNoticeParticle.m
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EnemyNoticeParticle.h"
#import "Resource.h" 
#import "FileCache.h"
#import "GameEngineScene.h"

@implementation EnemyNoticeParticle {
	CCSprite *_img;
	float _anim_t;
}

+(EnemyNoticeParticle*)cons_pos:(CGPoint)pos {
	return [[EnemyNoticeParticle node] cons_pos:pos];
}

-(EnemyNoticeParticle*)cons_pos:(CGPoint)pos {
	[self setPosition:pos];
	_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"exclamation_mark.png"]];
	[self addChild:_img];
	_anim_t = 0;
	[self update_img];
	return self;
}

-(void)update_img {
	_img.opacity = bezier_point_for_t(ccp(0,0), ccp(0,1.75), ccp(0.75,0.75), ccp(1,0), _anim_t).y * 0.8;
	_img.scale = bezier_point_for_t(ccp(0,0), ccp(0,1), ccp(1,0), ccp(1,1), _anim_t).y;
}

-(void)i_update:(id)g {
	_anim_t += 0.025 * dt_scale_get();
	[self update_img];
}

-(BOOL)should_remove {
	return _anim_t >= 1;
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerAirEffects;
}

@end
