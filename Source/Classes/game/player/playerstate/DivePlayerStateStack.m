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

@implementation DivePlayerStateStack {
	PlayerUnderwaterCombatParams *_underwater_params;
}

+(DivePlayerStateStack*)cons:(GameEngineScene*)g {
	return [[[DivePlayerStateStack alloc] init] cons:g];
}

-(DivePlayerStateStack*)cons:(GameEngineScene*)g {
	_underwater_params = [[PlayerUnderwaterCombatParams alloc] init];
	
	_underwater_params._vy = -7;
	_underwater_params._tar_camera_offset = g.get_current_camera_center_y - g.player.position.y;
	_underwater_params._current_mode = PlayerUnderwaterCombatMode_TransitionIn;
	_underwater_params._anim_ct = 0;
	_underwater_params._remainder_camera_offset = 0;
	_underwater_params._initial_camera_offset = _underwater_params._tar_camera_offset;
	[g.player read_s_pos:g];
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	g.player.shared_params._reset_to_center = YES;
	[g.player play_anim:@"swim" repeat:YES];
	CGPoint last_pos = g.player.position;
	switch (_underwater_params._current_mode) {
		case PlayerUnderwaterCombatMode_TransitionIn:;
			[g set_zoom:drp(g.get_zoom,1.1,20)];
			[g.player update_accel_x_position:g];
			g.player.position = ccp(g.player.position.x,clampf(g.player.position.y + _underwater_params._vy * dt_scale_get(),g.get_ground_depth,0));
			_underwater_params._tar_camera_offset = cubic_interp(_underwater_params._initial_camera_offset, _underwater_params.DEFAULT_OFFSET, 0, 1, _underwater_params._anim_ct);
			[g set_camera_height:g.player.position.y + _underwater_params._tar_camera_offset];
			_underwater_params._anim_ct += 0.025 * dt_scale_get();
			[g.player read_s_pos:g];
			if (_underwater_params._anim_ct >= 1) _underwater_params._current_mode = PlayerUnderwaterCombatMode_MainGame;
			
		break;
		case PlayerUnderwaterCombatMode_MainGame:;
			[g set_zoom:drp(g.get_zoom,1,20)];
			[g.player update_accel_x_position:g];
			g.player.position = ccp(g.player.position.x,clampf(g.player.position.y + _underwater_params._vy * dt_scale_get(),g.get_ground_depth,0));
			if (g.get_control_manager.is_touch_down) {
				if (g.player.position.y == g.get_ground_depth) {
					_underwater_params._vy = 0;
				} else {
					_underwater_params._vy = MAX(_underwater_params._vy-0.2*dt_scale_get(), -7);
				}
				_underwater_params._tar_camera_offset = _underwater_params.DEFAULT_OFFSET;
				[g set_camera_height:MIN(g.player.position.y + _underwater_params._tar_camera_offset + _underwater_params._remainder_camera_offset, g.get_current_camera_center_y)];
				_underwater_params._remainder_camera_offset = drp(_underwater_params._remainder_camera_offset, 0, 20);
				
			} else {
				_underwater_params._vy = MIN(_underwater_params._vy+0.2*dt_scale_get(), 7);
				_underwater_params._remainder_camera_offset = - ((g.player.position.y + _underwater_params._tar_camera_offset)-g.get_current_camera_center_y);
			}
			if (g.player.position.y > g.get_viewbox.y2) {
				[g.player pop_state_stack:g];
				[g.player push_state_stack:[DiveReturnPlayerStateStack cons:g waterparams:_underwater_params]];
			}
			[g.player read_s_pos:g];
		break;
	}
	
	float tar_rotation = vec_ang_deg_lim180(vec_cons(low_filter(g.player.position.x - last_pos.x,0.25),low_filter(g.player.position.y - last_pos.y,0.25), 0),90);
	g.player.rotation += shortest_angle(g.player.rotation, tar_rotation) * 0.25;
}

-(PlayerState)get_state {
	return PlayerState_Dive;
}

@end
