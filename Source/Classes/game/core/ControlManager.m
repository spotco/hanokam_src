//
//  AccelerometerManager.m
//  hobobob
//
//  Created by spotco on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ControlManager.h"
#import "GameEngineScene.h"
#import "Player.h"
#import "Vec3D.h"

@implementation ControlManager {
	float _touch_dist_sum, _avg_x, _avg_y;
	int _touch_move_counter;
	CGPoint _prev_touch;
	BOOL _is_touch_down, _this_touch_has_procced_swipe, _this_touch_has_procced_hold;
	
	Vec3D _proc_swipe_dir;
	BOOL _is_proc_swipe;
	
	CGPoint _proc_tap_pt;
	BOOL _is_proc_tap;
	
	float _proc_hold_ct;
	
	CGPoint _last_player_world_pos;
	
	float _frame_accel_x_vel;
}

+(ControlManager*)cons {
	return [[ControlManager alloc] init];
}

-(void)accel_report_x:(float)x {
	/*
	if (ABS(x) < 0.035) x = 0;
	x = signum(x)*(ABS(x)-0.035);
	_frame_accel_x_vel = x * 18;
	*/
	_frame_accel_x_vel = x;
}

-(float)get_frame_accel_x_vel {
	return _frame_accel_x_vel;
}

-(void)touch_begin:(CGPoint)pt {
    _is_touch_down = YES;
    _touch_move_counter = 0;
    _touch_dist_sum = 0;
    _prev_touch = pt;
	_this_touch_has_procced_hold = NO;
	_this_touch_has_procced_swipe = NO;
	[self clear_proc_swipe];
}

-(void)touch_move:(CGPoint)pt {
    _touch_move_counter++;
    _touch_dist_sum += CGPointDist(_prev_touch, pt);
	
	float avg_ct = 3.0;
	_avg_x -= _avg_x / avg_ct;
    _avg_x += (pt.x-_prev_touch.x) / avg_ct;
	_avg_y -= _avg_y / avg_ct;
    _avg_y += (pt.y-_prev_touch.y) / avg_ct;
    
    if(_touch_move_counter == 3) {
        float avg = _touch_dist_sum/_touch_move_counter;
        if (avg > 7 && !_this_touch_has_procced_swipe) {
			_this_touch_has_procced_swipe = YES;
			_proc_swipe_dir = vec_cons_norm(_avg_x, _avg_y, 0);
			_is_proc_swipe = YES;
        }
		
        _touch_move_counter = 0;
        _touch_dist_sum = 0;
        _avg_x = 0;
        _avg_y = 0;
	}
    _prev_touch = pt;
}

-(void)touch_end:(CGPoint)pt {
    _is_touch_down = NO;
	if (!_this_touch_has_procced_hold && !_this_touch_has_procced_swipe) {
		_is_proc_tap = YES;
		_proc_tap_pt = pt;
	}
}

-(BOOL)is_proc_swipe {
	return _is_proc_swipe;
}
-(void)clear_proc_swipe {
	_is_proc_swipe = NO;
}
-(Vec3D)get_proc_swipe_dir {
	return _proc_swipe_dir;
}

-(BOOL)is_proc_tap {
	return _is_proc_tap;
}
-(void)clear_proc_tap {
	_is_proc_tap = NO;
}
-(CGPoint)get_proc_tap {
	return _proc_tap_pt;
}
-(void)this_touch_procced_hold {
	_this_touch_has_procced_hold = YES;
}

-(BOOL)is_touch_down {
	return _is_touch_down;
}



-(CGPoint)get_player_to_touch_dir {
	return CGPointSub(_prev_touch, _last_player_world_pos);
}

-(void)i_update:(GameEngineScene*)game {
	if (_is_touch_down) {
		_proc_hold_ct += dt_scale_get();
	} else {
		_proc_hold_ct = 0;
	}
	_last_player_world_pos = [game.player convertToWorldSpace:CGPointZero];
}

@end
