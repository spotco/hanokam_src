//
//  PlayerUIAimReticule.m
//  hanokam
//
//  Created by spotco on 05/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerUIAimReticule.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "Resource.h" 
#import "FileCache.h"
#import "AlphaGradientSprite.h"
#import "ControlManager.h"

@implementation PlayerUIAimReticule {
	AlphaGradientSprite *_left_line, *_right_line;
	AlphaGradientSprite *_mega_arrow_line;
	float _tar_alpha;
	float _variance;
	
	float _charged_arrow_t, _charged_arrow_target_t;
}
+(PlayerUIAimReticule*)cons {
	return [[PlayerUIAimReticule node] cons];
}


-(PlayerUIAimReticule*)cons {
	_tar_alpha = 0;
	_left_line = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_BLANK]
									   texrect:cctexture_default_rect([Resource get_tex:TEX_BLANK])
										  size:CGSizeMake(2, 600)
								   anchorPoint:ccp(0.5,0)
                                         color:[CCColor whiteColor]
										alphaX:CGRangeMake(1, 1)
										alphaY:CGRangeMake(0, 1)];
	[_left_line setAnchorPoint:ccp(0.5,0)];
	[self addChild:_left_line];
	
	_right_line = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_BLANK]
                                        texrect:cctexture_default_rect([Resource get_tex:TEX_BLANK])
                                           size:CGSizeMake(2, 600)
                                    anchorPoint:ccp(0.5,0)
                                          color:[CCColor whiteColor]
                                         alphaX:CGRangeMake(1, 1)
                                         alphaY:CGRangeMake(0, 1)];
	[_right_line setAnchorPoint:ccp(0.5,0)];
	[self addChild:_right_line];
	
	_mega_arrow_line = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_PARTICLES_SPRITESHEET]
                                        texrect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"mega_arrow.png"]
                                           size:CGSizeMake(150, 15)
                                    anchorPoint:ccp(0,0.5)
                                          color:[CCColor whiteColor]
                                         alphaX:CGRangeMake(0, 0.75)
                                         alphaY:CGRangeMake(1, 1)];
	[_mega_arrow_line setAnchorPoint:ccp(0.5,0)];
	
	[self addChild:_mega_arrow_line];

	return self;
}

-(void)hold_visible:(float)variance {
	_tar_alpha = 1;
	_variance = variance;
	if (variance <= 0) {
		_charged_arrow_target_t = 1;
	} else {
		_charged_arrow_target_t = 0;
	}
}

-(void)i_update:(GameEngineScene*)g {
	if (g.get_player_state == PlayerState_InAir) {
		[self setVisible:YES];
		[self setPosition:[g.get_anchor convertToWorldSpace:g.player.get_center]];
		float tar_ang = vec_ang_deg_lim180(vec_cons(g.get_control_manager.get_player_to_touch_dir.x, g.get_control_manager.get_player_to_touch_dir.y, 0), 0) - 90;
		_left_line.rotation = tar_ang + _variance;
		_right_line.rotation = tar_ang - _variance;
		_mega_arrow_line.rotation = tar_ang - 90;
		
		
		float modif_tar_alpha = _tar_alpha * lerp(1, 0.05, _charged_arrow_target_t);
		_left_line.opacity = modif_tar_alpha;
		_right_line.opacity = modif_tar_alpha;
		_tar_alpha -= dt_scale_get()*0.1;
		
		_charged_arrow_t = clampf(_charged_arrow_t+SIG(_charged_arrow_target_t-_charged_arrow_t)*dt_scale_get()*0.15, 0, 1);
		_mega_arrow_line.scaleX = lerp(1.5, 1.25, _charged_arrow_t);
		_mega_arrow_line.scaleY = lerp(1.35, 1.25, _charged_arrow_t);
		_mega_arrow_line.opacity = _charged_arrow_t;
		_charged_arrow_target_t -= dt_scale_get()*0.1;
		
	} else {
		[self setVisible:NO];
		
	}
}
@end
