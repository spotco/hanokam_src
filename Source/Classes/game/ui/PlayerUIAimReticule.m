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
}
+(PlayerUIAimReticule*)cons {
	return [[PlayerUIAimReticule node] cons];
}


-(PlayerUIAimReticule*)cons {
	_left_line = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_BLANK]
									   texrect:cctexture_default_rect([Resource get_tex:TEX_BLANK])
										  size:CGSizeMake(2, 400)
								   anchorPoint:ccp(0.5,0)
										alphaX:CGRangeMake(1, 1)
										alphaY:CGRangeMake(0, 1)];
	[_left_line setAnchorPoint:ccp(0.5,0)];
	[_left_line setRotation:10];
	[self addChild:_left_line];
	
	_right_line = [AlphaGradientSprite cons_tex:[Resource get_tex:TEX_BLANK]
									   texrect:cctexture_default_rect([Resource get_tex:TEX_BLANK])
										  size:CGSizeMake(2, 400)
								   anchorPoint:ccp(0.5,0)
										alphaX:CGRangeMake(1, 1)
										alphaY:CGRangeMake(0, 1)];
	[_right_line setAnchorPoint:ccp(0.5,0)];
	[_right_line setRotation:-10];
	[self addChild:_right_line];

	return self;
}

-(void)i_update:(GameEngineScene*)g {
	[self setPosition:[g.player convertToWorldSpace:CGPointZero]];
	float tar_ang = vec_ang_deg_lim180(vec_cons(g.get_control_manager.get_player_to_touch_dir.x, g.get_control_manager.get_player_to_touch_dir.y, 0), 0) + 90;
	_left_line.rotation = tar_ang + 5;
	_right_line.rotation = tar_ang - 5;
}
@end
