//
//  QuestMenuUI.m
//  hanokam
//
//  Created by spotco on 14/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "QuestMenuUI.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "FileCache.h"
#import "Resource.h"
#import "FileCache.h"
#import "Common.h"
#import "SPLabel.h"
#import "GameColors.h"
#import "BGCharacterBase.h"
#import "DialogEvent.h"
#import "TouchButton.h"

@implementation QuestMenuUI {
	SPLabel *_quest_title;
	CCSprite *_desc_head;
	float _desc_head_anim_theta;
	SPLabel *_desc_text;
	SPLabel *_goal_text;
	SPLabel *_reward_text;
	
	TouchButton *_yes_button;
	TouchButton *_no_button;
}

+(QuestMenuUI*)cons:(GameEngineScene *)g {
	return [[QuestMenuUI node] cons:g];
}

-(QuestMenuUI*)cons:(GameEngineScene*) g {
	CCNode *menu_root = [CCNode node];
	[menu_root setPosition:game_screen_pct(0.5, 0.5)];
	[self addChild:menu_root]; //pct_of_obj from center since menu_bg is center scaled

	CCSprite *menu_bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"quest_window_bg.png"]];
	menu_bg.scaleX = 0.8228;
	menu_bg.scaleY = 1.2342;
	[menu_root setContentSize:menu_bg.boundingBox.size];
	[menu_root addChild:menu_bg];
	
	CCSprite *title_bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"dialogue_character_title.png"]];
	[title_bg setPosition:pct_of_obj(menu_root, 0, 0.5)];
	[title_bg setScale:1.5];
	[menu_root addChild:title_bg];
	
	SPLabel *title_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[title_text set_default_fill:GCOLOR_DIALOGUI_TITLE_FILL stroke:GCOLOR_DIALOGUI_TITLE_STROKE shadow:GCOLOR_BLACK];
	[title_text setAnchorPoint:ccp(0.5,0.5)];
	[title_text set_string:@"Quest Info"];
	[title_text setPosition:CGPointAdd(pct_of_obj(title_bg, 0.5, 0.5),ccp(0,4))];
	[title_text setScale:0.275];
	[title_bg addChild:title_text];
	
	_quest_title = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[_quest_title set_default_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	[_quest_title setAnchorPoint:ccp(0.5,1)];
	[_quest_title set_string:@"Quest Title"];
	[_quest_title setPosition:CGPointAdd(title_bg.position,ccp(0,-15))];
	[_quest_title setScale:0.5];
	[menu_root addChild:_quest_title];
	
	CCSprite *desc_bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"quest_window_descbubble.png"]];
	[desc_bg setAnchorPoint:ccp(0.5,1)];
	[desc_bg setPosition:CGPointAdd(_quest_title.position, ccp(0,-55))];
	[desc_bg setScale:0.5];
	[menu_root addChild:desc_bg];
	
	_desc_head = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET] rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"headicon_hanoka.png"]];
	[_desc_head setAnchorPoint:ccp(0.5,0.5)];
	[_desc_head setPosition:pct_of_obj(desc_bg, 0, 1)];
	[_desc_head setScale:1.0];
	[desc_bg addChild:_desc_head];
	
	_desc_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	
	[_desc_text set_default_style:g.player.get_player_dialogue_character.get_dialog_default_style];
	[_desc_text add_style:g.player.get_player_dialogue_character.get_dialog_emph_style name:DIALOGTEXT_EMPH];
	
	[_desc_text set_scale:0.5];
	[_desc_text setPosition:pct_of_obj(desc_bg, 0.5, 0.5)];
	[_desc_text setAnchorPoint:ccp(0.5,0.5)];
	[_desc_text set_string:@"Quest [emph]Description1@\nQuest Description 2"];
	[desc_bg addChild:_desc_text];
	
	SPLabel *goal_header = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[goal_header set_default_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	[goal_header setAnchorPoint:ccp(0,1)];
	[goal_header set_string:@"Goal:"];
	[goal_header setPosition:pct_of_obj(menu_root, -0.375, 0.125)];
	[goal_header setScale:0.35];
	[menu_root addChild:goal_header];
	
	_goal_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[_goal_text set_default_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	[_goal_text setAnchorPoint:ccp(0,1)];
	[_goal_text set_string:@"goal 1\ngoal 2\ngoal 3"];
	[_goal_text setPosition:pct_of_obj(menu_root, -0.325, 0.07)];
	[_goal_text setScale:0.25];
	[menu_root addChild:_goal_text];
	
	SPLabel *rewards_header = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[rewards_header set_default_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	[rewards_header setAnchorPoint:ccp(0,1)];
	[rewards_header set_string:@"Rewards:"];
	[rewards_header setPosition:pct_of_obj(menu_root, -0.375, -0.075)];
	[rewards_header setScale:0.35];
	[menu_root addChild:rewards_header];
	
	_reward_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[_reward_text set_default_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	[_reward_text setAnchorPoint:ccp(0,1)];
	[_reward_text set_string:@"reward 1\nreward 2\nreward 3"];
	[_reward_text setPosition:pct_of_obj(menu_root, -0.325, -0.13)];
	[_reward_text setScale:0.25];
	[menu_root addChild:_reward_text];
	
	CCSprite *yes_button_sprite = (CCSprite*)[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET]
			rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"quest_window_button_yes.png"]] set_scale:0.35];
	SPLabel *yes_button_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	
	SPLabelStyle *yes_button_text_style = [SPLabelStyle cons];
	[yes_button_text_style set_fill:GCOLOR_DIALOGUI_TITLE_FILL stroke:GCOLOR_DIALOGUI_TITLE_STROKE shadow:GCOLOR_BLACK];
	[yes_button_text_style set_amplitude:7];
	[yes_button_text_style set_time_incr:0.75];
	[yes_button_text set_default_style:yes_button_text_style];
	[yes_button_text setAnchorPoint:ccp(0.5,0.5)];
	[yes_button_text set_string:@"Let's do this!"];
	[yes_button_text setPosition:CGPointAdd(pct_of_obj(yes_button_sprite, 0.5, 0.5),ccp(0,0))];
	[yes_button_text setScale:0.8];
	[yes_button_sprite addChild:yes_button_text];
	
	_yes_button = [TouchButton cons_sprite:yes_button_sprite callback:callback_cons(self, @selector(yes_button_press:), g)];
	[_yes_button setPosition:pct_of_obj(menu_root, 0, -0.36)];
	[menu_root addChild:_yes_button];
	
	CCSprite *no_button_sprite = (CCSprite*)[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_DIALOGUE_SPRITESHEET]
			rect:[FileCache get_cgrect_from_plist:TEX_UI_DIALOGUE_SPRITESHEET idname:@"quest_window_button_no.png"]] set_scale:0.35];
	
	SPLabel *no_button_text = [SPLabel cons_texkey:TEX_DIALOGUE_FONT];
	[no_button_text set_default_fill:GCOLOR_DIALOGUI_TITLE_FILL stroke:GCOLOR_DIALOGUI_TITLE_STROKE shadow:GCOLOR_BLACK];
	[no_button_text setAnchorPoint:ccp(0.5,0.5)];
	[no_button_text set_string:@"Hold on..."];
	[no_button_text setPosition:CGPointAdd(pct_of_obj(no_button_sprite, 0.5, 0.5),ccp(0,0))];
	[no_button_text setScale:0.6];
	[no_button_sprite addChild:no_button_text];
	
	_no_button = [TouchButton cons_sprite:no_button_sprite callback:callback_cons(self, @selector(no_button_press:), g)];
	[_no_button setPosition:pct_of_obj(menu_root, 0, -0.45)];
	[menu_root addChild:_no_button];
	
	return self;
}

-(void)show_start:(GameEngineScene *)g {
	[_no_button reset];
	[_yes_button reset];
}

-(void)yes_button_press:(id)context {
	GameEngineScene *g = context;
	if (g.get_player_state == PlayerState_InQuestMenu) {
		[g.player pop_state_stack:g];
	}
	NSLog(@"yes button press");
}

-(void)no_button_press:(id)context {
	GameEngineScene *g = context;
	if (g.get_player_state == PlayerState_InQuestMenu) {
		[g.player pop_state_stack:g];
	}
	NSLog(@"no button press");
}

-(void)set_questinfo:(QuestInfo *)questinfo {

}

-(void)i_update:(GameEngineScene*)g {
	_desc_head_anim_theta += dt_scale_get() * 0.075;
	[_desc_head setRotation:7.5*sinf(_desc_head_anim_theta)];
	
	[_yes_button i_update:g];
	[_no_button i_update:g];
}

@end
