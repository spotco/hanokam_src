//
//  DiveUI.m
//  hanokam
//
//  Created by spotco on 30/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DiveUI.h"
#import "HealthBar.h"
#import "Common.h"
#import "Player.h"
#import "FlashCount.h"

@implementation DiveUI {
    HealthBar *_breath_bar;
    CCLabelTTF *_breath_bar_text;
	
	float _current_fill_pct;
	
	ccColor4F _breath_bar_back_color, _breath_bar_fill_color, _breath_bar_fill_hit_color;
	float _breath_bar_anim_t;
	
	FlashCount *_low_breath_flash;
}
+(DiveUI*)cons:(GameEngineScene*)g {
	return [[DiveUI node] cons:g];
}

-(DiveUI*)cons:(GameEngineScene*)g {
    _breath_bar = [HealthBar cons_size:CGSizeMake(game_screen().width-10, 20) anchor:ccp(0,1)];
	
	_breath_bar_back_color = ccc4f(150.0/255, 155.0/255, 157.0/255, 1.0);
	_breath_bar_fill_color = ccc4f(197.0/255, 227.0/255, 238.0/255, 1.0);
	_breath_bar_fill_hit_color = ccc4f(220.0/255, 120.0/255, 150.0/255, 1.0);
	[_breath_bar set_color_back:_breath_bar_back_color fill:_breath_bar_fill_color];
    [_breath_bar set_alpha_back:0.65 fill:0.85];
    [_breath_bar setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp(5, -5))];
    [self addChild:_breath_bar];
    
    _breath_bar_text = (CCLabelTTF*)[label_cons(CGPointAdd(pct_of_obj(_breath_bar, 0, -1),ccp(2,-1)), ccc3(0, 0, 0), 8, @"") set_anchor_pt:ccp(0,0)];
    [_breath_bar addChild:_breath_bar_text];
	
	_breath_bar_anim_t = 0.0;
	_current_fill_pct = 1.0;
    [self set_breath_pct:_current_fill_pct];
	
	[g.get_event_dispatcher add_listener:self];
	
	_low_breath_flash = [FlashCount cons];
	[_low_breath_flash add_flash_at_times:@[@(0.3),@(0.2),@(0.15),@(0.1),@(0.05)]];
    return self;
}

-(void)dispatch_event:(GEvent *)e {
	if (e.type == GEventType_ModeDiveStart) {
		_current_fill_pct = 1.0;
		[_breath_bar set_color_back:_breath_bar_back_color fill:_breath_bar_fill_color];
		[_low_breath_flash reset];
	}
	if (!self.visible) return;
	switch (e.type) {
	case GEventType_PlayerTakeDamage:{
		_breath_bar_anim_t = 1;
	} break;
	default: break;
	}
}

-(void)set_breath_pct:(float)pct {
    [_breath_bar set_pct:pct];
    [_breath_bar_text setString:strf("Breath %d%%",(int)(pct*100))];
}

-(void)i_update:(GameEngineScene *)g {
	_current_fill_pct = drpt(_current_fill_pct, g.player.shared_params.get_current_breath/g.player.shared_params.get_max_breath, 1/10.0);
    [self set_breath_pct:_current_fill_pct];
	
	if ([_low_breath_flash do_flash_given_time:_current_fill_pct]) {
		_breath_bar_anim_t = 1;
	}
	
	_breath_bar_anim_t = MAX(_breath_bar_anim_t-=dt_scale_get()*0.035,0);
	float fill_color_pct = bezier_point_for_t(ccp(0,0), ccp(0,0.75), ccp(0,1), ccp(1,1), _breath_bar_anim_t).y;
	
	ccColor4F tar_color = ccc4f(
		lerp(_breath_bar_fill_color.r, _breath_bar_fill_hit_color.r, fill_color_pct),
		lerp(_breath_bar_fill_color.g, _breath_bar_fill_hit_color.g, fill_color_pct),
		lerp(_breath_bar_fill_color.b, _breath_bar_fill_hit_color.b, fill_color_pct),
		1.0
	);
	
	[_breath_bar set_color_back:_breath_bar_back_color fill:tar_color];
}
@end
