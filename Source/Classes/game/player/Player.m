
#import "Player.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameEngineScene.h"
#import "GameMain.h"

#import "SpriterNode.h"
#import "SpriterJSONParser.h"
#import "SpriterData.h"

#import "PlayerProjectile.h"

#import "CCTexture_Private.h"
#import "ControlManager.h"

#import "AirEnemyManager.h"
#import "BasicAirEnemy.h"

#import "PlayerSharedParams.h"
#import "OnGroundPlayerStateStack.h"

#import "GameUI.h"

#import "ChainedMovementParticle.h"

@implementation Player {
	SpriterNode *_img;
	
	NSString *_current_playing;
	NSString *_on_finish_play_anim;
	
	PlayerSharedParams *_player_shared_params;
	NSMutableArray *_player_state_stack;
		
	float _current_health;
	int _max_health;
}

+(Player*)cons_g:(GameEngineScene*)g {
	return [[Player node] cons_g:g];
}
-(Player*)cons_g:(GameEngineScene*)g {
	_player_shared_params = [[PlayerSharedParams alloc] init];
	_player_state_stack = [NSMutableArray array];
	
	_img = [SpriterNode nodeFromData:[FileCache spriter_scml_data_from_file:@"hanokav2.scml" json:@"hanokav2.json" texture:[Resource get_tex:TEX_SPRITER_CHAR_HANOKA_V2]]];
	[self play_anim:@"idle" repeat:YES];
	[self addChild:_img z:1];
	
	//SPTODO
	//[self prep_initial_land_mode:g];
	[self push_state_stack:[IdlePlayerStateStack cons]];
	[self push_state_stack:[OnGroundPlayerStateStack cons:g]];
	
	[_img set_scale:0.25];
	
	_player_shared_params._calc_accel_x_pos = game_screen().width/2;
	_player_shared_params._reset_to_center = YES;
	
	_max_health = 3;
	_current_health = _max_health;
	
	return self;
}

-(void)pop_state_stack:(GameEngineScene*)g {
	if (_player_state_stack.count > 0) {
		BasePlayerStateStack *state_stack_top = [_player_state_stack objectAtIndex:0];
		[state_stack_top on_state_end:g];
		[_player_state_stack removeObjectAtIndex:0];
		
	}
}
-(void)push_state_stack:(BasePlayerStateStack*)item {
	[_player_state_stack insertObject:item atIndex:0];
}

-(void)set_health:(float)val { _current_health = val; }
-(void)add_health:(float)val g:(GameEngineScene*)g {
	_current_health += val;
	[g.get_ui pulse_heart_lastfill];
}
-(int)get_max_health { return _max_health; }
-(float)get_current_health { return _current_health; }

-(void)i_update:(GameEngineScene*)g {
	//SPTODO
	/*
	if (g.get_player_state == PlayerState_OnGround && _land_params._current_mode == PlayerLandMode_OnDock) {
		[self setZOrder:GameAnchorZ_Player];
	} else {
		[self setZOrder:GameAnchorZ_Player_Out];
	}
	*/
	
	if (!_img.current_anim_repeating && _img.current_anim_finished && _on_finish_play_anim != NULL) {
		[_img playAnim:_on_finish_play_anim repeat:YES];
		_on_finish_play_anim = NULL;
	}
	
	BasePlayerStateStack *state_stack_top = [_player_state_stack objectAtIndex:0];
	[state_stack_top i_update:g];
}

-(void)play_anim:(NSString*)anim repeat:(BOOL)repeat {
	_on_finish_play_anim = NULL;
	if(_current_playing != anim) {
		_current_playing = anim;
		[_img playAnim:anim repeat:repeat];
	}
}

-(void)play_anim:(NSString*)anim1 on_finish_anim:(NSString*)anim2 {
	_current_playing = anim1;
	[_img playAnim:anim1 repeat:NO];
	_on_finish_play_anim = anim2;
}

//mapped move direction+value
float accel_x_move_val(GameEngineScene *g, float from_val) {
	return clampf(
		((160 + g.get_control_manager.get_frame_accel_x_vel * 320) - from_val) * .07 ,
		-7 , 7)
		* dt_scale_get();
}
//move get next mapped accel position (TOFIX: MODIFIES FIELDS WHEN drps to center)
-(float)get_next_update_accel_x_position:(GameEngineScene*)g {
	float target_delta = accel_x_move_val(g, _player_shared_params._calc_accel_x_pos);
	_player_shared_params._calc_accel_x_pos += target_delta;
	if (_player_shared_params._reset_to_center) {
		_player_shared_params._s_pos = ccp(
			drp(_player_shared_params._s_pos.x, _player_shared_params._calc_accel_x_pos, 10),
			_player_shared_params._s_pos.y
		);
	}
	return clampf(
		_player_shared_params._reset_to_center?_player_shared_params._s_pos.x:_player_shared_params._s_pos.x + target_delta,
		0,
		game_screen().width
	);
}
//get how much next mapped accel will move
-(float)get_next_update_accel_x_position_delta:(GameEngineScene*)g {
	return accel_x_move_val(g,_player_shared_params._calc_accel_x_pos);
}
//move to next mapped accel position
-(void)update_accel_x_position:(GameEngineScene*)g {
	float x_pos = [self get_next_update_accel_x_position:g];
	_player_shared_params._s_pos = ccp(x_pos,_player_shared_params._s_pos.y);
	self.position = ccp(_player_shared_params._s_pos.x,self.position.y);
}

//set real position to value in _s_pos (screen position)
-(void)apply_s_pos:(GameEngineScene*)g {
	self.position = CGPointAdd(
		_player_shared_params._s_pos,
		ccp(g.get_viewbox.x1,g.get_viewbox.y1)
	);
}
//set _s_pos to current position
-(void)read_s_pos:(GameEngineScene*)g {
	_player_shared_params._s_pos = CGPointSub(
		self.position,
		ccp(g.get_viewbox.x1,g.get_viewbox.y1)
	);
}

-(PlayerSharedParams*)shared_params { return _player_shared_params; }
-(SpriterNode*)img { return _img; }

-(BOOL)is_underwater:(GameEngineScene *)g {
	return self.position.y < 0 && g._player_state != PlayerState_InAir;
}

-(PlayerLandParams*)getLandParams {
    return NULL;
}


-(CGPoint)get_size { return ccp(40,130); }
-(HitRect)get_hit_rect {
	return satpolyowner_cons_hit_rect(self.position, self.get_size.x, self.get_size.y);
}
-(void)get_sat_poly:(SATPoly*)in_poly {
	return satpolyowner_cons_sat_poly(in_poly, self.position, self.rotation, self.get_size.x, self.get_size.y, ccp(1,1));
}
@end
