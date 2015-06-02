//
//  AccelerometerManager.h
//  hobobob
//
//  Created by spotco on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vec3D.h" 

@class GameEngineScene;
@interface ControlManager : NSObject
+(ControlManager*)cons;
-(void)accel_report_x:(float)x y:(float)y z:(float)z;
-(void)touch_begin:(CGPoint)pt;
-(void)touch_move:(CGPoint)pt;
-(void)touch_end:(CGPoint)pt;
-(void)i_update:(GameEngineScene*)game;

-(float)get_accel_x;

-(BOOL)is_proc_swipe;
-(void)clear_proc_swipe;
-(Vec3D)get_proc_swipe_dir;

-(BOOL)is_proc_tap;
-(void)clear_proc_tap;
-(CGPoint)get_proc_tap;

-(BOOL)is_proc_hold;
-(void)clear_proc_hold;
-(float)get_proc_hold_ct;
-(float)get_proc_hold_max;

-(BOOL)is_touch_down;

-(CGPoint)get_player_to_touch_dir;

@end
