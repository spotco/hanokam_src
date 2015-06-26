//
//  InAirPlayerStateStack.h
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasePlayerStateStack.h"
#import "GEventDispatcher.h"

@interface InAirPlayerStateStack : BasePlayerStateStack <GEventListener>
+(InAirPlayerStateStack*)cons:(GameEngineScene*)g;
@end
