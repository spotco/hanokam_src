//
//  TouchButton.h
//  hanokam
//
//  Created by spotco on 14/08/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@class CallBack;
@class GameEngineScene;

@interface TouchButton : CCNode

+(TouchButton*)cons_sprite:(CCSprite*)sprite callback:(CallBack*)callback;
-(void)i_update:(GameEngineScene*)g;
-(void)reset;

@end
