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
	id _target;
}

+(EnemyNoticeParticle*)cons_pos:(CGPoint)pos g:(GameEngineScene *)g target:(id)target {
	return [[EnemyNoticeParticle node] cons_pos:pos g:g target:target];
}

-(EnemyNoticeParticle*)cons_pos:(CGPoint)pos g:(GameEngineScene*)g target:(id)target {
	_target = target;
	[self setPosition:pos];
	_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_HUD_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"exclamation_mark.png"]];
	[self addChild:_img];
	_anim_t = 0;
	[self update_img];
	[g.get_event_dispatcher add_listener:self];
	return self;
}

-(void)dispatch_event:(GEvent *)e {
	if (e.type == GEventType_PlayerHitEnemyDash && e.target == _target) {
		_anim_t = 1.0;
	}
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

-(void)do_remove:(id)g {
	[((GameEngineScene*)g).get_event_dispatcher remove_listener:self];

}

-(int)get_render_ord {
	return GameAnchorZ_PlayerAirEffects;
}

@end
