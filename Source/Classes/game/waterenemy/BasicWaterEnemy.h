//
//  BasicWaterEnemy.h
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WaterEnemyManager.h"

typedef enum {
	BasicWaterEnemyMode_IdleMove,
	BasicWaterEnemyMode_IdleNoticed,
	BasicWaterEnemyMode_InPack
} BasicWaterEnemyMode;

@interface BasicWaterEnemy : BaseWaterEnemy
@property(readwrite,assign) BasicWaterEnemyMode _current_mode;
-(BasicWaterEnemy*)cons_g:(GameEngineScene*)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2;
-(CGPoint)notice_anim_offset;
@end
