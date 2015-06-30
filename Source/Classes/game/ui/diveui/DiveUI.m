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

@implementation DiveUI {
    HealthBar *_breath_bar;
    CCLabelTTF *_breath_bar_text;
}
+(DiveUI*)cons:(GameEngineScene*)g {
	return [[DiveUI node] cons:g];
}
-(DiveUI*)cons:(GameEngineScene*)g {
    _breath_bar = [HealthBar cons_size:CGSizeMake(game_screen().width-10, 20) anchor:ccp(0,1)];
    [_breath_bar set_color_back:ccc4f(150.0/255, 155.0/255, 157.0/255, 1.0) fill:ccc4f(197.0/255, 227.0/255, 238.0/255, 1.0)];
    [_breath_bar set_alpha_back:0.65 fill:0.85];
    [_breath_bar setPosition:game_screen_anchor_offset(ScreenAnchor_TL, ccp(5, -5))];
    [self addChild:_breath_bar];
    
    _breath_bar_text = (CCLabelTTF*)[label_cons(CGPointAdd(pct_of_obj(_breath_bar, 0, -1),ccp(2,-1)), ccc3(0, 0, 0), 8, @"") set_anchor_pt:ccp(0,0)];
    [_breath_bar addChild:_breath_bar_text];
    
    [self set_breath_pct:0.75];
    
    return self;
}

-(void)set_breath_pct:(float)pct {
    [_breath_bar set_pct:pct];
    [_breath_bar_text setString:strf("Breath %d%%",(int)(pct*100))];
}

-(void)i_update:(GameEngineScene *)g {
    [self set_breath_pct:g.player.shared_params.get_current_breath/g.player.shared_params.get_max_breath];
}
@end
