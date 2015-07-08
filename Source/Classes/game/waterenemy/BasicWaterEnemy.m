//
//  BasicWaterEnemy.m
//  hanokam
//
//  Created by spotco on 01/07/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasicWaterEnemy.h"
#import "GameEngineScene.h" 
#import "Player.h"
#import "EnemyNoticeParticle.h"
#import "PlayerUnderwaterCombatParams.h"
#import "BasePlayerStateStack.h"

@implementation BasicWaterEnemy {
	CGPoint _pt1, _pt2;
	float _idle_move_anim_theta;
	CGPoint _last_pos;
	
	float _stunned_anim_ct_max;
	float _anim_theta;
	float _stunned_anim_ct;
	float _last_move_rotation;
	
	float _idle_noticed_ct;
	
	float _pack_lr_theta;
	float _pack_ud_theta;
	float _pack_lr_vtheta, _pack_ud_vtheta;
	float _pack_cur_vel;
	
	BOOL _divereturn_has_set_target_offset;
	CGPoint _divereturn_target_offset;
}
-(BasicWaterEnemy*)cons_g:(GameEngineScene *)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	self._current_mode = BasicWaterEnemyMode_IdleMove;
	_pt1 = pt1;
	_pt2 = pt2;
	_last_pos = CGPointZero;
	[self setPosition:_pt1];
	_idle_move_anim_theta = float_random(-3.14,3.14);
	
	_divereturn_has_set_target_offset = NO;
	return self;
}
-(void)i_update:(GameEngineScene*)g {

	if (g.get_player_state == PlayerState_DiveReturn) {
		if (!_divereturn_has_set_target_offset) {
			_pack_cur_vel = 0;
			if (ABS(self.position.x - g.player.position.x) < 50) {
				_divereturn_target_offset.x = (self.position.x > g.player.position.x) ? float_random(50, 100) : float_random(-100, -50);
			} else {
				_divereturn_target_offset.x = self.position.x - g.player.position.x;
			}
			_divereturn_target_offset.y = float_random(-50, 150);
			_divereturn_has_set_target_offset = YES;
		}
		
		CGPoint target_pos = ccp(g.player.position.x + _divereturn_target_offset.x, MAX(self.position.y,g.player.position.y+_divereturn_target_offset.y));
		Vec3D delta = vec_cons_norm(target_pos.x-self.position.x, target_pos.y-self.position.y, 0);
		_pack_cur_vel = MIN(drpt(_pack_cur_vel, 4*dt_scale_get(), 1/20.0),CGPointDist(target_pos, self.position));
		vec_scale_m(&delta, _pack_cur_vel);
		self.position = CGPointAdd(self.position, vec_to_cgpoint(delta));
		
		self.rotation = drpt(self.rotation,vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(g.player.position, self.position)),0)-90,1/10.0);
		return;
	}

	switch (self._current_mode) {
	case BasicWaterEnemyMode_IdleMove:{
		_idle_move_anim_theta += 0.025 * dt_scale_get();
		[self setPosition:lerp_point(_pt1, _pt2, (sinf(_idle_move_anim_theta)+1)/2.0)];
		if (g.player.position.y <= self.position.y + 100) {
			self._current_mode = BasicWaterEnemyMode_IdleNoticed;
			[g add_particle:[EnemyNoticeParticle cons_pos:CGPointAdd(self.position,[self notice_anim_offset]) g:g target:self]];
			_idle_noticed_ct = 40;
		}
		self.rotation = drpt(self.rotation,vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(self.position, _last_pos)),0)-90,1/10.0);
		[self check_hit:g];
		_last_move_rotation = self.rotation;
		
	} break;
	case BasicWaterEnemyMode_IdleNoticed:{
		self.rotation = drpt(self.rotation,vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(g.player.position, self.position)),0)-90,1/10.0);
		_idle_noticed_ct -= dt_scale_get();
		if (_idle_noticed_ct <= 0) {
			self._current_mode = BasicWaterEnemyMode_InPack;
			[self set_inpack_start_random_vars];
		}
		[self check_hit:g];
		_last_move_rotation = self.rotation;
		
	} break;
	case BasicWaterEnemyMode_Stunned:{
		_stunned_anim_ct -= dt_scale_get();
		
		_anim_theta = fmodf(_anim_theta + dt_scale_get() / (3.14 * 2),3.14*2);
		self.rotation =
			_last_move_rotation
				+ lerp(30, 5, 1-_stunned_anim_ct/_stunned_anim_ct_max)
				* sin(_anim_theta * lerp(1,7,1-_stunned_anim_ct/_stunned_anim_ct_max));
		
		if (_stunned_anim_ct <= 0) {
			[self set_inpack_start_random_vars];
			self._current_mode = BasicWaterEnemyMode_InPack;
		}
		
	} break;
	case BasicWaterEnemyMode_InPack:{
		self.rotation = drpt(self.rotation,vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(g.player.position, self.position)),0)-90,1/10.0);
		
		_pack_ud_theta += _pack_ud_vtheta * dt_scale_get();
		_pack_lr_theta += _pack_lr_vtheta * dt_scale_get();
		
		CGPoint target_pos = CGPointAdd(g.player.position, ccp( 90*sinf(_pack_lr_theta), 70*sinf(_pack_ud_theta) + 150 ));
		Vec3D delta = vec_cons_norm(target_pos.x-self.position.x, target_pos.y-self.position.y, 0);
		_pack_cur_vel = MIN(drpt(_pack_cur_vel, 10*dt_scale_get(), 1/20.0),CGPointDist(target_pos, self.position));
		vec_scale_m(&delta, _pack_cur_vel);
		self.position = CGPointAdd(self.position, vec_to_cgpoint(delta));
		[self check_hit:g];
		_last_move_rotation = self.rotation;
	}
	default:break;
	}
	_last_pos = self.position;
}

-(void)set_inpack_start_random_vars {
	_pack_lr_theta = float_random(-3.14, 3.14);
	_pack_ud_theta = float_random(-3.14, 3.14);
	_pack_lr_vtheta = float_random(0.045, 0.065);
	_pack_ud_vtheta = float_random(0.03, 0.04);
}

-(void)check_hit:(GameEngineScene*)g {
	PlayerUnderwaterCombatParams *underwater_params = g.player.get_top_state.cond_get_underwater_combat_params;
	if ([self is_active:g] && underwater_params._current_mode == PlayerUnderwaterCombatMode_MainGame && SAT_polyowners_intersect(g.player, self)) {
		self._current_mode = BasicWaterEnemyMode_Stunned;
		if (underwater_params._dashing) {
			[g.get_event_dispatcher push_event:[[GEvent cons_context:g type:GEventType_PlayerHitEnemyDash] set_target:self]];
			
		} else {
			[g.get_event_dispatcher push_event:[[GEvent cons_context:g type:GEventType_PlayerTouchEnemy] set_target:self]];
			
		}
		_stunned_anim_ct = _stunned_anim_ct_max = 30;
	}
}

-(BOOL)is_active:(GameEngineScene*)g {
	return self._current_mode == BasicWaterEnemyMode_IdleMove || self._current_mode == BasicWaterEnemyMode_IdleNoticed || self._current_mode == BasicWaterEnemyMode_InPack;
}


-(BOOL)should_remove {
	return NO;
}
-(void)do_remove:(GameEngineScene*)g {
	
}
-(float)get_stunned_anim_ct { return _stunned_anim_ct; }
-(CGPoint)notice_anim_offset {
	return ccp(0,40);
}
@end
