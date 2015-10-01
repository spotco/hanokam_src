//
//  QuestMenuPlayerStateStack.h
//  hanokam
//
//  Created by spotco on 14/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasePlayerStateStack.h"

@interface QuestInfo : NSObject
@end

@interface QuestMenuPlayerStateStack : BasePlayerStateStack

+(QuestMenuPlayerStateStack*)cons_g:(GameEngineScene*)g questinfo:(QuestInfo*)questinfo;

@end
