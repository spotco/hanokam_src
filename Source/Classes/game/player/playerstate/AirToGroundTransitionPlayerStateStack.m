//
//  AirToGroundTransitionPlayerStateStack.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AirToGroundTransitionPlayerStateStack.h"
#import "PlayerLandParams.h"
#import "OnGroundPlayerStateStack.h"

@implementation AirToGroundTransitionPlayerStateStack {
	PlayerLandParams *_land_params;
}

+(AirToGroundTransitionPlayerStateStack*)cons:(GameEngineScene*)g {
	return [[[AirToGroundTransitionPlayerStateStack alloc] init] cons:g];
}

-(AirToGroundTransitionPlayerStateStack*)cons:(GameEngineScene*)g {
	_land_params = [[PlayerLandParams alloc] init];
	
	[g.player set_health:0];
	[g.player add_health:0.25 g:g];
	[g imm_set_camera_hei:0];
	g.player.position = ccp(g.player.position.x,300);
	g.player.rotation = 0;
	_land_params._vel = ccp(0,0);
	_land_params._current_mode = PlayerLandMode_AirToGround_FadeIn;
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	g.player.shared_params._reset_to_center = NO;
	CGPoint last_pos = g.player.position;
	[g.player update_accel_x_position:g];
	[g set_zoom:drp(g.get_zoom,1.2,20)];
	switch (_land_params._current_mode) {
		case PlayerLandMode_AirToGround_FadeIn:;
			[g.get_ui fadeout:NO];
			if (g.get_ui.is_faded_in) _land_params._current_mode = PlayerLandMode_AirToGround_FallToWater;
			
		case PlayerLandMode_AirToGround_FallToWater:;
			[g.player play_anim:@"Fall" repeat:YES];
			_land_params._vel = ccp(_land_params._vel.x,_land_params._vel.y - 0.3 * dt_scale_get());
			g.player.position = CGPointAdd(g.player.position, ccp(0,_land_params._vel.y*dt_scale_get()));
			[g set_camera_height:drp(g.get_current_camera_center_y,0,20)];
			if (g.player.position.y < 0) {
			
				_land_params._current_mode = PlayerLandMode_AirToGround_WaterDiveUp;
				[g add_ripple:ccp(g.player.position.x,0)];
				[g shake_slow_for:100 distance:10];
			}
			
		break;
		case PlayerLandMode_AirToGround_WaterDiveUp:;
			[g.player play_anim:@"Swim" repeat:YES];
			_land_params._vel = ccp(_land_params._vel.x,_land_params._vel.y + 0.4 * dt_scale_get());
			g.player.position = CGPointAdd(g.player.position, ccp(0,_land_params._vel.y*dt_scale_get()));
			if (g.player.position.y > 0) {
				[g add_ripple:ccp(g.player.position.x,0)];
				_land_params._current_mode = PlayerLandMode_AirToGround_FlipToDock;
			}
			[g set_camera_height:drp(g.get_current_camera_center_y,-50,20)];
			float tar_rotation = vec_ang_deg_lim180(vec_cons(g.player.position.x - last_pos.x,g.player.position.y - last_pos.y, 0),90);
			g.player.rotation += shortest_angle(g.player.rotation, tar_rotation) * 0.25;
		
		break;
		case PlayerLandMode_AirToGround_FlipToDock:;
			[g.player play_anim:@"Spin" repeat:YES];
			_land_params._vel = ccp(_land_params._vel.x,_land_params._vel.y - 0.4 * dt_scale_get());
			g.player.position = CGPointAdd(g.player.position, ccp(0,_land_params._vel.y*dt_scale_get()));
			if (_land_params._vel.y < 0 && g.player.position.y < g.DOCK_HEIGHT) {
				[g.player pop_state_stack:g];
				[g.player push_state_stack:[OnGroundPlayerStateStack cons:g]];
				return;
			}
			[g set_camera_height:drp(g.get_current_camera_center_y,30,20)];
			
		break;
		default:;
	}
}

-(PlayerState)get_state {
	return PlayerState_AirToGroundTransition;
}
@end
