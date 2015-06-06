//
//  BasePlayerStateStack.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasePlayerStateStack.h"

@implementation BasePlayerStateStack
-(void)i_update:(GameEngineScene *)game{}
-(PlayerState)get_state{return PlayerState_OnGround;}
-(void)on_state_end:(GameEngineScene*)game{}
@end

@implementation IdlePlayerStateStack

+(IdlePlayerStateStack*)cons {
	return [[IdlePlayerStateStack alloc] init];
}

-(void)i_update:(GameEngineScene *)game {
	NSLog(@"PLAYER IDLE STATE");
}

-(BOOL)on_land:(GameEngineScene*)game {
	return NO;
}

@end