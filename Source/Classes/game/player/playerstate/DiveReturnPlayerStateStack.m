//
//  DiveReturnPlayerState.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DiveReturnPlayerStateStack.h"
#import "PlayerUnderwaterCombatParams.h"

@implementation DiveReturnPlayerStateStack {
	PlayerUnderwaterCombatParams *_underwater_params;
}

+(DiveReturnPlayerStateStack*)cons:(GameEngineScene*)g waterparams:(PlayerUnderwaterCombatParams *)waterparams {
	return [[[DiveReturnPlayerStateStack alloc] init] cons:g waterparams:waterparams];
}

-(DiveReturnPlayerStateStack*)cons:(GameEngineScene*)g waterparams:(PlayerUnderwaterCombatParams *)waterparams  {
	_underwater_params = waterparams;
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	g.player.shared_params._reset_to_center = YES;
	CGPoint last_pos = g.player.position;

	[g.player update_accel_x_position:g];
	_underwater_params._tar_camera_offset = drp(_underwater_params._tar_camera_offset, 0, 10);
	_underwater_params._remainder_camera_offset = drp(_underwater_params._remainder_camera_offset, 0, 10);
	_underwater_params._vy = MIN(_underwater_params._vy+0.6*dt_scale_get(), 14);
	g.player.position = ccp(g.player.position.x,g.player.position.y + _underwater_params._vy * dt_scale_get());
	
	float tar_rotation = vec_ang_deg_lim180(vec_cons(g.player.position.x - last_pos.x,g.player.position.y - last_pos.y, 0),90) + 15;
	g.player.rotation += shortest_angle(g.player.rotation, tar_rotation) * 0.25;
	if (g.player.position.y > 0) {
		//SPTODO
		//[g.player prep_water_to_air_mode:g];
		[g.player play_anim:@"in air" repeat:YES];
		[g add_ripple:ccp(g.player.position.x,0)];
	}
	[g.player read_s_pos:g];
	[g set_camera_height:g.player.position.y + _underwater_params._tar_camera_offset + _underwater_params._remainder_camera_offset];
	[g set_zoom:drp(g.get_zoom,1.5,20)];
}

-(PlayerState)get_state {
	return PlayerState_DiveReturn;
}

@end
