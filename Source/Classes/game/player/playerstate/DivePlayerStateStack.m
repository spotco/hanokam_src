//
//  DivePlayerStateStack.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DivePlayerStateStack.h"
#import "PlayerUnderwaterCombatParams.h"
#import "DiveReturnPlayerStateStack.h"
#import "UnderwaterBubbleParticle.h"
#import "FlashEvery.h"

@implementation DivePlayerStateStack {
	PlayerUnderwaterCombatParams *_underwater_params;
    FlashEvery *_bubble_every;
}

+(DivePlayerStateStack*)cons:(GameEngineScene*)g {
	return [[[DivePlayerStateStack alloc] init] cons:g];
}

-(DivePlayerStateStack*)cons:(GameEngineScene*)g {
	_underwater_params = [[PlayerUnderwaterCombatParams alloc] init];
	
	_underwater_params._vel = ccp(0,-7);
	_underwater_params._camera_offset = g.get_current_camera_center_y - g.player.position.y;
	_underwater_params._current_mode = PlayerUnderwaterCombatMode_TransitionIn;
	_underwater_params._anim_ct = 0;
	_underwater_params._initial_camera_offset = _underwater_params._camera_offset;
    [g.player.shared_params set_breath:g.player.shared_params.get_max_breath];
	[g.player read_s_pos:g];
    [self proc_multiple_bubbles2:g];
    
    _bubble_every = [FlashEvery cons_time:30];
	
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	g.player.shared_params._reset_to_center = NO;
	CGPoint last_pos = g.player.position;
	switch (_underwater_params._current_mode) {
		case PlayerUnderwaterCombatMode_TransitionIn:;
			[g set_zoom:drpt(g.get_zoom,1.1,1/20.0)];
			[g.player update_accel_x_position:g];
			g.player.position = ccp(g.player.position.x,clampf(g.player.position.y + _underwater_params._vel.y * dt_scale_get(),g.get_ground_depth,0));
			_underwater_params._camera_offset = cubic_interp(_underwater_params._initial_camera_offset, _underwater_params.DEFAULT_OFFSET, 0, 1, _underwater_params._anim_ct);
			[g set_camera_height:g.player.position.y + _underwater_params._camera_offset];
			_underwater_params._anim_ct += 0.025 * dt_scale_get();
			[g.player read_s_pos:g];
			if (_underwater_params._anim_ct >= 1) _underwater_params._current_mode = PlayerUnderwaterCombatMode_MainGame;
            
		break;
		case PlayerUnderwaterCombatMode_MainGame:;
			[g set_zoom:drpt(g.get_zoom,1,1/20.0)];
			
			if (_underwater_params._dashing) {
				[g.player play_anim:@"Spin" repeat:YES];
				if (!CGPointEqualToPoint(g.get_control_manager.get_post_swipe_drag, CGPointZero)) {
					float vel = CGPointDist(CGPointZero, _underwater_params._vel);
					Vec3D post_dir = vec_cons_norm(g.get_control_manager.get_post_swipe_drag.x, g.get_control_manager.get_post_swipe_drag.y, 0);
					Vec3D cur_dir = cgpoint_to_vec(_underwater_params._vel);
					Vec3D final_dir = vec_cons_norm(cur_dir.x+post_dir.x*2, cur_dir.y+post_dir.y*2, 0);
					vec_scale_m(&final_dir, vel);
					_underwater_params._vel = ccp(final_dir.x,final_dir.y);
				}
				
				_underwater_params._dash_ct -= dt_scale_get();
				if (_underwater_params._dash_ct <= 0) {
					_underwater_params._dashing = NO;
				}
				
			} else {
				[g.player play_anim:@"Swim" repeat:YES];
				_underwater_params._vel = ccp(_underwater_params._vel.x*powf(0.9, dt_scale_get()),_underwater_params._vel.y);
		
				if (g.get_control_manager.is_touch_down) {
					if (g.player.position.y == g.get_ground_depth) {
						_underwater_params._vel = ccp(_underwater_params._vel.x,0);
					} else {
						_underwater_params._vel = ccp(_underwater_params._vel.x,MAX(_underwater_params._vel.y-0.2*dt_scale_get(), -7));
					}
					
				} else {
					_underwater_params._vel = ccp(_underwater_params._vel.x,MIN(_underwater_params._vel.y+0.2*dt_scale_get(), 7));
				}
				
				if (g.get_control_manager.is_proc_swipe) {
					Vec3D swipe_dir = g.get_control_manager.get_proc_swipe_dir;
					float angle = rad_to_deg(vec_ang_rad(swipe_dir));
					float spd = 7;
					if (angle > 0 && ABS(ABS(angle)-90) < 90) {
						spd = lerp(7, 3.5, 1-ABS(ABS(angle)-90)/90.0);
						
					}
					_underwater_params._dashing = YES;
					_underwater_params._vel = vec_to_cgpoint(vec_scale(swipe_dir, spd));
					_underwater_params._dash_ct += 20;
                    [self proc_multiple_bubbles:g];
				}
			}
            
            [_bubble_every i_update:dt_scale_get()];
            if ([_bubble_every do_flash]) {
                (int_random(0, 4) == 0) ? [_bubble_every set_time:float_random(1, 3)] : [_bubble_every set_time:float_random(20, 40)];
                [self proc_bubble:g];
            }
            
            [g.player.shared_params set_breath:g.player.shared_params.get_current_breath-dt_scale_get()];
            if (g.player.shared_params.get_current_breath <= 0 || g.player.position.y > g.get_viewbox.y2) {
                [g.player pop_state_stack:g];
                [g.player push_state_stack:[DiveReturnPlayerStateStack cons:g waterparams:_underwater_params]];
                [self proc_multiple_bubbles:g];
            }
			
			if (g.get_control_manager.is_touch_down) {
				_underwater_params._camera_offset = drpt(_underwater_params._camera_offset, _underwater_params.DEFAULT_OFFSET, 1/15.0);
			} else {
				if (_underwater_params._vel.y < 0) {
					_underwater_params._camera_offset -= _underwater_params._vel.y;
				}
				if (_underwater_params._camera_offset > _underwater_params.MAX_OFFSET) {
					_underwater_params._camera_offset = drpt(_underwater_params._camera_offset, _underwater_params.MAX_OFFSET, 1/5.0);
				} else {
					_underwater_params._camera_offset = drpt(_underwater_params._camera_offset, _underwater_params.DEFAULT_OFFSET, 1/80.0);
				}
			}
			[g set_camera_height:MIN(g.player.position.y + _underwater_params._camera_offset, g.get_current_camera_center_y)];
			
			g.player.position = ccp(g.player.position.x,clampf(g.player.position.y + _underwater_params._vel.y * dt_scale_get(),g.get_ground_depth,0));
			[g.player read_s_pos:g];
			g.player.shared_params._s_pos = ccp(
				g.player.shared_params._s_pos.x+_underwater_params._vel.x*dt_scale_get(),
				g.player.shared_params._s_pos.y
			);
			[g.player update_accel_x_position:g];
			[g.player apply_s_pos:g];
			
			
		break;
	}
	
	float tar_rotation = vec_ang_deg_lim180(vec_cons(low_filter(g.player.position.x - last_pos.x,0.25),low_filter(g.player.position.y - last_pos.y,0.25), 0),90);
	g.player.rotation += shortest_angle(g.player.rotation, tar_rotation) * 0.25;
}

-(void)proc_multiple_bubbles:(GameEngineScene*)g {
    [self proc_bubble:g];
    DO_FOR(8,
        [g add_delayed_action:[DelayAction cons_in:float_random(0, 12) action:^(){
            CGPoint pos = CGPointAdd(g.player.position, ccp(float_random(-5, 5),float_random(-5, 5)));
            [g add_particle:[UnderwaterBubbleParticle cons_start:pos end:CGPointAdd(pos, ccp(0,100+float_random(-50, 50)))]];
        }]];
    );
}
-(void)proc_multiple_bubbles2:(GameEngineScene*)g {
    DO_FOR(25,
           [g add_delayed_action:[DelayAction cons_in:float_random(10, 35) action:^(){
        CGPoint pos = CGPointAdd(g.player.position, ccp(float_random(-25, 25),float_random(-25, 25)));
        [g add_particle:[UnderwaterBubbleParticle cons_start:pos end:CGPointAdd(pos, ccp(0,100+float_random(-50, 50)))]];
    }]];
    );
}
-(void)proc_bubble:(GameEngineScene*)g {
    [g add_particle:[UnderwaterBubbleParticle cons_start:g.player.position end:CGPointAdd(g.player.position, ccp(0,100+float_random(-80, 10)))]];
}

-(PlayerState)get_state {
	return PlayerState_Dive;
}

@end
