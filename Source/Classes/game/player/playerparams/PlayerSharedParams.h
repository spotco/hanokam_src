//
//  PlayerSharedParams.h
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameEngineScene;
@interface PlayerSharedParams : NSObject

@property(readwrite,assign) CGPoint _s_pos;
@property(readwrite,assign) float _calc_accel_x_pos; //actual 1-to-1 x position (not offset by dashing)
@property(readwrite,assign) BOOL _reset_to_center;

+(PlayerSharedParams*)cons;

-(void)add_health:(float)val g:(GameEngineScene*)g;
-(void)set_health:(float)val;
-(int)get_max_health;
-(float)get_current_health;

-(float)get_current_breath;
-(void)set_breath:(float)val;
-(float)get_max_breath;

@end
