//
//  InAirUI.m
//  hanokam
//
//  Created by spotco on 30/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "InAirUI.h"
#import "PlayerUIHealthIndicator.h"
#import "PlayerUIAimReticule.h"
#import "EnemyUIHealthIndicators.h"
#import "EnemyWarningUI.h"
#import "PlayerUIArrowsIndicator.h"
#import "Resource.h" 
#import "FileCache.h"

@implementation InAirUI {
	PlayerUIHealthIndicator *_player_health_ui;
	PlayerUIAimReticule *_player_aim_reticule;
	PlayerUIArrowsIndicator *_player_arrows_indicator;
	EnemyUIHealthIndicators *_enemy_ui_health_indicators;
	EnemyWarningUI *_enemy_warning_ui;
}

+(InAirUI*)cons:(GameEngineScene*)g {
	return [[InAirUI node] cons:g];
}
-(InAirUI*)cons:(GameEngineScene*)g {
	[g.get_event_dispatcher add_listener:self];

	_enemy_ui_health_indicators = [EnemyUIHealthIndicators cons:g];
	[self addChild:_enemy_ui_health_indicators];
	
	_enemy_warning_ui = [EnemyWarningUI cons:g];
	[self addChild:_enemy_warning_ui];
	
	CGRect heart_size = [FileCache get_cgrect_from_plist:TEX_HUD_SPRITESHEET idname:@"heart_fill.png"];
	_player_health_ui = [PlayerUIHealthIndicator cons:g];
	[_player_health_ui setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp((heart_size.size.width*0.5 + 3),-(heart_size.size.height*0.5 + 3)))];
	[self addChild:_player_health_ui];
	
	_player_arrows_indicator = [PlayerUIArrowsIndicator cons:g];
	[self addChild:_player_arrows_indicator];
	
	_player_aim_reticule = [PlayerUIAimReticule cons];
	[self addChild:_player_aim_reticule];
	return self;
}

-(void)dispatch_event:(GEvent *)e {
	switch (e.type) {
	case GEventType_PlayerAimVariance: {
		[_player_aim_reticule hold_visible:e.float_value];
	}
	break;
	case GeventType_PlayerHealthHeal: {
		[_player_health_ui pulse_heart_lastfill];
	}
	default: {}
	}
}

-(void)i_update:(GameEngineScene*)g {
	[_player_aim_reticule i_update:g];
	[_player_arrows_indicator i_update:g];
	[_enemy_ui_health_indicators i_update:g];
	[_enemy_warning_ui i_update:g];
	[_player_health_ui i_update:g];
}

@end
