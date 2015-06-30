//
//  EnemyWarningUI.h
//  hanokam
//
//  Created by spotco on 23/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
@class GameEngineScene;
@interface EnemyWarningUI : CCSprite
+(EnemyWarningUI*)cons:(GameEngineScene*)g;
-(void)i_update:(GameEngineScene*)g;
@end
