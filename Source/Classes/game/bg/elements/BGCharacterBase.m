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

-(NSArray*)get_dialog_list {
	return @[
		[DialogEvent cons_text:@"test1 [emph]test1@ test1"],
		[DialogEvent cons_text:@"test2 [emph]test2@ test2"]
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