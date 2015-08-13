//
//  BGCharacterBase.h
//  hanokam
//
//  Created by Kenneth Pu on 6/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Common.h"
#import "SPLabel.h"
#import "GameColors.h"

@class GameEngineScene;
@class SpriterNode;

@interface BGCharacterBase : CCSprite

-(NSArray*)get_dialog_list:(GameEngineScene*)g;
-(CGPoint)get_dialog_icon_offset;
-(NSString*)get_dialog_title;

-(void)set_anchor_object:(CCNode*)anchor;
-(void)set_anchor_relative_position:(CGPoint)anchor_rel_pos g:(GameEngineScene*)g;
-(CGPoint)get_anchor_relative_position;

-(void)i_update:(GameEngineScene*)g;

-(HitRect)get_hit_rect:(GameEngineScene*)g;

//dialog ui stuff
-(TexRect*)get_head_icon;
-(SPLabelStyle*)get_dialog_default_style;
-(SPLabelStyle*)get_dialog_emph_style;

@end
