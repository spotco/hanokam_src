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
	CGPoint _stun_vel;
	
	float _stunned_anim_ct_max;
	float _anim_theta;
	float _stunned_anim_ct;
	float _last_move_rotation;
	
	float _idle_noticed_ct;
	
	float _pack_lr_theta;
	float _pack_ud_theta;
	float _pack_lr_vtheta, _pack_ud_vtheta;
	float _pack_cur_vel;
	float _pack_x_var,_pack_y_var;
	
	CGPoint _test_last_target;
}
-(BasicWaterEnemy*)cons_g:(GameEngineScene *)g pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	self._current_mode = BasicWaterEnemyMode_IdleMove;
	_pt1 = pt1;
	_pt2 = pt2;
	_last_pos = CGPointZero;
	[self setPosition:_pt1];
	_idle_move_anim_theta = float_random(-3.14,3.14);
	_pack_lr_theta = float_random(-3.14, 3.14);
	_pack_ud_theta = float_random(-3.14, 3.14);
	_pack_lr_vtheta = float_random(0.045, 0.065);
	_pack_ud_vtheta = float_random(0.03, 0.04);
	_pack_x_var = float_random(70, 200);
	_pack_y_var = float_random(70, 150);
	return self;
}

-(void)i_update:(GameEngineScene*)g {
	switch (g.get_player_state) {
	case PlayerState_DiveReturn:{
		[self i_update_divereturn:g];
	} break;
	case PlayerState_Dive:{
		[self i_update_dive:g];
	} break;
	default: break;
	}
	[self setVisible:hitrect_touch([self get_hit_rect], [g get_viewbox])];
}

-(void)i_update_dive:(GameEngineScene*)g {
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
		
		self.position = CGPointAdd(self.position, _stun_vel);
		_stun_vel = ccp(drpt(_stun_vel.x, 0, 1/10.0),drpt(_stun_vel.y, 0, 1/10.0));
		
		if (_stunned_anim_ct <= 0) {
			self._current_mode = BasicWaterEnemyMode_InPack;
		}
		
	} break;
	case BasicWaterEnemyMode_InPack:{
		self.rotation = drpt(self.rotation,vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(g.player.position, self.position)),0)-90,1/10.0);
		
		_pack_ud_theta += _pack_ud_vtheta * dt_scale_get();
		_pack_lr_theta += _pack_lr_vtheta * dt_scale_get();
		
		CGPoint target_pos = CGPointAdd(g.player.position, ccp( _pack_x_var*sinf(_pack_lr_theta), _pack_y_var*cosf(_pack_ud_theta) + _pack_y_var + 100 ));
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

-(void)i_update_divereturn:(GameEngineScene*)g {
	_pack_ud_theta += _pack_ud_vtheta * dt_scale_get();
	_pack_lr_theta += _pack_lr_vtheta * dt_scale_get();
	CGPoint target_pos = CGPointAdd(g.player.get_center, ccp( _pack_x_var*sinf(_pack_lr_theta), _pack_y_var*cosf(_pack_ud_theta)));
	
	Vec3D delta = vec_cons_norm(target_pos.x-self.position.x, target_pos.y-self.position.y, 0);
	_pack_cur_vel = MIN(drpt(_pack_cur_vel, 3*dt_scale_get(), 1/20.0),CGPointDist(target_pos, self.position));
	vec_scale_m(&delta, _pack_cur_vel);
	self.position = CGPointAdd(self.position, vec_to_cgpoint(delta));
	self.rotation = drpt(self.rotation,vec_ang_deg_lim180(cgpoint_to_vec(CGPointSub(self.position, _last_pos)),0)-90,1/4.0);
	_last_move_rotation = self.rotation;
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
		_stunned_anim_ct = _stunned_anim_ct_max = 50;
		
		Vec3D pos_delta = cgpoint_to_vec(CGPointSub(self.position, g.player.get_center));
		vec_norm_m(&pos_delta);
		pos_delta = vec_add(pos_delta, vec_cons(0, -0.5, 0));
		vec_scale_m(&pos_delta, 5);
		_stun_vel = vec_to_cgpoint(pos_delta);
		
		[BaseWaterEnemy particle_blood_effect:g pos:g.player.get_center ct:6];
	}
}

-(BOOL)is_attracted {
	return self._current_mode == BasicWaterEnemyMode_IdleNoticed || self._current_mode == BasicWaterEnemyMode_InPack || self._current_mode == BasicWaterEnemyMode_Stunned;
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
	return ccp(0,30);
}
@end
