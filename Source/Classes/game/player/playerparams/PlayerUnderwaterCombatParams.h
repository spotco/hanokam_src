//
//  PlayerUnderwaterCombatParams.h
//  hobobob
//
//  Created by spotco on 08/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Player.h"

typedef enum _PlayerUnderwaterCombatMode {
	PlayerUnderwaterCombatMode_TransitionIn,
	PlayerUnderwaterCombatMode_MainGame
} PlayerUnderwaterCombatMode;

@interface PlayerUnderwaterCombatParams : NSObject
@property(readwrite,assign) PlayerUnderwaterCombatMode _current_mode;
@property(readwrite,assign) CGPoint _vel;
@property(readwrite,assign) float _camera_offset, _anim_ct;
@property(readwrite,assign) float _initial_camera_offset;
@property(readwrite,assign) BOOL _dashing;
@property(readwrite,assign) float _dash_ct;

-(float)DEFAULT_OFFSET;
-(float)MAX_OFFSET;
@end