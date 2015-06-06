//
//  VillageUI.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class GameEngineScene;

@interface VillageUI : CCNode

+(VillageUI*)cons:(GameEngineScene*)game;
-(void)i_update:(GameEngineScene*)game;

@end
