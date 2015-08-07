//
//  DialogUI.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameUI.h"
@class BGCharacterBase;
@class GameEngineScene;

@interface DialogUI : GameUISubView

+(DialogUI*)cons:(GameEngineScene *)game;


-(void)show_message:(NSString*)message from_character:(BGCharacterBase*)character g:(GameEngineScene*)g;
-(void)fast_forward_message_to_end;
-(BOOL)is_ready_for_next_message;


@end
