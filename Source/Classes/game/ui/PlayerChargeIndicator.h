//
//  PlayerChargeIndicator.h
//  hanokam
//
//  Created by spotco on 02/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
@class GameEngineScene;
@interface PlayerChargeIndicator : CCNode

+(PlayerChargeIndicator*)cons;
-(void)i_update:(GameEngineScene*)game;
-(void)set_pct:(float)pct g:(GameEngineScene*)g;
-(void)fadeout_fail;
@end
