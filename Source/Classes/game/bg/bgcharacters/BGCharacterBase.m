//
//  BGCharacterBase.m
//  hanokam
//
//  Created by Kenneth Pu on 6/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BGCharacterBase.h"
#import "GameEngineScene.h"
#import "Resource.h"
#import "FileCache.h"
#import "Player.h"
#import "ControlManager.h"
#import "Common.h"
#import "PlayerLandParams.h"
#import "BasePlayerStateStack.h"
#import "InDialoguePlayerStateStack.h"
#import "DialogEvent.h"

@implementation BGCharacterBase {
	CCNode *_anchor;
	CGPoint _anchor_rel_pos;
	
	TexRect *_cached_head_icon;
	SPLabelStyle *_dialog_default_style, *_dialog_emph_style;
}

-(void)set_anchor_object:(CCNode*)anchor {
	_anchor = anchor;
}
-(void)set_anchor_relative_position:(CGPoint)anchor_rel_pos g:(GameEngineScene *)g {
	_anchor_rel_pos = anchor_rel_pos;
	self.position = CGPointAdd(_anchor_rel_pos,[g.get_anchor convertToNodeSpace:[_anchor convertToWorldSpace:CGPointZero]]);
}
-(CGPoint)get_anchor_relative_position {
	return _anchor_rel_pos;
}

-(TexRect*)get_head_icon {
	if (_cached_head_icon == NULL) _cached_head_icon = [TexRect cons_tex:NULL rect:CGRectZero];
	return _cached_head_icon;
}

-(SPLabelStyle*)get_dialog_default_style {
	if (_dialog_default_style == NULL) _dialog_default_style = [SPLabelStyle cons];
	[_dialog_default_style set_fill:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_DEFAULT_STROKE shadow:GCOLOR_BLACK];
	_dialog_default_style._amplitude = 1.5;
	_dialog_default_style._time_incr = 0.15;
	return _dialog_default_style;
}

-(SPLabelStyle*)get_dialog_emph_style {
	if (_dialog_emph_style == NULL) _dialog_emph_style = [SPLabelStyle cons];
	[_dialog_emph_style set_fill:GCOLOR_DIALOGUI_PRIMARY_EMPH_FILL stroke:GCOLOR_DIALOGUI_PRIMARY_EMPH_STROKE shadow:GCOLOR_BLACK];
	_dialog_emph_style._amplitude = 7;
	_dialog_emph_style._time_incr = 0.75;
	return _dialog_emph_style;
}

-(NSArray*)get_dialog_list:(GameEngineScene *)g {
	return @[
		[DialogEvent cons_text:@"test1 [emph]test1@ test1" speaker:self],
		[DialogEvent cons_text:@"test2 [emph]test2@ test2" speaker:g.player.get_player_dialogue_character],
		[DialogEvent cons_text:@"test3 [emph]test2@ test3" speaker:self]
	];
}
-(CGPoint)get_dialog_icon_offset {
	return CGPointZero;
}
-(NSString*)get_dialog_title {
	return @"Placeholder";
}

-(void)i_update:(GameEngineScene*)g {
	[self set_anchor_relative_position:_anchor_rel_pos g:g];
}

-(HitRect)get_hit_rect:(GameEngineScene *)g {
	return hitrect_cons_xy_widhei(self.position.x-15, self.position.y, 30, 40);
}

@end