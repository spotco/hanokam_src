//
//  PlayerAirCombatParams.m
//  hobobob
//
//  Created by spotco on 08/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerAirCombatParams.h"
#import "GameEngineScene.h" 

@implementation PlayerAirCombatParams
@synthesize _s_vel;
@synthesize _w_camera_center, _w_upwards_vel, _anim_ct;
@synthesize _current_mode;
@synthesize _sword_out;
@synthesize _dashing;
@synthesize _dash_ct, _arrow_last_fired_ct;
@synthesize  __rescue_last_waypoint_ct;
@synthesize _hold_ct;
-(float)DEFAULT_HEIGHT { return game_screen().height * 0.8; }
-(float)ARROW_AIM_TIME { return 30; }

-(BOOL)is_hittable {
	return _current_mode == PlayerAirCombatMode_Combat && self._invuln_ct <= 0;
}
@end
