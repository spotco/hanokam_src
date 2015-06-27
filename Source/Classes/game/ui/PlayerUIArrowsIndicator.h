//
//  PlayerUIArrowsIndicator.h
//  hanokam
//
//  Created by spotco on 26/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
@class GameEngineScene;
@interface PlayerUIArrowsIndicator : CCSprite
+(PlayerUIArrowsIndicator*)cons:(GameEngineScene*)g;
-(void)i_update:(GameEngineScene*)g;
@end
