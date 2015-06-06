//
//  PlayerUIAimReticule.h
//  hanokam
//
//  Created by spotco on 05/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
@class GameEngineScene;
@interface PlayerUIAimReticule : CCNode

+(PlayerUIAimReticule*)cons;
-(void)i_update:(GameEngineScene*)g;

@end
