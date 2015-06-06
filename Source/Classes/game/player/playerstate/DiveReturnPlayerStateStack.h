//
//  DiveReturnPlayerState.h
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasePlayerStateStack.h"
@class PlayerUnderwaterCombatParams;

@interface DiveReturnPlayerStateStack : BasePlayerStateStack
+(DiveReturnPlayerStateStack*)cons:(GameEngineScene*)g waterparams:(PlayerUnderwaterCombatParams*)waterparams;
@end
