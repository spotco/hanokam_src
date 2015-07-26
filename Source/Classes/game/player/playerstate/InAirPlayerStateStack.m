//
//  InAirPlayerStateStack.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "InAirPlayerStateStack.h"
#import "PlayerAirCombatParams.h"
#import "Arrow.h"
#import "ChargedArrow.h"
#import "AirEnemyManager.h"
#import "ChainedMovementParticle.h"
#import "AirToGroundTransitionPlayerStateStack.h"
#import "RotateFadeOutParticle.h"
#import "SwordSlashParticle.h"
#import "TouchTrackingLayer.h"
#import "FlashEvery.h"
#import "GEventDispatcher.h"
#import "SPCCTimedSpriteAnimator.h"

@implementation InAirPlayerStateStack {
	PlayerAirCombatParams *_air_params;
	ChainedMovementParticle *_rescue_anim;
	FlashEvery *_arrow_restore_tick;
	
	float _initial_s_pos_y;
}
+(InAirPlayerStateStack*)cons:(GameEngineScene*)g {
	return [[[InAirPlayerStateStack alloc] init] cons:g];
}

-(InAirPlayerStateStack*)cons:(GameEngineScene*)g {
	_air_params = [[PlayerAirCombatParams alloc] init];
	_air_params._w_camera_center = [g get_current_camera_center_y];
	_air_params._w_upwards_vel = 6;
	_air_params._s_vel = ccp(0,0);
	_air_params._current_mode = PlayerAirCombatMode_InitialJumpOut;
	_air_params._anim_ct = 0;
	_air_params._sword_out = NO;
	_air_params._hold_ct = 0;
	_air_params._invuln_ct = 0;
	_air_params._target_rotation = 0;
	_arrow_restore_tick = [FlashEvery cons_time:3];
	_initial_s_pos_y = g.player.shared_params._s_pos.y;
    [g.player.shared_params set_health:g.player.shared_params.get_max_health];
	
	[g.get_event_dispatcher add_listener:self];
	[g blur_and_pulse];
	[g shake_for:10 distance:5];
	return self;
}

-(void)on_state_end:(GameEngineScene *)g {
	_rescue_anim = NULL;
	[g.get_event_dispatcher remove_listener:self];
}

-(PlayerAirCombatParams*)cond_get_inair_combat_params { return _air_params; }

-(void)dispatch_event:(GEvent *)e {
	GameEngineScene *g = e.context;
	switch (e.type) {
	case GEventType_BulletHitPlayer: {
		[g.player.shared_params add_health:-0.5 g:g];
		[g.get_event_dispatcher push_event:[GEvent cons_context:g type:GEventType_PlayerTakeDamage]];
		[g.player play_anim:@"In Air Hurt" on_finish_anim:@"In Air Idle"];
		[BaseAirEnemy particle_blood_effect:g pos:g.player.position ct:6];
		_air_params._s_vel = ccp(_air_params._s_vel.x,5);
		_air_params._w_upwards_vel = 4;
		_air_params._sword_out = NO;
		_air_params._invuln_ct = 30;
		[g shake_for:10 distance:5];
	}
	break;
	case GEventType_PlayerHitEnemySword: {
		BaseAirEnemy *itr = e.target;
	
		_air_params._w_upwards_vel = 4;
		_air_params._sword_out = NO;
		_air_params._s_vel = ccp(_air_params._s_vel.x,10);
		_air_params._sword_out = NO;
		_air_params._dashing = YES;
		_air_params._dash_ct += 15;
		{
			RotateFadeOutParticle *neu_particle = [RotateFadeOutParticle cons_tex:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:CGRectZero];
			SPCCTimedSpriteAnimator *neu_particle_animator = [SPCCTimedSpriteAnimator cons_target:neu_particle];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_hit_000.png"] at_time:0];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_hit_001.png"] at_time:0.2];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_hit_002.png"] at_time:0.4];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_hit_003.png"] at_time:0.6];
			[neu_particle_animator add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"sword_plant_hit_004.png"] at_time:0.8];
			[neu_particle set_timed_sprite_animator:neu_particle_animator];
			[neu_particle set_ctmax:15];
			[neu_particle set_render_ord:GameAnchorZ_PlayerAirEffects];
			[neu_particle setAnchorPoint:ccp(0.5,0.3)];
			[neu_particle set_pos:g.player.position];
			[neu_particle set_scale_min:0.3 max:0.15];
			[g add_particle:neu_particle];
		}
		{
			RotateFadeOutParticle *neu_particle2 = [RotateFadeOutParticle cons_tex:[Resource get_tex:TEX_EFFECTS_HANOKA] rect:CGRectZero];
			SPCCTimedSpriteAnimator *neu_particle_animator2 = [SPCCTimedSpriteAnimator cons_target:neu_particle2];
			[neu_particle_animator2 add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"stab_000.png"] at_time:0];
			[neu_particle_animator2 add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"stab_001.png"] at_time:0.3];
			[neu_particle_animator2 add_frame:[FileCache get_cgrect_from_plist:TEX_EFFECTS_HANOKA idname:@"stab_002.png"] at_time:0.6];
			[neu_particle2 set_timed_sprite_animator:neu_particle_animator2];
			[neu_particle2 set_ctmax:13];
			[neu_particle2 set_render_ord:GameAnchorZ_PlayerAirEffects];
			[neu_particle2 set_pos:g.player.position];
			[neu_particle2 set_scale_min:0.275 max:0.1];
			[g add_particle:neu_particle2];
		}
		
		[BaseAirEnemy particle_blood_effect:g pos:itr.position ct:10];
		[g shake_for:10 distance:5];
	}
	break;
	case GEventType_PlayerHitEnemyDash: {
		CCNode *itr = e.target;
		
		_air_params._dashing = YES;
		_air_params._dash_ct = MIN(_air_params._dash_ct+16,40);
		_air_params._w_upwards_vel = 2;
		if ([itr isKindOfClass:[BaseAirEnemy class]]) {
			[g add_particle:[[SwordSlashParticle cons_pos:itr.position dir:vec_cons_norm(_air_params._s_vel.x, _air_params._s_vel.y, 0)] show_blood]];
		} else {
			[g add_particle:[SwordSlashParticle cons_pos:itr.position dir:vec_cons_norm(_air_params._s_vel.x, _air_params._s_vel.y, 0)]];
		}
		
		_air_params._invuln_ct = MAX(_air_params._invuln_ct,5);
		[BaseAirEnemy particle_blood_effect:g pos:itr.position ct:6];
		[g shake_for:10 distance:5];
	}
	break;
	case GEventType_PlayerTouchEnemy: {
		BaseAirEnemy *itr = e.target;
		if (!itr.is_stunned) {
			[g.player.shared_params add_health:-0.5 g:g];
			[g.get_event_dispatcher push_event:[GEvent cons_context:g type:GEventType_PlayerTakeDamage]];
			[g.player play_anim:@"In Air Hurt" on_finish_anim:@"In Air Idle"];
			
			[BaseAirEnemy particle_blood_effect:g pos:g.player.position ct:6];
		}
		_air_params._s_vel = ccp(_air_params._s_vel.x,5);
		_air_params._w_upwards_vel = 4;
		_air_params._sword_out = NO;
		_air_params._invuln_ct = 30;
		[g shake_for:10 distance:5];
	}
	break;
	default:;
	break;
	}
}

-(void)i_update:(GameEngineScene *)g {
	g.player.rotation += shortest_angle(g.player.rotation, _air_params._target_rotation) * powf(0.75, dt_scale_get());
	g.player.shared_params._reset_to_center = NO;
	[g set_zoom:drpt(g.get_zoom,1,1/20.0)];
	
	switch (_air_params._current_mode) {
		case PlayerAirCombatMode_InitialJumpOut:;
			_air_params._anim_ct = clampf(_air_params._anim_ct + 0.025 * dt_scale_get(), 0, 1);
			g.player.shared_params._s_pos = ccp(
				g.player.shared_params._s_pos.x,
				lerp(_initial_s_pos_y, _air_params.DEFAULT_HEIGHT,
					bezier_point_for_t(ccp(0,0), ccp(0,0.5), ccp(0.5,1), ccp(1,1), _air_params._anim_ct).y )
			);
			if (_air_params._anim_ct >= 1) {
				_air_params._current_mode = PlayerAirCombatMode_Combat;
			}
			[g set_zoom:drpt(g.get_zoom,1,1/20.0)];
		break;
		case PlayerAirCombatMode_Combat:;
			_air_params._w_upwards_vel *= powf(0.95, dt_scale_get());
			
			float arrow_variance_angle = lerp(15,0,clampf(_air_params._hold_ct/_air_params.ARROW_AIM_TIME,0,1));
			
			if (_air_params._dashing) {
				[g.player play_anim:@"Spin" repeat:YES];
				_air_params._dash_ct -= dt_scale_get();
				if (_air_params._dash_ct <= 0) {
					_air_params._dashing = NO;
				}
				
				if (!CGPointEqualToPoint(g.get_control_manager.get_post_swipe_drag, CGPointZero)) {
					float vel = CGPointDist(CGPointZero, _air_params._s_vel);
					Vec3D post_dir = vec_cons_norm(g.get_control_manager.get_post_swipe_drag.x, g.get_control_manager.get_post_swipe_drag.y, 0);
					Vec3D cur_dir = cgpoint_to_vec(_air_params._s_vel);
					Vec3D final_dir = vec_cons_norm(cur_dir.x+post_dir.x*2, cur_dir.y+post_dir.y*2, 0);
					vec_scale_m(&final_dir, vel);
					_air_params._s_vel = ccp(final_dir.x,final_dir.y);
				}
				
				if (_air_params._s_vel.y > 0) {
					_air_params._s_vel = ccp(
						_air_params._s_vel.x,
						_air_params._s_vel.y*powf(0.95, dt_scale_get()));
				}
				
				_air_params._s_vel = ccp(
					_air_params._s_vel.x*powf(0.9, dt_scale_get()),
					_air_params._s_vel.y - 0.05 * dt_scale_get());
				_air_params._hold_ct = 0;
				_air_params._target_rotation = 0;
				
			} else if (_air_params._sword_out) {
				_air_params._hold_ct = 0;
				_air_params._s_vel = ccp(0,-15);
				_air_params._hold_ct = 0;
				_air_params._target_rotation = 0;
				g.player.rotation = 0;
				[g.player play_anim:@"Sword Plant" repeat:YES];

			} else {
				if (g.get_control_manager.is_touch_down  && _air_params._arrows_left_ct > 0) {
					if (g.get_control_manager.this_touch_can_proc_tap) [g.get_event_dispatcher push_event:[[GEvent cons_context:g type:GEventType_PlayerAimVariance] set_float_value:arrow_variance_angle]];
					_air_params._hold_ct += dt_scale_get();
					
					CGPoint tap = g.get_control_manager.get_proc_tap;
					CGPoint delta = CGPointSub(tap, g.player.shared_params._s_pos);
					
					
					if (delta.x > 0) {
						g.player.img.scaleX = -ABS(g.player.img.scaleX);
						_air_params._target_rotation = vec_ang_deg_lim180(vec_cons(delta.x, delta.y, 0),180)+20;
						
					} else {
						g.player.img.scaleX = ABS(g.player.img.scaleX);
						_air_params._target_rotation = vec_ang_deg_lim180(vec_cons(delta.x, delta.y, 0),0)+20;
						
					}
					
				} else {
					_air_params._hold_ct = 0;
					_air_params._target_rotation = 0;
				}
				_air_params._arrow_last_fired_ct -= dt_scale_get();
				
				_air_params._s_vel = ccp(_air_params._s_vel.x*powf(0.9, dt_scale_get()),_air_params._s_vel.y - 0.05 * dt_scale_get());
				if (_air_params._s_vel.y > 0) {
					_air_params._s_vel = ccp(
						_air_params._s_vel.x,
						_air_params._s_vel.y*powf(0.95, dt_scale_get()));
				}
				if (g.get_control_manager.is_touch_down) {
					_air_params._s_vel = ccp(
						_air_params._s_vel.x,
						_air_params._s_vel.y*powf(0.8, dt_scale_get()));
				}
				
				if (_air_params._arrow_last_fired_ct <= 0) {
					if (g.get_control_manager.is_touch_down && g.get_control_manager.this_touch_can_proc_tap && _air_params._arrows_left_ct > 0) {
						[g.player play_anim:@"Bow Aim" repeat:NO];
					} else {
						[g.player play_anim:@"In Air Idle" repeat:YES];
					}
				}
			}
			if (!g.get_control_manager.this_touch_can_proc_tap) {
				[g.get_touch_tracking_layer hide_touch_hold_pulse];
			}
			
			[_arrow_restore_tick i_update:dt_scale_get()];
			if (_air_params._arrows_recharge_ct > 0) {
				_air_params._arrows_recharge_ct -= dt_scale_get();
			} else {
				if ([_arrow_restore_tick do_flash]) {
					_air_params._arrows_left_ct = MIN(_air_params._arrows_left_ct+1,_air_params.GET_MAX_ARROWS);
				}
			}
			[_arrow_restore_tick do_flash];
			
			if (g.get_control_manager.is_proc_tap && _air_params._arrows_left_ct > 0) {
				[g.player play_anim:@"Bow Fire" repeat:NO];
				_air_params._arrow_last_fired_ct = 20;
				_air_params._arrows_left_ct--;
				_air_params._arrows_recharge_ct = [_air_params GET_ARROWS_RECHARGE_TIME];
				CGPoint tap = g.get_control_manager.get_proc_tap;
				CGPoint delta = CGPointSub(tap, g.player.shared_params._s_pos);
				
				float rad_arrow_variance = ABS(deg_to_rad(arrow_variance_angle));
				
				if (arrow_variance_angle <= 0) {
					[g shake_for:10 distance:5];
					[g add_player_projectile:[ChargedArrow cons_pos:g.player.get_center dir:vec_rotate_rad(vec_cons_norm(delta.x, delta.y, 0), float_random(-rad_arrow_variance, rad_arrow_variance) )]];
				} else {
					[g add_player_projectile:[Arrow cons_pos:g.player.get_center dir:vec_rotate_rad(vec_cons_norm(delta.x, delta.y, 0), float_random(-rad_arrow_variance, rad_arrow_variance) )]];
				}
				
				_air_params._sword_out = NO;
				_air_params._dashing = NO;
				_air_params._dash_ct = 0;
				
				_air_params._s_vel = ccp(
					_air_params._s_vel.x,
					MAX(lerp(2.5, 0.15, clampf((g.player.shared_params._s_pos.y-100)/300,0,1)), _air_params._s_vel.y)
				);
				_air_params._w_upwards_vel = MAX(1,_air_params._w_upwards_vel);
			}
			
			if (g.get_control_manager.is_proc_swipe) {
				if (arrow_variance_angle <= 0) {
					_air_params._arrow_last_fired_ct = 20;
					CGPoint tap = g.get_control_manager.get_proc_tap;
					CGPoint delta = CGPointSub(tap, g.player.shared_params._s_pos);
					float rad_arrow_variance = 0;
					if (arrow_variance_angle <= 0) {
						[g shake_for:6 distance:3.5];
						[g add_player_projectile:[ChargedArrow cons_pos:g.player.position dir:vec_rotate_rad(vec_cons_norm(delta.x, delta.y, 0), float_random(-rad_arrow_variance, rad_arrow_variance) )]];
					}
				}
			
				Vec3D swipe_dir = g.get_control_manager.get_proc_swipe_dir;
				float angle = rad_to_deg(vec_ang_rad(swipe_dir));
				if (angle < -60 && angle > -120) {
					_air_params._sword_out = YES;
					_air_params._dashing = NO;
					_air_params._dash_ct = 0;
					
				} else {
					_air_params._sword_out = NO;
					_air_params._dashing = YES;
					_air_params._s_vel = vec_to_cgpoint(vec_scale(swipe_dir, 10));
					_air_params._dash_ct += 8;
				}
			}
			
			if (_air_params._invuln_ct > 0) {
				_air_params._invuln_ct -= dt_scale_get();
			}
			
			float s_pos_y = g.player.shared_params._s_pos.y+_air_params._s_vel.y*dt_scale_get();
			if (s_pos_y > _air_params.DEFAULT_HEIGHT) {
				s_pos_y = drpt(s_pos_y, _air_params.DEFAULT_HEIGHT, 1/12.0);
			}
			g.player.shared_params._s_pos = ccp(
				g.player.shared_params._s_pos.x+_air_params._s_vel.x*dt_scale_get(),
				s_pos_y
			);
			
			if (g.player.shared_params._s_pos.y < -50) {
				[g.player.shared_params add_health:-0.25 g:g];
				[g.get_event_dispatcher push_event:[GEvent cons_context:g type:GEventType_PlayerTakeDamage]];
				[g shake_for:10 distance:5];
				_air_params._w_upwards_vel = 0;
				_air_params._s_vel = CGPointZero;
				_air_params._sword_out = NO;
				_air_params._current_mode = PlayerAirCombatMode_RescueBackToTop;
				[g.player play_anim:@"In Air Idle" repeat:YES];
				
				if (g.player.shared_params.get_current_health > 0) {
					_rescue_anim = [ChainedMovementParticle cons];
					[_rescue_anim setTexture:[Resource get_tex:TEX_PARTICLES_SPRITESHEET]];
					[_rescue_anim setTextureRect:[FileCache get_cgrect_from_plist:TEX_PARTICLES_SPRITESHEET idname:@"grey_particle"]];
					(int_random(0, 2) < 1)?[_rescue_anim add_waypoint:game_screen_pct(0, float_random(0.5, 0.8)) speed:1]:[_rescue_anim add_waypoint:game_screen_pct(1, float_random(0.5, 0.8)) speed:1];
					[_rescue_anim add_playerx_waypoint:-40 speed:0.025];
					[_rescue_anim add_playerx_waypoint:_air_params.DEFAULT_HEIGHT speed:0.01];
					(int_random(0, 2) < 1)?[_rescue_anim add_waypoint:game_screen_pct(1, 1.5) speed:0.025]:[_rescue_anim add_waypoint:game_screen_pct(0, 1.5) speed:0.025];
					[_rescue_anim set_relative];
					[g add_particle:_rescue_anim];
				}
			}
			
		break;
		case PlayerAirCombatMode_RescueBackToTop:;
			if (_rescue_anim != NULL) {
				if (_rescue_anim.waypoints_left == 2) {
					if (_air_params.__rescue_last_waypoint_ct == 3) [g shake_for:5 distance:1];
					g.player.shared_params._s_pos = ccp(g.player.shared_params._s_pos.x,_rescue_anim.position.y-g.get_viewbox.y1-10);
				} else if (_rescue_anim.waypoints_left < 2) {
					_rescue_anim = NULL;
					[g shake_for:5 distance:1];
					_air_params._current_mode = PlayerAirCombatMode_Combat;
				}
				_air_params.__rescue_last_waypoint_ct = _rescue_anim.waypoints_left;
			}
		break;
		case PlayerAirCombatMode_FallToGround:;
			[g.get_ui fadeout:YES];
			[g.player play_anim:@"Fall" repeat:YES];
			_air_params._s_vel = ccp(_air_params._s_vel.x,_air_params._s_vel.y - 0.4 * dt_scale_get());
			_air_params._w_upwards_vel = 0;
			g.player.shared_params._s_pos = ccp(
				g.player.shared_params._s_pos.x,
				g.player.shared_params._s_pos.y+_air_params._s_vel.y*dt_scale_get()
			);
			
			if (g.get_ui.is_faded_out) {
				[g.get_air_enemy_manager remove_all_enemies:g];
				[g.player pop_state_stack:g];
				[g.player push_state_stack:[AirToGroundTransitionPlayerStateStack cons:g]];
				return;
			}
		break;
	}
	
	if (g.player.shared_params.get_current_health <= 0 && _air_params._current_mode != PlayerAirCombatMode_FallToGround) {
		_air_params._current_mode = PlayerAirCombatMode_FallToGround;
		[g blur_and_pulse];
	}
	
	[g.player update_accel_x_position:g];
	_air_params._w_camera_center += _air_params._w_upwards_vel * dt_scale_get();
	[g set_camera_height:_air_params._w_camera_center];
	[g.player apply_s_pos:g];
}

-(PlayerState)get_state {
	return PlayerState_InAir;
}

@end
