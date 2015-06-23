//
//  BasicAirEnemy.m
//  hobobob
//
//  Created by spotco on 08/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "BasicAirEnemy.h"
#import "Resource.h" 
#import "FileCache.h"
#import "GameEngineScene.h"
#import "Common.h"
#import "Vec3D.h"

@implementation BasicAirEnemy {
	CGPoint _rel_start,_rel_end;
	CGPoint _rel_offset, _rel_offset_vel;
	float _anim_t;
	
	BOOL _is_dead;
	BOOL _is_stunned;
	float _stunned_anim_ct, _stunned_anim_ct_max, _last_move_rotation;
	float _death_anim_ct;
	float _stun_slow_scf;
	
	float _charged_arrow_hit_ct;
	
	long _last_hit_chargedprojectile_id;
	float _anim_theta;
	
	float _health, _health_max;
}
@synthesize _rel_pos;

-(BasicAirEnemy*)cons_g:(GameEngineScene*)g relstart:(CGPoint)relstart relend:(CGPoint)relend  {
	_rel_start = relstart;
	_rel_end = relend;
	_rel_pos = _rel_start;
	_rel_offset = CGPointZero;
	_rel_offset_vel = CGPointZero;
	[self update_rel_pos:g];
	_anim_t = 0;
	_death_anim_ct = 0;
	_stunned_anim_ct = 0;
	_is_dead = NO;
	_is_stunned = NO;
	_health = _health_max = 10;
	return self;
}
-(float)get_health_pct { return clampf(_health/_health_max,0,1); }
-(BOOL)should_show_health_bar { return _health < _health_max; }

-(void)i_update:(GameEngineScene *)g {
	CGPoint scaled_rel_vel = ccp(_rel_offset_vel.x * dt_scale_get(),_rel_offset_vel.y * dt_scale_get());
	CGPoint neu_rel_offset = CGPointAdd(_rel_offset, scaled_rel_vel);
	if (![self rel_offset:neu_rel_offset is_out_of_view:g]) {
		_rel_offset = neu_rel_offset;
	}
	_rel_offset_vel.x *= powf(0.9, dt_scale_get());
	_rel_offset_vel.y *= powf(0.9, dt_scale_get());
	
	_anim_theta = fmodf(_anim_theta + dt_scale_get() / (3.14 * 2),3.14*2);
	
	if (_is_dead) {
		_death_anim_ct -= dt_scale_get();
		[self update_rel_pos:g];
		[self update_death:g];
		
	} else if (_is_stunned) {
		_stunned_anim_ct -= dt_scale_get();
		if (_stunned_anim_ct <= 0) {
			_is_stunned = NO;
		}
		_stun_slow_scf *= powf(0.9, dt_scale_get());
		[self ih_update_move:g];
		self.rotation =
			_last_move_rotation
				+ lerp(30, 5, 1-_stunned_anim_ct/_stunned_anim_ct_max)
				* sin(_anim_theta * lerp(1,7,1-_stunned_anim_ct/_stunned_anim_ct_max));
		
		[self update_stunned:g];
		
	} else {
		_stun_slow_scf = 1;
		[self ih_update_move:g];
		_last_move_rotation = self.rotation;
		[self update_alive:g];
	}
}

-(void)ih_update_move:(GameEngineScene*)g {
	_anim_t += 0.004 * dt_scale_get() * _stun_slow_scf;
	CGPoint bez_ctrl1 = ccp(_rel_start.x,_rel_end.y + 100);
	CGPoint bez_ctrl2 = CGPointMid(bez_ctrl1, _rel_end);
	
	if (_anim_t < 1) {
		CGPoint next_rel_pos = bezier_point_for_t(_rel_start, bez_ctrl1, bez_ctrl2, _rel_end, _anim_t);
		Vec3D dir = vec_cons(next_rel_pos.x - _rel_pos.x, next_rel_pos.y - _rel_pos.y, 0);
		self.rotation += shortest_angle(self.rotation, vec_ang_deg_lim180(dir,90)) * 0.25;
		
		_rel_pos = next_rel_pos;
		[self update_rel_pos:g];
		
	} else {
		CGPoint end_m_delta = bezier_point_for_t(_rel_start, bez_ctrl1, bez_ctrl2, _rel_end, 1.0-0.004);
		Vec3D end_tangent = vec_cons_norm(_rel_end.x-end_m_delta.x, _rel_end.y-end_m_delta.y, 0);
		vec_scale_m(&end_tangent, CGPointDist(_rel_end, end_m_delta) * dt_scale_get());
		_rel_pos = CGPointAdd(_rel_pos, vec_to_cgpoint(end_tangent));
		[self update_rel_pos:g];
		
		BOOL off_screen = self.position.x < -50 || self.position.x > game_screen().width + 50 || self.position.y < g.get_viewbox.y1 - 50 || self.position.y > g.get_viewbox.y2 + 50;
		
		if (off_screen) {
			_is_dead = YES;
			_death_anim_ct = 0;
		}
		
	}
}

-(void)update_rel_pos:(GameEngineScene*)g {
	CGPoint lcorner = ccp(g.get_viewbox.x1,g.get_viewbox.y1);
	self.position = CGPointAdd(CGPointAdd(_rel_pos, lcorner),_rel_offset);
}

-(BOOL)rel_offset:(CGPoint)rel_offset is_out_of_view:(GameEngineScene*)g {
	CGPoint lcorner = ccp(g.get_viewbox.x1,g.get_viewbox.y1);
	CGPoint calc_pos = CGPointAdd(CGPointAdd(_rel_pos, lcorner),rel_offset);
	return calc_pos.x < 15 || calc_pos.x > game_screen().width - 15 || calc_pos.y < lcorner.y + 15 || calc_pos.y > lcorner.y+game_screen().height - 15;
}

-(void)hit:(GameEngineScene*)g params:(PlayerHitParams*)params {
	float force = params->_pushback_force * 2.5;
	switch (params->_type) {
	case PlayerHitType_Melee:;
		_health -= 10;
		_rel_offset_vel = CGPointAdd(_rel_offset_vel,ccp(params->_dir.x*force,params->_dir.y*force));
		
	break;
	case PlayerHitType_Projectile:;
		_is_stunned = YES;
		_health -= 1;
		_stunned_anim_ct = _stunned_anim_ct_max = 150;
		_rel_offset_vel = CGPointAdd(_rel_offset_vel,ccp(params->_dir.x*force,params->_dir.y*force));
		
	break;
	case PlayerHitType_ChargedProjectile:;
		if (_last_hit_chargedprojectile_id == params->_id) {
			_charged_arrow_hit_ct+=dt_scale_get();
		} else {
			_charged_arrow_hit_ct = 0;
			_health -= 2;
		}
		_last_hit_chargedprojectile_id = params->_id;
			
		_is_stunned = YES;
		_stunned_anim_ct = _stunned_anim_ct_max = 150;
		if (_charged_arrow_hit_ct < 15) {
			_rel_offset_vel = CGPointAdd(_rel_offset_vel,ccp(params->_dir.x*force,params->_dir.y*force));
		}
	break;
	}
	
	if (_health <= 0) {
		_is_dead = YES;
		_death_anim_ct = 50;
	}
}

-(BOOL)should_remove {
	return _is_dead && _death_anim_ct <= 0;
}

-(int)get_stunned_anim_ct {
	return _stunned_anim_ct;
}
-(int)get_death_anim_ct {
	return _death_anim_ct;
}

-(void)update_alive:(GameEngineScene*)g{}
-(void)update_death:(GameEngineScene*)g{}
-(void)update_stunned:(GameEngineScene *)g{};

-(void)do_remove:(GameEngineScene *)g {
}

-(BOOL)is_stunned{
	return _is_stunned;
}
-(BOOL)is_alive{
	return !_is_dead;
}

@end
