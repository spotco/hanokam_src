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

-(void)accel_report_x:(float)x;
-(float)get_frame_accel_x_vel;

-(CGPoint)get_post_swipe_drag;

-(void)touch_begin:(CGPoint)pt;
-(void)touch_move:(CGPoint)pt;
-(void)touch_end:(CGPoint)pt;
-(void)i_update:(GameEngineScene*)game;

-(BOOL)is_proc_swipe;
-(void)clear_proc_swipe;
-(Vec3D)get_proc_swipe_dir;

-(BOOL)is_proc_tap;
-(void)this_touch_procced_hold;
-(void)clear_proc_tap;
-(CGPoint)get_proc_tap;

-(BOOL)is_touch_down;

-(BOOL)this_touch_can_proc_tap;

-(CGPoint)get_player_to_touch_dir;

@end
