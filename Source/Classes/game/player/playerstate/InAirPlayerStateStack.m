//
//  InAirPlayerStateStack.m
//  hanokam
//
//  Created by spotco on 06/06/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "InAirPlayerStateStack.h"
#import "PlayerAirCombatParams.h"
#import "PlayerProjectile.h"
#import "AirEnemyManager.h"
#import "ChainedMovementParticle.h"
#import "AirToGroundTransitionPlayerStateStack.h"

#import "SwordSlashParticle.h"

@implementation InAirPlayerStateStack {
	PlayerAirCombatParams *_air_params;
	ChainedMovementParticle *_rescue_anim;
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
	return self;
}

-(void)on_state_end:(GameEngineScene *)game {
	_rescue_anim = NULL;
}

-(void)i_update:(GameEngineScene *)g {
	g.player.rotation = drp(g.player.rotation, 0, 10);
	g.player.shared_params._reset_to_center = NO;
	[g set_zoom:drp(g.get_zoom,1,20)];
	[g.player swordplant_streak_set_visible:NO];
	
	switch (_air_params._current_mode) {
		case PlayerAirCombatMode_InitialJumpOut:;
			_air_params._anim_ct = clampf(_air_params._anim_ct + 0.025 * dt_scale_get(), 0, 1);
			g.player.shared_params._s_pos = ccp(
				g.player.shared_params._s_pos.x,
				lerp(g.player.shared_params._s_pos.y, _air_params.DEFAULT_HEIGHT, _air_params._anim_ct)
			);
			if (_air_params._anim_ct >= 1) {
				_air_params._current_mode = PlayerAirCombatMode_Combat;
			}
			[g set_zoom:drp(g.get_zoom,1,20)];
		break;
		case PlayerAirCombatMode_Combat:;
			_air_params._w_upwards_vel *= powf(0.95, dt_scale_get());
			
			float arrow_variance_angle = lerp(10,0,clampf(_air_params._hold_ct/_air_params.ARROW_AIM_TIME,0,1));
			
			if (_air_params._dashing) {
				[g.player play_anim:@"dash" repeat:YES];
				_air_params._dash_ct -= dt_scale_get();
				if (_air_params._dash_ct <= 0) {
					_air_params._dashing = NO;
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
				
			} else if (_air_params._sword_out) {
				[g.player swordplant_streak_set_visible:YES];
				_air_params._hold_ct = 0;
				_air_params._s_vel = ccp(0,-15);
				_air_params._hold_ct = 0;
				[g.player play_anim:@"sword hold" repeat:YES];

			} else {
				if (g.get_control_manager.is_touch_down) {
					if (g.get_control_manager.this_touch_can_proc_tap) [g.get_ui hold_reticule_visible:arrow_variance_angle];
					_air_params._hold_ct += dt_scale_get();
				} else {
					_air_params._hold_ct = 0;
				}
				_air_params._arrow_last_fired_ct -= dt_scale_get();
				_air_params._s_vel = ccp(_air_params._s_vel.x*powf(0.9, dt_scale_get()),_air_params._s_vel.y - 0.05 * dt_scale_get());
				if (_air_params._s_vel.y > 0) {
					_air_params._s_vel = ccp(
						_air_params._s_vel.x,
						_air_params._s_vel.y*powf(0.95, dt_scale_get()));
				}
				
				if (_air_params._arrow_last_fired_ct <= 0) {
					if (g.get_control_manager.is_touch_down && g.get_control_manager.this_touch_can_proc_tap) {
						[g.player play_anim:@"bow aim" repeat:NO];
					} else {
						[g.player play_anim:@"in air" repeat:YES];
					}
				}
				
			}
			
			if (g.get_control_manager.is_proc_tap) {
				[g.player play_anim:@"bow fire" on_finish_anim:@"bow hold"];
				_air_params._arrow_last_fired_ct = 20;
				CGPoint tap = g.get_control_manager.get_proc_tap;
				CGPoint delta = CGPointSub(tap, g.player.shared_params._s_pos);
				
				float rad_arrow_variance = ABS(deg_to_rad(arrow_variance_angle));
				
				[g add_player_projectile:[Arrow cons_pos:g.player.position dir:vec_rotate_rad(vec_cons_norm(delta.x, delta.y, 0), float_random(-rad_arrow_variance, rad_arrow_variance) )]];
				
				_air_params._sword_out = NO;
				_air_params._dashing = NO;
				
				_air_params._s_vel = ccp(
					_air_params._s_vel.x,
					MAX(lerp(2.5, 0.15, clampf((g.player.shared_params._s_pos.y-100)/300,0,1)), _air_params._s_vel.y)
				);
				_air_params._w_upwards_vel = MAX(1,_air_params._w_upwards_vel);
				
				if (delta.x > 0) {
					g.player.img.scaleX = ABS(g.player.img.scaleX);
				} else {
					g.player.img.scaleX = -ABS(g.player.img.scaleX);
				}
			}
			
			if (g.get_control_manager.is_proc_swipe) {
				Vec3D swipe_dir = g.get_control_manager.get_proc_swipe_dir;
				float angle = rad_to_deg(vec_ang_rad(swipe_dir));
				if (angle < -60 && angle > -120) {
					_air_params._sword_out = YES;
					_air_params._dashing = NO;
					
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
			
			for (BaseAirEnemy *itr in g.get_air_enemy_manager.get_enemies) {
				if (itr.is_alive && SAT_polyowners_intersect(g.player, itr)) {
					if (_air_params._sword_out) {
						[g.player play_anim:@"spin" on_finish_anim:@"in air"];
						
						_air_params._w_upwards_vel = 4;
						_air_params._sword_out = NO;
						[itr hit_player_melee:g];
						
						_air_params._s_vel = ccp(_air_params._s_vel.x,10);
						_air_params._sword_out = NO;
						_air_params._dashing = YES;
						_air_params._dash_ct += 15;
						
					} else if (_air_params._dashing) {
						_air_params._dashing = YES;
						_air_params._dash_ct += 16;
						_air_params._w_upwards_vel = 2;
						[itr hit_player_melee:g];
						[g add_particle:[SwordSlashParticle cons_pos:itr.position dir:vec_cons_norm(_air_params._s_vel.x, _air_params._s_vel.y, 0)]];
						_air_params._invuln_ct = MAX(_air_params._invuln_ct,5);
						
					} else if (_air_params._invuln_ct <= 0) {
						if (!itr.is_stunned) {
							[g.player add_health:-0.5 g:g];
							[g.get_ui flash_red];
							[g.player play_anim:@"hurt air" on_finish_anim:@"in air"];
						}
						_air_params._s_vel = ccp(_air_params._s_vel.x,5);
						_air_params._w_upwards_vel = 4;
						_air_params._sword_out = NO;
						_air_params._invuln_ct = 30;
						[itr hit_projectile:g];
					}
					[g shake_for:10 distance:5];
					break;
				}
			}
			
			float s_pos_y = g.player.shared_params._s_pos.y+_air_params._s_vel.y*dt_scale_get();
			if (s_pos_y > _air_params.DEFAULT_HEIGHT) {
				s_pos_y = drp(s_pos_y, _air_params.DEFAULT_HEIGHT, 6.6);
			}
			g.player.shared_params._s_pos = ccp(
				g.player.shared_params._s_pos.x+_air_params._s_vel.x*dt_scale_get(),
				s_pos_y
			);
			
			if (g.player.shared_params._s_pos.y < -50) {
				[g.player add_health:-0.25 g:g];
				[g.get_ui flash_red];
				[g shake_for:10 distance:5];
				_air_params._w_upwards_vel = 0;
				_air_params._s_vel = CGPointZero;
				_air_params._sword_out = NO;
				_air_params._current_mode = PlayerAirCombatMode_RescueBackToTop;
				[g.player play_anim:@"in air" repeat:YES];
				
				if (g.player.get_current_health > 0) {
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
			[g.player play_anim:@"fall" repeat:YES];
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
				[g.player swordplant_streak_set_visible:NO];
				return;
			}
		break;
	}
	
	if (g.player.get_current_health <= 0 && _air_params._current_mode != PlayerAirCombatMode_FallToGround) {
		_air_params._current_mode = PlayerAirCombatMode_FallToGround;
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
