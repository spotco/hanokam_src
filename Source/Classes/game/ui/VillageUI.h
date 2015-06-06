//
//  VillageUI.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@class GameEngineScene;

/**
 *  @class  VillageUI
 *
 *  Manages UI elements related to the village (dialogue bubbles, etc.)
 */
@interface VillageUI : CCNode

/**
 *  Returns an instance of VillageUI
 *
 *  @param  game        an object containing information about the current game state
 */
+(VillageUI*)cons:(GameEngineScene*)game;

/**
 *  Update state, handles interactions with other elements in the game
 *
 *  @param  game        an object containing information about the current game state
 */
-(void)i_update:(GameEngineScene*)game;

@end
