//
//  WaterEnemyManager.h
//  hanokam
//
//  Created by spotco on 30/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h" 
#import "PolyLib.h"
#import "GEventDispatcher.h"
@class GameEngineScene;

@interface BaseWaterEnemy : CCSprite <SATPolyHitOwner>
-(void)i_update:(GameEngineScene*)g;
-(BOOL)should_remove;
-(void)do_remove:(GameEngineScene*)g;
-(HitRect)get_hit_rect;
-(void)get_sat_poly:(SATPoly *)in_poly;

+(void)particle_blood_effect:(GameEngineScene *)g pos:(CGPoint)pos ct:(int)ct;
@end

@interface WaterEnemyManager : NSObject <GEventListener>
+(WaterEnemyManager*)cons:(GameEngineScene*)g;
-(void)i_update:(GameEngineScene*)g;
-(NSArray*)get_enemies;
-(void)add_enemy:(BaseWaterEnemy*)enemy game:(GameEngineScene*)g;
-(void)remove_all_enemies:(GameEngineScene*)g;
@end
