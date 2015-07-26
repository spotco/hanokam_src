//
//  DiveReturnPlayerState.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DiveReturnPlayerStateStack.h"
#import "PlayerUnderwaterCombatParams.h"
#import "InAirPlayerStateStack.h"
#import "GameEngineScene.h"
#import "UnderwaterBubbleParticle.h"
#import "FlashEvery.h"
#import "WaterEnemyManager.h"

typedef enum {
	DiveReturnPlayerStateStackMode_InitialZoomIn,
	DiveReturnPlayerStateStackMode_CameraPanUp,
	DiveReturnPlayerStateStackMode_PanUpToBreakThroughPause,
	DiveReturnPlayerStateStackMode_BreakThrough,
	DiveReturnPlayerStateStackMode_FollowUp
} DiveReturnPlayerStateStackMode;

@implementation DiveReturnPlayerStateStack {
	PlayerUnderwaterCombatParams *_underwater_params;
    FlashEvery *_bubble_every;
	
	float _anim_t;
	float _current_player_height;
	float _target_player_height;
	float _camera_drpt_speed;
	
	DiveReturnPlayerStateStackMode _current_mode;
}

+(DiveReturnPlayerStateStack*)cons:(GameEngineScene*)g waterparams:(PlayerUnderwaterCombatParams *)waterparams {
	return [[[DiveReturnPlayerStateStack alloc] init] cons:g waterparams:waterparams];
}

-(DiveReturnPlayerStateStack*)cons:(GameEngineScene*)g waterparams:(PlayerUnderwaterCombatParams *)waterparams {
	_underwater_params = waterparams;
    [g.player play_anim:@"Swim" repeat:YES];
    _bubble_every = [FlashEvery cons_time:4];
	[g.get_water_enemy_manager remove_all_unattracted_enemies:g];
	
	_anim_t = 0;
	_current_player_height = g.player.position.y + _underwater_params._camera_offset;
	_target_player_height = g.player.position.y + game_screen().height/2 + 50;
	_anim_t = 0;
	
	if (g.player.shared_params.get_current_breath <= 0) {
		_current_mode = DiveReturnPlayerStateStackMode_InitialZoomIn;
		[g blur_and_pulse];
	} else {
		_current_mode = DiveReturnPlayerStateStackMode_CameraPanUp;
	}
	
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	//popin ui messages for depth and enemies attracted
	switch (_current_mode) {
	case DiveReturnPlayerStateStackMode_InitialZoomIn: {
		[g set_camera_height:g.player.position.y + _underwater_params._camera_offset];
		_underwater_params._camera_offset = drpt(_underwater_params._camera_offset, 0, 1/12.0);
		[g set_zoom:drpt(g.get_zoom,2.0,1/10.0)];
		if (fuzzyeq(_underwater_params._camera_offset, 0, 5)) {
			_current_mode = DiveReturnPlayerStateStackMode_CameraPanUp;
			
		}
	}break;
	case DiveReturnPlayerStateStackMode_CameraPanUp: {
		_anim_t += 1/15.0 * dt_scale_get();
		_underwater_params._camera_offset = drpt(_underwater_params._camera_offset, 0, 1/6.0);
		[g set_zoom:drpt(g.get_zoom,1.0,1/10.0)];
		if (_anim_t < 1.0) {
			[g set_camera_height:lerp(_current_player_height,_target_player_height,bezier_point_for_t(ccp(0,0), ccp(0.2,0.2), ccp(0.8,1), ccp(1,1), _anim_t).y)];
			[g set_zoom:drpt(g.get_zoom,1,1/20.0)];
			[g.player read_s_pos:g];
			
		} else {
			_current_mode =  DiveReturnPlayerStateStackMode_PanUpToBreakThroughPause;
			_anim_t = 0;
			
		}
	} break;
	case DiveReturnPlayerStateStackMode_PanUpToBreakThroughPause: {
		[g.player setPosition:ccp(drpt(g.player.position.x, game_screen().width/2, 1/10.0),g.player.position.y)];
		[g.player read_s_pos:g];
		_anim_t += 0.05 * dt_scale_get();
		if (_anim_t >= 1) {
			g.player.rotation = 0;
			_current_mode = DiveReturnPlayerStateStackMode_BreakThrough;
			[g shake_for:20 distance:5];
		}
		
	}; break;
	case DiveReturnPlayerStateStackMode_BreakThrough: {
		
		_underwater_params._vel = ccp(0,15);
		g.player.position = ccp(g.player.position.x,g.player.position.y + _underwater_params._vel.y * dt_scale_get());
		[g.player read_s_pos:g];
		if (g.player.shared_params._s_pos.y > game_screen().height * 0.75) {
			_current_mode = DiveReturnPlayerStateStackMode_FollowUp;
			_camera_drpt_speed = 20;
		}
		
	} break;
	case DiveReturnPlayerStateStackMode_FollowUp: {
		[g.player update_accel_x_position:g];
		_underwater_params._vel = ccp(0,clampf(_underwater_params._vel.y+0.25*dt_scale_get(), 0, 30));
		[g set_zoom:drpt(g.get_zoom,1.5,1/20.0)];
		_underwater_params._camera_offset = drpt(_underwater_params._camera_offset, 0, 1/10.0);
		g.player.position = ccp(g.player.position.x,g.player.position.y + _underwater_params._vel.y * dt_scale_get());
		[g set_camera_height:drpt(g.get_current_camera_center_y,g.player.position.y + _underwater_params._camera_offset,1/_camera_drpt_speed)];
		_camera_drpt_speed = drpt(_camera_drpt_speed, 1, 1/20.0);
		
		[_bubble_every i_update:dt_scale_get()];
		if ([_bubble_every do_flash] && _underwater_params._vel.y > 10) {
			[self proc_bubble:g];
		}
		if (g.player.position.y > 0) {
			[g.player pop_state_stack:g];
			[g.player push_state_stack:[InAirPlayerStateStack cons:g]];
			
			[g.player play_anim:@"In Air Idle" repeat:YES];
			[g add_ripple:ccp(g.player.position.x,0)];
			[g.get_water_enemy_manager remove_all_enemies:g];
		}
		[g.player read_s_pos:g];
		
	}; break;
	}
}

-(void)proc_bubble:(GameEngineScene*)g {
    CGPoint pos = CGPointAdd(g.player.position, ccp(float_random(-10, 10),float_random(-15, 5)));
    [g add_particle:[UnderwaterBubbleParticle cons_start:pos end:CGPointAdd(pos, ccp(0,200))]];
}

-(PlayerUnderwaterCombatParams*)cond_get_underwater_combat_params {
	return _underwater_params;
}

-(PlayerState)get_state {
	return PlayerState_DiveReturn;
}

@end
