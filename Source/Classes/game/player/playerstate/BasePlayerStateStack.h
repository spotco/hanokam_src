//
//  BasePlayerStateStack.h
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEngineScene.h"
#import "Player.h" 
#import "PlayerSharedParams.h"
#import "ControlManager.h"
#import "GameUI.h" 
#import "SpriterNode.h" 

@interface BasePlayerStateStack : NSObject
-(void)i_update:(GameEngineScene*)game;
-(PlayerState)get_state;
-(void)on_state_end:(GameEngineScene*)game;
-(BOOL)on_land:(GameEngineScene*)game;
@end

@interface IdlePlayerStateStack : BasePlayerStateStack
+(IdlePlayerStateStack*)cons;
@end