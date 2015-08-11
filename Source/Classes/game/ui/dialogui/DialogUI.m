//
//  DialogUI.m
//
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DialogUI.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "FileCache.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"
#import "SPLabel.h"
#import "GameColors.h"

@implementation DialogUI {
	SPLabel *_primary_text;
}

+(DialogUI*)cons:(GameEngineScene *)game {
    return [[DialogUI node] cons:game];
}

-(DialogUI*)cons:(GameEngineScene*)game {
	CCSprite *dialog_bubble_back = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET]
	rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"dialogue_bubble_back.png"]];
	[dialog_bubble_back setAnchorPoint:ccp(0.5,0)];
	[dialog_bubble_back setPosition:CGPointAdd(game_screen_pct(0.5, 0),ccp(0,5))];
	scale_to_fit_screen_x(dialog_bubble_back);
	dialog_bubble_back.scaleX = (dialog_bubble_back.scaleX * 0.95);
	dialog_bubble_back.scaleY = dialog_bubble_back.scaleX;
	[self addChild:dialog_bubble_back];
	
	CCSprite *dialog_bubble_title = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET]
	rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"dialogue_character_title.png"]];
	[dialog_bubble_title setAnchorPoint:ccp(0,0.5)];
	[dialog_bubble_title setPosition:pct_of_obj(dialog_bubble_back, -0.0175, 0.975)];
	[dialog_bubble_back addChild:dialog_bubble_title];
	
	_primary_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	
	SPLabelStyle *primary_text_default_style = [SPLabelStyle cons];
	[primary_text_default_style set_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	primary_text_default_style._amplitude = 1.5;
	primary_text_default_style._time_incr = 0.15;
	[_primary_text set_default_style:primary_text_default_style];
	
	SPLabelStyle *primary_text_emph_style = [SPLabelStyle cons];
	[primary_text_emph_style set_fill:GCOLOR_DIALOGUI_PRIMARY_EMPH_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_EMPH_STROKE shadow:GCOLOR_BLACK];
	primary_text_emph_style._amplitude = 7;
	primary_text_emph_style._time_incr = 0.75;
	[_primary_text add_style:primary_text_emph_style name:@"emph"];
	
	[_primary_text set_scale:0.35];
	[_primary_text set_string:@"[emph]TOP KEK m8!!!@\nu [emph]thingken@ u cna \nhandle this?"];
	[_primary_text setPosition:pct_of_obj(dialog_bubble_back, 0.5, 0.5)];
	[_primary_text setAnchorPoint:ccp(0.5,0.5)];
	
	[dialog_bubble_back addChild:_primary_text z:9999];
	
	return self;
}
-(void)i_update:(GameEngineScene *)game {
}

-(void)show_message:(NSString*)message from_character:(BGCharacterBase*)character g:(GameEngineScene*)g {

}
-(void)fast_forward_message_to_end {

}
-(BOOL)is_ready_for_next_message {
	return NO;
}
@end
