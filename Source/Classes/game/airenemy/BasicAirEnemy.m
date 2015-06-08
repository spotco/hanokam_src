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
	float _stunned_anim_ct;
	float _death_anim_ct;
	float _stun_slow_scf;
	
	float _charged_arrow_hit_ct;
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
	return self;
}

-(void)i_update:(GameEngineScene *)g {
	_rel_offset.x += _rel_offset_vel.x * dt_scale_get();
	_rel_offset.y += _rel_offset_vel.y * dt_scale_get();
	_rel_offset_vel.x *= powf(0.9, dt_scale_get());
	_rel_offset_vel.y *= powf(0.9, dt_scale_get());
	
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
		[self update_stunned:g];
		
	} else {
		_stun_slow_scf = 1;
		[self ih_update_move:g];
		[self update_alive:g];
	}
}

-(void)ih_update_move:(GameEngineScene*)g {
	_anim_t += 0.004 * dt_scale_get() * _stun_slow_scf;
	if (_anim_t > 1) _is_dead = YES;
	CGPoint bez_ctrl1 = ccp(_rel_start.x,_rel_end.y + 100);
	CGPoint bez_ctrl2 = CGPointMid(bez_ctrl1, _rel_end);
	CGPoint next_rel_pos = bezier_point_for_t(_rel_start, bez_ctrl1, bez_ctrl2, _rel_end, _anim_t);
	Vec3D dir = vec_cons(next_rel_pos.x - _rel_pos.x, next_rel_pos.y - _rel_pos.y, 0);
	self.rotation = vec_ang_deg_lim180(dir,90);
	_rel_pos = next_rel_pos;
	[self update_rel_pos:g];
}

-(void)update_rel_pos:(GameEngineScene*)g {
	CGPoint lcorner = ccp(g.get_viewbox.x1,g.get_viewbox.y1);
	self.position = CGPointAdd(CGPointAdd(_rel_pos, lcorner),_rel_offset);
}

-(void)hit:(GameEngineScene*)g params:(PlayerHitParams*)params {
	float force = params->_pushback_force * 2.5;
	switch (params->_type) {
	case PlayerHitType_Melee:;
		_is_dead = YES;
		_death_anim_ct = 50;
		_rel_offset_vel = CGPointAdd(_rel_offset_vel,ccp(params->_dir.x*force,params->_dir.y*force));
		
	break;
	case PlayerHitType_Projectile:;
		_is_stunned = YES;
		_stunned_anim_ct = 150;
		_rel_offset_vel = CGPointAdd(_rel_offset_vel,ccp(params->_dir.x*force,params->_dir.y*force));
		
	break;
	case PlayerHitType_ChargedProjectile:;
		_is_stunned = YES;
		_stunned_anim_ct = 150;
		_rel_offset_vel = CGPointAdd(_rel_offset_vel,ccp(params->_dir.x*force,params->_dir.y*force));
		_charged_arrow_hit_ct+=dt_scale_get();
		if (_charged_arrow_hit_ct > 15) {
			_is_dead = YES;
			_death_anim_ct = 50;
		}
	break;
	}
}

-(BOOL)should_remove{
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
