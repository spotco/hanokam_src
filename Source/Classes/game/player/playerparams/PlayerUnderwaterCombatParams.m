//
//  PlayerUnderwaterCombatParams.m
//  hobobob
//
//  Created by spotco on 08/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlayerUnderwaterCombatParams.h"

@implementation PlayerUnderwaterCombatParams
@synthesize _current_mode;
@synthesize _vel;
@synthesize _camera_offset;
@synthesize _dash_ct;
@synthesize _dashing;

@synthesize _initial_camera_offset;
-(float)DEFAULT_OFFSET {
	return -game_screen().height * 0.3;
}
-(float)MAX_OFFSET {
	return -game_screen().height * 0.1;
}
@end
