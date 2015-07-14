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
#import "Common.h"
#import "SPCCTimedSpriteAnimator.h"

@implementation SwordSlashParticle {
	SPCCTimedSpriteAnimator *_sprite_animator, *_blood_animator;
	CCSprite *_img, *_img_blood;
	
	float _anim_t;
}

+(SwordSlashParticle*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	return [[SwordSlashParticle node] cons_pos:pos dir:dir];
}

-(SwordSlashParticle*)show_blood {
	_img_blood = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_ENEMY] rect:CGRectZero];
	_blood_animator = [SPCCTimedSpriteAnimator cons_target:_img_blood];
	[_blood_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy_blood_000.png"] at_time:0.0];
	[_blood_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy_blood_001.png"] at_time:0.25];
	[_blood_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy_blood_002.png"] at_time:0.5];
	[_blood_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_ENEMY idname:@"enemy_blood_003.png"] at_time:0.75];
	[self addChild:_img_blood z:0];
	_img_blood.rotation = _img.rotation;
	return self;
}

-(SwordSlashParticle*)cons_pos:(CGPoint)pos dir:(Vec3D)dir {
	[self setPosition:pos];
	
	_img = [CCSprite spriteWithTexture:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:CGRectZero];
	_sprite_animator = [SPCCTimedSpriteAnimator cons_target:_img];
	[_sprite_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"slash_000.png"] at_time:0.0];
	[_sprite_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"slash_001.png"] at_time:0.5];
	[_sprite_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"slash_002.png"] at_time:0.7];
	[self addChild:_img z:1];
	[self setScale:0.5];
	
	_img.rotation = vec_ang_deg_lim180(dir, 0);
	
	_anim_t = 0;
	[self update_img];
	return self;
}

-(void)update_img {
	_img.opacity = bezier_point_for_t(ccp(0,0), ccp(0,1.75), ccp(0.75,0.75), ccp(1,0), _anim_t).y;
	_img.scaleX = bezier_point_for_t(ccp(0,0), ccp(0,1), ccp(1,0), ccp(1,1), _anim_t).y * 0.9;
	_img.scaleY = bezier_point_for_t(ccp(0,0.5), ccp(0,1), ccp(1,0.5), ccp(1,1.5), _anim_t).y * 0.65;
	
	if (_img_blood != NULL) {
		_img_blood.opacity = clampf(_img.opacity * 4,0,1);
		_img_blood.scaleX = _img.scaleX * 0.85;
		_img_blood.scaleY = _img.scaleY * 0.85;
	}
}

-(void)i_update:(id)g {
	_anim_t += 0.075 * dt_scale_get();
	[_sprite_animator show_frame_for_time:_anim_t];
	if (_img_blood != NULL) {
		[_blood_animator show_frame_for_time:_anim_t];
	}
	[self update_img];
}

-(BOOL)should_remove {
	return _anim_t >= 1;
}

-(int)get_render_ord {
	return GameAnchorZ_PlayerAirEffects;
}
@end
