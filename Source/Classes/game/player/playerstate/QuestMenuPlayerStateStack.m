//
//  QuestMenuPlayerStateStack.m
//  hanokam
//
//  Created by spotco on 14/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "QuestMenuPlayerStateStack.h"

@implementation QuestMenuPlayerStateStack

+(QuestMenuPlayerStateStack*)cons_g:(GameEngineScene *)g questinfo:(QuestInfo *)questinfo {
	return [[[QuestMenuPlayerStateStack alloc] init] cons_g:g questinfo:questinfo];
}

-(QuestMenuPlayerStateStack*)cons_g:(GameEngineScene *)g questinfo:(QuestInfo *)questinfo {
	return self;
}

-(void)i_update:(GameEngineScene *)game {
}

-(PlayerState)get_state {
	return PlayerState_InQuestMenu;
}

@end
