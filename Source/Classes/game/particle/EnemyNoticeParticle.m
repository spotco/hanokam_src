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
#import "Player.h"

@implementation EnemyNoticeParticle {
	CCSprite *_img;
	CCSprite *_excl_img;
	float _anim_t;
	id _target;
}

+(EnemyNoticeParticle*)cons_pos:(CGPoint)pos g:(GameEngineScene *)g target:(id)target {
	return [[EnemyNoticeParticle node] cons_pos:pos g:g target:target];
}

-(EnemyNoticeParticle*)cons_pos:(CGPoint)pos g:(GameEngineScene*)g target:(id)target {
	_target = target;
	[self setPosition:pos];
	
	_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_ENEMY] rect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy Notice Ink.png"]];
	[_img set_anchor_pt:ccp(0.5,0.5)];
	[self addChild:_img];
	
	if ([_target isKindOfClass:[CCNode class]]) {
		_img.rotation = vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(g.player.position,((CCNode*)_target).position)),0);
	}

	_excl_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_ENEMY] rect:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"Enemy Notice !.png"]];
	[self addChild:_excl_img];
	
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
	if (_anim_t <= 0) {
		_img.scale = 4 * 0.25;
		_img.opacity = 0;

	} else if (_anim_t <= 0.8) {
		_img.scale = drpt(_img.scale, 1*0.25, 1/4.0);
		_img.opacity = drpt(_img.opacity, 0.7, 1/5.0);
	} else {
		_img.scale = drpt(_img.scale, 2*0.25, 1/4.0);
		_img.opacity = drpt(_img.opacity, 0, 1/5.0);
	}
	
	_excl_img.scale = _img.scale;
	_excl_img.opacity = _img.opacity;
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
