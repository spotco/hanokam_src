//
//  PlayerUIArrowsIndicator.m
//  hanokam
//
//  Created by spotco on 26/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerUIArrowsIndicator.h"
#import "GameEngineScene.h"
#import "HealthBar.h"
#import "Player.h"
#import "BasePlayerStateStack.h"

@implementation PlayerUIArrowsIndicator {
	CCSprite *_root;
	HealthBar *_arrows_indicator;
	float _indicator_at_max_ct;
}
+(PlayerUIArrowsIndicator*)cons:(GameEngineScene*)g {
	return [[PlayerUIArrowsIndicator node] cons:g];
}
-(PlayerUIArrowsIndicator*)cons:(GameEngineScene*)g {
	_root = [CCSprite node];
	[self addChild:_root];

	_arrows_indicator = [HealthBar cons_size:CGSizeMake(30, 6) anchor:ccp(0.5,0.5)];
	[_arrows_indicator set_color_back:ccc4f(0.47, 0.47, 0.47, 1.0) fill:ccc4f(1.0, 0.75, 0, 1.0)];
	[_arrows_indicator set_alpha_back:0.7 fill:0.9];
	[_arrows_indicator set_pct:1.0];
	[_root addChild:_arrows_indicator];
	return self;
}
-(void)i_update:(GameEngineScene*)g {
	PlayerAirCombatParams *air_params = [g.player.get_top_state cond_get_inair_combat_params];
	if (air_params != NULL) {
		[self setVisible:YES];
		[_root setPosition:CGPointAdd([g.player convertToWorldSpace:CGPointZero],ccp(0,25))];
		float pct = air_params._arrows_left_ct/air_params.GET_MAX_ARROWS;
		[_arrows_indicator set_pct:pct];
		if (pct >= 1) {
			_indicator_at_max_ct += dt_scale_get();
		} else {
			_indicator_at_max_ct = 0;
		}
		if (_indicator_at_max_ct > 30) {
			_arrows_indicator.opacity = drp(_arrows_indicator.opacity, 0, 5);
		} else {
			_arrows_indicator.opacity = drp(_arrows_indicator.opacity, 1, 5);
		}
		
		
		
	} else {
		[self setVisible:NO];
	}
}

@end
