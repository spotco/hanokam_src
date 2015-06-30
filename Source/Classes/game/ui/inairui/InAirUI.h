//
//  InAirUI.h
//  hanokam
//
//  Created by spotco on 30/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameUI.h"
@class GameEngineScene;
@interface InAirUI : GameUISubView <GEventListener>
+(InAirUI*)cons:(GameEngineScene*)g;
@end
