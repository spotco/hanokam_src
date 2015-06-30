//
//  VillageUI.h
//  hanokam
//
//  Created by Kenneth Pu on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameUI.h"

@class GameEngineScene;

/**
 *  @class  VillageUI
 *
 *  Manages UI elements related to the village (dialogue bubbles, etc.)
 */
@interface VillageUI : GameUISubView

/**
 *  Returns an instance of VillageUI
 *
 *  @param  game        an object containing information about the current game state
 */
+(VillageUI*)cons:(GameEngineScene*)game;

@end
