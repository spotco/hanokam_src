//
//  BGCharacterBase.h
//  hanokam
//
//  Created by Kenneth Pu on 6/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Common.h"

@class GameEngineScene;
@class SpriterNode;

@interface BGCharacterBase : CCSprite

-(NSArray*)get_dialog_list;
-(CGPoint)get_dialog_icon_offset;
-(NSString*)get_dialog_title;

-(void)set_anchor_object:(CCNode*)anchor;
-(void)set_anchor_relative_position:(CGPoint)anchor_rel_pos g:(GameEngineScene*)g;
-(CGPoint)get_anchor_relative_position;

-(void)i_update:(GameEngineScene*)g;

-(HitRect)get_hit_rect:(GameEngineScene*)g;

@end
