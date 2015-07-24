//
//  BGWater.h
//  hobobob
//
//  Created by spotco on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import "GameEngineScene.h"

@interface BGWater : BGElement
+(BGWater*)cons:(GameEngineScene*)g;

-(void)set_ground_depth:(float)depth;
-(CGPoint)get_underwater_treasure_position;
-(void)set_underwater_treasure_visible:(BOOL)tar;

@end
