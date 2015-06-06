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
	float _anim_t;
	
	BOOL _is_dead;
	BOOL _is_stunned;
	float _stunned_anim_ct;
	float _death_anim_ct;
	float _stun_slow_scf;
}
@synthesize _rel_pos;

-(BasicAirEnemy*)cons_g:(GameEngineScene*)g relstart:(CGPoint)relstart relend:(CGPoint)relend  {
	_rel_start = relstart;
	_rel_end = relend;
	_rel_pos = _rel_start;
	[self update_rel_pos:g];
	_anim_t = 0;
	_death_anim_ct = 0;
	_stunned_anim_ct = 0;
	_is_dead = NO;
	_is_stunned = NO;
	return self;
}

-(int)get_stunned_anim_ct {
	return _stunned_anim_ct;
}

-(void)update_rel_pos:(GameEngineScene*)g {
	CGPoint lcorner = ccp(g.get_viewbox.x1,g.get_viewbox.y1);
	self.position = CGPointAdd(_rel_pos, lcorner);
}

-(void)i_update:(GameEngineScene *)game {
	if (_is_dead) {
		_death_anim_ct -= dt_scale_get();
		[self update_rel_pos:game];
		[self update_death:game];
		
	} else if (_is_stunned) {
		_stunned_anim_ct -= dt_scale_get();
		[self update_stunned:game];
		if (_stunned_anim_ct <= 0) {
			_is_stunned = NO;
		}
		
		
		
		_anim_t += 0.004 * dt_scale_get() * _stun_slow_scf;
		
		_stun_slow_scf = drp(_stun_slow_scf, 0, 10);
		
		if (_anim_t > 1) _is_dead = YES;
		CGPoint bez_ctrl1 = ccp(_rel_start.x,_rel_end.y + 100);
		CGPoint bez_ctrl2 = CGPointMid(bez_ctrl1, _rel_end);
		CGPoint next_rel_pos = bezier_point_for_t(_rel_start, bez_ctrl1, bez_ctrl2, _rel_end, _anim_t);
		Vec3D dir = vec_cons(next_rel_pos.x - _rel_pos.x, next_rel_pos.y - _rel_pos.y, 0);
		
		self.rotation = vec_ang_deg_lim180(dir,90);
		
		_rel_pos = next_rel_pos;
		[self update_rel_pos:game];
		
		
	} else {
		_stun_slow_scf = 1;
		_anim_t += 0.004 * dt_scale_get();
		if (_anim_t > 1) _is_dead = YES;
		CGPoint bez_ctrl1 = ccp(_rel_start.x,_rel_end.y + 100);
		CGPoint bez_ctrl2 = CGPointMid(bez_ctrl1, _rel_end);
		CGPoint next_rel_pos = bezier_point_for_t(_rel_start, bez_ctrl1, bez_ctrl2, _rel_end, _anim_t);
		Vec3D dir = vec_cons(next_rel_pos.x - _rel_pos.x, next_rel_pos.y - _rel_pos.y, 0);
		self.rotation = vec_ang_deg_lim180(dir,90);
		_rel_pos = next_rel_pos;
		[self update_rel_pos:game];
		[self update_alive:game];
	}
}

-(void)update_alive:(GameEngineScene*)g{}
-(void)update_death:(GameEngineScene*)g{}
-(void)update_stunned:(GameEngineScene *)g{};

-(BOOL)should_remove{ return _is_dead && _death_anim_ct <= 0; }
-(void)do_remove:(GameEngineScene *)g {}

-(void)hit_projectile:(GameEngineScene*)g { _is_stunned = YES; _stunned_anim_ct = 150; }
-(void)hit_player_melee:(GameEngineScene*)g { _is_dead = YES; _death_anim_ct = 50; }
-(BOOL)is_stunned{ return _is_stunned; }
-(BOOL)is_alive{ return !_is_dead; }

@end
